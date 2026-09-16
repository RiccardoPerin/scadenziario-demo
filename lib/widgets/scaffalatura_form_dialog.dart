import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/scaffalatura.dart';
import '../providers/scaffalature_provider.dart';
import 'campo_data.dart';

DateTime? _parseData(String value) => value.isEmpty ? null : DateTime.tryParse(value);

DateTime _aggiungiPeriodo(DateTime data, {int anni = 0, int mesi = 0}) {
  return DateTime(data.year + anni, data.month + mesi, data.day);
}

Future<void> showScaffalaturaFormDialog(
  BuildContext context, {
  required ScaffalatureProvider provider,
  required List<Scaffalatura> scaffalature,
  Scaffalatura? esistente,
}) {
  return showDialog(
    context: context,
    builder: (_) => _ScaffalaturaFormDialog(
      provider: provider,
      scaffalature: scaffalature,
      esistente: esistente,
    ),
  );
}

class _ScaffalaturaFormDialog extends StatefulWidget {
  const _ScaffalaturaFormDialog({
    required this.provider,
    required this.scaffalature,
    this.esistente,
  });

  final ScaffalatureProvider provider;
  final List<Scaffalatura> scaffalature;
  final Scaffalatura? esistente;

  @override
  State<_ScaffalaturaFormDialog> createState() => _ScaffalaturaFormDialogState();
}

class _ScaffalaturaFormDialogState extends State<_ScaffalaturaFormDialog> {
  final _formKey = GlobalKey<FormState>();

  late final _idInternoController =
      TextEditingController(text: widget.esistente?.idInterno ?? '');
  late final _noteController =
      TextEditingController(text: widget.esistente?.note ?? '');
  
  bool _esitoPositivo = true;

  DateTime? _dataVerifica;
  DateTime? _dataProssimaVerifica;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final s = widget.esistente;

    _esitoPositivo = s?.esitoPositivo ?? true;

    _dataProssimaVerifica = _parseData(s?.dataProssimaVerifica ?? '');
    _dataVerifica = _parseData(s?.dataVerifica ?? '');
  }

  @override
  void dispose() {
    _idInternoController.dispose();
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

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);
    try {
      if (widget.esistente == null) {
        await widget.provider.create(
          idInterno: _idInternoController.text.trim(),
          esitoPositivo: _esitoPositivo,
          dataVerifica: _dataVerifica,
          dataProssimaVerifica: _dataProssimaVerifica,
          note: _noteController.text.trim(),
        );
      } else {
        await widget.provider.update(
          widget.esistente!.id,
          idInterno: _idInternoController.text.trim(),
          esitoPositivo: _esitoPositivo,
          dataVerifica: _dataVerifica,
          dataProssimaVerifica: _dataProssimaVerifica,
          note: _noteController.text.trim(),
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
      title: Text(widget.esistente == null ? l10n.scaffalaturaFormDialogNewTitle : l10n.scaffalaturaFormDialogEditTitle),
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
                  controller: _idInternoController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: l10n.scaffalaturaFormDialogIdInternoLabel),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return l10n.commonRequiredField;
                    if (int.tryParse(v.trim()) == null) return l10n.scaffalaturaFormDialogInserireNumero;
                    return null;
                  },
                ),
                const Divider(height: 24),
                const SizedBox(height: 12),
                Text(l10n.scaffalaturaFormDialogVerifiche, style: TextStyle(fontWeight: FontWeight.w600, color: primaryBlue)),
                const SizedBox(height: 8),
                _campoData(l10n.scaffalaturaFormDialogDataUltimaVerifica, _dataVerifica, (v) {
                  _dataVerifica = v;
                  if (v!=null) {
                    _dataProssimaVerifica = _aggiungiPeriodo(v, mesi: 6);
                  }
                }),
                SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(l10n.scaffalaturaFormDialogEsitoPositivo),
                    value: _esitoPositivo,
                    onChanged: (v) => setState(() {
                      _esitoPositivo = v;
                    }),
                  ),
                _campoData(l10n.scaffalaturaFormDialogDataProssimaVerifica, _dataProssimaVerifica, (v) {
                  _dataProssimaVerifica = v;
                }),
                const Divider(height: 24),
                TextFormField(
                  controller: _noteController,
                  decoration: InputDecoration(labelText: l10n.commonNoteLabel),
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
