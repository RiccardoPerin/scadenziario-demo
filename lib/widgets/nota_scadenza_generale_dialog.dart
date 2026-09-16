import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/scadenza_generale.dart';
import '../providers/scadenze_generali_provider.dart';

Future<void> showNotaScadenzaGeneraleDialog(
  BuildContext context, {
  required ScadenzeGeneraliProvider provider,
  required ScadenzaGenerale scadenza,
}) {
  return showDialog(
    context: context,
    builder: (_) => _NotaScadenzaGeneraleDialog(
      provider: provider,
      scadenzaGenerale: scadenza,
    ),
  );
}

class _NotaScadenzaGeneraleDialog extends StatefulWidget {
  const _NotaScadenzaGeneraleDialog({
    required this.provider,
    required this.scadenzaGenerale,
  });

  final ScadenzeGeneraliProvider provider;
  final ScadenzaGenerale scadenzaGenerale;

  @override
  State<_NotaScadenzaGeneraleDialog> createState() =>
      _NotaScadenzaGeneraleDialogState();
}

class _NotaScadenzaGeneraleDialogState
    extends State<_NotaScadenzaGeneraleDialog> {
  late final _noteController = TextEditingController(
    text: widget.scadenzaGenerale.notaScadenza,
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
        widget.scadenzaGenerale.id,
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
      title: Text(l10n.notaScadenzaGeneraleDialogTitle(widget.scadenzaGenerale.nome)),
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
