import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../models/cantiere.dart';
import '../models/documento.dart';
import '../models/subappaltatore.dart';
import '../providers/auth_provider.dart';
import '../providers/cantieri_provider.dart';
import '../providers/dipendenti_subappaltatori_provider.dart';
import '../providers/documenti_provider.dart';
import '../providers/subappaltatori_provider.dart';
import '../providers/tipi_scadenze_provider.dart';
import '../services/stato_scadenze.dart';
import '../widgets/app_bar.dart' show kMobileAppBarBreakpoint;
import '../widgets/breadcrumb_app_bar.dart';
import '../widgets/document_form_dialog.dart';
import '../widgets/documento_tile.dart';
import '../widgets/subappaltatore_form_dialog.dart';
import '../widgets/stato_badge.dart';
import '../widgets/voce_info.dart';

class SubappaltatoreDetailScreen extends StatefulWidget {
  const SubappaltatoreDetailScreen({
    super.key,
    required this.cantiereId,
    required this.subappaltatoreId,
  });

  final String cantiereId;
  final String subappaltatoreId;

  @override
  State<SubappaltatoreDetailScreen> createState() => _SubappaltatoreDetailScreenState();
}

class _SubappaltatoreDetailScreenState extends State<SubappaltatoreDetailScreen> {
  final Set<String> _dipendentiEspansi = {};
  bool _documentiDipendentiEspansi = false;

  /// Stato peggiore fra tutti i documenti del dipendente, mostrato nel badge
  /// del gruppo quando è chiuso (rosso se almeno uno è scaduto, ecc.).
  StatoScadenza _statoPeggiore(List<Documento> documenti) {
    var peggiore = StatoScadenza.valido;
    for (final d in documenti) {
      final stato = computeStato(d.dataScadenza, giorniPreavviso: d.giorniPreavviso);
      if (stato == StatoScadenza.scaduto) return StatoScadenza.scaduto;
      if (stato == StatoScadenza.inScadenza) peggiore = StatoScadenza.inScadenza;
    }
    return peggiore;
  }

  /// Quanti documenti del dipendente sono scaduti e quanti in scadenza,
  /// mostrati nel sottotitolo del gruppo accanto al totale.
  ({int scaduti, int inScadenza}) _conteggioScadenze(List<Documento> documenti) {
    var scaduti = 0;
    var inScadenza = 0;
    for (final d in documenti) {
      switch (computeStato(d.dataScadenza, giorniPreavviso: d.giorniPreavviso)) {
        case StatoScadenza.scaduto:
          scaduti++;
        case StatoScadenza.inScadenza:
          inScadenza++;
        case StatoScadenza.valido:
          break;
      }
    }
    return (scaduti: scaduti, inScadenza: inScadenza);
  }

  /// Pallino di riepilogo del dipendente: al passaggio del mouse elenca per
  /// nome le scadenze scadute (e quelle in scadenza), così da sapere quali
  /// sono senza dover espandere il gruppo.
  Widget _badgeDipendente(List<Documento> documentiDelDipendente) {
    final badge = StatoBadge(
      stato: _statoPeggiore(documentiDelDipendente),
      showLabel: false,
    );
    final tooltip = tooltipDocumentiCritici(documentiDelDipendente);
    if (tooltip == null) return badge;
    return Tooltip(message: tooltip, child: badge);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cantiereId = widget.cantiereId;
    final subappaltatoreId = widget.subappaltatoreId;
    final primaryBlue = Theme.of(context).colorScheme.primary;
    final isMobile = MediaQuery.sizeOf(context).width < kMobileAppBarBreakpoint;
    final cantieriProvider = context.watch<CantieriProvider>();
    final subappaltatoriProvider = context.watch<SubappaltatoriProvider>();
    final documentiProvider = context.watch<DocumentiProvider>();
    final tipiScadenzeProvider = context.watch<TipiScadenzeProvider>();
    final dipendentiProvider = context.watch<DipendentiSubappaltatoriProvider>();
    final authProvider = context.watch<AuthProvider>();

    final cantieriTrovati = cantieriProvider.cantieri.where((c) => c.id == cantiereId);
    final subappaltatoriTrovati =
        subappaltatoriProvider.subappaltatori.where((s) => s.id == subappaltatoreId);
    if (cantieriTrovati.isEmpty || subappaltatoriTrovati.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final Cantiere cantiere = cantieriTrovati.first;
    final Subappaltatore subappaltatore = subappaltatoriTrovati.first;

    final documenti = documentiPerUrgenza(
      documentiProvider.soloUltimaVersione(
        documentiProvider
            .perSubappaltatore(cantiereId, subappaltatoreId)
            .where((d) => d.cantiereId.isNotEmpty)
            .toList(),
      ),
    );
    final documentiGeneraliSubappaltatore = documentiPerUrgenza(
      documentiProvider.soloUltimaVersione(
        documentiProvider
            .perSubappaltatoreTutti(subappaltatoreId)
            .where((d) => d.cantiereId.isEmpty)
            .toList(),
      ),
    );
    final dipendentiPresenti = dipendentiProvider
        .perSubappaltatore(subappaltatoreId)
        .where((d) => d.cantieriIds.contains(cantiereId))
        .toList();
    // L'ordine per urgenza si propaga ai gruppi per dipendente qui sotto, che
    // conservano quello della lista di partenza.
    final documentiDipendenti = documentiPerUrgenza(
      documentiProvider.soloUltimaVersione(
        documentiProvider.perDipendenti(dipendentiPresenti.map((d) => d.id).toList()),
      ),
    );

    // Documenti raggruppati per dipendente: ogni gruppo è una riga espandibile.
    final documentiPerDipendente = <String, List<Documento>>{};
    for (final d in documentiDipendenti) {
      (documentiPerDipendente[d.dipendenteId] ??= []).add(d);
    }
    final dipendentiConDocumenti = dipendentiPresenti
        .where((d) => documentiPerDipendente.containsKey(d.id))
        .toList()
      ..sort((a, b) {
        final perCognome = a.cognome.compareTo(b.cognome);
        return perCognome != 0 ? perCognome : a.nome.compareTo(b.nome);
      });

    return Scaffold(
      appBar: BreadcrumbAppBar(
        items: [
          BreadcrumbItem(label: l10n.subappaltatoreDetailScreenBreadcrumbCantieri, onTap: () => context.go('/cantieri')),
          BreadcrumbItem(
            label: cantiere.nome,
            onTap: () => vaiRicostruendoStack(
              context,
              ['/cantieri', '/cantieri/$cantiereId'],
            ),
          ),
          BreadcrumbItem(label: subappaltatore.ragioneSociale),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 5, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(l10n.subappaltatoreDetailScreenInfoSection, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18, color: primaryBlue)),
                      IconButton(
                        icon: Icon(Icons.edit, color: primaryBlue, size: isMobile ? 18 : 22),
                        onPressed: () => showSubappaltatoreFormDialog(
                          context,
                          provider: subappaltatoriProvider,
                          tuttiCantieri: cantieriProvider.cantieri,
                          esistente: subappaltatore
                        ),
                      ),
                    ],
                  ),
                  VoceInfo(l10n.subappaltatoreDetailScreenVatLabel, subappaltatore.partitaIva),
                  if (subappaltatore.email.isNotEmpty)
                    VoceInfo('Email', subappaltatore.email),
                  if (subappaltatore.note.isNotEmpty)
                    VoceInfo(l10n.commonNoteLabel, subappaltatore.note),
                ],
              ),
            ),
          ),
          if (documentiGeneraliSubappaltatore.isNotEmpty) ... [
            const SizedBox(height: 24),
            Text(l10n.subappaltatoreDetailScreenGeneralDeadlinesTitle,
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18, color: primaryBlue)),
            const SizedBox(height: 8),
            Card(
              child: Column(
                children: ListTile.divideTiles(
                  context: context,
                  color: Colors.blueGrey.shade200,
                  tiles: documentiGeneraliSubappaltatore.map((d) => DocumentoTile(
                    documento: d, 
                    documentiProvider: documentiProvider
                    ))
                ).toList(),
              ),
            ),
          ],
          const SizedBox(height: 32),
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            runSpacing: 8,
            children: [
              Text(l10n.subappaltatoreDetailScreenSiteDeadlinesTitle, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18, color: primaryBlue)),
              TextButton.icon(
                icon: const Icon(Icons.add),
                label: Text(l10n.subappaltatoreDetailScreenAddDeadline),
                onPressed: () => showDocumentFormDialog(
                  context,
                  documentiProvider: documentiProvider,
                  tipiScadenzeProvider: tipiScadenzeProvider,
                  caricatoDaId: authProvider.currentUser?.id ?? '',
                  cantiereId: cantiereId,
                  subappaltatoreId: subappaltatoreId,
                ),
              ),
            ],
          ),
          if (documenti.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(l10n.subappaltatoreDetailScreenNoDeadlinesSubappaltatore),
            )
          else
            Card(
              child: Column(
                children: ListTile.divideTiles(
                  context: context,
                  color: Colors.blueGrey.shade200,
                  tiles: documenti.map((d) => DocumentoTile(
                    documento: d, 
                    documentiProvider: documentiProvider
                    ))
                ).toList()
              )
            ),
          if (dipendentiPresenti.isNotEmpty) ...[
            const SizedBox(height: 32),
            Row(
              children: [
                Text(l10n.subappaltatoreDetailScreenEmployeeDeadlinesTitle,
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18, color: primaryBlue)),
                IconButton(
                  tooltip: _documentiDipendentiEspansi ? l10n.subappaltatoreDetailScreenCollapseAll : l10n.subappaltatoreDetailScreenExpandAll,
                  onPressed:() {
                    setState(() {
                      _documentiDipendentiEspansi = !_documentiDipendentiEspansi;
                      if (_documentiDipendentiEspansi) {
                        _dipendentiEspansi.addAll(
                          dipendentiPresenti.map((d) => d.id)
                        );
                      }
                      else {
                        _dipendentiEspansi.clear();
                      }
                    });
                  }, 
                  icon: Icon(
                    _documentiDipendentiEspansi ? Icons.unfold_less_outlined : Icons.unfold_more_outlined,
                    size: 20, color: primaryBlue,
                  )
                ),
              ]
            ),
            const SizedBox(height: 8),
            if (dipendentiConDocumenti.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(l10n.subappaltatoreDetailScreenNoDeadlinesEmployees),
              )
            else
              Card(
                child: Column(
                  children: [
                    for (int i = 0; i < dipendentiConDocumenti.length; i++) ...[
                      Builder(builder: (context) {
                        final dipendente = dipendentiConDocumenti[i];
                        final documentiDelDipendente = documentiPerDipendente[dipendente.id]!;
                        final espanso = _dipendentiEspansi.contains(dipendente.id);
                        final conteggio = _conteggioScadenze(documentiDelDipendente);
                        return Column(
                          children: [
                            ListTile(
                              leading: _badgeDipendente(documentiDelDipendente),
                              title: Text(
                                dipendente.nomeCompleto,
                                style: const TextStyle(fontWeight: FontWeight.w600),
                              ),
                              subtitle: Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: documentiDelDipendente.length == 1
                                          ? l10n.subappaltatoreDetailScreenDeadlineCountSingular
                                          : l10n.subappaltatoreDetailScreenDeadlineCountPlural(documentiDelDipendente.length),
                                    ),
                                    if (conteggio.scaduti > 0)
                                      TextSpan(
                                        text: conteggio.scaduti == 1
                                            ? l10n.subappaltatoreDetailScreenExpiredCountSingular
                                            : l10n.subappaltatoreDetailScreenExpiredCountPlural(conteggio.scaduti),
                                      ),
                                    if (conteggio.inScadenza > 0)
                                      TextSpan(
                                        text: l10n.subappaltatoreDetailScreenUpcomingCount(conteggio.inScadenza),
                                      ),
                                    if (dipendente.lavoratoreAutonomo)
                                      TextSpan(text: l10n.subappaltatoreDetailScreenAutonomousWorker),
                                    if (dipendente.note.isNotEmpty)
                                      TextSpan(text: l10n.subappaltatoreDetailScreenNoteSuffix(dipendente.note)),
                                  ],
                                ),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    tooltip: espanso ? l10n.subappaltatoreDetailScreenHideDeadlines : l10n.subappaltatoreDetailScreenShowDeadlines,
                                    onPressed: () => setState(() {
                                      espanso
                                          ? _dipendentiEspansi.remove(dipendente.id)
                                          : _dipendentiEspansi.add(dipendente.id);
                                    }),
                                    icon: Icon(
                                      espanso
                                          ? Icons.keyboard_arrow_up_outlined
                                          : Icons.keyboard_arrow_down_outlined,
                                      color: primaryBlue,
                                      size: isMobile ? 18 : 22,
                                    ),
                                  ),
                                  IconButton(
                                    tooltip: l10n.subappaltatoreDetailScreenOpenEmployeePage,
                                    // push (non go) così il tasto indietro
                                    // riporta a questa pagina.
                                    onPressed: () => context.push(
                                      '/subappaltatori/$subappaltatoreId/dipendenti/${dipendente.id}',
                                    ),
                                    icon: Icon(
                                      Icons.arrow_forward,
                                      color: primaryBlue,
                                      size: isMobile ? 18 : 22,
                                    ),
                                  ),
                                ],
                              ),
                              onTap: () => setState(() {
                                espanso
                                    ? _dipendentiEspansi.remove(dipendente.id)
                                    : _dipendentiEspansi.add(dipendente.id);
                              }),
                            ),
                            AnimatedSize(
                              duration: const Duration(milliseconds: 200),
                              alignment: Alignment.topCenter,
                              child: !espanso
                                  ? const SizedBox(width: double.infinity)
                                  : Column(
                                      children: [
                                        Divider(height: 1, color: Colors.blueGrey.shade200),
                                        ...ListTile.divideTiles(
                                          context: context,
                                          color: Colors.blueGrey.shade200,
                                          tiles: documentiDelDipendente.map(
                                            (d) => DocumentoTile(
                                              documento: d,
                                              documentiProvider: documentiProvider,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          ],
                        );
                      }),
                      // Divider grigio fra un dipendente e l'altro, tranne dopo l'ultimo
                      if (i < dipendentiConDocumenti.length - 1)
                        Divider(height: 1, color: Colors.blueGrey.shade200),
                    ],
                  ],
                ),
              ),
          ],
        ],
      ),
    );
  }
}
