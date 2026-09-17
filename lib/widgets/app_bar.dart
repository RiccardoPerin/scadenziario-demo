import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../providers/auth_provider.dart';
import '../providers/locale_provider.dart';
import 'confirm_dialog.dart';

/// Larghezza sotto la quale l'app bar passa al layout compatto da mobile
/// (azioni solo icona, logo più piccolo, titolo affiancato).
const double kMobileAppBarBreakpoint = 640;

/// Azione mostrata nella [CustomAppBar]: su schermi larghi viene renderizzata
/// come [TextButton.icon] con etichetta, su mobile collassa in una sola icona
/// con tooltip per non far traboccare l'app bar.
class AppBarAction {
  const AppBarAction({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.color,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onPressed;
  final Color? color;
}

const double _kMobileToolbarHeight = 56;
const double _kDesktopToolbarHeight = 92;

/// Larghezza attuale della finestra/schermo, letta senza [BuildContext]:
/// serve per [CustomAppBar.preferredSize], che essendo un getter puro non
/// ha accesso a [MediaQuery].
double _currentScreenWidth() {
  final view = WidgetsBinding.instance.platformDispatcher.views.first;
  return view.physicalSize.width / view.devicePixelRatio;
}

/// App bar personalizzata con logo e titolo, drawer e azioni responsive.
///
/// Essendo passata a [Scaffold.appBar] resta sempre fissa in cima allo
/// schermo anche quando il body scorre.
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    required this.title,
    this.actions = const [],
    this.iconActions,
    this.showLogout = true,
    this.showHome = true,
  });

  final String title;
  final List<AppBarAction> actions;

  /// Azioni mostrate come sola icona (con tooltip), renderizzate esattamente
  /// come passate: sta al chiamante decidere se e quando includerle in base
  /// alla larghezza dello schermo (es. `null` su mobile per lasciarle solo
  /// nel drawer).
  final List<AppBarAction>? iconActions;
  final bool showLogout;
  final bool showHome;

  @override
  Size get preferredSize => Size.fromHeight(
        _currentScreenWidth() < kMobileAppBarBreakpoint
            ? _kMobileToolbarHeight
            : _kDesktopToolbarHeight,
      );

  Future<void> _confirmLogout(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final confermato = await showConfirmDialog(
      context,
      title: l10n.appBarLogoutConfirmTitle,
      message: l10n.appBarLogoutConfirmMessage,
      confirmLabel: l10n.appBarLogoutConfirmButton,
    );
    if (confermato && context.mounted) {
      await context.read<AuthProvider>().logout();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final primaryBlue = Theme.of(context).colorScheme.primary;
    final isMobile = MediaQuery.sizeOf(context).width < kMobileAppBarBreakpoint;

    return AppBar(
      backgroundColor: Colors.transparent,
      foregroundColor: primaryBlue,
      elevation: 1,
      surfaceTintColor: Colors.transparent,
      toolbarHeight: isMobile ? _kMobileToolbarHeight : _kDesktopToolbarHeight,
      titleSpacing: isMobile ? 4 : 20,
      automaticallyImplyLeading: false,
      centerTitle: !isMobile,
      leadingWidth: showHome ? (isMobile ? 88 : 104) : null,
      leading: Builder(
        builder: (context) => Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
            if (showHome)
              IconButton(
                icon: const Icon(Icons.home_outlined),
                tooltip: l10n.appBarGoHome,
                onPressed: () => context.go('/'),
              ),
          ],
        ),
      ),
      title: isMobile
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('assets/demo.png', height: 26),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                      color: primaryBlue,
                    ),
                  ),
                ),
              ],
            )
          : SizedBox(
              height: 80,
              child: FittedBox(
                fit: BoxFit.contain,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset('assets/demo.png', height: 50),
                    const SizedBox(height: 5),
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 30,
                        color: primaryBlue,
                      ),
                    ),
                  ],
                ),
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
              : TextButton.icon(
                  onPressed: action.onPressed,
                  icon: Icon(action.icon, color: action.color),
                  label: Text(
                    action.label,
                    style: action.color != null ? TextStyle(color: action.color) : null,
                  ),
                ),
        for (final action in iconActions ?? const [])
          IconButton(
            icon: Icon(action.icon, color: action.color),
            tooltip: action.label,
            onPressed: action.onPressed,
          ),
        IconButton(
          icon: const Icon(Icons.translate),
          tooltip: l10n.appBarLanguageTooltip,
          onPressed: () => context.read<LocaleProvider>().toggle(),
        ),
        if (showLogout)
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: l10n.appBarLogout,
            onPressed: () => _confirmLogout(context),
          ),
        SizedBox(width: isMobile ? 4 : 12),
      ],
    );
  }
}
