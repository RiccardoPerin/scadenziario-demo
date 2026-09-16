import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/dipendente_aziendale.dart';
import '../providers/dipendenti_aziendali_provider.dart';

/// Dialog per la nota del dipendente: se [tipo] è valorizzato si modifica la
/// nota della singola scadenza, altrimenti la nota generale del dipendente.
Future<void> showNotaDipendenteAziendaleDialog(
  BuildContext context, {
  required DipendentiAziendaliProvider provider,
  required DipendenteAziendale dipendente,
  String? tipo,
}) {
  return showDialog(
    context: context,
    builder: (_) => _NotaDipendentiAziendaliDialog(
      provider: provider,
      dipendente: dipendente,
      tipo: tipo,
    ),
  );
}

class _NotaDipendentiAziendaliDialog extends StatefulWidget {
  const _NotaDipendentiAziendaliDialog({
    required this.provider,
    required this.dipendente,
    this.tipo,
  });

  final DipendentiAziendaliProvider provider;
  final DipendenteAziendale dipendente;
  final String? tipo;

  @override
  State<_NotaDipendentiAziendaliDialog> createState() =>
      _NotaDipendentiAziendaliDialogState();
}

class _NotaDipendentiAziendaliDialogState
    extends State<_NotaDipendentiAziendaliDialog> {
  late final _noteController = TextEditingController(
    text: widget.tipo == null
        ? widget.dipendente.note
        : widget.dipendente.noteScadenze[widget.tipo] ?? '',
  );
  bool _isSaving = false;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context)!;
    setState(() => _isSaving = true);
    try {
      final tipo = widget.tipo;
      if (tipo == null) {
        await widget.provider.updateNote(
          widget.dipendente.id,
          _noteController.text.trim(),
        );
      } else {
        await widget.provider.updateNotaScadenza(
          widget.dipendente,
          tipo,
          _noteController.text.trim(),
        );
      }
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
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
    return AlertDialog(
      title: Text(
        widget.tipo == null
            ? l10n.notaDipendenteAziendaleDialogTitle(
                widget.dipendente.nome, widget.dipendente.cognome)
            : l10n.notaDipendenteAziendaleDialogTitleConTipo(
                widget.dipendente.nome, widget.dipendente.cognome, widget.tipo!),
      ),
      content: SizedBox(
        width: 400,
        child: TextField(
          controller: _noteController,
          decoration: InputDecoration(labelText: l10n.commonNoteLabel),
          maxLines: 1,
          autofocus: true,
          onSubmitted: (_) => _submit(),
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
