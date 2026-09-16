import 'package:flutter/foundation.dart';
import 'package:pocketbase/pocketbase.dart';

import '../models/impostazioni.dart';
import '../services/pocketbase_service.dart';
import '../l10n/app_localizations.dart';
import 'locale_provider.dart';

/// Impostazioni globali (una sola riga nella collection "impostazioni").
/// Per ora contiene solo la sospensione temporanea dei solleciti sulle voci
/// già scadute, usata durante le chiusure aziendali: vedi
/// backend/pb_hooks/notifiche.pb.js per l'effetto sulle email.
class ImpostazioniProvider extends ChangeNotifier {
  final PocketBase _pb = PocketBaseService.instance.pb;

  Impostazioni? _impostazioni;
  Impostazioni? get impostazioni => _impostazioni;

  bool isLoading = false;
  String? errorMessage;

  DateTime? get sospensioneScadutiFino => _impostazioni?.sospensioneScadutiFino;

  String get sospensioneImpostataDa => _impostazioni?.sospensioneImpostataDa ?? '';

  /// True finché la data di fine sospensione non è passata (giorno compreso).
  bool get sollecitiSospesi {
    final fino = sospensioneScadutiFino;
    if (fino == null) return false;
    final oggi = DateTime.now();
    return !fino.isBefore(DateTime(oggi.year, oggi.month, oggi.day));
  }

  Future<void> load() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      final records = await _pb.collection('impostazioni').getFullList(sort: 'created');
      _impostazioni = records.isEmpty ? null : Impostazioni.fromRecord(records.first);
    } on ClientException catch (e) {
      errorMessage =
          e.response['message'] as String? ?? lookupAppLocalizations(LocaleProvider.current).errorLoadingImpostazioni;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Sospende i solleciti sulle voci già scadute fino a [fino] compreso;
  /// con null li riattiva subito.
  Future<void> sospendiSollecitiFino(DateTime? fino) async {
    final body = {
      'sospensione_scaduti_fino': fino == null
          ? ''
          : DateTime(fino.year, fino.month, fino.day).toIso8601String(),
      'sospensione_impostata_da':
          fino == null ? '' : (_pb.authStore.record?.getStringValue('email') ?? ''),
    };

    final id = _impostazioni?.id;
    if (id == null) {
      // La riga è creata dalla migrazione: qui si arriva solo se manca del
      // tutto (es. database ripristinato da un backup più vecchio).
      await _pb.collection('impostazioni').create(body: body);
    } else {
      await _pb.collection('impostazioni').update(id, body: body);
    }
    await load();
  }
}
