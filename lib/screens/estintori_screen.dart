import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badges;

import '../l10n/app_localizations.dart';
import '../widgets/app_bar.dart';
import '../widgets/app_drawer.dart';
import '../widgets/campo_info.dart';
import '../widgets/responsive_card_grid.dart';
import '../widgets/stato_badge.dart';
import '../widgets/estintore_form_dialog.dart' show showEstintoreFormDialog, tipiAgente;
import '../widgets/nota_estintore_dialog.dart';
import '../widgets/confirm_dialog.dart';
import '../widgets/info_dialog.dart';
import '../widgets/voce_info.dart';
import '../providers/automezzi_provider.dart';
import '../providers/cantieri_provider.dart';
import '../providers/estintori_provider.dart';
import '../models/automezzo.dart';
import '../models/cantiere.dart';
import '../models/estintore.dart';
import '../services/stato_scadenze.dart';
import '../services/stampa_tabella.dart';

String _tipologia(Estintore e) => tipiAgente[e.tipoAgente] ?? e.tipoAgente;

List<String> _colonnePdf(AppLocalizations l10n) => [
  l10n.estintoriScreenPdfColMatricola,
  l10n.estintoriScreenLabelCapacita,
  l10n.estintoriScreenLabelTipo,
  l10n.estintoriScreenLabelUbicazione,
  l10n.estintoriScreenPdfColDataProduzione,
  l10n.estintoriScreenLabelDataMessaInServizio,
  l10n.estintoriScreenLabelDataVerificaEsterna,
  l10n.estintoriScreenPdfColScadVerificaEsterna,
  l10n.estintoriScreenPdfColDataRevisione,
  l10n.estintoriScreenPdfColScadRevisione,
  l10n.estintoriScreenLabelDataCollaudo,
  l10n.estintoriScreenPdfColScadCollaudo,
  l10n.commonNoteLabel,
];

List<List<CellaPdf>> _righePdf({
  required AppLocalizations l10n,
  required List<Estintore> estintori,
  required List<Cantiere> cantieri,
  required List<Automezzo> automezzi
}) {
  return estintori.map((e) {
    return [
      CellaPdf(e.numeroMatricola, grassetto: true),
      CellaPdf(e.capacita),
      CellaPdf(_tipologia(e)),
      CellaPdf(_descrizioneUbicazione(l10n, e, cantieri, automezzi).join(', ')),
      CellaPdf(formatData(e.dataProduzione)),
      CellaPdf(formatData(e.dataMessaInServizio)),
      CellaPdf(formatData(e.dataVerificaEsterna)),
      cellaScadenza(e.scadenzaVerificaEsterna),
      CellaPdf(formatData(e.ultimaRevisione)),
      cellaScadenza(e.scadenzaRevisione),
      CellaPdf(formatData(e.ultimoCollaudo)),
      cellaScadenza(e.scadenzaCollaudo),
      CellaPdf(e.note),
    ];
  }).toList();
}

typedef _VoceScadenza = ({
  Estintore estintore,
  String tipo,
  DateTime scadenza,
  StatoScadenza stato,
});

String _ubicazioneTesto(
  Estintore e,
  List<Cantiere> cantieri,
  List<Automezzo> automezzi,
) {
  final parti = <String>[];
  if (e.inMagazzino) parti.add('magazzino');
  if (e.inUfficio) parti.add('ufficio');
  if (e.ubicazioneCantiereId.isNotEmpty) {
    parti.add('cantiere');
    final nome = cantieri
        .where((c) => c.id == e.ubicazioneCantiereId)
        .map((c) => c.nome)
        .firstOrNull;
    if (nome != null) parti.add(nome);
  }
  if (e.ubicazioneAutomezzoId.isNotEmpty) {
    parti.add('automezzo');
    final automezzo = automezzi
        .where((a) => a.id == e.ubicazioneAutomezzoId)
        .firstOrNull;
    if (automezzo != null) {
      parti.add(automezzo.nome);
      parti.add(automezzo.targa);
    }
  }
  if (e.dettaglioUbicazione.isNotEmpty) parti.add(e.dettaglioUbicazione);
  return parti.join(' ');
}

List<String> _descrizioneUbicazione(
  AppLocalizations l10n,
  Estintore e,
  List<Cantiere> cantieri,
  List<Automezzo> automezzi,
) {
  final dettaglio = e.dettaglioUbicazione;
  String conDettaglio(String base) =>
      dettaglio.isEmpty ? base : '$base ($dettaglio)';

  final descrizioni = <String>[];
  if (e.inMagazzino) descrizioni.add(conDettaglio(l10n.estintoriScreenLocationWarehouse));
  if (e.inUfficio) descrizioni.add(conDettaglio(l10n.estintoriScreenLocationOffice));
  if (e.ubicazioneCantiereId.isNotEmpty) {
    final nome =
        cantieri
            .where((c) => c.id == e.ubicazioneCantiereId)
            .map((c) => c.nome)
            .firstOrNull ??
        e.ubicazioneCantiereId;
    descrizioni.add(conDettaglio(l10n.estintoriScreenLocationSite(nome)));
  }
  if (e.ubicazioneAutomezzoId.isNotEmpty) {
    final automezzo = automezzi
        .where((a) => a.id == e.ubicazioneAutomezzoId)
        .firstOrNull;
    final testo = automezzo == null
        ? e.ubicazioneAutomezzoId
        : (automezzo.nome.isNotEmpty
              ? '${automezzo.nome} (${automezzo.targa})'
              : automezzo.targa);
    descrizioni.add(conDettaglio(l10n.estintoriScreenLocationVehicle(testo)));
  }
  // Ubicazione non specificata: mostra solo la nota di ubicazione.
  if (descrizioni.isEmpty && dettaglio.isNotEmpty) descrizioni.add(dettaglio);
  return descrizioni;
}

/// Le descrizioni di [_descrizioneUbicazione] su una riga sola, per le voci
/// "Ubicazione: ..." delle schede.
String _ubicazioneVoce(
  AppLocalizations l10n,
  Estintore e,
  List<Cantiere> cantieri,
  List<Automezzo> automezzi,
) {
  final descrizioni = _descrizioneUbicazione(l10n, e, cantieri, automezzi);
  return descrizioni.isEmpty ? l10n.estintoriScreenLocationUnspecified : descrizioni.join(', ');
}

/// Etichetta leggibile per il [tipo] di scadenza (le chiavi restano in
/// italiano perché usate anche come chiave di [Estintore.noteScadenze]).
String _tipoScadenzaLabel(AppLocalizations l10n, String tipo) {
  switch (tipo) {
    case 'Scadenza Collaudo':
      return l10n.estintoriScreenTipoScadenzaCollaudo;
    case 'Scadenza Revisione':
      return l10n.estintoriScreenTipoScadenzaRevisione;
    case 'Scadenza Verifica Esterna':
      return l10n.estintoriScreenTipoScadenzaVerificaEsterna;
    case 'Sostituzione (18 anni)':
      return l10n.estintoriScreenTipoSostituzione;
    default:
      return tipo;
  }
}

/// Priorità di ordinamento per posizione: ufficio, poi magazzino, poi
/// cantieri, infine automezzi e casi residuali.
int _prioritaPosizione(Estintore e) {
  if (e.inUfficio) return 0;
  if (e.inMagazzino) return 1;
  if (e.ubicazioneCantiereId.isNotEmpty) return 2;
  if (e.ubicazioneAutomezzoId.isNotEmpty) return 3;
  return 4;
}

List<_VoceScadenza> _vociScadenza(List<Estintore> estintori) {
  final voci = <_VoceScadenza>[];
  for (final e in estintori) {
    final campi = {
      'Scadenza Collaudo': e.scadenzaCollaudo,
      'Scadenza Revisione': e.scadenzaRevisione,
      'Scadenza Verifica Esterna': e.scadenzaVerificaEsterna,
    };
    for (final entry in campi.entries) {
      final data = parseData(entry.value);
      if (data == null) continue;
      final stato = computeStato(data);
      if (stato == StatoScadenza.valido) continue;
      voci.add((estintore: e, tipo: entry.key, scadenza: data, stato: stato));
    }

    final sostituzione = scadenzaSostituzioneEstintore(e);
    if (sostituzione != null) {
      final stato = computeStato(sostituzione);
      if (stato != StatoScadenza.valido) {
        voci.add((
          estintore: e,
          tipo: 'Sostituzione (18 anni)',
          scadenza: sostituzione,
          stato: stato,
        ));
      }
    }
  }
  voci.sort((a, b) => a.scadenza.compareTo(b.scadenza));
  return voci;
}

class EstintoriScreen extends StatefulWidget {
  const EstintoriScreen({super.key});

  @override
  State<EstintoriScreen> createState() => _EstintoriScreenState();
}

class _EstintoriScreenState extends State<EstintoriScreen> {
  final _searchController = TextEditingController();
  String _query = '';
  bool _loaded = false;
  final _espanse = <String>{};
  bool _scadenzeImminentiEspanse = false;
  bool _estintoriEspansi = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_loaded) {
      final estintoriProvider = context.read<EstintoriProvider>();
      final cantieriProvider = context.read<CantieriProvider>();
      final automezziProvider = context.read<AutomezziProvider>();
      _loaded = true;
      Future.microtask(() {
        estintoriProvider.load();
        cantieriProvider.load();
        automezziProvider.load();
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _stampa({
    required List<Estintore> estintori,
    required List<Cantiere> cantieri,
    required List<Automezzo> automezzi,
  }) async {
    final l10n = AppLocalizations.of(context)!;
    final ordinati = [...estintori]
      ..sort((a, b) => _prioritaPosizione(a).compareTo(_prioritaPosizione(b)));
    final filtro = _query.trim();
    try {
      await stampaTabellaPdf(
        titolo: l10n.estintoriScreenTitle,
        sottotitolo: [
          l10n.estintoriScreenPdfCount(ordinati.length),
          if (filtro.isNotEmpty) l10n.estintoriScreenPdfFilter(filtro),
        ].join(' - '),
        colonne: _colonnePdf(l10n),
        righe: _righePdf(
          l10n: l10n,
          estintori: ordinati,
          cantieri: cantieri,
          automezzi: automezzi,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.estintoriScreenPrintError(e.toString()))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final primaryBlue = Theme.of(context).colorScheme.primary;
    final estintoriProvider = context.watch<EstintoriProvider>();
    final cantieriProvider = context.watch<CantieriProvider>();
    final automezziProvider = context.watch<AutomezziProvider>();
    final erroreCaricamento =
        estintoriProvider.errorMessage ??
        cantieriProvider.errorMessage ??
        automezziProvider.errorMessage;

    final query = _query.trim().toLowerCase();
    final estintoriFiltrati = estintoriProvider.estintori
        .where(
          (e) =>
              query.isEmpty ||
              e.numeroMatricola.toLowerCase().contains(query) ||
              _ubicazioneTesto(
                e,
                cantieriProvider.cantieri,
                automezziProvider.automezzi,
              ).toLowerCase().contains(query),
        )
        .toList()
      ..sort((a, b) => _prioritaPosizione(a).compareTo(_prioritaPosizione(b)));
    final scadenzeImminenti = _vociScadenza(estintoriProvider.estintori);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: l10n.estintoriScreenTitle,
        actions: [
          AppBarAction(
            icon: Icons.add,
            label: l10n.estintoriScreenNewButton,
            onPressed: () => showEstintoreFormDialog(
              context,
              provider: estintoriProvider,
              estintori: estintoriProvider.estintori,
              cantieri: cantieriProvider.cantieri,
              automezzi: automezziProvider.automezzi,
            ),
          ),
        ],
        iconActions: [
          AppBarAction(
            icon: Icons.print_outlined,
            label: l10n.estintoriScreenPrintAction,
            onPressed: () => _stampa(
              estintori: estintoriFiltrati,
              cantieri: cantieriProvider.cantieri,
              automezzi: automezziProvider.automezzi,
            ),
          )
        ]
      ),
      drawer: const AppDrawer(current: 'Estintori'),
      body: estintoriProvider.isLoading && estintoriProvider.estintori.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async {
                await estintoriProvider.load();
              },
              child: ListView(
                padding: EdgeInsets.fromLTRB(24, 24, 24, 24),
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
                            l10n.estintoriScreenUpcomingDeadlines,
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
                          tooltip: _scadenzeImminentiEspanse ? l10n.estintoriScreenHideDeadlines : l10n.estintoriScreenShowDeadlines,
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
                              provider: estintoriProvider,
                              estintori: estintoriProvider.estintori,
                              cantieri: cantieriProvider.cantieri,
                              automezzi: automezziProvider.automezzi,
                            ),
                    ),
                    const SizedBox(height: 24),
                  ],
                  Row(
                    children: [
                      Text(
                        l10n.estintoriScreenSectionTitle,
                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 22, color: primaryBlue),
                      ),
                      IconButton(
                        tooltip: _estintoriEspansi ? l10n.estintoriScreenCollapseAll : l10n.estintoriScreenExpandAll,
                        onPressed: () {
                          setState(() {
                            _estintoriEspansi = !_estintoriEspansi;
                            if (_estintoriEspansi) {
                              _espanse.addAll(
                                estintoriProvider.estintori.map((e) => e.id),
                              );
                            } else {
                              _espanse.clear();
                            }
                          });
                        },
                        icon: Icon(
                          _estintoriEspansi ? Icons.unfold_less_outlined : Icons.unfold_more_outlined,
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
                      hintText: l10n.estintoriScreenSearchHint,
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
                  if (estintoriFiltrati.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Center(
                        child: Text(
                          estintoriProvider.estintori.isEmpty
                              ? l10n.estintoriScreenEmptyNone
                              : l10n.estintoriScreenEmptySearch(_query.trim()),
                        ),
                      ),
                    )
                  else
                    ColumnsCardGrid(
                      maxColumns: 2,
                      minWidth: 380,
                      children: estintoriFiltrati.map((estintore) {
                        final espansa = _espanse.contains(estintore.id);
                        return _EstintoreCard(
                          estintore: estintore, 
                          estintori: estintoriProvider.estintori, 
                          provider: estintoriProvider, 
                          espansa: espansa, 
                          onToggleEspansa: () => setState(() {
                            if (espansa) {
                              _espanse.remove(estintore.id);
                            } else {
                              _espanse.add(estintore.id);
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
    required this.estintori,
    required this.cantieri,
    required this.automezzi,
  });

  final List<_VoceScadenza> voci;
  final EstintoriProvider provider;
  final List<Estintore> estintori;
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
                    voce.estintore.noteScadenze[voce.tipo] ?? '';
                final ubicazione = _ubicazioneVoce(
                  l10n,
                  voce.estintore,
                  cantieri,
                  automezzi,
                );
                return ListTile(
                  leading: StatoBadge(stato: voce.stato, showLabel: !isMobile),
                  title: Text(_tipoScadenzaLabel(l10n, voce.tipo), style: const TextStyle(fontWeight: FontWeight.w700)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      VoceInfo(l10n.estintoriScreenLabelMatricola, voce.estintore.numeroMatricola),
                      VoceInfo(l10n.estintoriScreenLabelUbicazione, ubicazione),
                      if (voce.estintore.note != '') VoceInfo(l10n.commonNoteLabel, voce.estintore.note),
                      if (notaScadenza.isNotEmpty) VoceInfo(l10n.estintoriScreenLabelNotaScadenza, notaScadenza),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit_note_rounded, color: primaryBlue, size: isMobile ? 18 : 22),
                        tooltip: l10n.estintoriScreenEditNoteTooltip,
                        onPressed: () => showNotaEstintoreDialog(
                          context,
                          provider: provider,
                          estintore: voce.estintore,
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
                  onTap: () => showEstintoreFormDialog(
                    context,
                    provider: provider,
                    estintori: provider.estintori,
                    cantieri: cantieri,
                    automezzi: automezzi,
                    esistente: voce.estintore,
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

class _EstintoreCard extends StatelessWidget{
  const _EstintoreCard({
    required this.estintore,
    required this.estintori,
    required this.provider,
    required this.espansa,
    required this.onToggleEspansa,
  });

  final Estintore estintore;
  final List<Estintore> estintori;
  final EstintoriProvider provider;
  final bool espansa;
  final VoidCallback onToggleEspansa;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final primaryBlue = Theme.of(context).colorScheme.primary;
    final isMobile = MediaQuery.sizeOf(context).width < kMobileAppBarBreakpoint;
    final estintoriProvider = context.watch<EstintoriProvider>();
    final cantieriProvider = context.watch<CantieriProvider>();
    final automezziProvider = context.watch<AutomezziProvider>();
    final stato = statoScadenzaEstintore(estintore);
    final ubicazione = _ubicazioneVoce(
      l10n,
      estintore,
      cantieriProvider.cantieri,
      automezziProvider.automezzi,
    );

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: StatoBadge(
              stato: stato,
              showLabel: false,
            ),
            title: Text(estintore.numeroMatricola, style: const TextStyle(fontWeight: FontWeight.w700)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                VoceInfo(l10n.estintoriScreenLabelUbicazione, ubicazione),
                if (estintore.note != '') VoceInfo(l10n.commonNoteLabel, estintore.note),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit_outlined, color: primaryBlue, size: isMobile ? 18 : 22),
                  tooltip: l10n.estintoriScreenEditTooltip,
                  onPressed: () => showEstintoreFormDialog(
                    context,
                    provider: estintoriProvider,
                    estintori: estintoriProvider.estintori,
                    cantieri: cantieriProvider.cantieri,
                    automezzi: automezziProvider.automezzi,
                    esistente: estintore,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.delete_outline, color: primaryBlue, size: isMobile ? 18 : 22),
                  tooltip: l10n.estintoriScreenDeleteTooltip,
                  onPressed: () async {
                    final confermato = await showConfirmDialog(
                      context,
                      title: l10n.estintoriScreenDeleteConfirmTitle,
                      message: l10n.estintoriScreenDeleteConfirmMessage(estintore.numeroMatricola),
                    );
                    if (confermato) {
                      await estintoriProvider.delete(
                        estintore.id,
                      );
                    }
                  },
                ),
                IconButton(
                  tooltip: espansa ? l10n.estintoriScreenHideInfo : l10n.estintoriScreenShowInfo,
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
                        Text(l10n.estintoriScreenSectionGeneralData, style: TextStyle(color: primaryBlue, fontWeight: FontWeight.w600, fontSize: 15)),
                        const SizedBox(height: 8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            campoInfo(l10n.estintoriScreenLabelCapacita, estintore.capacita),
                            campoInfo(l10n.estintoriScreenLabelTipo, tipiAgente[estintore.tipoAgente] ?? estintore.tipoAgente),
                            campoInfo(l10n.commonNoteLabel, estintore.note)
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            campoInfo(l10n.estintoriScreenLabelDataProduzione, formatData(estintore.dataProduzione)),
                            campoInfo(l10n.estintoriScreenLabelDataMessaInServizio, formatData(estintore.dataMessaInServizio)),
                            campoInfo(
                              l10n.estintoriScreenLabelUbicazione,
                              _descrizioneUbicazione(
                                l10n,
                                estintore,
                                cantieriProvider.cantieri,
                                automezziProvider.automezzi,
                              ).join(', '),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(l10n.estintoriScreenSectionVerificaEsterna, style: TextStyle(fontWeight: FontWeight.w600, color: primaryBlue, fontSize: 15)),
                        const SizedBox(height: 8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            campoInfo(l10n.estintoriScreenLabelDataVerificaEsterna, formatData(estintore.dataVerificaEsterna)),
                            campoScadenza(l10n.estintoriScreenLabelScadenzaVerificaEsterna, estintore.scadenzaVerificaEsterna)
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(l10n.estintoriScreenSectionRevisione, style: TextStyle(fontWeight: FontWeight.w600, color: primaryBlue, fontSize: 15)),
                        const SizedBox(height: 8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            campoInfo(l10n.estintoriScreenLabelDataUltimaRevisione, formatData(estintore.ultimaRevisione)),
                            campoScadenza(l10n.estintoriScreenLabelScadenzaRevisione, estintore.scadenzaRevisione)
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(l10n.estintoriScreenSectionCollaudo, style: TextStyle(fontWeight: FontWeight.w600, color: primaryBlue, fontSize: 15)),
                        const SizedBox(height: 8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            campoInfo(l10n.estintoriScreenLabelDataCollaudo, formatData(estintore.ultimoCollaudo)),
                            campoScadenza(l10n.estintoriScreenLabelScadenzaCollaudo, estintore.scadenzaCollaudo)
                          ],
                        ),
                      ],
                    ),
                  )
          )
        ],
      )
    );
  }
}