import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/automezzo.dart';
import '../models/cantiere.dart';
import '../models/macchinario.dart';
import '../providers/macchinari_provider.dart';
import 'campo_data.dart';

DateTime? _parseData(String value) => value.isEmpty ? null : DateTime.tryParse(value);

/// Somma anni/mesi a una data mantenendo lo stesso giorno (usato per
/// precompilare la scadenza a partire dalla data dell'intervento/verifica).
DateTime _aggiungiPeriodo(DateTime data, {int anni = 0, int mesi = 0}) {
  return DateTime(data.year + anni, data.month + mesi, data.day);
}

/// Le chiavi restano in italiano perché sono usate come valori interni
/// (confrontate con `_proprietaSelezionata`); solo i testi mostrati sono
/// tradotti tramite [l10n].
Map<String, String> proprietaLabels(AppLocalizations l10n) => {
  'proprieta': l10n.macchinarioFormDialogOwnershipOwned,
  'noleggio': l10n.macchinarioFormDialogOwnershipRented,
  'leasing': l10n.macchinarioFormDialogOwnershipLeased,
};

enum _TipoUbicazione { nessuna, magazzino, cantiere, automezzo }

Future<void> showMacchinarioFormDialog(
  BuildContext context, {
  required MacchinariProvider provider,
  required List<Cantiere> cantieri,
  required List<Automezzo> automezzi,
  Macchinario? esistente,
}) {
  return showDialog(
    context: context,
    builder: (_) => _MacchinarioFormDialog(
      provider: provider,
      cantieri: cantieri,
      automezzi: automezzi,
      esistente: esistente,
    ),
  );
}

class _MacchinarioFormDialog extends StatefulWidget {
  const _MacchinarioFormDialog({
    required this.provider,
    required this.cantieri,
    required this.automezzi,
    this.esistente,
  });

  final MacchinariProvider provider;
  final List<Cantiere> cantieri;
  final List<Automezzo> automezzi;
  final Macchinario? esistente;

  @override
  State<_MacchinarioFormDialog> createState() => _MacchinarioFormDialogState();
}

class _MacchinarioFormDialogState extends State<_MacchinarioFormDialog> {
  final _formKey = GlobalKey<FormState>();

  late final _modelloController =
      TextEditingController(text: widget.esistente?.modello ?? '');
  late final _matricolaController =
      TextEditingController(text: widget.esistente?.numeroMatricola ?? '');
  late final _fabbricaController =
      TextEditingController(text: widget.esistente?.numeroFabbrica ?? '');
  late final _nomeAssicurazioneController = 
      TextEditingController(text: widget.esistente?.nomeAssicurazione ?? '');
  late final _nomeLeasingController = 
      TextEditingController(text: widget.esistente?.nomeLeasing ?? '');
  late final _nomeNoleggioController = 
      TextEditingController(text: widget.esistente?.nomeNoleggio ?? '');
  late final _emailNoleggioController = 
      TextEditingController(text: widget.esistente?.emailNoleggio ?? '');
  late final _noteController = 
      TextEditingController(text: widget.esistente?.note ?? '');
  late final _annoController = TextEditingController(
    text: widget.esistente == null || widget.esistente!.annoAcquisto == 0
        ? ''
        : widget.esistente!.annoAcquisto.toString(),
  );

  String? _tipologia;
  String? _proprietaSelezionata;
  bool _presenteInCivaInail = false;
  bool _inUso = true;
  late _TipoUbicazione _ubicazione;
  String? _cantiereSelezionatoId;
  String? _automezzoSelezionatoId;

  DateTime? _dataManutenzioneInterna;
  DateTime? _scadenzaManutenzioneInterna;
  DateTime? _dataControlloFuniCatene;
  DateTime? _scadenzaControlloFuniCatene;
  DateTime? _dataVerificaAnnuale;
  DateTime? _scadenzaVerificaAnnuale;
  DateTime? _dataVerificaVentennale;
  DateTime? _scadenzaVerificaVentennale;
  DateTime? _scadenzaAssicurazione;
  DateTime? _scadenzaLeasing;

  bool _mostraScadenzaAssicurazione = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final m = widget.esistente;
    _tipologia = (m == null || m.tipologia.isEmpty) ? null : m.tipologia;
    _proprietaSelezionata = (m == null || m.proprieta.isEmpty) ? null : m.proprieta;
    _presenteInCivaInail = m?.presenteInCivaInail ?? false;

    if (m == null ||
        (!m.inMagazzino && m.ubicazioneCantiereId.isEmpty && m.ubicazioneAutomezzoId.isEmpty)) {
      _ubicazione = _TipoUbicazione.nessuna;
    } else if (m.inMagazzino) {
      _ubicazione = _TipoUbicazione.magazzino;
    } else if (m.ubicazioneCantiereId.isNotEmpty) {
      _ubicazione = _TipoUbicazione.cantiere;
    } else {
      _ubicazione = _TipoUbicazione.automezzo;
    }
    _cantiereSelezionatoId = (m?.ubicazioneCantiereId.isEmpty ?? true) ? null : m!.ubicazioneCantiereId;
    _automezzoSelezionatoId =
        (m?.ubicazioneAutomezzoId.isEmpty ?? true) ? null : m!.ubicazioneAutomezzoId;

    _dataManutenzioneInterna = _parseData(m?.dataManutenzioneInterna ?? '');
    _scadenzaManutenzioneInterna = _parseData(m?.scadenzaManutenzioneInterna ?? '');
    _dataControlloFuniCatene = _parseData(m?.dataControlloFuniCatene ?? '');
    _scadenzaControlloFuniCatene = _parseData(m?.scadenzaControlloFuniCatene ?? '');
    _dataVerificaAnnuale = _parseData(m?.dataVerificaAnnuale ?? '');
    _scadenzaVerificaAnnuale = _parseData(m?.scadenzaVerificaAnnuale ?? '');
    _dataVerificaVentennale = _parseData(m?.dataVerificaVentennale ?? '');
    _scadenzaVerificaVentennale = _parseData(m?.scadenzaVerificaVentennale ?? '');
    _scadenzaAssicurazione = _parseData(m?.scadenzaAssicurazione ?? '');
    _scadenzaLeasing = _parseData(m?.scadenzaLeasing ?? '');
    _mostraScadenzaAssicurazione = _scadenzaAssicurazione != null;
  }

  @override
  void dispose() {
    _modelloController.dispose();
    _matricolaController.dispose();
    _fabbricaController.dispose();
    _annoController.dispose();
    _noteController.dispose();
    _nomeAssicurazioneController.dispose();
    _nomeLeasingController.dispose();
    _nomeNoleggioController.dispose();
    _emailNoleggioController.dispose();
    super.dispose();
  }

  Widget _campoData(
    String label,
    DateTime? valore,
    ValueChanged<DateTime?> onChanged, {
    VoidCallback? onRimuovi,
    String? tooltipRimuovi,
  }) {
    return CampoData(
      label: label,
      valore: valore,
      onChanged: (v) => setState(() => onChanged(v)),
      onRimuovi: onRimuovi,
      tooltipRimuovi: tooltipRimuovi,
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);
    try {
      final annoAcquisto = int.tryParse(_annoController.text.trim());
      final ubicazioneCantiereId =
          _ubicazione == _TipoUbicazione.cantiere ? _cantiereSelezionatoId : null;
      final ubicazioneAutomezzoId =
          _ubicazione == _TipoUbicazione.automezzo ? _automezzoSelezionatoId : null;
      final inMagazzino = _ubicazione == _TipoUbicazione.magazzino;

      if (widget.esistente == null) {
        await widget.provider.create(
          modello: _modelloController.text.trim(),
          numeroMatricola: _matricolaController.text.trim(),
          numeroFabbrica: _fabbricaController.text.trim(),
          tipologia: _tipologia,
          annoAcquisto: annoAcquisto,
          proprieta: _proprietaSelezionata,
          nomeLeasing: _nomeLeasingController.text.trim(),
          scadenzaLeasing: _scadenzaLeasing,
          nomeNoleggio: _nomeNoleggioController.text.trim(),
          emailNoleggio: _emailNoleggioController.text.trim(),
          presenteInCivaInail: _presenteInCivaInail,
          inUso: _inUso,
          inMagazzino: inMagazzino,
          ubicazioneCantiereId: ubicazioneCantiereId,
          ubicazioneAutomezzoId: ubicazioneAutomezzoId,
          dataManutenzioneInterna: _dataManutenzioneInterna,
          scadenzaManutenzioneInterna: _scadenzaManutenzioneInterna,
          dataControlloFuniCatene: _dataControlloFuniCatene,
          scadenzaControlloFuniCatene: _scadenzaControlloFuniCatene,
          dataVerificaAnnuale: _dataVerificaAnnuale,
          scadenzaVerificaAnnuale: _scadenzaVerificaAnnuale,
          dataVerificaVentennale: _dataVerificaVentennale,
          scadenzaVerificaVentennale: _scadenzaVerificaVentennale,
          nomeAssicurazione: _nomeAssicurazioneController.text.trim(),
          scadenzaAssicurazione: _scadenzaAssicurazione,
          note: _noteController.text.trim(),
        );
      } else {
        await widget.provider.update(
          widget.esistente!.id,
          modello: _modelloController.text.trim(),
          numeroMatricola: _matricolaController.text.trim(),
          numeroFabbrica: _fabbricaController.text.trim(),
          tipologia: _tipologia,
          annoAcquisto: annoAcquisto,
          proprieta: _proprietaSelezionata,
          nomeLeasing: _nomeLeasingController.text.trim(),
          scadenzaLeasing: _scadenzaLeasing,
          nomeNoleggio: _nomeNoleggioController.text.trim(),
          emailNoleggio: _emailNoleggioController.text.trim(),
          presenteInCivaInail: _presenteInCivaInail,
          inUso: _inUso,
          inMagazzino: inMagazzino,
          ubicazioneCantiereId: ubicazioneCantiereId,
          ubicazioneAutomezzoId: ubicazioneAutomezzoId,
          dataManutenzioneInterna: _dataManutenzioneInterna,
          scadenzaManutenzioneInterna: _scadenzaManutenzioneInterna,
          dataControlloFuniCatene: _dataControlloFuniCatene,
          scadenzaControlloFuniCatene: _scadenzaControlloFuniCatene,
          dataVerificaAnnuale: _dataVerificaAnnuale,
          scadenzaVerificaAnnuale: _scadenzaVerificaAnnuale,
          dataVerificaVentennale: _dataVerificaVentennale,
          scadenzaVerificaVentennale: _scadenzaVerificaVentennale,
          nomeAssicurazione: _nomeAssicurazioneController.text.trim(),
          scadenzaAssicurazione: _scadenzaAssicurazione,
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
    final proprieta = proprietaLabels(l10n);
    final primaryBlue = Theme.of(context).primaryColor;
    return AlertDialog(
      title: Text(widget.esistente == null
          ? l10n.macchinarioFormDialogNewTitle
          : l10n.macchinarioFormDialogEditTitle),
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
                  controller: _modelloController,
                  decoration: InputDecoration(labelText: l10n.macchinarioFormDialogModelLabel),
                  validator: (v) => (v == null || v.trim().isEmpty) ? l10n.commonRequiredField : null,
                ),
                TextFormField(
                  controller: _matricolaController,
                  decoration: InputDecoration(labelText: l10n.macchinarioFormDialogSerialNumberLabel),
                ),
                TextFormField(
                  controller: _fabbricaController,
                  decoration: InputDecoration(labelText: l10n.macchinarioFormDialogFactoryNumberLabel),
                ),
                TextFormField(
                  controller: _annoController,
                  decoration: InputDecoration(labelText: l10n.macchinarioFormDialogPurchaseYearLabel),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String?>(
                  borderRadius: BorderRadius.circular(15),
                  initialValue: _tipologia,
                  decoration: InputDecoration(labelText: l10n.macchinarioFormDialogTypeLabel),
                  items: [
                    DropdownMenuItem(value: null, child: Text(l10n.macchinarioFormDialogUnspecifiedOption)),
                    ...tipologieMacchinario.entries
                        .map((e) => DropdownMenuItem(value: e.key, child: Text(e.value))),
                  ],
                  onChanged: (v) => setState(() => _tipologia = v),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String?>(
                  borderRadius: BorderRadius.circular(15),
                  initialValue: _proprietaSelezionata,
                  decoration: InputDecoration(labelText: l10n.macchinarioFormDialogOwnershipLabel),
                  items: [
                    DropdownMenuItem(value: null, child: Text(l10n.macchinarioFormDialogUnspecifiedOption)),
                    ...proprieta.entries
                        .map((e) => DropdownMenuItem(value: e.key, child: Text(e.value))),
                  ],
                  onChanged: (v) {
                    setState(() => _proprietaSelezionata = v);
                    _nomeNoleggioController.text = '';
                    _emailNoleggioController.text = '';
                    _nomeLeasingController.text = '';
                    _scadenzaLeasing = null;
                  }
                ),
                if (_proprietaSelezionata == 'leasing') ... [
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _nomeLeasingController,
                    decoration: InputDecoration(labelText: l10n.macchinarioFormDialogLeasingCompanyLabel)
                  ),
                  const SizedBox(height: 8),
                  _campoData(l10n.macchinarioFormDialogLeasingDeadlineLabel, _scadenzaLeasing, (v) => _scadenzaLeasing = v),
                ]
                else if (_proprietaSelezionata == 'noleggio') ... [
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _nomeNoleggioController,
                    decoration: InputDecoration(labelText: l10n.macchinarioFormDialogRentalCompanyLabel)
                  ),
                  TextFormField(
                    controller: _emailNoleggioController,
                    decoration: InputDecoration(labelText: l10n.macchinarioFormDialogRentalEmailLabel),
                    validator: (v) => (v != null && !v.contains('@')) ? l10n.macchinarioFormDialogInvalidEmailValidator : null,
                  )
                ],
                const SizedBox(height: 8),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(l10n.macchinarioFormDialogCivaInailLabel),
                  value: _presenteInCivaInail,
                  onChanged: (v) => setState(() => _presenteInCivaInail = v),
                ),
                const Divider(height: 24),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(l10n.macchinarioFormDialogInUseLabel),
                  value: _inUso,
                  onChanged: (v) => setState(() {
                    _inUso = v;
                    if (!v) {
                      _scadenzaAssicurazione = null;
                      _scadenzaControlloFuniCatene = null;
                      _scadenzaManutenzioneInterna = null;
                      _scadenzaVerificaAnnuale = null;
                      _scadenzaVerificaVentennale = null;
                    }
                  }),
                ),
                if (_inUso) ... [
                  Text(l10n.macchinarioFormDialogLocationSectionTitle, style: TextStyle(fontWeight: FontWeight.w600, color: primaryBlue)),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<_TipoUbicazione>(
                    borderRadius: BorderRadius.circular(15),
                    initialValue: _ubicazione,
                    decoration: InputDecoration(labelText: l10n.macchinarioFormDialogLocationTypeLabel),
                    items: [
                      DropdownMenuItem(value: _TipoUbicazione.nessuna, child: Text(l10n.macchinarioFormDialogUnspecifiedOption)),
                      DropdownMenuItem(value: _TipoUbicazione.magazzino, child: Text(l10n.macchinarioFormDialogLocationWarehouse)),
                      DropdownMenuItem(value: _TipoUbicazione.cantiere, child: Text(l10n.macchinarioFormDialogLocationSite)),
                      DropdownMenuItem(value: _TipoUbicazione.automezzo, child: Text(l10n.macchinarioFormDialogLocationVehicle)),
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
                      decoration: InputDecoration(labelText: l10n.macchinarioFormDialogLocationSite),
                      items: widget.cantieri
                          .map((c) => DropdownMenuItem(value: c.id, child: Text(c.nome)))
                          .toList(),
                      onChanged: (v) => setState(() => _cantiereSelezionatoId = v),
                      validator: (v) => v == null ? l10n.macchinarioFormDialogSiteValidator : null,
                    ),
                  ],
                  if (_ubicazione == _TipoUbicazione.automezzo) ...[
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String?>(
                      borderRadius: BorderRadius.circular(15),
                      initialValue: widget.automezzi.any((a) => a.id == _automezzoSelezionatoId)
                          ? _automezzoSelezionatoId
                          : null,
                      decoration: InputDecoration(labelText: l10n.macchinarioFormDialogLocationVehicle),
                      items: widget.automezzi
                          .map((a) => DropdownMenuItem(
                                value: a.id,
                                child: Text(a.descrizioneConTarga),
                              ))
                          .toList(),
                      onChanged: (v) => setState(() => _automezzoSelezionatoId = v),
                      validator: (v) => v == null ? l10n.macchinarioFormDialogVehicleValidator : null,
                    ),
                  ],
                  const Divider(height: 24),
                  if (_mostraScadenzaAssicurazione) ... [
                    TextFormField(
                      controller: _nomeAssicurazioneController,
                      decoration: InputDecoration(labelText: l10n.macchinarioFormDialogInsuranceCompanyLabel),
                    ),
                    _campoData(
                      l10n.macchinarioFormDialogInsuranceDeadlineLabel,
                      _scadenzaAssicurazione, (v) => _scadenzaAssicurazione = v,
                      onRimuovi: () => setState(() {
                          _mostraScadenzaAssicurazione = false;
                          _scadenzaAssicurazione = null;
                        }),
                        tooltipRimuovi: l10n.macchinarioFormDialogRemoveInsuranceDeadlineTooltip,
                    )
                  ]
                  else
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton.icon(
                          onPressed: () => setState(() => _mostraScadenzaAssicurazione = true),
                          label: Text(l10n.macchinarioFormDialogAddInsuranceDeadlineLabel, style: const TextStyle(fontSize: 12)),
                          icon: Icon(Icons.add, color: primaryBlue, size: 12),
                        ),
                      ),
                  const Divider(height: 24),
                  Text(l10n.macchinarioFormDialogInternalMaintenanceSectionTitle, style: TextStyle(fontWeight: FontWeight.w600, color: primaryBlue)),
                  _campoData(l10n.macchinarioFormDialogInterventionDateLabel, _dataManutenzioneInterna, (v) {
                    _dataManutenzioneInterna = v;
                  }),
                  _campoData(l10n.macchinarioFormDialogDeadlineLabel, _scadenzaManutenzioneInterna,
                      (v) => _scadenzaManutenzioneInterna = v),
                  const Divider(height: 24),
                  Text(l10n.macchinarioFormDialogRopeChainCheckSectionTitle, style: TextStyle(fontWeight: FontWeight.w600, color: primaryBlue)),
                  _campoData(l10n.macchinarioFormDialogCheckDateLabel, _dataControlloFuniCatene, (v) {
                    _dataControlloFuniCatene = v;
                    if (v != null) {
                      _scadenzaControlloFuniCatene = _aggiungiPeriodo(v, mesi: 3);
                    }
                  }),
                  _campoData(l10n.macchinarioFormDialogDeadlineLabel, _scadenzaControlloFuniCatene,
                      (v) => _scadenzaControlloFuniCatene = v),
                  const Divider(height: 24),
                  Text(l10n.macchinarioFormDialogAnnualCheckSectionTitle, style: TextStyle(fontWeight: FontWeight.w600, color: primaryBlue)),
                  _campoData(l10n.macchinarioFormDialogInspectionDateLabel, _dataVerificaAnnuale, (v) {
                    _dataVerificaAnnuale = v;
                    if (v != null) {
                      _scadenzaVerificaAnnuale = _aggiungiPeriodo(v, anni: 1);
                    }
                  }),
                  _campoData(
                      l10n.macchinarioFormDialogDeadlineLabel, _scadenzaVerificaAnnuale, (v) => _scadenzaVerificaAnnuale = v),
                  const Divider(height: 24),
                  Text(l10n.macchinarioFormDialogTwentyYearCheckSectionTitle, style: TextStyle(fontWeight: FontWeight.w600, color: primaryBlue)),
                  _campoData(l10n.macchinarioFormDialogInspectionDateLabel, _dataVerificaVentennale, (v) {
                    _dataVerificaVentennale = v;
                    if (v != null) {
                      _scadenzaVerificaVentennale = _aggiungiPeriodo(v, anni: 20);
                    }
                  }),
                  _campoData(l10n.macchinarioFormDialogDeadlineLabel, _scadenzaVerificaVentennale,
                    (v) => _scadenzaVerificaVentennale = v),
                ],

                const Divider(height: 24),
                TextField(
                  controller: _noteController,
                  decoration: InputDecoration(labelText: l10n.macchinarioFormDialogAdditionalNotesLabel)
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
