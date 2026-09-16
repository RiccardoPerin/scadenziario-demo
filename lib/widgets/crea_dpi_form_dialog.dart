import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/tipo_dpi.dart';
import '../providers/tipi_dpi_provider.dart';

Future<void> showTipoDpiFormDialog(
  BuildContext context, {
  required TipiDpiProvider provider,
  required List<TipoDpi> tipiDpi,
  TipoDpi? esistente,
}) {
  return showDialog(
    context: context,
    builder: (_) => _TipoDpiFormDialog(
      provider: provider,
      tipiDpi: tipiDpi,
      esistente: esistente,
    ),
  );
}

class _TipoDpiFormDialog extends StatefulWidget {
  const _TipoDpiFormDialog({
    required this.provider,
    required this.tipiDpi,
    this.esistente,
  });

  final TipiDpiProvider provider;
  final List<TipoDpi> tipiDpi;
  final TipoDpi? esistente;

  @override
  State<_TipoDpiFormDialog> createState() => _TipoDpiFormDialogState();
}

class _TipoDpiFormDialogState extends State<_TipoDpiFormDialog> {
  final _formKey = GlobalKey<FormState>();

  late final _nomeController =
      TextEditingController(text: widget.esistente?.nome ?? '');
  late final _noteController =
      TextEditingController(text: widget.esistente?.note ?? '');
  late final _giorniPreavvisoController = TextEditingController(
    text: widget.esistente?.giorniPreavviso.join(', ') ?? '30, 15, 7, 1');

  late bool _lavoriInQuota = widget.esistente?.lavoriInQuota ?? false;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
  }


  @override
  void dispose() {
    _nomeController.dispose();
    _giorniPreavvisoController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  List<int> _parseGiorniPreavviso() {
    return _giorniPreavvisoController.text
        .split(',')
        .map((s) => int.tryParse(s.trim()))
        .whereType<int>()
        .toList();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);
    try {
      final nome = _nomeController.text.trim();
      final giorniPreavviso =  _parseGiorniPreavviso();
      final note = _noteController.text.trim();

      if (widget.esistente == null) {
        await widget.provider.create(
          nome: nome,
          giorniPreavviso: giorniPreavviso,
          note: note,
          lavoriInQuota: _lavoriInQuota,
        );
      } else {
        await widget.provider.update(
          widget.esistente!.id,
          nome: nome,
          giorniPreavviso: giorniPreavviso,
          note: note,
          lavoriInQuota: _lavoriInQuota,
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
    return AlertDialog(
      title: Text(widget.esistente == null ? l10n.creaDpiFormDialogTitleNew : l10n.creaDpiFormDialogTitleEdit),
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
                  controller: _nomeController,
                  decoration: InputDecoration(labelText: l10n.creaDpiFormDialogNameLabel),
                  validator: (v) => (v == null || v.trim().isEmpty) ? l10n.commonRequiredField : null,
                ),
                TextFormField(
                  controller: _giorniPreavvisoController,
                  decoration: InputDecoration(
                    labelText: l10n.creaDpiFormDialogNoticeDaysLabel,
                    hint: Text(l10n.creaDpiFormDialogNoticeDaysHint),
                  ),
                ),
                TextField(
                  controller: _noteController,
                  decoration: InputDecoration(labelText: l10n.creaDpiFormDialogAdditionalNotesLabel)
                ),
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.leading,
                  value: _lavoriInQuota,
                  title: Text(l10n.creaDpiFormDialogHeightWorkRequired),
                  subtitle: Text(
                    l10n.creaDpiFormDialogHeightWorkSubtitle,
                    style: const TextStyle(fontSize: 12),
                  ),
                  onChanged: (v) => setState(() => _lavoriInQuota = v ?? false),
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
}

