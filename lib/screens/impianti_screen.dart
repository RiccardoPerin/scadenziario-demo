import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badges;

import '../l10n/app_localizations.dart';
import '../providers/impianti_provider.dart';
import '../models/impianto.dart';
import '../widgets/app_bar.dart';
import '../widgets/campo_info.dart';
import '../widgets/app_drawer.dart';
import '../widgets/impianti_form_dialog.dart';
import '../widgets/stato_badge.dart';
import '../widgets/nota_impianto_dialog.dart';
import '../widgets/confirm_dialog.dart';
import '../widgets/info_dialog.dart';
import '../widgets/responsive_card_grid.dart';
import '../widgets/voce_info.dart';

import '../services/stato_scadenze.dart';
import '../services/stampa_tabella.dart';

List<Widget> _rigaCampi(List<Widget> campi, {int colonne = 3}) {
  return [
    ...campi,
    for (var i = campi.length; i < colonne; i++) const Expanded(child: SizedBox()),
  ];
}

String _ubicazione(Impianto i, AppLocalizations l10n) {
  if (i.inUfficio) {
    return l10n.impiantiScreenPdfOffice;
  } else if (i.inMagazzino) {
    return l10n.impiantiScreenPdfWarehouse;
  } else {
    return l10n.impiantiScreenPdfUnspecified;
  }
}

List<String> _colonnePdf(AppLocalizations l10n) => [
  l10n.impiantiScreenColType,
  l10n.impiantiScreenColLocation,
  l10n.impiantiScreenColInstallerCompany,
  l10n.impiantiScreenColInstallDate,
  l10n.impiantiScreenColAssessmentDate,
  l10n.impiantiScreenColInternalMaintDate,
  l10n.impiantiScreenColInternalMaintDeadline,
  l10n.impiantiScreenColInternalCheckType,
  l10n.impiantiScreenColExternalMaintDate,
  l10n.impiantiScreenColExternalMaintDeadline,
  l10n.impiantiScreenColExternalCheckType,
  l10n.impiantiScreenColLightningAssessmentDeadline,
  l10n.commonNoteLabel,
];

List<List<CellaPdf>> _righePdf({
  required List<Impianto> impianti,
  required AppLocalizations l10n,
}) {
  return impianti.map((i) {
    return [
      CellaPdf(i.tipologia, grassetto: true),
      CellaPdf(_ubicazione(i, l10n)),
      CellaPdf(i.dittaInstallatrice),
      CellaPdf(formatData(i.dataInstallazione)),
      CellaPdf(formatData(i.dataValutazione)),
      CellaPdf(formatData(i.dataManutenzioneInterna)),
      cellaScadenza(i.scadenzaManutenzioneInterna),
      CellaPdf(i.tipoVerificaInternaEffettuata),
      CellaPdf(formatData(i.dataManutenzioneEsterna)),
      cellaScadenza(i.scadenzaManutenzioneEsterna),
      CellaPdf(i.tipoVerificaEsternaEffettuata),
      cellaScadenza(i.scadenzaValutazioneScaricheAtmosferiche),
      CellaPdf(i.note),
    ];
  }).toList();
}

typedef _VoceScadenza = ({
  Impianto impianto,
  String tipo,
  DateTime scadenza,
  StatoScadenza stato,
});

int _prioritaPosizione(Impianto i) {
  if (i.inUfficio) return 0;
  if (i.inMagazzino) return 1;
  return 2;
}

/// Etichetta visualizzata per un tipo di scadenza. La chiave interna
/// (`tipo`) resta in italiano perché è usata anche come chiave di
/// archiviazione delle note (vedi `noteScadenze`/`updateNotaScadenza`), quindi
/// qui si traduce solo il testo mostrato all'utente.
String _tipoScadenzaLabel(String tipo, AppLocalizations l10n) {
  switch (tipo) {
    case 'Scadenza Manutenzione Interna':
      return l10n.impiantiScreenInternalMaintenanceDeadlineType;
    case 'Scadenza Manutenzione Esterna':
      return l10n.impiantiScreenExternalMaintenanceDeadlineType;
    default:
      return tipo;
  }
}

/// Una voce per ogni scadenza (non per macchinario) in scadenza o scaduta,
/// per la sezione "Scadenze imminenti" in cima alla pagina.
List<_VoceScadenza> _vociScadenza(List<Impianto> impianti) {
  final voci = <_VoceScadenza>[];
  for (final i in impianti) {
    final campi = {
      'Scadenza Manutenzione Interna': i.scadenzaManutenzioneInterna,
      'Scadenza Manutenzione Esterna': i.scadenzaManutenzioneEsterna,
    };
    for (final entry in campi.entries) {
      final data = parseData(entry.value);
      if (data == null) continue;
      final stato = computeStato(data);
      if (stato == StatoScadenza.valido) continue;
      voci.add((impianto: i, tipo: entry.key, scadenza: data, stato: stato));
    }
  }
  voci.sort((a, b) => a.scadenza.compareTo(b.scadenza));
  return voci;
}


class ImpiantiScreen extends StatefulWidget {
  const ImpiantiScreen({super.key});

  @override
  State<ImpiantiScreen> createState() => _ImpiantiScreenState();
}

class _ImpiantiScreenState extends State<ImpiantiScreen> {
  final _searchController = TextEditingController();
  String _query = '';
  bool _loaded = false;
  bool _scadenzeImminentiEspanse = false;
  final _espanse = <String>{};
  bool _impiantiEspansi = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_loaded) {
      final impiantiProvider = context.read<ImpiantiProvider>();
      _loaded = true;
      Future.microtask(() {
        impiantiProvider.load();
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

   Future<void> _stampa({
    required List<Impianto> impianti,
  }) async {
    final l10n = AppLocalizations.of(context)!;
    final ordinati = [...impianti]
      ..sort((a, b) => _prioritaPosizione(a).compareTo(_prioritaPosizione(b)));
    final filtro = _query.trim();
    try {
      await stampaTabellaPdf(
        titolo: l10n.impiantiScreenTitle,
        sottotitolo: [
          l10n.impiantiScreenPdfSubtitleCount(ordinati.length),
          if (filtro.isNotEmpty) l10n.impiantiScreenPdfSubtitleFilter(filtro),
        ].join(' - '),
        colonne: _colonnePdf(l10n),
        righe: _righePdf(impianti: ordinati, l10n: l10n),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.impiantiScreenPrintErrorMessage(e.toString()))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final primaryBlue = Theme.of(context).colorScheme.primary;
    final impiantiProvider = context.watch<ImpiantiProvider>();

    final erroreCaricamento = impiantiProvider.errorMessage;

    final query = _query.trim().toLowerCase();
    final impiantiFiltrati = impiantiProvider.impianti
        .where((i) => query.isEmpty || i.tipologia.toLowerCase().contains(query))
        .toList()
      ..sort((a, b) => _prioritaPosizione(a).compareTo(_prioritaPosizione(b)));
    final scadenzeImminenti = _vociScadenza(impiantiProvider.impianti);


    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: l10n.impiantiScreenTitle,
        actions: [
          AppBarAction(
            icon: Icons.add,
            label: l10n.impiantiScreenNewSystemLabel,
            onPressed: () => showImpiantoFormDialog(
              context,
              provider: impiantiProvider,
              impianti: impiantiProvider.impianti,
            ),
          ),
        ],
        iconActions: [
          if (impiantiFiltrati.isNotEmpty) ...[
            AppBarAction(
              icon: Icons.print_outlined,
              label: l10n.impiantiScreenPrintLabel,
              onPressed: () => _stampa(impianti: impiantiFiltrati),
            ),
          ],
        ],
      ),
      drawer: const AppDrawer(current: 'Impianti'),
      body:
          impiantiProvider.isLoading && impiantiProvider.impianti.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async {
                await impiantiProvider.load();
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
                            l10n.impiantiScreenUpcomingDeadlines,
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
                              ? l10n.impiantiScreenHideDeadlinesTooltip
                              : l10n.impiantiScreenShowDeadlinesTooltip,
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
                              provider: impiantiProvider,
                              impianti: impiantiProvider.impianti,
                            ),
                    ),
                    const SizedBox(height: 24),
                  ],
                  Row(
                    children: [
                      Text(
                        l10n.impiantiScreenActiveSystemsTitle,
                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 22, color: primaryBlue),
                      ),
                      IconButton(
                        tooltip: _impiantiEspansi
                            ? l10n.impiantiScreenCollapseAllTooltip
                            : l10n.impiantiScreenExpandAllTooltip,
                        onPressed: () {
                          setState(() {
                            _impiantiEspansi = !_impiantiEspansi;
                            if (_impiantiEspansi) {
                              _espanse.addAll(
                                impiantiProvider.impianti.map((i) => i.id),
                              );
                            } else {
                              _espanse.clear();
                            }
                          });
                        },
                        icon: Icon(
                          _impiantiEspansi ? Icons.unfold_less_outlined : Icons.unfold_more_outlined,
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
                      hintText: l10n.impiantiScreenSearchHint,
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
                  if (impiantiFiltrati.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Center(
                        child: Text(
                          impiantiProvider.impianti.isEmpty
                              ? l10n.impiantiScreenNoItemsLoaded
                              : l10n.impiantiScreenNoItemsFound(_query.trim()),
                        ),
                      ),
                    )
                  else
                    ColumnsCardGrid(
                      maxColumns: 2,
                      minWidth: 380,
                      children: impiantiFiltrati.map((impianto) {
                        final espansa = _espanse.contains(impianto.id);
                        return _ImpiantoCard(
                            impianto: impianto,
                            impianti: impiantiProvider.impianti,
                            provider: impiantiProvider,
                            espansa: espansa,
                            onToggleEspansa: () => setState(() {
                            if (espansa) {
                              _espanse.remove(impianto.id);
                            } else {
                              _espanse.add(impianto.id);
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
    required this.impianti,
  });

  final List<_VoceScadenza> voci;
  final ImpiantiProvider provider;
  final List<Impianto> impianti;


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
                    voce.impianto.noteScadenze[voce.tipo];
                final ubicazione = voce.impianto.inUfficio
                    ? l10n.impiantiScreenLocationOfficeLower
                    : voce.impianto.inMagazzino
                        ? l10n.impiantiScreenLocationWarehouseLower
                        : l10n.impiantiScreenLocationUnspecifiedLower;
                return ListTile(
                  leading: StatoBadge(stato: voce.stato, showLabel: !isMobile),
                  title: Text(_tipoScadenzaLabel(voce.tipo, l10n), style: const TextStyle(fontWeight: FontWeight.w700)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      VoceInfo(l10n.impiantiScreenColType, voce.impianto.tipologia),
                      VoceInfo(l10n.impiantiScreenColLocation, ubicazione),
                      if (voce.impianto.note != '') VoceInfo(l10n.commonNoteLabel, voce.impianto.note),
                      if (notaScadenza != null) VoceInfo(l10n.impiantiScreenDeadlineNoteLabel, notaScadenza)
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit_note_rounded, color: primaryBlue, size: isMobile ? 18 : 22),
                        tooltip: l10n.impiantiScreenEditNoteTooltip,
                        onPressed: () => showNotaImpiantoDialog(
                          context,
                          provider: provider,
                          impianto: voce.impianto,
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
                  onTap: () => showImpiantoFormDialog(
                    context,
                    provider: provider,
                    impianti: impianti,
                    esistente: voce.impianto,
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

class _ImpiantoCard extends StatelessWidget {
  const _ImpiantoCard({
    required this.impianto,
    required this.impianti, 
    required this.provider,
    required this.espansa,
    required this.onToggleEspansa,
  });

  final Impianto impianto;
  final List<Impianto> impianti;
  final ImpiantiProvider provider;
  final bool espansa;
  final VoidCallback onToggleEspansa;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final primaryBlue = Theme.of(context).colorScheme.primary;
    final isMobile = MediaQuery.sizeOf(context).width < kMobileAppBarBreakpoint;
    final impiantiProvider = context.watch<ImpiantiProvider>();
    final stato = statoScadenzaImpianto(impianto);
    final inUfficio = impianto.inUfficio;
    final inMagazzino = impianto.inMagazzino;
    final ubicazione = inUfficio
        ? l10n.impiantiScreenLocationOfficeLower
        : inMagazzino
          ? l10n.impiantiScreenLocationWarehouseLower
          : l10n.impiantiScreenLocationUnspecifiedLower;

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: StatoBadge(
              stato: stato,
              showLabel: false,
            ),
            title: Text(impianto.tipologia, style: const TextStyle(fontWeight: FontWeight.w700)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                VoceInfo(l10n.impiantiScreenColLocation, ubicazione),
                if (impianto.note != '') VoceInfo(l10n.commonNoteLabel, impianto.note)
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit_outlined, color: primaryBlue, size: isMobile ? 18 : 22),
                  tooltip: l10n.impiantiScreenEditSystemTooltip,
                  onPressed: () => showImpiantoFormDialog(
                    context,
                    provider: impiantiProvider,
                    impianti: impianti,
                    esistente: impianto,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.delete_outline, color: primaryBlue, size: isMobile ? 18 : 22),
                  tooltip: l10n.impiantiScreenDeleteSystemTooltip,
                  onPressed: () async {
                    final confermato = await showConfirmDialog(
                      context,
                      title: l10n.impiantiScreenDeleteConfirmTitle,
                      message: l10n.impiantiScreenDeleteConfirmMessage(impianto.tipologia),
                    );
                    if (confermato) {
                      await impiantiProvider.delete(
                        impianto.id,
                      );
                    }
                  },
                ),
                IconButton(
                  tooltip: espansa
                      ? l10n.impiantiScreenHideInfoTooltip
                      : l10n.impiantiScreenShowInfoTooltip,
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
                    Text(l10n.impiantiScreenInstallationSectionTitle, style: TextStyle(fontWeight: FontWeight.w600, color: primaryBlue, fontSize: 15)),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _rigaCampi([
                        if (impianto.dittaInstallatrice != '') campoInfo(l10n.impiantiScreenInstallerCompanyLabel, impianto.dittaInstallatrice),
                        campoInfo(l10n.impiantiScreenInstallDateLabel, formatData(impianto.dataInstallazione)),
                        if (impianto.dataValutazione != '') campoInfo(l10n.impiantiScreenAssessmentDateLabel, formatData(impianto.dataValutazione))
                      ]),
                    ),
                    if (impianto.dataManutenzioneInterna != '') ... [
                      const SizedBox(height: 12),
                      Text(l10n.impiantiScreenInternalMaintenanceSectionTitle, style: TextStyle(fontWeight: FontWeight.w600, color: primaryBlue, fontSize: 15)),
                      const SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: _rigaCampi([
                          campoInfo(l10n.impiantiScreenInternalMaintDateLabel, formatData(impianto.dataManutenzioneInterna)),
                          if (impianto.scadenzaManutenzioneInterna != '') campoScadenza(l10n.impiantiScreenInternalMaintDeadlineLabel, impianto.scadenzaManutenzioneInterna),
                          if (impianto.tipoVerificaInternaEffettuata != '') campoInfo(l10n.impiantiScreenCheckTypeLabel, impianto.tipoVerificaInternaEffettuata),
                        ]),
                      ),
                    ],
                    if (impianto.dataManutenzioneEsterna != '') ... [
                      const SizedBox(height: 12),
                      Text(l10n.impiantiScreenExternalMaintenanceSectionTitle, style: TextStyle(fontWeight: FontWeight.w600, color: primaryBlue, fontSize: 15)),
                      const SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: _rigaCampi([
                          campoInfo(l10n.impiantiScreenExternalMaintDateLabel, formatData(impianto.dataManutenzioneEsterna)),
                          if (impianto.scadenzaManutenzioneEsterna != '') campoScadenza(l10n.impiantiScreenExternalMaintDeadlineLabel, impianto.scadenzaManutenzioneEsterna),
                          if (impianto.tipoVerificaEsternaEffettuata != '') campoInfo(l10n.impiantiScreenCheckTypeLabel, impianto.tipoVerificaEsternaEffettuata),
                        ]),
                      ),
                    ],
                    if (impianto.scadenzaValutazioneScaricheAtmosferiche != '') ... [
                      const SizedBox(height: 12),
                      Text(l10n.impiantiScreenLightningSectionTitle, style: TextStyle(fontWeight: FontWeight.w600, color: primaryBlue, fontSize: 15)),
                      const SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: _rigaCampi([
                          campoScadenza(l10n.impiantiScreenLightningAssessmentDeadlineLabel, impianto.scadenzaValutazioneScaricheAtmosferiche)
                        ]),
                      ),
                    ],
                    if (impianto.note != '') ... [
                      const SizedBox(height: 12),
                      Text(l10n.impiantiScreenAdditionalNotesSectionTitle, style: TextStyle(fontWeight: FontWeight.w600, color: primaryBlue, fontSize: 15)),
                      const SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          campoInfo(l10n.commonNoteLabel, impianto.note),
                        ]
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