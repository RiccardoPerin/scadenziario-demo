import 'package:pocketbase/pocketbase.dart';

/// Valori ammessi dal campo `tipo_fascia` della collection, nell'ordine in cui
/// vanno mostrati nelle liste e nel form. Un record salvato con un tipo non
/// previsto (o senza tipo) finisce nel gruppo [tipoFasciaNonSpecificato].
const tipiFascia = [
  'braca di catene',
  'fasce di carico',
  'fasce di sollevamento',
  'nastro di ancoraggio',
];

const tipoFasciaNonSpecificato = 'Senza tipo';

/// Unico tipo per cui ha senso il flag `cricchetto` (vedi
/// [FasciaCatena.cricchetto]).
const tipoFasciaNastroAncoraggio = 'nastro di ancoraggio';

/// Etichetta da mostrare per un valore di `tipo_fascia` (i valori sono salvati
/// minuscoli, qui si mostrano con l'iniziale maiuscola).
String etichettaTipoFascia(String tipo) {
  if (tipo.isEmpty) return tipoFasciaNonSpecificato;
  return '${tipo[0].toUpperCase()}${tipo.substring(1)}';
}

class FasciaCatena {
  FasciaCatena({
    required this.id,
    required this.collectionId,
    required this.idInterno,
    required this.foto,
    required this.numeroSerie,
    required this.tipoFascia,
    required this.cricchetto,
    required this.colore,
    required this.portata,
    required this.larghezza,
    required this.inMagazzino,
    required this.ubicazioneAutomezzoId,
    required this.ubicazioneCantiereId,
    required this.spessore,
    required this.diametro,
    required this.lunghezza,
    required this.dataAcquisto,
    required this.luogoAcquisto,
    required this.dataUltimaVerificaInterna,
    required this.esitoVerifica,
    required this.dataProssimaVerifica,
    required this.note,
    required this.notaScadenza,
  });

  factory FasciaCatena.fromRecord(RecordModel r) {
    return FasciaCatena(
      id: r.id,
      collectionId: r.collectionId,
      idInterno: r.getStringValue('id_interno'),
      foto: r.getStringValue('foto'),
      numeroSerie: r.getStringValue('num_serie_produttore'),
      tipoFascia: r.getStringValue('tipo_fascia'),
      cricchetto: r.getBoolValue('cricchetto'),
      colore: r.getStringValue('colore'),
      inMagazzino: r.getBoolValue('in_magazzino'),
      ubicazioneAutomezzoId: r.getStringValue('ubicazione_automezzo'),
      ubicazioneCantiereId: r.getStringValue('ubicazione_cantiere'),
      portata: r.getStringValue('portata'),
      spessore: r.getStringValue('spessore'),
      diametro: r.getStringValue('diametro'),
      larghezza: r.getStringValue('larghezza'),
      lunghezza: r.getStringValue('lunghezza'),
      dataAcquisto: r.getStringValue('data_acquisto'),
      luogoAcquisto: r.getStringValue('luogo_acquisto'),
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
  final String tipoFascia;
  final bool cricchetto;
  final String colore;
  final String portata;
  final String lunghezza;
  final String spessore;
  final String diametro;
  final String larghezza;
  final bool inMagazzino;
  final String ubicazioneAutomezzoId;
  final String ubicazioneCantiereId;
  final String dataAcquisto;
  final String luogoAcquisto;
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
