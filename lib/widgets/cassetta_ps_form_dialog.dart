import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../l10n/app_localizations.dart';
import '../models/cassetta_ps.dart';
import '../models/articolo_cassetta_ps.dart';
import '../models/cantiere.dart';
import '../models/automezzo.dart';
import '../providers/cassette_ps_provider.dart';
import '../providers/articoli_cassette_ps_provider.dart';
import '../providers/articoli_standard_cassette_ps_provider.dart';
import 'stato_badge.dart';
import 'campo_data.dart';

final _dateFormat = DateFormat('dd/MM/yyyy');

DateTime? _parseData(String value) => value.isEmpty ? null : DateTime.tryParse(value);

DateTime _aggiungiPeriodo(DateTime data, {int anni = 0, int mesi = 0, int giorni = 0}) {
  return DateTime(data.year + anni, data.month + mesi, data.day + giorni);
}

const _tipologieKeys = ['Cassetta', 'Pacchetto di Medicazione'];

/// Etichetta leggibile per la [tipologia] (la chiave resta in italiano
/// perché usata anche come valore salvato su [CassettaPs.tipologia]).
String _tipologiaLabel(AppLocalizations l10n, String tipologia) {
  switch (tipologia) {
    case 'Cassetta':
      return l10n.cassettaPsFormDialogTipoCassetta;
    case 'Pacchetto di Medicazione':
      return l10n.cassettaPsFormDialogTipoPacchettoMedicazione;
    default:
      return tipologia;
  }
}

enum _TipoUbicazione { nessuna, magazzino, cantiere, automezzo, ufficio }

/// Bozza modificabile di un articolo, sia esso già salvato (con [id]) o
/// nuovo (in attesa di essere creato al salvataggio della cassetta).
class _ArticoloDraft {
  _ArticoloDraft({
    this.id,
    required this.nomeProdotto,
    required this.quantita,
    required this.scadenza,
    required this.note,
    required this.notaScadenza,
  });

  factory _ArticoloDraft.fromArticolo(ArticoloCassettaPs a) => _ArticoloDraft(
        id: a.id,
        nomeProdotto: a.nomeProdotto,
        quantita: a.quantita,
        scadenza: _parseData(a.scadenza),
        note: a.note,
        notaScadenza: a.notaScadenza,
      );

  final String? id;
  String nomeProdotto;
  String quantita;
  DateTime? scadenza;
  String note;
  String notaScadenza;
}

Future<void> showCassettaFormDialog(
  BuildContext context, {
  required CassettePsProvider provider,
  required ArticoliCassettePsProvider articoliProvider,
  required ArticoliStandardCassettePsProvider articoliStandardProvider,
  required List<CassettaPs> cassette,
  required List<ArticoloCassettaPs> articoli,
  required List<Cantiere> cantieri,
  required List<Automezzo> automezzi,
  CassettaPs? esistente,
}) {
  return showDialog(
    context: context,
    builder: (_) => _CassettaFormDialog(
      provider: provider,
      articoliProvider: articoliProvider,
      articoliStandardProvider: articoliStandardProvider,
      cassette: cassette,
      articoli: articoli,
      cantieri: cantieri,
      automezzi: automezzi,
      esistente: esistente,
    ),
  );
}

class _CassettaFormDialog extends StatefulWidget {
  const _CassettaFormDialog({
    required this.provider,
    required this.articoliProvider,
    required this.articoliStandardProvider,
    required this.cassette,
    required this.articoli,
    required this.cantieri,
    required this.automezzi,
    this.esistente,
  });

  final CassettePsProvider provider;
  final ArticoliCassettePsProvider articoliProvider;
  final ArticoliStandardCassettePsProvider articoliStandardProvider;
  final List<CassettaPs> cassette;
  final List<ArticoloCassettaPs> articoli;
  final List<Cantiere> cantieri;
  final List<Automezzo> automezzi;
  final CassettaPs? esistente;

  @override
  State<_CassettaFormDialog> createState() => _CassettaFormDialogState();
}

class _CassettaFormDialogState extends State<_CassettaFormDialog> {
  final _formKey = GlobalKey<FormState>();

  late final _numeroController =
      TextEditingController(text: widget.esistente?.numero ?? '');
  late final _noteController =
      TextEditingController(text: widget.esistente?.note ?? '');
  late final _dettaglioUbicazioneController =
      TextEditingController(text: widget.esistente?.dettaglioUbicazione ?? '');

  String? _tipologia;
  String? _cantiereSelezionatoId;
  String? _automezzoSelezionatoId;

  DateTime? _ultimaVerifica;
  DateTime? _prossimoControllo;

  late _TipoUbicazione _ubicazione;

  late List<_ArticoloDraft> _articoli;
  final _articoliRimossiIds = <String>[];

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final c = widget.esistente;
    _tipologia = (c == null || c.tipologia.isEmpty) ? null : c.tipologia;

    if (c == null ||
        (!c.inMagazzino && c.ubicazioneCantiereId.isEmpty && c.ubicazioneAutomezzoId.isEmpty && !c.inUfficio)) {
      _ubicazione = _TipoUbicazione.nessuna;
    } else if (c.inMagazzino) {
      _ubicazione = _TipoUbicazione.magazzino;
    } else if (c.ubicazioneCantiereId.isNotEmpty) {
      _ubicazione = _TipoUbicazione.cantiere;
    } else if (c.inUfficio) {
      _ubicazione = _TipoUbicazione.ufficio;
    } else {
      _ubicazione = _TipoUbicazione.automezzo;
    }
    _cantiereSelezionatoId = (c?.ubicazioneCantiereId.isEmpty ?? true) ? null : c!.ubicazioneCantiereId;
    _automezzoSelezionatoId = (c?.ubicazioneAutomezzoId.isEmpty ?? true) ? null : c!.ubicazioneAutomezzoId;

    _ultimaVerifica = _parseData(c?.ultimaVerifica ?? '');
    _prossimoControllo = _parseData(c?.prossimoControllo ?? '');

    _articoli = widget.articoli
        .where((a) => c != null && a.cassettaId == c.id)
        .map(_ArticoloDraft.fromArticolo)
        .toList();
  }

  @override
  void dispose() {
    _numeroController.dispose();
    _noteController.dispose();
    _dettaglioUbicazioneController.dispose();
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

  DateTime? get _prossimaScadenzaProdotti {
    final date = _articoli.map((a) => a.scadenza).whereType<DateTime>().toList()
      ..sort();
    return date.isEmpty ? null : date.first;
  }

  Future<void> _apriFormArticolo({_ArticoloDraft? esistente}) async {
    final risultato = await showDialog<_ArticoloDraft>(
      context: context,
      builder: (_) => _ArticoloDraftDialog(esistente: esistente),
    );
    if (risultato == null) return;
    setState(() {
      if (esistente == null) {
        _articoli.add(risultato);
      } else {
        final index = _articoli.indexOf(esistente);
        _articoli[index] = risultato;
      }
    });
  }

  /// Sostituisce l'intero elenco prodotti con quelli standard previsti per
  /// [tipologia]: i prodotti già presenti vengono rimossi (quelli già
  /// salvati vengono marcati per l'eliminazione al salvataggio) e al loro
  /// posto vengono inseriti quelli standard, con quantità precompilata e
  /// scadenza da impostare a mano.
  void _sostituisciProdottiConStandard(String tipologia) {
    for (final draft in _articoli) {
      if (draft.id != null) _articoliRimossiIds.add(draft.id!);
    }
    _articoli = widget.articoliStandardProvider
        .perTipologia(tipologia)
        .map(
          (standard) => _ArticoloDraft(
            nomeProdotto: standard.nomeProdotto,
            quantita: standard.quantita,
            scadenza: null,
            note: '',
            notaScadenza: '',
          ),
        )
        .toList();
  }

  void _rimuoviArticolo(_ArticoloDraft draft) {
    setState(() {
      _articoli.remove(draft);
      if (draft.id != null) _articoliRimossiIds.add(draft.id!);
    });
  }

  Widget _sezioneProdotti() {
    final l10n = AppLocalizations.of(context)!;
    final primaryBlue = Theme.of(context).primaryColor;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(l10n.cassettaPsFormDialogProductsSection, style: TextStyle(fontWeight: FontWeight.w600, color: primaryBlue)),
            TextButton.icon(
              onPressed: () => _apriFormArticolo(),
              icon: const Icon(Icons.add, size: 18),
              label: Text(l10n.cassettaPsFormDialogAddProduct),
            ),
          ],
        ),
        if (_articoli.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(l10n.cassettaPsFormDialogNoProducts, style: const TextStyle(color: Colors.black54)),
          )
        else
          for (final draft in _articoli)
            Builder(
              builder: (context) {
                final stato = computeStato(draft.scadenza);
                final sottotitolo = [
                  if (draft.quantita.isNotEmpty) l10n.cassettaPsFormDialogQuantityLabel(draft.quantita),
                  if (draft.scadenza != null)
                    l10n.cassettaPsFormDialogExpiryLabel(_dateFormat.format(draft.scadenza!)),
                ];
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                  leading: StatoBadge(stato: stato, showLabel: false),
                  title: Text(draft.nomeProdotto),
                  subtitle: sottotitolo.isEmpty
                      ? null
                      : Text(sottotitolo.join(' · ')),
                  trailing: Wrap(
                    spacing: 0,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit_outlined, color: primaryBlue, size: 18),
                        tooltip: l10n.cassettaPsFormDialogEditProductTooltip,
                        onPressed: () => _apriFormArticolo(esistente: draft),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete_outline, color: primaryBlue, size: 18),
                        tooltip: l10n.cassettaPsFormDialogRemoveProductTooltip,
                        onPressed: () => _rimuoviArticolo(draft),
                      ),
                    ],
                  ),
                );
              },
            ),
      ],
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);
    try {
      final numero = _numeroController.text.trim();
      final note = _noteController.text.trim();
      final inMagazzino = _ubicazione == _TipoUbicazione.magazzino;
      final inUfficio = _ubicazione == _TipoUbicazione.ufficio;
      final ubicazioneCantiereId =
          _ubicazione == _TipoUbicazione.cantiere ? _cantiereSelezionatoId : null;
      final ubicazioneAutomezzoId =
          _ubicazione == _TipoUbicazione.automezzo ? _automezzoSelezionatoId : null;
      final dettaglioUbicazione = _dettaglioUbicazioneController.text.trim();

      String cassettaId;
      if (widget.esistente == null) {
        cassettaId = await widget.provider.create(
          numero: numero,
          tipologia: _tipologia,
          inUfficio: inUfficio,
          inMagazzino: inMagazzino,
          ubicazioneCantiereId: ubicazioneCantiereId,
          ubicazioneAutomezzoId: ubicazioneAutomezzoId,
          dettaglioUbicazione: dettaglioUbicazione,
          ultimaVerifica: _ultimaVerifica,
          prossimoControllo: _prossimoControllo,
          note: note,
        );
      } else {
        cassettaId = widget.esistente!.id;
        await widget.provider.update(
          cassettaId,
          numero: numero,
          tipologia: _tipologia,
          inUfficio: inUfficio,
          inMagazzino: inMagazzino,
          ubicazioneCantiereId: ubicazioneCantiereId,
          ubicazioneAutomezzoId: ubicazioneAutomezzoId,
          dettaglioUbicazione: dettaglioUbicazione,
          ultimaVerifica: _ultimaVerifica,
          prossimoControllo: _prossimoControllo,
          note: note,
        );
      }

      for (final draft in _articoli) {
        if (draft.id == null) {
          await widget.articoliProvider.create(
            nomeProdotto: draft.nomeProdotto,
            cassettaId: cassettaId,
            quantita: draft.quantita,
            scadenza: draft.scadenza,
            note: draft.note,
            notaScadenza: draft.notaScadenza,
          );
        } else {
          await widget.articoliProvider.update(
            draft.id!,
            nomeProdotto: draft.nomeProdotto,
            cassettaId: cassettaId,
            quantita: draft.quantita,
            scadenza: draft.scadenza,
            note: draft.note,
            notaScadenza: draft.notaScadenza,
          );
        }
      }
      for (final id in _articoliRimossiIds) {
        await widget.articoliProvider.delete(id);
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
    final prossimaScadenzaProdotti = _prossimaScadenzaProdotti;
    return AlertDialog(
      title: Text(widget.esistente == null ? l10n.cassettaPsFormDialogNewTitle : l10n.cassettaPsFormDialogEditTitle),
      content: Form(
        key: _formKey,
        child: SizedBox(
          width: 460,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _numeroController,
                  decoration: InputDecoration(labelText: l10n.cassettaPsFormDialogNumberLabel),
                  validator: (v) => (v == null || v.trim().isEmpty) ? l10n.commonRequiredField : null,
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String?>(
                  initialValue: _tipologia,
                  decoration: InputDecoration(labelText: l10n.cassettaPsFormDialogTypeLabel),
                  borderRadius: BorderRadius.circular(15),
                  isExpanded: true,
                  itemHeight: null,
                  items: [
                    DropdownMenuItem(value: null, child: Text(l10n.cassettaPsFormDialogNotSpecified)),
                    ..._tipologieKeys.map(
                      (tipologia) => DropdownMenuItem(
                        value: tipologia,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Text(_tipologiaLabel(l10n, tipologia)),
                        ),
                      ),
                    ),
                  ],
                  selectedItemBuilder: (context) => [
                    Text(l10n.cassettaPsFormDialogNotSpecified),
                    ..._tipologieKeys.map(
                      (tipologia) => Text(_tipologiaLabel(l10n, tipologia), maxLines: 1, overflow: TextOverflow.ellipsis),
                    ),
                  ],
                  onChanged: (v) => setState(() {
                    _tipologia = v;
                    if (v != null) _sostituisciProdottiConStandard(v);
                  }),
                ),
                const Divider(height: 24),
                Text(l10n.cassettaPsFormDialogLocationSection, style: TextStyle(fontWeight: FontWeight.w600, color: primaryBlue)),
                const SizedBox(height: 8),
                DropdownButtonFormField<_TipoUbicazione>(
                  borderRadius: BorderRadius.circular(15),
                  initialValue: _ubicazione,
                  decoration: InputDecoration(labelText: l10n.cassettaPsFormDialogLocationTypeLabel),
                  items: [
                    DropdownMenuItem(value: _TipoUbicazione.nessuna, child: Text(l10n.cassettaPsFormDialogNotSpecified)),
                    DropdownMenuItem(value: _TipoUbicazione.magazzino, child: Text(l10n.cassettaPsFormDialogLocationWarehouse)),
                    DropdownMenuItem(value: _TipoUbicazione.ufficio, child: Text(l10n.cassettaPsFormDialogLocationOffice)),
                    DropdownMenuItem(value: _TipoUbicazione.cantiere, child: Text(l10n.cassettaPsFormDialogLocationSite)),
                    DropdownMenuItem(value: _TipoUbicazione.automezzo, child: Text(l10n.cassettaPsFormDialogLocationVehicle)),
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
                    decoration: InputDecoration(labelText: l10n.cassettaPsFormDialogSiteLabel),
                    items: widget.cantieri
                        .map((c) => DropdownMenuItem(value: c.id, child: Text(c.nome)))
                        .toList(),
                    onChanged: (v) => setState(() => _cantiereSelezionatoId = v),
                    validator: (v) => v == null ? l10n.cassettaPsFormDialogSelectSiteValidator : null,
                  ),
                ],
                if (_ubicazione == _TipoUbicazione.automezzo) ...[
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String?>(
                    borderRadius: BorderRadius.circular(15),
                    initialValue: widget.automezzi.any((a) => a.id == _automezzoSelezionatoId)
                        ? _automezzoSelezionatoId
                        : null,
                    decoration: InputDecoration(labelText: l10n.cassettaPsFormDialogVehicleLabel),
                    items: widget.automezzi
                        .map((a) => DropdownMenuItem(
                              value: a.id,
                              child: Text(a.descrizioneConTarga),
                            ))
                        .toList(),
                    onChanged: (v) => setState(() => _automezzoSelezionatoId = v),
                    validator: (v) => v == null ? l10n.cassettaPsFormDialogSelectVehicleValidator : null,
                  ),
                ],
                TextField(
                  controller: _dettaglioUbicazioneController,
                  decoration: InputDecoration(labelText: l10n.cassettaPsFormDialogLocationDetailsLabel),
                ),
                const Divider(height: 24),
                Text(l10n.cassettaPsFormDialogChecksSection, style: TextStyle(fontWeight: FontWeight.w600, color: primaryBlue)),
                _campoData(l10n.cassettaPsFormDialogLastCheckLabel, _ultimaVerifica, (v) {
                  _ultimaVerifica = v;
                  if (v != null){
                    _prossimoControllo = _aggiungiPeriodo(v, giorni: 182);
                  }
                }),
                _campoData(l10n.cassettaPsFormDialogNextCheckLabel, _prossimoControllo, (v) => _prossimoControllo = v),
                const Divider(height: 24),
                _sezioneProdotti(),
                const Divider(height: 24),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                  title: Text(l10n.cassettaPsFormDialogNextProductExpiryTitle, style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text(
                    prossimaScadenzaProdotti == null
                        ? l10n.cassettaPsFormDialogNoProductExpiry
                        : _dateFormat.format(prossimaScadenzaProdotti),
                  ),
                ),
                const Divider(height: 24),
                TextFormField(
                  controller: _noteController,
                  decoration: InputDecoration(labelText: l10n.commonNoteLabel),
                  maxLines: 2,
                ),
              ]
            ),
          )
        )
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

/// Form compatto per aggiungere/modificare un singolo prodotto della
/// cassetta, mostrato come dialog sopra quello della cassetta.
class _ArticoloDraftDialog extends StatefulWidget {
  const _ArticoloDraftDialog({this.esistente});

  final _ArticoloDraft? esistente;

  @override
  State<_ArticoloDraftDialog> createState() => _ArticoloDraftDialogState();
}

class _ArticoloDraftDialogState extends State<_ArticoloDraftDialog> {
  final _formKey = GlobalKey<FormState>();

  late final _nomeController =
      TextEditingController(text: widget.esistente?.nomeProdotto ?? '');
  late final _quantitaController =
      TextEditingController(text: widget.esistente?.quantita ?? '');
  late final _noteController =
      TextEditingController(text: widget.esistente?.note ?? '');

  late DateTime? _scadenza = widget.esistente?.scadenza;

  @override
  void dispose() {
    _nomeController.dispose();
    _quantitaController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.of(context).pop(
      _ArticoloDraft(
        id: widget.esistente?.id,
        nomeProdotto: _nomeController.text.trim(),
        quantita: _quantitaController.text.trim(),
        scadenza: _scadenza,
        note: _noteController.text.trim(),
        notaScadenza: widget.esistente?.notaScadenza ?? '',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(widget.esistente == null ? l10n.cassettaPsFormDialogNewProductTitle : l10n.cassettaPsFormDialogEditProductTitle),
      content: Form(
        key: _formKey,
        child: SizedBox(
          width: 380,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _nomeController,
                  decoration: InputDecoration(labelText: l10n.cassettaPsFormDialogProductNameLabel),
                  validator: (v) => (v == null || v.trim().isEmpty) ? l10n.commonRequiredField : null,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _quantitaController,
                  decoration: InputDecoration(labelText: l10n.cassettaPsFormDialogQuantityFieldLabel),
                ),
                const SizedBox(height: 8),
                CampoData(
                  label: l10n.cassettaPsFormDialogExpiryFieldLabel,
                  valore: _scadenza,
                  onChanged: (v) => setState(() => _scadenza = v),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _noteController,
                  decoration: InputDecoration(labelText: l10n.commonNoteLabel),
                  maxLines: 2,
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.commonCancel),
        ),
        FilledButton(
          onPressed: _submit,
          child: Text(l10n.commonSave),
        ),
      ],
    );
  }
}
