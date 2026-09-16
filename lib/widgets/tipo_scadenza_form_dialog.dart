import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../models/tipo_scadenza.dart';
import '../providers/documenti_provider.dart';
import '../providers/tipi_scadenze_provider.dart';

Future<void> showTipoScadenzaFormDialog(
  BuildContext context, {
  required TipiScadenzeProvider provider,
  TipoScadenza? esistente,
}) {
  return showDialog(
    context: context,
    builder: (_) => _TipoScadenzaFormDialog(
      provider: provider, 
      esistente: esistente
    ),
  );
}

class _TipoScadenzaFormDialog extends StatefulWidget {
  const _TipoScadenzaFormDialog({
    required this.provider, 
    this.esistente
  });

  final TipiScadenzeProvider provider;
  final TipoScadenza? esistente;

  @override
  State<_TipoScadenzaFormDialog> createState() => _TipoScadenzaFormDialogState();
}

class _TipoScadenzaFormDialogState extends State<_TipoScadenzaFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final _nomeController =
      TextEditingController(text: widget.esistente?.nome ?? '');
  late final _giorniPreavvisoController = TextEditingController(
    text: widget.esistente?.giorniPreavviso.join(', ') ?? '30, 1',
  );
  late final _noteController =
      TextEditingController(text: widget.esistente?.note ?? '');
  late bool _richiedeScadenza = widget.esistente?.richiedeScadenza ?? true;
  late bool _avvisaDopoScadenza = widget.esistente?.avvisaDopoScadenza ?? false;
  late bool _appartieneCantiere = widget.esistente?.appartieneCantiere ?? true;
  late bool _appartieneSubappaltatore = widget.esistente?.appartieneSubappaltatore ?? false;
  late bool _appartieneDipendente = widget.esistente?.appartieneDipendente ?? false;
  late bool _appartieneLavoratoreAutonomo =
      widget.esistente?.appartieneLavoratoreAutonomo ?? false;
  bool _isSaving = false;

  @override
  void dispose() {
    _nomeController.dispose();
    _giorniPreavvisoController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  List<int> _parseGiorniPreavviso() {
    return _giorniPreavvisoController.text
        .split(',')
        .map((s) => int.tryParse(s.trim()))
        .whereType<int>()
        .toList();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final l10n = AppLocalizations.of(context)!;
    if (!_appartieneCantiere &&
        !_appartieneSubappaltatore &&
        !_appartieneDipendente &&
        !_appartieneLavoratoreAutonomo) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.tipoScadenzaFormDialogSelezionaAppartenenza)),
      );
      return;
    }
    setState(() => _isSaving = true);
    try {
      // Senza scadenza non c'è nulla da avvisare, né prima né dopo: i due
      // campi seguono "Richiede scadenza" per non lasciare in giro valori
      // che poi non vengono usati da nessuno.
      final avvisaDopoScadenza = _richiedeScadenza && _avvisaDopoScadenza;
      final giorniPreavviso =
          _richiedeScadenza && !avvisaDopoScadenza ? _parseGiorniPreavviso() : <int>[];
      final appartenenza = [
        if (_appartieneCantiere) 'cantiere',
        if (_appartieneSubappaltatore) 'subappaltatore',
        if (_appartieneDipendente) 'dipendente',
        if (_appartieneLavoratoreAutonomo) 'lavoratore_autonomo',
      ];
      if (widget.esistente == null) {
        await widget.provider.create(
          nome: _nomeController.text.trim(),
          richiedeScadenza: _richiedeScadenza,
          giorniPreavviso: giorniPreavviso,
          avvisaDopoScadenza: avvisaDopoScadenza,
          appartenenza: appartenenza,
          note: _noteController.text.trim(),
        );
      } else {
        final documentiProvider = context.read<DocumentiProvider>();
        final aggiornato = await widget.provider.update(
          widget.esistente!.id,
          nome: _nomeController.text.trim(),
          richiedeScadenza: _richiedeScadenza,
          giorniPreavviso: giorniPreavviso,
          avvisaDopoScadenza: avvisaDopoScadenza,
          appartenenza: appartenenza,
          note: _noteController.text.trim(),
        );
        // Le scadenze già caricate portano con sé nome e giorni di preavviso
        // della tipologia: vanno riallineati qui, altrimenti una tipologia
        // rinominata resterebbe col vecchio nome negli elenchi di cantieri,
        // subappaltatori e dipendenti.
        documentiProvider.aggiornaTipoScadenza(aggiornato);
      }
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(l10n.commonErrorWithDetails(e.toString()))));
        setState(() => _isSaving = false);
      }
    }
  }

  /// Una casella dell'elenco "Appartenenza": come nel form dei
  /// subappaltatori, la voce selezionata si distingue anche dal peso del
  /// testo, non solo dalla spunta.
  Widget _appartenenza(String etichetta, bool selezionato, ValueChanged<bool> onChanged) {
    return CheckboxListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      title: Text(
        etichetta,
        style: TextStyle(fontWeight: selezionato ? FontWeight.w600 : FontWeight.w500),
      ),
      value: selezionato,
      onChanged: (v) => setState(() => onChanged(v ?? false)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final primaryBlue = Theme.of(context).primaryColor;
    return AlertDialog(
      title: Text(widget.esistente == null ? l10n.tipoScadenzaFormDialogNewTitle : l10n.tipoScadenzaFormDialogEditTitle),
      content: Form(
        key: _formKey,
        child: SizedBox(
          width: 440,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.tipoScadenzaFormDialogTipologia,
                    style: TextStyle(fontWeight: FontWeight.w600, color: primaryBlue)),
                TextFormField(
                  controller: _nomeController,
                  decoration: InputDecoration(
                    labelText: l10n.tipoScadenzaFormDialogNomeLabel,
                    hintText: l10n.tipoScadenzaFormDialogNomeHint,
                  ),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? l10n.commonRequiredField : null,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _noteController,
                  decoration: InputDecoration(
                    labelText: l10n.tipoScadenzaFormDialogNotaPredefinitaLabel,
                    hintText: l10n.tipoScadenzaFormDialogNotaPredefinitaHint,
                    helperText: l10n.tipoScadenzaFormDialogNotaPredefinitaHelper,
                    helperMaxLines: 2,
                  ),
                  maxLines: 1,
                ),
                const Divider(height: 24),
                Text(l10n.tipoScadenzaFormDialogAppartenenza,
                    style: TextStyle(fontWeight: FontWeight.w600, color: primaryBlue)),
                const SizedBox(height: 4),
                _appartenenza(
                  l10n.tipoScadenzaFormDialogCantiere,
                  _appartieneCantiere,
                  (v) => _appartieneCantiere = v,
                ),
                _appartenenza(
                  l10n.tipoScadenzaFormDialogSubappaltatore,
                  _appartieneSubappaltatore,
                  (v) => _appartieneSubappaltatore = v,
                ),
                _appartenenza(
                  l10n.tipoScadenzaFormDialogDipendenteSubappaltatore,
                  _appartieneDipendente,
                  (v) => _appartieneDipendente = v,
                ),
                // I lavoratori autonomi ereditano già tutte le tipologie dei
                // dipendenti: questa casella serve solo per le tipologie in
                // più, quelle che spettano a chi lavora in proprio.
                _appartenenza(
                  l10n.tipoScadenzaFormDialogLavoratoreAutonomo,
                  _appartieneLavoratoreAutonomo,
                  (v) => _appartieneLavoratoreAutonomo = v,
                ),
                if (_appartieneDipendente)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      l10n.tipoScadenzaFormDialogTipologieDipendentiInfo,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: Colors.black54),
                    ),
                  ),
                const Divider(height: 24),
                Text(l10n.tipoScadenzaFormDialogScadenza,
                    style: TextStyle(fontWeight: FontWeight.w600, color: primaryBlue)),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(l10n.tipoScadenzaFormDialogRichiedeScadenza),
                  value: _richiedeScadenza,
                  onChanged: (v) => setState(() => _richiedeScadenza = v),
                ),
                if (_richiedeScadenza) ...[
                  // Il DURC (e simili) si rinnova solo quando il precedente è
                  // scaduto: avvisare prima è rumore, la mail serve dal giorno
                  // dopo. In quel caso i giorni di preavviso non servono più.
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(l10n.tipoScadenzaFormDialogAvvisaSoloScadutaTitle),
                    subtitle: Text(
                      l10n.tipoScadenzaFormDialogAvvisaSoloScadutaSubtitle,
                    ),
                    isThreeLine: true,
                    value: _avvisaDopoScadenza,
                    onChanged: (v) => setState(() => _avvisaDopoScadenza = v),
                  ),
                  if (!_avvisaDopoScadenza)
                    TextFormField(
                      controller: _giorniPreavvisoController,
                      decoration: InputDecoration(
                        labelText: l10n.tipoScadenzaFormDialogGiorniPreavvisoLabel,
                        hintText: l10n.tipoScadenzaFormDialogGiorniPreavvisoHint,
                      ),
                    ),
                ],
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
