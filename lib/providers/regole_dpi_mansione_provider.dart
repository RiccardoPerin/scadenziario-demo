import 'package:flutter/foundation.dart';
import 'package:pocketbase/pocketbase.dart';

import '../models/regola_dpi_mansione.dart';
import '../services/pocketbase_service.dart';
import '../l10n/app_localizations.dart';
import 'locale_provider.dart';

class RegoleDpiMansioneProvider extends ChangeNotifier {
  final PocketBase _pb = PocketBaseService.instance.pb;

  List<RegolaDpiMansione> _regole = [];
  List<RegolaDpiMansione> get regole => _regole;

  bool isLoading = false;
  String? errorMessage;

  List<RegolaDpiMansione> perMansione(String mansione) =>
      _regole.where((r) => r.mansione == mansione).toList();

  Future<void> load() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      final records = await _pb
          .collection('regole_dpi_mansione')
          .getFullList(sort: 'mansione');
      _regole = records.map(RegolaDpiMansione.fromRecord).toList();
    } on ClientException catch (e) {
      errorMessage =
          e.response['message'] as String? ??
          lookupAppLocalizations(LocaleProvider.current).errorLoadingRegoleDpi;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> create({
    required String mansione,
    List<String> dpiObbligatoriIds = const [],
  }) async {
    await _pb.collection('regole_dpi_mansione').create(
      body: {
        'mansione': mansione,
        'dpi_obbligatori': dpiObbligatoriIds,
      },
    );
    await load();
  }

  Future<void> update(
    String id, {
    required String mansione,
    List<String> dpiObbligatoriIds = const [],
  }) async {
    await _pb.collection('regole_dpi_mansione').update(
      id,
      body: {
        'mansione': mansione,
        'dpi_obbligatori': dpiObbligatoriIds,
      },
    );
    await load();
  }

  Future<void> delete(String id) async {
    await _pb.collection('regole_dpi_mansione').delete(id);
    await load();
  }
}
