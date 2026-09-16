import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../providers/tipi_dpi_provider.dart';
import '../widgets/app_bar.dart';
import '../widgets/breadcrumb_app_bar.dart';
import '../widgets/crea_dpi_form_dialog.dart';
import '../widgets/confirm_dialog.dart';

class TipiDpiScreen extends StatefulWidget {
  const TipiDpiScreen({super.key});

  @override
  State<TipiDpiScreen> createState() => _TipiDpiScreenState();
}

class _TipiDpiScreenState extends State<TipiDpiScreen> {
  bool _loaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_loaded) {
      final tipoProvider = context.read<TipiDpiProvider>();
      _loaded = true;
      Future.microtask(() => tipoProvider.load());
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final primaryBlue = Theme.of(context).colorScheme.primary;
    final isMobile = MediaQuery.sizeOf(context).width < kMobileAppBarBreakpoint;
    final tipoProvider = context.watch<TipiDpiProvider>();
    final tipologie = tipoProvider.tipiDpi;

    void nuovaTipologia() => showTipoDpiFormDialog(
      context,
      provider: tipoProvider,
      tipiDpi: tipologie,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: BreadcrumbAppBar(
        items: [
          BreadcrumbItem(label: l10n.tipiDpiScreenBreadcrumbDpi, onTap: () => context.pop()),
          BreadcrumbItem(label: l10n.tipiDpiScreenBreadcrumbTipiDpi),
        ],
        actions: [
          AppBarAction(
            icon: Icons.add,
            label: l10n.tipiDpiScreenNewDpiLabel,
            onPressed: nuovaTipologia,
          ),
        ],
      ),
      body: tipoProvider.isLoading && tipologie.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(24),
              children: [
                if (tipoProvider.errorMessage != null) ...[
                  Card(
                    color: Theme.of(context).colorScheme.errorContainer,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          const Icon(Icons.error_outline),
                          const SizedBox(width: 8),
                          Expanded(child: Text(tipoProvider.errorMessage!)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                if (tipologie.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Center(
                      child: Text(l10n.tipiDpiScreenEmptyState, style: const TextStyle(fontSize: 22)),
                    ),
                  )
                else
                  Card(
                    child: Column(
                      children: [
                        for (var i = 0; i < tipologie.length; i++) ...[
                          if (i > 0) const Divider(height: 1, color: Color(0xFFE0E0E0)),
                          Builder(builder: (context) {
                            final t = tipologie[i];
                            final sottotitolo = [
                              if (t.lavoriInQuota) l10n.tipiDpiScreenForHeightWork,
                              if (t.note.isNotEmpty) l10n.tipiDpiScreenNoteLabel(t.note),
                            ];
                            return ListTile(
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              title: Text(t.nome, style: const TextStyle(fontWeight: FontWeight.w700)),
                              subtitle: sottotitolo.isEmpty
                                  ? null
                                  : Text(sottotitolo.join(' · ')),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (t.lavoriInQuota)
                                    Padding(
                                      padding: const EdgeInsets.only(right: 8),
                                      child: Icon(Icons.height_outlined, color: Colors.black87, size: 20),
                                    ),
                                  IconButton(
                                    icon: Icon(Icons.settings_outlined, color: primaryBlue, size: isMobile ? 18 : 22),
                                    tooltip: l10n.tipiDpiScreenEditTooltip,
                                    onPressed: () => showTipoDpiFormDialog(
                                      context,
                                      provider: tipoProvider,
                                      tipiDpi: tipologie,
                                      esistente: t,
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete_outlined, color: primaryBlue, size: isMobile ? 18 : 22),
                                    tooltip: l10n.tipiDpiScreenDeleteTooltip,
                                    onPressed: () async {
                                      final confermato = await showConfirmDialog(
                                        context,
                                        title: l10n.tipiDpiScreenDeleteConfirmTitle,
                                        message: l10n.tipiDpiScreenDeleteConfirmMessage(t.nome),
                                      );
                                      if (!confermato) return;
                                      try {
                                        await tipoProvider.delete(t.id);
                                      } catch (e) {
                                        if (context.mounted) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text(l10n.commonErrorWithDetails(e.toString()))),
                                          );
                                        }
                                      }
                                    },
                                  ),
                                ],
                              ),
                            );
                          }),
                        ],
                      ],
                    ),
                  ),
              ],
            ),
    );
  }
}
