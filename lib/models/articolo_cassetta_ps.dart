import 'package:pocketbase/pocketbase.dart';

class ArticoloCassettaPs {
  ArticoloCassettaPs({
    required this.id,
    required this.cassettaId,
    required this.nomeProdotto,
    required this.quantita,
    required this.scadenza,
    required this.note,
    required this.notaScadenza,
  });

  factory ArticoloCassettaPs.fromRecord(RecordModel r) {
    return ArticoloCassettaPs(
      id: r.id,
      cassettaId: r.getStringValue('cassetta'),
      nomeProdotto: r.getStringValue('nome_prodotto'),
      quantita: r.getStringValue('quantita'),
      scadenza: r.getStringValue('scadenza'),
      note: r.getStringValue('note'),
      notaScadenza: r.getStringValue('nota_scadenza'),
    );
  }

  final String id;
  final String cassettaId;
  final String nomeProdotto;
  final String quantita;
  final String scadenza;
  final String note;
  final String notaScadenza;
}
