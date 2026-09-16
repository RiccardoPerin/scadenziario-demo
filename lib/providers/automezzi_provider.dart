import 'package:flutter/foundation.dart';
import 'package:pocketbase/pocketbase.dart';

import '../models/automezzo.dart';
import '../services/pocketbase_service.dart';
import '../l10n/app_localizations.dart';
import 'locale_provider.dart';

class AutomezziProvider extends ChangeNotifier {
  final PocketBase _pb = PocketBaseService.instance.pb;

  List<Automezzo> _automezzi = [];
  List<Automezzo> get automezzi => _automezzi;

  bool isLoading = false;
  String? errorMessage;

  Future<void> load() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      final records = await _pb
          .collection('automezzi')
          .getFullList(sort: 'targa');
      _automezzi = records.map(Automezzo.fromRecord).toList();
    } on ClientException catch (e) {
      errorMessage =
          e.response['message'] as String? ??
          lookupAppLocalizations(LocaleProvider.current).errorLoadingAutomezzi;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> create({
    required String nome,
    required String targa,
    String? catEuro,
    String? telepass,
    String? compAssicurazione,
    String? proprieta,
    DateTime? scadenzaNoleggioLeasing,
    DateTime? scadenzaAssicurazione,
    DateTime? scadenzaBollo,
    DateTime? scadenzaRevisione,
    DateTime? scadenzaControlloTachigrafo,
    String? note,
  }) async {
    await _pb
        .collection('automezzi')
        .create(
          body: {
            'nome': nome,
            'targa': targa,
            'cat_euro': ?catEuro,
            'telepass': telepass ?? '',
            'comp_assicurazione': compAssicurazione ?? '',
            'proprieta': ?proprieta,
            if (scadenzaNoleggioLeasing != null)
              'scadenza_noleggio_leasing': scadenzaNoleggioLeasing
                  .toIso8601String(),
            if (scadenzaAssicurazione != null)
              'scadenza_assicurazione': scadenzaAssicurazione.toIso8601String(),
            if (scadenzaBollo != null)
              'scadenza_bollo': scadenzaBollo.toIso8601String(),
            if (scadenzaRevisione != null)
              'scadenza_revisione': scadenzaRevisione.toIso8601String(),
            if (scadenzaControlloTachigrafo != null)
              'scadenza_controllo_tachigrafo': scadenzaControlloTachigrafo
                  .toIso8601String(),
            'note': note ?? '',
          },
        );
    await load();
  }

  Future<void> update(
    String id, {
    required String nome,
    required String targa,
    String? catEuro,
    String? telepass,
    String? compAssicurazione,
    String? proprieta,
    DateTime? scadenzaNoleggioLeasing,
    DateTime? scadenzaAssicurazione,
    DateTime? scadenzaBollo,
    DateTime? scadenzaRevisione,
    DateTime? scadenzaControlloTachigrafo,
    String? note,
  }) async {
    await _pb
        .collection('automezzi')
        .update(
          id,
          body: {
            'nome': nome,
            'targa': targa,
            'cat_euro': catEuro ?? '',
            'telepass': telepass ?? '',
            'comp_assicurazione': compAssicurazione ?? '',
            'proprieta': proprieta ?? '',
            'scadenza_noleggio_leasing':
                scadenzaNoleggioLeasing?.toIso8601String() ?? '',
            'scadenza_assicurazione':
                scadenzaAssicurazione?.toIso8601String() ?? '',
            'scadenza_bollo': scadenzaBollo?.toIso8601String() ?? '',
            'scadenza_revisione': scadenzaRevisione?.toIso8601String() ?? '',
            'scadenza_controllo_tachigrafo':
                scadenzaControlloTachigrafo?.toIso8601String() ?? '',
            'note': note ?? '',
          },
        );
    await load();
  }

  Future<void> updateNote(String id, String note) async {
    await _pb.collection('automezzi').update(id, body: {'note': note});
    await load();
  }

  /// Nota libera per una singola scadenza dell'automezzo (es. "prenotato"),
  /// indipendente dalla nota generale dell'automezzo.
  Future<void> updateNotaScadenza(
    Automezzo automezzo,
    String tipo,
    String nota,
  ) async {
    final noteScadenze = Map<String, String>.from(automezzo.noteScadenze);
    if (nota.isEmpty) {
      noteScadenze.remove(tipo);
    } else {
      noteScadenze[tipo] = nota;
    }
    await _pb
        .collection('automezzi')
        .update(automezzo.id, body: {'note_scadenze': noteScadenze});
    await load();
  }

  Future<void> delete(String id) async {
    await _pb.collection('automezzi').delete(id);
    await load();
  }
}
