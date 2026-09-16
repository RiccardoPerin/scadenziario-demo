import 'package:flutter/foundation.dart';
import 'package:pocketbase/pocketbase.dart';

import '../models/impianto.dart';
import '../services/pocketbase_service.dart';
import '../l10n/app_localizations.dart';
import 'locale_provider.dart';

class ImpiantiProvider extends ChangeNotifier {
  final PocketBase _pb = PocketBaseService.instance.pb;

  List<Impianto> _impianti = [];
  List<Impianto> get impianti => _impianti;

  bool isLoading = false;
  String? errorMessage;

  Future<void> load() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      final records = await _pb
          .collection('impianti')
          .getFullList(sort: 'tipologia');
      _impianti = records.map(Impianto.fromRecord).toList();
    } on ClientException catch (e) {
      errorMessage =
          e.response['message'] as String? ??
          lookupAppLocalizations(LocaleProvider.current).errorLoadingImpianti;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> create({
    required String tipologia,
    bool inUfficio = false,
    bool inMagazzino = false,
    String? dittaInstallatrice,
    String? tipoVerificaEsternaEffettuata,
    String? tipoVerificaInternaEffettuata,
    DateTime? dataInstallazione,
    DateTime? dataValutazione,
    DateTime? dataManutenzioneInterna,
    DateTime? scadenzaManutenzioneInterna,
    DateTime? dataManutenzioneEsterna,
    DateTime? scadenzaManutenzioneEsterna,
    DateTime? scadenzaValutazioneScaricheAtmosferiche,
    String? note,
  }) async {
    await _pb
        .collection('impianti')
        .create(
          body: {
            'tipologia': tipologia,
            'in_ufficio': inUfficio,
            'in_magazzino': inMagazzino,
            if (dataInstallazione != null)
              'data_installazione': dataInstallazione.toIso8601String(),
            'ditta_installatrice': dittaInstallatrice ?? '',
            if (dataValutazione != null)
              'data_valutazione': dataValutazione.toIso8601String(),
            if (dataManutenzioneInterna != null)
              'data_manutenzione_interna': dataManutenzioneInterna.toIso8601String(),
            if (scadenzaManutenzioneInterna != null)
              'scadenza_manutenzione_interna': scadenzaManutenzioneInterna.toIso8601String(),
            'tipo_verifica_interna_effettuata': tipoVerificaInternaEffettuata ?? '',
            if (dataManutenzioneEsterna != null)
              'data_manutenzione_esterna': dataManutenzioneEsterna.toIso8601String(),
            if (scadenzaManutenzioneEsterna != null)
              'scadenza_manutenzione_esterna': scadenzaManutenzioneEsterna.toIso8601String(),
            'tipo_verifica_esterna_effettuata': tipoVerificaEsternaEffettuata ?? '',
            if (scadenzaValutazioneScaricheAtmosferiche != null) 
              'scadenza_valutazione_scariche_atmosferiche': scadenzaValutazioneScaricheAtmosferiche.toIso8601String(),
            'note': note ?? '',
          },
        );
    await load();
  }

  Future<void> update(
    String id, {
    required String tipologia,
    bool inUfficio = false,
    bool inMagazzino = false,
    String? dittaInstallatrice,
    String? tipoVerificaEsternaEffettuata,
    String? tipoVerificaInternaEffettuata,
    DateTime? dataInstallazione,
    DateTime? dataValutazione,
    DateTime? dataManutenzioneInterna,
    DateTime? scadenzaManutenzioneInterna,
    DateTime? dataManutenzioneEsterna,
    DateTime? scadenzaManutenzioneEsterna,
    DateTime? scadenzaValutazioneScaricheAtmosferiche,
    String? note,
  }) async {
    await _pb
        .collection('impianti')
        .update(
          id,
          body: {
            'tipologia': tipologia,
            'in_ufficio': inUfficio,
            'in_magazzino': inMagazzino,
            if (dataInstallazione != null)
              'data_installazione': dataInstallazione.toIso8601String(),
            'ditta_installatrice': dittaInstallatrice ?? '',
            if (dataValutazione != null)
              'data_valutazione': dataValutazione.toIso8601String(),
            if (dataManutenzioneInterna != null)
              'data_manutenzione_interna': dataManutenzioneInterna.toIso8601String(),
            if (scadenzaManutenzioneInterna != null)
              'scadenza_manutenzione_interna': scadenzaManutenzioneInterna.toIso8601String(),
            'tipo_verifica_interna_effettuata': tipoVerificaInternaEffettuata ?? '',
            if (dataManutenzioneEsterna != null)
              'data_manutenzione_esterna': dataManutenzioneEsterna.toIso8601String(),
            if (scadenzaManutenzioneEsterna != null)
              'scadenza_manutenzione_esterna': scadenzaManutenzioneEsterna.toIso8601String(),
            'tipo_verifica_esterna_effettuata': tipoVerificaEsternaEffettuata ?? '',
            if (scadenzaValutazioneScaricheAtmosferiche != null) 
              'scadenza_valutazione_scariche_atmosferiche': scadenzaValutazioneScaricheAtmosferiche.toIso8601String(),
            'note': note ?? '',
          },
        );
    await load();
  }

  Future<void> delete(String id) async {
    await _pb.collection('impianti').delete(id);
    await load();
  }

  Future<void> updateNote(String id, String note) async {
    await _pb.collection('impianti').update(id, body: {'note': note});
    await load();
  }

  Future<void> updateNotaScadenza(
    Impianto impianto,
    String tipo,
    String nota,
  ) async {
    final noteScadenze = Map<String, String>.from(impianto.noteScadenze);
    if (nota.isEmpty) {
      noteScadenze.remove(tipo);
    } else {
      noteScadenze[tipo] = nota;
    }
    await _pb
        .collection('impianti')
        .update(impianto.id, body: {'note_scadenze': noteScadenze});
    await load();
  }
}
