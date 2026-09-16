import 'package:pocketbase/pocketbase.dart';

class TipoDpi {
  TipoDpi({
    required this.id,
    required this.nome,
    required this.giorniPreavviso,
    required this.note,
    required this.lavoriInQuota,
  });

  factory TipoDpi.fromRecord(RecordModel r) {
    return TipoDpi(
      id: r.id,
      nome: r.getStringValue('nome'),
      giorniPreavviso: r.getListValue<int>('giorni_preavviso'),
      note: r.getStringValue('note'),
      lavoriInQuota: r.getBoolValue('lavori_in_quota'),
    );
  }

  final String id;
  final String nome;
  final List<int> giorniPreavviso;
  final String note;

  /// Se true, questo DPI viene richiesto automaticamente agli operai (M04)
  /// che hanno una scadenza lavori in quota impostata, oltre ai DPI previsti
  /// dalla regola della loro mansione.
  final bool lavoriInQuota;
}
