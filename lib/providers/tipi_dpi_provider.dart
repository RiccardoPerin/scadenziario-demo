import 'package:flutter/foundation.dart';
import 'package:pocketbase/pocketbase.dart';

import '../models/tipo_dpi.dart';
import '../services/pocketbase_service.dart';
import '../l10n/app_localizations.dart';
import 'locale_provider.dart';

class TipiDpiProvider extends ChangeNotifier {
  final PocketBase _pb = PocketBaseService.instance.pb;

  List<TipoDpi> _tipiDpi = [];
  List<TipoDpi> get tipiDpi => _tipiDpi;

  bool isLoading = false;
  String? errorMessage;

  Future<void> load() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      final records = await _pb.collection('tipi_dpi').getFullList(sort: 'nome');
      _tipiDpi = records.map(TipoDpi.fromRecord).toList();
    } on ClientException catch (e) {
      errorMessage =
          e.response['message'] as String? ??
          lookupAppLocalizations(LocaleProvider.current).errorLoadingTipiDpi;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> create({
    required String nome,
    List<int>? giorniPreavviso,
    String? note,
    bool lavoriInQuota = false,
  }) async {
    await _pb.collection('tipi_dpi').create(
      body: {
        'nome': nome,
        'giorni_preavviso': giorniPreavviso ?? [],
        'note': note ?? '',
        'lavori_in_quota': lavoriInQuota,
      },
    );
    await load();
  }

  Future<void> update(
    String id, {
    required String nome,
    List<int>? giorniPreavviso,
    String? note,
    bool lavoriInQuota = false,
  }) async {
    await _pb.collection('tipi_dpi').update(
      id,
      body: {
        'nome': nome,
        'giorni_preavviso': giorniPreavviso ?? [],
        'note': note ?? '',
        'lavori_in_quota': lavoriInQuota,
      },
    );
    await load();
  }

  Future<void> delete(String id) async {
    await _pb.collection('tipi_dpi').delete(id);
    await load();
  }
}
