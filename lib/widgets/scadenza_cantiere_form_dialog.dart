import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/cantiere.dart';
import '../providers/cantieri_provider.dart';
import 'campo_data.dart';

DateTime? _parseData(String value) => value.isEmpty ? null : DateTime.tryParse(value);

Future<void> showScadenzaCantiereFormDialog(
  BuildContext context, {
  required CantieriProvider provider,
  required Cantiere cantiere,
}) {
  return showDialog(
    context: context,
    builder: (_) => _ScadenzaCantiereFormDialog(provider: provider, cantiere: cantiere),
  );
}

class _ScadenzaCantiereFormDialog extends StatefulWidget {
  const _ScadenzaCantiereFormDialog({required this.provider, required this.cantiere});

  final CantieriProvider provider;
  final Cantiere cantiere;

  @override
  State<_ScadenzaCantiereFormDialog> createState() => _ScadenzaCantiereFormDialogState();
}

class _ScadenzaCantiereFormDialogState extends State<_ScadenzaCantiereFormDialog> {
  static const _maxScadenzeGeneriche = 5;

  /// Campi PocketBase delle scadenze generiche, nell'ordine in cui compaiono
  /// nel form: sono le chiavi con cui le note vivono in
  /// [Cantiere.commentiScadenze].
  static const _campoMessaATerra = 'scadenza_messa_a_terra';
  static const _campiScadenzeGeneriche = [
    'scadenza_generica1',
    'scadenza_generica2',
    'scadenza_generica3',
    'scadenza_generica4',
    'scadenza_generica5',
  ];

  DateTime? _scadenzaMessaTerra;
  bool _mostraScadenzaMessaTerra = false;

  late final List<DateTime?> _scadenzeGeneriche;
  late final List<String> _nomiScadenzeGeneriche;
  late int _numeroScadenzeGeneriche;

  /// Note libere per scadenza (`commenti_scadenze`), una per campo: sono dei
  /// promemoria e non hanno effetto sulle mail di sollecito, a differenza
  /// della nota "prenotato" di `note_scadenze`.
  late final TextEditingController _notaMessaTerra;
  late final List<TextEditingController> _noteScadenzeGeneriche;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final c = widget.cantiere;

    _scadenzaMessaTerra = _parseData(c.scadenzaMessaTerra);
    _mostraScadenzaMessaTerra = _scadenzaMessaTerra != null;

    _scadenzeGeneriche = [
      _parseData(c.scadenzaGenerica1),
      _parseData(c.scadenzaGenerica2),
      _parseData(c.scadenzaGenerica3),
      _parseData(c.scadenzaGenerica4),
      _parseData(c.scadenzaGenerica5),
    ];
    _nomiScadenzeGeneriche = [
      c.nomeScadenzaGenerica1,
      c.nomeScadenzaGenerica2,
      c.nomeScadenzaGenerica3,
      c.nomeScadenzaGenerica4,
      c.nomeScadenzaGenerica5,
    ];
    // Mostra solo gli slot già valorizzati (in ordine): quelli successivi
    // restano nascosti finché non si preme "Aggiungi scadenza generica".
    _numeroScadenzeGeneriche = _scadenzeGeneriche.lastIndexWhere((v) => v != null) + 1;

    _notaMessaTerra =
        TextEditingController(text: c.commentiScadenze[_campoMessaATerra] ?? '');
    _noteScadenzeGeneriche = [
      for (final campo in _campiScadenzeGeneriche)
        TextEditingController(text: c.commentiScadenze[campo] ?? ''),
    ];
  }

  @override
  void dispose() {
    _notaMessaTerra.dispose();
    for (final controller in _noteScadenzeGeneriche) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<String?> _chiediNomeScadenzaGenerica() {
    final l10n = AppLocalizations.of(context)!;
    final controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.scadenzaCantiereFormDialogNomeScadenzaTitle),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(labelText: l10n.scadenzaCantiereFormDialogNomeScadenzaHint),
          onSubmitted: (v) => Navigator.of(dialogContext).pop(v.trim()),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(controller.text.trim()),
            child: Text(l10n.scadenzaCantiereFormDialogContinua),
          ),
        ],
      ),
    );
  }

  /// Data e nota di una singola scadenza generale, impilate: la nota resta
  /// attaccata alla scadenza a cui si riferisce anche quando le scadenze
  /// generiche sono più di una.
  Widget _campoScadenza(
    String label,
    DateTime? valore,
    ValueChanged<DateTime?> onChanged,
    TextEditingController nota, {
    VoidCallback? onRimuovi,
    String? tooltipRimuovi,
  }) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CampoData(
            label: label,
            valore: valore,
            onChanged: (v) => setState(() => onChanged(v)),
            onRimuovi: onRimuovi,
            tooltipRimuovi: tooltipRimuovi,
          ),
          TextFormField(
            controller: nota,
            decoration: InputDecoration(labelText: l10n.commonNoteLabel),
            maxLines: 2,
          ),
        ],
      ),
    );
  }

  void _rimuoviScadenzaGenerica(int indice) {
    setState(() {
      for (var i = indice; i < _scadenzeGeneriche.length - 1; i++) {
        _scadenzeGeneriche[i] = _scadenzeGeneriche[i + 1];
        _nomiScadenzeGeneriche[i] = _nomiScadenzeGeneriche[i + 1];
        _noteScadenzeGeneriche[i].text = _noteScadenzeGeneriche[i + 1].text;
      }
      _scadenzeGeneriche[_scadenzeGeneriche.length - 1] = null;
      _nomiScadenzeGeneriche[_nomiScadenzeGeneriche.length - 1] = '';
      _noteScadenzeGeneriche[_noteScadenzeGeneriche.length - 1].clear();
      _numeroScadenzeGeneriche--;
    });
  }

  Future<void> _aggiungiScadenzaGenerica() async {
    final nome = await _chiediNomeScadenzaGenerica();
    if (nome == null || !mounted) return;
    setState(() {
      _nomiScadenzeGeneriche[_numeroScadenzeGeneriche] = nome;
      _noteScadenzeGeneriche[_numeroScadenzeGeneriche].clear();
      _numeroScadenzeGeneriche++;
    });
  }

  /// Note da salvare in `commenti_scadenze`. Una nota vive solo finché esiste
  /// la scadenza a cui appartiene: se la data è stata tolta (o il campo
  /// rimosso dal form) la nota sparisce con lei, altrimenti resterebbe
  /// appiccicata alla prossima scadenza registrata su quello stesso campo.
  Map<String, String> _commentiScadenze() {
    final commenti = Map<String, String>.from(widget.cantiere.commentiScadenze);

    void aggiorna(String campo, DateTime? data, String nota) {
      final testo = nota.trim();
      if (data == null || testo.isEmpty) {
        commenti.remove(campo);
      } else {
        commenti[campo] = testo;
      }
    }

    aggiorna(
      _campoMessaATerra,
      _mostraScadenzaMessaTerra ? _scadenzaMessaTerra : null,
      _notaMessaTerra.text,
    );
    for (var i = 0; i < _campiScadenzeGeneriche.length; i++) {
      aggiorna(
        _campiScadenzeGeneriche[i],
        i < _numeroScadenzeGeneriche ? _scadenzeGeneriche[i] : null,
        _noteScadenzeGeneriche[i].text,
      );
    }
    return commenti;
  }

  Future<void> _submit() async {
    setState(() => _isSaving = true);
    try {
      final c = widget.cantiere;
      await widget.provider.update(
        c.id,
        nome: c.nome,
        indirizzo: c.indirizzo,
        comune: c.comune,
        cap: c.cap,
        stato: c.stato,
        scadenzaMessaTerra: _mostraScadenzaMessaTerra ? _scadenzaMessaTerra : null,
        scadenzaGenerica1: _scadenzeGeneriche[0],
        scadenzaGenerica2: _scadenzeGeneriche[1],
        scadenzaGenerica3: _scadenzeGeneriche[2],
        scadenzaGenerica4: _scadenzeGeneriche[3],
        scadenzaGenerica5: _scadenzeGeneriche[4],
        nomeScadenzaGenerica1: _nomiScadenzeGeneriche[0],
        nomeScadenzaGenerica2: _nomiScadenzeGeneriche[1],
        nomeScadenzaGenerica3: _nomiScadenzeGeneriche[2],
        nomeScadenzaGenerica4: _nomiScadenzeGeneriche[3],
        nomeScadenzaGenerica5: _nomiScadenzeGeneriche[4],
        note: c.note,
        commentiScadenze: _commentiScadenze(),
      );
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
    final primaryBlue = Theme.of(context).colorScheme.primary;
    return AlertDialog(
      title: Text(l10n.scadenzaCantiereFormDialogTitle),
      content: SizedBox(
        width: 460,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_mostraScadenzaMessaTerra)
                _campoScadenza(
                  l10n.scadenzaCantiereFormDialogScadenzaMessaTerra,
                  _scadenzaMessaTerra,
                  (v) => _scadenzaMessaTerra = v,
                  _notaMessaTerra,
                  onRimuovi: () => setState(() {
                    _scadenzaMessaTerra = null;
                    _mostraScadenzaMessaTerra = false;
                    _notaMessaTerra.clear();
                  }),
                  tooltipRimuovi: l10n.scadenzaCantiereFormDialogRimuoviMessaTerra,
                )
              else
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    onPressed: () => setState(() => _mostraScadenzaMessaTerra = true),
                    label: Text(
                      l10n.scadenzaCantiereFormDialogAggiungiMessaTerra,
                      style: const TextStyle(fontSize: 12),
                    ),
                    icon: Icon(Icons.add, color: primaryBlue, size: 12),
                  ),
                ),
              const Divider(height: 24),
              for (var i = 0; i < _numeroScadenzeGeneriche; i++)
                _campoScadenza(
                  _nomiScadenzeGeneriche[i].isEmpty
                      ? l10n.scadenzaCantiereFormDialogScadenzaGenerica(i + 1)
                      : _nomiScadenzeGeneriche[i],
                  _scadenzeGeneriche[i],
                  (v) => _scadenzeGeneriche[i] = v,
                  _noteScadenzeGeneriche[i],
                  onRimuovi: () => _rimuoviScadenzaGenerica(i),
                  tooltipRimuovi: l10n.scadenzaCantiereFormDialogRimuoviQuesta,
                ),
              if (_numeroScadenzeGeneriche < _maxScadenzeGeneriche)
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    onPressed: _aggiungiScadenzaGenerica,
                    label: Text(
                      l10n.scadenzaCantiereFormDialogAggiungiGenerica,
                      style: const TextStyle(fontSize: 12),
                    ),
                    icon: Icon(Icons.add, color: primaryBlue, size: 12),
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
              : Text(l10n.commonSave),
        ),
      ],
    );
  }
}
