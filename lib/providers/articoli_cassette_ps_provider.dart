import 'package:flutter/foundation.dart';
import 'package:pocketbase/pocketbase.dart';

import '../models/articolo_cassetta_ps.dart';
import '../services/pocketbase_service.dart';
import '../l10n/app_localizations.dart';
import 'locale_provider.dart';

class ArticoliCassettePsProvider extends ChangeNotifier {
  final PocketBase _pb = PocketBaseService.instance.pb;

  List<ArticoloCassettaPs> _articoli = [];
  List<ArticoloCassettaPs> get articoli => _articoli;

  bool isLoading = false;
  String? errorMessage;

  Future<void> load() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      final records = await _pb
          .collection('articoli_cassette_primo_soccorso')
          .getFullList(sort: 'nome_prodotto');
      _articoli = records.map(ArticoloCassettaPs.fromRecord).toList();
    } on ClientException catch (e) {
      errorMessage =
          e.response['message'] as String? ??
          lookupAppLocalizations(LocaleProvider.current).errorLoadingArticoli;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> create({
    required String nomeProdotto,
    String? cassettaId,
    String? quantita,
    DateTime? scadenza,
    String? note,
    String? notaScadenza,
  }) async {
    await _pb
        .collection('articoli_cassette_primo_soccorso')
        .create(
          body: {
            'nome_prodotto': nomeProdotto,
            'cassetta': ?cassettaId,
            'quantita': quantita,
            if (scadenza != null)
              'scadenza': scadenza.toIso8601String(),
            'note': note ?? '',
            'nota_scadenza': notaScadenza ?? '',
          },
        );
    await load();
  }

  Future<void> update(
    String id, {
    required String nomeProdotto,
    String? cassettaId,
    String? quantita,
    DateTime? scadenza,
    String? note,
    String? notaScadenza,
  }) async {
    await _pb
        .collection('articoli_cassette_primo_soccorso')
        .update(
          id,
          body: {
            'nome_prodotto': nomeProdotto,
            'cassetta': ?cassettaId,
            'quantita': quantita,
            if (scadenza != null)
              'scadenza': scadenza.toIso8601String(),
            'note': note ?? '',
            'nota_scadenza': notaScadenza ?? '',
          },
        );
    await load();
  }

  Future<void> delete(String id) async {
    await _pb.collection('articoli_cassette_primo_soccorso').delete(id);
    await load();
  }

  Future<void> updateNote(String id, String note) async {
    await _pb.collection('articoli_cassette_primo_soccorso').update(id, body: {'note': note});
    await load();
  }

  /// Nota libera per una singola scadenza della cassetta (es. "prenotato"),
  /// indipendente dalla nota generale della cassetta.
   Future<void> updateNotaScadenza(String id, String nota) async {
    await _pb
        .collection('articoli_cassette_primo_soccorso')
        .update(id, body: {'nota_scadenza': nota});
    await load();
  }
}
