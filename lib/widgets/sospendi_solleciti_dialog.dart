import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../providers/impostazioni_provider.dart';
import 'campo_data.dart';

/// Sospensione dei solleciti sulle voci già scadute, per i periodi di chiusura
/// aziendale: le email di preavviso continuano ad arrivare, si ferma solo la
/// ripetizione quotidiana di ciò che è già scaduto.
Future<void> showSospendiSollecitiDialog(
  BuildContext context, {
  required ImpostazioniProvider provider,
}) {
  return showDialog(
    context: context,
    builder: (_) => _SospendiSollecitiDialog(provider: provider),
  );
}

class _SospendiSollecitiDialog extends StatefulWidget {
  const _SospendiSollecitiDialog({required this.provider});

  final ImpostazioniProvider provider;

  @override
  State<_SospendiSollecitiDialog> createState() => _SospendiSollecitiDialogState();
}

class _SospendiSollecitiDialogState extends State<_SospendiSollecitiDialog> {
  late DateTime? _fino = widget.provider.sospensioneScadutiFino;
  bool _isSaving = false;

  DateTime get _oggi {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  bool get _dataValida => _fino != null && !_fino!.isBefore(_oggi);

  Future<void> _salva(DateTime? fino) async {
    setState(() => _isSaving = true);
    try {
      await widget.provider.sospendiSollecitiFino(fino);
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
    final sospesi = widget.provider.sollecitiSospesi;
    final impostataDa = widget.provider.sospensioneImpostataDa;
    final annoCorrente = DateTime.now().year;

    return AlertDialog(
      title: Text(l10n.sospendiSollecitiDialogTitle),
      content: SizedBox(
        width: 460,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.sospendiSollecitiDialogDescription1,
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.sospendiSollecitiDialogDescription2,
              style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
            ),
            const SizedBox(height: 20),
            CampoData(
              label: l10n.sospendiSollecitiDialogUntilLabel,
              valore: _fino,
              primoAnno: annoCorrente,
              ultimoAnno: annoCorrente + 1,
              onChanged: (data) => setState(() => _fino = data),
            ),
            if (_fino != null && !_dataValida) ...[
              const SizedBox(height: 8),
              Text(
                l10n.sospendiSollecitiDialogInvalidDateMessage,
                style: const TextStyle(fontSize: 13, color: Colors.redAccent),
              ),
            ],
            if (sospesi && impostataDa.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                l10n.sospendiSollecitiDialogSetByMessage(impostataDa),
                style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSaving ? null : () => Navigator.of(context).pop(),
          child: Text(l10n.commonCancel),
        ),
        if (sospesi)
          TextButton(
            onPressed: _isSaving ? null : () => _salva(null),
            child: Text(l10n.sospendiSollecitiDialogReactivateNowLabel, style: const TextStyle(color: Colors.redAccent)),
          ),
        FilledButton(
          onPressed: _isSaving || !_dataValida ? null : () => _salva(_fino),
          child: _isSaving
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(sospesi ? l10n.sospendiSollecitiDialogUpdateLabel : l10n.sospendiSollecitiDialogSuspendLabel),
        ),
      ],
    );
  }
}
