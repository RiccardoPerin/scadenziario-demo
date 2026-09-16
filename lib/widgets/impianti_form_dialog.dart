import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/impianto.dart';
import '../providers/impianti_provider.dart';
import 'campo_data.dart';

DateTime? _parseData(String value) => value.isEmpty ? null : DateTime.tryParse(value);

DateTime _aggiungiPeriodo(DateTime data, {int anni = 0, int mesi = 0}) {
  return DateTime(data.year + anni, data.month + mesi, data.day);
}

enum _TipoUbicazione { nessuna, magazzino, ufficio }

Future<void> showImpiantoFormDialog(
  BuildContext context, {
  required ImpiantiProvider provider,
  required List<Impianto> impianti,
  Impianto? esistente,
}) {
  return showDialog(
    context: context,
    builder: (_) => _ImpiantoFormDialog(
      provider: provider,
      impianti: impianti,
      esistente: esistente,
    ),
  );
}

class _ImpiantoFormDialog extends StatefulWidget {
  const _ImpiantoFormDialog({
    required this.provider,
    required this.impianti,
    this.esistente,
  });

  final ImpiantiProvider provider;
  final List<Impianto> impianti;
  final Impianto? esistente;

  @override
  State<_ImpiantoFormDialog> createState() => _ImpiantoFormDialogState();
}

class _ImpiantoFormDialogState extends State<_ImpiantoFormDialog> {
  final _formKey = GlobalKey<FormState>();

  late final _tipologiaController =
      TextEditingController(text: widget.esistente?.tipologia ?? '');
  late final _dittaInstallatriceController =
      TextEditingController(text: widget.esistente?.dittaInstallatrice ?? '');
  late final _tipoVerificaInternaController =
      TextEditingController(text: widget.esistente?.tipoVerificaInternaEffettuata ?? '');
  late final _tipoVerificaEsternaController =
      TextEditingController(text: widget.esistente?.tipoVerificaEsternaEffettuata ?? '');
  late final _noteController = 
      TextEditingController(text: widget.esistente?.note ?? '');

  late _TipoUbicazione _ubicazione;

  DateTime? _dataInstallazione;
  DateTime? _dataValutazione;
  DateTime? _dataManutenzioneInterna;
  DateTime? _scadenzaManutenzioneInterna;
  DateTime? _dataManutenzioneEsterna;
  DateTime? _scadenzaManutenzioneEsterna;
  DateTime? _scadenzaValutazioneScaricheAtmosferiche;

  bool _isSaving = false;
  bool _mostraScadenzaScaricheAtmosferiche = false;

  @override
  void initState() {
    super.initState();
    final i = widget.esistente;

    if (i == null ||
        (!i.inMagazzino && !i.inUfficio)) {
      _ubicazione = _TipoUbicazione.nessuna;
    } else if (i.inMagazzino) {
      _ubicazione = _TipoUbicazione.magazzino;
    } else if (i.inUfficio) {
      _ubicazione = _TipoUbicazione.ufficio;
    }

    _dataInstallazione = _parseData(i?.dataInstallazione ?? '');
    _dataValutazione = _parseData(i?.dataValutazione ?? '');
    _dataManutenzioneInterna = _parseData(i?.dataManutenzioneInterna ?? '');
    _dataManutenzioneEsterna = _parseData(i?.dataManutenzioneEsterna ?? '');
    _scadenzaManutenzioneEsterna = _parseData(i?.scadenzaManutenzioneEsterna ?? '');
    _scadenzaManutenzioneInterna = _parseData(i?.scadenzaManutenzioneInterna ?? '');
    _scadenzaValutazioneScaricheAtmosferiche = _parseData(i?.scadenzaValutazioneScaricheAtmosferiche ?? '');
  }

  @override
  void dispose() {
    _tipologiaController.dispose();
    _tipoVerificaEsternaController.dispose();
    _tipoVerificaInternaController.dispose();
    _dittaInstallatriceController.dispose();
    _noteController.dispose();
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
      final inMagazzino = _ubicazione == _TipoUbicazione.magazzino;
      final inUfficio = _ubicazione == _TipoUbicazione.ufficio;

      if (widget.esistente == null) {
        await widget.provider.create(
          tipologia: _tipologiaController.text.trim(),
          tipoVerificaEsternaEffettuata: _tipoVerificaEsternaController.text.trim(),
          tipoVerificaInternaEffettuata: _tipoVerificaInternaController.text.trim(),
          note: _noteController.text.trim(),
          inUfficio: inUfficio,
          inMagazzino: inMagazzino,
          dittaInstallatrice: _dittaInstallatriceController.text.trim(),
          dataInstallazione: _dataInstallazione,
          dataValutazione: _dataValutazione,
          dataManutenzioneEsterna: _dataManutenzioneEsterna,
          dataManutenzioneInterna: _dataManutenzioneInterna,
          scadenzaManutenzioneEsterna: _scadenzaManutenzioneEsterna,
          scadenzaManutenzioneInterna: _scadenzaManutenzioneInterna,
          scadenzaValutazioneScaricheAtmosferiche: _scadenzaValutazioneScaricheAtmosferiche,
        );
      } else {
        await widget.provider.update(
          widget.esistente!.id,
          tipologia: _tipologiaController.text.trim(),
          tipoVerificaEsternaEffettuata: _tipoVerificaEsternaController.text.trim(),
          tipoVerificaInternaEffettuata: _tipoVerificaInternaController.text.trim(),
          note: _noteController.text.trim(),
          inUfficio: inUfficio,
          inMagazzino: inMagazzino,
          dittaInstallatrice: _dittaInstallatriceController.text.trim(),
          dataInstallazione: _dataInstallazione,
          dataValutazione: _dataValutazione,
          dataManutenzioneEsterna: _dataManutenzioneEsterna,
          dataManutenzioneInterna: _dataManutenzioneInterna,
          scadenzaManutenzioneEsterna: _scadenzaManutenzioneEsterna,
          scadenzaManutenzioneInterna: _scadenzaManutenzioneInterna,
          scadenzaValutazioneScaricheAtmosferiche: _scadenzaValutazioneScaricheAtmosferiche,
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
      title: Text(widget.esistente == null
          ? l10n.impiantiFormDialogNewTitle
          : l10n.impiantiFormDialogEditTitle),
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
                  controller: _tipologiaController,
                  decoration: InputDecoration(labelText: l10n.impiantiFormDialogTypeLabel),
                  validator: (v) => (v == null || v.trim().isEmpty) ? l10n.commonRequiredField : null,
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<_TipoUbicazione>(
                  borderRadius: BorderRadius.circular(15),
                  initialValue: _ubicazione,
                  decoration: InputDecoration(labelText: l10n.impiantiFormDialogLocationTypeLabel),
                  items: [
                    DropdownMenuItem(value: _TipoUbicazione.nessuna, child: Text(l10n.impiantiFormDialogUnspecifiedOption)),
                    DropdownMenuItem(value: _TipoUbicazione.magazzino, child: Text(l10n.impiantiFormDialogLocationWarehouse)),
                    DropdownMenuItem(value: _TipoUbicazione.ufficio, child: Text(l10n.impiantiFormDialogLocationOffice)),
                  ],
                  onChanged: (v) => setState(() => _ubicazione = v ?? _TipoUbicazione.nessuna),
                ),
                const Divider(height: 24),
                Text(l10n.impiantiFormDialogInstallationSectionTitle, style: TextStyle(fontWeight: FontWeight.w600, color: primaryBlue)),
                _campoData(l10n.impiantiFormDialogInstallDateLabel, _dataInstallazione, (v) => _dataInstallazione = v),
                TextFormField(
                  controller: _dittaInstallatriceController,
                  decoration: InputDecoration(labelText: l10n.impiantiFormDialogInstallerCompanyLabel),
                ),
                const SizedBox(height: 8),
                _campoData(l10n.impiantiFormDialogAssessmentDateLabel, _dataValutazione, (v) => _dataValutazione = v),
                const Divider(height: 24),
                Text(l10n.impiantiFormDialogInternalMaintenanceSectionTitle, style: TextStyle(fontWeight: FontWeight.w600, color: primaryBlue)),
                _campoData(l10n.impiantiFormDialogInternalMaintDateLabel, _dataManutenzioneInterna, (v) {
                  _dataManutenzioneInterna = v;
                  if (v != null) {
                    _scadenzaManutenzioneInterna = _aggiungiPeriodo(v, anni: 1);
                  }
                }),
                _campoData(l10n.impiantiFormDialogInternalMaintDeadlineLabel, _scadenzaManutenzioneInterna, (v) {
                  _scadenzaManutenzioneInterna = v;
                }),
                TextField(
                  controller: _tipoVerificaInternaController,
                  decoration: InputDecoration(labelText: l10n.impiantiFormDialogInternalCheckTypeLabel),
                ),
                const Divider(height: 24),
                Text(l10n.impiantiFormDialogExternalMaintenanceSectionTitle, style: TextStyle(fontWeight: FontWeight.w600, color: primaryBlue)),
                _campoData(l10n.impiantiFormDialogExternalMaintDateLabel, _dataManutenzioneEsterna, (v) {
                  _dataManutenzioneEsterna = v;
                }),
                _campoData(l10n.impiantiFormDialogExternalMaintDeadlineLabel, _scadenzaManutenzioneEsterna, (v) {
                  _scadenzaManutenzioneEsterna = v;
                }),
                TextField(
                  controller: _tipoVerificaEsternaController,
                  decoration: InputDecoration(labelText: l10n.impiantiFormDialogExternalCheckTypeLabel),
                ),
                const Divider(height: 24),
                if (_mostraScadenzaScaricheAtmosferiche) ... [
                  Text(l10n.impiantiFormDialogLightningSectionTitle, style: TextStyle(fontWeight: FontWeight.w600, color: primaryBlue)),
                  _campoData(
                      l10n.impiantiFormDialogLightningAssessmentDeadlineLabel,
                      _scadenzaValutazioneScaricheAtmosferiche,
                      (v) => _scadenzaValutazioneScaricheAtmosferiche = v,
                      onRimuovi: () => setState(() {
                        _mostraScadenzaScaricheAtmosferiche = false;
                        _scadenzaValutazioneScaricheAtmosferiche = null;
                      }),
                      tooltipRimuovi: l10n.impiantiFormDialogRemoveLightningAssessmentTooltip,
                    )
                ]
                else ... [
                  Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton.icon(
                        onPressed: () => setState(() => _mostraScadenzaScaricheAtmosferiche = true),
                        label: Text(l10n.impiantiFormDialogAddLightningAssessmentLabel, style: const TextStyle(fontSize: 12)),
                        icon: Icon(Icons.add, color: primaryBlue, size: 12),
                      ),
                    ),
                ],
                const Divider(height: 24),
                TextField(
                  controller: _noteController,
                  decoration: InputDecoration(labelText: l10n.impiantiFormDialogAdditionalNotesLabel)
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
