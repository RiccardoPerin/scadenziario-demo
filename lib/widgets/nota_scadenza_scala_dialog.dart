import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/scala.dart';
import '../providers/scale_provider.dart';

Future<void> showNotaScalaDialog(
  BuildContext context, {
  required ScaleProvider provider,
  required Scala scala,
}) {
  return showDialog(
    context: context,
    builder: (_) => _NotaScalaDialog(
      provider: provider,
      scala: scala,
    ),
  );
}

class _NotaScalaDialog extends StatefulWidget {
  const _NotaScalaDialog({
    required this.provider,
    required this.scala,
  });

  final ScaleProvider provider;
  final Scala scala;

  @override
  State<_NotaScalaDialog> createState() =>
      _NotaScalaDialogState();
}

class _NotaScalaDialogState
    extends State<_NotaScalaDialog> {
  late final _noteController = TextEditingController(
    text: widget.scala.notaScadenza,
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
        widget.scala.id,
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
      title: Text(l10n.notaScadenzaScalaDialogTitle(widget.scala.codice)),
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
