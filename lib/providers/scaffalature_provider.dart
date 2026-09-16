import 'package:flutter/foundation.dart';
import 'package:pocketbase/pocketbase.dart';

import '../models/scaffalatura.dart';
import '../services/pocketbase_service.dart';
import '../l10n/app_localizations.dart';
import 'locale_provider.dart';

class ScaffalatureProvider extends ChangeNotifier {
  final PocketBase _pb = PocketBaseService.instance.pb;

  List<Scaffalatura> _scaffalature = [];
  List<Scaffalatura> get scaffalature => _scaffalature;

  bool isLoading = false;
  String? errorMessage;

  Future<void> load() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      final records = await _pb
          .collection('scaffalature')
          .getFullList(sort: 'id_interno');
      _scaffalature = records.map(Scaffalatura.fromRecord).toList();
    } on ClientException catch (e) {
      errorMessage =
          e.response['message'] as String? ??
          lookupAppLocalizations(LocaleProvider.current).errorLoadingScaffalature;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> create({
    required String idInterno,
    bool esitoPositivo = true,
    DateTime? dataVerifica,
    DateTime? dataProssimaVerifica,
    required String note,
  }) async {
    await _pb
        .collection('scaffalature')
        .create(
          body: {
            'id_interno': int.tryParse(idInterno) ?? 0,
            'data_verifica': dataVerifica?.toIso8601String() ?? '',
            'data_prossima_verifica': dataProssimaVerifica?.toIso8601String() ?? '',
            'esito_positivo': esitoPositivo,
            'note': note,
          },
        );
    await load();
  }

  Future<void> update(
    String id, {
    required String idInterno,
    bool esitoPositivo = true,
    DateTime? dataVerifica,
    DateTime? dataProssimaVerifica,
    required String note,
  }) async {
    await _pb
        .collection('scaffalature')
        .update(
          id,
          body: {
            'id_interno': int.tryParse(idInterno) ?? 0,
            'data_verifica': dataVerifica?.toIso8601String() ?? '',
            'data_prossima_verifica': dataProssimaVerifica?.toIso8601String() ?? '',
            'esito_positivo': esitoPositivo,
            'note': note,
          },
        );
    await load();
  }

  /// Nota libera per la scadenza (es. "prenotato"), indipendente dalle note
  /// generali della scaffalatura. Una scaffalatura ha una sola scadenza
  /// (la prossima verifica), quindi non serve una mappa per tipo come per le
  /// altre entità: basta aggiornare il campo di testo.
  Future<void> updateNotaScadenza(String id, String nota) async {
    await _pb
        .collection('scaffalature')
        .update(id, body: {'nota_scadenza': nota});
    await load();
  }

  Future<void> delete(String id) async {
    try {
      await _pb.collection('scaffalature').delete(id);
    } on ClientException catch (e) {
      throw e.response['message'] as String? ??
          lookupAppLocalizations(LocaleProvider.current).errorDeletingScaffalatura;
    }
    await load();
  }
}
