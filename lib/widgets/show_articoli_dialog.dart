import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../l10n/app_localizations.dart';
import '../models/articolo_cassetta_ps.dart';
import '../models/cassetta_ps.dart';
import '../services/stato_scadenze.dart';
import 'stato_badge.dart';

final _dateFormat = DateFormat('dd/MM/yyyy');

Future<void> showArticoliDialog(
  BuildContext context, {
  required List<ArticoloCassettaPs> articoli,
  required CassettaPs cassetta,
}) {
  return showDialog(
    context: context,
    builder: (_) => _ArticoliDialog(articoli: articoli, cassetta: cassetta),
  );
}

class _ArticoliDialog extends StatelessWidget {
  const _ArticoliDialog({required this.articoli, required this.cassetta});

  final List<ArticoloCassettaPs> articoli;
  final CassettaPs cassetta;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final ordinati = [...articoli]..sort((a, b) {
      final scadenzaA = parseData(a.scadenza);
      final scadenzaB = parseData(b.scadenza);
      if (scadenzaA == null && scadenzaB == null) return 0;
      if (scadenzaA == null) return 1;
      if (scadenzaB == null) return -1;
      return scadenzaA.compareTo(scadenzaB);
    });

    return AlertDialog(
      title: Text(l10n.showArticoliDialogTitle(cassetta.tipologia, cassetta.numero)),
      content: SizedBox(
        width: 420,
        child: ordinati.isEmpty
            ? Text(
                l10n.showArticoliDialogEmptyMessage,
                style: const TextStyle(color: Colors.black54),
              )
            : SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (var i = 0; i < ordinati.length; i++) ...[
                      if (i > 0) const Divider(height: 1, color: Color(0xFFE0E0E0)),
                      Builder(
                        builder: (context) {
                          final a = ordinati[i];
                          final scadenza = parseData(a.scadenza);
                          final stato = computeStato(scadenza);
                          final sottotitolo = [
                            if (a.quantita.isNotEmpty) l10n.showArticoliDialogQuantityLine(a.quantita),
                            if (scadenza != null) l10n.showArticoliDialogDeadlineLine(_dateFormat.format(scadenza)),
                            if (a.note.isNotEmpty) l10n.showArticoliDialogNoteLine(a.note),
                            if (a.notaScadenza.isNotEmpty) l10n.showArticoliDialogDeadlineNoteLine(a.notaScadenza),
                          ];
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            dense: true,
                            leading: StatoBadge(stato: stato, showLabel: false),
                            title: Text(a.nomeProdotto),
                            subtitle: sottotitolo.isEmpty ? null : Text(sottotitolo.join(' · ')),
                          );
                        },
                      ),
                    ],
                  ],
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
