import 'package:flutter/foundation.dart';
import 'package:pocketbase/pocketbase.dart';

import '../models/dpi_assegnato.dart';
import '../services/pocketbase_service.dart';
import '../l10n/app_localizations.dart';
import 'locale_provider.dart';

class DpiAssegnatiProvider extends ChangeNotifier {
  final PocketBase _pb = PocketBaseService.instance.pb;

  List<DpiAssegnato> _dpiAssegnati = [];
  List<DpiAssegnato> get dpiAssegnati => _dpiAssegnati;

  bool isLoading = false;
  String? errorMessage;

  List<DpiAssegnato> perDipendente(String dipendenteId) =>
      _dpiAssegnati.where((d) => d.dipendente == dipendenteId).toList();

  Future<void> load() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      final records = await _pb
          .collection('dpi_assegnati')
          .getFullList(expand: 'dipendente,tipo_dpi');
      _dpiAssegnati = records.map(DpiAssegnato.fromRecord).toList();
    } on ClientException catch (e) {
      errorMessage =
          e.response['message'] as String? ??
          lookupAppLocalizations(LocaleProvider.current).errorLoadingDpiAssegnati;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> create({
    required String dipendenteId,
    required String tipoDpiId,
    String? matricola,
    int? taglia,
    String? produttore,
    DateTime? dataMessaInUso,
    int? annoFabbricazione,
    DateTime? dataScadenza,
    DateTime? dataConsegna,
    String? note,
  }) async {
    await _pb.collection('dpi_assegnati').create(
      body: {
        'dipendente': dipendenteId,
        'tipo_dpi': tipoDpiId,
        'matricola': matricola ?? '',
        'taglia': ?taglia,
        'produttore': produttore ?? '',
        if (dataMessaInUso != null)
          'data_messa_in_uso': dataMessaInUso.toIso8601String(),
        'anno_fabbricazione': ?annoFabbricazione,
        if (dataScadenza != null)
          'data_scadenza': dataScadenza.toIso8601String(),
        if (dataConsegna != null)
          'data_consegna_dpi': dataConsegna.toIso8601String(),
        'note': note ?? '',
      },
    );
    await load();
  }

  Future<void> update(
    String id, {
    required String dipendenteId,
    required String tipoDpiId,
    String? matricola,
    int? taglia,
    String? produttore,
    DateTime? dataMessaInUso,
    int? annoFabbricazione,
    DateTime? dataScadenza,
    DateTime? dataConsegna,
    String? note,
  }) async {
    await _pb.collection('dpi_assegnati').update(
      id,
      body: {
        'dipendente': dipendenteId,
        'tipo_dpi': tipoDpiId,
        'matricola': matricola ?? '',
        'taglia': ?taglia,
        'produttore': produttore ?? '',
        'data_messa_in_uso': dataMessaInUso?.toIso8601String() ?? '',
        'anno_fabbricazione': annoFabbricazione,
        'data_scadenza': dataScadenza?.toIso8601String() ?? '',
        'data_consegna_dpi': dataConsegna?.toIso8601String() ?? '',
        'note': note ?? '',
      },
    );
    await load();
  }

  Future<void> delete(String id) async {
    await _pb.collection('dpi_assegnati').delete(id);
    await load();
  }

  Future<void> updateNote(String id, String note) async {
    await _pb.collection('dpi_assegnati').update(id, body: {'note': note});
    await load();
  }

  /// Ritiro temporaneo di un DPI per lavori in quota (corde, imbragature, ...):
  /// il DPI resta assegnato al dipendente con tutti i suoi dati — matricola,
  /// produttore, scadenza — ma non è più in suo possesso, quindi la data di
  /// consegna viene azzerata. Alla riconsegna basta reinserire quella data,
  /// senza ricompilare il resto della scheda.
  ///
  /// Scrive solo i due campi coinvolti, così un ritiro non può sovrascrivere
  /// il resto del record.
  Future<void> updateRitiroQuota(
    String id, {
    required bool ritirato,
    DateTime? dataConsegna,
  }) async {
    await _pb.collection('dpi_assegnati').update(
      id,
      body: {
        'ritiro_dpi_quota': ritirato,
        'data_consegna_dpi': dataConsegna?.toIso8601String() ?? '',
      },
    );
    await load();
  }

  /// Nota libera per la scadenza del DPI (es. "prenotato"), indipendente
  /// dalla nota generale del DPI assegnato.
  Future<void> updateNotaScadenza(String id, String nota) async {
    await _pb
        .collection('dpi_assegnati')
        .update(id, body: {'nota_scadenza': nota});
    await load();
  }

  /// Elimina tutti i DPI assegnati a un dipendente: da chiamare quando il
  /// dipendente stesso viene eliminato, per non lasciare record orfani.
  Future<void> deletePerDipendente(String dipendenteId) async {
    for (final d in perDipendente(dipendenteId)) {
      await _pb.collection('dpi_assegnati').delete(d.id);
    }
    await load();
  }
}
