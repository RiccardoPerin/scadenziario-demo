import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../services/stato_scadenze.dart';
import 'stato_badge.dart';

final _dateFormat = DateFormat('dd/MM/yyyy');

/// Formatta una data grezza (come arriva da PocketBase) in gg/mm/aaaa, oppure
/// '-' se il campo è vuoto o non interpretabile.
String formatData(String valore) {
  final data = parseData(valore);
  return data == null ? '-' : _dateFormat.format(data);
}

/// Rosso se lo stato è scaduto, ambra se è in scadenza, altrimenti `null`
/// (colore di default del testo).
Color? coloreStato(StatoScadenza stato) {
  switch (stato) {
    case StatoScadenza.scaduto:
      return Colors.red;
    case StatoScadenza.inScadenza:
      return Colors.amber[800];
    case StatoScadenza.valido:
      return null;
  }
}

/// Colore di una data di scadenza grezza in base al suo stato.
/// [giorniPreavviso] sono le soglie del tipo, per le scadenze che ne hanno di
/// proprie (documenti, DPI); se vuote vale la soglia di default di 30 giorni.
Color? coloreScadenza(
  String valoreGrezzo, {
  List<int> giorniPreavviso = const [],
}) {
  final data = parseData(valoreGrezzo);
  if (data == null) return null;
  return coloreStato(computeStato(data, giorniPreavviso: giorniPreavviso));
}

/// Etichetta + valore, come colonna di una riga di dettaglio di una card.
/// [sotto] è una precisazione facoltativa mostrata su una riga a sé sotto al
/// valore (es. "Cricchetto" per i nastri di ancoraggio che ne sono dotati).
Widget campoInfo(String label, String valore, {Color? colore, String? sotto}) {
  return Expanded(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          valore.isEmpty ? '-' : valore,
          style: colore == null
              ? null
              : TextStyle(color: colore, fontWeight: FontWeight.w600),
        ),
        if (sotto != null && sotto.isNotEmpty)
          Text(
            sotto,
            style: colore == null
              ? null
              : TextStyle(color: colore, fontWeight: FontWeight.w600),
          ),
      ],
    ),
  );
}

/// Come [campoInfo], ma per una data di scadenza: la formatta e la colora in
/// base allo stato (rosso se scaduta, ambra se in scadenza). Da usare solo
/// per le date che rappresentano davvero una scadenza: quelle che registrano
/// quando un intervento è stato svolto vanno mostrate con [campoInfo].
Widget campoScadenza(
  String label,
  String valoreGrezzo, {
  List<int> giorniPreavviso = const [],
}) {
  return campoInfo(
    label,
    formatData(valoreGrezzo),
    colore: coloreScadenza(valoreGrezzo, giorniPreavviso: giorniPreavviso),
  );
}
