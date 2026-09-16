import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/articolo_standard_cassetta_ps.dart';
import '../providers/articoli_standard_cassette_ps_provider.dart';

const _tipologieKeys = ['Cassetta', 'Pacchetto di Medicazione'];

/// Etichetta leggibile per la [tipologia] (la chiave resta in italiano
/// perché usata anche come valore salvato su [ArticoloStandardCassettaPs]).
String _tipologiaLabel(AppLocalizations l10n, String tipologia) {
  switch (tipologia) {
    case 'Cassetta':
      return l10n.articoloStandardCassettaPsFormDialogTipoCassetta;
    case 'Pacchetto di Medicazione':
      return l10n.articoloStandardCassettaPsFormDialogTipoPacchettoMedicazione;
    default:
      return tipologia;
  }
}

Future<void> showArticoloStandardCassettaPsFormDialog(
  BuildContext context, {
  required ArticoliStandardCassettePsProvider provider,
  String? tipologiaIniziale,
  ArticoloStandardCassettaPs? esistente,
}) {
  return showDialog(
    context: context,
    builder: (_) => _ArticoloStandardFormDialog(
      provider: provider,
      tipologiaIniziale: tipologiaIniziale,
      esistente: esistente,
    ),
  );
}

class _ArticoloStandardFormDialog extends StatefulWidget {
  const _ArticoloStandardFormDialog({
    required this.provider,
    this.tipologiaIniziale,
    this.esistente,
  });

  final ArticoliStandardCassettePsProvider provider;
  final String? tipologiaIniziale;
  final ArticoloStandardCassettaPs? esistente;

  @override
  State<_ArticoloStandardFormDialog> createState() =>
      _ArticoloStandardFormDialogState();
}

class _ArticoloStandardFormDialogState
    extends State<_ArticoloStandardFormDialog> {
  final _formKey = GlobalKey<FormState>();

  late final _nomeController =
      TextEditingController(text: widget.esistente?.nomeProdotto ?? '');
  late final _quantitaController =
      TextEditingController(text: widget.esistente?.quantita ?? '');

  late String _tipologia = widget.esistente?.tipologia ??
      widget.tipologiaIniziale ??
      _tipologieKeys.first;

  bool _isSaving = false;

  @override
  void dispose() {
    _nomeController.dispose();
    _quantitaController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);
    try {
      if (widget.esistente == null) {
        await widget.provider.create(
          nomeProdotto: _nomeController.text.trim(),
          tipologia: _tipologia,
          quantita: _quantitaController.text.trim(),
        );
      } else {
        await widget.provider.update(
          widget.esistente!.id,
          nomeProdotto: _nomeController.text.trim(),
          tipologia: _tipologia,
          quantita: _quantitaController.text.trim(),
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
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(
        widget.esistente == null
            ? l10n.articoloStandardCassettaPsFormDialogNewTitle
            : l10n.articoloStandardCassettaPsFormDialogEditTitle,
      ),
      content: Form(
        key: _formKey,
        child: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonFormField<String>(
                initialValue: _tipologia,
                decoration: InputDecoration(labelText: l10n.articoloStandardCassettaPsFormDialogTypeLabel),
                borderRadius: BorderRadius.circular(15),
                items: _tipologieKeys
                    .map((tipologia) => DropdownMenuItem(value: tipologia, child: Text(_tipologiaLabel(l10n, tipologia))))
                    .toList(),
                onChanged: (v) => setState(() => _tipologia = v ?? _tipologia),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nomeController,
                decoration: InputDecoration(labelText: l10n.articoloStandardCassettaPsFormDialogProductNameLabel),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? l10n.commonRequiredField : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _quantitaController,
                decoration: InputDecoration(labelText: l10n.articoloStandardCassettaPsFormDialogQuantityLabel),
              ),
            ],
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
