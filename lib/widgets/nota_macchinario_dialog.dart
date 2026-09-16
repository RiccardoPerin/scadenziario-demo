import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/macchinario.dart';
import '../providers/macchinari_provider.dart';

Future<void> showNotaMacchinarioDialog(
  BuildContext context, {
  required MacchinariProvider provider,
  required Macchinario macchinario,
  required String tipo,
}) {
  return showDialog(
    context: context,
    builder: (_) => _NotaMacchinarioDialog(
      provider: provider,
      macchinario: macchinario,
      tipo: tipo,
    ),
  );
}

class _NotaMacchinarioDialog extends StatefulWidget {
  const _NotaMacchinarioDialog({
    required this.provider,
    required this.macchinario,
    required this.tipo,
  });

  final MacchinariProvider provider;
  final Macchinario macchinario;
  final String tipo;

  @override
  State<_NotaMacchinarioDialog> createState() => _NotaMacchinarioDialogState();
}

class _NotaMacchinarioDialogState extends State<_NotaMacchinarioDialog> {
  late final _noteController = TextEditingController(
    text: widget.macchinario.noteScadenze[widget.tipo] ?? '',
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
        widget.macchinario,
        widget.tipo,
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
      title: Text(l10n.notaMacchinarioDialogTitle(widget.macchinario.modello, widget.tipo)),
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
