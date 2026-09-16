import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badges;

import '../l10n/app_localizations.dart';
import '../models/automezzo.dart';
import '../models/cantiere.dart';
import '../models/macchinario.dart';
import '../providers/automezzi_provider.dart';
import '../providers/cantieri_provider.dart';
import '../providers/macchinari_provider.dart';
import '../services/stampa_tabella.dart';
import '../services/stato_scadenze.dart';
import '../widgets/app_bar.dart';
import '../widgets/app_drawer.dart';
import '../widgets/campo_info.dart';
import '../widgets/confirm_dialog.dart';
import '../widgets/voce_info.dart';
import '../widgets/info_dialog.dart';
import '../widgets/macchinario_form_dialog.dart' show proprietaLabels, showMacchinarioFormDialog;
import '../widgets/nota_macchinario_dialog.dart';
import '../widgets/responsive_card_grid.dart';
import '../widgets/stato_badge.dart';

/// Completa una riga di campi (già filtrati con `if`) fino a [colonne] colonne,
/// così che i campi restino allineati tra righe diverse.
List<Widget> _rigaCampi(List<Widget> campi, {int colonne = 3}) {
  return [
    ...campi,
    for (var i = campi.length; i < colonne; i++) const Expanded(child: SizedBox()),
  ];
}

/// Dove si trova il macchinario in parole ("In cantiere X", "In [Automezzo]",
/// "In magazzino"), `null` se non è indicata nessuna ubicazione.
String? _ubicazione(
  Macchinario macchinario, {
  required List<Cantiere> cantieri,
  required List<Automezzo> automezzi,
  required AppLocalizations l10n,
}) {
  final nomeCantiere = macchinario.ubicazioneCantiereId.isNotEmpty
      ? cantieri
            .where((c) => c.id == macchinario.ubicazioneCantiereId)
            .map((c) => c.nome)
            .firstOrNull
      : null;
  if (nomeCantiere != null) return l10n.macchinariScreenLocationCantiere(nomeCantiere);
  final automezzo = macchinario.ubicazioneAutomezzoId.isNotEmpty
      ? automezzi
            .where((a) => a.id == macchinario.ubicazioneAutomezzoId)
            .firstOrNull
      : null;
  if (automezzo != null) return l10n.macchinariScreenLocationAutomezzo(automezzo.descrizioneConTarga);
  if (macchinario.inMagazzino) return l10n.macchinariScreenLocationMagazzino;
  return null;
}

/// Proprietà del macchinario con, se presente, il nome della società di
/// leasing/noleggio: nel PDF non ci sono colonne dedicate.
String _proprieta(Macchinario m, AppLocalizations l10n) {
  final etichetta = proprietaLabels(l10n)[m.proprieta] ?? m.proprieta;
  final societa = switch (m.proprieta) {
    'leasing' => m.nomeLeasing,
    'noleggio' => m.nomeNoleggio,
    _ => '',
  };
  return societa.isEmpty ? etichetta : '$etichetta - $societa';
}

List<String> _colonnePdf(AppLocalizations l10n) => [
  l10n.macchinariScreenFieldModello,
  l10n.macchinariScreenFieldTipologia,
  l10n.macchinariScreenFieldMatricola,
  l10n.macchinariScreenFieldFabbrica,
  l10n.macchinariScreenFieldAnno,
  l10n.macchinariScreenFieldProprieta,
  l10n.macchinariScreenFieldUbicazione,
  l10n.macchinariScreenFieldCivaInail,
  l10n.macchinariScreenFieldScadAssicurazione,
  l10n.macchinariScreenFieldScadManutenzione,
  l10n.macchinariScreenFieldScadFuniCatene,
  l10n.macchinariScreenFieldVerificaAnnuale,
  l10n.macchinariScreenFieldVerificaVentennale,
  l10n.commonNoteLabel,
];

List<List<CellaPdf>> _righePdf(
  List<Macchinario> macchinari, {
  required List<Cantiere> cantieri,
  required List<Automezzo> automezzi,
  required AppLocalizations l10n,
}) {
  return macchinari.map((m) {
    return [
      CellaPdf(m.modello, grassetto: true),
      CellaPdf(tipologieMacchinario[m.tipologia] ?? m.tipologia),
      CellaPdf(m.numeroMatricola),
      CellaPdf(m.numeroFabbrica),
      CellaPdf(m.annoAcquisto == 0 ? '' : m.annoAcquisto.toString()),
      CellaPdf(_proprieta(m, l10n)),
      CellaPdf(_ubicazione(m, cantieri: cantieri, automezzi: automezzi, l10n: l10n) ?? ''),
      CellaPdf(m.presenteInCivaInail ? l10n.commonYes : l10n.commonNo),
      cellaScadenza(m.scadenzaAssicurazione),
      cellaScadenza(m.scadenzaManutenzioneInterna),
      cellaScadenza(m.scadenzaControlloFuniCatene),
      cellaScadenza(m.scadenzaVerificaAnnuale),
      cellaScadenza(m.scadenzaVerificaVentennale),
      CellaPdf(m.note),
    ];
  }).toList();
}

typedef _VoceScadenza = ({
  Macchinario macchinario,
  String tipo,
  DateTime scadenza,
  StatoScadenza stato,
});

/// Una voce per ogni scadenza (non per macchinario) in scadenza o scaduta,
/// per la sezione "Scadenze imminenti" in cima alla pagina.
///
/// Nota: le chiavi qui sotto ("Manutenzione annuale", ecc.) sono usate anche
/// come chiave di lookup in `macchinario.noteScadenze`, quindi restano in
/// italiano indipendentemente dalla lingua dell'interfaccia: tradurle
/// romperebbe l'associazione con le note già salvate.
List<_VoceScadenza> _vociScadenza(List<Macchinario> macchinari) {
  final voci = <_VoceScadenza>[];
  for (final m in macchinari) {
    final campi = {
      'Manutenzione annuale': m.scadenzaManutenzioneInterna,
      'Controllo funi/catene': m.scadenzaControlloFuniCatene,
      'Verifica annuale': m.scadenzaVerificaAnnuale,
      'Verifica ventennale': m.scadenzaVerificaVentennale,
      'Scadenza Assicurazione': m.scadenzaAssicurazione,
    };
    for (final entry in campi.entries) {
      final data = parseData(entry.value);
      if (data == null) continue;
      final stato = computeStato(data);
      if (stato == StatoScadenza.valido) continue;
      voci.add((macchinario: m, tipo: entry.key, scadenza: data, stato: stato));
    }
  }
  voci.sort((a, b) => a.scadenza.compareTo(b.scadenza));
  return voci;
}

class MacchinariScreen extends StatefulWidget {
  const MacchinariScreen({super.key});

  @override
  State<MacchinariScreen> createState() => _MacchinariScreenState();
}

class _MacchinariScreenState extends State<MacchinariScreen> {
  final _searchController = TextEditingController();
  String _query = '';
  bool _loaded = false;
  final _espanse = <String>{};
  bool _scadenzeImminentiEspanse = false;
  bool _macchinariEspansi = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_loaded) {
      _loaded = true;
      final cantieriProvider = context.read<CantieriProvider>();
      final macchinariProvider = context.read<MacchinariProvider>();
      final automezziProvider = context.read<AutomezziProvider>();
      Future.microtask(() {
        cantieriProvider.load();
        macchinariProvider.load();
        automezziProvider.load();
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Apre la finestra di stampa del browser con l'elenco (già filtrato dalla
  /// ricerca) impaginato come una tabella Excel: da lì si può stampare oppure
  /// salvare in PDF.
  Future<void> _stampa({
    required List<Macchinario> macchinari,
    required List<Cantiere> cantieri,
    required List<Automezzo> automezzi,
  }) async {
    final l10n = AppLocalizations.of(context)!;
    final ordinati = [...macchinari]
      ..sort((a, b) => a.modello.toLowerCase().compareTo(b.modello.toLowerCase()));
    final filtro = _query.trim();
    try {
      await stampaTabellaPdf(
        titolo: l10n.macchinariScreenTitle,
        sottotitolo: [
          l10n.macchinariScreenPrintSubtitleCount(ordinati.length),
          if (filtro.isNotEmpty) l10n.macchinariScreenPrintSubtitleFilter(filtro),
        ].join(' - '),
        colonne: _colonnePdf(l10n),
        righe: _righePdf(ordinati, cantieri: cantieri, automezzi: automezzi, l10n: l10n),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.macchinariScreenPrintError(e.toString()))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final primaryBlue = Theme.of(context).colorScheme.primary;
    final cantieriProvider = context.watch<CantieriProvider>();
    final macchinariProvider = context.watch<MacchinariProvider>();
    final automezziProvider = context.watch<AutomezziProvider>();
    final erroreCaricamento =
        cantieriProvider.errorMessage ??
        macchinariProvider.errorMessage ??
        automezziProvider.errorMessage;

    final query = _query.trim().toLowerCase();
    final macchinariFiltrati = macchinariProvider.macchinari
        .where((m) => query.isEmpty ||
                      m.modello.toLowerCase().contains(query) ||
                      m.tipologia.toLowerCase().contains(query))
        .toList();
    final scadenzeImminenti = _vociScadenza(macchinariProvider.macchinari);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: l10n.macchinariScreenTitle,
        actions: [
          AppBarAction(
            icon: Icons.add,
            label: l10n.macchinariScreenNewButton,
            onPressed: () => showMacchinarioFormDialog(
              context,
              provider: macchinariProvider,
              cantieri: cantieriProvider.cantieri,
              automezzi: automezziProvider.automezzi,
            ),
          ),
        ],
        iconActions: [
          AppBarAction(
            icon: Icons.print_outlined,
            label: l10n.macchinariScreenPrintButton,
            onPressed: () => _stampa(
              macchinari: macchinariFiltrati,
              cantieri: cantieriProvider.cantieri,
              automezzi: automezziProvider.automezzi,
            )
          ),
        ]
      ),
      drawer: const AppDrawer(current: 'Macchinari'),
      body:
          macchinariProvider.isLoading && macchinariProvider.macchinari.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async {
                await cantieriProvider.load();
                await macchinariProvider.load();
                await automezziProvider.load();
              },
              child: ListView(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
                children: [
                  const SizedBox(height: 15),
                  if (erroreCaricamento != null) ...[
                    Card(
                      color: Theme.of(context).colorScheme.errorContainer,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            const Icon(Icons.error_outline),
                            const SizedBox(width: 8),
                            Expanded(child: Text(erroreCaricamento)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  if (scadenzeImminenti.isNotEmpty) ...[
                    Row(
                      children: [
                        badges.Badge(
                          badgeContent: Text(
                            '${scadenzeImminenti.length}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          badgeStyle: badges.BadgeStyle(badgeColor: Colors.black),
                          position: badges.BadgePosition.topEnd(top: -10, end: -25),
                          child: Text(
                            l10n.macchinariScreenUpcomingDeadlines,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 22,
                            ),
                          ),
                        ),
                        const SizedBox(width: 25),
                        IconButton(
                          onPressed: () => showNoteScadenzaInfoDialog(context),
                          icon: Icon(Icons.info_outline, size: 20, color: Colors.black),
                        ),
                        IconButton(
                          tooltip: _scadenzeImminentiEspanse
                              ? l10n.macchinariScreenHideDeadlinesTooltip
                              : l10n.macchinariScreenShowDeadlinesTooltip,
                          onPressed: () => setState(
                            () => _scadenzeImminentiEspanse = !_scadenzeImminentiEspanse,
                          ),
                          icon: Icon(
                            _scadenzeImminentiEspanse ? Icons.unfold_less_outlined : Icons.unfold_more_outlined,
                            color: Colors.black,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    AnimatedSize(
                      duration: const Duration(milliseconds: 400),
                      alignment: Alignment.topCenter,
                      child: !_scadenzeImminentiEspanse
                          ? const SizedBox(width: double.infinity)
                          : _ScadenzeImminenti(
                              voci: scadenzeImminenti,
                              provider: macchinariProvider,
                              cantieri: cantieriProvider.cantieri,
                              automezzi: automezziProvider.automezzi,
                            ),
                    ),
                    const SizedBox(height: 24),
                  ],
                  Row(
                    children: [
                      Text(
                        l10n.macchinariScreenTitle,
                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 22, color: primaryBlue),
                      ),
                      IconButton(
                        tooltip: _macchinariEspansi
                            ? l10n.macchinariScreenCollapseAllTooltip
                            : l10n.macchinariScreenExpandAllTooltip,
                        onPressed: () {
                          setState(() {
                            _macchinariEspansi = !_macchinariEspansi;
                            if (_macchinariEspansi) {
                              _espanse.addAll(
                                macchinariProvider.macchinari.map((m) => m.id),
                              );
                            } else {
                              _espanse.clear();
                            }
                          });
                        },
                        icon: Icon(
                          _macchinariEspansi ? Icons.unfold_less_outlined : Icons.unfold_more_outlined,
                          color: primaryBlue, size: 20
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: Icon(Icons.search, color: primaryBlue),
                      hintText: l10n.macchinariScreenSearchHint,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(
                          color: Colors.black54,
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: primaryBlue, width: 2),
                      ),
                    ),
                    onChanged: (v) => setState(() => _query = v),
                  ),
                  const SizedBox(height: 20),
                  if (macchinariFiltrati.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Center(
                        child: Text(
                          macchinariProvider.macchinari.isEmpty
                              ? l10n.macchinariScreenEmptyLoaded
                              : l10n.macchinariScreenEmptySearch(_query.trim()),
                        ),
                      ),
                    )
                  else
                    ColumnsCardGrid(
                      maxColumns: 2,
                      minWidth: 380,
                      children: macchinariFiltrati.map((macchinario) {
                        final espansa = _espanse.contains(macchinario.id);
                        return _MacchinarioCard(
                          macchinario: macchinario,
                          macchinari: macchinariProvider.macchinari,
                          provider: macchinariProvider,
                          espansa: espansa,
                          onToggleEspansa: () => setState(() {
                            if (espansa) {
                              _espanse.remove(macchinario.id);
                            } else {
                              _espanse.add(macchinario.id);
                            }
                          })
                        );
                      }).toList(),
                    ),
                ],
              ),
            ),
    );
  }
}

class _ScadenzeImminenti extends StatelessWidget {
  const _ScadenzeImminenti({
    required this.voci,
    required this.provider,
    required this.cantieri,
    required this.automezzi,
  });

  final List<_VoceScadenza> voci;
  final MacchinariProvider provider;
  final List<Cantiere> cantieri;
  final List<Automezzo> automezzi;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isMobile = MediaQuery.sizeOf(context).width < kMobileAppBarBreakpoint;
    final primaryBlue = Theme.of(context).colorScheme.primary;
    final elenco = voci.take(10).toList();
    return Card(
      child: Column(
        children: [
          for (var i = 0; i < elenco.length; i++) ...[
            if (i > 0) const Divider(height: 1, color: Color(0xFFE0E0E0)),
            Builder(
              builder: (context) {
                final voce = elenco[i];
                final notaScadenza =
                    voce.macchinario.noteScadenze[voce.tipo] ?? '';
                return ListTile(
                  leading: StatoBadge(stato: voce.stato, showLabel: !isMobile),
                  title: Text(voce.tipo, style: const TextStyle(fontWeight: FontWeight.w700)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      VoceInfo(l10n.macchinariScreenFieldModello, voce.macchinario.modello),
                      if (voce.macchinario.note != '') VoceInfo(l10n.commonNoteLabel, voce.macchinario.note),
                      if (notaScadenza.isNotEmpty) VoceInfo(l10n.macchinariScreenFieldNotaScadenza, notaScadenza)
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit_note_rounded, color: primaryBlue, size: isMobile ? 18 : 22),
                        tooltip: l10n.macchinariScreenEditNoteTooltip,
                        onPressed: () => showNotaMacchinarioDialog(
                          context,
                          provider: provider,
                          macchinario: voce.macchinario,
                          tipo: voce.tipo,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        '${voce.scadenza.day.toString().padLeft(2, '0')}/'
                        '${voce.scadenza.month.toString().padLeft(2, '0')}/'
                        '${voce.scadenza.year}',
                      ),
                    ],
                  ),
                  onTap: () => showMacchinarioFormDialog(
                    context,
                    provider: provider,
                    cantieri: cantieri,
                    automezzi: automezzi,
                    esistente: voce.macchinario,
                  ),
                );
              },
            ),
          ],
        ],
      ),
    );
  }
}

class _MacchinarioCard extends StatelessWidget{
  const _MacchinarioCard({
    required this.macchinario,
    required this.macchinari,
    required this.provider,
    required this.espansa,
    required this.onToggleEspansa,
  });

  final Macchinario macchinario;
  final List<Macchinario> macchinari;
  final MacchinariProvider provider;
  final bool espansa;
  final VoidCallback onToggleEspansa;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final primaryBlue = Theme.of(context).colorScheme.primary;
    final isMobile = MediaQuery.sizeOf(context).width < kMobileAppBarBreakpoint;
    final automezziProvider = context.watch<AutomezziProvider>();
    final macchinariProvider = context.watch<MacchinariProvider>();
    final cantieriProvider = context.watch<CantieriProvider>();
    final stato = statoScadenzaMacchinario(macchinario);

    final ubicazione = _ubicazione(
      macchinario,
      cantieri: cantieriProvider.cantieri,
      automezzi: automezziProvider.automezzi,
      l10n: l10n,
    );
    final tipologia =
        tipologieMacchinario[macchinario.tipologia] ??
        macchinario.tipologia;


    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: StatoBadge(
              stato: stato,
              showLabel: false,
            ),
            title: Text(macchinario.modello, style: const TextStyle(fontWeight: FontWeight.w700)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                VoceInfo(l10n.macchinariScreenFieldTipologia, tipologia),
                VoceInfo(l10n.macchinariScreenFieldUbicazione, ubicazione ?? l10n.macchinariScreenLocationUnspecified),
                if (macchinario.note != '') VoceInfo(l10n.commonNoteLabel, macchinario.note)
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit_outlined, color: primaryBlue, size: isMobile ? 18 : 22),
                  tooltip: l10n.macchinariScreenEditTooltip,
                  onPressed: () => showMacchinarioFormDialog(
                    context,
                    provider: macchinariProvider,
                    cantieri: cantieriProvider.cantieri,
                    automezzi: automezziProvider.automezzi,
                    esistente: macchinario,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.delete_outline, color: primaryBlue, size: isMobile ? 18 : 22),
                  tooltip: l10n.macchinariScreenDeleteTooltip,
                  onPressed: () async {
                    final confermato = await showConfirmDialog(
                      context,
                      title: l10n.macchinariScreenDeleteConfirmTitle,
                      message: l10n.macchinariScreenDeleteConfirmMessage(macchinario.modello),
                    );
                    if (confermato) {
                      await macchinariProvider.delete(
                        macchinario.id,
                      );
                    }
                  },
                ),
                IconButton(
                  tooltip: espansa ? l10n.macchinariScreenHideInfoTooltip : l10n.macchinariScreenShowInfoTooltip,
                  onPressed: onToggleEspansa,
                  icon: Icon(
                    espansa ? Icons.keyboard_arrow_up_outlined : Icons.keyboard_arrow_down_outlined,
                    color: primaryBlue,
                    size: isMobile ? 18 : 22,
                  ),
                ),
              ],
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 400),
            alignment: Alignment.topCenter,
            child: !espansa
                ? const SizedBox(width: double.infinity)
                : Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Divider(height: 1, color: Color(0xFFE0E0E0)),
                        const SizedBox(height: 12),
                        Text(l10n.macchinariScreenSectionGeneralData, style: TextStyle(fontWeight: FontWeight.w600, color: primaryBlue, fontSize: 15)),
                        const SizedBox(height: 8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: _rigaCampi([
                            if (macchinario.numeroMatricola != '') campoInfo(l10n.macchinariScreenFieldMatricola, macchinario.numeroMatricola),
                            if (macchinario.numeroFabbrica != '') campoInfo(l10n.macchinariScreenFieldFabbrica, macchinario.numeroFabbrica),
                            if (macchinario.annoAcquisto != 0) campoInfo(l10n.macchinariScreenFieldAnnoAcquisto, macchinario.annoAcquisto.toString()),
                          ]),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                          campoInfo(l10n.macchinariScreenFieldProprieta, proprietaLabels(l10n)[macchinario.proprieta] ?? macchinario.proprieta),
                          campoInfo(l10n.macchinariScreenFieldUbicazione, (ubicazione != null) ? ubicazione : ''),
                          campoInfo(l10n.macchinariScreenFieldPresenteCivaInail, macchinario.presenteInCivaInail ? l10n.commonYes : l10n.commonNo)
                          ],
                        ),
                        if (macchinario.proprieta == 'leasing') ... [
                          const SizedBox(height: 8),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: _rigaCampi([
                              campoInfo(l10n.macchinariScreenFieldLeasingCompany, macchinario.nomeLeasing),
                              campoScadenza(l10n.macchinariScreenFieldLeasingExpiry, macchinario.scadenzaLeasing),
                              if (macchinario.note != '') campoInfo(l10n.commonNoteLabel, macchinario.note),
                            ]),
                          ),
                        ],
                        if (macchinario.proprieta == 'noleggio') ... [
                          const SizedBox(height: 8),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: _rigaCampi([
                              campoInfo(l10n.macchinariScreenFieldRentalCompany, macchinario.nomeNoleggio),
                              campoInfo(l10n.macchinariScreenFieldEmail, macchinario.emailNoleggio),
                              if (macchinario.note != '') campoInfo(l10n.commonNoteLabel, macchinario.note),
                            ]),
                          ),
                        ],
                        if (macchinario.scadenzaAssicurazione != '') ... [
                          const SizedBox(height: 12),
                          Text(l10n.macchinariScreenSectionInsurance, style: TextStyle(fontWeight: FontWeight.w600, color: primaryBlue, fontSize: 15)),
                          const SizedBox(height: 8),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: _rigaCampi([
                            campoInfo(l10n.macchinariScreenFieldInsuranceCompany, macchinario.nomeAssicurazione),
                            campoScadenza(l10n.macchinariScreenFieldInsuranceExpiry, macchinario.scadenzaAssicurazione),
                            ]),
                          ),
                        ],
                        if (macchinario.scadenzaManutenzioneInterna != '') ... [
                          const SizedBox(height: 12),
                          Text(l10n.macchinariScreenSectionInternalMaintenance, style: TextStyle(fontWeight: FontWeight.w600, color: primaryBlue, fontSize: 15)),
                          const SizedBox(height: 8),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: _rigaCampi([
                            campoInfo(l10n.macchinariScreenFieldInterventionDate, formatData(macchinario.dataManutenzioneInterna)),
                            campoScadenza(l10n.macchinariScreenFieldExpiry, macchinario.scadenzaManutenzioneInterna),
                            ]),
                          ),
                        ],
                        if (macchinario.scadenzaControlloFuniCatene != '') ... [
                          const SizedBox(height: 12),
                          Text(l10n.macchinariScreenSectionRopesChainsControl, style: TextStyle(fontWeight: FontWeight.w600, color: primaryBlue, fontSize: 15)),
                          const SizedBox(height: 8),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: _rigaCampi([
                            campoInfo(l10n.macchinariScreenFieldLastControlDate, formatData(macchinario.dataControlloFuniCatene)),
                            campoScadenza(l10n.macchinariScreenFieldExpiry, macchinario.scadenzaControlloFuniCatene),
                            ]),
                          ),
                        ],
                        if (macchinario.scadenzaVerificaAnnuale != '') ... [
                          const SizedBox(height: 12),
                          Text(l10n.macchinariScreenFieldVerificaAnnuale, style: TextStyle(fontWeight: FontWeight.w600, color: primaryBlue, fontSize: 15)),
                          const SizedBox(height: 8),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: _rigaCampi([
                            campoInfo(l10n.macchinariScreenFieldVerificationDate, formatData(macchinario.dataVerificaAnnuale)),
                            campoScadenza(l10n.macchinariScreenFieldExpiry, macchinario.scadenzaVerificaAnnuale),
                            ]),
                          ),
                        ],
                        if (macchinario.scadenzaVerificaVentennale != '') ... [
                          const SizedBox(height: 12),
                          Text(l10n.macchinariScreenFieldVerificaVentennale, style: TextStyle(fontWeight: FontWeight.w600, color: primaryBlue, fontSize: 15)),
                          const SizedBox(height: 8),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: _rigaCampi([
                            campoInfo(l10n.macchinariScreenFieldVerificationDate, formatData(macchinario.dataVerificaVentennale)),
                            campoScadenza(l10n.macchinariScreenFieldExpiry, macchinario.scadenzaVerificaVentennale),
                            ]),
                          ),
                        ],
                      ]
                    ),
                  )
          )
        ],
      )
    );
  }
}
