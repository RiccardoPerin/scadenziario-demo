import 'package:pocketbase/pocketbase.dart';

class Scala {
  Scala({
    required this.id,
    required this.codice,
    required this.materiale,
    required this.descrizione,
    required this.ubicazioneCantiereId,
    required this.inMagazzino,
    required this.ultimaVerifica,
    required this.prossimaVerifica,
    required this.note,
    required this.notaScadenza,
    
  });

  factory Scala.fromRecord(RecordModel s) {
    return Scala(
      id: s.id,
      codice: s.getStringValue('codice'),
      materiale: s.getStringValue('materiale'),
      descrizione: s.getStringValue('descrizione'),
      inMagazzino: s.getBoolValue('in_magazzino'),
      ubicazioneCantiereId: s.getStringValue('ubicazione_cantiere'),
      ultimaVerifica: s.getStringValue('ultima_verifica'),
      prossimaVerifica: s.getStringValue('prossima_verifica'),
      note: s.getStringValue('note'),
      notaScadenza: s.getStringValue('nota_scadenza'),
    );
  }

  final String id;
  final String codice;
  final String materiale;
  final String descrizione;
  final bool inMagazzino;
  final String ubicazioneCantiereId;
  final String ultimaVerifica;
  final String prossimaVerifica;
  final String note;
  final String notaScadenza;
}
