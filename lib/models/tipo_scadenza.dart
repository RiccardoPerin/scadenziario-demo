import 'package:pocketbase/pocketbase.dart';

class TipoScadenza {
  TipoScadenza({
    required this.id,
    required this.nome,
    required this.richiedeScadenza,
    required this.giorniPreavviso,
    required this.avvisaDopoScadenza,
    required this.appartenenza,
    required this.note,
  });

  factory TipoScadenza.fromRecord(RecordModel r) {
    return TipoScadenza(
      id: r.id,
      nome: r.getStringValue('nome'),
      richiedeScadenza: r.getBoolValue('richiede_scadenza'),
      giorniPreavviso: r.getListValue<int>('giorni_preavviso'),
      avvisaDopoScadenza: r.getBoolValue('avvisa_dopo_scadenza'),
      appartenenza: r.getListValue<String>('appartenenza'),
      note: r.getStringValue('note'),
    );
  }

  final String id;
  final String nome;
  final bool richiedeScadenza;
  final List<int> giorniPreavviso;

  /// Tipologia da avvisare solo a scadenza superata (es. il DURC, che si
  /// rinnova quando il precedente è scaduto): niente preavvisi né avviso il
  /// giorno stesso, la prima mail parte il giorno dopo la data segnata.
  /// Con questo flag attivo [giorniPreavviso] non viene usato per le email
  /// (vedi backend/pb_hooks/notifiche.pb.js).
  final bool avvisaDopoScadenza;

  final List<String> appartenenza;

  /// Nota predefinita della tipologia (es. "scade ogni 6 mesi"): viene
  /// precompilata nelle note della scadenza quando si sceglie questo tipo.
  final String note;

  bool get appartieneCantiere => appartenenza.contains('cantiere');
  bool get appartieneSubappaltatore => appartenenza.contains('subappaltatore');
  bool get appartieneDipendente => appartenenza.contains('dipendente');

  /// Tipologia riservata ai lavoratori autonomi: sono i documenti che un
  /// autonomo deve avere in proprio (DURC, visura, POS…) e che un dipendente
  /// di un subappaltatore non ha, perché li tiene la sua azienda.
  bool get appartieneLavoratoreAutonomo => appartenenza.contains('lavoratore_autonomo');

  /// Tipologie assegnabili a un lavoratore autonomo: eredita tutte quelle dei
  /// dipendenti del subappaltatore e vi aggiunge le proprie.
  bool get assegnabileALavoratoreAutonomo =>
      appartieneDipendente || appartieneLavoratoreAutonomo;
}
