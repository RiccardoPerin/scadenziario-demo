import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/dipendente_subappaltatore.dart';
import '../providers/dipendenti_subappaltatori_provider.dart';

Future<void> showDipendenteSubappaltatoreFormDialog(
  BuildContext context, {
  required DipendentiSubappaltatoriProvider provider,
  String? subappaltatoreId,
  DipendenteSubappaltatore? esistente,
}) {
  return showDialog(
    context: context,
    builder: (_) => _DipendenteSubappaltatoreFormDialog(
      provider: provider,
      subappaltatoreId: subappaltatoreId,
      esistente: esistente,
    ),
  );
}

class _DipendenteSubappaltatoreFormDialog extends StatefulWidget {
  const _DipendenteSubappaltatoreFormDialog({
    required this.provider,
    this.subappaltatoreId,
    this.esistente,
  });

  final DipendentiSubappaltatoriProvider provider;
  final String? subappaltatoreId;
  final DipendenteSubappaltatore? esistente;

  @override
  State<_DipendenteSubappaltatoreFormDialog> createState() => _DipendenteSubappaltatoreFormDialogState();
}

class _DipendenteSubappaltatoreFormDialogState extends State<_DipendenteSubappaltatoreFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final _nomeController = TextEditingController(text: widget.esistente?.nome ?? '');
  late final _cognomeController =
      TextEditingController(text: widget.esistente?.cognome ?? '');
  late final _noteController = TextEditingController(text: widget.esistente?.note ?? '');
  late bool _lavoratoreAutonomo = widget.esistente?.lavoratoreAutonomo ?? false;
  bool _isSaving = false;

  @override
  void dispose() {
    _nomeController.dispose();
    _cognomeController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);
    try {
      if (widget.esistente == null) {
        await widget.provider.create(
          nome: _nomeController.text.trim(),
          cognome: _cognomeController.text.trim(),
          lavoratoreAutonomo: _lavoratoreAutonomo,
          note: _noteController.text.trim(),
          subappaltatoreId: widget.subappaltatoreId,
        );
      } else {
        await widget.provider.update(
          widget.esistente!.id,
          nome: _nomeController.text.trim(),
          cognome: _cognomeController.text.trim(),
          lavoratoreAutonomo: _lavoratoreAutonomo,
          note: _noteController.text.trim(),
        );
      }
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
      title: Text(
        widget.esistente == null
            ? l10n.dipendenteSubappaltatoreFormDialogNuovo
            : l10n.dipendenteSubappaltatoreFormDialogModifica,
      ),
      content: Form(
        key: _formKey,
        child: SizedBox(
          width: 400,
          // Con la casella "Lavoratore autonomo" il contenuto non sta più
          // sempre nell'altezza disponibile: come negli altri form, scorre.
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nomeController,
                  decoration: InputDecoration(labelText: l10n.dipendenteSubappaltatoreFormDialogNome),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? l10n.commonRequiredField : null,
                ),
                TextFormField(
                  controller: _cognomeController,
                  decoration: InputDecoration(labelText: l10n.dipendenteSubappaltatoreFormDialogCognome),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? l10n.commonRequiredField : null,
                ),
                TextFormField(
                  controller: _noteController,
                  decoration: InputDecoration(
                    labelText: l10n.commonNoteLabel,
                    helperText: l10n.dipendenteSubappaltatoreFormDialogNoteHelper,
                    helperMaxLines: 2,
                  ),
                  minLines: 1,
                  maxLines: 3,
                ),
                const SizedBox(height: 8),
                // Un lavoratore autonomo si registra come gli altri, ma sulle
                // sue scadenze compaiono anche le tipologie d'impresa (vedi
                // TipoScadenza.assegnabileALavoratoreAutonomo).
                CheckboxListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    l10n.dipendenteSubappaltatoreFormDialogLavoratoreAutonomo,
                    style: TextStyle(
                      fontWeight: _lavoratoreAutonomo ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                  subtitle: Text(
                    l10n.dipendenteSubappaltatoreFormDialogLavoratoreAutonomoSubtitle,
                  ),
                  isThreeLine: true,
                  value: _lavoratoreAutonomo,
                  onChanged: (v) => setState(() => _lavoratoreAutonomo = v ?? false),
                ),
              ],
            ),
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
