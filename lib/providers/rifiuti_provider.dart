import 'package:flutter/foundation.dart';
import 'package:pocketbase/pocketbase.dart';

import '../models/rifiuto.dart';
import '../services/pocketbase_service.dart';
import '../l10n/app_localizations.dart';
import 'locale_provider.dart';

class RifiutiProvider extends ChangeNotifier {
  final PocketBase _pb = PocketBaseService.instance.pb;

  List<Rifiuto> _rifiuti = [];
  List<Rifiuto> get rifiuti => _rifiuti;

  bool isLoading = false;
  String? errorMessage;

  Future<void> load() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      final records = await _pb
          .collection('rifiuti')
          .getFullList(sort: 'nome_ditta');
      _rifiuti = records.map(Rifiuto.fromRecord).toList();
    } on ClientException catch (e) {
      errorMessage =
          e.response['message'] as String? ??
          lookupAppLocalizations(LocaleProvider.current).errorLoadingRifiuti;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> create({
    required String nomeDitta,
    bool trasportatore = false,
    String? nrAutorizzazioneTrasportatore,
    DateTime? scadRifiutiNonPericolosiTrasportatore,
    bool autorizzazioneRifiutiPericolosiTrasportatore = true,
    DateTime? scadRifiutiPericolosiTrasportatore,
    String? noteTrasportatore,
    bool smaltitore = false,
    String? nrAutorizzazioneSmaltitore,
    DateTime? scadRifiutiNonPericolosiSmaltitore,
    bool autorizzazioneRifiutiPericolosiSmaltitore = true,
    DateTime? scadRifiutiPericolosiSmaltitore,
    String? noteSmaltitore,
  }) async {
    await _pb
        .collection('rifiuti')
        .create(
          body: {
            'nome_ditta': nomeDitta,
            'trasportatore': trasportatore,
            'nr_autorizzazione_trasportatore': nrAutorizzazioneTrasportatore ?? '',
            'scadenza_rifiuti_non_pericolosi_trasportatore':
                scadRifiutiNonPericolosiTrasportatore?.toIso8601String() ?? '',
            'autorizzazione_rifiuti_pericolosi_trasportatore': autorizzazioneRifiutiPericolosiTrasportatore,
            'scadenza_rifiuti_pericolosi_trasportatore':
                scadRifiutiPericolosiTrasportatore?.toIso8601String() ?? '',
            'note_trasportatore': noteTrasportatore ?? '',

            'smaltitore': smaltitore,
            'nr_autorizzazione_smaltitore': nrAutorizzazioneSmaltitore ?? '',
            'scadenza_rifiuti_non_pericolosi_smaltitore':
                scadRifiutiNonPericolosiSmaltitore?.toIso8601String() ?? '',
            'autorizzazione_rifiuti_pericolosi_smaltitore': autorizzazioneRifiutiPericolosiSmaltitore,
            'scadenza_rifiuti_pericolosi_smaltitore':
                scadRifiutiPericolosiSmaltitore?.toIso8601String() ?? '',
            'note_smaltitore': noteSmaltitore ?? '',
          },
        );
    await load();
  }

  Future<void> update(
    String id, {
    required String nomeDitta,
    bool trasportatore = false,
    String? nrAutorizzazioneTrasportatore,
    DateTime? scadRifiutiNonPericolosiTrasportatore,
    bool autorizzazioneRifiutiPericolosiTrasportatore = false,
    DateTime? scadRifiutiPericolosiTrasportatore,
    String? noteTrasportatore,
    bool smaltitore = false,
    String? nrAutorizzazioneSmaltitore,
    DateTime? scadRifiutiNonPericolosiSmaltitore,
    bool autorizzazioneRifiutiPericolosiSmaltitore = false,
    DateTime? scadRifiutiPericolosiSmaltitore,
    String? noteSmaltitore,
  }) async {
    await _pb
        .collection('rifiuti')
        .update(
          id,
          body: {
            'nome_ditta': nomeDitta,
            'trasportatore': trasportatore,
            'nr_autorizzazione_trasportatore': nrAutorizzazioneTrasportatore ?? '',
            'scadenza_rifiuti_non_pericolosi_trasportatore':
                scadRifiutiNonPericolosiTrasportatore?.toIso8601String() ?? '',
            'autorizzazione_rifiuti_pericolosi_trasportatore': autorizzazioneRifiutiPericolosiTrasportatore,
            'scadenza_rifiuti_pericolosi_trasportatore':
                scadRifiutiPericolosiTrasportatore?.toIso8601String() ?? '',
            'note_trasportatore': noteTrasportatore ?? '',

            'smaltitore': smaltitore,
            'nr_autorizzazione_smaltitore': nrAutorizzazioneSmaltitore ?? '',
            'scadenza_rifiuti_non_pericolosi_smaltitore':
                scadRifiutiNonPericolosiSmaltitore?.toIso8601String() ?? '',
            'autorizzazione_rifiuti_pericolosi_smaltitore': autorizzazioneRifiutiPericolosiSmaltitore,
            'scadenza_rifiuti_pericolosi_smaltitore':
                scadRifiutiPericolosiSmaltitore?.toIso8601String() ?? '',
            'note_smaltitore': noteSmaltitore ?? '',
          },
        );
    await load();
  }

  Future<void> updateNoteTrasportatore(String id, String noteTrasportatore) async {
    await _pb.collection('rifiuti').update(id, body: {'note_trasportatore': noteTrasportatore});
    await load();
  }

  Future<void> updateNoteSmaltitore(String id, String noteSmaltitore) async {
    await _pb.collection('rifiuti').update(id, body: {'note_smaltitore': noteSmaltitore});
    await load();
  }


  Future<void> updateNotaScadenza(
    Rifiuto rifiuto,
    String tipo,
    String nota,
  ) async {
    final noteScadenze = Map<String, String>.from(rifiuto.noteScadenze);
    if (nota.isEmpty) {
      noteScadenze.remove(tipo);
    } else {
      noteScadenze[tipo] = nota;
    }
    await _pb
        .collection('rifiuti')
        .update(rifiuto.id, body: {'note_scadenze': noteScadenze});
    await load();
  }

  Future<void> delete(String id) async {
    await _pb.collection('rifiuti').delete(id);
    await load();
  }
}
