import 'package:flutter/foundation.dart';
import 'package:pocketbase/pocketbase.dart';

import '../models/macchinario.dart';
import '../services/pocketbase_service.dart';
import '../l10n/app_localizations.dart';
import 'locale_provider.dart';

class MacchinariProvider extends ChangeNotifier {
  final PocketBase _pb = PocketBaseService.instance.pb;

  List<Macchinario> _macchinari = [];
  List<Macchinario> get macchinari => _macchinari;

  bool isLoading = false;
  String? errorMessage;

  Future<void> load() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      final records = await _pb
          .collection('macchinari')
          .getFullList(sort: 'modello');
      _macchinari = records.map(Macchinario.fromRecord).toList();
    } on ClientException catch (e) {
      errorMessage =
          e.response['message'] as String? ??
          lookupAppLocalizations(LocaleProvider.current).errorLoadingMacchinari;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> create({
    required String modello,
    String? numeroMatricola,
    String? numeroFabbrica,
    String? tipologia,
    int? annoAcquisto,
    String? proprieta,
    String? nomeLeasing,
    DateTime? scadenzaLeasing,
    String? nomeNoleggio,
    String? emailNoleggio,
    bool presenteInCivaInail = false,
    bool inUso = true,
    bool inMagazzino = false,
    String? ubicazioneCantiereId,
    String? ubicazioneAutomezzoId,
    String? nomeAssicurazione,
    DateTime? scadenzaAssicurazione,
    DateTime? dataManutenzioneInterna,
    DateTime? scadenzaManutenzioneInterna,
    DateTime? dataControlloFuniCatene,
    DateTime? scadenzaControlloFuniCatene,
    DateTime? dataVerificaAnnuale,
    DateTime? scadenzaVerificaAnnuale,
    DateTime? dataVerificaVentennale,
    DateTime? scadenzaVerificaVentennale,
    String? note,
  }) async {
    await _pb
        .collection('macchinari')
        .create(
          body: {
            'modello': modello,
            'numero_matricola': numeroMatricola ?? '',
            'numero_fabbrica': numeroFabbrica ?? '',
            'note': note ?? '',
            'tipologia': ?tipologia,
            'anno_acquisto': ?annoAcquisto,
            'proprieta': ?proprieta,
            'nome_leasing': nomeLeasing ?? '',
            if (scadenzaLeasing != null) 
              'scadenza_leasing': scadenzaLeasing.toIso8601String(), 
            'nome_noleggio': nomeNoleggio ?? '',
            'email_noleggiatore': emailNoleggio ?? '',
            'presente_in_civa_inail': presenteInCivaInail,
            'in_uso': inUso,
            'in_magazzino': inMagazzino,
            if (ubicazioneCantiereId != null && ubicazioneCantiereId.isNotEmpty)
              'ubicazione_cantiere': ubicazioneCantiereId,
            if (ubicazioneAutomezzoId != null &&
                ubicazioneAutomezzoId.isNotEmpty)
              'ubicazione_automezzo': ubicazioneAutomezzoId,
            'nome_assicurazione': nomeAssicurazione ?? '',
            if (scadenzaAssicurazione != null)
              'scadenza_assicurazione': scadenzaAssicurazione.toIso8601String(),
            if (dataManutenzioneInterna != null)
              'data_manutenzione_interna': dataManutenzioneInterna.toIso8601String(),
            if (scadenzaManutenzioneInterna != null)
              'scadenza_manutenzione_interna': scadenzaManutenzioneInterna.toIso8601String(),
            if (dataControlloFuniCatene != null)
              'data_controllo_funi_catene': dataControlloFuniCatene.toIso8601String(),
            if (scadenzaControlloFuniCatene != null)
              'scadenza_controllo_funi_catene': scadenzaControlloFuniCatene.toIso8601String(),
            if (dataVerificaAnnuale != null)
              'data_verifica_annuale': dataVerificaAnnuale.toIso8601String(),
            if (scadenzaVerificaAnnuale != null)
              'scadenza_verifica_annuale': scadenzaVerificaAnnuale.toIso8601String(),
            if (dataVerificaVentennale != null)
              'data_verifica_ventennale': dataVerificaVentennale.toIso8601String(),
            if (scadenzaVerificaVentennale != null)
              'scadenza_verifica_ventennale': scadenzaVerificaVentennale.toIso8601String(),
          },
        );
    await load();
  }

  Future<void> update(
    String id, {
    required String modello,
    String? numeroMatricola,
    String? numeroFabbrica,
    String? tipologia,
    int? annoAcquisto,
    String? proprieta,
    String? nomeLeasing,
    DateTime? scadenzaLeasing,
    String? nomeNoleggio,
    String? emailNoleggio,
    bool presenteInCivaInail = false,
    bool inUso = true,
    bool inMagazzino = false,
    String? ubicazioneCantiereId,
    String? ubicazioneAutomezzoId,
    String? nomeAssicurazione,
    DateTime? scadenzaAssicurazione,
    DateTime? dataManutenzioneInterna,
    DateTime? scadenzaManutenzioneInterna,
    DateTime? dataControlloFuniCatene,
    DateTime? scadenzaControlloFuniCatene,
    DateTime? dataVerificaAnnuale,
    DateTime? scadenzaVerificaAnnuale,
    DateTime? dataVerificaVentennale,
    DateTime? scadenzaVerificaVentennale,
    String? note,
  }) async {
    await _pb
        .collection('macchinari')
        .update(
          id,
          body: {
            'modello': modello,
            'numero_matricola': numeroMatricola ?? '',
            'numero_fabbrica': numeroFabbrica ?? '',
            'note': note ?? '',
            'tipologia': ?tipologia,
            'anno_acquisto': ?annoAcquisto,
            'proprieta': ?proprieta,
            'nome_leasing': nomeLeasing ?? '',
            if (scadenzaLeasing != null) 
              'scadenza_leasing': scadenzaLeasing.toIso8601String(), 
            'nome_noleggio': nomeNoleggio ?? '',
            'email_noleggiatore': emailNoleggio ?? '',
            'presente_in_civa_inail': presenteInCivaInail,
            'in_uso': inUso,
            'in_magazzino': inMagazzino,
            if (ubicazioneCantiereId != null && ubicazioneCantiereId.isNotEmpty)
              'ubicazione_cantiere': ubicazioneCantiereId,
            if (ubicazioneAutomezzoId != null &&
                ubicazioneAutomezzoId.isNotEmpty)
              'ubicazione_automezzo': ubicazioneAutomezzoId,
            'nome_assicurazione': nomeAssicurazione ?? '',
            if (scadenzaAssicurazione != null)
              'scadenza_assicurazione': scadenzaAssicurazione.toIso8601String(),
            if (dataManutenzioneInterna != null)
              'data_manutenzione_interna': dataManutenzioneInterna.toIso8601String(),
            if (scadenzaManutenzioneInterna != null)
              'scadenza_manutenzione_interna': scadenzaManutenzioneInterna.toIso8601String(),
            if (dataControlloFuniCatene != null)
              'data_controllo_funi_catene': dataControlloFuniCatene.toIso8601String(),
            if (scadenzaControlloFuniCatene != null)
              'scadenza_controllo_funi_catene': scadenzaControlloFuniCatene.toIso8601String(),
            if (dataVerificaAnnuale != null)
              'data_verifica_annuale': dataVerificaAnnuale.toIso8601String(),
            if (scadenzaVerificaAnnuale != null)
              'scadenza_verifica_annuale': scadenzaVerificaAnnuale.toIso8601String(),
            if (dataVerificaVentennale != null)
              'data_verifica_ventennale': dataVerificaVentennale.toIso8601String(),
            if (scadenzaVerificaVentennale != null)
              'scadenza_verifica_ventennale': scadenzaVerificaVentennale.toIso8601String(),
          },
        );
    await load();
  }

  Future<void> updateNote(String id, String note) async {
    await _pb.collection('macchinari').update(id, body: {'note': note});
    await load();
  }

  /// Nota libera per una singola scadenza del macchinario (es. "prenotato"),
  /// indipendente dalla nota generale del macchinario.
  Future<void> updateNotaScadenza(
    Macchinario macchinario,
    String tipo,
    String nota,
  ) async {
    final noteScadenze = Map<String, String>.from(macchinario.noteScadenze);
    if (nota.isEmpty) {
      noteScadenze.remove(tipo);
    } else {
      noteScadenze[tipo] = nota;
    }
    await _pb
        .collection('macchinari')
        .update(macchinario.id, body: {'note_scadenze': noteScadenze});
    await load();
  }

  Future<void> delete(String id) async {
    await _pb.collection('macchinari').delete(id);
    await load();
  }
}
