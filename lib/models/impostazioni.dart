import 'package:pocketbase/pocketbase.dart';

/// Impostazioni globali del gestionale: la collection ha una sola riga.
class Impostazioni {
  Impostazioni({
    required this.id,
    required this.sospensioneScadutiFino,
    required this.sospensioneImpostataDa,
  });

  factory Impostazioni.fromRecord(RecordModel r) {
    return Impostazioni(
      id: r.id,
      sospensioneScadutiFino: _soloData(r.getStringValue('sospensione_scaduti_fino')),
      sospensioneImpostataDa: r.getStringValue('sospensione_impostata_da'),
    );
  }

  /// PocketBase restituisce le date come "aaaa-mm-gg hh:mm:ss.sssZ": qui conta
  /// solo il giorno di calendario, quindi si prendono i componenti così come
  /// sono (senza conversione al fuso locale, che sposterebbe la data di un
  /// giorno per le mezzanotti UTC).
  static DateTime? _soloData(String valore) {
    if (valore.isEmpty) return null;
    final data = DateTime.tryParse(valore);
    return data == null ? null : DateTime(data.year, data.month, data.day);
  }

  final String id;

  /// Ultimo giorno (compreso) in cui restano sospesi i solleciti sulle voci
  /// già scadute; null se non c'è alcuna sospensione impostata.
  final DateTime? sospensioneScadutiFino;

  /// Email di chi ha impostato la sospensione, per sapere a chi chiedere.
  final String sospensioneImpostataDa;
}
