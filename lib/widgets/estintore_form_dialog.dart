import 'package:flutter/material.dart';
import 'package:gestionale_edile/models/estintore.dart';
import 'package:gestionale_edile/providers/estintori_provider.dart';

import '../l10n/app_localizations.dart';
import '../models/automezzo.dart';
import '../models/cantiere.dart';
import 'campo_data.dart';

DateTime? _parseData(String value) => value.isEmpty ? null : DateTime.tryParse(value);

DateTime _aggiungiPeriodo(DateTime data, {int anni = 0, int mesi = 0}) {
  return DateTime(data.year + anni, data.month + mesi, data.day);
}

/// Soglia di produzione (UNI 9994-1) da cui cambia la periodicità di
/// revisione degli estintori non a CO2: 3 anni prima, 5 anni da qui in poi.
final _sogliaRevisione2024 = DateTime(2024, 7, 1);

// NOTA: questa mappa è pubblica (`show tipiAgente`) e viene consumata anche
// da estintori_screen.dart, fuori dal perimetro di questo intervento: i suoi
// valori restano quindi in italiano per non rompere quel contratto.
const tipiAgente = {
  'polvere': 'Polvere',
  'schiuma' : 'Schiuma',
  'CO2' : 'CO2',
};

enum _TipoUbicazione { nessuna, magazzino, cantiere, automezzo, ufficio }

Future<void> showEstintoreFormDialog(
  BuildContext context, {
  required EstintoriProvider provider,
  required List<Estintore> estintori,
  required List<Cantiere> cantieri,
  required List<Automezzo> automezzi,
  Estintore? esistente,
}) {
  return showDialog(
    context: context,
    builder: (_) => _EstintoreFormDialog(
      provider: provider,
      estintori: estintori,
      cantieri: cantieri,
      automezzi: automezzi,
      esistente: esistente,
    ),
  );
}

class _EstintoreFormDialog extends StatefulWidget {
  const _EstintoreFormDialog({
    required this.provider,
    required this.estintori,
    required this.cantieri,
    required this.automezzi,
    this.esistente,
  });

  final EstintoriProvider provider;
  final List<Estintore> estintori;
  final List<Cantiere> cantieri;
  final List<Automezzo> automezzi;
  final Estintore? esistente;

  @override
  State<_EstintoreFormDialog> createState() => _EstintoreFormDialogState();
}

class _EstintoreFormDialogState extends State<_EstintoreFormDialog> {
  final _formKey = GlobalKey<FormState>();

  late final _matricolaController =
      TextEditingController(text: widget.esistente?.numeroMatricola ?? '');
  late final _capacitaController =
      TextEditingController(text: widget.esistente?.capacita ?? '');
  late final _noteController =
      TextEditingController(text: widget.esistente?.note ?? '');
  late final _dettaglioUbicazioneController =
      TextEditingController(text: widget.esistente?.dettaglioUbicazione ?? '');

  String? _tipoAgente;

  late _TipoUbicazione _ubicazione;
  String? _cantiereSelezionatoId;
  String? _automezzoSelezionatoId;

  DateTime? _dataProduzione;
  DateTime? _dataMessaInServizio;
  DateTime? _dataVerificaEsterna;
  DateTime? _scadenzaVerificaEsterna;
  DateTime? _ultimaRevisione;
  DateTime? _scadenzaRevisione;
  DateTime? _ultimoCollaudo;
  DateTime? _scadenzaCollaudo;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final e = widget.esistente;
    _tipoAgente = (e == null || e.tipoAgente.isEmpty) ? null : e.tipoAgente;

    if (e == null ||
        (!e.inMagazzino && e.ubicazioneCantiereId.isEmpty && e.ubicazioneAutomezzoId.isEmpty && !e.inUfficio)) {
      _ubicazione = _TipoUbicazione.nessuna;
    } else if (e.inMagazzino) {
      _ubicazione = _TipoUbicazione.magazzino;
    } else if (e.ubicazioneCantiereId.isNotEmpty) {
      _ubicazione = _TipoUbicazione.cantiere;
    } else if (e.inUfficio) {
      _ubicazione = _TipoUbicazione.ufficio;
    } else {
      _ubicazione = _TipoUbicazione.automezzo;
    }
    _cantiereSelezionatoId = (e?.ubicazioneCantiereId.isEmpty ?? true) ? null : e!.ubicazioneCantiereId;
    _automezzoSelezionatoId =
        (e?.ubicazioneAutomezzoId.isEmpty ?? true) ? null : e!.ubicazioneAutomezzoId;

    _dataProduzione = _parseData(e?.dataProduzione ?? '');
    _dataMessaInServizio = _parseData(e?.dataMessaInServizio ?? '');
    _dataVerificaEsterna = _parseData(e?.dataVerificaEsterna ?? '');
    _scadenzaVerificaEsterna = _parseData(e?.scadenzaVerificaEsterna ?? '');
    _ultimaRevisione = _parseData(e?.ultimaRevisione ?? '');
    _scadenzaRevisione = _parseData(e?.scadenzaRevisione ?? '');
    _ultimoCollaudo = _parseData(e?.ultimoCollaudo ?? '');
    _scadenzaCollaudo = _parseData(e?.scadenzaCollaudo ?? '');
  }

  @override
  void dispose() {
    _matricolaController.dispose();
    _capacitaController.dispose();
    _noteController.dispose();
    _dettaglioUbicazioneController.dispose();
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
      final inUfficio = _ubicazione == _TipoUbicazione.ufficio;
      final ubicazioneCantiereId =
          _ubicazione == _TipoUbicazione.cantiere ? _cantiereSelezionatoId : null;
      final ubicazioneAutomezzoId =
          _ubicazione == _TipoUbicazione.automezzo ? _automezzoSelezionatoId : null;

      if (widget.esistente == null) {
        await widget.provider.create(
          numeroMatricola: _matricolaController.text.trim(),
          tipoAgente: _tipoAgente,
          capacita: _capacitaController.text.trim(),
          dataProduzione: _dataProduzione,
          dataMessaInServizio: _dataMessaInServizio,
          note: _noteController.text.trim(),
          inUfficio: inUfficio,
          inMagazzino: inMagazzino,
          ubicazioneAutomezzoId: ubicazioneAutomezzoId,
          ubicazioneCantiereId: ubicazioneCantiereId,
          dettaglioUbicazione: _dettaglioUbicazioneController.text.trim(),
          dataVerificaEsterna: _dataVerificaEsterna,
          scadenzaVerificaEsterna: _scadenzaVerificaEsterna,
          ultimaRevisione: _ultimaRevisione,
          scadenzaRevisione: _scadenzaRevisione,
          ultimoCollaudo: _ultimoCollaudo,
          scadenzaCollaudo: _scadenzaCollaudo,
        );
      } else {
        await widget.provider.update(
          widget.esistente!.id,
          numeroMatricola: _matricolaController.text.trim(),
          tipoAgente: _tipoAgente,
          capacita: _capacitaController.text.trim(),
          dataProduzione: _dataProduzione,
          dataMessaInServizio: _dataMessaInServizio,
          note: _noteController.text.trim(),
          inUfficio: inUfficio,
          inMagazzino: inMagazzino,
          ubicazioneAutomezzoId: ubicazioneAutomezzoId,
          ubicazioneCantiereId: ubicazioneCantiereId,
          dettaglioUbicazione: _dettaglioUbicazioneController.text.trim(),
          dataVerificaEsterna: _dataVerificaEsterna,
          scadenzaVerificaEsterna: _scadenzaVerificaEsterna,
          ultimaRevisione: _ultimaRevisione,
          scadenzaRevisione: _scadenzaRevisione,
          ultimoCollaudo: _ultimoCollaudo,
          scadenzaCollaudo: _scadenzaCollaudo,
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
      title: Text(widget.esistente == null ? l10n.estintoreFormDialogNewTitle : l10n.estintoreFormDialogEditTitle),
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
                  controller: _matricolaController,
                  decoration: InputDecoration(labelText: l10n.estintoreFormDialogMatricolaLabel),
                  validator: (v) => (v == null || v.trim().isEmpty) ? l10n.commonRequiredField : null,
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String?>(
                  borderRadius: BorderRadius.circular(15),
                  initialValue: _tipoAgente,
                  decoration: InputDecoration(labelText: l10n.estintoreFormDialogTipoAgenteLabel),
                  items: [
                    DropdownMenuItem(value: null, child: Text(l10n.estintoreFormDialogTipoAgenteNonSpecificato)),
                    ...tipiAgente.entries
                        .map((e) => DropdownMenuItem(value: e.key, child: Text(e.value)))
                  ],
                  onChanged: (v) => setState(() => _tipoAgente = v)
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _capacitaController,
                  decoration: InputDecoration(labelText: l10n.estintoreFormDialogCapacitaLabel),
                ),
                const Divider(height: 24),
                _campoData(l10n.estintoreFormDialogDataProduzione, _dataProduzione, (v) {
                  _dataProduzione = v;
                  _ultimoCollaudo = _dataProduzione;
                  if (v != null) {
                    _scadenzaCollaudo = _aggiungiPeriodo(v, anni: 10);
                  }
                }),
                _campoData(l10n.estintoreFormDialogDataMessaInServizio, _dataMessaInServizio, (v) {
                  _dataMessaInServizio = v;
                }),
                const Divider(height: 24),
                Text(l10n.estintoreFormDialogSectionUbicazione, style: TextStyle(fontWeight: FontWeight.w600, color: primaryBlue)),
                const SizedBox(height: 8),
                DropdownButtonFormField<_TipoUbicazione>(
                  borderRadius: BorderRadius.circular(15),
                  initialValue: _ubicazione,
                  decoration: InputDecoration(labelText: l10n.estintoreFormDialogTipoUbicazioneLabel),
                  items: [
                    DropdownMenuItem(value: _TipoUbicazione.nessuna, child: Text(l10n.estintoreFormDialogUbicazioneNonSpecificata)),
                    DropdownMenuItem(value: _TipoUbicazione.magazzino, child: Text(l10n.estintoreFormDialogUbicazioneMagazzino)),
                    DropdownMenuItem(value: _TipoUbicazione.ufficio, child: Text(l10n.estintoreFormDialogUbicazioneUfficio)),
                    DropdownMenuItem(value: _TipoUbicazione.cantiere, child: Text(l10n.estintoreFormDialogUbicazioneCantiere)),
                    DropdownMenuItem(value: _TipoUbicazione.automezzo, child: Text(l10n.estintoreFormDialogUbicazioneAutomezzo)),
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
                    decoration: InputDecoration(labelText: l10n.estintoreFormDialogUbicazioneCantiere),
                    items: widget.cantieri
                        .map((c) => DropdownMenuItem(value: c.id, child: Text(c.nome)))
                        .toList(),
                    onChanged: (v) => setState(() => _cantiereSelezionatoId = v),
                    validator: (v) => v == null ? l10n.estintoreFormDialogSelectCantiereValidator : null,
                  ),
                ],
                if (_ubicazione == _TipoUbicazione.automezzo) ...[
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String?>(
                    borderRadius: BorderRadius.circular(15),
                    initialValue: widget.automezzi.any((a) => a.id == _automezzoSelezionatoId)
                        ? _automezzoSelezionatoId
                        : null,
                    decoration: InputDecoration(labelText: l10n.estintoreFormDialogUbicazioneAutomezzo),
                    items: widget.automezzi
                        .map((a) => DropdownMenuItem(
                              value: a.id,
                              child: Text(a.descrizioneConTarga),
                            ))
                        .toList(),
                    onChanged: (v) => setState(() => _automezzoSelezionatoId = v),
                    validator: (v) => v == null ? l10n.estintoreFormDialogSelectAutomezzoValidator : null,
                  ),
                ],
                TextField(
                  controller: _dettaglioUbicazioneController,
                  decoration: InputDecoration(labelText: l10n.estintoreFormDialogDettagliUbicazione),
                ),
                const Divider(height: 24),
                Text(l10n.estintoreFormDialogSectionVerificaEsterna, style: TextStyle(fontWeight: FontWeight.w600, color: primaryBlue)),
                _campoData(l10n.estintoreFormDialogDataVerificaEsterna, _dataVerificaEsterna, (v) {
                  _dataVerificaEsterna = v;
                  if (v != null){
                    _scadenzaVerificaEsterna = _aggiungiPeriodo(v, mesi: 6);
                  }
                }),
                _campoData(l10n.estintoreFormDialogScadenzaVerificaEsterna, _scadenzaVerificaEsterna,
                    (v) =>  _scadenzaVerificaEsterna = v
                ),
                const Divider(height: 24),
                Text(l10n.estintoreFormDialogSectionRevisione, style: TextStyle(fontWeight: FontWeight.w600, color: primaryBlue)),
                _campoData(l10n.estintoreFormDialogUltimaRevisione, _ultimaRevisione, (v) {
                  _ultimaRevisione = v;
                  if (v == null) return;
                  if (_tipoAgente == 'CO2') {
                    _scadenzaRevisione = _aggiungiPeriodo(v, anni: 5);
                  } else if (_dataProduzione != null) {
                    final produzione = _dataProduzione!;
                    _scadenzaRevisione = produzione.isBefore(_sogliaRevisione2024)
                        ? _aggiungiPeriodo(v, anni: 3)
                        : _aggiungiPeriodo(v, anni: 5);
                  }
                }),
                _campoData(l10n.estintoreFormDialogScadenzaRevisione, _scadenzaRevisione,
                    (v) => _scadenzaRevisione = v
                ),
                const Divider(height: 24),
                Text(l10n.estintoreFormDialogSectionCollaudo, style: TextStyle(fontWeight: FontWeight.w600, color: primaryBlue)),
                _campoData(l10n.estintoreFormDialogUltimoCollaudo, _ultimoCollaudo, (v) {
                  _ultimoCollaudo = v;
                  if (v != null){
                    _scadenzaCollaudo = _aggiungiPeriodo(v, anni: 10);
                  }
                }),
                _campoData(l10n.estintoreFormDialogScadenzaCollaudo, _scadenzaCollaudo,
                    (v) => _scadenzaCollaudo = v),
                const Divider(height: 24),
                TextField(
                  controller: _noteController,
                  decoration: InputDecoration(labelText: l10n.estintoreFormDialogNoteAggiuntive)
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
