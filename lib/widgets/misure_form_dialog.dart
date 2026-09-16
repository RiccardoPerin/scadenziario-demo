import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../models/misura.dart';
import '../providers/misure_provider.dart';
import '../providers/dipendenti_aziendali_provider.dart';
import '../services/stato_scadenze.dart';
import 'campo_data.dart';

DateTime? _parseData(String value) => value.isEmpty ? null : DateTime.tryParse(value);

DateTime _aggiungiPeriodo(DateTime data, {int anni = 0, int mesi = 0, int giorni = 0}) {
  return DateTime(data.year + anni, data.month + mesi, data.day + giorni);
}

Future<void> showMisureFormDialog(
  BuildContext context, {
  required MisureProvider provider,
  required DipendentiAziendaliProvider dipProvider,
  required List<Misura> misure,
  Misura? esistente,
}) {
  return showDialog(
    context: context,
    builder: (_) => _MisureFormDialog(
      provider: provider,
      dipProvider: dipProvider,
      misure: misure,
      esistente: esistente,
    ),
  );
}

class _MisureFormDialog extends StatefulWidget {
  const _MisureFormDialog({
    required this.provider,
    required this.dipProvider,
    required this.misure,
    this.esistente,
  });

  final MisureProvider provider;
  final DipendentiAziendaliProvider dipProvider;
  final List<Misura> misure;
  final Misura? esistente;

  @override
  State<_MisureFormDialog> createState() => _MisureFormDialogState();
}

class _MisureFormDialogState extends State<_MisureFormDialog> {
  final _formKey = GlobalKey<FormState>();

  late final _nomeController =
      TextEditingController(text: widget.esistente?.nome ?? '');
  late final _matricolaController =
      TextEditingController(text: widget.esistente?.matricola ?? '');
  late final _riferimentoController =
      TextEditingController(text: widget.esistente?.riferimento ?? '');
  late final _noteController = 
      TextEditingController(text: widget.esistente?.note ?? '');
  late final _incaricatoTaraturaEsternaController =
      TextEditingController(text: widget.esistente?.incaricatoTaraturaEsterna ?? '');

  DateTime? _dataTaraturaInterna;
  DateTime? _dataProssimaTaraturaInterna;
  DateTime? _dataTaraturaEsterna;
  DateTime? _dataProssimaTaraturaEsterna;

  String? _dipendenteSelezionatoId;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final m = widget.esistente;

    // Su una nuova misura la taratura interna è a carico del Datore di Lavoro:
    // lo si propone già selezionato, restando comunque modificabile.
    _dipendenteSelezionatoId = (m == null || m.incaricatoTaraturaInterna.isEmpty)
        ? widget.dipProvider.dipendenti.where(isTitolare).firstOrNull?.id
        : m.incaricatoTaraturaInterna;

    _dataTaraturaInterna = _parseData(m?.dataTaraturaInterna ?? '');
    _dataProssimaTaraturaInterna = _parseData(m?.dataProssimaTaraturaInterna ?? '');
    _dataTaraturaEsterna = _parseData(m?.dataTaraturaEsterna ?? '');
    _dataProssimaTaraturaEsterna = _parseData(m?.dataProssimaTaraturaEsterna ?? '');
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _matricolaController.dispose();
    _riferimentoController.dispose();
    _noteController.dispose();
    _incaricatoTaraturaEsternaController.dispose();
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
          matricola: _matricolaController.text.trim(),
          riferimento: _riferimentoController.text.trim(),
          incaricatoTaraturaInterna: _dipendenteSelezionatoId,
          dataTaraturaInterna: _dataTaraturaInterna,
          dataProssimaTaraturaInterna: _dataProssimaTaraturaInterna,
          incaricatoTaraturaEsterna: _incaricatoTaraturaEsternaController.text.trim(),
          dataTaraturaEsterna: _dataTaraturaEsterna,
          dataProssimaTaraturaEsterna: _dataProssimaTaraturaEsterna,
          note: _noteController.text.trim(),
        );
      } else {
        await widget.provider.update(
          widget.esistente!.id,
          nome: _nomeController.text.trim(),
          matricola: _matricolaController.text.trim(),
          riferimento: _riferimentoController.text.trim(),
          incaricatoTaraturaInterna: _dipendenteSelezionatoId,
          dataTaraturaInterna: _dataTaraturaInterna,
          dataProssimaTaraturaInterna: _dataProssimaTaraturaInterna,
          incaricatoTaraturaEsterna: _incaricatoTaraturaEsternaController.text.trim(),
          dataTaraturaEsterna: _dataTaraturaEsterna,
          dataProssimaTaraturaEsterna: _dataProssimaTaraturaEsterna,
          note: _noteController.text.trim(),
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
    final primaryBlue = Theme.of(context).primaryColor;
    final dipProvider = context.watch<DipendentiAziendaliProvider>();
    return AlertDialog(
      title: Text(widget.esistente == null ? l10n.misureFormDialogNewTitle : l10n.misureFormDialogEditTitle),
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
                  decoration: InputDecoration(labelText: l10n.misureFormDialogNameLabel),
                  validator: (v) => (v == null || v.trim().isEmpty) ? l10n.commonRequiredField : null,
                ),
                TextFormField(
                  controller: _riferimentoController,
                  decoration: InputDecoration(labelText: l10n.misureFormDialogReferenceLabel),
                ),
                TextFormField(
                  controller: _matricolaController,
                  decoration: InputDecoration(labelText: l10n.misureFormDialogSerialLabel),
                ),
                const Divider(height: 24),
                Text(l10n.misureFormDialogInternalCalibrationSection, style: TextStyle(color: primaryBlue, fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                DropdownButtonFormField<String?>(
                  initialValue:
                      dipProvider.dipendenti.any((d) => d.id == _dipendenteSelezionatoId)
                          ? _dipendenteSelezionatoId
                          : null,
                  borderRadius: BorderRadius.circular(15),
                  isExpanded: true,
                  decoration: InputDecoration(labelText: l10n.misureFormDialogAssignedToLabel),
                  items: [
                    DropdownMenuItem(value: null, child: Text(l10n.misureFormDialogNotSpecified)),
                    ...dipProvider.dipendenti.map(
                      (d) => DropdownMenuItem(value: d.id, child: Text(d.nomeCompleto)),
                    ),
                  ],
                  onChanged: (v) => setState(() => _dipendenteSelezionatoId = v),
                ),
                const SizedBox(height: 8),
                _campoData(l10n.misureFormDialogLastCalibrationLabel, _dataTaraturaInterna, (v) {
                  _dataTaraturaInterna = v;
                  if (v != null) {
                    _dataProssimaTaraturaInterna = _aggiungiPeriodo(v, anni: 1);
                  }
                }),
                const SizedBox(height: 8),
                _campoData(l10n.misureFormDialogNextCalibrationLabel, _dataProssimaTaraturaInterna, (v) => _dataProssimaTaraturaInterna = v),
                const Divider(height: 24),
                Text(l10n.misureFormDialogExternalCalibrationSection, style: TextStyle(color: primaryBlue, fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _incaricatoTaraturaEsternaController,
                  decoration: InputDecoration(labelText: l10n.misureFormDialogExternalAssignedToLabel),
                ),
                const SizedBox(height: 8),
                _campoData(l10n.misureFormDialogLastCalibrationLabel, _dataTaraturaEsterna, (v) {
                  _dataTaraturaEsterna = v;
                  if (v != null) {
                    _dataProssimaTaraturaEsterna = _aggiungiPeriodo(v, anni: 3);
                  }
                }),
                const SizedBox(height: 8),
                _campoData(l10n.misureFormDialogNextCalibrationLabel, _dataProssimaTaraturaEsterna, (v) => _dataProssimaTaraturaEsterna = v),
                const Divider(height: 24),
                TextField(
                  controller: _noteController,
                  decoration: InputDecoration(labelText: l10n.misureFormDialogAdditionalNotesLabel)
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
