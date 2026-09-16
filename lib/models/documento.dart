import 'package:pocketbase/pocketbase.dart';

class Documento {
  Documento({
    required this.record,
    required this.tipoDocumentoId,
    required this.cantiereId,
    required this.subappaltatoreId,
    required this.dipendenteId,
    required this.dataScadenza,
    required this.caricatoDaId,
    required this.note,
    required this.notaScadenza,
    required this.created,
    this.tipoDocumentoNome,
    this.giorniPreavviso = const [],
  });

  factory Documento.fromRecord(RecordModel r) {
    final scadenzaStr = r.getStringValue('data_scadenza');
    final createdStr = r.get<String>('created', '');
    return Documento(
      record: r,
      tipoDocumentoId: r.getStringValue('tipo_documento'),
      cantiereId: r.getStringValue('cantiere'),
      subappaltatoreId: r.getStringValue('subappaltatore'),
      dipendenteId: r.getStringValue('dipendente'),
      dataScadenza: scadenzaStr.isEmpty ? null : DateTime.tryParse(scadenzaStr),
      caricatoDaId: r.getStringValue('caricato_da'),
      note: r.getStringValue('note'),
      notaScadenza: r.getStringValue('nota_scadenza'),
      created: createdStr.isEmpty
          ? DateTime.fromMillisecondsSinceEpoch(0)
          : DateTime.parse(createdStr),
      tipoDocumentoNome: r.get<String>('expand.tipo_documento.nome', ''),
      giorniPreavviso: r.getListValue<int>('expand.tipo_documento.giorni_preavviso'),
    );
  }

  final RecordModel record;
  final String tipoDocumentoId;
  final String cantiereId;
  final String subappaltatoreId;
  final String dipendenteId;
  final DateTime? dataScadenza;
  final String caricatoDaId;

  /// Nota generale libera sul documento, editabile in qualsiasi momento.
  final String note;

  /// Nota "prenotato"/"prenotata" per questa scadenza: scriverla blocca
  /// l'invio della mail di sollecito (vedi backend/pb_hooks/notifiche.pb.js).
  /// Modificabile solo dalla sezione "Scadenze imminenti", indipendente da
  /// [note].
  final String notaScadenza;

  final DateTime created;
  final String? tipoDocumentoNome;
  final List<int> giorniPreavviso;

  /// Copia con nome e giorni di preavviso della tipologia riallineati.
  ///
  /// Questi due campi arrivano dall'`expand` del record (vedi
  /// [Documento.fromRecord]): sono una fotografia del tipo scadenza al momento
  /// del caricamento, quindi dopo una modifica della tipologia le scadenze già
  /// in memoria vanno aggiornate così, senza rileggere l'intera collection.
  Documento conTipoAggiornato({
    required String nome,
    required List<int> giorniPreavviso,
  }) {
    return Documento(
      record: record,
      tipoDocumentoId: tipoDocumentoId,
      cantiereId: cantiereId,
      subappaltatoreId: subappaltatoreId,
      dipendenteId: dipendenteId,
      dataScadenza: dataScadenza,
      caricatoDaId: caricatoDaId,
      note: note,
      notaScadenza: notaScadenza,
      created: created,
      tipoDocumentoNome: nome,
      giorniPreavviso: giorniPreavviso,
    );
  }

  /// Documento generale del cantiere (nessun subappaltatore/dipendente associato).
  bool get isDocumentoCantiere =>
      cantiereId.isNotEmpty && subappaltatoreId.isEmpty && dipendenteId.isEmpty;

  /// Documento generale del subappaltatore, valido su più cantieri.
  bool get isDocumentoSubappaltatoreGenerale =>
      subappaltatoreId.isNotEmpty && cantiereId.isEmpty && dipendenteId.isEmpty;

  /// Documento specifico della coppia cantiere+subappaltatore (es. POS).
  bool get isDocumentoSpecifico =>
      cantiereId.isNotEmpty && subappaltatoreId.isNotEmpty && dipendenteId.isEmpty;

  /// Documento/certificazione di un dipendente.
  bool get isDocumentoDipendente => dipendenteId.isNotEmpty;
}
