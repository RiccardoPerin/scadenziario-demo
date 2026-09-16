import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';

import '../l10n/app_localizations.dart';
import '../models/automezzo.dart';
import '../models/cantiere.dart';
import '../models/fascia_catena.dart';
import '../providers/fasce_catene_provider.dart';
import '../services/pocketbase_service.dart';
import 'campo_data.dart';

DateTime? _parseData(String value) => value.isEmpty ? null : DateTime.tryParse(value);

DateTime _aggiungiPeriodo(DateTime data, {int anni = 0, int mesi = 0}) {
  return DateTime(data.year + anni, data.month + mesi, data.day);
}

const _estensioniAmmesse = ['jpg', 'jpeg', 'png', 'webp'];

/// Deve combaciare con il "maxSize" del campo file "foto" della collection
/// "fasce_catene": lasciato a 0 nella migration, PocketBase applica il suo
/// default di 5 MB. Senza questo controllo lato client un file più grande
/// verrebbe respinto dal server con un errore generico invece del messaggio
/// "Immagine troppo grande".
const _dimensioneMassimaBytes = 5242880;

String _estensioneDi(String nomeFile) {
  final punto = nomeFile.lastIndexOf('.');
  return punto == -1 ? '' : nomeFile.substring(punto + 1).toLowerCase();
}

enum _TipoUbicazione { nessuna, magazzino, cantiere, automezzo }

/// Form di creazione/modifica di una fascia o catena.
/// Passando [esistente] il dialog lavora in modifica.
Future<void> showFasciaCatenaFormDialog(
  BuildContext context, {
  required FasceCateneProvider provider,
  required List<Cantiere> cantieri,
  required List<Automezzo> automezzi,
  FasciaCatena? esistente,
}) {
  return showDialog(
    context: context,
    builder: (_) => _FasciaCatenaFormDialog(
      provider: provider,
      cantieri: cantieri,
      automezzi: automezzi,
      esistente: esistente,
    ),
  );
}

class _FasciaCatenaFormDialog extends StatefulWidget {
  const _FasciaCatenaFormDialog({
    required this.provider,
    required this.cantieri,
    required this.automezzi,
    this.esistente,
  });

  final FasceCateneProvider provider;
  final List<Cantiere> cantieri;
  final List<Automezzo> automezzi;
  final FasciaCatena? esistente;

  @override
  State<_FasciaCatenaFormDialog> createState() => _FasciaCatenaFormDialogState();
}

class _FasciaCatenaFormDialogState extends State<_FasciaCatenaFormDialog> {
  final _formKey = GlobalKey<FormState>();

  late final _idInternoController =
      TextEditingController(text: widget.esistente?.idInterno ?? '');
  late final _numeroSerieController =
      TextEditingController(text: widget.esistente?.numeroSerie ?? '');
  late final _coloreController =
      TextEditingController(text: widget.esistente?.colore ?? '');
  late final _portataController =
      TextEditingController(text: widget.esistente?.portata ?? '');
  late final _lunghezzaController =
      TextEditingController(text: widget.esistente?.lunghezza ?? '');
  late final _spessoreController =
      TextEditingController(text: widget.esistente?.spessore ?? '');
  late final _diametroController =
      TextEditingController(text: widget.esistente?.diametro ?? '');
  late final _larghezzaController = 
      TextEditingController(text: widget.esistente?.larghezza ?? '');
  late final _luogoAcquistoController =
      TextEditingController(text: widget.esistente?.luogoAcquisto ?? '');
  late final _noteController =
      TextEditingController(text: widget.esistente?.note ?? '');

  String? _tipoFascia;

  late _TipoUbicazione _ubicazione;
  String? _cantiereSelezionatoId;
  String? _automezzoSelezionatoId;

  DateTime? _dataAcquisto;
  DateTime? _dataUltimaVerificaInterna;
  DateTime? _dataProssimaVerifica;
  bool _esitoVerifica = true;
  bool _cricchetto = false;

  DropzoneViewController? _dropzoneController;
  Uint8List? _fileBytes;
  String? _fileNome;
  bool _dragHover = false;
  String? _erroreFile;
  bool _isSaving = false;

  /// In modifica: true quando si è tolta la foto già caricata senza
  /// sostituirla, così il salvataggio la cancella anche sul server.
  bool _rimuoviFoto = false;

  bool get _isModifica => widget.esistente != null;

  /// Il cricchetto è una caratteristica dei soli nastri di ancoraggio: se si
  /// cambia tipo dopo averlo acceso, il flag non va salvato (l'interruttore
  /// conserva comunque il valore, per non perderlo tornando sui nastri).
  bool get _haCricchetto =>
      _tipoFascia == tipoFasciaNastroAncoraggio && _cricchetto;

  /// Foto già su PocketBase ancora valida (non rimossa né sostituita).
  bool get _mostraFotoEsistente =>
      _fileBytes == null &&
      !_rimuoviFoto &&
      (widget.esistente?.haFoto ?? false);

  @override
  void initState() {
    super.initState();
    final f = widget.esistente;
    _tipoFascia = tipiFascia.contains(f?.tipoFascia) ? f!.tipoFascia : null;

    if (f == null ||
        (!f.inMagazzino &&
            f.ubicazioneCantiereId.isEmpty &&
            f.ubicazioneAutomezzoId.isEmpty)) {
      _ubicazione = _TipoUbicazione.nessuna;
    } else if (f.inMagazzino) {
      _ubicazione = _TipoUbicazione.magazzino;
    } else if (f.ubicazioneCantiereId.isNotEmpty) {
      _ubicazione = _TipoUbicazione.cantiere;
    } else {
      _ubicazione = _TipoUbicazione.automezzo;
    }
    _cantiereSelezionatoId =
        (f?.ubicazioneCantiereId.isEmpty ?? true) ? null : f!.ubicazioneCantiereId;
    _automezzoSelezionatoId =
        (f?.ubicazioneAutomezzoId.isEmpty ?? true) ? null : f!.ubicazioneAutomezzoId;

    _dataAcquisto = _parseData(f?.dataAcquisto ?? '');
    _dataUltimaVerificaInterna = _parseData(f?.dataUltimaVerificaInterna ?? '');
    _dataProssimaVerifica = _parseData(f?.dataProssimaVerifica ?? '');
    // Su un record nuovo si parte da "conforme": l'esito negativo è
    // l'eccezione da segnalare, non il valore di partenza.
    _esitoVerifica = f?.esitoVerifica ?? true;
    _cricchetto = f?.cricchetto ?? false;
  }

  @override
  void dispose() {
    _idInternoController.dispose();
    _numeroSerieController.dispose();
    _coloreController.dispose();
    _portataController.dispose();
    _lunghezzaController.dispose();
    _spessoreController.dispose();
    _diametroController.dispose();
    _larghezzaController.dispose();
    _luogoAcquistoController.dispose();
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

  Future<void> _gestisciFile(DropzoneFileInterface file) async {
    final l10n = AppLocalizations.of(context)!;
    final estensione = _estensioneDi(file.name);
    if (!_estensioniAmmesse.contains(estensione)) {
      setState(() {
        _erroreFile = l10n.fasciaCatenaFormDialogInvalidExtension(estensione);
        _fileBytes = null;
        _fileNome = null;
      });
      return;
    }
    if (file.size > _dimensioneMassimaBytes) {
      setState(() {
        _erroreFile = l10n.fasciaCatenaFormDialogImageTooLarge;
        _fileBytes = null;
        _fileNome = null;
      });
      return;
    }
    final bytes = await _dropzoneController!.getFileData(file);
    if (!mounted) return;
    setState(() {
      _erroreFile = null;
      _fileBytes = bytes;
      _fileNome = file.name;
      _rimuoviFoto = false;
    });
  }

  Future<void> _scegliFile() async {
    final controller = _dropzoneController;
    if (controller == null) return;
    final files = await controller.pickFiles();
    if (files.isEmpty) return;
    await _gestisciFile(files.first);
  }

  void _rimuoviImmagine() {
    setState(() {
      _fileBytes = null;
      _fileNome = null;
      _erroreFile = null;
      _rimuoviFoto = true;
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);
    try {
      final inMagazzino = _ubicazione == _TipoUbicazione.magazzino;
      final ubicazioneCantiereId =
          _ubicazione == _TipoUbicazione.cantiere ? _cantiereSelezionatoId : null;
      final ubicazioneAutomezzoId =
          _ubicazione == _TipoUbicazione.automezzo ? _automezzoSelezionatoId : null;

      if (_isModifica) {
        await widget.provider.update(
          widget.esistente!.id,
          idInterno: _idInternoController.text.trim(),
          numeroSerie: _numeroSerieController.text.trim(),
          tipoFascia: _tipoFascia,
          cricchetto: _haCricchetto,
          colore: _coloreController.text.trim(),
          portata: _portataController.text.trim(),
          spessore: _spessoreController.text.trim(),
          diametro: _diametroController.text.trim(),
          lunghezza: _lunghezzaController.text.trim(),
          inMagazzino: inMagazzino,
          ubicazioneCantiereId: ubicazioneCantiereId,
          ubicazioneAutomezzoId: ubicazioneAutomezzoId,
          dataAcquisto: _dataAcquisto,
          luogoAcquisto: _luogoAcquistoController.text.trim(),
          dataUltimaVerificaInterna: _dataUltimaVerificaInterna,
          esitoVerifica: _esitoVerifica,
          dataProssimaVerifica: _dataProssimaVerifica,
          note: _noteController.text.trim(),
          fotoBytes: _fileBytes,
          fotoFileName: _fileNome,
          rimuoviFoto: _rimuoviFoto,
        );
      } else {
        await widget.provider.create(
          idInterno: _idInternoController.text.trim(),
          numeroSerie: _numeroSerieController.text.trim(),
          tipoFascia: _tipoFascia,
          cricchetto: _haCricchetto,
          colore: _coloreController.text.trim(),
          portata: _portataController.text.trim(),
          spessore: _spessoreController.text.trim(),
          diametro: _diametroController.text.trim(),
          lunghezza: _lunghezzaController.text.trim(),
          inMagazzino: inMagazzino,
          ubicazioneCantiereId: ubicazioneCantiereId,
          ubicazioneAutomezzoId: ubicazioneAutomezzoId,
          dataAcquisto: _dataAcquisto,
          luogoAcquisto: _luogoAcquistoController.text.trim(),
          dataUltimaVerificaInterna: _dataUltimaVerificaInterna,
          esitoVerifica: _esitoVerifica,
          dataProssimaVerifica: _dataProssimaVerifica,
          note: _noteController.text.trim(),
          fotoBytes: _fileBytes,
          fotoFileName: _fileNome,
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
      title: Text(_isModifica ? l10n.fasciaCatenaFormDialogEditTitle : l10n.fasciaCatenaFormDialogNewTitle),
      content: Form(
        key: _formKey,
        child: SizedBox(
          width: 440,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.fasciaCatenaFormDialogRegistrySection, style: TextStyle(fontWeight: FontWeight.w600, color: primaryBlue)),
                TextFormField(
                  controller: _idInternoController,
                  decoration: InputDecoration(labelText: l10n.fasciaCatenaFormDialogInternalIdLabel),
                  validator: (v) => (v == null || v.trim().isEmpty) ? l10n.commonRequiredField : null,
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String?>(
                  borderRadius: BorderRadius.circular(15),
                  isExpanded: true,
                  initialValue: _tipoFascia,
                  decoration: InputDecoration(labelText: l10n.fasciaCatenaFormDialogTypeLabel),
                  items: [
                    DropdownMenuItem(value: null, child: Text(l10n.fasciaCatenaFormDialogTypeNotSpecified)),
                    ...tipiFascia.map(
                      (t) => DropdownMenuItem(value: t, child: Text(etichettaTipoFascia(t))),
                    ),
                  ],
                  onChanged: (v) => setState(() => _tipoFascia = v),
                ),
                const SizedBox(height: 8),
                if (_tipoFascia == tipoFasciaNastroAncoraggio) ... [
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(l10n.fasciaCatenaFormDialogRatchetLabel),
                    value: _cricchetto,
                    onChanged: (v) => setState(() => _cricchetto = v),
                  ),
                ],
                TextFormField(
                  controller: _numeroSerieController,
                  decoration: InputDecoration(labelText: l10n.fasciaCatenaFormDialogSerialNumberLabel),
                ),
                TextFormField(
                  controller: _coloreController,
                  decoration: InputDecoration(labelText: l10n.fasciaCatenaFormDialogColorLabel),
                ),
                const Divider(height: 24),
                Text(l10n.fasciaCatenaFormDialogCharacteristicsSection, style: TextStyle(fontWeight: FontWeight.w600, color: primaryBlue)),
                TextFormField(
                  controller: _portataController,
                  decoration: InputDecoration(labelText: l10n.fasciaCatenaFormDialogCapacityLabel),
                ),
                TextFormField(
                  controller: _spessoreController,
                  decoration: InputDecoration(labelText: l10n.fasciaCatenaFormDialogThicknessLabel),
                ),
                if (_tipoFascia == 'braca di catene') ... [
                  TextFormField(
                    controller: _diametroController,
                    decoration: InputDecoration(labelText: l10n.fasciaCatenaFormDialogDiameterLabel),
                  ),
                ]
                else ... [
                  TextFormField(
                    controller: _larghezzaController,
                    decoration: InputDecoration(labelText: l10n.fasciaCatenaFormDialogWidthLabel),
                  ),
                ],
                TextFormField(
                  controller: _lunghezzaController,
                  decoration: InputDecoration(labelText: l10n.fasciaCatenaFormDialogLengthLabel),
                ),
                const Divider(height: 24),
                Text(l10n.fasciaCatenaFormDialogLocationSection, style: TextStyle(fontWeight: FontWeight.w600, color: primaryBlue)),
                const SizedBox(height: 8),
                DropdownButtonFormField<_TipoUbicazione>(
                  borderRadius: BorderRadius.circular(15),
                  initialValue: _ubicazione,
                  decoration: InputDecoration(labelText: l10n.fasciaCatenaFormDialogLocationTypeLabel),
                  items: [
                    DropdownMenuItem(value: _TipoUbicazione.nessuna, child: Text(l10n.fasciaCatenaFormDialogLocationNotSpecified)),
                    DropdownMenuItem(value: _TipoUbicazione.magazzino, child: Text(l10n.fasciaCatenaFormDialogWarehouseOption)),
                    DropdownMenuItem(value: _TipoUbicazione.cantiere, child: Text(l10n.fasciaCatenaFormDialogSiteOption)),
                    DropdownMenuItem(value: _TipoUbicazione.automezzo, child: Text(l10n.fasciaCatenaFormDialogVehicleOption)),
                  ],
                  onChanged: (v) => setState(() => _ubicazione = v ?? _TipoUbicazione.nessuna),
                ),
                if (_ubicazione == _TipoUbicazione.cantiere) ...[
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String?>(
                    borderRadius: BorderRadius.circular(15),
                    isExpanded: true,
                    initialValue: widget.cantieri.any((c) => c.id == _cantiereSelezionatoId)
                        ? _cantiereSelezionatoId
                        : null,
                    decoration: InputDecoration(labelText: l10n.fasciaCatenaFormDialogSiteOption),
                    items: widget.cantieri
                        .map((c) => DropdownMenuItem(value: c.id, child: Text(c.nome)))
                        .toList(),
                    onChanged: (v) => setState(() => _cantiereSelezionatoId = v),
                    validator: (v) => v == null ? l10n.fasciaCatenaFormDialogSelectSite : null,
                  ),
                ],
                if (_ubicazione == _TipoUbicazione.automezzo) ...[
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String?>(
                    borderRadius: BorderRadius.circular(15),
                    isExpanded: true,
                    initialValue: widget.automezzi.any((a) => a.id == _automezzoSelezionatoId)
                        ? _automezzoSelezionatoId
                        : null,
                    decoration: InputDecoration(labelText: l10n.fasciaCatenaFormDialogVehicleOption),
                    items: widget.automezzi
                        .map((a) => DropdownMenuItem(
                              value: a.id,
                              child: Text(a.descrizioneConTarga),
                            ))
                        .toList(),
                    onChanged: (v) => setState(() => _automezzoSelezionatoId = v),
                    validator: (v) => v == null ? l10n.fasciaCatenaFormDialogSelectVehicle : null,
                  ),
                ],
                const Divider(height: 24),
                Text(l10n.fasciaCatenaFormDialogPurchaseSection, style: TextStyle(fontWeight: FontWeight.w600, color: primaryBlue)),
                _campoData(l10n.fasciaCatenaFormDialogPurchaseDateLabel, _dataAcquisto, (v) => _dataAcquisto = v),
                TextFormField(
                  controller: _luogoAcquistoController,
                  decoration: InputDecoration(labelText: l10n.fasciaCatenaFormDialogPurchaseLocationLabel),
                ),
                const Divider(height: 24),
                Text(l10n.fasciaCatenaFormDialogInternalCheckSection, style: TextStyle(fontWeight: FontWeight.w600, color: primaryBlue)),
                _campoData(l10n.fasciaCatenaFormDialogLastInternalCheckLabel, _dataUltimaVerificaInterna, (v) {
                  _dataUltimaVerificaInterna = v;
                  // Verifica periodica annuale degli accessori di sollevamento.
                  if (v != null) {
                    _dataProssimaVerifica = _aggiungiPeriodo(v, mesi: 3);
                  }
                }),
                _campoData(l10n.fasciaCatenaFormDialogNextCheckLabel, _dataProssimaVerifica,
                    (v) => _dataProssimaVerifica = v),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(l10n.fasciaCatenaFormDialogCheckPassedLabel),
                  subtitle: Text(
                    _esitoVerifica
                        ? l10n.fasciaCatenaFormDialogFitForUse
                        : l10n.fasciaCatenaFormDialogNotFitForUse,
                    style: TextStyle(
                      fontSize: 12,
                      color: _esitoVerifica ? Colors.black54 : Colors.red,
                    ),
                  ),
                  value: _esitoVerifica,
                  onChanged: (v) => setState(() => _esitoVerifica = v),
                ),
                const Divider(height: 24),
                Text(l10n.fasciaCatenaFormDialogPhotoSection, style: TextStyle(fontWeight: FontWeight.w600, color: primaryBlue)),
                const SizedBox(height: 8),
                Container(
                  height: 150,
                  decoration: BoxDecoration(
                    color: _dragHover ? primaryBlue.withValues(alpha: 0.06) : null,
                    border: Border.all(
                      color: _erroreFile != null
                          ? Colors.red
                          : _dragHover
                          ? primaryBlue
                          : Colors.black26,
                      width: _dragHover ? 2 : 1,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(11),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        DropzoneView(
                          cursor: CursorType.grab,
                          onCreated: (controller) => _dropzoneController = controller,
                          onHover: () => setState(() => _dragHover = true),
                          onLeave: () => setState(() => _dragHover = false),
                          onDropFile: (file) {
                            setState(() => _dragHover = false);
                            _gestisciFile(file);
                          },
                        ),
                        Center(child: _anteprima(context, primaryBlue)),
                      ],
                    ),
                  ),
                ),
                if (_erroreFile != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      _erroreFile!,
                      style: const TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Row(
                    children: [
                      TextButton(
                        onPressed: _scegliFile,
                        child: Text(
                          _fileBytes != null || _mostraFotoEsistente
                              ? l10n.fasciaCatenaFormDialogChangePhoto
                              : l10n.fasciaCatenaFormDialogBrowse,
                        ),
                      ),
                      if (_fileBytes != null || _mostraFotoEsistente)
                        TextButton(
                          onPressed: _rimuoviImmagine,
                          child: Text(
                            l10n.fasciaCatenaFormDialogRemove,
                            style: const TextStyle(color: Colors.redAccent),
                          ),
                        ),
                    ],
                  ),
                ),
                const Divider(height: 24),
                TextField(
                  controller: _noteController,
                  decoration: InputDecoration(labelText: l10n.fasciaCatenaFormDialogAdditionalNotesLabel),
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

  /// Anteprima della foto appena scelta o di quella già salvata; se non c'è
  /// nulla mostra l'invito a trascinare il file.
  Widget _anteprima(BuildContext context, Color primaryBlue) {
    final l10n = AppLocalizations.of(context)!;
    if (_fileBytes != null) {
      return Image.memory(_fileBytes!, fit: BoxFit.contain);
    }
    if (_mostraFotoEsistente) {
      return Image.network(
        widget.esistente!.getImageUrl(PocketBaseService.instance.pb),
        fit: BoxFit.contain,
        errorBuilder: (_, _, _) => Text(l10n.fasciaCatenaFormDialogImageUnavailable),
      );
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.cloud_upload_outlined, color: primaryBlue, size: 28),
        const SizedBox(height: 6),
        Text(
          l10n.fasciaCatenaFormDialogDragPhotoHint,
          textAlign: TextAlign.center,
        ),
        Text(
          l10n.fasciaCatenaFormDialogFileFormatsHint,
          style: const TextStyle(fontSize: 11, color: Colors.black54),
        ),
      ],
    );
  }
}
