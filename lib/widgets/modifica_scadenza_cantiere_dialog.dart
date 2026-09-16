import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/cantiere.dart';
import '../providers/cantieri_provider.dart';
import 'campo_data.dart';

/// Corregge data e commento di una scadenza generale del cantiere (messa a
/// terra o generica), l'equivalente di [showModificaScadenzaDocumentoDialog]
/// per le scadenze che vivono sul record del cantiere.
Future<void> showModificaScadenzaCantiereDialog(
  BuildContext context, {
  required CantieriProvider provider,
  required Cantiere cantiere,
  required String campo,
  required String etichetta,
  required DateTime data,
}) {
  return showDialog(
    context: context,
    builder: (_) => _ModificaScadenzaCantiereDialog(
      provider: provider,
      cantiere: cantiere,
      campo: campo,
      etichetta: etichetta,
      data: data,
    ),
  );
}

class _ModificaScadenzaCantiereDialog extends StatefulWidget {
  const _ModificaScadenzaCantiereDialog({
    required this.provider,
    required this.cantiere,
    required this.campo,
    required this.etichetta,
    required this.data,
  });

  final CantieriProvider provider;
  final Cantiere cantiere;
  final String campo;
  final String etichetta;
  final DateTime data;

  @override
  State<_ModificaScadenzaCantiereDialog> createState() =>
      _ModificaScadenzaCantiereDialogState();
}

class _ModificaScadenzaCantiereDialogState
    extends State<_ModificaScadenzaCantiereDialog> {
  final _formKey = GlobalKey<FormState>();
  late final _noteController = TextEditingController(
      text: widget.cantiere.commentiScadenze[widget.campo] ?? '');
  late DateTime? _data = widget.data;
  bool _isSaving = false;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final l10n = AppLocalizations.of(context)!;
    // Una scadenza generale esiste solo finché ha una data: per toglierla si
    // usa "Elimina scadenza", non il campo svuotato.
    final data = _data;
    if (data == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.modificaScadenzaCantiereDialogMissingDate)),
      );
      return;
    }

    setState(() => _isSaving = true);
    try {
      await widget.provider.updateScadenzaGenerale(
        widget.cantiere,
        widget.campo,
        data: data,
        commento: _noteController.text.trim(),
      );
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
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
      title: Text(l10n.modificaScadenzaCantiereDialogTitle(widget.etichetta)),
      content: Form(
        key: _formKey,
        child: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CampoData(
                label: l10n.modificaScadenzaCantiereDialogDataScadenza,
                valore: _data,
                onChanged: (v) => setState(() => _data = v),
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
