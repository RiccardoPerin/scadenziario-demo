import 'package:pocketbase/pocketbase.dart';

Map<String, String> _leggiNoteScadenze(RecordModel r) {
  final raw = r.data['note_scadenze'];
  if (raw is! Map) return {};
  return raw.map((tipo, nota) => MapEntry(tipo.toString(), nota.toString()));
}

class Misura {
  Misura({
    required this.id,
    required this.nome,
    required this.riferimento,
    required this.matricola,
    required this.incaricatoTaraturaInterna,
    required this.dataTaraturaInterna,
    required this.dataProssimaTaraturaInterna,
    required this.incaricatoTaraturaEsterna,
    required this.dataTaraturaEsterna,
    required this.dataProssimaTaraturaEsterna,
    required this.note,
    required this.noteScadenze,
  });

  factory Misura.fromRecord(RecordModel r) {
    return Misura(
      id: r.id,
      nome: r.getStringValue('nome'),
      riferimento: r.getStringValue('riferimento'),
      matricola: r.getStringValue('matricola'),
      incaricatoTaraturaInterna: r.getStringValue('incaricato_taratura_interna'),
      dataTaraturaInterna: r.getStringValue('data_ultima_taratura_interna'),
      dataProssimaTaraturaInterna: r.getStringValue('data_prossima_taratura_interna'),
      incaricatoTaraturaEsterna: r.getStringValue('incaricato_taratura_esterna'),
      dataTaraturaEsterna: r.getStringValue('data_ultima_taratura_esterna'),
      dataProssimaTaraturaEsterna: r.getStringValue('data_prossima_taratura_esterna'),
      note: r.getStringValue('note'),
      noteScadenze: _leggiNoteScadenze(r),
    );
  }

  final String id;
  final String nome;
  final String riferimento;
  final String matricola;
  final String incaricatoTaraturaInterna;
  final String dataTaraturaInterna;
  final String dataProssimaTaraturaInterna;
  final String incaricatoTaraturaEsterna;
  final String dataTaraturaEsterna;
  final String dataProssimaTaraturaEsterna;
  final String note;
  final Map<String, String> noteScadenze;
}
