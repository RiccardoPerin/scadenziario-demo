import 'package:flutter/material.dart';
import 'package:gestionale_edile/providers/estintori_provider.dart';

import '../models/estintore.dart';

Future<void> showNotaEstintoreDialog(
  BuildContext context, {
  required EstintoriProvider provider,
  required Estintore estintore,
  required String tipo,
}) {
  return showDialog(
    context: context,
    builder: (_) => _NotaEstintoreDialog(
      provider: provider,
      estintore: estintore,
      tipo: tipo,
    ),
  );
}

class _NotaEstintoreDialog extends StatefulWidget {
  const _NotaEstintoreDialog({
    required this.provider,
    required this.estintore,
    required this.tipo,
  });

  final EstintoriProvider provider;
  final Estintore estintore;
  final String tipo;

  @override
  State<_NotaEstintoreDialog> createState() => _NotaEstintoreDialogState();
}

class _NotaEstintoreDialogState extends State<_NotaEstintoreDialog> {
  late final _noteController = TextEditingController(
    text: widget.estintore.noteScadenze[widget.tipo] ?? '',
  );
  bool _isSaving = false;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _isSaving = true);
    try {
      await widget.provider.updateNotaScadenza(
        widget.estintore,
        widget.tipo,
        _noteController.text.trim(),
      );
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Errore: $e')));
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Nota — ${widget.estintore.numeroMatricola} — ${widget.tipo}',
      ),
      content: SizedBox(
        width: 400,
        child: TextField(
          controller: _noteController,
          decoration: const InputDecoration(labelText: 'Note'),
          maxLines: 1,
          autofocus: true,
          onSubmitted: (_) => _submit(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSaving ? null : () => Navigator.of(context).pop(),
          child: const Text('Annulla'),
        ),
        FilledButton(
          onPressed: _isSaving ? null : _submit,
          child: _isSaving
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Salva'),
        ),
      ],
    );
  }
}
