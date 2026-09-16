import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../models/dipendente_subappaltatore.dart';
import '../models/subappaltatore.dart';
import '../providers/auth_provider.dart';
import '../providers/cantieri_provider.dart';
import '../providers/dipendenti_subappaltatori_provider.dart';
import '../providers/documenti_provider.dart';
import '../providers/subappaltatori_provider.dart';
import '../providers/tipi_scadenze_provider.dart';
import '../services/eliminazione_cascata.dart';
import '../services/stato_scadenze.dart';
import '../widgets/app_bar.dart' show kMobileAppBarBreakpoint;
import '../widgets/breadcrumb_app_bar.dart';
import '../widgets/dipendente_subappaltatore_form_dialog.dart';
import '../widgets/document_form_dialog.dart';
import '../widgets/confirm_dialog.dart';
import '../widgets/documento_tile.dart';
import '../widgets/stato_badge.dart';
import '../widgets/subappaltatore_form_dialog.dart';
import '../widgets/voce_info.dart';

class SubappaltatoreDocumentiScreen extends StatelessWidget {
  const SubappaltatoreDocumentiScreen({super.key, required this.subappaltatoreId});

  final String subappaltatoreId;

  /// Elimina il dipendente insieme ai suoi documenti (vedi
  /// [eliminaDipendenteSubappaltatoreConTracce]): la conferma lo dice
  /// esplicitamente, perché l'operazione non è reversibile.
  Future<void> _eliminaDipendente(
    BuildContext context,
    DipendenteSubappaltatore dipendente,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final documentiProvider = context.read<DocumentiProvider>();
    final quantiDocumenti = documentiProvider
        .soloUltimaVersione(documentiProvider.perDipendente(dipendente.id))
        .length;

    final confermato = await showConfirmDialog(
      context,
      width: 380,
      title: l10n.subappaltatoreDocumentiScreenDeleteEmployeeTitle,
      message: [
        l10n.subappaltatoreDocumentiScreenDeleteEmployeeConfirm(dipendente.nomeCompleto),
        if (quantiDocumenti > 0)
          l10n.subappaltatoreDocumentiScreenDeleteEmployeeWithDocs(quantiDocumenti)
        else
          l10n.subappaltatoreDocumentiScreenDeleteEmployeeNoDocs,
        l10n.subappaltatoreDocumentiScreenIrreversible,
      ].join('\n\n'),
    );
    if (!confermato || !context.mounted) return;
    await eliminaDipendenteSubappaltatoreConTracce(context, dipendente.id);
  }

  /// Pallino con lo stato peggiore fra i documenti del dipendente.
  ///
  /// Il grigio segnala che non ne ha ancora nessuno: come altrove nell'app
  /// (DPI mai assegnati, cartelli mai controllati) distingue il dato che
  /// manca da uno stato davvero in regola, che qui sarebbe verde e
  /// ingannevole.
  Widget _badgeDocumentiDipendente(
    AppLocalizations l10n,
    DocumentiProvider documentiProvider,
    DipendenteSubappaltatore dipendente,
  ) {
    final documenti = documentiProvider.soloUltimaVersione(
      documentiProvider.perDipendente(dipendente.id),
    );
    if (documenti.isEmpty) {
      return Tooltip(
        message: l10n.subappaltatoreDocumentiScreenNoDeadlinesRegistered,
        child: const StatoBadge(
          stato: StatoScadenza.valido,
          showLabel: false,
          colorOverride: Colors.grey,
        ),
      );
    }
    final stato = statoPeggioreTra(documenti
        .map((d) => computeStato(d.dataScadenza, giorniPreavviso: d.giorniPreavviso)));
    return Tooltip(
      // Meglio i nomi dei documenti che non vanno bene di un generico "almeno
      // uno scaduto": si capisce cosa manca senza aprire il dipendente.
      message: tooltipDocumentiCritici(documenti) ?? l10n.subappaltatoreDocumentiScreenDocsInOrder,
      child: StatoBadge(stato: stato, showLabel: false),
    );
  }

  /// Riga dell'anagrafica: etichetta in grassetto, valore in peso normale.
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final primaryBlue = Theme.of(context).colorScheme.primary;
    final isMobile = MediaQuery.sizeOf(context).width < kMobileAppBarBreakpoint;
    final cantieriProvider = context.watch<CantieriProvider>();
    final subappaltatoriProvider = context.watch<SubappaltatoriProvider>();
    final documentiProvider = context.watch<DocumentiProvider>();
    final dipendentiProvider = context.watch<DipendentiSubappaltatoriProvider>();
    final tipiScadenzeProvider = context.watch<TipiScadenzeProvider>();
    final authProvider = context.watch<AuthProvider>();

    final trovati =
        subappaltatoriProvider.subappaltatori.where((s) => s.id == subappaltatoreId);
    if (trovati.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final Subappaltatore subappaltatore = trovati.first;

    final cantieri = cantieriProvider.cantieri
        .where((c) => subappaltatore.cantieriIds.contains(c.id))
        .toList()
      ..sort((a, b) => a.nome.compareTo(b.nome));

    final documentiGenerali = documentiPerUrgenza(
      documentiProvider.soloUltimaVersione(
        documentiProvider
            .perSubappaltatoreTutti(subappaltatoreId)
            .where((d) => d.cantiereId.isEmpty)
            .toList(),
      ),
    );

    final dipendenti = dipendentiProvider.perSubappaltatore(subappaltatoreId)
      ..sort((a, b) {
        final perCognome = a.cognome.compareTo(b.cognome);
        return perCognome != 0 ? perCognome : a.nome.compareTo(b.nome);
      });

    return Scaffold(
      appBar: BreadcrumbAppBar(
        items: [
          BreadcrumbItem(label: l10n.subappaltatoreDocumentiScreenBreadcrumbCantieri, onTap: () => context.go('/cantieri')),
          BreadcrumbItem(
            label: l10n.subappaltatoreDocumentiScreenBreadcrumbSubappaltatori,
            onTap: () => vaiRicostruendoStack(
              context,
              const ['/cantieri', '/subappaltatori'],
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
                      Text(l10n.subappaltatoreDocumentiScreenInfoLabel, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18, color: primaryBlue)),
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
                  VoceInfo(l10n.subappaltatoreDocumentiScreenVatLabel, subappaltatore.partitaIva),
                  if (subappaltatore.email.isNotEmpty)
                    VoceInfo(l10n.subappaltatoreDocumentiScreenEmailLabel, subappaltatore.email),
                  if (subappaltatore.note.isNotEmpty)
                    VoceInfo(l10n.commonNoteLabel, subappaltatore.note),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            runSpacing: 8,
            children: [
              Text(l10n.subappaltatoreDocumentiScreenEmployeesLabel, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18, color: primaryBlue)),
              isMobile
                ? IconButton(
                    tooltip: l10n.subappaltatoreDocumentiScreenAddEmployeeLabel,
                    icon: Icon(Icons.person_add, color: primaryBlue, size: 20),
                    onPressed: () => showDipendenteSubappaltatoreFormDialog(
                      context,
                      provider: dipendentiProvider,
                      subappaltatoreId: subappaltatoreId,
                    ),
                  )
                : TextButton.icon(
                    icon: const Icon(Icons.person_add),
                    label: Text(l10n.subappaltatoreDocumentiScreenAddEmployeeLabel),
                    onPressed: () => showDipendenteSubappaltatoreFormDialog(
                      context,
                      provider: dipendentiProvider,
                      subappaltatoreId: subappaltatoreId,
                    ),
                  ),
            ],
          ),
          if (dipendenti.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(l10n.subappaltatoreDocumentiScreenNoEmployees, style: const TextStyle(fontSize: 15),),
            )
          else
              Card(
                child: Column(
                  children: [
                    ...ListTile.divideTiles(
                      context: context,
                      color: Colors.blueGrey.shade200,
                      tiles: dipendenti.map(
                        (dipendente) => ListTile(
                          leading: _badgeDocumentiDipendente(
                            l10n,
                            documentiProvider,
                            dipendente,
                          ),
                          title: Text(
                            dipendente.lavoratoreAutonomo
                                ? '${dipendente.nomeCompleto} - ${l10n.subappaltatoreDocumentiScreenSelfEmployed}'
                                : dipendente.nomeCompleto,
                            style: const TextStyle(fontWeight: FontWeight.w600),),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (dipendente.lavoratoreAutonomo) VoceInfo(l10n.subappaltatoreDocumentiScreenTypeLabel, l10n.subappaltatoreDocumentiScreenSelfEmployed),
                              VoceInfo(l10n.subappaltatoreDocumentiScreenAssociatedSitesLabel, dipendente.cantieriIds.length.toString()),
                              if (dipendente.note.isNotEmpty) VoceInfo(l10n.commonNoteLabel, dipendente.note),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                tooltip: l10n.subappaltatoreDocumentiScreenDeleteEmployeeTooltip,
                                icon: Icon(
                                  Icons.delete_outline,
                                  color: primaryBlue,
                                  size: isMobile ? 18 : 22,
                                ),
                                onPressed: () => _eliminaDipendente(context, dipendente),
                              ),
                              Icon(Icons.chevron_right, color: primaryBlue, size: isMobile ? 18 : 22),
                            ],
                          ),
                          onTap: () => context.push(
                              '/subappaltatori/$subappaltatoreId/dipendenti/${dipendente.id}'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          const SizedBox(height: 32),
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            runSpacing: 8,
            children: [
              Text(l10n.subappaltatoreDocumentiScreenGeneralDeadlinesLabel, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18, color: primaryBlue)),
              isMobile
                ? IconButton(
                    tooltip: l10n.subappaltatoreDocumentiScreenNewGeneralDeadlineTooltip,
                    icon: Icon(Icons.add_outlined, color: primaryBlue, size: 20),
                    onPressed: () => showDocumentFormDialog(
                      context,
                      documentiProvider: documentiProvider,
                      tipiScadenzeProvider: tipiScadenzeProvider,
                      caricatoDaId: authProvider.currentUser?.id ?? '',
                      subappaltatoreId: subappaltatoreId,
                    ),
                  )
                : TextButton.icon(
                    icon: const Icon(Icons.add_outlined),
                    label: Text(l10n.subappaltatoreDocumentiScreenAddGeneralDeadlineLabel),
                    onPressed: () => showDocumentFormDialog(
                      context,
                      documentiProvider: documentiProvider,
                      tipiScadenzeProvider: tipiScadenzeProvider,
                      caricatoDaId: authProvider.currentUser?.id ?? '',
                      subappaltatoreId: subappaltatoreId,
                    ),
                  ),
            ],
          ),
          if (documentiGenerali.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(l10n.subappaltatoreDocumentiScreenNoGeneralDeadlines, style: const TextStyle(fontSize: 15)),
            )
          else
            Card(
              child: Column(
                children: ListTile.divideTiles(
                  context: context,
                  color: Colors.blueGrey.shade200,
                  tiles: documentiGenerali.map((d) => DocumentoTile(
                        documento: d,
                        documentiProvider: documentiProvider,
                      )),
                ).toList(),
              )
            ),
          if (cantieri.isNotEmpty) ... [
            const SizedBox(height: 32),
            Text(l10n.subappaltatoreDocumentiScreenAssociatedSitesLabel, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18, color: primaryBlue)),
          /*
          if (cantieri.isEmpty && documentiGenerali.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Text('Nessuna scadenza e nessun cantiere associato.'),
            ),
          */
            for (final (index, cantiere) in cantieri.indexed) ...[
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                runSpacing: 8,
                children: [
                  Text(l10n.subappaltatoreDocumentiScreenSiteIndexTitle(index + 1, cantiere.nome), style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                  isMobile
                    ? IconButton(
                        tooltip: l10n.subappaltatoreDocumentiScreenOpenSiteTooltip,
                        icon: Icon(Icons.arrow_forward, color: primaryBlue, size: 20),
                        onPressed:() => context.push('/cantieri/${cantiere.id}/subappaltatori/$subappaltatoreId'),
                      )
                    : TextButton.icon(
                        icon: const Icon(Icons.arrow_forward),
                        label: Text(l10n.subappaltatoreDocumentiScreenOpenSiteTooltip),
                        onPressed: () =>
                            context.push('/cantieri/${cantiere.id}/subappaltatori/$subappaltatoreId'),
                      ),

                ],
              ),
              const SizedBox(height: 8),
              Builder(builder: (context) {
                final documentiCantiere = documentiPerUrgenza(
                  documentiProvider.soloUltimaVersione(
                    documentiProvider.perSubappaltatore(cantiere.id, subappaltatoreId),
                  ),
                );
                if (documentiCantiere.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(l10n.subappaltatoreDocumentiScreenNoDeadlinesForSite),
                  );
                }
                return Card(
                  child: Column(
                    children: ListTile.divideTiles(
                      context: context,
                      color: Colors.blueGrey.shade200,
                      tiles: documentiCantiere.map((d) => DocumentoTile(
                            documento: d,
                            documentiProvider: documentiProvider,
                            condiviso: d.isDocumentoSubappaltatoreGenerale,
                          )),
                    ).toList(),
                  ),
                );
              }),
              const SizedBox(height: 24),
            ],
          ]
        ],
      ),
    );
  }
}
