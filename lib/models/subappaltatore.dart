import 'package:pocketbase/pocketbase.dart';

class Subappaltatore {
  Subappaltatore({
    required this.id,
    required this.ragioneSociale,
    required this.partitaIva,
    required this.telefono,
    required this.email,
    required this.note,
    required this.cantieriIds,
  });

  factory Subappaltatore.fromRecord(RecordModel r) {
    return Subappaltatore(
      id: r.id,
      ragioneSociale: r.getStringValue('ragione_sociale'),
      partitaIva: r.getStringValue('p_iva'),
      telefono: r.getStringValue('telefono'),
      email: r.getStringValue('email'),
      note: r.getStringValue('note'),
      cantieriIds: r.getListValue<String>('cantieri'),
    );
  }

  final String id;
  final String ragioneSociale;
  final String partitaIva;
  final String telefono;
  final String email;

  /// Note libere sul subappaltatore, mostrate nel riquadro "Informazioni"
  /// della sua pagina.
  final String note;
  final List<String> cantieriIds;
}
