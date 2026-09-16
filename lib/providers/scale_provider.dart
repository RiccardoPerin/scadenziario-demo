import 'package:flutter/foundation.dart';
import 'package:pocketbase/pocketbase.dart';

import '../models/scala.dart';
import '../services/pocketbase_service.dart';
import '../l10n/app_localizations.dart';
import 'locale_provider.dart';

class ScaleProvider extends ChangeNotifier {
  final PocketBase _pb = PocketBaseService.instance.pb;

  List<Scala> _scale = [];
  List<Scala> get scale => _scale;

  bool isLoading = false;
  String? errorMessage;

  Future<void> load() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      final records = await _pb
          .collection('scale')
          .getFullList(sort: 'codice');
      _scale = records.map(Scala.fromRecord).toList();
    } on ClientException catch (e) {
      errorMessage =
          e.response['message'] as String? ??
          lookupAppLocalizations(LocaleProvider.current).errorLoadingScale;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> create({
    required String codice,
    String? materiale,
    String? descrizione,
    bool inMagazzino = false,
    String? ubicazioneCantiereId,
    DateTime? ultimaVerifica,
    DateTime? prossimaVerifica,
    String? note,
  }) async {
    await _pb
        .collection('scale')
        .create(
          body: {
            'codice': codice,
            'materiale': materiale ?? '',
            'descrizione': descrizione ?? '',
            'in_magazzino': inMagazzino,
            if (ubicazioneCantiereId != null && ubicazioneCantiereId.isNotEmpty)
              'ubicazione_cantiere': ubicazioneCantiereId,
            if (ultimaVerifica != null)
              'ultima_verifica': ultimaVerifica.toIso8601String(),
            if (prossimaVerifica != null)
              'prossima_verifica': prossimaVerifica.toIso8601String(),
            'note': note ?? '',
          },
        );
    await load();
  }

  Future<void> update(
    String id, {
    required String codice,
    String? materiale,
    String? descrizione,
    bool inMagazzino = false,
    String? ubicazioneCantiereId,
    DateTime? ultimaVerifica,
    DateTime? prossimaVerifica,
    String? note,
  }) async {
    await _pb
        .collection('scale')
        .update(
          id,
          body: {
            'codice': codice,
            'materiale': materiale ?? '',
            'descrizione': descrizione ?? '',
            'in_magazzino': inMagazzino,
            'ubicazione_cantiere': ubicazioneCantiereId ?? '',
            'ultima_verifica': ultimaVerifica?.toIso8601String() ?? '',
            'prossima_verifica': prossimaVerifica?.toIso8601String() ?? '',
            'note': note ?? '',
          },
        );
    await load();
  }

  Future<void> delete(String id) async {
    await _pb.collection('scale').delete(id);
    await load();
  }

  Future<void> updateNote(String id, String note) async {
    await _pb.collection('scale').update(id, body: {'note': note});
    await load();
  }

  Future<void> updateNotaScadenza(String id, String nota) async {
    await _pb
        .collection('scale')
        .update(id, body: {'nota_scadenza': nota});
    await load();
  }
}
