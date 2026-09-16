import 'package:pocketbase/pocketbase.dart';

Map<String, String> _leggiNoteScadenze(RecordModel r) {
  final raw = r.data['note_scadenze'];
  if (raw is! Map) return {};
  return raw.map((tipo, nota) => MapEntry(tipo.toString(), nota.toString()));
}

class Impianto {
  Impianto({
    required this.id,
    required this.tipologia,
    required this.inUfficio,
    required this.inMagazzino,
    required this.dataInstallazione,
    required this.dittaInstallatrice,
    required this.dataValutazione,
    required this.dataManutenzioneInterna,
    required this.scadenzaManutenzioneInterna,
    required this.tipoVerificaInternaEffettuata,
    required this.dataManutenzioneEsterna,
    required this.scadenzaManutenzioneEsterna,
    required this.tipoVerificaEsternaEffettuata,
    required this.scadenzaValutazioneScaricheAtmosferiche,
    required this.note,
    required this.noteScadenze,
  });

  factory Impianto.fromRecord(RecordModel r) {
    return Impianto(
      id: r.id,
      tipologia: r.getStringValue('tipologia'),
      inUfficio: r.getBoolValue('in_ufficio'),
      inMagazzino: r.getBoolValue('in_magazzino'),
      dataInstallazione: r.getStringValue('data_installazione'),
      dittaInstallatrice: r.getStringValue('ditta_installatrice'),
      dataValutazione: r.getStringValue('data_valutazione'),
      dataManutenzioneInterna: r.getStringValue('data_manutenzione_interna'),
      scadenzaManutenzioneInterna: r.getStringValue('scadenza_manutenzione_interna'),
      tipoVerificaInternaEffettuata: r.getStringValue('tipo_manutenzione_interna_effettuata'),
      dataManutenzioneEsterna: r.getStringValue('data_manutenzione_esterna'),
      scadenzaManutenzioneEsterna: r.getStringValue('scadenza_manutenzione_esterna'),
      tipoVerificaEsternaEffettuata: r.getStringValue('tipo_verifica_esterna_effettuata'),
      scadenzaValutazioneScaricheAtmosferiche: r.getStringValue('scadenza_valutazione_scariche_atmosferiche'),
      note: r.getStringValue('note'),
      noteScadenze: _leggiNoteScadenze(r),
    );
  }

  final String id;
  final String tipologia;
  final bool inUfficio;
  final bool inMagazzino;
  final String dataInstallazione;
  final String dittaInstallatrice;
  final String dataValutazione;
  final String dataManutenzioneInterna;
  final String scadenzaManutenzioneInterna;
  final String tipoVerificaInternaEffettuata;
  final String dataManutenzioneEsterna;
  final String scadenzaManutenzioneEsterna;
  final String tipoVerificaEsternaEffettuata;
  final String scadenzaValutazioneScaricheAtmosferiche;
  final String note;
  final Map<String, String> noteScadenze;
}
