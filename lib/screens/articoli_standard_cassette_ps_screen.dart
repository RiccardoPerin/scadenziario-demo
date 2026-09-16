import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../models/articolo_standard_cassetta_ps.dart';
import '../providers/articoli_standard_cassette_ps_provider.dart';
import '../widgets/articolo_standard_cassetta_ps_form_dialog.dart';
import '../widgets/breadcrumb_app_bar.dart';
import '../widgets/confirm_dialog.dart';
import '../widgets/responsive_card_grid.dart';
import '../widgets/app_bar.dart' show kMobileAppBarBreakpoint;

const _tipologie = ['Cassetta', 'Pacchetto di Medicazione'];

/// Etichetta leggibile per la [tipologia] (la chiave resta in italiano
/// perché usata anche come valore salvato su [ArticoloStandardCassettaPs]).
String _tipologiaLabel(AppLocalizations l10n, String tipologia) {
  switch (tipologia) {
    case 'Cassetta':
      return l10n.articoliStandardCassettePsScreenTipoCassetta;
    case 'Pacchetto di Medicazione':
      return l10n.articoliStandardCassettePsScreenTipoPacchettoMedicazione;
    default:
      return tipologia;
  }
}

class ArticoliStandardCassettePsScreen extends StatefulWidget {
  const ArticoliStandardCassettePsScreen({super.key});

  @override
  State<ArticoliStandardCassettePsScreen> createState() =>
      _ArticoliStandardCassettePsScreenState();
}

class _ArticoliStandardCassettePsScreenState
    extends State<ArticoliStandardCassettePsScreen> {
  bool _loaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_loaded) {
      _loaded = true;
      final provider = context.read<ArticoliStandardCassettePsProvider>();
      Future.microtask(() => provider.load());
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final provider = context.watch<ArticoliStandardCassettePsProvider>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: BreadcrumbAppBar(
        items: [
          BreadcrumbItem(label: l10n.articoliStandardCassettePsScreenBreadcrumbFirstAid, onTap: () => context.pop()),
          BreadcrumbItem(label: l10n.articoliStandardCassettePsScreenBreadcrumbStandardProducts),
        ],
      ),
      body: provider.isLoading && provider.articoli.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(24),
              children: [
                if (provider.errorMessage != null) ...[
                  Card(
                    color: Theme.of(context).colorScheme.errorContainer,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          const Icon(Icons.error_outline),
                          const SizedBox(width: 8),
                          Expanded(child: Text(provider.errorMessage!)),
                        ],
                      ),
                    ),
                  ),
                ],
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    l10n.articoliStandardCassettePsScreenDescription,
                    style: const TextStyle(color: Colors.black54),
                  ),
                ),
                ColumnsCardGrid(
                  maxColumns: 2,
                  minWidth: 420,
                  children: _tipologie.map((tipologia) {
                    return _SezioneTipologia(
                      tipologia: tipologia,
                      articoli: provider.perTipologia(tipologia),
                      provider: provider,
                    );
                  }).toList(),
                ),
              ],
            ),
    );
  }
}

class _SezioneTipologia extends StatelessWidget {
  const _SezioneTipologia({
    required this.tipologia,
    required this.articoli,
    required this.provider,
  });

  final String tipologia;
  final List<ArticoloStandardCassettaPs> articoli;
  final ArticoliStandardCassettePsProvider provider;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final primaryBlue = Theme.of(context).colorScheme.primary;
    final isMobile = MediaQuery.sizeOf(context).width < kMobileAppBarBreakpoint;
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text(_tipologiaLabel(l10n, tipologia), style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 20)),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!isMobile) ... [
                  TextButton.icon(
                    icon: Icon(Icons.add, color: primaryBlue, size: isMobile ? 18 : 22),
                    label: Text(l10n.articoliStandardCassettePsScreenAddProduct, style: TextStyle(color: primaryBlue),),
                    onPressed: () => showArticoloStandardCassettaPsFormDialog(
                      context,
                      provider: provider,
                      tipologiaIniziale: tipologia,
                    ),
                  ),
                ]
                else ... [
                  IconButton(
                    onPressed: () => showArticoloStandardCassettaPsFormDialog(
                      context,
                      provider: provider,
                      tipologiaIniziale: tipologia,
                    ),
                    icon: Icon(Icons.add, color: primaryBlue, size: isMobile ? 18 : 22)
                  )
                ],
              ],
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 400),
            alignment: Alignment.topCenter,
            child: articoli.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(l10n.articoliStandardCassettePsScreenEmpty, style: const TextStyle(color: Colors.black54)),
                      )
                    : Padding(
                        padding: EdgeInsets.fromLTRB(16, 12, 16, 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Divider(height: 1, color: Color(0xFFE0E0E0)),
                            const SizedBox(height: 12),
                            Text(l10n.articoliStandardCassettePsScreenContentSection, style: TextStyle(fontWeight: FontWeight.w600, color: primaryBlue, fontSize: 15)),
                            const SizedBox(height: 8),
                            for (var i = 0; i < articoli.length; i++) ...[
                              if (i > 0) const Divider(height: 1, color: Color(0xFFE0E0E0)),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Text(
                                      articoli[i].quantita.isEmpty
                                          ? articoli[i].nomeProdotto
                                          : '${articoli[i].nomeProdotto} (${articoli[i].quantita})',
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.edit_outlined, color: primaryBlue, size: isMobile ? 18 : 22),
                                    visualDensity: VisualDensity.compact,
                                    tooltip: l10n.articoliStandardCassettePsScreenEditTooltip,
                                    onPressed: () => showArticoloStandardCassettaPsFormDialog(
                                      context,
                                      provider: provider,
                                      esistente: articoli[i],
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete_outline, color: primaryBlue, size: isMobile ? 18 : 22),
                                    visualDensity: VisualDensity.compact,
                                    tooltip: l10n.articoliStandardCassettePsScreenDeleteTooltip,
                                    onPressed: () async {
                                      final confermato = await showConfirmDialog(
                                        context,
                                        title: l10n.articoliStandardCassettePsScreenDeleteConfirmTitle,
                                        message: l10n.articoliStandardCassettePsScreenDeleteConfirmMessage(articoli[i].nomeProdotto),
                                      );
                                      if (confermato) await provider.delete(articoli[i].id);
                                    },
                                  ),
                                ],
                              ),
                            ]
                          ]
                        )
                    )
          )
        ]
      )
    );
  }
}