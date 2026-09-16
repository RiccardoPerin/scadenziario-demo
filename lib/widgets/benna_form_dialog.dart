import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';

import '../l10n/app_localizations.dart';
import '../models/benna.dart';
import '../models/cantiere.dart';
import '../providers/benne_provider.dart';
import '../services/pocketbase_service.dart';
import 'campo_data.dart';

DateTime? _parseData(String value) => value.isEmpty ? null : DateTime.tryParse(value);

DateTime _aggiungiPeriodo(DateTime data, {int anni = 0, int mesi = 0}) {
  return DateTime(data.year + anni, data.month + mesi, data.day);
}

const _estensioniAmmesse = ['jpg', 'jpeg', 'png', 'webp'];

/// Deve combaciare con il "maxSize" del campo file "foto" della collection
/// "benne": lasciato a 0 nella migration, PocketBase applica il suo default
/// di 5 MB. Senza questo controllo lato client un file più grande verrebbe
/// respinto dal server con un errore generico invece del messaggio
/// "Immagine troppo grande".
const _dimensioneMassimaBytes = 5242880;

String _estensioneDi(String nomeFile) {
  final punto = nomeFile.lastIndexOf('.');
  return punto == -1 ? '' : nomeFile.substring(punto + 1).toLowerCase();
}

/// La collection "benne" non ha il campo `ubicazione_automezzo` (a differenza
/// di fasce e catene): qui le ubicazioni possibili sono solo queste.
enum _TipoUbicazione { nessuna, magazzino, cantiere }

/// Form di creazione/modifica di una benna.
/// Passando [esistente] il dialog lavora in modifica.
Future<void> showBennaFormDialog(
  BuildContext context, {
  required BenneProvider provider,
  required List<Cantiere> cantieri,
  Benna? esistente,
}) {
  return showDialog(
    context: context,
    builder: (_) => _BennaFormDialog(
      provider: provider,
      cantieri: cantieri,
      esistente: esistente,
    ),
  );
}

class _BennaFormDialog extends StatefulWidget {
  const _BennaFormDialog({
    required this.provider,
    required this.cantieri,
    this.esistente,
  });

  final BenneProvider provider;
  final List<Cantiere> cantieri;
  final Benna? esistente;

  @override
  State<_BennaFormDialog> createState() => _BennaFormDialogState();
}

class _BennaFormDialogState extends State<_BennaFormDialog> {
  final _formKey = GlobalKey<FormState>();

  late final _idInternoController =
      TextEditingController(text: widget.esistente?.idInterno ?? '');
  late final _numeroSerieController =
      TextEditingController(text: widget.esistente?.numeroSerie ?? '');
  late final _descrizioneController =
      TextEditingController(text: widget.esistente?.descrizione ?? '');
  late final _capacitaCaricoController =
      TextEditingController(text: widget.esistente?.capacitaCarico ?? '');
  late final _noteController =
      TextEditingController(text: widget.esistente?.note ?? '');

  late _TipoUbicazione _ubicazione;
  String? _cantiereSelezionatoId;

  DateTime? _dataAcquisto;
  DateTime? _dataUltimaVerificaInterna;
  DateTime? _dataProssimaVerifica;
  bool _esitoVerifica = true;

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

  /// Foto già su PocketBase ancora valida (non rimossa né sostituita).
  bool get _mostraFotoEsistente =>
      _fileBytes == null && !_rimuoviFoto && (widget.esistente?.haFoto ?? false);

  @override
  void initState() {
    super.initState();
    final b = widget.esistente;

    if (b == null || (!b.inMagazzino && b.ubicazioneCantiereId.isEmpty)) {
      _ubicazione = _TipoUbicazione.nessuna;
    } else if (b.inMagazzino) {
      _ubicazione = _TipoUbicazione.magazzino;
    } else {
      _ubicazione = _TipoUbicazione.cantiere;
    }
    _cantiereSelezionatoId =
        (b?.ubicazioneCantiereId.isEmpty ?? true) ? null : b!.ubicazioneCantiereId;

    _dataAcquisto = _parseData(b?.dataAcquisto ?? '');
    _dataUltimaVerificaInterna = _parseData(b?.dataUltimaVerificaInterna ?? '');
    _dataProssimaVerifica = _parseData(b?.dataProssimaVerifica ?? '');
    // Su un record nuovo si parte da "conforme": l'esito negativo è
    // l'eccezione da segnalare, non il valore di partenza.
    _esitoVerifica = b?.esitoVerifica ?? true;
  }

  @override
  void dispose() {
    _idInternoController.dispose();
    _numeroSerieController.dispose();
    _descrizioneController.dispose();
    _capacitaCaricoController.dispose();
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
        _erroreFile = l10n.bennaFormDialogEstensioneNonAmmessa(estensione);
        _fileBytes = null;
        _fileNome = null;
      });
      return;
    }
    if (file.size > _dimensioneMassimaBytes) {
      setState(() {
        _erroreFile = l10n.bennaFormDialogImmagineTroppoGrande;
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

      if (_isModifica) {
        await widget.provider.update(
          widget.esistente!.id,
          idInterno: _idInternoController.text.trim(),
          numeroSerie: _numeroSerieController.text.trim(),
          descrizione: _descrizioneController.text.trim(),
          capacitaCarico: _capacitaCaricoController.text.trim(),
          inMagazzino: inMagazzino,
          ubicazioneCantiereId: ubicazioneCantiereId,
          dataAcquisto: _dataAcquisto,
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
          descrizione: _descrizioneController.text.trim(),
          capacitaCarico: _capacitaCaricoController.text.trim(),
          inMagazzino: inMagazzino,
          ubicazioneCantiereId: ubicazioneCantiereId,
          dataAcquisto: _dataAcquisto,
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
    return AlertDialog(
      title: Text(_isModifica ? l10n.bennaFormDialogModificaTitle : l10n.bennaFormDialogNuovaTitle),
      content: Form(
        key: _formKey,
        child: SizedBox(
          width: 440,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.bennaFormDialogAnagrafica, style: TextStyle(fontWeight: FontWeight.w600, color: primaryBlue)),
                TextFormField(
                  controller: _idInternoController,
                  decoration: InputDecoration(labelText: l10n.bennaFormDialogIdInterno),
                  validator: (v) => (v == null || v.trim().isEmpty) ? l10n.commonRequiredField : null,
                ),
                TextFormField(
                  controller: _descrizioneController,
                  decoration: InputDecoration(labelText: l10n.bennaFormDialogDescrizione),
                ),
                TextFormField(
                  controller: _numeroSerieController,
                  decoration: InputDecoration(labelText: l10n.bennaFormDialogNumeroSerieProduttore),
                ),
                TextFormField(
                  controller: _capacitaCaricoController,
                  decoration: InputDecoration(labelText: l10n.bennaFormDialogCapacitaCaricoLt),
                ),
                const Divider(height: 24),
                Text(l10n.bennaFormDialogUbicazione, style: TextStyle(fontWeight: FontWeight.w600, color: primaryBlue)),
                const SizedBox(height: 8),
                DropdownButtonFormField<_TipoUbicazione>(
                  borderRadius: BorderRadius.circular(15),
                  initialValue: _ubicazione,
                  decoration: InputDecoration(labelText: l10n.bennaFormDialogTipoUbicazione),
                  items: [
                    DropdownMenuItem(
                      value: _TipoUbicazione.nessuna,
                      child: Text(l10n.bennaFormDialogNonSpecificata),
                    ),
                    DropdownMenuItem(
                      value: _TipoUbicazione.magazzino,
                      child: Text(l10n.bennaFormDialogMagazzino),
                    ),
                    DropdownMenuItem(
                      value: _TipoUbicazione.cantiere,
                      child: Text(l10n.bennaFormDialogCantiere),
                    ),
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
                    decoration: InputDecoration(labelText: l10n.bennaFormDialogCantiere),
                    items: widget.cantieri
                        .map((c) => DropdownMenuItem(value: c.id, child: Text(c.nome)))
                        .toList(),
                    onChanged: (v) => setState(() => _cantiereSelezionatoId = v),
                    validator: (v) => v == null ? l10n.bennaFormDialogSelezionaCantiere : null,
                  ),
                ],
                const Divider(height: 24),
                Text(l10n.bennaFormDialogAcquisto, style: TextStyle(fontWeight: FontWeight.w600, color: primaryBlue)),
                _campoData(l10n.bennaFormDialogDataAcquisto, _dataAcquisto, (v) => _dataAcquisto = v),
                const Divider(height: 24),
                Text(l10n.bennaFormDialogVerificaInterna, style: TextStyle(fontWeight: FontWeight.w600, color: primaryBlue)),
                _campoData(l10n.bennaFormDialogUltimaVerificaInterna, _dataUltimaVerificaInterna, (v) {
                  _dataUltimaVerificaInterna = v;
                  // Verifica periodica annuale, come per fasce e catene.
                  if (v != null) {
                    _dataProssimaVerifica = _aggiungiPeriodo(v, mesi: 3);
                  }
                }),
                _campoData(l10n.bennaFormDialogProssimaVerifica, _dataProssimaVerifica,
                    (v) => _dataProssimaVerifica = v),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(l10n.bennaFormDialogEsitoVerificaPositivo),
                  subtitle: Text(
                    _esitoVerifica
                        ? l10n.bennaFormDialogIdoneaUso
                        : l10n.bennaFormDialogNonIdonea,
                    style: TextStyle(
                      fontSize: 12,
                      color: _esitoVerifica ? Colors.black54 : Colors.red,
                    ),
                  ),
                  value: _esitoVerifica,
                  onChanged: (v) => setState(() => _esitoVerifica = v),
                ),
                const Divider(height: 24),
                Text(l10n.bennaFormDialogFoto, style: TextStyle(fontWeight: FontWeight.w600, color: primaryBlue)),
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
                        Center(child: _anteprima(primaryBlue)),
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
                              ? l10n.bennaFormDialogCambiaFoto
                              : l10n.bennaFormDialogSfoglia,
                        ),
                      ),
                      if (_fileBytes != null || _mostraFotoEsistente)
                        TextButton(
                          onPressed: _rimuoviImmagine,
                          child: Text(
                            l10n.bennaFormDialogRimuovi,
                            style: const TextStyle(color: Colors.redAccent),
                          ),
                        ),
                    ],
                  ),
                ),
                const Divider(height: 24),
                TextField(
                  controller: _noteController,
                  decoration: InputDecoration(labelText: l10n.bennaFormDialogNoteAggiuntive),
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
  Widget _anteprima(Color primaryBlue) {
    final l10n = AppLocalizations.of(context)!;
    if (_fileBytes != null) {
      return Image.memory(_fileBytes!, fit: BoxFit.contain);
    }
    if (_mostraFotoEsistente) {
      return Image.network(
        widget.esistente!.getImageUrl(PocketBaseService.instance.pb),
        fit: BoxFit.contain,
        errorBuilder: (_, _, _) => Text(l10n.bennaFormDialogImmagineNonDisponibile),
      );
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.cloud_upload_outlined, color: primaryBlue, size: 28),
        const SizedBox(height: 6),
        Text(l10n.bennaFormDialogTrascinaFoto, textAlign: TextAlign.center),
        Text(
          l10n.bennaFormDialogFormatiAmmessi,
          style: const TextStyle(fontSize: 11, color: Colors.black54),
        ),
      ],
    );
  }
}
