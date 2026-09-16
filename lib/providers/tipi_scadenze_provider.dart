import 'package:flutter/foundation.dart';
import 'package:pocketbase/pocketbase.dart';

import '../models/tipo_scadenza.dart';
import '../services/pocketbase_service.dart';
import 'lista_locale.dart';
import '../l10n/app_localizations.dart';
import 'locale_provider.dart';

class TipiScadenzeProvider extends ChangeNotifier {
  final PocketBase _pb = PocketBaseService.instance.pb;

  List<TipoScadenza> _tipiScadenze = [];
  List<TipoScadenza> get tipiScadenze => _tipiScadenze;

  bool isLoading = false;
  String? errorMessage;

  Future<void> load() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      final records = await _pb.collection('tipi_scadenze').getFullList(sort: 'nome');
      _tipiScadenze = records.map(TipoScadenza.fromRecord).toList();
    } on ClientException catch (e) {
      errorMessage =
          e.response['message'] as String? ?? lookupAppLocalizations(LocaleProvider.current).errorLoadingTipiScadenza;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Stesso ordinamento del `sort: 'nome'` usato in [load].
  static int _perNome(TipoScadenza a, TipoScadenza b) => a.nome.compareTo(b.nome);

  Future<void> create({
    required String nome,
    required bool richiedeScadenza,
    required List<int> giorniPreavviso,
    required bool avvisaDopoScadenza,
    required List<String> appartenenza,
    required String note,
  }) async {
    final record = await _pb.collection('tipi_scadenze').create(body: {
      'nome': nome,
      'richiede_scadenza': richiedeScadenza,
      'giorni_preavviso': giorniPreavviso,
      'avvisa_dopo_scadenza': avvisaDopoScadenza,
      'appartenenza': appartenenza,
      'note': note,
    });
    inserisciOrdinato(_tipiScadenze, TipoScadenza.fromRecord(record), _perNome);
    notifyListeners();
  }

  /// Restituisce la tipologia aggiornata: chi la modifica deve passarla a
  /// `DocumentiProvider.aggiornaTipoScadenza`, perché nome e giorni di
  /// preavviso sono copiati dentro le scadenze già caricate.
  Future<TipoScadenza> update(
    String id, {
    required String nome,
    required bool richiedeScadenza,
    required List<int> giorniPreavviso,
    required bool avvisaDopoScadenza,
    required List<String> appartenenza,
    required String note,
  }) async {
    final record = await _pb.collection('tipi_scadenze').update(id, body: {
      'nome': nome,
      'richiede_scadenza': richiedeScadenza,
      'giorni_preavviso': giorniPreavviso,
      'avvisa_dopo_scadenza': avvisaDopoScadenza,
      'appartenenza': appartenenza,
      'note': note,
    });
    final aggiornato = TipoScadenza.fromRecord(record);
    sostituisciOrdinato(_tipiScadenze, aggiornato, (t) => t.id, _perNome);
    notifyListeners();
    return aggiornato;
  }

  Future<void> delete(String id) async {
    try {
      await _pb.collection('tipi_scadenze').delete(id);
    } on ClientException catch (e) {
      throw e.response['message'] as String? ??
          lookupAppLocalizations(LocaleProvider.current).errorDeletingTipoScadenzaInUse;
    }
    rimuoviLocale(_tipiScadenze, {id}, (t) => t.id);
    notifyListeners();
  }
}
