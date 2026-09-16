import 'package:pocketbase/pocketbase.dart';

class DipendenteSubappaltatore {
  DipendenteSubappaltatore({
    required this.id,
    required this.nome,
    required this.cognome,
    required this.subappaltatoreId,
    required this.lavoratoreAutonomo,
    required this.note,
    required this.cantieriIds,
  });

  factory DipendenteSubappaltatore.fromRecord(RecordModel r) {
    return DipendenteSubappaltatore(
      id: r.id,
      nome: r.getStringValue('nome'),
      cognome: r.getStringValue('cognome'),
      subappaltatoreId: r.getStringValue('subappaltatore'),
      lavoratoreAutonomo: r.getBoolValue('lavoratore_autonomo'),
      note: r.getStringValue('note'),
      cantieriIds: r.getListValue<String>('cantieri'),
    );
  }

  final String id;
  final String nome;
  final String cognome;
  final String subappaltatoreId;

  /// Lavora in proprio: non è un dipendente di un'azienda, quindi oltre alle
  /// scadenze di un dipendente deve avere anche quelle d'impresa. Sulle sue
  /// scadenze si possono scegliere le tipologie con appartenenza
  /// "dipendente" più quelle con appartenenza "lavoratore_autonomo".
  final bool lavoratoreAutonomo;

  /// Note libere sul dipendente, mostrate nel riquadro "Informazioni" della
  /// sua pagina e nei tile che lo elencano.
  final String note;
  final List<String> cantieriIds;

  String get nomeCompleto => '$cognome $nome';
}
