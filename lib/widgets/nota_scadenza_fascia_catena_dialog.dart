import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/fascia_catena.dart';
import '../providers/fasce_catene_provider.dart';

Future<void> showNotaFasciaCatenaDialog(
  BuildContext context, {
  required FasceCateneProvider provider,
  required FasciaCatena fasciaCatena,
}) {
  return showDialog(
    context: context,
    builder: (_) => _NotaFasciaCatenaDialog(
      provider: provider,
      fasciaCatena: fasciaCatena,
    ),
  );
}

class _NotaFasciaCatenaDialog extends StatefulWidget {
  const _NotaFasciaCatenaDialog({
    required this.provider,
    required this.fasciaCatena,
  });

  final FasceCateneProvider provider;
  final FasciaCatena fasciaCatena;

  @override
  State<_NotaFasciaCatenaDialog> createState() => _NotaFasciaCatenaDialogState();
}

class _NotaFasciaCatenaDialogState extends State<_NotaFasciaCatenaDialog> {
  late final _noteController = TextEditingController(
    text: widget.fasciaCatena.notaScadenza,
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
        widget.fasciaCatena.id,
        _noteController.text.trim(),
      );
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
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(l10n.notaScadenzaFasciaCatenaDialogTitle(widget.fasciaCatena.idInterno)),
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
