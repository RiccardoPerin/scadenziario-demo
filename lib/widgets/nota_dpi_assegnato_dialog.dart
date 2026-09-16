import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/dpi_assegnato.dart';
import '../providers/dpi_assegnati_provider.dart';

Future<void> showNotaDpiAssegnatoDialog(
  BuildContext context, {
  required DpiAssegnatiProvider provider,
  required DpiAssegnato dpiAssegnato,
  required String titolo,
}) {
  return showDialog(
    context: context,
    builder: (_) => _NotaDpiAssegnatoDialog(
      provider: provider,
      dpiAssegnato: dpiAssegnato,
      titolo: titolo,
    ),
  );
}

class _NotaDpiAssegnatoDialog extends StatefulWidget {
  const _NotaDpiAssegnatoDialog({
    required this.provider,
    required this.dpiAssegnato,
    required this.titolo,
  });

  final DpiAssegnatiProvider provider;
  final DpiAssegnato dpiAssegnato;
  final String titolo;

  @override
  State<_NotaDpiAssegnatoDialog> createState() => _NotaDpiAssegnatoDialogState();
}

class _NotaDpiAssegnatoDialogState extends State<_NotaDpiAssegnatoDialog> {
  late final _noteController =
      TextEditingController(text: widget.dpiAssegnato.notaScadenza);
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
        widget.dpiAssegnato.id,
        _noteController.text.trim(),
      );
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.commonErrorWithDetails(e.toString()))));
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(l10n.notaDpiAssegnatoDialogTitle(widget.titolo)),
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
