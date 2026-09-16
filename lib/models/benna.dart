import 'package:pocketbase/pocketbase.dart';

class Benna {
  Benna({
    required this.id,
    required this.collectionId,
    required this.idInterno,
    required this.foto,
    required this.numeroSerie,
    required this.descrizione,
    required this.capacitaCarico,
    required this.dataAcquisto,
    required this.inMagazzino,
    required this.ubicazioneCantiereId,
    required this.dataUltimaVerificaInterna,
    required this.esitoVerifica,
    required this.dataProssimaVerifica,
    required this.note,
    required this.notaScadenza,
  });

  factory Benna.fromRecord(RecordModel r) {
    return Benna(
      id: r.id,
      collectionId: r.collectionId,
      idInterno: r.getStringValue('id_interno'),
      foto: r.getStringValue('foto'),
      numeroSerie: r.getStringValue('num_serie_produttore'),
      descrizione: r.getStringValue('descrizione'),
      capacitaCarico: r.getStringValue('capacita_carico'),
      inMagazzino: r.getBoolValue('in_magazzino'),
      ubicazioneCantiereId: r.getStringValue('ubicazione_cantiere'),
      dataAcquisto: r.getStringValue('data_acquisto'),
      dataUltimaVerificaInterna: r.getStringValue('data_ultima_verifica_interna'),
      esitoVerifica: r.getBoolValue('esito_verifica'),
      dataProssimaVerifica: r.getStringValue('data_prossima_verifica'),
      note: r.getStringValue('note'),
      notaScadenza: r.getStringValue('nota_scadenza'),
    );
  }

  final String id;

  /// Serve a comporre l'URL del file `foto` (vedi [getImageUrl]).
  final String collectionId;
  final String idInterno;

  /// Nome del file della foto, vuoto se non caricata.
  final String foto;
  final String numeroSerie;
  final String descrizione;
  final String capacitaCarico;
  final bool inMagazzino;
  final String ubicazioneCantiereId;
  final String dataAcquisto;
  final String dataUltimaVerificaInterna;
  final bool esitoVerifica;
  final String dataProssimaVerifica;
  final String note;
  final String notaScadenza;

  bool get haFoto => foto.isNotEmpty;

  /// URL della foto da usare nei widget; `thumb` accetta i formati di
  /// PocketBase (es. `100x100`) per non scaricare l'originale.
  String getImageUrl(PocketBase pb, {String? thumb}) {
    if (foto.isEmpty) return '';
    final url = '${pb.baseURL}/api/files/$collectionId/$id/$foto';
    return thumb == null ? url : '$url?thumb=$thumb';
  }
}
