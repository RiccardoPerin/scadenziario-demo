import 'package:pocketbase/pocketbase.dart';

class CassettaPs {
  CassettaPs({
    required this.id,
    required this.numero,
    required this.tipologia,
    required this.inUfficio,
    required this.inMagazzino,
    required this.ubicazioneAutomezzoId,
    required this.ubicazioneCantiereId,
    required this.dettaglioUbicazione,
    required this.ultimaVerifica,
    required this.prossimoControllo,
    required this.note,
    required this.notaScadenza,
  });

  factory CassettaPs.fromRecord(RecordModel r) {
    return CassettaPs(
      id: r.id,
      numero: r.getStringValue('numero'),
      tipologia: r.getStringValue('tipologia'),
      inUfficio: r.getBoolValue('in_ufficio'),
      inMagazzino: r.getBoolValue('in_magazzino'),
      ubicazioneAutomezzoId: r.getStringValue('ubicazione_automezzo'),
      ubicazioneCantiereId: r.getStringValue('ubicazione_cantiere'),
      dettaglioUbicazione: r.getStringValue('dettaglio_ubicazione'),
      ultimaVerifica: r.getStringValue('ultima_verifica'),
      prossimoControllo: r.getStringValue('prossimo_controllo'),
      note: r.getStringValue('note'),
      notaScadenza: r.getStringValue('nota_scadenza'),
    );
  }

  final String id;
  final String numero;
  final String tipologia;
  final bool inUfficio;
  final bool inMagazzino;
  final String ubicazioneAutomezzoId;
  final String ubicazioneCantiereId;
  final String dettaglioUbicazione;
  final String ultimaVerifica;
  final String prossimoControllo;
  final String note;
  final String notaScadenza;
}
