import 'package:pocketbase/pocketbase.dart';

/// Etichette leggibili per il campo select `tipologia` di PocketBase, le cui
/// opzioni sono salvate con underscore (es. "gru_a_torre").
const tipologieMacchinario = {
  'gru_su_autocarro': 'Gru su autocarro',
  'gru_a_torre': 'Gru a torre',
  'sollevatore_telescopico': 'Sollevatore telescopico',
  'carrello_elevatore': 'Carrello elevatore',
  'minipala': 'Minipala',
  'escavatore_cingolato': 'Escavatore cingolato',
  'escavatore_idraulico': 'Escavatore idraulico',
  'rullo': 'Rullo',
};

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

class Macchinario {
  Macchinario({
    required this.id,
    required this.modello,
    required this.numeroMatricola,
    required this.numeroFabbrica,
    required this.tipologia,
    required this.annoAcquisto,
    required this.proprieta,
    required this.nomeLeasing,
    required this.scadenzaLeasing,
    required this.nomeNoleggio,
    required this.emailNoleggio,
    required this.presenteInCivaInail,
    required this.inUso,
    required this.inMagazzino,
    required this.ubicazioneCantiereId,
    required this.ubicazioneAutomezzoId,
    required this.nomeAssicurazione,
    required this.scadenzaAssicurazione,
    required this.dataManutenzioneInterna,
    required this.scadenzaManutenzioneInterna,
    required this.dataControlloFuniCatene,
    required this.scadenzaControlloFuniCatene,
    required this.dataVerificaAnnuale,
    required this.scadenzaVerificaAnnuale,
    required this.dataVerificaVentennale,
    required this.scadenzaVerificaVentennale,
    required this.note,
    required this.noteScadenze,
    
  });

  factory Macchinario.fromRecord(RecordModel r) {
    return Macchinario(
      id: r.id,
      modello: r.getStringValue('modello'),
      numeroMatricola: r.getStringValue('numero_matricola'),
      numeroFabbrica: r.getStringValue('numero_fabbrica'),
      tipologia: r.getStringValue('tipologia'),
      annoAcquisto: r.getIntValue('anno_acquisto'),
      proprieta: r.getStringValue('proprieta'),
      nomeLeasing: r.getStringValue('nome_leasing'),
      scadenzaLeasing: r.getStringValue('scadenza_leasing'),
      nomeNoleggio: r.getStringValue('nome_noleggio'),
      emailNoleggio: r.getStringValue('email_noleggiatore'),
      presenteInCivaInail: r.getBoolValue('presente_in_civa_inail'),
      inUso: r.getBoolValue('in_uso'),
      inMagazzino: r.getBoolValue('in_magazzino'),
      ubicazioneCantiereId: r.getStringValue('ubicazione_cantiere'),
      ubicazioneAutomezzoId: r.getStringValue('ubicazione_automezzo'),
      nomeAssicurazione: r.getStringValue('nome_assicurazione'),
      scadenzaAssicurazione: r.getStringValue('scadenza_assicurazione'),
      dataManutenzioneInterna: r.getStringValue('data_manutenzione_interna'),
      scadenzaManutenzioneInterna: r.getStringValue(
        'scadenza_manutenzione_interna',
      ),
      dataControlloFuniCatene: r.getStringValue('data_controllo_funi_catene'),
      scadenzaControlloFuniCatene: r.getStringValue(
        'scadenza_controllo_funi_catene',
      ),
      dataVerificaAnnuale: r.getStringValue('data_verifica_annuale'),
      scadenzaVerificaAnnuale: r.getStringValue('scadenza_verifica_annuale'),
      dataVerificaVentennale: r.getStringValue('data_verifica_ventennale'),
      scadenzaVerificaVentennale: r.getStringValue(
        'scadenza_verifica_ventennale',
      ),
      note: r.getStringValue('note'),
      noteScadenze: _leggiNoteScadenze(r),
    );
  }

  final String id;
  final String modello;
  final String numeroMatricola;
  final String numeroFabbrica;
  final String tipologia;
  final int annoAcquisto;
  final String proprieta;
  final String nomeLeasing;
  final String scadenzaLeasing;
  final String nomeNoleggio;
  final String emailNoleggio;
  final bool presenteInCivaInail;
  final bool inUso;
  final bool inMagazzino;
  final String ubicazioneCantiereId;
  final String ubicazioneAutomezzoId;
  final String nomeAssicurazione;
  final String scadenzaAssicurazione;
  final String dataManutenzioneInterna;
  final String scadenzaManutenzioneInterna;
  final String dataControlloFuniCatene;
  final String scadenzaControlloFuniCatene;
  final String dataVerificaAnnuale;
  final String scadenzaVerificaAnnuale;
  final String dataVerificaVentennale;
  final String scadenzaVerificaVentennale;
  final String note;
  

  /// Note libere per singola scadenza (es. "prenotato"), indicizzate per
  /// l'etichetta della scadenza (vedi _vociScadenza in macchinari_screen.dart).
  final Map<String, String> noteScadenze;
}
