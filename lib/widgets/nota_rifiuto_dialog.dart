import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/rifiuto.dart';
import '../providers/rifiuti_provider.dart';

Future<void> showNotaRifiutoDialog(
  BuildContext context, {
  required RifiutiProvider provider,
  required Rifiuto rifiuto,
  required String tipo,
}) {
  return showDialog(
    context: context,
    builder: (_) => _NotaRifiutoDialog(
      provider: provider,
      rifiuto: rifiuto,
      tipo: tipo,
    ),
  );
}

class _NotaRifiutoDialog extends StatefulWidget {
  const _NotaRifiutoDialog({
    required this.provider,
    required this.rifiuto,
    required this.tipo,
  });

  final RifiutiProvider provider;
  final Rifiuto rifiuto;
  final String tipo;

  @override
  State<_NotaRifiutoDialog> createState() => _NotaRifiutoDialogState();
}

class _NotaRifiutoDialogState extends State<_NotaRifiutoDialog> {
  late final _noteController = TextEditingController(
    text: widget.rifiuto.noteScadenze[widget.tipo] ?? '',
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
        widget.rifiuto,
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
      title: Text(l10n.notaRifiutoDialogTitle(widget.rifiuto.nomeDitta, widget.tipo)),
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
