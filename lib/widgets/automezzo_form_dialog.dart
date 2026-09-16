import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/automezzo.dart';
import '../providers/automezzi_provider.dart';
import 'campo_data.dart';

DateTime? _parseData(String value) => value.isEmpty ? null : DateTime.tryParse(value);

// NOTA: queste mappe sono pubbliche (`show categorie, proprieta`) e vengono
// consumate anche da automezzi_screen.dart e scadenze_imminenti_screen.dart,
// fuori dal perimetro di questo intervento: i loro valori restano quindi in
// italiano per non rompere quel contratto.
const categorie = {
  'euro_4' : 'EURO 4',
  'euro_5' : 'EURO 5',
  'euro_6' : 'EURO 6',
  'NA' : 'Non applicabile'
};

const proprieta = {
  'proprieta': 'Di Proprietà',
  'noleggio': 'Noleggio',
  'leasing': 'Leasing',
};

Future<void> showAutomezzoFormDialog(
  BuildContext context, {
  required AutomezziProvider provider,
  required List<Automezzo> automezzi,
  Automezzo? esistente,
}) {
  return showDialog(
    context: context,
    builder: (_) => _AutomezzoFormDialog(
      provider: provider,
      automezzi: automezzi,
      esistente: esistente,
    ),
  );
}

class _AutomezzoFormDialog extends StatefulWidget {
  const _AutomezzoFormDialog({
    required this.provider,
    required this.automezzi,
    this.esistente,
  });

  final AutomezziProvider provider;
  final List<Automezzo> automezzi;
  final Automezzo? esistente;

  @override
  State<_AutomezzoFormDialog> createState() => _AutomezzoFormDialogState();
}

class _AutomezzoFormDialogState extends State<_AutomezzoFormDialog> {
  final _formKey = GlobalKey<FormState>();

  late final _nomeController =
      TextEditingController(text: widget.esistente?.nome ?? '');
  late final _targaController =
      TextEditingController(text: widget.esistente?.targa ?? '');
  late final _telepassController =
      TextEditingController(text: widget.esistente?.telepass ?? '');
  late final _nomeAssicurazioneController =
      TextEditingController(text: widget.esistente?.compAssicurazione ?? '');
  late final _noteController =
      TextEditingController(text: widget.esistente?.note ?? '');

  String? _categoria;
  String? _proprietaSelezionata;

  DateTime? _scadenzaNoleggioLeasing;
  DateTime? _scadenzaAssicurazione;
  DateTime? _scadenzaBollo;
  DateTime? _scadenzaRevisione;
  DateTime? _scadenzaControlloTachigrafo;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final a = widget.esistente;
    _categoria = (a == null || a.catEuro.isEmpty) ? null : a.catEuro;
    _proprietaSelezionata = (a == null || a.proprieta.isEmpty) ? null : a.proprieta;

    _scadenzaNoleggioLeasing = _parseData(a?.scadenzaNoleggioLeasing ?? '');
    _scadenzaAssicurazione = _parseData(a?.scadenzaAssicurazione ?? '');
    _scadenzaBollo = _parseData(a?.scadenzaBollo ?? '');
    _scadenzaRevisione = _parseData(a?.scadenzaRevisione ?? '');
    _scadenzaControlloTachigrafo = _parseData(a?.scadenzaControlloTachigrafo ?? '');

    _targaController.addListener(_aggiornaVisibilitaTachigrafo);
  }

  void _aggiornaVisibilitaTachigrafo() => setState(() {});

  @override
  void dispose() {
    _targaController.removeListener(_aggiornaVisibilitaTachigrafo);
    _nomeController.dispose();
    _targaController.dispose();
    _nomeAssicurazioneController.dispose();
    _telepassController.dispose();
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
          targa: _targaController.text.trim(),
          telepass: _telepassController.text.trim(),
          compAssicurazione: _nomeAssicurazioneController.text.trim(),
          note: _noteController.text.trim(),
          catEuro: _categoria,
          proprieta: _proprietaSelezionata,
          scadenzaNoleggioLeasing: _scadenzaNoleggioLeasing,
          scadenzaAssicurazione: _scadenzaAssicurazione,
          scadenzaBollo: _scadenzaBollo,
          scadenzaRevisione: _scadenzaRevisione,
          scadenzaControlloTachigrafo: _scadenzaControlloTachigrafo
        );
      } else {
        await widget.provider.update(
          widget.esistente!.id,
          nome: _nomeController.text.trim(),
          targa: _targaController.text.trim(),
          telepass: _telepassController.text.trim(),
          compAssicurazione: _nomeAssicurazioneController.text.trim(),
          note: _noteController.text.trim(),
          catEuro: _categoria,
          proprieta: _proprietaSelezionata,
          scadenzaNoleggioLeasing: _scadenzaNoleggioLeasing,
          scadenzaAssicurazione: _scadenzaAssicurazione,
          scadenzaBollo: _scadenzaBollo,
          scadenzaRevisione: _scadenzaRevisione,
          scadenzaControlloTachigrafo: _scadenzaControlloTachigrafo
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
      title: Text(widget.esistente == null ? l10n.automezzoFormDialogNewTitle : l10n.automezzoFormDialogEditTitle),
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
                  decoration: InputDecoration(labelText: l10n.automezzoFormDialogNomeLabel),
                ),
                TextFormField(
                  controller: _targaController,
                  decoration: InputDecoration(labelText: l10n.automezzoFormDialogTargaLabel),
                  validator: (v) => (v == null || v.trim().isEmpty) ? l10n.commonRequiredField : null,
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String?>(
                  borderRadius: BorderRadius.circular(15),
                  initialValue: _categoria,
                  decoration: InputDecoration(labelText: l10n.automezzoFormDialogCategoriaLabel),
                  items: [
                    DropdownMenuItem(value: null, child: Text(l10n.automezzoFormDialogNonSpecificata)),
                    ...categorie.entries
                        .map((e) => DropdownMenuItem(value: e.key, child: Text(e.value)))
                  ],
                  onChanged: (v) => setState(() => _categoria = v)
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _telepassController,
                  decoration: InputDecoration(labelText: l10n.automezzoFormDialogTelepassLabel),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String?>(
                  borderRadius: BorderRadius.circular(15),
                  initialValue: _proprietaSelezionata,
                  decoration: InputDecoration(labelText: l10n.automezzoFormDialogProprietaLabel),
                  items: [
                    DropdownMenuItem(value: null, child: Text(l10n.automezzoFormDialogNonSpecificata)),
                    ...proprieta.entries
                        .map((e) => DropdownMenuItem(value: e.key, child: Text(e.value))),
                  ],
                  onChanged: (v) => setState(() => _proprietaSelezionata = v),
                ),
                if (_proprietaSelezionata == 'noleggio' || _proprietaSelezionata == 'leasing') ... [
                  const Divider(height: 24),
                  _campoData(l10n.automezzoFormDialogScadenzaProprieta(_proprietaSelezionata ?? ''), _scadenzaNoleggioLeasing, (v) {
                    _scadenzaNoleggioLeasing = v;
                  })
                ],
                const Divider(height: 24),
                Text(l10n.automezzoFormDialogSectionAssicurazione, style: TextStyle(fontWeight: FontWeight.w600, color: primaryBlue)),
                _campoData(l10n.automezzoFormDialogScadenzaAssicurazione, _scadenzaAssicurazione, (v) {
                  _scadenzaAssicurazione = v;
                }),
                TextFormField(
                  controller: _nomeAssicurazioneController,
                  decoration: InputDecoration(labelText: l10n.automezzoFormDialogNomeAssicurazioneLabel),
                ),
                const Divider(height: 24),
                Text(l10n.automezzoFormDialogSectionBollo, style: TextStyle(fontWeight: FontWeight.w600, color: primaryBlue)),
                _campoData(l10n.automezzoFormDialogScadenzaBollo, _scadenzaBollo, (v) {
                  _scadenzaBollo = v;
                }),
                const Divider(height: 24),
                Text(l10n.automezzoFormDialogSectionRevisione, style: TextStyle(fontWeight: FontWeight.w600, color: primaryBlue)),
                _campoData(l10n.automezzoFormDialogScadenzaRevisione, _scadenzaRevisione, (v) {
                  _scadenzaRevisione = v;
                }),
                if (_targaController.text == 'DV389KS' || _targaController.text == 'DY667BP') ... [
                  const Divider(height: 24),
                  Text(l10n.automezzoFormDialogSectionTachigrafo, style: TextStyle(fontWeight: FontWeight.w600, color: primaryBlue)),
                  _campoData(l10n.automezzoFormDialogScadenzaControlloTachigrafo, _scadenzaControlloTachigrafo, (v) {
                    _scadenzaControlloTachigrafo = v;
                  }),
                ],
                const Divider(height: 24),
                TextField(
                  controller: _noteController,
                  decoration: InputDecoration(labelText: l10n.automezzoFormDialogNoteAggiuntive)
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
