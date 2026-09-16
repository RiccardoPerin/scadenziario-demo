import 'package:flutter/foundation.dart';
import 'package:pocketbase/pocketbase.dart';

import '../models/articolo_standard_cassetta_ps.dart';
import '../services/pocketbase_service.dart';
import '../l10n/app_localizations.dart';
import 'locale_provider.dart';

class ArticoliStandardCassettePsProvider extends ChangeNotifier {
  final PocketBase _pb = PocketBaseService.instance.pb;

  List<ArticoloStandardCassettaPs> _articoli = [];
  List<ArticoloStandardCassettaPs> get articoli => _articoli;

  bool isLoading = false;
  String? errorMessage;

  List<ArticoloStandardCassettaPs> perTipologia(String tipologia) =>
      _articoli.where((a) => a.tipologia == tipologia).toList();

  Future<void> load() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      final records = await _pb
          .collection('articoli_standard_cassette_ps')
          .getFullList(sort: 'nome_prodotto');
      _articoli = records.map(ArticoloStandardCassettaPs.fromRecord).toList();
    } on ClientException catch (e) {
      errorMessage =
          e.response['message'] as String? ??
          lookupAppLocalizations(LocaleProvider.current).errorLoadingProdottiStandard;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> create({
    required String nomeProdotto,
    required String tipologia,
    String? quantita,
  }) async {
    await _pb.collection('articoli_standard_cassette_ps').create(
      body: {
        'nome_prodotto': nomeProdotto,
        'tipologia': tipologia,
        'quantita': quantita ?? '',
      },
    );
    await load();
  }

  Future<void> update(
    String id, {
    required String nomeProdotto,
    required String tipologia,
    String? quantita,
  }) async {
    await _pb.collection('articoli_standard_cassette_ps').update(
      id,
      body: {
        'nome_prodotto': nomeProdotto,
        'tipologia': tipologia,
        'quantita': quantita ?? '',
      },
    );
    await load();
  }

  Future<void> delete(String id) async {
    await _pb.collection('articoli_standard_cassette_ps').delete(id);
    await load();
  }
}
