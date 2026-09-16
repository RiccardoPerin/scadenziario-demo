import 'package:pocketbase/pocketbase.dart';

/// Legge il campo JSON `note_scadenze` in modo tollerante: se il valore non
/// è ancora stato impostato PocketBase lo restituisce come `null`, ma se
/// qualcuno lo modifica a mano dall'Admin UI con un valore non valido (es.
/// una stringa anziché un oggetto) un cast diretto lancerebbe un'eccezione
/// non gestita che romperebbe il caricamento dell'intera lista.
Map<String, String> _leggiNoteScadenze(RecordModel r) {
  final raw = r.data['note_scadenze'];
  if (raw is! Map) return {};
  return raw.map((tipo, nota) => MapEntry(tipo.toString(), nota.toString()));
}

class Automezzo {
  Automezzo({
    required this.id,
    required this.nome,
    required this.targa,
    required this.catEuro,
    required this.telepass,
    required this.compAssicurazione,
    required this.proprieta,
    required this.scadenzaNoleggioLeasing,
    required this.scadenzaAssicurazione,
    required this.scadenzaBollo,
    required this.scadenzaRevisione,
    required this.scadenzaControlloTachigrafo,
    required this.note,
    required this.noteScadenze,
  });

  factory Automezzo.fromRecord(RecordModel r) {
    return Automezzo(
      id: r.id,
      nome: r.getStringValue('nome'),
      targa: r.getStringValue('targa'),
      catEuro: r.getStringValue('cat_euro'),
      telepass: r.getStringValue('telepass'),
      compAssicurazione: r.getStringValue('comp_assicurazione'),
      proprieta: r.getStringValue('proprieta'),
      scadenzaNoleggioLeasing: r.getStringValue('scadenza_noleggio_leasing'),
      scadenzaAssicurazione: r.getStringValue('scadenza_assicurazione'),
      scadenzaBollo: r.getStringValue('scadenza_bollo'),
      scadenzaRevisione: r.getStringValue('scadenza_revisione'),
      scadenzaControlloTachigrafo: r.getStringValue(
        'scadenza_controllo_tachigrafo',
      ),
      note: r.getStringValue('note'),
      noteScadenze: _leggiNoteScadenze(r),
    );
  }

  final String id;
  final String nome;
  final String targa;
  final String catEuro;
  final String telepass;
  final String compAssicurazione;
  final String proprieta;
  final String scadenzaNoleggioLeasing;
  final String scadenzaAssicurazione;
  final String scadenzaBollo;
  final String scadenzaRevisione;
  final String scadenzaControlloTachigrafo;
  final String note;

  /// Note libere per singola scadenza (es. "prenotato"), indicizzate per
  /// l'etichetta della scadenza (vedi _vociScadenza in automezzi_screen.dart).
  final Map<String, String> noteScadenze;

  /// Nome e targa per i selettori (es. "Furgone (AB123CD)"), per distinguere
  /// automezzi con nomi simili o non ancora rinominati.
  String get descrizioneConTarga {
    if (nome.isEmpty) return targa;
    if (targa.isEmpty) return nome;
    return '$nome ($targa)';
  }
}
