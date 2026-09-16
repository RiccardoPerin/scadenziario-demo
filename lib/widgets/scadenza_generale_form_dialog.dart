import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/scadenza_generale.dart';
import '../providers/scadenze_generali_provider.dart';
import 'campo_data.dart';

DateTime? _parseData(String value) => value.isEmpty ? null : DateTime.tryParse(value);

Future<void> showScadenzaGeneraleFormDialog(
  BuildContext context, {
  required ScadenzeGeneraliProvider provider,
  required List<ScadenzaGenerale> scadenze,
  ScadenzaGenerale? esistente,
}) {
  return showDialog(
    context: context,
    builder: (_) => _ScadenzaGeneraleFormDialog(
      provider: provider,
      scadenze: scadenze,
      esistente: esistente,
    ),
  );
}

class _ScadenzaGeneraleFormDialog extends StatefulWidget {
  const _ScadenzaGeneraleFormDialog({
    required this.provider,
    required this.scadenze,
    this.esistente,
  });

  final ScadenzeGeneraliProvider provider;
  final List<ScadenzaGenerale> scadenze;
  final ScadenzaGenerale? esistente;

  @override
  State<_ScadenzaGeneraleFormDialog> createState() => _ScadenzaGeneraleFormDialogState();
}

class _ScadenzaGeneraleFormDialogState extends State<_ScadenzaGeneraleFormDialog> {
  final _formKey = GlobalKey<FormState>();

  late final _nomeController =
      TextEditingController(text: widget.esistente?.nome ?? '');
  late final _noteController = 
      TextEditingController(text: widget.esistente?.note ?? '');
  late final _giorniPreavvisoController = TextEditingController(
    text: widget.esistente?.giorniPreavviso.join(', ') ?? '30, 15, 7, 1',
  );

  DateTime? _scadenza;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final s = widget.esistente;

    _scadenza = _parseData(s?.scadenza ?? '');
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _giorniPreavvisoController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  List<int> _parseGiorniPreavviso() {
    return _giorniPreavvisoController.text
        .split(',')
        .map((s) => int.tryParse(s.trim()))
        .whereType<int>()
        .toList();
  }

  Widget _campoData(String label, DateTime? valore, ValueChanged<DateTime?> onChanged) {
    return CampoData(
      label: label,
      valore: valore,
      onChanged: (v) => setState(() => onChanged(v)),
    );
  }

  Future<void> _submit() async {
    final giorniPreavviso = _parseGiorniPreavviso();
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);
    try {
      if (widget.esistente == null) {
        await widget.provider.create(
          nome: _nomeController.text.trim(),
          giorniPreavviso: giorniPreavviso,
          note: _noteController.text.trim(),
          scadenza: _scadenza,
        );
      } else {
        await widget.provider.update(
          widget.esistente!.id,
          nome: _nomeController.text.trim(),
          note: _noteController.text.trim(),
          giorniPreavviso: giorniPreavviso,
          scadenza: _scadenza,
        );
      }
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
      title: Text(widget.esistente == null
          ? l10n.scadenzaGeneraleFormDialogNewTitle
          : l10n.scadenzaGeneraleFormDialogEditTitle),
      content: Form(
        key: _formKey,
        child: SizedBox(
          width: 440,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _nomeController,
                  decoration: InputDecoration(labelText: l10n.scadenzaGeneraleFormDialogNameLabel),
                ),
                const SizedBox(height: 8),
                _campoData(l10n.scadenzaGeneraleFormDialogDeadlineLabel, _scadenza, (v) => _scadenza = v),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _giorniPreavvisoController,
                  decoration: InputDecoration(labelText: l10n.scadenzaGeneraleFormDialogNoticeDaysLabel, hint: const Text('30, 15, 7, 1')),
                ),
                TextField(
                  controller: _noteController,
                  decoration: InputDecoration(labelText: l10n.scadenzaGeneraleFormDialogAdditionalNotesLabel)
                )
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
