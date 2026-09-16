import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/dipendente_aziendale.dart';
import '../models/dpi_assegnato.dart';
import '../models/tipo_dpi.dart';
import '../providers/dpi_assegnati_provider.dart';
import 'campo_data.dart';

DateTime? _parseData(String value) => value.isEmpty ? null : DateTime.tryParse(value);

/// Form per assegnare un DPI a un dipendente, o modificare un'assegnazione
/// esistente. [dipendenteInizialeId] e [tipoDpiInizialeId] permettono di
/// precompilare i due campi quando il form viene aperto da un contesto già
/// noto (es. il pulsante "Assegna" su un DPI obbligatorio mancante).
Future<void> showDpiAssegnatoFormDialog(
  BuildContext context, {
  required DpiAssegnatiProvider provider,
  required List<DipendenteAziendale> dipendenti,
  required List<TipoDpi> tipiDpi,
  DpiAssegnato? esistente,
  String? dipendenteInizialeId,
  String? tipoDpiInizialeId,
}) {
  return showDialog(
    context: context,
    builder: (_) => _DpiAssegnatoFormDialog(
      provider: provider,
      dipendenti: dipendenti,
      tipiDpi: tipiDpi,
      esistente: esistente,
      dipendenteInizialeId: dipendenteInizialeId,
      tipoDpiInizialeId: tipoDpiInizialeId,
    ),
  );
}

class _DpiAssegnatoFormDialog extends StatefulWidget {
  const _DpiAssegnatoFormDialog({
    required this.provider,
    required this.dipendenti,
    required this.tipiDpi,
    this.esistente,
    this.dipendenteInizialeId,
    this.tipoDpiInizialeId,
  });

  final DpiAssegnatiProvider provider;
  final List<DipendenteAziendale> dipendenti;
  final List<TipoDpi> tipiDpi;
  final DpiAssegnato? esistente;
  final String? dipendenteInizialeId;
  final String? tipoDpiInizialeId;

  @override
  State<_DpiAssegnatoFormDialog> createState() => _DpiAssegnatoFormDialogState();
}

class _DpiAssegnatoFormDialogState extends State<_DpiAssegnatoFormDialog> {
  final _formKey = GlobalKey<FormState>();

  late final _matricolaController =
      TextEditingController(text: widget.esistente?.matricola ?? '');
  late final _produttoreController =
      TextEditingController(text: widget.esistente?.produttore ?? '');
  late final _annoFabbricazioneController = TextEditingController(
    text: widget.esistente != null && widget.esistente!.annoFabbricazione != 0
        ? widget.esistente!.annoFabbricazione.toString()
        : '',
  );
  late final _tagliaController = TextEditingController(
    text: widget.esistente != null && widget.esistente!.taglia != 0
        ? widget.esistente!.taglia.toString()
        : '',
  );
  late final _noteController = TextEditingController(text: widget.esistente?.note ?? '');

  String? _dipendenteId;
  String? _tipoDpiId;

  DateTime? _dataMessaInUso;
  DateTime? _dataConsegna;
  DateTime? _dataScadenza;

  bool _isSaving = false;

  bool get _isScarpeAntinfortunistiche {
    for (final t in widget.tipiDpi) {
      if (t.id == _tipoDpiId) return t.nome == 'Scarpe Antinfortunistiche';
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    final d = widget.esistente;
    _dipendenteId = d?.dipendente ?? widget.dipendenteInizialeId;
    _tipoDpiId = d?.tipoDpi ?? widget.tipoDpiInizialeId;
    _dataMessaInUso = _parseData(d?.dataMessaInUso ?? '');
    _dataConsegna = _parseData(d?.dataConsegna ?? '');
    _dataScadenza = _parseData(d?.dataScadenza ?? '');
  }

  @override
  void dispose() {
    _matricolaController.dispose();
    _annoFabbricazioneController.dispose();
    _noteController.dispose();
    _produttoreController.dispose();
    _tagliaController.dispose();
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
      final matricola = _matricolaController.text.trim();
      final produttore = _produttoreController.text.trim();
      final annoFabbricazione = int.tryParse(_annoFabbricazioneController.text.trim());
      final taglia = int.tryParse(_tagliaController.text.trim());
      final note = _noteController.text.trim();

      if (widget.esistente == null) {
        await widget.provider.create(
          dipendenteId: _dipendenteId!,
          tipoDpiId: _tipoDpiId!,
          matricola: matricola,
          taglia: taglia,
          produttore: produttore,
          dataMessaInUso: _dataMessaInUso,
          annoFabbricazione: annoFabbricazione,
          dataScadenza: _dataScadenza,
          dataConsegna: _dataConsegna,
          note: note,
        );
      } else {
        await widget.provider.update(
          widget.esistente!.id,
          dipendenteId: _dipendenteId!,
          tipoDpiId: _tipoDpiId!,
          matricola: matricola,
          taglia: taglia,
          produttore: produttore,
          dataMessaInUso: _dataMessaInUso,
          annoFabbricazione: annoFabbricazione,
          dataScadenza: _dataScadenza,
          dataConsegna: _dataConsegna,
          note: note,
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
          ? l10n.dpiAssegnatoFormDialogAssignTitle
          : l10n.dpiAssegnatoFormDialogEditTitle),
      content: Form(
        key: _formKey,
        child: SizedBox(
          width: 460,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButtonFormField<String?>(
                  initialValue: widget.dipendenti.any((d) => d.id == _dipendenteId)
                      ? _dipendenteId
                      : null,
                  decoration: InputDecoration(labelText: l10n.dpiAssegnatoFormDialogEmployeeLabel),
                  borderRadius: BorderRadius.circular(15),
                  isExpanded: true,
                  items: widget.dipendenti
                      .map((d) => DropdownMenuItem(value: d.id, child: Text(d.nomeCompleto)))
                      .toList(),
                  onChanged: (v) => setState(() => _dipendenteId = v),
                  validator: (v) => v == null ? l10n.dpiAssegnatoFormDialogSelectEmployee : null,
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String?>(
                  initialValue:
                      widget.tipiDpi.any((t) => t.id == _tipoDpiId) ? _tipoDpiId : null,
                  decoration: InputDecoration(labelText: l10n.dpiAssegnatoFormDialogDpiTypeLabel),
                  borderRadius: BorderRadius.circular(15),
                  isExpanded: true,
                  items: widget.tipiDpi
                      .map((t) => DropdownMenuItem(value: t.id, child: Text(t.nome)))
                      .toList(),
                  onChanged: (v) => setState(() => _tipoDpiId = v),
                  validator: (v) => v == null ? l10n.dpiAssegnatoFormDialogSelectDpiType : null,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _produttoreController,
                  decoration: InputDecoration(labelText: l10n.dpiAssegnatoFormDialogManufacturerLabel),
                ),
                if (_isScarpeAntinfortunistiche)
                  TextFormField(
                    controller: _tagliaController,
                    decoration: InputDecoration(labelText: l10n.dpiAssegnatoFormDialogSizeLabel),
                    keyboardType: TextInputType.number,
                  )
                else
                  TextFormField(
                    controller: _matricolaController,
                    decoration: InputDecoration(labelText: l10n.dpiAssegnatoFormDialogSerialNumberLabel),
                  ),
                TextFormField(
                  controller: _annoFabbricazioneController,
                  decoration: InputDecoration(labelText: l10n.dpiAssegnatoFormDialogManufactureYearLabel),
                  keyboardType: TextInputType.number,
                ),
                const Divider(height: 24),
                _campoData(l10n.dpiAssegnatoFormDialogDateInUseLabel, _dataMessaInUso, (v) => _dataMessaInUso = v),
                _campoData(l10n.dpiAssegnatoFormDialogDeliveryDateLabel, _dataConsegna, (v) => _dataConsegna = v),
                _campoData(l10n.dpiAssegnatoFormDialogExpiryDateLabel, _dataScadenza, (v) => _dataScadenza = v),
                const Divider(height: 24),
                TextField(
                  controller: _noteController,
                  decoration: InputDecoration(labelText: l10n.dpiAssegnatoFormDialogAdditionalNotesLabel),
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
