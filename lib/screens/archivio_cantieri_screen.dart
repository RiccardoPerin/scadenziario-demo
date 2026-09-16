import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../providers/cantieri_provider.dart';
import '../providers/subappaltatori_provider.dart';
import '../services/eliminazione_cascata.dart';
import '../widgets/cantiere_card.dart';
import '../widgets/cantiere_form_dialog.dart';
import '../widgets/confirm_dialog.dart';
import '../widgets/responsive_card_grid.dart';
import '../widgets/stato_badge.dart';

class ArchivioCantieriScreen extends StatefulWidget {
  const ArchivioCantieriScreen({super.key});

  @override
  State<ArchivioCantieriScreen> createState() => _ArchivioCantieriScreenState();
}

class _ArchivioCantieriScreenState extends State<ArchivioCantieriScreen> {
  final _searchController = TextEditingController();
  String _query = '';
  bool _loaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_loaded) {
      final subappaltatoriProvider = context.read<SubappaltatoriProvider>();
      final cantieriProvider = context.read<CantieriProvider>();
      _loaded = true;
      Future.microtask(() {
        subappaltatoriProvider.load();
        cantieriProvider.load();
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
    final l10n = AppLocalizations.of(context)!;
    final primaryBlue = Theme.of(context).colorScheme.primary;
    final cantieriProvider = context.watch<CantieriProvider>();
    final subappaltatoriProvider = context.watch<SubappaltatoriProvider>();
    
    final erroreCaricamento = subappaltatoriProvider.errorMessage ?? cantieriProvider.errorMessage;

    final cantieriArchiviati =
        cantieriProvider.cantieri.where((c) => c.stato == 'concluso').toList();
    final isMobile = MediaQuery.sizeOf(context).width < 640;

    final query = _query.toLowerCase().trim();
    final cantieriArchiviatiFiltrati = cantieriArchiviati
        .where(
          (c) =>
              query.isEmpty ||
              c.nome.toLowerCase().contains(query) ||
              c.comune.toLowerCase().contains(query) ||
              c.indirizzo.toLowerCase().contains(query)
        )
        .toList();

    Future<void> eliminaTutti() async {
      final confermato = await showConfirmDialog(
        context,
        title: l10n.archivioCantieriScreenEliminareTuttiTitle,
        message: l10n.archivioCantieriScreenEliminareTuttiMessage,
      );
      if (confermato && context.mounted) {
        await eliminaCantieriConTracce(
          context,
          cantieriArchiviati.map((c) => c.id).toList(),
        );
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: primaryBlue,
        elevation: 1,
        surfaceTintColor: Colors.transparent,
        title: Text(
          l10n.archivioCantieriScreenTitle,
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: isMobile ? 20 : 25),
        ),
        actions: [
          isMobile
              ? IconButton(
                  icon: const Icon(Icons.delete_forever, color: Colors.redAccent, size: 20,),
                  tooltip: l10n.archivioCantieriScreenEliminaCantieriArchiviatiTooltip,
                  onPressed: cantieriArchiviati.isEmpty ? null : eliminaTutti,
                )
              : Padding(
                  padding: const EdgeInsets.fromLTRB(20, 15, 10, 10),
                  child: TextButton.icon(
                    onPressed: cantieriArchiviati.isEmpty ? null : eliminaTutti,
                    label: Text(l10n.archivioCantieriScreenEliminaCantieriLabel, style: const TextStyle(color: Colors.redAccent)),
                    icon: const Icon(Icons.delete_forever, color: Colors.redAccent),
                  ),
                ),
        ],
      ),
      body: cantieriProvider.isLoading && subappaltatoriProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : cantieriArchiviati.isEmpty
              ? Center(
                  child: Text(l10n.archivioCantieriScreenNessunCantiereArchiviato, style: const TextStyle(fontSize: 22))
                )
              : RefreshIndicator(
                    onRefresh: () async {
                        await cantieriProvider.load();
                        await subappaltatoriProvider.load();
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
                        Text(
                          l10n.archivioCantieriScreenCantieriConclusi,
                          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 22, color: primaryBlue),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            prefixIcon: Icon(Icons.search, color: primaryBlue),
                            hintText: l10n.archivioCantieriScreenCercaHint,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide.none
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(
                                color: Colors.black54,
                                width: 1
                              )
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(color: primaryBlue, width: 2),
                            ),
                          ),
                          onChanged: (v) => setState(() => _query = v),
                        ),
                        const SizedBox(height: 20),
                        if (cantieriArchiviatiFiltrati.isEmpty) 
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 24),
                            child: Center(
                              child: Text(
                                  cantieriArchiviati.isEmpty
                                      ? l10n.archivioCantieriScreenNessunCantiereConcluso
                                      : l10n.archivioCantieriScreenNessunCantiereTrovato(_query.trim()),
                              ),
                            ),
                          )
                        else 
                          SingleChildScrollView(
                            child: ResponsiveCardGrid(
                              children: cantieriArchiviatiFiltrati.map((cantiere) {
                                return SizedBox(
                                  height: 240,
                                  child: CantiereCard(
                                    nome: cantiere.nome,
                                    comune: cantiere.comune,
                                    stato: StatoScadenza.valido,
                                    numeroSubappaltatori:
                                        subappaltatoriProvider.perCantiere(cantiere.id).length,
                                    numeroDocumentiInScadenza: 0,
                                    dataChiusura: cantiere.dataFine,
                                    statoCantiere: cantiere.stato,
                                    onTap: () => context.push('/cantieri/${cantiere.id}'),
                                    onEdit: () => showCantiereFormDialog(
                                      context,
                                      provider: cantieriProvider,
                                      esistente: cantiere,
                                    ),
                                    onDelete: () async {
                                      final confermato = await showConfirmDialog(
                                        context,
                                        title: l10n.archivioCantieriScreenEliminareCantiereTitle,
                                        message: l10n.archivioCantieriScreenEliminareCantiereMessage(cantiere.nome),
                                      );
                                      if (confermato && context.mounted) {
                                        await eliminaCantiereConTracce(context, cantiere.id);
                                      }
                                    },
                                  ),
                                );
                              }).toList(),
                            )
                          )
                      ]
                    ),
                  )
    );
  }
}
