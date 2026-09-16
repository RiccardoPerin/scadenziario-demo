import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/rifiuto.dart';
import '../providers/rifiuti_provider.dart';
import 'campo_data.dart';

DateTime? _parseData(String value) => value.isEmpty ? null : DateTime.tryParse(value);

Future<void> showRifiutoFormDialog(
  BuildContext context, {
  required RifiutiProvider provider,
  required List<Rifiuto> rifiuti,
  Rifiuto? esistente,
}) {
  return showDialog(
    context: context,
    builder: (_) => _RifiutoFormDialog(
      provider: provider,
      rifiuti: rifiuti,
      esistente: esistente,
    ),
  );
}

class _RifiutoFormDialog extends StatefulWidget {
  const _RifiutoFormDialog({
    required this.provider,
    required this.rifiuti,
    this.esistente,
  });

  final RifiutiProvider provider;
  final List<Rifiuto> rifiuti;
  final Rifiuto? esistente;

  @override
  State<_RifiutoFormDialog> createState() => _RifiutoFormDialogState();
}

class _RifiutoFormDialogState extends State<_RifiutoFormDialog> {
  final _formKey = GlobalKey<FormState>();

  late final _nomeDittaController =
      TextEditingController(text: widget.esistente?.nomeDitta ?? '');

  late final _nrAutorizzazioneTrasportatoreController =
      TextEditingController(text: widget.esistente?.nrAutorizzazioneTrasportatore ?? '');
  late final _noteTrasportatoreController =
      TextEditingController(text: widget.esistente?.noteTrasportatore ?? '');

  late final _nrAutorizzazioneSmaltitoreController=
      TextEditingController(text: widget.esistente?.nrAutorizzazioneSmaltitore ?? '');
  late final _noteSmaltitoreController =
      TextEditingController(text: widget.esistente?.noteSmaltitore ?? '');

  bool _trasportatore = false;
  bool _smaltitore = false;
  bool _autorizzazioneRifiutiPericolosiTrasportatore = false;
  bool _autorizzazioneRifiutiPericolosiSmaltitore = false;

  DateTime? _scadRifiutiNonPericolosiTrasportatore;
  DateTime? _scadRifiutiPericolosiTrasportatore;
  DateTime? _scadRifiutiNonPericolosiSmaltitore;
  DateTime? _scadRifiutiPericolosiSmaltitore;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final r = widget.esistente;

    _trasportatore = r?.trasportatore ?? false;
    _smaltitore = r?.smaltitore ?? false;
    _autorizzazioneRifiutiPericolosiTrasportatore = r?.autorizzazioneRifiutiPericolosiTrasportatore ?? false;
    _autorizzazioneRifiutiPericolosiSmaltitore = r?.autorizzazioneRifiutiPericolosiSmaltitore ?? false;

    _scadRifiutiNonPericolosiTrasportatore = _parseData(r?.scadRifiutiNonPericolosiTrasportatore ?? '');
    _scadRifiutiPericolosiTrasportatore = _parseData(r?.scadRifiutiPericolosiTrasportatore ?? '');
    _scadRifiutiNonPericolosiSmaltitore = _parseData(r?.scadRifiutiNonPericolosiSmaltitore ?? '');
    _scadRifiutiPericolosiSmaltitore = _parseData(r?.scadRifiutiPericolosiSmaltitore ?? '');
  }

  @override
  void dispose() {
    _nomeDittaController.dispose();
    _nrAutorizzazioneTrasportatoreController.dispose();
    _nrAutorizzazioneSmaltitoreController.dispose();
    _noteTrasportatoreController.dispose();
    _noteSmaltitoreController.dispose();
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
          nomeDitta: _nomeDittaController.text.trim(),
          trasportatore: _trasportatore,
          nrAutorizzazioneTrasportatore: _nrAutorizzazioneTrasportatoreController.text.trim(),
          scadRifiutiNonPericolosiTrasportatore: _scadRifiutiNonPericolosiTrasportatore,
          autorizzazioneRifiutiPericolosiTrasportatore: _autorizzazioneRifiutiPericolosiTrasportatore,
          scadRifiutiPericolosiTrasportatore: _scadRifiutiPericolosiTrasportatore,
          noteTrasportatore: _noteTrasportatoreController.text.trim(),
          smaltitore: _smaltitore,
          nrAutorizzazioneSmaltitore: _nrAutorizzazioneSmaltitoreController.text.trim(),
          scadRifiutiNonPericolosiSmaltitore: _scadRifiutiNonPericolosiSmaltitore,
          autorizzazioneRifiutiPericolosiSmaltitore: _autorizzazioneRifiutiPericolosiSmaltitore,
          scadRifiutiPericolosiSmaltitore: _scadRifiutiPericolosiSmaltitore,
          noteSmaltitore: _noteSmaltitoreController.text.trim(),
        );
      } else {
        await widget.provider.update(
          widget.esistente!.id,
          nomeDitta: _nomeDittaController.text.trim(),
          trasportatore: _trasportatore,
          nrAutorizzazioneTrasportatore: _nrAutorizzazioneTrasportatoreController.text.trim(),
          scadRifiutiNonPericolosiTrasportatore: _scadRifiutiNonPericolosiTrasportatore,
          autorizzazioneRifiutiPericolosiTrasportatore: _autorizzazioneRifiutiPericolosiTrasportatore,
          scadRifiutiPericolosiTrasportatore: _scadRifiutiPericolosiTrasportatore,
          noteTrasportatore: _noteTrasportatoreController.text.trim(),
          smaltitore: _smaltitore,
          nrAutorizzazioneSmaltitore: _nrAutorizzazioneSmaltitoreController.text.trim(),
          scadRifiutiNonPericolosiSmaltitore: _scadRifiutiNonPericolosiSmaltitore,
          autorizzazioneRifiutiPericolosiSmaltitore: _autorizzazioneRifiutiPericolosiSmaltitore,
          scadRifiutiPericolosiSmaltitore: _scadRifiutiPericolosiSmaltitore,
          noteSmaltitore: _noteSmaltitoreController.text.trim(),
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
      title: Text(widget.esistente == null ? l10n.rifiutoFormDialogNewTitle : l10n.rifiutoFormDialogEditTitle),
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
                  controller: _nomeDittaController,
                  decoration: InputDecoration(labelText: l10n.rifiutoFormDialogNomeDittaLabel),
                  validator: (v) => (v == null || v.trim().isEmpty) ? l10n.commonRequiredField : null,
                ),

                const Divider(height: 24),
                Text(l10n.rifiutoFormDialogSectionTrasportatore, style: TextStyle(fontWeight: FontWeight.w600, color: primaryBlue)),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(l10n.rifiutoFormDialogIsTrasportatore),
                  value: _trasportatore,
                  onChanged: (v) => setState(() {
                    _trasportatore = v;
                    if (!v) {
                      _scadRifiutiPericolosiTrasportatore = null;
                      _scadRifiutiNonPericolosiTrasportatore = null;
                    }
                  }),
                ),
                if (_trasportatore) ... [
                  TextFormField(
                    controller: _nrAutorizzazioneTrasportatoreController,
                    decoration: InputDecoration(labelText: l10n.rifiutoFormDialogNrAutorizzazioneTrasportatore),
                  ),
                  const SizedBox(height: 8),
                  _campoData(l10n.rifiutoFormDialogScadNonPericolosiTrasportatore, _scadRifiutiNonPericolosiTrasportatore, (v) {
                    _scadRifiutiNonPericolosiTrasportatore = v;
                  }),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(l10n.rifiutoFormDialogAutorizzazionePericolosi),
                    value: _autorizzazioneRifiutiPericolosiTrasportatore,
                    onChanged: (v) => setState(() {
                      _autorizzazioneRifiutiPericolosiTrasportatore = v;
                      if (!v) _scadRifiutiPericolosiTrasportatore = null;
                    }),
                  ),
                  if (_autorizzazioneRifiutiPericolosiTrasportatore) ... [
                    const SizedBox(height: 8),
                    _campoData(l10n.rifiutoFormDialogScadPericolosiTrasportatore, _scadRifiutiPericolosiTrasportatore, (v) {
                      _scadRifiutiPericolosiTrasportatore = v;
                    })
                  ],
                  TextFormField(
                    controller: _noteTrasportatoreController,
                    decoration: InputDecoration(labelText: l10n.rifiutoFormDialogNoteTrasportatore),
                  ),
                ],

                const Divider(height: 24),
                Text(l10n.rifiutoFormDialogSectionSmaltitore, style: TextStyle(fontWeight: FontWeight.w600, color: primaryBlue)),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(l10n.rifiutoFormDialogIsSmaltitore),
                  value: _smaltitore,
                  onChanged: (v) => setState(() {
                    _smaltitore = v;
                    if (!v) {
                      _scadRifiutiPericolosiSmaltitore = null;
                      _scadRifiutiNonPericolosiSmaltitore = null;
                    }
                  }),
                ),
                if (_smaltitore) ... [
                  TextFormField(
                    controller: _nrAutorizzazioneSmaltitoreController,
                    decoration: InputDecoration(labelText: l10n.rifiutoFormDialogNrAutorizzazioneSmaltitore),
                  ),
                  const SizedBox(height: 8),
                  _campoData(l10n.rifiutoFormDialogScadNonPericolosiSmaltitore, _scadRifiutiNonPericolosiSmaltitore, (v) {
                    _scadRifiutiNonPericolosiSmaltitore = v;
                  }),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(l10n.rifiutoFormDialogAutorizzazionePericolosi),
                    value: _autorizzazioneRifiutiPericolosiSmaltitore,
                    onChanged: (v) => setState(() {
                      _autorizzazioneRifiutiPericolosiSmaltitore = v;
                      if (!v) _scadRifiutiPericolosiSmaltitore = null;
                    }),
                  ),
                  if (_autorizzazioneRifiutiPericolosiSmaltitore) ... [
                    const SizedBox(height: 8),
                    _campoData(l10n.rifiutoFormDialogScadPericolosiSmaltitore, _scadRifiutiPericolosiSmaltitore, (v) {
                      _scadRifiutiPericolosiSmaltitore = v;
                    })
                  ],
                  TextFormField(
                    controller: _noteSmaltitoreController,
                    decoration: InputDecoration(labelText: l10n.rifiutoFormDialogNoteSmaltitore),
                  ),
                ],
                const Divider(height: 24),
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
