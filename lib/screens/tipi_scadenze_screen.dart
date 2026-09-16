import 'package:flutter/material.dart';
import 'package:gestionale_edile/models/tipo_scadenza.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../providers/tipi_scadenze_provider.dart';
import '../widgets/tipo_scadenza_form_dialog.dart';
import '../widgets/confirm_dialog.dart';
import '../widgets/app_bar.dart' show kMobileAppBarBreakpoint;
import '../widgets/responsive_card_grid.dart';
import '../widgets/voce_info.dart';

class TipiScadenzeScreen extends StatefulWidget {
  const TipiScadenzeScreen({super.key});

  @override
  State<TipiScadenzeScreen> createState() => _TipiScadenzeScreenState();
}

class _TipiScadenzeScreenState extends State<TipiScadenzeScreen> {
  final _searchController = TextEditingController();
  String _query = '';
  bool _loaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_loaded) {
      final tipiScadenzeProvider = context.read<TipiScadenzeProvider>();
      _loaded = true;
      Future.microtask(() {
        tipiScadenzeProvider.load();
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

    final tipoProvider = context.watch<TipiScadenzeProvider>();
    final erroreCaricamento = tipoProvider.errorMessage;

    final isMobile = MediaQuery.sizeOf(context).width < kMobileAppBarBreakpoint;
    final query = _query.trim().toLowerCase();
    final tipiFiltrati = tipoProvider.tipiScadenze
        .where(
          (t) =>
              query.isEmpty ||
              t.nome.toLowerCase().contains(query)
        ).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: primaryBlue,
        elevation: 1,
        surfaceTintColor: Colors.transparent,
        title: Text(
          l10n.tipiScadenzeScreenTitle,
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: isMobile ? 20 : 25),
        ),
        actions: [
          isMobile
              ? IconButton(
                  icon: const Icon(Icons.add),
                  tooltip: l10n.tipiScadenzeScreenNuovaTipologia,
                  onPressed: () => showTipoScadenzaFormDialog(
                    context,
                    provider: tipoProvider
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.fromLTRB(20, 15, 10, 10),
                  child: TextButton.icon(
                    onPressed: () => showTipoScadenzaFormDialog(
                      context,
                      provider: tipoProvider
                    ),
                    icon: const Icon(Icons.add),
                    label: Text(l10n.tipiScadenzeScreenNuovaTipologia),
                  ),
                ),
        ]
      ),
      body: tipoProvider.isLoading && tipoProvider.tipiScadenze.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async {
                await Future.wait([
                  tipoProvider.load(),
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
                        hintText: l10n.tipiScadenzeScreenSearchHint,
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
                    if (tipiFiltrati.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        child: Center(
                          child: Text(
                            tipoProvider.tipiScadenze.isEmpty
                                ? l10n.tipiScadenzeScreenNessunaTipologiaCaricata
                                : l10n.tipiScadenzeScreenNessunaTipologiaTrovata(_query.trim()),
                          ),
                        ),
                      )
                    else 
                      ColumnsCardGrid(
                        maxColumns: 3,
                        minWidth: 380,
                        altezzaUniforme: true,
                        children: tipiFiltrati.map((t) {
                          return _TipoScadenzaCard(tipologia: t);
                        }).toList()
                      )
                  ]

            )
          )
    );
  }
}

class _TipoScadenzaCard extends StatelessWidget {
  const _TipoScadenzaCard({required this.tipologia});

  final TipoScadenza tipologia;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final primaryBlue = Theme.of(context).primaryColor;
    final provider = context.watch<TipiScadenzeProvider>();
    final isMobile = MediaQuery.sizeOf(context).width < kMobileAppBarBreakpoint;
    final descrizione = _descrizioneAppartenenza(tipologia, l10n);


    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(tipologia.nome, style: const TextStyle(fontWeight: FontWeight.w700)
        ),
        isThreeLine: tipologia.note.isNotEmpty,
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            VoceInfo(
              l10n.tipiScadenzeScreenRichiedeScadenza,
              tipologia.richiedeScadenza ? l10n.commonYes : l10n.commonNo,
            ),
            if (tipologia.richiedeScadenza)
              tipologia.avvisaDopoScadenza
                  ? VoceInfo(l10n.tipiScadenzeScreenAvviso, l10n.tipiScadenzeScreenAvvisoDalGiorno)
                  : VoceInfo(
                      l10n.tipiScadenzeScreenPreavviso,
                      l10n.tipiScadenzeScreenGiorniPreavviso(tipologia.giorniPreavviso.join(', ')),
                    ),
            VoceInfo(l10n.tipiScadenzeScreenCollegatoA, descrizione),
            if (tipologia.note.isNotEmpty) VoceInfo(l10n.commonNoteLabel, tipologia.note)
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit_outlined, color: primaryBlue, size: isMobile ? 18 : 22),
              tooltip: l10n.tipiScadenzeScreenModificaTipologia,
              onPressed: () => showTipoScadenzaFormDialog(
                context,
                provider: provider,
                esistente: tipologia,
              ),
            ),
            IconButton(
              icon: Icon(Icons.delete_outlined, color: primaryBlue, size: isMobile ? 18 : 22),
              tooltip: l10n.tipiScadenzeScreenEliminaTipologia,
              onPressed: () async {
                final confermato = await showConfirmDialog(
                  context,
                  title: l10n.tipiScadenzeScreenEliminareTitle,
                  message: l10n.tipiScadenzeScreenEliminareMessage(tipologia.nome),
                );
                if (!confermato) return;
                try {
                  await provider.delete(tipologia.id);
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(l10n.commonErrorWithDetails(e.toString()))),
                    );
                  }
                }
              }
            )
          ]
        ),
      ),
    );
  }
}

/// Elenco leggibile delle appartenenze della tipologia, es. "Cantiere e
/// Subappaltatore". Le tipologie dei dipendenti valgono anche per i
/// lavoratori autonomi, quindi in quel caso l'eredità va detta, altrimenti
/// sembrerebbe che a un autonomo non si possano assegnare.
String _descrizioneAppartenenza(TipoScadenza tipologia, AppLocalizations l10n) {
  final voci = [
    if (tipologia.appartieneCantiere) l10n.tipiScadenzeScreenCantiere,
    if (tipologia.appartieneSubappaltatore) l10n.tipiScadenzeScreenSubappaltatore,
    if (tipologia.appartieneDipendente)
      tipologia.appartieneLavoratoreAutonomo
          ? l10n.tipiScadenzeScreenDipendenteSubappaltatore
          : l10n.tipiScadenzeScreenDipendenteSubappaltatoreAutonomo,
    if (tipologia.appartieneLavoratoreAutonomo) l10n.tipiScadenzeScreenLavoratoreAutonomo,
  ];
  if (voci.isEmpty) return '';
  if (voci.length == 1) return voci.first;
  return l10n.tipiScadenzeScreenElencoFinale(
    voci.sublist(0, voci.length - 1).join(', '),
    voci.last,
  );
}
