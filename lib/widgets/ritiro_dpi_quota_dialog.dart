import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/dpi_assegnato.dart';
import '../providers/dpi_assegnati_provider.dart';
import 'campo_data.dart';
import 'confirm_dialog.dart';

/// Colore del ritiro temporaneo: volutamente fuori dalla scala verde/arancio/
/// rosso delle scadenze, perché "ritirato" non è uno stato di scadenza ma una
/// parentesi in cui il DPI non è in mano al dipendente.
final coloreRitiroQuota = Colors.grey.shade700;

/// Ritira o riconsegna un DPI per lavori in quota. Il ritiro azzera solo la
/// data di consegna (il DPI resta assegnato, con matricola, produttore e
/// scadenza), così alla riconsegna basta reinserire quella data.
Future<void> showRitiroDpiQuotaDialog(
  BuildContext context, {
  required DpiAssegnatiProvider provider,
  required DpiAssegnato assegnato,
  required String nomeTipo,
  required String nomeDipendente,
}) async {
  if (assegnato.ritiratoDPIQuota) {
    return showDialog(
      context: context,
      builder: (_) => _RiconsegnaDpiQuotaDialog(
        provider: provider,
        assegnato: assegnato,
        nomeTipo: nomeTipo,
        nomeDipendente: nomeDipendente,
      ),
    );
  }

  final l10n = AppLocalizations.of(context)!;
  final confermato = await showConfirmDialog(
    context,
    title: l10n.ritiroDpiQuotaDialogConfirmTitle,
    message: l10n.ritiroDpiQuotaDialogConfirmMessage(nomeTipo, nomeDipendente),
    confirmLabel: l10n.ritiroDpiQuotaDialogConfirmButton,
    confirmColor: Theme.of(context).primaryColor,
    width: 500,
  );
  if (!confermato) return;
  await provider.updateRitiroQuota(assegnato.id, ritirato: true);
}

class _RiconsegnaDpiQuotaDialog extends StatefulWidget {
  const _RiconsegnaDpiQuotaDialog({
    required this.provider,
    required this.assegnato,
    required this.nomeTipo,
    required this.nomeDipendente,
  });

  final DpiAssegnatiProvider provider;
  final DpiAssegnato assegnato;
  final String nomeTipo;
  final String nomeDipendente;

  @override
  State<_RiconsegnaDpiQuotaDialog> createState() => _RiconsegnaDpiQuotaDialogState();
}

class _RiconsegnaDpiQuotaDialogState extends State<_RiconsegnaDpiQuotaDialog> {
  final _formKey = GlobalKey<FormState>();

  DateTime? _dataConsegna = DateTime.now();
  bool _isSaving = false;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);
    try {
      await widget.provider.updateRitiroQuota(
        widget.assegnato.id,
        ritirato: false,
        dataConsegna: _dataConsegna,
      );
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
      title: Text(l10n.ritiroDpiQuotaDialogRiconsegnaTitle(widget.nomeTipo)),
      content: Form(
        key: _formKey,
        child: SizedBox(
          width: 500,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.ritiroDpiQuotaDialogRiconsegnaMessage(widget.nomeDipendente)),
              const SizedBox(height: 12),
              CampoData(
                label: l10n.ritiroDpiQuotaDialogDataConsegnaLabel,
                valore: _dataConsegna,
                onChanged: (v) => setState(() => _dataConsegna = v),
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
          onPressed: _isSaving || _dataConsegna == null ? null : _submit,
          child: _isSaving
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(l10n.ritiroDpiQuotaDialogRiconsegnaButton),
        ),
      ],
    );
  }
}
