import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../models/cantiere.dart';
import '../models/subappaltatore.dart';
import '../providers/dipendenti_subappaltatori_provider.dart';
import '../providers/subappaltatori_provider.dart';

Future<void> showSubappaltatoreFormDialog(
  BuildContext context, {
  required SubappaltatoriProvider provider,
  required List<Cantiere> tuttiCantieri,
  Subappaltatore? esistente,
  String? cantierePreselezionato,
}) {
  return showDialog(
    context: context,
    builder: (_) => _SubappaltatoreFormDialog(
      provider: provider,
      tuttiCantieri: tuttiCantieri,
      esistente: esistente,
      cantierePreselezionato: cantierePreselezionato,
    ),
  );
}

class _SubappaltatoreFormDialog extends StatefulWidget {
  const _SubappaltatoreFormDialog({
    required this.provider,
    required this.tuttiCantieri,
    this.esistente,
    this.cantierePreselezionato,
  });

  final SubappaltatoriProvider provider;
  final List<Cantiere> tuttiCantieri;
  final Subappaltatore? esistente;
  final String? cantierePreselezionato;

  @override
  State<_SubappaltatoreFormDialog> createState() => _SubappaltatoreFormDialogState();
}

class _SubappaltatoreFormDialogState extends State<_SubappaltatoreFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final _ragioneSocialeController =
      TextEditingController(text: widget.esistente?.ragioneSociale ?? '');
  late final _partitaIvaController =
      TextEditingController(text: widget.esistente?.partitaIva ?? '');
  late final _telefonoController =
      TextEditingController(text: widget.esistente?.telefono ?? '');
  late final _emailController =
      TextEditingController(text: widget.esistente?.email ?? '');
  late final _noteController =
      TextEditingController(text: widget.esistente?.note ?? '');
  late final Set<String> _cantieriSelezionati = {
    ...?widget.esistente?.cantieriIds,
    if (widget.cantierePreselezionato != null) widget.cantierePreselezionato!,
  };

  /// Un cantiere concluso non è più collegabile: non compare tra le caselle
  /// selezionabili, ma il collegamento già esistente resta salvato (così il
  /// subappaltatore continua a comparire nella card del cantiere concluso).
  late final List<Cantiere> _cantieriCollegabili =
      widget.tuttiCantieri.where((c) => c.stato != 'concluso').toList();

  bool _isSaving = false;

  @override
  void dispose() {
    _ragioneSocialeController.dispose();
    _partitaIvaController.dispose();
    _telefonoController.dispose();
    _emailController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _selezionaEsistente(Subappaltatore s) async {
    final cantiereId = widget.cantierePreselezionato;
    if (cantiereId == null) return;
    if (s.cantieriIds.contains(cantiereId)) {
      if (mounted) Navigator.of(context).pop();
      return;
    }
    setState(() => _isSaving = true);
    try {
      await widget.provider.addCantiereToSubappaltatore(s.id, cantiereId);
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

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);
    try {
      if (widget.esistente == null) {
        await widget.provider.create(
          ragioneSociale: _ragioneSocialeController.text.trim(),
          partitaIva: _partitaIvaController.text.trim(),
          telefono: _telefonoController.text.trim(),
          email: _emailController.text.trim(),
          note: _noteController.text.trim(),
          cantieriIds: _cantieriSelezionati.toList(),
        );
      } else {
        final cantieriRimossi = widget.esistente!.cantieriIds
            .where((id) => !_cantieriSelezionati.contains(id))
            .toSet();
        await widget.provider.update(
          widget.esistente!.id,
          ragioneSociale: _ragioneSocialeController.text.trim(),
          partitaIva: _partitaIvaController.text.trim(),
          telefono: _telefonoController.text.trim(),
          email: _emailController.text.trim(),
          note: _noteController.text.trim(),
          cantieriIds: _cantieriSelezionati.toList(),
        );
        if (cantieriRimossi.isNotEmpty && mounted) {
          await context
              .read<DipendentiSubappaltatoriProvider>()
              .rimuoviCantieriDaiDipendentiDiSubappaltatore(
                widget.esistente!.id,
                cantieriRimossi,
              );
        }
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
      title: Text(
        widget.esistente == null ? l10n.subappaltatoreFormDialogNewTitle : l10n.subappaltatoreFormDialogEditTitle,
      ),
      content: Form(
        key: _formKey,
        child: SizedBox(
          width: 440,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.esistente == null && widget.cantierePreselezionato != null) ...[
                  Autocomplete<Subappaltatore>(
                    displayStringForOption: (s) => s.ragioneSociale,
                    optionsBuilder: (textEditingValue) {
                      final query = textEditingValue.text.trim().toLowerCase();
                      if (query.isEmpty) return const Iterable<Subappaltatore>.empty();
                      return widget.provider.subappaltatori
                          .where((s) => s.ragioneSociale.toLowerCase().contains(query));
                    },
                    onSelected: _selezionaEsistente,
                    fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                      return TextFormField(
                        controller: controller,
                        focusNode: focusNode,
                        decoration: InputDecoration(
                          labelText: l10n.subappaltatoreFormDialogCercaEsistenti,
                          prefixIcon: const Icon(Icons.search),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.subappaltatoreFormDialogSelezionaEsistenteInfo,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: Colors.black54),
                  ),
                  const Divider(height: 24),
                ],
                Text(l10n.subappaltatoreFormDialogAnagrafica,
                    style: TextStyle(fontWeight: FontWeight.w600, color: primaryBlue)),
                TextFormField(
                  controller: _ragioneSocialeController,
                  decoration: InputDecoration(labelText: l10n.subappaltatoreFormDialogRagioneSocialeLabel),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? l10n.commonRequiredField : null,
                ),
                TextFormField(
                  controller: _partitaIvaController,
                  decoration: InputDecoration(labelText: l10n.subappaltatoreFormDialogPartitaIvaLabel),
                ),
                TextFormField(
                  controller: _telefonoController,
                  decoration: InputDecoration(labelText: l10n.subappaltatoreFormDialogTelefonoLabel),
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: l10n.subappaltatoreFormDialogEmailLabel),
                  validator: (v) {
                    final email = v?.trim() ?? '';
                    if (email.isEmpty) return null;
                    return email.contains('@') ? null : l10n.subappaltatoreFormDialogEmailInvalida;
                  },
                ),
                TextFormField(
                  controller: _noteController,
                  decoration: InputDecoration(
                    labelText: l10n.commonNoteLabel,
                    helperText: l10n.subappaltatoreFormDialogNoteHelper,
                    helperMaxLines: 2,
                  ),
                  minLines: 1,
                  maxLines: 3,
                ),
                const Divider(height: 24),
                Text(l10n.subappaltatoreFormDialogCantieriAssociati,
                    style: TextStyle(fontWeight: FontWeight.w600, color: primaryBlue)),
                const SizedBox(height: 4),
                ..._cantieriCollegabili.map((c) {
                  final selezionato = _cantieriSelezionati.contains(c.id);
                  return CheckboxListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      c.nome,
                      style: TextStyle(
                        fontWeight: selezionato ? FontWeight.w600 : FontWeight.w500,
                      ),
                    ),
                    value: selezionato,
                    onChanged: (checked) {
                      setState(() {
                        if (checked ?? false) {
                          _cantieriSelezionati.add(c.id);
                        } else {
                          _cantieriSelezionati.remove(c.id);
                        }
                      });
                    },
                  );
                }),
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
