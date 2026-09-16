import 'package:flutter/foundation.dart';
import 'package:pocketbase/pocketbase.dart';

import '../models/misura.dart';
import '../services/pocketbase_service.dart';
import '../l10n/app_localizations.dart';
import 'locale_provider.dart';

class MisureProvider extends ChangeNotifier {
  final PocketBase _pb = PocketBaseService.instance.pb;

  List<Misura> _misure = [];
  List<Misura> get misure => _misure;

  bool isLoading = false;
  String? errorMessage;

  Future<void> load() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      final records = await _pb
          .collection('misure')
          .getFullList(sort: 'nome');
      _misure = records.map(Misura.fromRecord).toList();
    } on ClientException catch (e) {
      errorMessage =
          e.response['message'] as String? ??
          lookupAppLocalizations(LocaleProvider.current).errorLoadingMisure;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> create({
    required String nome,
    String? riferimento,
    String? matricola,
    String? incaricatoTaraturaInterna,
    DateTime? dataTaraturaInterna,
    DateTime? dataProssimaTaraturaInterna,
    String? incaricatoTaraturaEsterna,
    DateTime? dataTaraturaEsterna,
    DateTime? dataProssimaTaraturaEsterna,
    String? note,
  }) async {
    await _pb
        .collection('misure')
        .create(
          body: {
            'nome': nome,
            'riferimento': riferimento ?? '',
            'matricola': matricola ?? '',
            'incaricato_taratura_interna' : incaricatoTaraturaInterna ?? '',
            if (dataTaraturaInterna != null)
              'data_ultima_taratura_interna': dataTaraturaInterna.toIso8601String(),
            if (dataProssimaTaraturaInterna != null)
              'data_prossima_taratura_interna': dataProssimaTaraturaInterna.toIso8601String(),
            'incaricato_taratura_esterna' : incaricatoTaraturaEsterna ?? '',
            if (dataTaraturaEsterna != null)
              'data_ultima_taratura_esterna': dataTaraturaEsterna.toIso8601String(),
            if (dataProssimaTaraturaEsterna != null)
              'data_prossima_taratura_esterna': dataProssimaTaraturaEsterna.toIso8601String(),
            'note': note ?? '',
          },
        );
    await load();
  }

  Future<void> update(
    String id, {
    required String nome,
    String? riferimento,
    String? matricola,
    String? incaricatoTaraturaInterna,
    DateTime? dataTaraturaInterna,
    DateTime? dataProssimaTaraturaInterna,
    String? incaricatoTaraturaEsterna,
    DateTime? dataTaraturaEsterna,
    DateTime? dataProssimaTaraturaEsterna,
    String? note,
  }) async {
    await _pb
        .collection('misure')
        .update(
          id,
          body: {
            'nome': nome,
            'riferimento': riferimento ?? '',
            'matricola': matricola ?? '',
            'incaricato_taratura_interna' : incaricatoTaraturaInterna ?? '',
            if (dataTaraturaInterna != null)
              'data_ultima_taratura_interna': dataTaraturaInterna.toIso8601String(),
            if (dataProssimaTaraturaInterna != null)
              'data_prossima_taratura_interna': dataProssimaTaraturaInterna.toIso8601String(),
            'incaricato_taratura_esterna' : incaricatoTaraturaEsterna ?? '',
            if (dataTaraturaEsterna != null)
              'data_ultima_taratura_esterna': dataTaraturaEsterna.toIso8601String(),
            if (dataProssimaTaraturaEsterna != null)
              'data_prossima_taratura_esterna': dataProssimaTaraturaEsterna.toIso8601String(),
            'note': note ?? '',
          },
        );
    await load();
  }

  Future<void> delete(String id) async {
    await _pb.collection('misure').delete(id);
    await load();
  }

  Future<void> updateNote(String id, String note) async {
    await _pb.collection('misure').update(id, body: {'note': note});
    await load();
  }

  /// Nota libera per una singola scadenza dell'estintore (es. "prenotato"),
  /// indipendente dalla nota generale dell'estintore.
  Future<void> updateNotaScadenza(
    Misura misura,
    String tipo,
    String nota,
  ) async {
    final noteScadenze = Map<String, String>.from(misura.noteScadenze);
    if (nota.isEmpty) {
      noteScadenze.remove(tipo);
    } else {
      noteScadenze[tipo] = nota;
    }
    await _pb
        .collection('misure')
        .update(misura.id, body: {'note_scadenze': noteScadenze});
    await load();
  }
}
