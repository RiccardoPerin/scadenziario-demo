import 'package:pocketbase/pocketbase.dart';

class ControlloSegnale {
  ControlloSegnale({
    required this.id,
    required this.segnaleId,
    required this.dataIspezione,
    required this.esiste,
    required this.posizioneIdonea,
    required this.buonoStato,
    required this.note,
    this.segnaleNome = '',
  });

  factory ControlloSegnale.fromRecord(RecordModel r) {
    return ControlloSegnale(
      id: r.id,
      segnaleId: r.getStringValue('segnale'),
      dataIspezione: r.getStringValue('data_ispezione'),
      esiste: r.getBoolValue('esiste'),
      posizioneIdonea: r.getBoolValue('posizione_idonea'),
      buonoStato: r.getBoolValue('buono_stato'),
      note: r.getStringValue('note'),
      // Valorizzato solo se il record è stato caricato con expand=segnale.
      segnaleNome: r.get<String>('expand.segnale.nome', ''),
    );
  }

  final String id;
  final String segnaleId;
  final String dataIspezione;
  final bool esiste;
  final bool posizioneIdonea;
  final bool buonoStato;
  final String note;
  final String segnaleNome;

  /// Controllo con esito positivo su tutti e tre i punti verificati.
  bool get esitoPositivo => esiste && posizioneIdonea && buonoStato;
}
