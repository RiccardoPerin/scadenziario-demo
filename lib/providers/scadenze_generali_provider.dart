import 'package:flutter/foundation.dart';
import 'package:pocketbase/pocketbase.dart';

import '../models/scadenza_generale.dart';
import '../services/pocketbase_service.dart';
import '../l10n/app_localizations.dart';
import 'locale_provider.dart';

class ScadenzeGeneraliProvider extends ChangeNotifier {
  final PocketBase _pb = PocketBaseService.instance.pb;

  List<ScadenzaGenerale> _scadenze = [];
  List<ScadenzaGenerale> get scadenze => _scadenze;

  bool isLoading = false;
  String? errorMessage;

  Future<void> load() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      final records = await _pb
          .collection('scadenze_generali')
          .getFullList(sort: 'nome');
      _scadenze = records.map(ScadenzaGenerale.fromRecord).toList();
    } on ClientException catch (e) {
      errorMessage =
          e.response['message'] as String? ??
          lookupAppLocalizations(LocaleProvider.current).errorLoadingScadenzeGenerali;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> create({
    required String nome,
    DateTime? scadenza,
    required List<int> giorniPreavviso,
    required String note,
  }) async {
    await _pb
        .collection('scadenze_generali')
        .create(
          body: {
            'nome': nome,
            'scadenza': scadenza?.toIso8601String() ?? '',
            'giorni_preavviso': giorniPreavviso,
            'note': note,
          },
        );
    await load();
  }

  Future<void> update(
    String id, {
    required String nome,
    DateTime? scadenza,
    required List<int> giorniPreavviso,
    required String note,
  }) async {
    await _pb
        .collection('scadenze_generali')
        .update(
          id,
          body: {
            'nome': nome,
            'scadenza': scadenza?.toIso8601String() ?? '',
            'giorni_preavviso': giorniPreavviso,
            'note': note,
          },
        );
    await load();
  }

  /// Nota libera per questa scadenza (es. "prenotato"), indipendente dalla
  /// nota generale della scadenza. Un record di scadenze_generali è già una
  /// sola scadenza, quindi non serve una mappa per tipo come per le altre
  /// entità: basta aggiornare il campo di testo.
  Future<void> updateNotaScadenza(String id, String nota) async {
    await _pb
        .collection('scadenze_generali')
        .update(id, body: {'nota_scadenza': nota});
    await load();
  }

  Future<void> delete(String id) async {
    try {
      await _pb.collection('scadenze_generali').delete(id);
    } on ClientException catch (e) {
      throw e.response['message'] as String? ??
          lookupAppLocalizations(LocaleProvider.current).errorDeletingScadenzaGenerale;
    }
    await load();
  }
}
