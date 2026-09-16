import 'package:flutter/foundation.dart';
import 'package:pocketbase/pocketbase.dart';

import '../models/dipendente_aziendale.dart';
import '../services/pocketbase_service.dart';
import '../l10n/app_localizations.dart';
import 'locale_provider.dart';

class DipendentiAziendaliProvider extends ChangeNotifier {
  final PocketBase _pb = PocketBaseService.instance.pb;

  List<DipendenteAziendale> _dipendenti = [];
  List<DipendenteAziendale> get dipendenti => _dipendenti;

  bool isLoading = false;
  String? errorMessage;

  Future<void> load() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      final records = await _pb
          .collection('dipendenti_aziendali')
          .getFullList(sort: 'cognome,nome');
      _dipendenti = records.map(DipendenteAziendale.fromRecord).toList();
      await _allineaEtaSalvate();
    } on ClientException catch (e) {
      errorMessage =
          e.response['message'] as String? ??
          lookupAppLocalizations(LocaleProvider.current).errorLoadingDipendentiAziendali;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Corpo comune a create/update. Le date non valorizzate vengono salvate come
  /// stringa vuota, così da poterle anche azzerare dal form.
  Map<String, dynamic> _body({
    required String nome,
    required String cognome,
    String? codiceFiscale,
    String? mansione,
    String? luogoNascita,
    String? eta,
    DateTime? dataNascita,
    DateTime? dataAssunzione,
    DateTime? scadenzaVisitaMedica,
    DateTime? scadenzaCodiceFiscale,
    DateTime? scadenzaFormazioneSicurezza,
    DateTime? scadenzaLavoriQuota,
    DateTime? scadenzaAntitetanica,
    DateTime? scadenzaGruAutocarro,
    DateTime? scadenzaGruTorre,
    DateTime? scadenzaCarrelloElevatoreSemovente,
    DateTime? scadenzaConduzioneEscavatori,
    DateTime? scadenzaPiattaformeElevatrici,
    DateTime? scadenzaPonteggi,
    DateTime? scadenzaScaffalature,
    DateTime? scadenzaCorsoDisocianati,
    DateTime? scadenzaCorsoCronotachigrafico,
    DateTime? scadenzaPreposto,
    DateTime? scadenzaAntincendio,
    DateTime? scadenzaPrimoSoccorso,
    DateTime? scadenzaRspp,
    DateTime? scadenzaRlst,
    DateTime? scadenzaPatente,
    DateTime? scadenzaCartaTachigrafica,
    DateTime? scadenzaCartaIdentita,
    DateTime? scadenzaFirmaDigitale,
    DateTime? scadenzaPermessoSoggiorno,
    DateTime? scadenzaContratto,
    DateTime? dataFormazione231,
    DateTime? dataFormazioneAmbientale,
    DateTime? dataFormazioneRentri,
    String? note,
  }) {
    String iso(DateTime? d) => d?.toIso8601String() ?? '';
    return {
      'nome': nome,
      'cognome': cognome,
      'codice_fiscale': codiceFiscale ?? '',
      'mansione': mansione ?? '',
      'luogo_di_nascita': luogoNascita ?? '',
      // Se c'è la data di nascita l'età è derivata, così su PocketBase non
      // finisce mai un valore incoerente con la data salvata.
      'eta': dataNascita != null ? calcoloEta(dataNascita) : (eta ?? ''),
      'data_di_nascita': iso(dataNascita),
      'data_assunzione': iso(dataAssunzione),
      'scadenza_visita_medica': iso(scadenzaVisitaMedica),
      'scadenza_codice_fiscale': iso(scadenzaCodiceFiscale),
      'scadenza_formazione_sicurezza': iso(scadenzaFormazioneSicurezza),
      'scadenza_lavori_in_quota': iso(scadenzaLavoriQuota),
      'scadenza_antitetanica': iso(scadenzaAntitetanica),
      'scadenza_gru_autocarro': iso(scadenzaGruAutocarro),
      'scadenza_gru_torre': iso(scadenzaGruTorre),
      'scadenza_carrelli_elevatori_semoventi': iso(
        scadenzaCarrelloElevatoreSemovente,
      ),
      'scadenza_conduzione_escavatori': iso(scadenzaConduzioneEscavatori),
      'scadenza_piattaforme_elevatrici': iso(scadenzaPiattaformeElevatrici),
      'scadenza_montaggio_smontaggio_ponteggi': iso(scadenzaPonteggi),
      'scadenza_corso_scaffalature': iso(scadenzaScaffalature),
      'scadenza_corso_disocianati': iso(scadenzaCorsoDisocianati),
      'scadenza_corso_cronotachigrafico': iso(scadenzaCorsoCronotachigrafico),
      'scadenza_preposto': iso(scadenzaPreposto),
      'scadenza_antincendio': iso(scadenzaAntincendio),
      'scadenza_primo_soccorso': iso(scadenzaPrimoSoccorso),
      'scadenza_rspp': iso(scadenzaRspp),
      'scadenza_rlst': iso(scadenzaRlst),
      'scadenza_patente': iso(scadenzaPatente),
      'scadenza_carta_tachigrafica': iso(scadenzaCartaTachigrafica),
      'scadenza_carta_identita': iso(scadenzaCartaIdentita),
      'scadenza_firma_digitale': iso(scadenzaFirmaDigitale),
      'scadenza_permesso_soggiorno': iso(scadenzaPermessoSoggiorno),
      'scadenza_contratto': iso(scadenzaContratto),
      'data_formazione_modello_231': iso(dataFormazione231),
      'data_formazione_sistema_gestione_ambientale': iso(
        dataFormazioneAmbientale,
      ),
      'data_formazione_rentri': iso(dataFormazioneRentri),
      'note': note ?? '',
    };
  }

  Future<void> create({
    required String nome,
    required String cognome,
    String? codiceFiscale,
    String? mansione,
    String? luogoNascita,
    String? eta,
    DateTime? dataNascita,
    DateTime? dataAssunzione,
    DateTime? scadenzaVisitaMedica,
    DateTime? scadenzaCodiceFiscale,
    DateTime? scadenzaFormazioneSicurezza,
    DateTime? scadenzaLavoriQuota,
    DateTime? scadenzaAntitetanica,
    DateTime? scadenzaGruAutocarro,
    DateTime? scadenzaGruTorre,
    DateTime? scadenzaCarrelloElevatoreSemovente,
    DateTime? scadenzaConduzioneEscavatori,
    DateTime? scadenzaPiattaformeElevatrici,
    DateTime? scadenzaPonteggi,
    DateTime? scadenzaScaffalature,
    DateTime? scadenzaCorsoDisocianati,
    DateTime? scadenzaCorsoCronotachigrafico,
    DateTime? scadenzaPreposto,
    DateTime? scadenzaAntincendio,
    DateTime? scadenzaPrimoSoccorso,
    DateTime? scadenzaRspp,
    DateTime? scadenzaRlst,
    DateTime? scadenzaPatente,
    DateTime? scadenzaCartaTachigrafica,
    DateTime? scadenzaCartaIdentita,
    DateTime? scadenzaFirmaDigitale,
    DateTime? scadenzaPermessoSoggiorno,
    DateTime? scadenzaContratto,
    DateTime? dataFormazione231,
    DateTime? dataFormazioneAmbientale,
    DateTime? dataFormazioneRentri,
    String? note,
  }) async {
    await _pb
        .collection('dipendenti_aziendali')
        .create(
          body: _body(
            nome: nome,
            cognome: cognome,
            codiceFiscale: codiceFiscale,
            mansione: mansione,
            luogoNascita: luogoNascita,
            eta: eta,
            dataNascita: dataNascita,
            dataAssunzione: dataAssunzione,
            scadenzaVisitaMedica: scadenzaVisitaMedica,
            scadenzaCodiceFiscale: scadenzaCodiceFiscale,
            scadenzaFormazioneSicurezza: scadenzaFormazioneSicurezza,
            scadenzaLavoriQuota: scadenzaLavoriQuota,
            scadenzaAntitetanica: scadenzaAntitetanica,
            scadenzaGruAutocarro: scadenzaGruAutocarro,
            scadenzaGruTorre: scadenzaGruTorre,
            scadenzaCarrelloElevatoreSemovente:
                scadenzaCarrelloElevatoreSemovente,
            scadenzaConduzioneEscavatori: scadenzaConduzioneEscavatori,
            scadenzaPiattaformeElevatrici: scadenzaPiattaformeElevatrici,
            scadenzaPonteggi: scadenzaPonteggi,
            scadenzaScaffalature: scadenzaScaffalature,
            scadenzaCorsoDisocianati: scadenzaCorsoDisocianati,
            scadenzaCorsoCronotachigrafico: scadenzaCorsoCronotachigrafico,
            scadenzaPreposto: scadenzaPreposto,
            scadenzaAntincendio: scadenzaAntincendio,
            scadenzaPrimoSoccorso: scadenzaPrimoSoccorso,
            scadenzaRspp: scadenzaRspp,
            scadenzaRlst: scadenzaRlst,
            scadenzaPatente: scadenzaPatente,
            scadenzaCartaTachigrafica: scadenzaCartaTachigrafica,
            scadenzaCartaIdentita: scadenzaCartaIdentita,
            scadenzaFirmaDigitale: scadenzaFirmaDigitale,
            scadenzaPermessoSoggiorno: scadenzaPermessoSoggiorno,
            scadenzaContratto: scadenzaContratto,
            dataFormazione231: dataFormazione231,
            dataFormazioneAmbientale: dataFormazioneAmbientale,
            dataFormazioneRentri: dataFormazioneRentri,
            note: note,
          ),
        );
    await load();
  }

  Future<void> update(
    String id, {
    required String nome,
    required String cognome,
    String? codiceFiscale,
    String? mansione,
    String? luogoNascita,
    String? eta,
    DateTime? dataNascita,
    DateTime? dataAssunzione,
    DateTime? scadenzaVisitaMedica,
    DateTime? scadenzaCodiceFiscale,
    DateTime? scadenzaFormazioneSicurezza,
    DateTime? scadenzaLavoriQuota,
    DateTime? scadenzaAntitetanica,
    DateTime? scadenzaGruAutocarro,
    DateTime? scadenzaGruTorre,
    DateTime? scadenzaCarrelloElevatoreSemovente,
    DateTime? scadenzaConduzioneEscavatori,
    DateTime? scadenzaPiattaformeElevatrici,
    DateTime? scadenzaPonteggi,
    DateTime? scadenzaScaffalature,
    DateTime? scadenzaCorsoDisocianati,
    DateTime? scadenzaCorsoCronotachigrafico,
    DateTime? scadenzaPreposto,
    DateTime? scadenzaAntincendio,
    DateTime? scadenzaPrimoSoccorso,
    DateTime? scadenzaRspp,
    DateTime? scadenzaRlst,
    DateTime? scadenzaPatente,
    DateTime? scadenzaCartaTachigrafica,
    DateTime? scadenzaCartaIdentita,
    DateTime? scadenzaFirmaDigitale,
    DateTime? scadenzaPermessoSoggiorno,
    DateTime? scadenzaContratto,
    DateTime? dataFormazione231,
    DateTime? dataFormazioneAmbientale,
    DateTime? dataFormazioneRentri,
    String? note,
  }) async {
    await _pb
        .collection('dipendenti_aziendali')
        .update(
          id,
          body: _body(
            nome: nome,
            cognome: cognome,
            codiceFiscale: codiceFiscale,
            mansione: mansione,
            luogoNascita: luogoNascita,
            eta: eta,
            dataNascita: dataNascita,
            dataAssunzione: dataAssunzione,
            scadenzaVisitaMedica: scadenzaVisitaMedica,
            scadenzaCodiceFiscale: scadenzaCodiceFiscale,
            scadenzaFormazioneSicurezza: scadenzaFormazioneSicurezza,
            scadenzaLavoriQuota: scadenzaLavoriQuota,
            scadenzaAntitetanica: scadenzaAntitetanica,
            scadenzaGruAutocarro: scadenzaGruAutocarro,
            scadenzaGruTorre: scadenzaGruTorre,
            scadenzaCarrelloElevatoreSemovente:
                scadenzaCarrelloElevatoreSemovente,
            scadenzaConduzioneEscavatori: scadenzaConduzioneEscavatori,
            scadenzaPiattaformeElevatrici: scadenzaPiattaformeElevatrici,
            scadenzaPonteggi: scadenzaPonteggi,
            scadenzaScaffalature: scadenzaScaffalature,
            scadenzaCorsoDisocianati: scadenzaCorsoDisocianati,
            scadenzaCorsoCronotachigrafico: scadenzaCorsoCronotachigrafico,
            scadenzaPreposto: scadenzaPreposto,
            scadenzaAntincendio: scadenzaAntincendio,
            scadenzaPrimoSoccorso: scadenzaPrimoSoccorso,
            scadenzaRspp: scadenzaRspp,
            scadenzaRlst: scadenzaRlst,
            scadenzaPatente: scadenzaPatente,
            scadenzaCartaTachigrafica: scadenzaCartaTachigrafica,
            scadenzaCartaIdentita: scadenzaCartaIdentita,
            scadenzaFirmaDigitale: scadenzaFirmaDigitale,
            scadenzaPermessoSoggiorno: scadenzaPermessoSoggiorno,
            scadenzaContratto: scadenzaContratto,
            dataFormazione231: dataFormazione231,
            dataFormazioneAmbientale: dataFormazioneAmbientale,
            dataFormazioneRentri: dataFormazioneRentri,
            note: note,
          ),
        );
    await load();
  }

  Future<void> updateNote(String id, String note) async {
    await _pb
        .collection('dipendenti_aziendali')
        .update(id, body: {'note': note});
    await load();
  }

  /// Nota libera per una singola scadenza del dipendente (es. "prenotato"),
  /// indipendente dalla nota generale del dipendente.
  Future<void> updateNotaScadenza(
    DipendenteAziendale dipendente,
    String tipo,
    String nota,
  ) async {
    final noteScadenze = Map<String, String>.from(dipendente.noteScadenze);
    if (nota.isEmpty) {
      noteScadenze.remove(tipo);
    } else {
      noteScadenze[tipo] = nota;
    }
    await _pb
        .collection('dipendenti_aziendali')
        .update(dipendente.id, body: {'note_scadenze': noteScadenze});
    await load();
  }

  Future<void> delete(String id) async {
    await _pb.collection('dipendenti_aziendali').delete(id);
    await load();
  }

  /// Riallinea su PocketBase l'`eta` dei dipendenti che nel frattempo hanno
  /// compiuto gli anni, così il valore salvato resta corretto anche fuori
  /// dall'app. Un eventuale errore non deve far fallire il caricamento.
  Future<void> _allineaEtaSalvate() async {
    for (final dipendente in _dipendenti) {
      final eta = calcoloEtaDipendente(dipendente);
      if (eta == dipendente.eta) continue;
      try {
        await _pb
            .collection('dipendenti_aziendali')
            .update(dipendente.id, body: {'eta': eta});
      } on ClientException catch (e) {
        debugPrint(
          'Impossibile aggiornare l\'età di ${dipendente.id}: ${e.response['message'] ?? e}',
        );
      }
    }
  }

  /// Età ricavata dalla data di nascita: essendo calcolata al momento, si
  /// aggiorna da sola quando il dipendente compie gli anni.
  String calcoloEta(DateTime? dataNascita) {
    if (dataNascita == null) return '';
    final oggi = DateTime.now();
    var eta = oggi.year - dataNascita.year;

    if (oggi.month < dataNascita.month ||
        (oggi.month == dataNascita.month && oggi.day < dataNascita.day)) {
      eta--;
    }
    return eta < 0 ? '' : eta.toString();
  }

  /// Età del dipendente a partire dalla data di nascita salvata; se non è
  /// valorizzata si usa il campo `eta` inserito a mano.
  String calcoloEtaDipendente(DipendenteAziendale dipendente) {
    final dataNascita = DateTime.tryParse(dipendente.dataNascita);
    return dataNascita == null ? dipendente.eta : calcoloEta(dataNascita);
  }
}
