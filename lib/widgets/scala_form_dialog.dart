import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/scala.dart';
import '../models/cantiere.dart';
import 'campo_data.dart';

import '../providers/scale_provider.dart';

DateTime? _parseData(String value) => value.isEmpty ? null : DateTime.tryParse(value);

DateTime _aggiungiPeriodo(DateTime data, {int anni = 0, int mesi = 0}) {
  return DateTime(data.year + anni, data.month + mesi, data.day);
}

enum _TipoUbicazione { nessuna, magazzino, cantiere}

Future<void> showScalaFormDialog(
  BuildContext context, {
  required ScaleProvider provider,
  required List<Scala> scale,
  required List<Cantiere> cantieri,
  Scala? esistente,
}) {
  return showDialog(
    context: context,
    builder: (_) => _ScalaFormDialog(
      provider: provider,
      scale: scale,
      cantieri: cantieri,
      esistente: esistente,
    ),
  );
}

class _ScalaFormDialog extends StatefulWidget {
  const _ScalaFormDialog({
    required this.provider,
    required this.scale,
    required this.cantieri,
    this.esistente,
  });

  final ScaleProvider provider;
  final List<Scala> scale;
  final List<Cantiere> cantieri;
  final Scala? esistente;

  @override
  State<_ScalaFormDialog> createState() => _ScalaFormDialogState();
}

class _ScalaFormDialogState extends State<_ScalaFormDialog> {
  final _formKey = GlobalKey<FormState>();

  late final _codiceController =
      TextEditingController(text: widget.esistente?.codice ?? '');
  late final _materialeController =
      TextEditingController(text: widget.esistente?.materiale ?? '');
  late final _noteController =
      TextEditingController(text: widget.esistente?.note ?? '');
  late final _descrizioneController =
      TextEditingController(text: widget.esistente?.descrizione ?? '');

  late _TipoUbicazione _ubicazione;
  String? _cantiereSelezionatoId;

  DateTime? _ultimaVerifica;
  DateTime? _prossimaVerifica;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final s = widget.esistente;

    if (s == null ||
        (!s.inMagazzino && s.ubicazioneCantiereId.isEmpty)) {
      _ubicazione = _TipoUbicazione.nessuna;
    } else if (s.inMagazzino) {
      _ubicazione = _TipoUbicazione.magazzino;
    } else if (s.ubicazioneCantiereId.isNotEmpty) {
      _ubicazione = _TipoUbicazione.cantiere;
    }
    _cantiereSelezionatoId = (s?.ubicazioneCantiereId.isEmpty ?? true) ? null : s!.ubicazioneCantiereId;

    _ultimaVerifica = _parseData(s?.ultimaVerifica ?? '');
    _prossimaVerifica = _parseData(s?.prossimaVerifica ?? '');
  }

  @override
  void dispose() {
    _codiceController.dispose();
    _materialeController.dispose();
    _noteController.dispose();
    _descrizioneController.dispose();
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
      final inMagazzino = _ubicazione == _TipoUbicazione.magazzino;
      final ubicazioneCantiereId =
          _ubicazione == _TipoUbicazione.cantiere ? _cantiereSelezionatoId : null;

      if (widget.esistente == null) {
        await widget.provider.create(
          codice: _codiceController.text.trim(),
          materiale: _materialeController.text.trim(),
          descrizione: _descrizioneController.text.trim(),
          ubicazioneCantiereId: ubicazioneCantiereId,
          inMagazzino: inMagazzino,
          ultimaVerifica: _ultimaVerifica,
          prossimaVerifica: _prossimaVerifica,
          note: _noteController.text.trim(),
        );
      } else {
        await widget.provider.update(
          widget.esistente!.id,
          codice: _codiceController.text.trim(),
          materiale: _materialeController.text.trim(),
          descrizione: _descrizioneController.text.trim(),
          ubicazioneCantiereId: ubicazioneCantiereId,
          inMagazzino: inMagazzino,
          ultimaVerifica: _ultimaVerifica,
          prossimaVerifica: _prossimaVerifica,
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
    return AlertDialog(
      title: Text(widget.esistente == null ? l10n.scalaFormDialogNewTitle : l10n.scalaFormDialogEditTitle),
      content: Form(
        key: _formKey,
        child: SizedBox(
          width: 440,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.scalaFormDialogSectionAnagrafica, style: TextStyle(fontWeight: FontWeight.w600, color: primaryBlue)),
                TextFormField(
                  controller: _codiceController,
                  decoration: InputDecoration(labelText: l10n.scalaFormDialogCodiceLabel),
                  validator: (v) => (v == null || v.trim().isEmpty) ? l10n.commonRequiredField : null,
                ),
                TextFormField(
                  controller: _materialeController,
                  decoration: InputDecoration(labelText: l10n.scalaFormDialogMaterialeLabel),
                ),
                TextFormField(
                  controller: _descrizioneController,
                  decoration: InputDecoration(labelText: l10n.scalaFormDialogDescrizioneLabel),
                ),
                const Divider(height: 24),
                Text(l10n.scalaFormDialogSectionUbicazione, style: TextStyle(fontWeight: FontWeight.w600, color: primaryBlue)),
                const SizedBox(height: 8),
                DropdownButtonFormField<_TipoUbicazione>(
                  borderRadius: BorderRadius.circular(15),
                  initialValue: _ubicazione,
                  decoration: InputDecoration(labelText: l10n.scalaFormDialogTipoUbicazioneLabel),
                  items: [
                    DropdownMenuItem(value: _TipoUbicazione.nessuna, child: Text(l10n.scalaFormDialogUbicazioneNonSpecificata)),
                    DropdownMenuItem(value: _TipoUbicazione.magazzino, child: Text(l10n.scalaFormDialogUbicazioneMagazzino)),
                    DropdownMenuItem(value: _TipoUbicazione.cantiere, child: Text(l10n.scalaFormDialogUbicazioneCantiere)),
                  ],
                  onChanged: (v) => setState(() => _ubicazione = v ?? _TipoUbicazione.nessuna),
                ),
                if (_ubicazione == _TipoUbicazione.cantiere) ...[
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String?>(
                    borderRadius: BorderRadius.circular(15),
                    initialValue: widget.cantieri.any((c) => c.id == _cantiereSelezionatoId)
                        ? _cantiereSelezionatoId
                        : null,
                    decoration: InputDecoration(labelText: l10n.scalaFormDialogUbicazioneCantiere),
                    items: widget.cantieri
                        .map((c) => DropdownMenuItem(value: c.id, child: Text(c.nome)))
                        .toList(),
                    onChanged: (v) => setState(() => _cantiereSelezionatoId = v),
                    validator: (v) => v == null ? l10n.scalaFormDialogSelectCantiereValidator : null,
                  ),
                ],
                const Divider(height: 24),
                Text(l10n.scalaFormDialogSectionVerifiche, style: TextStyle(fontWeight: FontWeight.w600, color: primaryBlue)),
                _campoData(l10n.scalaFormDialogUltimaVerifica, _ultimaVerifica, (v) {
                  _ultimaVerifica = v;
                  if (v != null){
                    _prossimaVerifica = _aggiungiPeriodo(v, mesi: 6);
                  }
                }),
                _campoData(l10n.scalaFormDialogProssimaVerifica, _prossimaVerifica,
                    (v) =>  _prossimaVerifica = v
                ),
                const Divider(height: 24),
                TextField(
                  controller: _noteController,
                  decoration: InputDecoration(labelText: l10n.scalaFormDialogNoteAggiuntive)
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
