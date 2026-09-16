import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:pocketbase/pocketbase.dart';

import '../models/fascia_catena.dart';
import '../services/pocketbase_service.dart';
import '../l10n/app_localizations.dart';
import 'locale_provider.dart';

class FasceCateneProvider extends ChangeNotifier {
  final PocketBase _pb = PocketBaseService.instance.pb;

  List<FasciaCatena> _fasceCatene = [];
  List<FasciaCatena> get fasceCatene => _fasceCatene;

  bool isLoading = false;
  String? errorMessage;

  Future<void> load() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      final records = await _pb
          .collection('fasce_catene')
          .getFullList(sort: 'tipo_fascia,foto');
      _fasceCatene = records.map(FasciaCatena.fromRecord).toList();
    } on ClientException catch (e) {
      errorMessage =
          e.response['message'] as String? ??
          lookupAppLocalizations(LocaleProvider.current).errorLoadingFasceCatene;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> create({
    required String idInterno,
    String? numeroSerie,
    String? tipoFascia,
    bool cricchetto = false,
    String? colore,
    String? portata,
    String? spessore,
    String? diametro,
    String? lunghezza,
    String? larghezza,
    bool inMagazzino = false,
    String? ubicazioneCantiereId,
    String? ubicazioneAutomezzoId,
    DateTime? dataAcquisto,
    String? luogoAcquisto,
    DateTime? dataUltimaVerificaInterna,
    bool esitoVerifica = true,
    DateTime? dataProssimaVerifica,
    String? note,
    List<int>? fotoBytes,
    String? fotoFileName,
  }) async {
    await _pb
        .collection('fasce_catene')
        .create(
          body: {
            'id_interno': idInterno,
            'num_serie_produttore': numeroSerie ?? '',
            'tipo_fascia': tipoFascia ?? '',
            'cricchetto': cricchetto,
            'colore': colore ?? '',
            'portata': portata ?? '',
            'spessore': spessore ?? '',
            'diametro': diametro ?? '',
            'lunghezza': lunghezza ?? '',
            'larghezza': larghezza ?? '',
            'in_magazzino': inMagazzino,
            if (ubicazioneCantiereId != null && ubicazioneCantiereId.isNotEmpty)
              'ubicazione_cantiere': ubicazioneCantiereId,
            if (ubicazioneAutomezzoId != null &&
                ubicazioneAutomezzoId.isNotEmpty)
              'ubicazione_automezzo': ubicazioneAutomezzoId,
            if (dataAcquisto != null)
              'data_acquisto': dataAcquisto.toIso8601String(),
            'luogo_acquisto': luogoAcquisto ?? '',
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
    String? tipoFascia,
    bool cricchetto = false,
    String? colore,
    String? portata,
    String? spessore,
    String? diametro,
    String? lunghezza,
    String? larghezza,
    bool inMagazzino = false,
    String? ubicazioneCantiereId,
    String? ubicazioneAutomezzoId,
    DateTime? dataAcquisto,
    String? luogoAcquisto,
    DateTime? dataUltimaVerificaInterna,
    bool esitoVerifica = true,
    DateTime? dataProssimaVerifica,
    String? note,
    List<int>? fotoBytes,
    String? fotoFileName,
    bool rimuoviFoto = false,
  }) async {
    await _pb
        .collection('fasce_catene')
        .update(
          id,
          body: {
            'id_interno': idInterno,
            'num_serie_produttore': numeroSerie ?? '',
            'tipo_fascia': tipoFascia ?? '',
            'cricchetto': cricchetto,
            'colore': colore ?? '',
            'portata': portata ?? '',
            'spessore': spessore ?? '',
            'diametro': diametro ?? '',
            'lunghezza': lunghezza ?? '',
            'larghezza': larghezza ?? '',
            'in_magazzino': inMagazzino,
            'ubicazione_cantiere': ubicazioneCantiereId ?? '',
            'ubicazione_automezzo': ubicazioneAutomezzoId ?? '',
            'data_acquisto': dataAcquisto?.toIso8601String() ?? '',
            'luogo_acquisto': luogoAcquisto ?? '',
            'data_ultima_verifica_interna':
                dataUltimaVerificaInterna?.toIso8601String() ?? '',
            'esito_verifica': esitoVerifica,
            'data_prossima_verifica':
                dataProssimaVerifica?.toIso8601String() ?? '',
            'note': note ?? '',
            // Senza questo la foto già caricata resterebbe: PocketBase
            // cancella un campo file solo se lo si azzera esplicitamente.
            if (rimuoviFoto) 'foto': null,
          },
          files: _fotoFiles(fotoBytes, fotoFileName),
        );
    await load();
  }

  Future<void> delete(String id) async {
    await _pb.collection('fasce_catene').delete(id);
    await load();
  }

  Future<void> updateNote(String id, String note) async {
    await _pb.collection('fasce_catene').update(id, body: {'note': note});
    await load();
  }

  Future<void> updateNotaScadenza(String id, String nota) async {
    await _pb
        .collection('fasce_catene')
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
