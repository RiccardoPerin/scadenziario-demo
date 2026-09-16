import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../providers/dipendenti_subappaltatori_provider.dart';

Future<void> showDipendentiPresentiDialog(
  BuildContext context, {
  required DipendentiSubappaltatoriProvider dipendentiProvider,
  required String subappaltatoreId,
  required String subappaltatoreNome,
  required String cantiereId,
}) {
  return showDialog(
    context: context,
    builder: (_) => _DipendentiPresentiDialog(
      dipendentiProvider: dipendentiProvider,
      subappaltatoreId: subappaltatoreId,
      subappaltatoreNome: subappaltatoreNome,
      cantiereId: cantiereId,
    ),
  );
}

class _DipendentiPresentiDialog extends StatefulWidget {
  const _DipendentiPresentiDialog({
    required this.dipendentiProvider,
    required this.subappaltatoreId,
    required this.subappaltatoreNome,
    required this.cantiereId,
  });

  final DipendentiSubappaltatoriProvider dipendentiProvider;
  final String subappaltatoreId;
  final String subappaltatoreNome;
  final String cantiereId;

  @override
  State<_DipendentiPresentiDialog> createState() => _DipendentiPresentiDialogState();
}

class _DipendentiPresentiDialogState extends State<_DipendentiPresentiDialog> {
  bool _isSaving = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final dipendenti = widget.dipendentiProvider.perSubappaltatore(widget.subappaltatoreId);

    return AlertDialog(
      title: Text(l10n.dipendentiPresentiDialogTitle(widget.subappaltatoreNome)),
      content: SizedBox(
        width: 420,
        child: dipendenti.isEmpty
            ? Text(l10n.dipendentiPresentiDialogNessunDipendente)
            : SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: dipendenti.map((d) {
                    final presente = d.cantieriIds.contains(widget.cantiereId);
                    return CheckboxListTile(
                      dense: false,
                      contentPadding: EdgeInsets.zero,
                      title: Text(d.nomeCompleto),
                      subtitle: d.note.isEmpty
                          ? null
                          : Text(l10n.dipendentiPresentiDialogNote(d.note)),
                      value: presente,
                      onChanged: _isSaving
                          ? null
                          : (checked) async {
                              setState(() => _isSaving = true);
                              try {
                                if (checked ?? false) {
                                  await widget.dipendentiProvider
                                      .addCantiere(d.id, widget.cantiereId);
                                } else {
                                  await widget.dipendentiProvider
                                      .removeCantiere(d.id, widget.cantiereId);
                                }
                              } finally {
                                if (mounted) setState(() => _isSaving = false);
                              }
                            },
                    );
                  }).toList(),
                ),
              ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.commonClose),
        ),
      ],
    );
  }
}
