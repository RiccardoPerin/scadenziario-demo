import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';

/// Dialog generico per una nota testuale su singola riga, usato sia per il
/// commento libero di una scadenza cantiere (dalla pagina di dettaglio) sia
/// per la nota "prenotato" che blocca l'email (dalla sezione "Scadenze
/// imminenti"): le due note vivono in campi diversi, quindi chi apre il
/// dialog decide valore iniziale e salvataggio.
Future<void> showNotaCantiereDialog(
  BuildContext context, {
  required String titolo,
  required String valoreIniziale,
  required Future<void> Function(String) onSalva,
}) {
  return showDialog(
    context: context,
    builder: (_) => _NotaCantiereDialog(
      titolo: titolo,
      valoreIniziale: valoreIniziale,
      onSalva: onSalva,
    ),
  );
}

class _NotaCantiereDialog extends StatefulWidget {
  const _NotaCantiereDialog({
    required this.titolo,
    required this.valoreIniziale,
    required this.onSalva,
  });

  final String titolo;
  final String valoreIniziale;
  final Future<void> Function(String) onSalva;

  @override
  State<_NotaCantiereDialog> createState() => _NotaCantiereDialogState();
}

class _NotaCantiereDialogState extends State<_NotaCantiereDialog> {
  late final _noteController = TextEditingController(text: widget.valoreIniziale);
  bool _isSaving = false;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _isSaving = true);
    try {
      await widget.onSalva(_noteController.text.trim());
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
    return AlertDialog(
      title: Text(widget.titolo),
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
