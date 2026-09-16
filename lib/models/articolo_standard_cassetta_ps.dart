import 'package:pocketbase/pocketbase.dart';

class ArticoloStandardCassettaPs {
  ArticoloStandardCassettaPs({
    required this.id,
    required this.nomeProdotto,
    required this.quantita,
    required this.tipologia,
  });

  factory ArticoloStandardCassettaPs.fromRecord(RecordModel r) {
    return ArticoloStandardCassettaPs(
      id: r.id,
      nomeProdotto: r.getStringValue('nome_prodotto'),
      quantita: r.getStringValue('quantita'),
      tipologia: r.getStringValue('tipologia'),
    );
  }

  final String id;
  final String nomeProdotto;
  final String quantita;
  final String tipologia;
}
