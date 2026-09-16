import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:pocketbase/pocketbase.dart';

import '../models/benna.dart';
import '../services/pocketbase_service.dart';
import '../l10n/app_localizations.dart';
import 'locale_provider.dart';

class BenneProvider extends ChangeNotifier {
  final PocketBase _pb = PocketBaseService.instance.pb;

  List<Benna> _benne = [];
  List<Benna> get benne => _benne;

  bool isLoading = false;
  String? errorMessage;

  Future<void> load() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      final records = await _pb
          .collection('benne')
          .getFullList(sort: 'id_interno');
      _benne = records.map(Benna.fromRecord).toList();
    } on ClientException catch (e) {
      errorMessage =
          e.response['message'] as String? ??
          lookupAppLocalizations(LocaleProvider.current).errorLoadingBenne;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> create({
    required String idInterno,
    String? numeroSerie,
    String? descrizione,
    String? capacitaCarico,
    bool inMagazzino = false,
    String? ubicazioneCantiereId,
    DateTime? dataAcquisto,
    DateTime? dataUltimaVerificaInterna,
    bool esitoVerifica = true,
    DateTime? dataProssimaVerifica,
    String? note,
    List<int>? fotoBytes,
    String? fotoFileName,
  }) async {
    await _pb
        .collection('benne')
        .create(
          body: {
            'id_interno': idInterno,
            'num_serie_produttore': numeroSerie ?? '',
            'descrizione': descrizione ?? '',
            'capacita_carico': capacitaCarico ?? '',
            'in_magazzino': inMagazzino,
            if (ubicazioneCantiereId != null && ubicazioneCantiereId.isNotEmpty)
              'ubicazione_cantiere': ubicazioneCantiereId,
            if (dataAcquisto != null)
              'data_acquisto': dataAcquisto.toIso8601String(),
            if (dataUltimaVerificaInterna != null)
              'data_ultima_verifica_interna':
                  dataUltimaVerificaInterna.toIso8601String(),
            'esito_verifica': esitoVerifica,
            if (dataProssimaVerifica != null)
              'data_prossima_verifica': dataProssimaVerifica.toIso8601String(),
            'note': note ?? '',
          },
          files: _fotoFiles(fotoBytes, fotoFileName),
        );
    await load();
  }

  Future<void> update(
    String id, {
    required String idInterno,
    String? numeroSerie,
    String? descrizione,
    String? capacitaCarico,
    bool inMagazzino = false,
    String? ubicazioneCantiereId,
    DateTime? dataAcquisto,
    DateTime? dataUltimaVerificaInterna,
    bool esitoVerifica = true,
    DateTime? dataProssimaVerifica,
    String? note,
    List<int>? fotoBytes,
    String? fotoFileName,
    bool rimuoviFoto = false,
  }) async {
    await _pb
        .collection('benne')
        .update(
          id,
          body: {
            'id_interno': idInterno,
            'num_serie_produttore': numeroSerie ?? '',
            'descrizione': descrizione ?? '',
            'capacita_carico': capacitaCarico ?? '',
            'in_magazzino': inMagazzino,
            if (ubicazioneCantiereId != null && ubicazioneCantiereId.isNotEmpty)
              'ubicazione_cantiere': ubicazioneCantiereId,
            if (dataAcquisto != null)
              'data_acquisto': dataAcquisto.toIso8601String(),
            if (dataUltimaVerificaInterna != null)
              'data_ultima_verifica_interna':
                  dataUltimaVerificaInterna.toIso8601String(),
            'esito_verifica': esitoVerifica,
            if (dataProssimaVerifica != null)
              'data_prossima_verifica': dataProssimaVerifica.toIso8601String(),
            'note': note ?? '',

            if (rimuoviFoto) 'foto': null
          },
          files: _fotoFiles(fotoBytes, fotoFileName),
        );
    await load();
  }

  Future<void> delete(String id) async {
    await _pb.collection('benne').delete(id);
    await load();
  }

  Future<void> updateNote(String id, String note) async {
    await _pb.collection('benne').update(id, body: {'note': note});
    await load();
  }

  Future<void> updateNotaScadenza(String id, String nota) async {
    await _pb
        .collection('benne')
        .update(id, body: {'nota_scadenza': nota});
    await load();
  }

  /// La foto va inviata come multipart, non nel body JSON.
  List<http.MultipartFile> _fotoFiles(List<int>? bytes, String? fileName) {
    if (bytes == null || bytes.isEmpty) return const [];
    return [
      http.MultipartFile.fromBytes('foto', bytes, filename: fileName ?? 'foto'),
    ];
  }
}
