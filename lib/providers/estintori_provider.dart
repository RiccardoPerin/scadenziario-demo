import 'package:flutter/foundation.dart';
import 'package:pocketbase/pocketbase.dart';

import '../models/estintore.dart';
import '../services/pocketbase_service.dart';
import '../l10n/app_localizations.dart';
import 'locale_provider.dart';

class EstintoriProvider extends ChangeNotifier {
  final PocketBase _pb = PocketBaseService.instance.pb;

  List<Estintore> _estintori = [];
  List<Estintore> get estintori => _estintori;

  bool isLoading = false;
  String? errorMessage;

  Future<void> load() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      final records = await _pb
          .collection('estintori')
          .getFullList(sort: 'numero_matricola');
      _estintori = records.map(Estintore.fromRecord).toList();
    } on ClientException catch (e) {
      errorMessage =
          e.response['message'] as String? ??
          lookupAppLocalizations(LocaleProvider.current).errorLoadingEstintori;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> create({
    required String numeroMatricola,
    String? tipoAgente,
    String? capacita,
    DateTime? dataProduzione,
    DateTime? dataMessaInServizio,
    bool inUfficio = false,
    bool inMagazzino = false,
    String? ubicazioneAutomezzoId,
    String? ubicazioneCantiereId,
    String? dettaglioUbicazione,
    DateTime? dataVerificaEsterna,
    DateTime? scadenzaVerificaEsterna,
    DateTime? ultimaRevisione,
    DateTime? scadenzaRevisione,
    DateTime? ultimoCollaudo,
    DateTime? scadenzaCollaudo,
    String? note,
  }) async {
    await _pb
        .collection('estintori')
        .create(
          body: {
            'numero_matricola': numeroMatricola,
            'tipo_agente': ?tipoAgente,
            'capacita': capacita ?? '',
            if (dataProduzione != null)
              'data_produzione': dataProduzione.toIso8601String(),
            if (dataMessaInServizio != null)
              'data_messa_in_servizio': dataMessaInServizio.toIso8601String(),
            'in_ufficio': inUfficio,
            'in_magazzino': inMagazzino,
            if (ubicazioneAutomezzoId != null &&
                ubicazioneAutomezzoId.isNotEmpty)
              'ubicazione_automezzo': ubicazioneAutomezzoId,
            if (ubicazioneCantiereId != null && ubicazioneCantiereId.isNotEmpty)
              'ubicazione_cantiere': ubicazioneCantiereId,
            'dettaglio_ubicazione': dettaglioUbicazione ?? '',
            if (dataVerificaEsterna != null)
              'data_verifica_esterna': dataVerificaEsterna.toIso8601String(),
            if (scadenzaVerificaEsterna != null)
              'scadenza_verifica_esterna': scadenzaVerificaEsterna
                  .toIso8601String(),
            if (ultimaRevisione != null)
              'ultima_revisione': ultimaRevisione.toIso8601String(),
            if (scadenzaRevisione != null)
              'scadenza_revisione': scadenzaRevisione.toIso8601String(),
            if (ultimoCollaudo != null)
              'ultimo_collaudo': ultimoCollaudo.toIso8601String(),
            if (scadenzaCollaudo != null)
              'scadenza_collaudo': scadenzaCollaudo.toIso8601String(),
            'note': note ?? '',
          },
        );
    await load();
  }

  Future<void> update(
    String id, {
    required String numeroMatricola,
    String? tipoAgente,
    String? capacita,
    DateTime? dataProduzione,
    DateTime? dataMessaInServizio,
    bool inUfficio = false,
    bool inMagazzino = false,
    String? ubicazioneAutomezzoId,
    String? ubicazioneCantiereId,
    String? dettaglioUbicazione,
    DateTime? dataVerificaEsterna,
    DateTime? scadenzaVerificaEsterna,
    DateTime? ultimaRevisione,
    DateTime? scadenzaRevisione,
    DateTime? ultimoCollaudo,
    DateTime? scadenzaCollaudo,
    String? note,
  }) async {
    await _pb
        .collection('estintori')
        .update(
          id,
          body: {
            'numero_matricola': numeroMatricola,
            'tipo_agente': tipoAgente ?? '',
            'capacita': capacita ?? '',
            if (dataProduzione != null)
              'data_produzione': dataProduzione.toIso8601String(),
            if (dataMessaInServizio != null)
              'data_messa_in_servizio': dataMessaInServizio.toIso8601String(),
            'in_ufficio': inUfficio,
            'in_magazzino': inMagazzino,
            'ubicazione_automezzo': ubicazioneAutomezzoId ?? '',
            'ubicazione_cantiere': ubicazioneCantiereId ?? '',
            'dettaglio_ubicazione': dettaglioUbicazione ?? '',
            'data_verifica_esterna':
                dataVerificaEsterna?.toIso8601String() ?? '',
            'scadenza_verifica_esterna':
                scadenzaVerificaEsterna?.toIso8601String() ?? '',
            'ultima_revisione': ultimaRevisione?.toIso8601String() ?? '',
            'scadenza_revisione': scadenzaRevisione?.toIso8601String() ?? '',
            'ultimo_collaudo': ultimoCollaudo?.toIso8601String() ?? '',
            'scadenza_collaudo': scadenzaCollaudo?.toIso8601String() ?? '',
            'note': note ?? '',
          },
        );
    await load();
  }

  Future<void> delete(String id) async {
    await _pb.collection('estintori').delete(id);
    await load();
  }

  Future<void> updateNote(String id, String note) async {
    await _pb.collection('estintori').update(id, body: {'note': note});
    await load();
  }

  /// Nota libera per una singola scadenza dell'estintore (es. "prenotato"),
  /// indipendente dalla nota generale dell'estintore.
  Future<void> updateNotaScadenza(
    Estintore estintore,
    String tipo,
    String nota,
  ) async {
    final noteScadenze = Map<String, String>.from(estintore.noteScadenze);
    if (nota.isEmpty) {
      noteScadenze.remove(tipo);
    } else {
      noteScadenze[tipo] = nota;
    }
    await _pb
        .collection('estintori')
        .update(estintore.id, body: {'note_scadenze': noteScadenze});
    await load();
  }
}
