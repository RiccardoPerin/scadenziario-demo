import 'package:pocketbase/pocketbase.dart';

class RegolaDpiMansione {
  RegolaDpiMansione({
    required this.id,
    required this.mansione,
    required this.dpiObbligatoriIds,
  });

  factory RegolaDpiMansione.fromRecord(RecordModel r) {
    return RegolaDpiMansione(
      id: r.id,
      mansione: r.getStringValue('mansione'),
      dpiObbligatoriIds: r.getListValue<String>('dpi_obbligatori'),
    );
  }

  final String id;
  final String mansione;
  final List<String> dpiObbligatoriIds;
}
