import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';

/// Conferma sì/no. [width], se presente, fissa la larghezza del messaggio:
/// senza, il dialog si allarga fin dove arriva il testo, e con messaggi lunghi
/// diventa una riga sola larghissima.
Future<bool> showConfirmDialog(
  BuildContext context, {
  required String title,
  required String message,
  String? confirmLabel,
  Color confirmColor = Colors.red,
  double? width,
}) async {
  final l10n = AppLocalizations.of(context)!;
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(title),
      content: width == null
          ? Text(message)
          : SizedBox(width: width, child: Text(message)),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(l10n.confirmDialogCancel),
        ),
        FilledButton(
          style: FilledButton.styleFrom(backgroundColor: confirmColor),
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(confirmLabel ?? l10n.confirmDialogDeleteDefault),
        ),
      ]
    ),
  );
  return result ?? false;
}
