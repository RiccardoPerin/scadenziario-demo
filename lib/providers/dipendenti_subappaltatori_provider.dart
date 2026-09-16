import 'package:flutter/foundation.dart';
import 'package:pocketbase/pocketbase.dart';

import '../models/dipendente_subappaltatore.dart';
import '../services/pocketbase_service.dart';
import 'lista_locale.dart';
import '../l10n/app_localizations.dart';
import 'locale_provider.dart';

class DipendentiSubappaltatoriProvider extends ChangeNotifier {
  final PocketBase _pb = PocketBaseService.instance.pb;

  List<DipendenteSubappaltatore> _dipendenti = [];
  List<DipendenteSubappaltatore> get dipendenti => _dipendenti;

  bool isLoading = false;
  String? errorMessage;

  Future<void> load() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      final records = await _pb.collection('dipendenti_subappaltatori').getFullList(sort: 'cognome');
      _dipendenti = records.map(DipendenteSubappaltatore.fromRecord).toList();
    } on ClientException catch (e) {
      errorMessage = e.response['message'] as String? ?? lookupAppLocalizations(LocaleProvider.current).errorLoadingDipendentiSubappaltatori;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Stesso ordinamento del `sort: 'cognome'` usato in [load].
  static int _perCognome(DipendenteSubappaltatore a, DipendenteSubappaltatore b) =>
      a.cognome.compareTo(b.cognome);

  /// Dipendenti di un subappaltatore.
  List<DipendenteSubappaltatore> perSubappaltatore(String subappaltatoreId) {
    return _dipendenti.where((d) => d.subappaltatoreId == subappaltatoreId).toList();
  }

  /// Dipendenti presenti in un cantiere (di qualsiasi subappaltatore).
  List<DipendenteSubappaltatore> perCantiere(String cantiereId) {
    return _dipendenti.where((d) => d.cantieriIds.contains(cantiereId)).toList();
  }

  Future<void> create({
    required String nome,
    required String cognome,
    required bool lavoratoreAutonomo,
    required String note,
    String? subappaltatoreId,
  }) async {
    final record = await _pb.collection('dipendenti_subappaltatori').create(body: {
      'nome': nome,
      'cognome': cognome,
      'lavoratore_autonomo': lavoratoreAutonomo,
      'note': note,
      'subappaltatore': ?subappaltatoreId,
    });
    inserisciOrdinato(_dipendenti, DipendenteSubappaltatore.fromRecord(record), _perCognome);
    notifyListeners();
  }

  Future<void> update(
    String id, {
    required String nome,
    required String cognome,
    required bool lavoratoreAutonomo,
    required String note,
  }) async {
    final record = await _pb.collection('dipendenti_subappaltatori').update(id, body: {
      'nome': nome,
      'cognome': cognome,
      'lavoratore_autonomo': lavoratoreAutonomo,
      'note': note,
    });
    _sostituisci(DipendenteSubappaltatore.fromRecord(record));
  }

  /// Imposta l'elenco completo dei cantieri in cui il dipendente è presente.
  Future<void> setCantieri(String dipendenteId, List<String> cantieriIds) async {
    final record = await _pb.collection('dipendenti_subappaltatori').update(dipendenteId, body: {
      'cantieri': cantieriIds,
    });
    _sostituisci(DipendenteSubappaltatore.fromRecord(record));
  }

  Future<void> addCantiere(String dipendenteId, String cantiereId) async {
    final record = await _pb.collection('dipendenti_subappaltatori').update(dipendenteId, body: {
      'cantieri+': cantiereId,
    });
    _sostituisci(DipendenteSubappaltatore.fromRecord(record));
  }

  Future<void> removeCantiere(String dipendenteId, String cantiereId) async {
    final record = await _pb.collection('dipendenti_subappaltatori').update(dipendenteId, body: {
      'cantieri-': cantiereId,
    });
    _sostituisci(DipendenteSubappaltatore.fromRecord(record));
  }

  /// Elimina il dipendente. I suoi documenti li elimina PocketBase a cascata:
  /// va riallineato `DocumentiProvider`, cosa di cui si occupa
  /// `eliminaDipendenteSubappaltatoreConTracce`.
  Future<void> delete(String id) async {
    await _pb.collection('dipendenti_subappaltatori').delete(id);
    rimuoviLocale(_dipendenti, {id}, (d) => d.id);
    notifyListeners();
  }

  /// Rimuove un cantiere dai dipendenti di un subappaltatore che vi erano
  /// segnati presenti: da chiamare quando il subappaltatore viene scollegato
  /// da quel cantiere, per evitare che restino segnati come presenti.
  Future<void> rimuoviCantiereDaiDipendentiDiSubappaltatore(
    String subappaltatoreId,
    String cantiereId,
  ) async {
    await _rimuoviCantiereDa(
      perSubappaltatore(subappaltatoreId).where((d) => d.cantieriIds.contains(cantiereId)),
      cantiereId,
    );
  }

  /// Rimuove un cantiere da tutti i dipendenti (di qualsiasi subappaltatore)
  /// che vi erano segnati presenti: da chiamare quando il cantiere stesso
  /// viene concluso, per non tenere più conto della loro presenza lì.
  Future<void> rimuoviCantiereDaTutti(String cantiereId) async {
    await _rimuoviCantiereDa(perCantiere(cantiereId), cantiereId);
  }

  /// Toglie più cantieri in una volta sola dai dipendenti di un
  /// subappaltatore: da chiamare quando quei cantieri vengono scollegati dal
  /// subappaltatore, per non lasciare i dipendenti segnati presenti.
  Future<void> rimuoviCantieriDaiDipendentiDiSubappaltatore(
    String subappaltatoreId,
    Set<String> cantieriRimossi,
  ) async {
    if (cantieriRimossi.isEmpty) return;
    final daAggiornare = perSubappaltatore(subappaltatoreId)
        .where((d) => d.cantieriIds.any(cantieriRimossi.contains));
    final aggiornati = await Future.wait(
      daAggiornare.map((d) => _pb.collection('dipendenti_subappaltatori').update(
            d.id,
            body: {
              'cantieri': d.cantieriIds.where((id) => !cantieriRimossi.contains(id)).toList(),
            },
          )),
    );
    if (aggiornati.isEmpty) return;
    for (final record in aggiornati) {
      sostituisciOrdinato(
        _dipendenti,
        DipendenteSubappaltatore.fromRecord(record),
        (d) => d.id,
        _perCognome,
      );
    }
    notifyListeners();
  }

  /// Toglie [cantiereId] dall'elenco dei cantieri di più dipendenti in
  /// parallelo, con un solo aggiornamento della lista alla fine: farlo in
  /// serie significava una richiesta di scrittura *e* una rilettura completa
  /// della collection per ogni dipendente.
  Future<void> _rimuoviCantiereDa(
    Iterable<DipendenteSubappaltatore> dipendenti,
    String cantiereId,
  ) async {
    final aggiornati = await Future.wait(
      dipendenti.map((d) => _pb.collection('dipendenti_subappaltatori').update(
            d.id,
            body: {'cantieri-': cantiereId},
          )),
    );
    if (aggiornati.isEmpty) return;
    for (final record in aggiornati) {
      sostituisciOrdinato(
        _dipendenti,
        DipendenteSubappaltatore.fromRecord(record),
        (d) => d.id,
        _perCognome,
      );
    }
    notifyListeners();
  }

  void _sostituisci(DipendenteSubappaltatore dipendente) {
    sostituisciOrdinato(_dipendenti, dipendente, (d) => d.id, _perCognome);
    notifyListeners();
  }
}
