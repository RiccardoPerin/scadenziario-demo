import 'package:flutter/foundation.dart';
import 'package:pocketbase/pocketbase.dart';

import '../models/cassetta_ps.dart';
import '../services/pocketbase_service.dart';
import '../l10n/app_localizations.dart';
import 'locale_provider.dart';

class CassettePsProvider extends ChangeNotifier {
  final PocketBase _pb = PocketBaseService.instance.pb;

  List<CassettaPs> _cassette = [];
  List<CassettaPs> get cassette => _cassette;

  bool isLoading = false;
  String? errorMessage;

  Future<void> load() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      final records = await _pb
          .collection('cassette_primo_soccorso')
          .getFullList(sort: 'numero');
      _cassette = records.map(CassettaPs.fromRecord).toList();
    } on ClientException catch (e) {
      errorMessage =
          e.response['message'] as String? ??
          lookupAppLocalizations(LocaleProvider.current).errorLoadingCassette;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<String> create({
    required String numero,
    String? tipologia,
    bool inUfficio = false,
    bool inMagazzino = false,
    String? ubicazioneAutomezzoId,
    String? ubicazioneCantiereId,
    String? dettaglioUbicazione,
    DateTime? ultimaVerifica,
    DateTime? prossimoControllo,
    String? note,
    String? notaScadenza,
  }) async {
    final record = await _pb
        .collection('cassette_primo_soccorso')
        .create(
          body: {
            'numero': numero,
            'tipologia': ?tipologia,
            'in_ufficio': inUfficio,
            'in_magazzino': inMagazzino,
            if (ubicazioneAutomezzoId != null &&
                ubicazioneAutomezzoId.isNotEmpty)
              'ubicazione_automezzo': ubicazioneAutomezzoId,
            if (ubicazioneCantiereId != null && ubicazioneCantiereId.isNotEmpty)
              'ubicazione_cantiere': ubicazioneCantiereId,
            'dettaglio_ubicazione': dettaglioUbicazione ?? '',
            if (ultimaVerifica != null)
              'ultima_verifica': ultimaVerifica.toIso8601String(),
            if (prossimoControllo != null)
              'prossimo_controllo': prossimoControllo.toIso8601String(),
            'note': note ?? '',
            'nota_scadenza': notaScadenza ?? '',
          },
        );
    await load();
    return record.id;
  }

  Future<void> update(
    String id, {
    required String numero,
    String? tipologia,
    bool inUfficio = false,
    bool inMagazzino = false,
    String? ubicazioneAutomezzoId,
    String? ubicazioneCantiereId,
    String? dettaglioUbicazione,
    DateTime? ultimaVerifica,
    DateTime? prossimoControllo,
    String? note,
    String? notaScadenza,
  }) async {
    await _pb
        .collection('cassette_primo_soccorso')
        .update(
          id,
          body: {
            'numero': numero,
            'tipologia': ?tipologia,
            'in_ufficio': inUfficio,
            'in_magazzino': inMagazzino,
            // Assegnati sempre (anche vuoti): passando a "non specificata" la
            // vecchia relazione va cancellata, altrimenti resta appiccicata.
            'ubicazione_automezzo': ubicazioneAutomezzoId ?? '',
            'ubicazione_cantiere': ubicazioneCantiereId ?? '',
            'dettaglio_ubicazione': dettaglioUbicazione ?? '',
            if (ultimaVerifica != null)
              'ultima_verifica': ultimaVerifica.toIso8601String(),
            if (prossimoControllo != null)
              'prossimo_controllo': prossimoControllo.toIso8601String(),
            'note': note ?? '',
            'nota_scadenza': notaScadenza ?? '',
          },
        );
    await load();
  }

  /// Elimina la cassetta insieme a tutti i suoi articoli: senza questo, gli
  /// articoli restano orfani nel database (la relazione non viene ripulita
  /// automaticamente) e le loro scadenze continuano a far scattare il
  /// pallino rosso nel drawer anche se la cassetta non esiste più.
  Future<void> delete(String id) async {
    final articoli = await _pb
        .collection('articoli_cassette_primo_soccorso')
        .getFullList(filter: 'cassetta = "$id"');
    for (final articolo in articoli) {
      await _pb
          .collection('articoli_cassette_primo_soccorso')
          .delete(articolo.id);
    }
    await _pb.collection('cassette_primo_soccorso').delete(id);
    await load();
  }

  Future<void> updateNote(String id, String note) async {
    await _pb.collection('cassette_primo_soccorso').update(id, body: {'note': note});
    await load();
  }

  /// Nota libera per una singola scadenza della cassetta (es. "prenotato"),
  /// indipendente dalla nota generale della cassetta.
   Future<void> updateNotaScadenza(String id, String nota) async {
    await _pb
        .collection('cassette_primo_soccorso')
        .update(id, body: {'nota_scadenza': nota});
    await load();
  }
}
