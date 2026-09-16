import 'package:flutter/foundation.dart';
import 'package:pocketbase/pocketbase.dart';

import '../models/subappaltatore.dart';
import '../services/pocketbase_service.dart';
import 'lista_locale.dart';
import '../l10n/app_localizations.dart';
import 'locale_provider.dart';

class SubappaltatoriProvider extends ChangeNotifier {
  final PocketBase _pb = PocketBaseService.instance.pb;

  List<Subappaltatore> _subappaltatori = [];
  List<Subappaltatore> get subappaltatori => _subappaltatori;

  bool isLoading = false;
  String? errorMessage;

  Future<void> load() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      final records =
          await _pb.collection('subappaltatori').getFullList(sort: 'ragione_sociale');
      _subappaltatori = records.map(Subappaltatore.fromRecord).toList();
    } on ClientException catch (e) {
      errorMessage =
          e.response['message'] as String? ?? lookupAppLocalizations(LocaleProvider.current).errorLoadingSubappaltatori;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Stesso ordinamento del `sort: 'ragione_sociale'` usato in [load].
  static int _perRagioneSociale(Subappaltatore a, Subappaltatore b) =>
      a.ragioneSociale.compareTo(b.ragioneSociale);

  Future<Subappaltatore> getOne(String id) async {
    final r = await _pb.collection('subappaltatori').getOne(id);
    return Subappaltatore.fromRecord(r);
  }

  List<Subappaltatore> perCantiere(String cantiereId) {
    return _subappaltatori
        .where((s) => s.cantieriIds.contains(cantiereId))
        .toList();
  }

  Future<void> create({
    required String ragioneSociale,
    required String partitaIva,
    required String telefono,
    required String email,
    required String note,
    required List<String> cantieriIds,
  }) async {
    final record = await _pb.collection('subappaltatori').create(body: {
      'ragione_sociale': ragioneSociale,
      'p_iva': partitaIva,
      'telefono': telefono,
      'email': email,
      'note': note,
      'cantieri': cantieriIds,
    });
    inserisciOrdinato(_subappaltatori, Subappaltatore.fromRecord(record), _perRagioneSociale);
    notifyListeners();
  }

  Future<void> update(
    String id, {
    required String ragioneSociale,
    required String partitaIva,
    required String telefono,
    required String email,
    required String note,
    required List<String> cantieriIds,
  }) async {
    final record = await _pb.collection('subappaltatori').update(id, body: {
      'ragione_sociale': ragioneSociale,
      'p_iva': partitaIva,
      'telefono': telefono,
      'email': email,
      'note': note,
      'cantieri': cantieriIds,
    });
    _sostituisci(Subappaltatore.fromRecord(record));
  }

  Future<void> addCantiereToSubappaltatore(
    String subappaltatoreId,
    String cantiereId,
  ) async {
    final record = await _pb.collection('subappaltatori').update(subappaltatoreId, body: {
      'cantieri+': cantiereId,
    });
    _sostituisci(Subappaltatore.fromRecord(record));
  }

  Future<void> removeCantiereFromSubappaltatore(
    String subappaltatoreId,
    String cantiereId,
  ) async {
    final record = await _pb.collection('subappaltatori').update(subappaltatoreId, body: {
      'cantieri-': cantiereId,
    });
    _sostituisci(Subappaltatore.fromRecord(record));
  }

  /// Elimina il subappaltatore. I suoi dipendenti e tutti i documenti (suoi e
  /// dei dipendenti) li elimina PocketBase a cascata: i provider interessati
  /// vanno riallineati dopo, cosa di cui si occupa
  /// `eliminaSubappaltatoreConTracce`.
  Future<void> delete(String id) async {
    await _pb.collection('subappaltatori').delete(id);
    rimuoviLocale(_subappaltatori, {id}, (s) => s.id);
    notifyListeners();
  }

  void _sostituisci(Subappaltatore subappaltatore) {
    sostituisciOrdinato(_subappaltatori, subappaltatore, (s) => s.id, _perRagioneSociale);
    notifyListeners();
  }
}
