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

class Rifiuto {
  Rifiuto({
    required this.id,
    required this.nomeDitta,
    required this.trasportatore,
    required this.nrAutorizzazioneTrasportatore,
    required this.scadRifiutiNonPericolosiTrasportatore,
    required this.autorizzazioneRifiutiPericolosiTrasportatore,
    required this.scadRifiutiPericolosiTrasportatore,
    required this.noteTrasportatore,
    required this.smaltitore,
    required this.nrAutorizzazioneSmaltitore,
    required this.scadRifiutiNonPericolosiSmaltitore,
    required this.autorizzazioneRifiutiPericolosiSmaltitore,
    required this.scadRifiutiPericolosiSmaltitore,
    required this.noteSmaltitore,
    required this.noteScadenze,
  });

  factory Rifiuto.fromRecord(RecordModel r) {
    return Rifiuto(
      id: r.id,
      nomeDitta: r.getStringValue('nome_ditta'),
      trasportatore: r.getBoolValue('trasportatore'),
      nrAutorizzazioneTrasportatore: r.getStringValue('nr_autorizzazione_trasportatore'),
      scadRifiutiNonPericolosiTrasportatore: r.getStringValue('scadenza_rifiuti_non_pericolosi_trasportatore'),
      autorizzazioneRifiutiPericolosiTrasportatore: r.getBoolValue('autorizzazione_rifiuti_pericolosi_trasportatore'),
      scadRifiutiPericolosiTrasportatore: r.getStringValue('scadenza_rifiuti_pericolosi_trasportatore'),
      noteTrasportatore: r.getStringValue('note_trasportatore'),
      smaltitore: r.getBoolValue('smaltitore'),
      nrAutorizzazioneSmaltitore: r.getStringValue('nr_autorizzazione_smaltitore'),
      scadRifiutiNonPericolosiSmaltitore: r.getStringValue('scadenza_rifiuti_non_pericolosi_smaltitore'),
      autorizzazioneRifiutiPericolosiSmaltitore: r.getBoolValue('autorizzazione_rifiuti_pericolosi_smaltitore'),
      scadRifiutiPericolosiSmaltitore: r.getStringValue('scadenza_rifiuti_pericolosi_smaltitore'),
      noteSmaltitore: r.getStringValue('note_smaltitore'),
      noteScadenze: _leggiNoteScadenze(r),
    );
  }

  final String id;
  final String nomeDitta;
  final bool trasportatore;
  final String nrAutorizzazioneTrasportatore;
  final String scadRifiutiNonPericolosiTrasportatore;
  final bool autorizzazioneRifiutiPericolosiTrasportatore;
  final String scadRifiutiPericolosiTrasportatore;
  final String noteTrasportatore;
  final bool smaltitore;
  final String nrAutorizzazioneSmaltitore;
  final String scadRifiutiNonPericolosiSmaltitore;
  final bool autorizzazioneRifiutiPericolosiSmaltitore;
  final String scadRifiutiPericolosiSmaltitore;
  final String noteSmaltitore;

  /// Note libere per singola scadenza (es. "prenotato"), indicizzate per
  /// l'etichetta della scadenza (vedi _vociScadenza in automezzi_screen.dart).
  final Map<String, String> noteScadenze;
}
