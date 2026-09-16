import 'package:pocketbase/pocketbase.dart';

class Scaffalatura {
  Scaffalatura({
    required this.id,
    required this.idInterno,
    required this.dataVerifica,
    required this.esitoPositivo,
    required this.dataProssimaVerifica,
    required this.note,
    required this.notaScadenza,
  });

  factory Scaffalatura.fromRecord(RecordModel r) {
    return Scaffalatura(
      id: r.id,
      idInterno: r.getIntValue('id_interno').toString(),
      dataVerifica: r.getStringValue('data_verifica'),
      esitoPositivo: r.getBoolValue('esito_positivo'),
      dataProssimaVerifica: r.getStringValue('data_prossima_verifica'),
      note: r.getStringValue('note'),
      notaScadenza: r.getStringValue('nota_scadenza'),
    );
  }

  final String id;
  final String idInterno;
  final String dataVerifica;
  final String dataProssimaVerifica;
  final bool esitoPositivo;
  final String note;
  final String notaScadenza;
}
