import 'package:pocketbase/pocketbase.dart';

/// Legge il campo JSON `note_scadenze` in modo tollerante: se il valore non
/// è ancora stato impostato PocketBase lo restituisce come `null`, ma se
/// qualcuno lo modifica a mano dall'Admin UI con un valore non valido (es.
/// una stringa anziché un oggetto) un cast diretto lancerebbe un'eccezione
/// non gestita che romperebbe il caricamento dell'intera lista.
Map<String, String> _leggiNoteScadenze(RecordModel r) {
  final raw = r.data['note_scadenze'];
  if (raw is! Map) return {};
  return raw.map((tipo, nota) => MapEntry(tipo.toString(), nota.toString()));
}

/// Dipendente interno all'azienda. A differenza dei dipendenti dei
/// subappaltatori non ha documenti caricati: si tracciano solo le date di
/// scadenza, come per macchinari, automezzi ed estintori.
class DipendenteAziendale {
  DipendenteAziendale({
    required this.id,
    required this.nome,
    required this.cognome,
    required this.codiceFiscale,
    required this.mansione,
    required this.dataNascita,
    required this.luogoNascita,
    required this.eta,
    required this.dataAssunzione,
    required this.scadenzaVisitaMedica,
    required this.scadenzaCodiceFiscale,
    required this.scadenzaFormazioneSicurezza,
    required this.scadenzaGruAutocarro,
    required this.scadenzaGruTorre,
    required this.scadenzaCarrelloElevatoreSemovente,
    required this.scadenzaConduzioneEscavatori,
    required this.scadenzaPiattaformeElevatrici,
    required this.scadenzaPonteggi,
    required this.scadenzaPreposto,
    required this.scadenzaAntincendio,
    required this.scadenzaPrimoSoccorso,
    required this.scadenzaRspp,
    required this.scadenzaRlst,
    required this.scadenzaPatente,
    required this.scadenzaCartaTachigrafica,
    required this.scadenzaCartaIdentita,
    required this.scadenzaFirmaDigitale,
    required this.scadenzaPermessoSoggiorno,
    required this.scadenzaContratto,
    required this.scadenzaLavoriQuota,
    required this.scadenzaCorsoDisocianati,
    required this.scadenzaScaffalature,
    required this.scadenzaAntitetanica,
    required this.scadenzaCorsoCronotachigrafico,
    required this.dataFormazioneAmbientale,
    required this.dataFormazioneRentri,
    required this.dataFormazione231,
    required this.note,
    required this.noteScadenze,
  });

  factory DipendenteAziendale.fromRecord(RecordModel r) {
    return DipendenteAziendale(
      id: r.id,
      nome: r.getStringValue('nome'),
      cognome: r.getStringValue('cognome'),
      codiceFiscale: r.getStringValue('codice_fiscale'),
      mansione: r.getStringValue('mansione'),
      dataNascita: r.getStringValue('data_di_nascita'),
      luogoNascita: r.getStringValue('luogo_di_nascita'),
      eta: r.getStringValue('eta'),
      dataAssunzione: r.getStringValue('data_assunzione'),
      scadenzaVisitaMedica: r.getStringValue('scadenza_visita_medica'),
      scadenzaCodiceFiscale: r.getStringValue('scadenza_codice_fiscale'),
      scadenzaFormazioneSicurezza: r.getStringValue(
        'scadenza_formazione_sicurezza',
      ),
      scadenzaGruAutocarro: r.getStringValue('scadenza_gru_autocarro'),
      scadenzaGruTorre: r.getStringValue('scadenza_gru_torre'),
      scadenzaCarrelloElevatoreSemovente: r.getStringValue(
        'scadenza_carrelli_elevatori_semoventi',
      ),
      scadenzaConduzioneEscavatori: r.getStringValue(
        'scadenza_conduzione_escavatori',
      ),
      scadenzaPiattaformeElevatrici: r.getStringValue(
        'scadenza_piattaforme_elevatrici',
      ),
      scadenzaPonteggi: r.getStringValue(
        'scadenza_montaggio_smontaggio_ponteggi',
      ),
      scadenzaPreposto: r.getStringValue('scadenza_preposto'),
      scadenzaAntincendio: r.getStringValue('scadenza_antincendio'),
      scadenzaPrimoSoccorso: r.getStringValue('scadenza_primo_soccorso'),
      scadenzaRspp: r.getStringValue('scadenza_rspp'),
      scadenzaRlst: r.getStringValue('scadenza_rlst'),
      scadenzaPatente: r.getStringValue('scadenza_patente'),
      scadenzaCartaTachigrafica: r.getStringValue(
        'scadenza_carta_tachigrafica',
      ),
      scadenzaCartaIdentita: r.getStringValue('scadenza_carta_identita'),
      scadenzaFirmaDigitale: r.getStringValue('scadenza_firma_digitale'),
      scadenzaPermessoSoggiorno: r.getStringValue(
        'scadenza_permesso_soggiorno',
      ),
      scadenzaContratto: r.getStringValue('scadenza_contratto'),
      scadenzaLavoriQuota: r.getStringValue('scadenza_lavori_in_quota'),
      scadenzaCorsoDisocianati: r.getStringValue('scadenza_corso_disocianati'),
      scadenzaScaffalature: r.getStringValue('scadenza_corso_scaffalature'),
      scadenzaAntitetanica: r.getStringValue('scadenza_antitetanica'),
      dataFormazione231: r.getStringValue('data_formazione_modello_231'),
      dataFormazioneAmbientale: r.getStringValue(
        'data_formazione_sistema_gestione_ambientale',
      ),
      dataFormazioneRentri: r.getStringValue('data_formazione_rentri'),
      scadenzaCorsoCronotachigrafico: r.getStringValue(
        'scadenza_corso_cronotachigrafico',
      ),
      note: r.getStringValue('note'),
      noteScadenze: _leggiNoteScadenze(r),
    );
  }

  final String id;
  final String nome;
  final String cognome;
  final String codiceFiscale;
  final String mansione;
  final String dataNascita;
  final String luogoNascita;
  final String eta;
  final String dataAssunzione;

  // Sicurezza (base)
  final String scadenzaVisitaMedica;
  final String scadenzaCodiceFiscale;
  final String scadenzaFormazioneSicurezza;
  final String scadenzaLavoriQuota;

  // Corsi attrezzature
  final String scadenzaGruAutocarro;
  final String scadenzaGruTorre;
  final String scadenzaCarrelloElevatoreSemovente;
  final String scadenzaConduzioneEscavatori;
  final String scadenzaPiattaformeElevatrici;
  final String scadenzaPonteggi;
  final String scadenzaCorsoDisocianati;
  final String scadenzaScaffalature;
  final String scadenzaAntitetanica;
  final String scadenzaCorsoCronotachigrafico;

  // Ruoli ed emergenze
  final String scadenzaPreposto;
  final String scadenzaAntincendio;
  final String scadenzaPrimoSoccorso;
  final String scadenzaRspp;
  final String scadenzaRlst;

  // Formazione
  final String dataFormazione231;
  final String dataFormazioneAmbientale;
  final String dataFormazioneRentri;

  // Documenti personali
  final String scadenzaPatente;
  final String scadenzaCartaTachigrafica;
  final String scadenzaCartaIdentita;
  final String scadenzaFirmaDigitale;
  final String scadenzaPermessoSoggiorno;
  final String scadenzaContratto;

  final String note;

  /// Note libere per singola scadenza (es. "prenotato"), indicizzate per
  /// l'etichetta della scadenza (vedi [_vociScadenza] in amministrazione_screen.dart).
  final Map<String, String> noteScadenze;

  String get nomeCompleto => '$nome $cognome';
}
