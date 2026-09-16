import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/tipo_scadenza.dart';
import '../providers/documenti_provider.dart';
import '../providers/tipi_scadenze_provider.dart';
import 'campo_data.dart';

/// Registra la scadenza di un documento senza allegarne il file: la copia
/// (cartacea o digitale) resta archiviata in sede, qui si tiene solo la data
/// per far partire i solleciti via mail (vedi backend/pb_hooks/notifiche.pb.js).
Future<void> showDocumentFormDialog(
  BuildContext context, {
  required DocumentiProvider documentiProvider,
  required TipiScadenzeProvider tipiScadenzeProvider,
  String? caricatoDaId,
  String? cantiereId,
  String? subappaltatoreId,
  String? dipendenteId,
  bool lavoratoreAutonomo = false,
}) {
  return showDialog(
    context: context,
    builder: (_) => _DocumentFormDialog(
      documentiProvider: documentiProvider,
      tipiScadenzeProvider: tipiScadenzeProvider,
      caricatoDaId: caricatoDaId,
      cantiereId: cantiereId,
      subappaltatoreId: subappaltatoreId,
      dipendenteId: dipendenteId,
      lavoratoreAutonomo: lavoratoreAutonomo,
    ),
  );
}

class _DocumentFormDialog extends StatefulWidget {
  const _DocumentFormDialog({
    required this.documentiProvider,
    required this.tipiScadenzeProvider,
    this.caricatoDaId,
    this.cantiereId,
    this.subappaltatoreId,
    this.dipendenteId,
    this.lavoratoreAutonomo = false,
  });

  final DocumentiProvider documentiProvider;
  final TipiScadenzeProvider tipiScadenzeProvider;
  final String? caricatoDaId;
  final String? cantiereId;
  final String? subappaltatoreId;
  final String? dipendenteId;

  /// Il dipendente lavora in proprio: alle tipologie dei dipendenti si
  /// aggiungono quelle riservate ai lavoratori autonomi.
  final bool lavoratoreAutonomo;

  @override
  State<_DocumentFormDialog> createState() => _DocumentFormDialogState();
}

class _DocumentFormDialogState extends State<_DocumentFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _noteController = TextEditingController();

  TipoScadenza? _tipoSelezionato;

  /// Ultima nota precompilata dalla tipologia: serve a distinguerla da quanto
  /// scritto a mano, così cambiando tipo non si perde il testo dell'utente.
  String _notaPrecompilata = '';

  DateTime? _dataScadenza;

  /// CampoData non ha un validator proprio: l'obbligo della data per le
  /// tipologie con scadenza si verifica al salvataggio e si mostra qui sotto.
  String? _erroreScadenza;

  bool _isSaving = false;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  /// Precompila le note con la nota predefinita della tipologia scelta, senza
  /// sovrascrivere un testo scritto dall'utente.
  void _applicaNotaTipo(TipoScadenza? tipo) {
    final testoAttuale = _noteController.text.trim();
    if (testoAttuale.isNotEmpty && testoAttuale != _notaPrecompilata) return;
    final nuovaNota = tipo?.note.trim() ?? '';
    _noteController.text = nuovaNota;
    _notaPrecompilata = nuovaNota;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final l10n = AppLocalizations.of(context)!;
    if (_tipoSelezionato!.richiedeScadenza && _dataScadenza == null) {
      setState(() =>
          _erroreScadenza = l10n.documentFormDialogDeadlineRequiredError);
      return;
    }

    setState(() {
      _erroreScadenza = null;
      _isSaving = true;
    });
    try {
      await widget.documentiProvider.create(
        tipoDocumentoId: _tipoSelezionato!.id,
        cantiereId: widget.cantiereId,
        subappaltatoreId: widget.subappaltatoreId,
        dipendenteId: widget.dipendenteId,
        dataScadenza: _dataScadenza,
        note: _noteController.text.trim(),
        caricatoDaId: widget.caricatoDaId ?? '',
      );
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(l10n.commonErrorWithDetails(e.toString()))));
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final primaryBlue = Theme.of(context).primaryColor;
    final perDipendente = widget.dipendenteId != null && widget.dipendenteId!.isNotEmpty;
    final perSubappaltatore = widget.subappaltatoreId != null && widget.subappaltatoreId!.isNotEmpty;
    final tipi = widget.tipiScadenzeProvider.tipiScadenze
        .where((t) => perDipendente
            ? (widget.lavoratoreAutonomo
                ? t.assegnabileALavoratoreAutonomo
                : t.appartieneDipendente)
            : perSubappaltatore
                ? t.appartieneSubappaltatore
                : t.appartieneCantiere)
        .toList();

    return AlertDialog(
      title: Text(l10n.documentFormDialogTitle),
      content: Form(
        key: _formKey,
        child: SizedBox(
          width: 440,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.documentFormDialogSectionTitle,
                    style: TextStyle(fontWeight: FontWeight.w600, color: primaryBlue)),
                const SizedBox(height: 8),
                DropdownButtonFormField<TipoScadenza>(
                  borderRadius: BorderRadius.circular(15),
                  // Senza isExpanded il testo non viene vincolato alla larghezza
                  // del campo e le tipologie dal nome lungo sbordano dal dialog.
                  isExpanded: true,
                  // Lascia che una voce del menu occupi più righe invece di
                  // essere alta esattamente una riga.
                  itemHeight: null,
                  initialValue: _tipoSelezionato,
                  decoration: InputDecoration(labelText: l10n.documentFormDialogTypeLabel),
                  // Nel menu aperto il nome va a capo, così resta leggibile per
                  // intero; nel campo chiuso viene troncato, dove una riga sola
                  // serve a non far crescere il dialog in altezza.
                  selectedItemBuilder: (context) => tipi
                      .map((t) => Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              t.nome,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ))
                      .toList(),
                  items: tipi
                      .map((t) => DropdownMenuItem(
                            value: t,
                            // Con itemHeight a null l'altezza la decide il
                            // contenuto: il vincolo minimo tiene le voci corte
                            // alla stessa altezza di prima.
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(
                                minHeight: kMinInteractiveDimension,
                              ),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  child: Text(t.nome),
                                ),
                              ),
                            ),
                          ))
                      .toList(),
                  onChanged: (v) => setState(() {
                    _tipoSelezionato = v;
                    _erroreScadenza = null;
                    _applicaNotaTipo(v);
                  }),
                  validator: (v) => v == null ? l10n.documentFormDialogTypeValidator : null,
                ),
                const SizedBox(height: 8),
                CampoData(
                  // Le tipologie senza scadenza servono a segnare un documento
                  // come consegnato: lì la data resta facoltativa.
                  label: (_tipoSelezionato?.richiedeScadenza ?? false)
                      ? l10n.documentFormDialogDeadlineDateLabel
                      : l10n.documentFormDialogDeadlineDateOptionalLabel,
                  valore: _dataScadenza,
                  onChanged: (v) => setState(() {
                    _dataScadenza = v;
                    _erroreScadenza = null;
                  }),
                ),
                if (_erroreScadenza != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(_erroreScadenza!,
                        style: const TextStyle(color: Colors.red, fontSize: 12)),
                  ),
                TextFormField(
                  controller: _noteController,
                  decoration: InputDecoration(labelText: l10n.commonNoteLabel),
                  maxLines: 2,
                ),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.info_outline, size: 16, color: primaryBlue),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        l10n.documentFormDialogInfoText,
                        style: const TextStyle(fontSize: 12, color: Colors.black54),
                      ),
                    ),
                  ],
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
