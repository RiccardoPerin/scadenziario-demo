import 'package:pocketbase/pocketbase.dart';

/// Legge un campo JSON che contiene una mappa tipo->testo (es. `note_scadenze`
/// o `commenti_scadenze`) in modo tollerante: se il valore non è ancora stato
/// impostato PocketBase lo restituisce come `null`, ma se qualcuno lo
/// modifica a mano dall'Admin UI con un valore non valido (es. una stringa
/// anziché un oggetto) un cast diretto lancerebbe un'eccezione non gestita
/// che romperebbe il caricamento dell'intera lista.
Map<String, String> _leggiMappaJson(RecordModel r, String campo) {
  final raw = r.data[campo];
  if (raw is! Map) return {};
  return raw.map((tipo, nota) => MapEntry(tipo.toString(), nota.toString()));
}

class Cantiere {
  Cantiere({
    required this.id,
    required this.nome,
    required this.indirizzo,
    required this.comune,
    required this.cap,
    required this.dataInizio,
    required this.dataFine,
    required this.stato,
    required this.scadenzaMessaTerra,
    required this.scadenzaGenerica1,
    required this.scadenzaGenerica2,
    required this.scadenzaGenerica3,
    required this.scadenzaGenerica4,
    required this.scadenzaGenerica5,
    required this.nomeScadenzaGenerica1,
    required this.nomeScadenzaGenerica2,
    required this.nomeScadenzaGenerica3,
    required this.nomeScadenzaGenerica4,
    required this.nomeScadenzaGenerica5,
    required this.note,
    required this.noteScadenze,
    required this.commentiScadenze,
  });

  factory Cantiere.fromRecord(RecordModel r) {
    return Cantiere(
      id: r.id,
      nome: r.getStringValue('nome'),
      indirizzo: r.getStringValue('indirizzo'),
      comune: r.getStringValue('comune'),
      cap: r.getStringValue('CAP'),
      dataInizio: r.getStringValue('data_inizio'),
      dataFine: r.getStringValue('data_fine'),
      stato: r.getStringValue('stato'),
      scadenzaMessaTerra: r.getStringValue('scadenza_messa_a_terra'),
      scadenzaGenerica1: r.getStringValue('scadenza_generica1'),
      scadenzaGenerica2: r.getStringValue('scadenza_generica2'),
      scadenzaGenerica3: r.getStringValue('scadenza_generica3'),
      scadenzaGenerica4: r.getStringValue('scadenza_generica4'),
      scadenzaGenerica5: r.getStringValue('scadenza_generica5'),
      nomeScadenzaGenerica1: r.getStringValue('scadenza_generica1_nome'),
      nomeScadenzaGenerica2: r.getStringValue('scadenza_generica2_nome'),
      nomeScadenzaGenerica3: r.getStringValue('scadenza_generica3_nome'),
      nomeScadenzaGenerica4: r.getStringValue('scadenza_generica4_nome'),
      nomeScadenzaGenerica5: r.getStringValue('scadenza_generica5_nome'),
      note: r.getStringValue('note'),
      noteScadenze: _leggiMappaJson(r, 'note_scadenze'),
      commentiScadenze: _leggiMappaJson(r, 'commenti_scadenze'),
    );
  }

  final String id;
  final String nome;
  final String indirizzo;
  final String comune;
  final String cap;
  final String dataInizio;
  final String dataFine;
  final String stato;
  final String scadenzaMessaTerra;
  final String scadenzaGenerica1;
  final String scadenzaGenerica2;
  final String scadenzaGenerica3;
  final String scadenzaGenerica4;
  final String scadenzaGenerica5;
  final String nomeScadenzaGenerica1;
  final String nomeScadenzaGenerica2;
  final String nomeScadenzaGenerica3;
  final String nomeScadenzaGenerica4;
  final String nomeScadenzaGenerica5;

  /// Nota generale libera sul cantiere, mostrata in "Informazioni".
  final String note;

  /// Nota "prenotato"/"prenotata" per singola scadenza, indicizzata per il
  /// nome del campo ("scadenza_messa_a_terra", "scadenza_generica1", ...) e
  /// non per l'etichetta visualizzata (rinominabile per le scadenze
  /// generiche). Modificabile solo dalla sezione "Scadenze imminenti":
  /// scrivere "prenotato" qui blocca l'invio della mail di sollecito per
  /// quella scadenza (vedi backend/pb_hooks/notifiche.pb.js).
  final Map<String, String> noteScadenze;

  /// Commento libero per singola scadenza, indipendente da [noteScadenze]:
  /// non ha alcun effetto sull'invio delle mail, serve solo da promemoria e
  /// si può scrivere in qualsiasi momento (anche prima che la scadenza sia
  /// imminente) dalla pagina di dettaglio del cantiere.
  final Map<String, String> commentiScadenze;
}
