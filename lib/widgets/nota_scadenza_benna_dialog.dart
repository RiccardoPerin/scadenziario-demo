import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/benna.dart';
import '../providers/benne_provider.dart';

Future<void> showNotaBennaDialog(
  BuildContext context, {
  required BenneProvider provider,
  required Benna benna,
}) {
  return showDialog(
    context: context,
    builder: (_) => _NotaBennaDialog(provider: provider, benna: benna),
  );
}

class _NotaBennaDialog extends StatefulWidget {
  const _NotaBennaDialog({required this.provider, required this.benna});

  final BenneProvider provider;
  final Benna benna;

  @override
  State<_NotaBennaDialog> createState() => _NotaBennaDialogState();
}

class _NotaBennaDialogState extends State<_NotaBennaDialog> {
  late final _noteController = TextEditingController(
    text: widget.benna.notaScadenza,
  );
  bool _isSaving = false;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _isSaving = true);
    try {
      await widget.provider.updateNotaScadenza(
        widget.benna.id,
        _noteController.text.trim(),
      );
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.commonErrorWithDetails(e.toString()))));
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(l10n.notaScadenzaBennaDialogTitle(widget.benna.idInterno)),
      content: SizedBox(
        width: 400,
        child: TextField(
          controller: _noteController,
          decoration: InputDecoration(labelText: l10n.commonNoteLabel),
          maxLines: 1,
          autofocus: true,
          onSubmitted: (_) => _submit(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSaving ? null : () => Navigator.of(context).pop(),
          child: Text(l10n.commonCancel),
        ),
        FilledButton(
          onPressed: _isSaving ? null : _submit,
          child: _isSaving
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(l10n.commonSave),
        ),
      ],
    );
  }
}
