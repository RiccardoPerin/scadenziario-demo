import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/controllo_segnale.dart';
import '../models/segnale.dart';
import '../providers/controlli_segnali_provider.dart';
import 'campo_data.dart';

DateTime? _parseData(String value) =>
    value.isEmpty ? null : DateTime.tryParse(value);

/// Form di registrazione/modifica di un controllo su un cartello.
/// Passando [esistente] il dialog lavora in modifica; passando [segnale] il
/// cartello è già scelto (apertura dal dettaglio di un segnale) e non è
/// modificabile.
Future<void> showControlloSegnaleFormDialog(
  BuildContext context, {
  required ControlliSegnaliProvider provider,
  required List<Segnale> segnali,
  Segnale? segnale,
  ControlloSegnale? esistente,
}) {
  return showDialog(
    context: context,
    builder: (_) => _ControlloSegnaleFormDialog(
      provider: provider,
      segnali: segnali,
      segnale: segnale,
      esistente: esistente,
    ),
  );
}

class _ControlloSegnaleFormDialog extends StatefulWidget {
  const _ControlloSegnaleFormDialog({
    required this.provider,
    required this.segnali,
    this.segnale,
    this.esistente,
  });

  final ControlliSegnaliProvider provider;
  final List<Segnale> segnali;
  final Segnale? segnale;
  final ControlloSegnale? esistente;

  @override
  State<_ControlloSegnaleFormDialog> createState() =>
      _ControlloSegnaleFormDialogState();
}

class _ControlloSegnaleFormDialogState
    extends State<_ControlloSegnaleFormDialog> {
  final _formKey = GlobalKey<FormState>();

  late final _noteController = TextEditingController(
    text: widget.esistente?.note ?? '',
  );

  String? _segnaleId;
  DateTime? _dataIspezione;
  late bool _esiste;
  late bool _posizioneIdonea;
  late bool _buonoStato;
  bool _isSaving = false;

  bool get _isModifica => widget.esistente != null;

  /// Il cartello è imposto dal chiamante: niente tendina, solo l'indicazione
  /// di quale segnale si sta controllando.
  bool get _segnaleFissato => widget.segnale != null;

  @override
  void initState() {
    super.initState();
    final c = widget.esistente;

    _segnaleId = widget.segnale?.id ?? c?.segnaleId;
    _dataIspezione = _parseData(c?.dataIspezione ?? '') ?? DateTime.now();
    _esiste = c?.esiste ?? true;
    _posizioneIdonea = c?.posizioneIdonea ?? true;
    _buonoStato = c?.buonoStato ?? true;
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_segnaleId == null || _segnaleId!.isEmpty) return;

    setState(() => _isSaving = true);
    try {
      if (_isModifica) {
        await widget.provider.update(
          widget.esistente!.id,
          segnaleId: _segnaleId!,
          dataIspezione: _dataIspezione,
          esiste: _esiste,
          posizioneIdonea: _posizioneIdonea,
          buonoStato: _buonoStato,
          note: _noteController.text.trim(),
        );
      } else {
        await widget.provider.create(
          segnaleId: _segnaleId!,
          dataIspezione: _dataIspezione,
          esiste: _esiste,
          posizioneIdonea: _posizioneIdonea,
          buonoStato: _buonoStato,
          note: _noteController.text.trim(),
        );
      }
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.commonErrorWithDetails(e.toString()))));
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final primaryBlue = Theme.of(context).primaryColor;

    return AlertDialog(
      title: Text(_isModifica ? l10n.controlloSegnaleFormDialogEditTitle : l10n.controlloSegnaleFormDialogNewTitle),
      content: Form(
        key: _formKey,
        child: SizedBox(
          width: 440,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_segnaleFissato)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.signpost_outlined, color: primaryBlue),
                    title: Text(widget.segnale!.nome),
                    subtitle: widget.segnale!.ubicazione.isEmpty
                        ? null
                        : Text(widget.segnale!.ubicazione),
                  )
                else
                  DropdownButtonFormField<String>(
                    // Un id non più presente in lista (segnale eliminato)
                    // farebbe crashare il Dropdown: meglio nessuna selezione.
                    initialValue: widget.segnali.any((s) => s.id == _segnaleId)
                        ? _segnaleId
                        : null,
                    borderRadius: BorderRadius.circular(15),
                    isExpanded: true,
                    decoration: InputDecoration(labelText: l10n.controlloSegnaleFormDialogCartelloLabel),
                    items: widget.segnali
                        .map(
                          (s) => DropdownMenuItem(
                            value: s.id,
                            child: Text(
                              s.ubicazione.isEmpty
                                  ? s.nome
                                  : '${s.nome} - ${s.ubicazione}',
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (v) => setState(() => _segnaleId = v),
                    validator: (v) =>
                        v == null ? l10n.controlloSegnaleFormDialogSelezionaCartello : null,
                  ),
                const SizedBox(height: 8),
                CampoData(
                  label: l10n.controlloSegnaleFormDialogDataIspezione,
                  valore: _dataIspezione,
                  onChanged: (v) => setState(() => _dataIspezione = v),
                ),
                const Divider(height: 24),
                Text(
                  l10n.controlloSegnaleFormDialogEsitoControllo,
                  style: TextStyle(
                    color: primaryBlue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(l10n.controlloSegnaleFormDialogCartelloPresente),
                  value: _esiste,
                  onChanged: (v) => setState(() {
                    _esiste = v;
                    // Se il cartello non c'è, posizione e stato non sono
                    // verificabili: si azzerano per non salvare esiti falsi.
                    if (!v) {
                      _posizioneIdonea = false;
                      _buonoStato = false;
                    }
                  }),
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(l10n.controlloSegnaleFormDialogPosizioneIdonea),
                  value: _posizioneIdonea,
                  onChanged: _esiste
                      ? (v) => setState(() => _posizioneIdonea = v)
                      : null,
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(l10n.controlloSegnaleFormDialogInBuonoStato),
                  value: _buonoStato,
                  onChanged: _esiste
                      ? (v) => setState(() => _buonoStato = v)
                      : null,
                ),
                const Divider(height: 24),
                TextFormField(
                  controller: _noteController,
                  decoration: InputDecoration(
                    labelText: l10n.commonNoteLabel,
                    hintText: l10n.controlloSegnaleFormDialogNoteHint,
                  ),
                  maxLines: 2,
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

/// Registrazione in blocco del giro di controlli di una zona.
///
/// È la scorciatoia per il caso normale ("è andato tutto bene"): l'utente
/// sceglie solo la data e tutti i cartelli della zona ricevono un controllo con
/// esito positivo. Le eccezioni si sistemano dopo, cartello per cartello, con
/// il form del singolo controllo.
Future<void> showControlloSegnaleZonaFormDialog(
  BuildContext context, {
  required ControlliSegnaliProvider provider,
  required List<Segnale> segnali,
  required String titoloZona,
}) {
  return showDialog(
    context: context,
    builder: (_) => _ControlloSegnaleZonaFormDialog(
      provider: provider,
      segnali: segnali,
      titoloZona: titoloZona,
    ),
  );
}

class _ControlloSegnaleZonaFormDialog extends StatefulWidget {
  const _ControlloSegnaleZonaFormDialog({
    required this.provider,
    required this.segnali,
    required this.titoloZona,
  });

  final ControlliSegnaliProvider provider;

  /// Cartelli della sola zona su cui si sta registrando il giro.
  final List<Segnale> segnali;
  final String titoloZona;

  @override
  State<_ControlloSegnaleZonaFormDialog> createState() =>
      _ControlloSegnaleZonaFormDialogState();
}

class _ControlloSegnaleZonaFormDialogState
    extends State<_ControlloSegnaleZonaFormDialog> {
  final _noteController = TextEditingController();

  DateTime? _dataIspezione = DateTime.now();
  bool _isSaving = false;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (widget.segnali.isEmpty) return;

    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);

    setState(() => _isSaving = true);
    try {
      await widget.provider.createMultipli(
        segnaliIds: widget.segnali.map((s) => s.id).toList(),
        dataIspezione: _dataIspezione,
        note: _noteController.text.trim(),
      );
      navigator.pop();
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        messenger.showSnackBar(SnackBar(content: Text(l10n.commonErrorWithDetails(e.toString()))));
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final primaryBlue = Theme.of(context).primaryColor;
    final quanti = widget.segnali.length;

    return AlertDialog(
      title: Text(l10n.controlloSegnaleFormDialogControlloZonaTitle(widget.titoloZona)),
      content: SizedBox(
        width: 440,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.controlloSegnaleFormDialogRegistrazioneBlocco(
                  quanti,
                  quanti == 1
                      ? l10n.controlloSegnaleFormDialogSignSingular
                      : l10n.controlloSegnaleFormDialogSignPlural,
                ),
                style: const TextStyle(color: Colors.black54, fontSize: 13),
              ),
              const SizedBox(height: 12),
              CampoData(
                label: l10n.controlloSegnaleFormDialogDataIspezione,
                valore: _dataIspezione,
                onChanged: (v) => setState(() => _dataIspezione = v),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _noteController,
                decoration: InputDecoration(
                  labelText: l10n.controlloSegnaleFormDialogNoteAppliedLabel,
                  hintText: l10n.controlloSegnaleFormDialogNoteAppliedHint,
                ),
                maxLines: 2,
              ),
              const Divider(height: 24),
              Text(
                l10n.controlloSegnaleFormDialogCartelliInteressati,
                style: TextStyle(
                  color: primaryBlue,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              // Elenco di sola lettura: serve a far vedere su cosa si sta per
              // scrivere prima di confermare, con un'altezza massima perché la
              // zona può contenere molti cartelli.
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 180),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (final s in widget.segnali)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Row(
                            children: [
                              Icon(
                                Icons.check_circle_outline,
                                size: 16,
                                color: primaryBlue,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  s.ubicazione.isEmpty
                                      ? s.nome
                                      : '${s.nome} - ${s.ubicazione}',
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
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
              : Text(l10n.controlloSegnaleFormDialogRegistraSuTutti),
        ),
      ],
    );
  }
}
