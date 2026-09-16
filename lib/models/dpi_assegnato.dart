import 'package:pocketbase/pocketbase.dart';

class DpiAssegnato {
  DpiAssegnato({
    required this.id,
    required this.dipendente,
    required this.tipoDpi,
    required this.matricola,
    required this.taglia,
    required this.produttore,
    required this.dataMessaInUso,
    required this.annoFabbricazione,
    required this.dataScadenza,
    required this.dataConsegna,
    required this.ritiratoDPIQuota,
    required this.note,
    required this.notaScadenza,
  });

  factory DpiAssegnato.fromRecord(RecordModel r) {
    return DpiAssegnato(
      id: r.id,
      dipendente: r.getStringValue('dipendente'),
      tipoDpi: r.getStringValue('tipo_dpi'),
      matricola: r.getStringValue('matricola'),
      taglia: r.getIntValue('taglia'),
      produttore: r.getStringValue('produttore'),
      dataMessaInUso: r.getStringValue('data_messa_in_uso'),
      annoFabbricazione: r.getIntValue('anno_fabbricazione'),
      dataConsegna: r.getStringValue('data_consegna_dpi'),
      dataScadenza: r.getStringValue('data_scadenza'),
      ritiratoDPIQuota: r.getBoolValue('ritiro_dpi_quota'),
      note: r.getStringValue('note'),
      notaScadenza: r.getStringValue('nota_scadenza'),
    );
  }

  final String id;
  final String dipendente;
  final String tipoDpi;
  final String matricola;
  final int taglia;
  final String produttore;
  final String dataMessaInUso;
  final int annoFabbricazione;
  final String dataConsegna;
  final String dataScadenza;
  final bool ritiratoDPIQuota;
  final String note;
  final String notaScadenza;
}
