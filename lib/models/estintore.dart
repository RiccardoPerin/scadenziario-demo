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

class Estintore {
  Estintore({
    required this.id,
    required this.numeroMatricola,
    required this.tipoAgente,
    required this.capacita,
    required this.dataProduzione,
    required this.dataMessaInServizio,
    required this.inUfficio,
    required this.inMagazzino,
    required this.ubicazioneAutomezzoId,
    required this.ubicazioneCantiereId,
    required this.dettaglioUbicazione,
    required this.dataVerificaEsterna,
    required this.scadenzaVerificaEsterna,
    required this.ultimaRevisione,
    required this.scadenzaRevisione,
    required this.ultimoCollaudo,
    required this.scadenzaCollaudo,
    required this.note,
    required this.noteScadenze,
  });

  factory Estintore.fromRecord(RecordModel r) {
    return Estintore(
      id: r.id,
      numeroMatricola: r.getStringValue('numero_matricola'),
      tipoAgente: r.getStringValue('tipo_agente'),
      capacita: r.getStringValue('capacita'),
      dataProduzione: r.getStringValue('data_produzione'),
      dataMessaInServizio: r.getStringValue('data_messa_in_servizio'),
      inUfficio: r.getBoolValue('in_ufficio'),
      inMagazzino: r.getBoolValue('in_magazzino'),
      ubicazioneAutomezzoId: r.getStringValue('ubicazione_automezzo'),
      ubicazioneCantiereId: r.getStringValue('ubicazione_cantiere'),
      dettaglioUbicazione: r.getStringValue('dettaglio_ubicazione'),
      dataVerificaEsterna: r.getStringValue('data_verifica_esterna'),
      scadenzaVerificaEsterna: r.getStringValue('scadenza_verifica_esterna'),
      ultimaRevisione: r.getStringValue('ultima_revisione'),
      scadenzaRevisione: r.getStringValue('scadenza_revisione'),
      ultimoCollaudo: r.getStringValue('ultimo_collaudo'),
      scadenzaCollaudo: r.getStringValue('scadenza_collaudo'),
      note: r.getStringValue('note'),
      noteScadenze: _leggiNoteScadenze(r),
    );
  }

  final String id;
  final String numeroMatricola;
  final String tipoAgente;
  final String capacita;
  final String dataProduzione;
  final String dataMessaInServizio;
  final bool inUfficio;
  final bool inMagazzino;
  final String ubicazioneAutomezzoId;
  final String ubicazioneCantiereId;
  final String dettaglioUbicazione;
  final String dataVerificaEsterna;
  final String scadenzaVerificaEsterna;
  final String ultimaRevisione;
  final String scadenzaRevisione;
  final String ultimoCollaudo;
  final String scadenzaCollaudo;
  final String note;

  /// Note libere per singola scadenza (es. "prenotato"), indicizzate per
  /// l'etichetta della scadenza (vedi _vociScadenza in estintori_screen.dart).
  final Map<String, String> noteScadenze;
}
