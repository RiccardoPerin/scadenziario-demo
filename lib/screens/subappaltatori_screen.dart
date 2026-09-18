import 'package:flutter/material.dart';
import 'package:gestionale_edile/models/subappaltatore.dart';
import 'package:gestionale_edile/widgets/responsive_card_grid.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../providers/cantieri_provider.dart';
import '../providers/dipendenti_subappaltatori_provider.dart';
import '../providers/documenti_provider.dart';
import '../providers/subappaltatori_provider.dart';
import '../services/eliminazione_cascata.dart';
import '../services/stato_scadenze.dart';
import '../widgets/confirm_dialog.dart';
import '../widgets/stato_badge.dart';
import '../widgets/subappaltatore_form_dialog.dart';
import '../widgets/voce_info.dart';
import '../widgets/app_bar.dart' show kMobileAppBarBreakpoint;

class SubappaltatoriScreen extends StatefulWidget {
  const SubappaltatoriScreen({super.key});

  @override
  State<SubappaltatoriScreen> createState() => _SubappaltatoriScreenState();
}

class _SubappaltatoriScreenState extends State<SubappaltatoriScreen> {
  final _searchController = TextEditingController();
  String _query = '';
  bool _loaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_loaded) {
      final subappaltatoriProvider = context.read<SubappaltatoriProvider>();
      _loaded = true;
      Future.microtask(() {
        subappaltatoriProvider.load();
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryBlue = Theme.of(context).colorScheme.primary;
    final isMobile = MediaQuery.sizeOf(context).width < kMobileAppBarBreakpoint;
    final l10n = AppLocalizations.of(context)!;

    final cantieriProvider = context.watch<CantieriProvider>();
    final subappaltatoriProvider = context.watch<SubappaltatoriProvider>();

    final erroreCaricamento = cantieriProvider.errorMessage ?? subappaltatoriProvider.errorMessage;
    final query = _query.trim().toLowerCase();
    final subappaltatoriFiltrati = subappaltatoriProvider.subappaltatori
        .where(
          (s) =>
              query.isEmpty ||
              s.ragioneSociale.toLowerCase().contains(query)
        ).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: primaryBlue,
        elevation: 1,
        surfaceTintColor: Colors.transparent,
        title: Text(
          l10n.subappaltatoriScreenTitle,
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: isMobile ? 20 : 25),
        ),
        actions: [
          isMobile
              ? IconButton(
                  icon: const Icon(Icons.add),
                  tooltip: l10n.subappaltatoriScreenNewTooltip,
                  onPressed: () => showSubappaltatoreFormDialog(
                    context,
                    provider: subappaltatoriProvider,
                    tuttiCantieri: cantieriProvider.cantieri
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.fromLTRB(20, 15, 10, 10),
                  child: TextButton.icon(
                    icon: const Icon(Icons.add),
                    label: Text(l10n.subappaltatoriScreenNewTooltip),
                    onPressed: () => showSubappaltatoreFormDialog(
                      context,
                      provider: subappaltatoriProvider,
                      tuttiCantieri: cantieriProvider.cantieri
                    ),
                  ),
                ),
        ]
      ),
      body: subappaltatoriProvider.isLoading && subappaltatoriProvider.subappaltatori.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async {
                await Future.wait([
                  subappaltatoriProvider.load(),
                  cantieriProvider.load(),
                  // Servono per il bollino di stato di ogni subappaltatore.
                  context.read<DocumentiProvider>().load(),
                  context.read<DipendentiSubappaltatoriProvider>().load(),
                ]);
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
                    const SizedBox(height: 8),
                    TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: Icon(Icons.search, color: primaryBlue),
                        hintText: l10n.subappaltatoriScreenSearchHint,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(color: Colors.black54, width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: primaryBlue, width: 2),
                        ),
                      ),
                      onChanged: (v) => setState(() => _query = v),
                    ),
                    const SizedBox(height: 20),
                    if (subappaltatoriFiltrati.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        child: Center(
                          child: Text(
                            subappaltatoriProvider.subappaltatori.isEmpty
                                ? l10n.subappaltatoriScreenEmptyLoaded
                                : l10n.subappaltatoriScreenEmptySearch(_query.trim()),
                          ),
                        ),
                      )
                    else 
                      ColumnsCardGrid(
                        maxColumns: 2,
                        minWidth: 380,
                        altezzaUniforme: true,
                        children: subappaltatoriFiltrati
                            .map((s) => _SubappaltatoreCard(subappaltatore: s))
                            .toList()
                      )
                  ]
              ),
            )
    );
  }
}

class _SubappaltatoreCard extends StatelessWidget {
  const _SubappaltatoreCard({required this.subappaltatore});

  final Subappaltatore subappaltatore;

  @override
  Widget build(BuildContext context) {
    final primaryBlue = Theme.of(context).colorScheme.primary;
    final isMobile = MediaQuery.sizeOf(context).width < kMobileAppBarBreakpoint;
    final l10n = AppLocalizations.of(context)!;
    final subappaltatoriProvider = context.watch<SubappaltatoriProvider>();
    final cantieriProvider = context.watch<CantieriProvider>();
    final documentiProvider = context.watch<DocumentiProvider>();
    final dipendentiProvider = context.watch<DipendentiSubappaltatoriProvider>();

    final numeroCantieri = subappaltatore.cantieriIds.length;
    final stato = statoScadenzaSubappaltatore(
      subappaltatore: subappaltatore,
      documentiProvider: documentiProvider,
      dipendenti: dipendentiProvider.dipendenti,
    );

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        onTap: () => context.push('/subappaltatori/${subappaltatore.id}'),
        leading: StatoBadge(stato: stato, showLabel: false),
        title: Text(
          subappaltatore.ragioneSociale,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            VoceInfo(l10n.subappaltatoriScreenSitesCount, numeroCantieri==0 ? l10n.subappaltatoriScreenNone : numeroCantieri.toString()),
            VoceInfo(l10n.subappaltatoriNumDipendenti, dipendentiProvider.perSubappaltatore(subappaltatore.id).length.toString()),
            if (subappaltatore.note != '')
              VoceInfo(l10n.commonNoteLabel, subappaltatore.note),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit_outlined, color: primaryBlue, size: isMobile ? 18 : 22),
              tooltip: l10n.subappaltatoriScreenEditTooltip,
              onPressed: () => showSubappaltatoreFormDialog(
                context,
                provider: subappaltatoriProvider,
                tuttiCantieri: cantieriProvider.cantieri,
                esistente: subappaltatore,
              ),
            ),
            IconButton(
              icon: Icon(Icons.delete_outline, color: primaryBlue, size: isMobile ? 18 : 22),
              tooltip: l10n.subappaltatoriScreenDeleteTooltip,
              onPressed: () async {
                final confermato = await showConfirmDialog(
                  context,
                  title: l10n.subappaltatoriScreenConfirmDeleteTitle,
                  message: l10n.subappaltatoriScreenConfirmDeleteMessage(subappaltatore.ragioneSociale),
                );
                if (confermato && context.mounted) {
                  await eliminaSubappaltatoreConTracce(context, subappaltatore.id);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}