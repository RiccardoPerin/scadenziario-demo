import 'package:flutter/material.dart';
import 'package:gestionale_edile/services/stampa_tabella.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badges;

import '../l10n/app_localizations.dart';
import '../widgets/app_bar.dart';
import '../widgets/app_drawer.dart';
import '../widgets/automezzo_form_dialog.dart' show proprieta, categorie, showAutomezzoFormDialog;
import '../widgets/campo_info.dart';
import '../widgets/nota_automezzo_dialog.dart';
import '../widgets/responsive_card_grid.dart';
import '../widgets/stato_badge.dart';
import '../widgets/confirm_dialog.dart';
import '../widgets/info_dialog.dart';
import '../widgets/voce_info.dart';
import '../services/stato_scadenze.dart';
import '../models/automezzo.dart';
import '../providers/automezzi_provider.dart';

/// Completa una riga di campi (già filtrati con `if`) fino a [colonne] colonne,
/// così che i campi restino allineati tra righe diverse.
List<Widget> _rigaCampi(List<Widget> campi, {int colonne = 3}) {
  return [
    ...campi,
    for (var i = campi.length; i < colonne; i++) const Expanded(child: SizedBox()),
  ];
}

String _proprieta(Automezzo a) => proprieta[a.proprieta] ?? a.proprieta;

String _categoria(Automezzo a) => categorie[a.catEuro] ?? a.catEuro;

List<String> _colonnePdf(AppLocalizations l10n) => [
  l10n.automezziScreenFieldNome,
  l10n.automezziScreenFieldTarga,
  l10n.automezziScreenFieldCategoria,
  l10n.automezziScreenFieldTelepass,
  l10n.automezziScreenFieldProprieta,
  l10n.automezziScreenFieldCompAssicurazione,
  l10n.automezziScreenFieldScadAssicurazione,
  l10n.automezziScreenFieldScadBollo,
  l10n.automezziScreenFieldScadRevisione,
  l10n.automezziScreenFieldScadTachigrafo,
  l10n.commonNoteLabel,
];

List<List<CellaPdf>> _righePdf({
  required List<Automezzo> automezzi,
}) {
  return automezzi.map((a) {
    return [
      CellaPdf(a.nome, grassetto: true),
      CellaPdf(a.targa),
      CellaPdf(_categoria(a)),
      CellaPdf(a.telepass),
      CellaPdf(_proprieta(a)),
      CellaPdf(a.compAssicurazione),
      cellaScadenza(a.scadenzaAssicurazione),
      cellaScadenza(a.scadenzaBollo),
      cellaScadenza(a.scadenzaRevisione),
      cellaScadenza(a.scadenzaControlloTachigrafo),
      CellaPdf(a.note),
    ];
  }).toList();
}

typedef _VoceScadenza = ({
  Automezzo automezzo,
  String tipo,
  DateTime scadenza,
  StatoScadenza stato,
});

/// Una voce per ogni scadenza (non per macchinario) in scadenza o scaduta,
/// per la sezione "Scadenze imminenti" in cima alla pagina.
///
/// Nota: le chiavi qui sotto sono usate anche come chiave di lookup in
/// `automezzo.noteScadenze`, quindi restano in italiano indipendentemente
/// dalla lingua dell'interfaccia: tradurle romperebbe l'associazione con le
/// note già salvate.
List<_VoceScadenza> _vociScadenza(List<Automezzo> automezzi) {
  final voci = <_VoceScadenza>[];
  for (final a in automezzi) {
    final campi = {
      'Scadenza Assicurazione': a.scadenzaAssicurazione,
      'Scadenza Noleggio/Leasing': a.scadenzaNoleggioLeasing,
      'Scadenza Bollo': a.scadenzaBollo,
      'Scadenza Revisione': a.scadenzaRevisione,
      'Scadenza Tachigrafo': a.scadenzaControlloTachigrafo,
    };
    for (final entry in campi.entries) {
      final data = parseData(entry.value);
      if (data == null) continue;
      final stato = computeStato(data);
      if (stato == StatoScadenza.valido) continue;
      voci.add((automezzo: a, tipo: entry.key, scadenza: data, stato: stato));
    }
  }
  voci.sort((a, b) => a.scadenza.compareTo(b.scadenza));
  return voci;
}

class AutomezziScreen extends StatefulWidget {
  const AutomezziScreen({super.key});

  @override
  State<AutomezziScreen> createState() => _AutomezziScreenState();
}

class _AutomezziScreenState extends State<AutomezziScreen> {
  final _searchController = TextEditingController();
  String _query = '';
  bool _loaded = false;
  final _espanse = <String>{};
  bool _scadenzeImminentiEspanse = false;
  bool _automezziEspansi = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_loaded) {
      final automezziProvider = context.read<AutomezziProvider>();
      _loaded = true;
      Future.microtask(() => automezziProvider.load());
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
    required List<Automezzo> automezzi,
  }) async {
    final l10n = AppLocalizations.of(context)!;
    final ordinati = [...automezzi]
      ..sort((a, b) => a.targa.toLowerCase().compareTo(b.targa.toLowerCase()));
    final filtro = _query.trim();
    try {
      await stampaTabellaPdf(
        titolo: l10n.automezziScreenTitle,
        sottotitolo: [
          l10n.automezziScreenPrintSubtitleCount(ordinati.length),
          if (filtro.isNotEmpty) l10n.automezziScreenPrintSubtitleFilter(filtro),
        ].join(' - '),
        colonne: _colonnePdf(l10n),
        righe: _righePdf(automezzi: ordinati),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.automezziScreenPrintError(e.toString()))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final primaryBlue = Theme.of(context).colorScheme.primary;
    final automezziProvider = context.watch<AutomezziProvider>();
    final erroreCaricamento = automezziProvider.errorMessage;

    final query = _query.trim().toLowerCase();
    final automezziFiltrati = automezziProvider.automezzi
        .where(
          (a) =>
              query.isEmpty ||
              a.targa.toLowerCase().contains(query) ||
              a.nome.toLowerCase().contains(query),
        )
        .toList();
    final scadenzeImminenti = _vociScadenza(automezziProvider.automezzi);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: l10n.automezziScreenTitle,
        actions: [
          AppBarAction(
            icon: Icons.add,
            label: l10n.automezziScreenNewButton,
            onPressed: () => showAutomezzoFormDialog(
              context,
              provider: automezziProvider,
              automezzi: automezziProvider.automezzi,
            ),
          ),
        ],
        iconActions: [
          AppBarAction(
            icon: Icons.print_outlined,
            label: l10n.automezziScreenPrintButton,
            onPressed: () => _stampa(
              automezzi: automezziProvider.automezzi
            )
          ),
        ]
      ),
      drawer: const AppDrawer(current: 'Automezzi'),
      body: automezziProvider.isLoading && automezziProvider.automezzi.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async {
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
                            l10n.automezziScreenUpcomingDeadlines,
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
                              ? l10n.automezziScreenHideDeadlinesTooltip
                              : l10n.automezziScreenShowDeadlinesTooltip,
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
                              provider: automezziProvider,
                              automezzi: automezziProvider.automezzi,
                            ),
                    ),
                    const SizedBox(height: 24),
                  ],
                  Row(
                    children: [
                      Text(
                        l10n.automezziScreenTitle,
                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 22, color: primaryBlue),
                      ),
                      IconButton(
                        tooltip: _automezziEspansi
                            ? l10n.automezziScreenCollapseAllTooltip
                            : l10n.automezziScreenExpandAllTooltip,
                        icon: Icon(
                          _automezziEspansi ? Icons.unfold_less_outlined : Icons.unfold_more_outlined,
                          size: 20, color: primaryBlue
                        ),
                        onPressed: () {
                          _automezziEspansi = !_automezziEspansi;
                          setState(() {
                            if (_automezziEspansi) {
                              _espanse.addAll(
                                automezziProvider.automezzi.map((a) => a.id)
                                );
                            }
                            else {
                              _espanse.clear();
                            }
                          });
                        }
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
                      hintText: l10n.automezziScreenSearchHint,
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
                  if (automezziFiltrati.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Center(
                        child: Text(
                          automezziProvider.automezzi.isEmpty
                              ? l10n.automezziScreenEmptyLoaded
                              : l10n.automezziScreenEmptySearch(_query.trim()),
                        ),
                      ),
                    )
                  else
                    ColumnsCardGrid(
                      maxColumns: 2,
                      minWidth: 380,
                      children: automezziFiltrati.map((automezzo) {
                        final espansa = _espanse.contains(automezzo.id);
                        return _AutomezzoCard(
                          automezzo: automezzo,
                          automezzi: automezziProvider.automezzi,
                          provider: automezziProvider,
                          espansa: espansa,
                          onToggleEspansa: () => setState(() {
                            if (espansa) {
                              _espanse.remove(automezzo.id);
                            } else {
                              _espanse.add(automezzo.id);
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
    required this.automezzi,
  });

  final List<_VoceScadenza> voci;
  final AutomezziProvider provider;
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
                    voce.automezzo.noteScadenze[voce.tipo] ?? '';
                return ListTile(
                  leading: StatoBadge(stato: voce.stato, showLabel: !isMobile),
                  title: Text(voce.tipo, style: const TextStyle(fontWeight: FontWeight.w700)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      VoceInfo(l10n.automezziScreenFieldVeicolo, voce.automezzo.nome),
                      VoceInfo(l10n.automezziScreenFieldTarga, voce.automezzo.targa),
                      if (notaScadenza.isNotEmpty) VoceInfo(l10n.automezziScreenFieldNotaScadenza, notaScadenza),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit_note_rounded, color: primaryBlue, size: isMobile ? 18 : 22),
                        tooltip: l10n.automezziScreenEditNoteTooltip,
                        onPressed: () => showNotaAutomezzoDialog(
                          context,
                          provider: provider,
                          automezzo: voce.automezzo,
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
                  onTap: () => showAutomezzoFormDialog(
                    context,
                    provider: provider,
                    automezzi: automezzi,
                    esistente: voce.automezzo,
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

class _AutomezzoCard extends StatelessWidget{
  const _AutomezzoCard({
    required this.automezzo,
    required this.automezzi,
    required this.provider,
    required this.espansa,
    required this.onToggleEspansa,
  });

  final Automezzo automezzo;
  final List<Automezzo> automezzi;
  final AutomezziProvider provider;
  final bool espansa;
  final VoidCallback onToggleEspansa;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final primaryBlue = Theme.of(context).colorScheme.primary;
    final isMobile = MediaQuery.sizeOf(context).width < kMobileAppBarBreakpoint;
    final automezziProvider = context.watch<AutomezziProvider>();
    final stato = statoScadenzaAutomezzo(automezzo);

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: StatoBadge(
              stato: stato,
              showLabel: false,
            ),
            title: Text('${automezzo.nome} ${automezzo.targa}', style: const TextStyle(fontWeight: FontWeight.w700)),
            subtitle: automezzo.note != ''
                ? VoceInfo(l10n.commonNoteLabel, automezzo.note)
                : null,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit_outlined, color: primaryBlue, size: isMobile ? 18 : 22),
                  tooltip: l10n.automezziScreenEditTooltip,
                  onPressed: () => showAutomezzoFormDialog(
                    context,
                    provider: automezziProvider,
                    automezzi: automezziProvider.automezzi,
                    esistente: automezzo,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.delete_outline, color: primaryBlue, size: isMobile ? 18 : 22),
                  tooltip: l10n.automezziScreenDeleteTooltip,
                  onPressed: () async {
                    final confermato = await showConfirmDialog(
                      context,
                      title: l10n.automezziScreenDeleteConfirmTitle,
                      message: l10n.automezziScreenDeleteConfirmMessage(automezzo.nome),
                    );
                    if (confermato) {
                      await automezziProvider.delete(
                        automezzo.id,
                      );
                    }
                  },
                ),
                IconButton(
                  tooltip: espansa ? l10n.automezziScreenHideInfoTooltip : l10n.automezziScreenShowInfoTooltip,
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
                        Text(l10n.automezziScreenSectionGeneralData, style: TextStyle(fontWeight: FontWeight.w600, color: primaryBlue, fontSize: 15)),
                        const SizedBox(height: 8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: _rigaCampi([
                            if (automezzo.catEuro != '') campoInfo(l10n.automezziScreenFieldCategoriaEuro, categorie[automezzo.catEuro] ?? automezzo.catEuro),
                            if (automezzo.telepass != '') campoInfo(l10n.automezziScreenFieldTelepass, automezzo.telepass),
                            if (automezzo.proprieta != '') campoInfo(l10n.automezziScreenFieldProprieta, proprieta[automezzo.proprieta] ?? automezzo.proprieta),
                          ])
                        ),
                        const SizedBox(height: 8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: _rigaCampi([
                            if (automezzo.proprieta == 'noleggio' || automezzo.proprieta == 'leasing')
                              campoScadenza(
                                l10n.automezziScreenFieldScadenzaProprieta(automezzo.proprieta),
                                automezzo.scadenzaNoleggioLeasing,
                              ),
                            if (automezzo.compAssicurazione != '') campoInfo(l10n.automezziScreenFieldCompAssicurazione, automezzo.compAssicurazione),
                            if (automezzo.note != '') campoInfo(l10n.commonNoteLabel, automezzo.note),
                          ]),
                        ),
                        const SizedBox(height: 12),
                        Text(l10n.automezziScreenSectionScadenze, style: TextStyle(fontWeight: FontWeight.w600, color: primaryBlue, fontSize: 15)),
                        const SizedBox(height: 8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: _rigaCampi([
                            if (automezzo.scadenzaAssicurazione != '') campoScadenza(l10n.automezziScreenFieldScadAssicurazione, automezzo.scadenzaAssicurazione),
                            if (automezzo.scadenzaBollo != '') campoScadenza(l10n.automezziScreenFieldScadBollo, automezzo.scadenzaBollo),
                            if (automezzo.scadenzaRevisione != '') campoScadenza(l10n.automezziScreenFieldScadRevisione, automezzo.scadenzaRevisione),
                          ])
                        ),
                        if (automezzo.scadenzaControlloTachigrafo != '') ... [
                          const SizedBox(height: 8),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              campoScadenza(l10n.automezziScreenFieldScadTachigrafo, automezzo.scadenzaControlloTachigrafo),
                            ],
                          ),
                        ]
                      ],
                    ),
                  )
          )
        ],
      )
    );
  }
}
