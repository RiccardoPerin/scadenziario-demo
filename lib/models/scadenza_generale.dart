import 'package:pocketbase/pocketbase.dart';

class ScadenzaGenerale {
  ScadenzaGenerale({
    required this.id,
    required this.nome,
    required this.scadenza,
    required this.giorniPreavviso,
    required this.note,
    required this.notaScadenza,
  });

  factory ScadenzaGenerale.fromRecord(RecordModel r) {
    return ScadenzaGenerale(
      id: r.id,
      nome: r.getStringValue('nome'),
      scadenza: r.getStringValue('scadenza'),
      giorniPreavviso: r.getListValue<int>('giorni_preavviso'),
      note: r.getStringValue('note'),
      notaScadenza: r.getStringValue('nota_scadenza'),
    );
  }

  final String id;
  final String nome;
  final String scadenza;
  final List<int> giorniPreavviso;
  final String note;

  /// Nota libera per questa scadenza (es. "prenotato"). A differenza delle
  /// altre entità con più scadenze per record, qui un record è già una sola
  /// scadenza, quindi non serve una mappa per tipo: basta un testo semplice.
  final String notaScadenza;
}
