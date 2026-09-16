import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../models/cantiere.dart';
import '../models/dipendente_subappaltatore.dart';
import '../models/subappaltatore.dart';
import '../providers/auth_provider.dart';
import '../providers/cantieri_provider.dart';
import '../providers/dipendenti_subappaltatori_provider.dart';
import '../providers/documenti_provider.dart';
import '../providers/subappaltatori_provider.dart';
import '../providers/tipi_scadenze_provider.dart';
import '../services/stato_scadenze.dart';
import '../widgets/app_bar.dart';
import '../widgets/breadcrumb_app_bar.dart';
import '../widgets/dipendente_subappaltatore_form_dialog.dart';
import '../widgets/document_form_dialog.dart';
import '../widgets/documento_tile.dart';
import '../widgets/voce_info.dart';

class DipendenteSubappaltatoreDetailScreen extends StatelessWidget {
  const DipendenteSubappaltatoreDetailScreen({
    super.key,
    this.subappaltatoreId,
    required this.dipendenteId,
  });

  final String? subappaltatoreId;
  final String dipendenteId;

  bool get _isInterno => subappaltatoreId == null || subappaltatoreId!.isEmpty;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final primaryBlue = Theme.of(context).primaryColor;
    final isMobile = MediaQuery.sizeOf(context).width < kMobileAppBarBreakpoint;
    final subappaltatoriProvider = context.watch<SubappaltatoriProvider>();
    final cantieriProvider = context.watch<CantieriProvider>();
    final dipendentiProvider = context.watch<DipendentiSubappaltatoriProvider>();
    final documentiProvider = context.watch<DocumentiProvider>();
    final tipiScadenzeProvider = context.watch<TipiScadenzeProvider>();
    final authProvider = context.watch<AuthProvider>();

    final dipendentiTrovati =
        dipendentiProvider.dipendenti.where((d) => d.id == dipendenteId);
    final subappaltatoriTrovati =
        subappaltatoriProvider.subappaltatori.where((s) => s.id == subappaltatoreId);
    final Subappaltatore? subappaltatore =
        _isInterno ? null : (subappaltatoriTrovati.isEmpty ? null : subappaltatoriTrovati.first);
    if ((!_isInterno && subappaltatore == null) || dipendentiTrovati.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final DipendenteSubappaltatore dipendente = dipendentiTrovati.first;

    final documenti = documentiPerUrgenza(
      documentiProvider.soloUltimaVersione(
        documentiProvider.perDipendente(dipendenteId),
      ),
    );
    final cantieriDelSubappaltatore = subappaltatore == null
        ? <Cantiere>[]
        : cantieriProvider.cantieri
            .where((c) => subappaltatore.cantieriIds.contains(c.id))
            .toList()
      ..sort((a, b) => a.nome.compareTo(b.nome));

    /// Casella di presenza in un cantiere: il nome è in grassetto quando il
    /// dipendente vi risulta presente, così lo stato si legge anche senza
    /// guardare la spunta.
    Widget voceCantiere(Cantiere cantiere) {
      final selezionato = dipendente.cantieriIds.contains(cantiere.id);
      return CheckboxListTile(
        dense: false,
        title: Text(
          cantiere.nome,
          style: TextStyle(fontWeight: selezionato ? FontWeight.w600 : FontWeight.w500),
        ),
        value: selezionato,
        onChanged: (checked) async {
          if (checked ?? false) {
            await dipendentiProvider.addCantiere(dipendente.id, cantiere.id);
          } else {
            await dipendentiProvider.removeCantiere(dipendente.id, cantiere.id);
          }
        },
      );
    }

    return Scaffold(
      appBar: BreadcrumbAppBar(
        items: [
          BreadcrumbItem(
            label: l10n.dipendenteSubappaltatoreDetailScreenCantieri,
            onTap: () => context.go('/cantieri'),
          ),
          BreadcrumbItem(
            label: l10n.dipendenteSubappaltatoreDetailScreenSubappaltatori,
            onTap: () => vaiRicostruendoStack(
              context,
              const ['/cantieri', '/subappaltatori'],
            ),
          ),
          BreadcrumbItem(
            label: subappaltatore?.ragioneSociale ??
                l10n.dipendenteSubappaltatoreDetailScreenDipendentiAziendali,
            onTap: () => vaiRicostruendoStack(context, [
              '/cantieri',
              '/subappaltatori',
              '/subappaltatori/$subappaltatoreId',
            ]),
          ),
          BreadcrumbItem(label: dipendente.nomeCompleto),
        ],
        actions: [
          AppBarAction(
            icon: Icons.edit,
            label: l10n.commonEdit,
            onPressed: () => showDipendenteSubappaltatoreFormDialog(
              context,
              provider: dipendentiProvider,
              subappaltatoreId: subappaltatoreId,
              esistente: dipendente,
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (dipendente.note.isNotEmpty || dipendente.lavoratoreAutonomo) ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 5, 10, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(l10n.dipendenteSubappaltatoreDetailScreenInformazioni,
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 18, color: primaryBlue)),
                        IconButton(
                          icon: Icon(Icons.edit, color: primaryBlue, size: isMobile ? 18 : 22),
                          onPressed: () => showDipendenteSubappaltatoreFormDialog(
                            context,
                            provider: dipendentiProvider,
                            subappaltatoreId: subappaltatoreId,
                            esistente: dipendente,
                          ),
                        ),
                      ],
                    ),
                    if (dipendente.lavoratoreAutonomo)
                      VoceInfo(
                        l10n.dipendenteSubappaltatoreDetailScreenTipo,
                        l10n.dipendenteSubappaltatoreDetailScreenLavoratoreAutonomo,
                      ),
                    if (dipendente.note.isNotEmpty)
                      VoceInfo(l10n.commonNoteLabel, dipendente.note),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
          if (subappaltatore != null) ...[
            Text(l10n.dipendenteSubappaltatoreDetailScreenCantieri, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18, color: primaryBlue)),
            const SizedBox(height: 4),
            if (cantieriDelSubappaltatore.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(l10n.dipendenteSubappaltatoreDetailScreenNessunCantiere),
              )
            else
              Card(
                child: Column(
                  children: [
                    ...ListTile.divideTiles(
                        context: context,
                        color: Colors.blueGrey.shade200,
                        tiles: cantieriDelSubappaltatore.map((c) => voceCantiere(c))
                    )
                  ]
                ),
              ),
            const SizedBox(height: 24),
          ],
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            runSpacing: 8,
            children: [
              Text(l10n.dipendenteSubappaltatoreDetailScreenScadenzeDocumenti,
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18, color: primaryBlue)),
              TextButton.icon(
                icon: const Icon(Icons.add),
                label: Text(l10n.dipendenteSubappaltatoreDetailScreenAggiungiScadenza),
                onPressed: () => showDocumentFormDialog(
                  context,
                  documentiProvider: documentiProvider,
                  tipiScadenzeProvider: tipiScadenzeProvider,
                  caricatoDaId: authProvider.currentUser?.id ?? '',
                  dipendenteId: dipendenteId,
                  lavoratoreAutonomo: dipendente.lavoratoreAutonomo,
                ),
              ),
            ],
          ),
          if (documenti.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(l10n.dipendenteSubappaltatoreDetailScreenNessunaScadenza),
            )
          else
            Card(
              child: Column(
                children: ListTile.divideTiles(
                  context: context,
                  color: Colors.blueGrey.shade200,
                  tiles: documenti
                    .map((d) => DocumentoTile(documento: d, documentiProvider: documentiProvider))
                ).toList(),
              ),
            ),
        ],
      ),
    );
  }
}
