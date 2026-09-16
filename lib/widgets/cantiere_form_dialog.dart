import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../models/cantiere.dart';
import '../providers/cantieri_provider.dart';
import '../providers/dipendenti_subappaltatori_provider.dart';
import 'campo_data.dart';

DateTime? _parseData(String value) => value.isEmpty ? null : DateTime.tryParse(value);

Future<void> showCantiereFormDialog(
  BuildContext context, {
  required CantieriProvider provider,
  Cantiere? esistente,
}) {
  return showDialog(
    context: context,
    builder: (_) => _CantiereFormDialog(provider: provider, esistente: esistente),
  );
}

class _CantiereFormDialog extends StatefulWidget {
  const _CantiereFormDialog({required this.provider, this.esistente});

  final CantieriProvider provider;
  final Cantiere? esistente;

  @override
  State<_CantiereFormDialog> createState() => _CantiereFormDialogState();
}

class _CantiereFormDialogState extends State<_CantiereFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final _nomeController =
      TextEditingController(text: widget.esistente?.nome ?? '');
  late final _indirizzoController =
      TextEditingController(text: widget.esistente?.indirizzo ?? '');
  late final _comuneController =
      TextEditingController(text: widget.esistente?.comune ?? '');
  late final _capController =
      TextEditingController(text: widget.esistente?.cap ?? '');
  late final _noteController =
      TextEditingController(text: widget.esistente?.note ?? '');
  late String _stato = widget.esistente?.stato ?? 'in_corso';
  
  DateTime? _dataInizio;
  DateTime? _dataFine;
  DateTime? _scadenzaMessaTerra;
  DateTime? _scadenzaGenerica1;
  DateTime? _scadenzaGenerica2;
  DateTime? _scadenzaGenerica3;
  DateTime? _scadenzaGenerica4;
  DateTime? _scadenzaGenerica5;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final c = widget.esistente;

    _dataInizio = _parseData(c?.dataInizio ?? '');
    _dataFine = _parseData(c?.dataFine ?? '');
    _scadenzaMessaTerra = _parseData(c?.scadenzaMessaTerra ?? '');
    _scadenzaGenerica1 = _parseData(c?.scadenzaGenerica1 ?? '');
    _scadenzaGenerica2 = _parseData(c?.scadenzaGenerica2 ?? '');
    _scadenzaGenerica3 = _parseData(c?.scadenzaGenerica3 ?? '');
    _scadenzaGenerica4 = _parseData(c?.scadenzaGenerica4 ?? '');
    _scadenzaGenerica5 = _parseData(c?.scadenzaGenerica5 ?? '');
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _indirizzoController.dispose();
    _comuneController.dispose();
    _capController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Widget _campoData(String label, DateTime? valore, ValueChanged<DateTime?> onChanged) {
    return CampoData(
      label: label,
      valore: valore,
      onChanged: (v) => setState(() => onChanged(v)),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);
    try {
      if (widget.esistente == null) {
        await widget.provider.create(
          nome: _nomeController.text.trim(),
          indirizzo: _indirizzoController.text.trim(),
          comune: _comuneController.text.trim(),
          cap: _capController.text.trim(),
          dataInizio: _dataInizio,
          dataFine: _dataFine,
          stato: _stato,
          scadenzaMessaTerra: _scadenzaMessaTerra,
          scadenzaGenerica1: _scadenzaGenerica1,
          scadenzaGenerica2: _scadenzaGenerica2,
          scadenzaGenerica3: _scadenzaGenerica3,
          scadenzaGenerica4: _scadenzaGenerica4,
          scadenzaGenerica5: _scadenzaGenerica5,
          note: _noteController.text.trim(),
        );
      } else {
        final diventaConcluso = widget.esistente!.stato != 'concluso' && _stato == 'concluso';
        await widget.provider.update(
          widget.esistente!.id,
          nome: _nomeController.text.trim(),
          indirizzo: _indirizzoController.text.trim(),
          comune: _comuneController.text.trim(),
          cap: _capController.text.trim(),
          dataInizio: _dataInizio,
          dataFine: _dataFine,
          stato: _stato,
          scadenzaMessaTerra: _scadenzaMessaTerra,
          scadenzaGenerica1: _scadenzaGenerica1,
          scadenzaGenerica2: _scadenzaGenerica2,
          scadenzaGenerica3: _scadenzaGenerica3,
          scadenzaGenerica4: _scadenzaGenerica4,
          scadenzaGenerica5: _scadenzaGenerica5,
          note: _noteController.text.trim(),
        );
        if (diventaConcluso && mounted) {
          await context.read<DipendentiSubappaltatoriProvider>().rimuoviCantiereDaTutti(widget.esistente!.id);
        }
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
    final primaryBlue = Theme.of(context).primaryColor;

    return AlertDialog(
      title: Text(widget.esistente == null
          ? l10n.cantiereFormDialogNewTitle
          : l10n.cantiereFormDialogEditTitle),
      content: Form(
        key: _formKey,
        child: SizedBox(
          width: 440,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.cantiereFormDialogInfoSectionTitle, style: TextStyle(color: primaryBlue, fontWeight: FontWeight.w600)),
              TextFormField(
                controller: _nomeController,
                decoration: InputDecoration(labelText: l10n.cantiereFormDialogNameLabel),
                validator: (v) => (v == null || v.trim().isEmpty) ? l10n.commonRequiredField : null,
              ),
              TextFormField(
                controller: _indirizzoController,
                decoration: InputDecoration(labelText: l10n.cantiereFormDialogAddressLabel),
                validator: (v) => (v == null || v.trim().isEmpty) ? l10n.commonRequiredField : null,
              ),
              TextFormField(
                controller: _comuneController,
                decoration: InputDecoration(labelText: l10n.cantiereFormDialogTownLabel),
              ),
              TextFormField(
                controller: _capController,
                decoration: InputDecoration(labelText: l10n.cantiereFormDialogPostalCodeLabel),
              ),
              const Divider(height: 24),
              Text(l10n.cantiereFormDialogStatusSectionTitle, style: TextStyle(color: primaryBlue, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                borderRadius: BorderRadius.circular(15),
                initialValue: _stato,
                decoration: InputDecoration(labelText: l10n.cantiereFormDialogStatusLabel),
                items: [
                  DropdownMenuItem(value: 'in_corso', child: Text(l10n.cantiereFormDialogStatusInProgress)),
                  DropdownMenuItem(value: 'concluso', child: Text(l10n.cantiereFormDialogStatusCompleted)),
                  DropdownMenuItem(value: 'sospeso', child: Text(l10n.cantiereFormDialogStatusSuspended)),
                ],
                onChanged: (v) => setState(() => _stato = v ?? _stato),
              ),
              const Divider(height: 24),
              _campoData(l10n.cantiereFormDialogStartDateLabel, _dataInizio, (v) => _dataInizio = v),
              if (_stato == 'sospeso')
                _campoData(l10n.cantiereFormDialogSuspensionDateLabel, _dataFine, (v) => _dataFine = v),
              if (_stato == 'concluso')
                _campoData(l10n.cantiereFormDialogCompletionDateLabel, _dataFine, (v) => _dataFine = v),
              const Divider(height: 24),
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
