import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/scaffalatura.dart';
import '../providers/scaffalature_provider.dart';

Future<void> showNotaScaffalaturaDialog(
  BuildContext context, {
  required ScaffalatureProvider provider,
  required Scaffalatura scaffalatura,
  required String tipo,
}) {
  return showDialog(
    context: context,
    builder: (_) => _NotaScaffalaturaDialog(
      provider: provider,
      scaffalatura: scaffalatura,
      tipo: tipo,
    ),
  );
}

class _NotaScaffalaturaDialog extends StatefulWidget {
  const _NotaScaffalaturaDialog({
    required this.provider,
    required this.scaffalatura,
    required this.tipo,
  });

  final ScaffalatureProvider provider;
  final Scaffalatura scaffalatura;
  final String tipo;

  @override
  State<_NotaScaffalaturaDialog> createState() => _NotaScaffalaturaDialogState();
}

class _NotaScaffalaturaDialogState extends State<_NotaScaffalaturaDialog> {
  late final _noteController = TextEditingController(
    text: widget.scaffalatura.notaScadenza,
  );
  bool _isSaving = false;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context)!;
    setState(() => _isSaving = true);
    try {
      await widget.provider.updateNotaScadenza(
        widget.scaffalatura.id,
        _noteController.text.trim(),
      );
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
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
      title: Text(l10n.notaScaffalaturaDialogTitle(widget.scaffalatura.idInterno, widget.tipo)),
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
