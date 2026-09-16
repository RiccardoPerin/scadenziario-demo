import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/impianto.dart';
import '../providers/impianti_provider.dart';

/// Etichetta visualizzata per un tipo di scadenza. La chiave interna (`tipo`)
/// resta in italiano perché è usata come chiave di archiviazione delle note
/// (vedi `noteScadenze`/`updateNotaScadenza` in impianti_screen.dart), quindi
/// qui si traduce solo il testo mostrato all'utente.
String _tipoScadenzaLabel(String tipo, AppLocalizations l10n) {
  switch (tipo) {
    case 'Scadenza Manutenzione Interna':
      return l10n.impiantiScreenInternalMaintenanceDeadlineType;
    case 'Scadenza Manutenzione Esterna':
      return l10n.impiantiScreenExternalMaintenanceDeadlineType;
    default:
      return tipo;
  }
}

Future<void> showNotaImpiantoDialog(
  BuildContext context, {
  required ImpiantiProvider provider,
  required Impianto impianto,
  required String tipo,
}) {
  return showDialog(
    context: context,
    builder: (_) => _NotaImpiantoDialog(
      provider: provider,
      impianto: impianto,
      tipo: tipo,
    ),
  );
}

class _NotaImpiantoDialog extends StatefulWidget {
  const _NotaImpiantoDialog({
    required this.provider,
    required this.impianto,
    required this.tipo,
  });

  final ImpiantiProvider provider;
  final Impianto impianto;
  final String tipo;

  @override
  State<_NotaImpiantoDialog> createState() => _NotaImpiantoDialogState();
}

class _NotaImpiantoDialogState extends State<_NotaImpiantoDialog> {
  late final _noteController = TextEditingController(
    text: widget.impianto.noteScadenze[widget.tipo] ?? '',
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
        widget.impianto,
        widget.tipo,
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
      title: Text(l10n.notaImpiantoDialogTitle(widget.impianto.tipologia, _tipoScadenzaLabel(widget.tipo, l10n))),
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
