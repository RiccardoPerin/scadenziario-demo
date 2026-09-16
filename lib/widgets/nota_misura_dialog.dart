import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/misura.dart';
import '../providers/misure_provider.dart';

Future<void> showNotaMisuraDialog(
  BuildContext context, {
  required MisureProvider provider,
  required Misura misura,
  required String tipo,
}) {
  return showDialog(
    context: context,
    builder: (_) => _NotaMisuraDialog(
      provider: provider,
      misura: misura,
      tipo: tipo,
    ),
  );
}

class _NotaMisuraDialog extends StatefulWidget {
  const _NotaMisuraDialog({
    required this.provider,
    required this.misura,
    required this.tipo,
  });

  final MisureProvider provider;
  final Misura misura;
  final String tipo;

  @override
  State<_NotaMisuraDialog> createState() => _NotaMisuraDialogState();
}

class _NotaMisuraDialogState extends State<_NotaMisuraDialog> {
  late final _noteController = TextEditingController(
    text: widget.misura.noteScadenze[widget.tipo] ?? '',
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
        widget.misura,
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
      title: Text(l10n.notaMisuraDialogTitle(widget.misura.nome, widget.tipo)),
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
