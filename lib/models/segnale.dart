import 'package:pocketbase/pocketbase.dart';

class Segnale {
  Segnale({
    required this.id,
    required this.collectionId,
    required this.nome,
    required this.cartello,
    required this.ubicazione,
    required this.zona,
    required this.note,
  });

  factory Segnale.fromRecord(RecordModel r) {
    return Segnale(
      id: r.id,
      collectionId: r.collectionId,
      nome: r.getStringValue('nome'),
      // Campo file singolo: PocketBase restituisce il solo nome del file.
      cartello: r.getStringValue('cartello'),
      ubicazione: r.getStringValue('ubicazione'),
      zona: r.getStringValue('zona'),
      note: r.getStringValue('note'),
    );
  }

  final String id;

  /// Serve a comporre l'URL del file `cartello` (vedi [getImageUrl]).
  final String collectionId;
  final String nome;

  /// Nome del file dell'immagine del cartello, vuoto se non caricata.
  final String cartello;
  final String ubicazione;

  /// Valori ammessi dalla collection: `ufficio` o `magazzino`.
  final String zona;

  /// Note libere sul cartello, vuote se non compilate.
  final String note;

  bool get haCartello => cartello.isNotEmpty;

  /// URL dell'immagine del cartello da usare nei widget; `thumb` accetta i
  /// formati di PocketBase (es. `100x100`) per non scaricare l'originale.
  String getImageUrl(PocketBase pb, {String? thumb}) {
    if (cartello.isEmpty) return '';
    final url = '${pb.baseURL}/api/files/$collectionId/$id/$cartello';
    return thumb == null ? url : '$url?thumb=$thumb';
  }
}
