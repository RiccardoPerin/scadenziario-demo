import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:pocketbase/pocketbase.dart';

import '../models/segnale.dart';
import '../services/pocketbase_service.dart';
import '../l10n/app_localizations.dart';
import 'locale_provider.dart';

class SegnaliProvider extends ChangeNotifier {
  final PocketBase _pb = PocketBaseService.instance.pb;

  List<Segnale> _segnali = [];
  List<Segnale> get segnali => _segnali;

  bool isLoading = false;
  String? errorMessage;

  Future<void> load() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      final records = await _pb
          .collection('segnaletica')
          .getFullList(sort: 'nome');
      _segnali = records.map(Segnale.fromRecord).toList();
    } on ClientException catch (e) {
      errorMessage =
          e.response['message'] as String? ??
          lookupAppLocalizations(LocaleProvider.current).errorLoadingSegnaletica;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<String> create({
    required String nome,
    String? ubicazione,
    String? zona,
    String? note,
    List<int>? cartelloBytes,
    String? cartelloFileName,
  }) async {
    final record = await _pb
        .collection('segnaletica')
        .create(
          body: {
            'nome': nome,
            'ubicazione': ubicazione ?? '',
            'zona': zona ?? '',
            'note': note ?? '',
          },
          files: _cartelloFiles(cartelloBytes, cartelloFileName),
        );
    await load();
    return record.id;
  }

  Future<void> update(
    String id, {
    required String nome,
    String? ubicazione,
    String? zona,
    String? note,
    List<int>? cartelloBytes,
    String? cartelloFileName,
    bool rimuoviCartello = false,
  }) async {
    await _pb
        .collection('segnaletica')
        .update(
          id,
          body: {
            'nome': nome,
            'ubicazione': ubicazione ?? '',
            'zona': zona ?? '',
            'note': note ?? '',
            // Senza questo il file già caricato resterebbe: PocketBase
            // cancella un campo file solo se lo si azzera esplicitamente.
            if (rimuoviCartello) 'cartello': null,
          },
          files: _cartelloFiles(cartelloBytes, cartelloFileName),
        );
    await load();
  }

  Future<void> delete(String id) async {
    await _pb.collection('segnaletica').delete(id);
    await load();
  }

  /// L'immagine del cartello va inviata come multipart, non nel body JSON.
  List<http.MultipartFile> _cartelloFiles(List<int>? bytes, String? fileName) {
    if (bytes == null || bytes.isEmpty) return const [];
    return [
      http.MultipartFile.fromBytes(
        'cartello',
        bytes,
        filename: fileName ?? 'cartello',
      ),
    ];
  }
}
