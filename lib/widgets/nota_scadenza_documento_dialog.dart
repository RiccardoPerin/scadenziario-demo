import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/documento.dart';
import '../providers/documenti_provider.dart';

/// Nota "prenotato" del documento (blocca l'email di sollecito), distinta
/// dalla nota generale editabile da [showNotaDocumentoDialog].
Future<void> showNotaScadenzaDocumentoDialog(
  BuildContext context, {
  required DocumentiProvider documentiProvider,
  required Documento documento,
}) {
  return showDialog(
    context: context,
    builder: (_) => _NotaScadenzaDocumentoDialog(
      documentiProvider: documentiProvider,
      documento: documento,
    ),
  );
}

class _NotaScadenzaDocumentoDialog extends StatefulWidget {
  const _NotaScadenzaDocumentoDialog({
    required this.documentiProvider,
    required this.documento,
  });

  final DocumentiProvider documentiProvider;
  final Documento documento;

  @override
  State<_NotaScadenzaDocumentoDialog> createState() => _NotaScadenzaDocumentoDialogState();
}

class _NotaScadenzaDocumentoDialogState extends State<_NotaScadenzaDocumentoDialog> {
  late final _noteController = TextEditingController(text: widget.documento.notaScadenza);
  bool _isSaving = false;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _isSaving = true);
    try {
      await widget.documentiProvider.updateNotaScadenza(
        widget.documento.record.id,
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
      title: Text(l10n.notaScadenzaDocumentoDialogTitle(
        widget.documento.tipoDocumentoNome ?? l10n.notaScadenzaDocumentoDialogDefaultType,
      )),
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
