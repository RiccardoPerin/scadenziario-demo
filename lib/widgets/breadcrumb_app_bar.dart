import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'app_bar.dart';

/// Naviga verso l'ultimo percorso di [percorsi] ricostruendo lo stack di
/// navigazione: il primo percorso diventa la radice (con `go`) e i successivi
/// vengono impilati sopra con `push`.
///
/// Serve ai breadcrumb: un `go` secco sostituisce l'intero stack e la pagina di
/// arrivo resterebbe senza tasto indietro, mentre un `pop` dipende da come ci si
/// è arrivati. Così invece lo stack rispecchia sempre il breadcrumb mostrato.
void vaiRicostruendoStack(BuildContext context, List<String> percorsi) {
  context.go(percorsi.first);
  for (final percorso in percorsi.skip(1)) {
    context.push(percorso);
  }
}

/// Una voce del breadcrumb: [onTap] nullo per l'ultima voce (pagina corrente).
class BreadcrumbItem {
  const BreadcrumbItem({required this.label, this.onTap});

  final String label;
  final VoidCallback? onTap;
}

/// App bar con breadcrumb di navigazione (Home > ... > pagina corrente) per
/// le schermate di dettaglio raggiunte tramite push.
///
/// Su desktop il breadcrumb scorre orizzontalmente se non entra nello spazio
/// disponibile invece di traboccare; su mobile viene omesso (resta solo il
/// titolo della pagina corrente) dato che l'utente può sempre tornare
/// indietro con il tasto back. Le azioni collassano in sole icone su mobile.
class BreadcrumbAppBar extends StatelessWidget implements PreferredSizeWidget {
  const BreadcrumbAppBar({
    super.key,
    required this.items,
    this.actions = const [],
  });

  final List<BreadcrumbItem> items;
  final List<AppBarAction> actions;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final primaryBlue = Theme.of(context).colorScheme.primary;
    final isMobile = MediaQuery.sizeOf(context).width < kMobileAppBarBreakpoint;

    return AppBar(
      // Colora la freccia indietro generata automaticamente da AppBar (e le
      // icone delle azioni che non impostano un colore proprio).
      iconTheme: IconThemeData(color: primaryBlue),
      centerTitle: false,
      title: isMobile
          ? Text(
              items.last.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: primaryBlue, fontWeight: FontWeight.w700),
            )
          : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (var i = 0; i < items.length; i++) ...[
                    if (i > 0) const Text(' > '),
                    if (i == items.length - 1)
                      Text(
                        items[i].label,
                        style: TextStyle(color: primaryBlue, fontWeight: FontWeight.w700),
                      )
                    else
                      InkWell(
                        onTap: items[i].onTap,
                        child: Text(
                          items[i].label,
                          style: const TextStyle(decoration: TextDecoration.underline),
                        ),
                      ),
                  ],
                ],
              ),
            ),
      actions: [
        for (final action in actions)
          isMobile
              ? IconButton(
                  icon: Icon(action.icon, color: action.color),
                  tooltip: action.label,
                  onPressed: action.onPressed,
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: TextButton.icon(
                    onPressed: action.onPressed,
                    icon: Icon(action.icon, color: action.color),
                    label: Text(
                      action.label,
                      style: action.color != null ? TextStyle(color: action.color) : null,
                    ),
                  ),
                ),
        const SizedBox(width: 8),
      ],
    );
  }
}
