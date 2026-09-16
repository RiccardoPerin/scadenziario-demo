import 'package:flutter/foundation.dart';
import 'package:pocketbase/pocketbase.dart';

import '../models/controllo_segnale.dart';
import '../services/pocketbase_service.dart';
import '../l10n/app_localizations.dart';
import 'locale_provider.dart';

class ControlliSegnaliProvider extends ChangeNotifier {
  final PocketBase _pb = PocketBaseService.instance.pb;

  List<ControlloSegnale> _controlli = [];
  List<ControlloSegnale> get controlli => _controlli;

  bool isLoading = false;
  String? errorMessage;

  Future<void> load() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      final records = await _pb
          .collection('controlli_segnaletica')
          .getFullList(sort: '-data_ispezione', expand: 'segnale');
      _controlli = records.map(ControlloSegnale.fromRecord).toList();
    } on ClientException catch (e) {
      errorMessage =
          e.response['message'] as String? ??
          lookupAppLocalizations(LocaleProvider.current).errorLoadingControlli;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Controlli di un singolo segnale, dal più recente al più vecchio.
  List<ControlloSegnale> perSegnale(String segnaleId) =>
      _controlli.where((c) => c.segnaleId == segnaleId).toList();

  /// Ultimo controllo registrato per un segnale, `null` se mai controllato.
  ControlloSegnale? ultimoControllo(String segnaleId) {
    for (final c in _controlli) {
      if (c.segnaleId == segnaleId) return c;
    }
    return null;
  }

  Future<String> create({
    required String segnaleId,
    DateTime? dataIspezione,
    bool esiste = true,
    bool posizioneIdonea = true,
    bool buonoStato = true,
    String? note,
  }) async {
    final record = await _creaRecord(
      segnaleId: segnaleId,
      dataIspezione: dataIspezione,
      esiste: esiste,
      posizioneIdonea: posizioneIdonea,
      buonoStato: buonoStato,
      note: note,
    );
    await load();
    return record.id;
  }

  /// Registra lo stesso controllo su più cartelli in un colpo solo (caso
  /// tipico: giro di verifica di una zona andato tutto bene).
  ///
  /// I record vengono creati uno alla volta e la lista viene ricaricata una
  /// volta sola alla fine, anche se qualcosa fallisce a metà: così l'elenco
  /// mostra comunque i controlli già registrati prima dell'errore.
  Future<void> createMultipli({
    required List<String> segnaliIds,
    DateTime? dataIspezione,
    bool esiste = true,
    bool posizioneIdonea = true,
    bool buonoStato = true,
    String? note,
  }) async {
    try {
      for (final segnaleId in segnaliIds) {
        await _creaRecord(
          segnaleId: segnaleId,
          dataIspezione: dataIspezione,
          esiste: esiste,
          posizioneIdonea: posizioneIdonea,
          buonoStato: buonoStato,
          note: note,
        );
      }
    } finally {
      await load();
    }
  }

  Future<RecordModel> _creaRecord({
    required String segnaleId,
    DateTime? dataIspezione,
    required bool esiste,
    required bool posizioneIdonea,
    required bool buonoStato,
    String? note,
  }) {
    return _pb
        .collection('controlli_segnaletica')
        .create(
          body: {
            'segnale': segnaleId,
            if (dataIspezione != null)
              'data_ispezione': dataIspezione.toIso8601String(),
            'esiste': esiste,
            'posizione_idonea': posizioneIdonea,
            'buono_stato': buonoStato,
            'note': note ?? '',
          },
        );
  }

  Future<void> update(
    String id, {
    required String segnaleId,
    DateTime? dataIspezione,
    bool esiste = true,
    bool posizioneIdonea = true,
    bool buonoStato = true,
    String? note,
  }) async {
    await _pb
        .collection('controlli_segnaletica')
        .update(
          id,
          body: {
            'segnale': segnaleId,
            // Stringa vuota anziché omissione: in update serve a svuotare la
            // data se l'utente la cancella dal form.
            'data_ispezione': dataIspezione?.toIso8601String() ?? '',
            'esiste': esiste,
            'posizione_idonea': posizioneIdonea,
            'buono_stato': buonoStato,
            'note': note ?? '',
          },
        );
    await load();
  }

  Future<void> delete(String id) async {
    await _pb.collection('controlli_segnaletica').delete(id);
    await load();
  }

  Future<void> updateNote(String id, String note) async {
    await _pb.collection('controlli_segnaletica').update(
      id,
      body: {'note': note},
    );
    await load();
  }
}
