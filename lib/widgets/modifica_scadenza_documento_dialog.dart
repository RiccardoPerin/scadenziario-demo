import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/documento.dart';
import '../providers/documenti_provider.dart';
import 'campo_data.dart';

/// Corregge data di scadenza e nota di una scadenza già registrata, senza
/// doverne inserire una nuova. La nota "prenotato" delle scadenze imminenti è
/// un'altra cosa e si modifica da [showNotaScadenzaDocumentoDialog].
Future<void> showModificaScadenzaDocumentoDialog(
  BuildContext context, {
  required DocumentiProvider documentiProvider,
  required Documento documento,
}) {
  return showDialog(
    context: context,
    builder: (_) => _ModificaScadenzaDocumentoDialog(
      documentiProvider: documentiProvider,
      documento: documento,
    ),
  );
}

class _ModificaScadenzaDocumentoDialog extends StatefulWidget {
  const _ModificaScadenzaDocumentoDialog({
    required this.documentiProvider,
    required this.documento,
  });

  final DocumentiProvider documentiProvider;
  final Documento documento;

  @override
  State<_ModificaScadenzaDocumentoDialog> createState() =>
      _ModificaScadenzaDocumentoDialogState();
}

class _ModificaScadenzaDocumentoDialogState
    extends State<_ModificaScadenzaDocumentoDialog> {
  final _formKey = GlobalKey<FormState>();
  late final _noteController = TextEditingController(text: widget.documento.note);
  late DateTime? _dataScadenza = widget.documento.dataScadenza;
  bool _isSaving = false;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    try {
      await widget.documentiProvider.updateScadenza(
        widget.documento.record.id,
        dataScadenza: _dataScadenza,
        note: _noteController.text.trim(),
      );
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(l10n.commonErrorWithDetails(e.toString()))));
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(widget.documento.tipoDocumentoNome?.isNotEmpty == true
          ? l10n.modificaScadenzaDocumentoDialogModificaTipo(widget.documento.tipoDocumentoNome!)
          : l10n.modificaScadenzaDocumentoDialogModificaScadenza),
      content: Form(
        key: _formKey,
        child: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CampoData(
                label: l10n.modificaScadenzaDocumentoDialogDataScadenza,
                valore: _dataScadenza,
                onChanged: (v) => setState(() => _dataScadenza = v),
              ),
              TextFormField(
                controller: _noteController,
                decoration: InputDecoration(labelText: l10n.commonNoteLabel),
                maxLines: 2,
              ),
            ],
          ),
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
