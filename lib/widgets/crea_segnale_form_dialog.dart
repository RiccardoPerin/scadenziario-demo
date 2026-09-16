import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';

import '../l10n/app_localizations.dart';
import '../models/segnale.dart';
import '../providers/segnali_provider.dart';
import '../services/pocketbase_service.dart';

const _estensioniAmmesse = ['jpg', 'jpeg', 'png', 'webp'];

/// Deve combaciare con il "maxSize" del campo file "cartello" della collection
/// "segnaletica": lasciato a 0 nella migration, PocketBase applica il suo
/// default di 5 MB. Senza questo controllo lato client un file più grande
/// verrebbe respinto dal server con un errore generico invece del messaggio
/// "Immagine troppo grande".
const _dimensioneMassimaBytes = 5242880;

/// Valori del campo select "zona" su PocketBase: vanno inviati esattamente così.
const _zone = ['ufficio', 'magazzino'];

String _estensioneDi(String nomeFile) {
  final punto = nomeFile.lastIndexOf('.');
  return punto == -1 ? '' : nomeFile.substring(punto + 1).toLowerCase();
}

/// Form di creazione/modifica di un segnale della segnaletica.
/// Passando [esistente] il dialog lavora in modifica.
Future<void> showSegnaleFormDialog(
  BuildContext context, {
  required SegnaliProvider provider,
  Segnale? esistente,
}) {
  return showDialog(
    context: context,
    builder: (_) => _SegnaleFormDialog(provider: provider, esistente: esistente),
  );
}

class _SegnaleFormDialog extends StatefulWidget {
  const _SegnaleFormDialog({required this.provider, this.esistente});

  final SegnaliProvider provider;
  final Segnale? esistente;

  @override
  State<_SegnaleFormDialog> createState() => _SegnaleFormDialogState();
}

class _SegnaleFormDialogState extends State<_SegnaleFormDialog> {
  final _formKey = GlobalKey<FormState>();

  late final _nomeController = TextEditingController(
    text: widget.esistente?.nome ?? '',
  );
  late final _ubicazioneController = TextEditingController(
    text: widget.esistente?.ubicazione ?? '',
  );
  late final _noteController = TextEditingController(
    text: widget.esistente?.note ?? '',
  );

  late String? _zona = _zone.contains(widget.esistente?.zona)
      ? widget.esistente!.zona
      : null;

  DropzoneViewController? _dropzoneController;
  Uint8List? _fileBytes;
  String? _fileNome;
  bool _dragHover = false;
  String? _erroreFile;
  bool _isSaving = false;

  /// In modifica: true quando si è tolta l'immagine già caricata senza
  /// sostituirla, così il salvataggio la cancella anche sul server.
  bool _rimuoviCartello = false;

  bool get _isModifica => widget.esistente != null;

  /// Immagine già su PocketBase ancora valida (non rimossa né sostituita).
  bool get _mostraCartelloEsistente =>
      _fileBytes == null &&
      !_rimuoviCartello &&
      (widget.esistente?.haCartello ?? false);

  @override
  void dispose() {
    _nomeController.dispose();
    _ubicazioneController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _gestisciFile(DropzoneFileInterface file) async {
    final l10n = AppLocalizations.of(context)!;
    final estensione = _estensioneDi(file.name);
    if (!_estensioniAmmesse.contains(estensione)) {
      setState(() {
        _erroreFile = l10n.creaSegnaleFormDialogExtensionNotAllowed(estensione);
        _fileBytes = null;
        _fileNome = null;
      });
      return;
    }
    if (file.size > _dimensioneMassimaBytes) {
      setState(() {
        _erroreFile = l10n.creaSegnaleFormDialogFileTooLarge;
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
      _rimuoviCartello = false;
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
      _rimuoviCartello = true;
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    try {
      if (_isModifica) {
        await widget.provider.update(
          widget.esistente!.id,
          nome: _nomeController.text.trim(),
          ubicazione: _ubicazioneController.text.trim(),
          zona: _zona,
          note: _noteController.text.trim(),
          cartelloBytes: _fileBytes,
          cartelloFileName: _fileNome,
          rimuoviCartello: _rimuoviCartello,
        );
      } else {
        await widget.provider.create(
          nome: _nomeController.text.trim(),
          ubicazione: _ubicazioneController.text.trim(),
          zona: _zona,
          note: _noteController.text.trim(),
          cartelloBytes: _fileBytes,
          cartelloFileName: _fileNome,
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
    final primaryBlue = Theme.of(context).primaryColor;
    final l10n = AppLocalizations.of(context)!;

    return AlertDialog(
      title: Text(_isModifica ? l10n.creaSegnaleFormDialogTitleEdit : l10n.creaSegnaleFormDialogTitleNew),
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
                  decoration: InputDecoration(labelText: l10n.creaSegnaleFormDialogNameLabel),
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? l10n.commonRequiredField
                      : null,
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String?>(
                  initialValue: _zona,
                  borderRadius: BorderRadius.circular(15),
                  isExpanded: true,
                  decoration: InputDecoration(labelText: l10n.creaSegnaleFormDialogZoneLabel),
                  items: [
                    DropdownMenuItem(
                      value: null,
                      child: Text(l10n.creaSegnaleFormDialogZoneUnspecified),
                    ),
                    ..._zone.map(
                      (z) => DropdownMenuItem(
                        value: z,
                        child: Text(
                          z == 'ufficio'
                              ? l10n.creaSegnaleFormDialogZoneOffice
                              : l10n.creaSegnaleFormDialogZoneWarehouse,
                        ),
                      ),
                    ),
                  ],
                  onChanged: (v) => setState(() => _zona = v),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _ubicazioneController,
                  decoration: InputDecoration(
                    labelText: l10n.creaSegnaleFormDialogLocationLabel,
                    hintText: l10n.creaSegnaleFormDialogLocationHint,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _noteController,
                  decoration: InputDecoration(labelText: l10n.commonNoteLabel),
                  maxLines: 2,
                ),
                const SizedBox(height: 12),
                Text(
                  l10n.creaSegnaleFormDialogImageSectionTitle,
                  style: TextStyle(
                    color: primaryBlue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 150,
                  decoration: BoxDecoration(
                    color: _dragHover
                        ? primaryBlue.withValues(alpha: 0.06)
                        : null,
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
                          onCreated: (controller) =>
                              _dropzoneController = controller,
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
                          _fileBytes != null || _mostraCartelloEsistente
                              ? l10n.creaSegnaleFormDialogChangeImage
                              : l10n.creaSegnaleFormDialogBrowse,
                        ),
                      ),
                      if (_fileBytes != null || _mostraCartelloEsistente)
                        TextButton(
                          onPressed: _rimuoviImmagine,
                          child: Text(
                            l10n.creaSegnaleFormDialogRemoveImage,
                            style: const TextStyle(color: Colors.redAccent),
                          ),
                        ),
                    ],
                  ),
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

  /// Anteprima dell'immagine appena scelta o di quella già salvata; se non c'è
  /// nulla mostra l'invito a trascinare il file.
  Widget _anteprima(Color primaryBlue) {
    final l10n = AppLocalizations.of(context)!;
    if (_fileBytes != null) {
      return Image.memory(_fileBytes!, fit: BoxFit.contain);
    }
    if (_mostraCartelloEsistente) {
      return Image.network(
        widget.esistente!.getImageUrl(PocketBaseService.instance.pb),
        fit: BoxFit.contain,
        errorBuilder: (_, _, _) => Text(l10n.creaSegnaleFormDialogImageUnavailable),
      );
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.cloud_upload_outlined, color: primaryBlue, size: 28),
        const SizedBox(height: 6),
        Text(
          l10n.creaSegnaleFormDialogDragDropText,
          textAlign: TextAlign.center,
        ),
        Text(
          l10n.creaSegnaleFormDialogFileTypesHint,
          style: const TextStyle(fontSize: 11, color: Colors.black54),
        ),
      ],
    );
  }
}
