import 'package:flutter/foundation.dart';
import 'package:pocketbase/pocketbase.dart';

import '../models/cantiere.dart';
import '../services/pocketbase_service.dart';
import 'lista_locale.dart';
import '../l10n/app_localizations.dart';
import 'locale_provider.dart';

class CantieriProvider extends ChangeNotifier {
  final PocketBase _pb = PocketBaseService.instance.pb;

  List<Cantiere> _cantieri = [];
  List<Cantiere> get cantieri => _cantieri;

  bool isLoading = false;
  String? errorMessage;

  Future<void> load() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      final records = await _pb.collection('cantieri').getFullList(sort: 'nome');
      _cantieri = records.map(Cantiere.fromRecord).toList();
    } on ClientException catch (e) {
      errorMessage = e.response['message'] as String? ?? lookupAppLocalizations(LocaleProvider.current).errorLoadingCantieri;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Stesso ordinamento del `sort: 'nome'` usato in [load], per mantenere
  /// coerente la lista aggiornata in memoria dopo una scrittura.
  static int _perNome(Cantiere a, Cantiere b) => a.nome.compareTo(b.nome);

  static const _campoMessaATerra = 'scadenza_messa_a_terra';
  static const _campiScadenzeGeneriche = [
    'scadenza_generica1',
    'scadenza_generica2',
    'scadenza_generica3',
    'scadenza_generica4',
    'scadenza_generica5',
  ];

  Future<Cantiere> getOne(String id) async {
    final r = await _pb.collection('cantieri').getOne(id);
    return Cantiere.fromRecord(r);
  }

  Future<void> create({
    required String nome,
    required String indirizzo,
    required String comune,
    required String cap,
    DateTime? dataInizio,
    DateTime? dataFine,
    required String stato,
    DateTime? scadenzaMessaTerra,
    DateTime? scadenzaGenerica1,
    DateTime? scadenzaGenerica2,
    DateTime? scadenzaGenerica3,
    DateTime? scadenzaGenerica4,
    DateTime? scadenzaGenerica5,
    String? nomeScadenzaGenerica1,
    String? nomeScadenzaGenerica2,
    String? nomeScadenzaGenerica3,
    String? nomeScadenzaGenerica4,
    String? nomeScadenzaGenerica5,
    required String note,
  }) async {
    final record = await _pb.collection('cantieri').create(body: {
      'nome': nome,
      'indirizzo': indirizzo,
      'comune': comune,
      'CAP': cap,
      if (dataInizio != null)
        'data_inizio': dataInizio.toIso8601String(),
      if (dataFine != null)
        'data_fine': dataFine.toIso8601String(),
      'stato': stato,
      'note': note,
      'scadenza_messa_a_terra': scadenzaMessaTerra?.toIso8601String(),
      'scadenza_generica1': scadenzaGenerica1?.toIso8601String(),
      'scadenza_generica2': scadenzaGenerica2?.toIso8601String(),
      'scadenza_generica3': scadenzaGenerica3?.toIso8601String(),
      'scadenza_generica4': scadenzaGenerica4?.toIso8601String(),
      'scadenza_generica5': scadenzaGenerica5?.toIso8601String(),
      'scadenza_generica1_nome': ?nomeScadenzaGenerica1,
      'scadenza_generica2_nome': ?nomeScadenzaGenerica2,
      'scadenza_generica3_nome': ?nomeScadenzaGenerica3,
      'scadenza_generica4_nome': ?nomeScadenzaGenerica4,
      'scadenza_generica5_nome': ?nomeScadenzaGenerica5,
    });
    inserisciOrdinato(_cantieri, Cantiere.fromRecord(record), _perNome);
    notifyListeners();
  }

  Future<void> update(
    String id, {
    required String nome,
    required String indirizzo,
    required String comune,
    required String cap,
    DateTime? dataInizio,
    DateTime? dataFine,
    required String stato,
    DateTime? scadenzaMessaTerra,
    DateTime? scadenzaGenerica1,
    DateTime? scadenzaGenerica2,
    DateTime? scadenzaGenerica3,
    DateTime? scadenzaGenerica4,
    DateTime? scadenzaGenerica5,
    String? nomeScadenzaGenerica1,
    String? nomeScadenzaGenerica2,
    String? nomeScadenzaGenerica3,
    String? nomeScadenzaGenerica4,
    String? nomeScadenzaGenerica5,
    required String note,
    Map<String, String>? commentiScadenze,
  }) async {
    final record = await _pb.collection('cantieri').update(id, body: {
      'nome': nome,
      'indirizzo': indirizzo,
      'comune': comune,
      'CAP': cap,
      if (dataInizio != null)
        'data_inizio': dataInizio.toIso8601String(),
      if (dataFine != null)
        'data_fine': dataFine.toIso8601String(),
      'stato': stato,
      'note': note,
      'scadenza_messa_a_terra': scadenzaMessaTerra?.toIso8601String(),
      'scadenza_generica1': scadenzaGenerica1?.toIso8601String(),
      'scadenza_generica2': scadenzaGenerica2?.toIso8601String(),
      'scadenza_generica3': scadenzaGenerica3?.toIso8601String(),
      'scadenza_generica4': scadenzaGenerica4?.toIso8601String(),
      'scadenza_generica5': scadenzaGenerica5?.toIso8601String(),
      'scadenza_generica1_nome': ?nomeScadenzaGenerica1,
      'scadenza_generica2_nome': ?nomeScadenzaGenerica2,
      'scadenza_generica3_nome': ?nomeScadenzaGenerica3,
      'scadenza_generica4_nome': ?nomeScadenzaGenerica4,
      'scadenza_generica5_nome': ?nomeScadenzaGenerica5,
      // Solo i form che mostrano anche le note delle scadenze generali le
      // passano: gli altri (es. la modifica dei dati del cantiere) devono
      // lasciare intatto quanto già salvato.
      'commenti_scadenze': ?commentiScadenze,
    });
    _sostituisci(Cantiere.fromRecord(record));
  }

  /// Aggiorna data e commento di una singola scadenza generale del cantiere,
  /// senza toccare gli altri campi. [campo] è il nome stabile del campo
  /// ("scadenza_messa_a_terra", "scadenza_generica1", ...).
  Future<void> updateScadenzaGenerale(
    Cantiere cantiere,
    String campo, {
    required DateTime data,
    required String commento,
  }) async {
    if (campo != _campoMessaATerra && !_campiScadenzeGeneriche.contains(campo)) {
      throw ArgumentError('Campo scadenza sconosciuto: $campo');
    }
    final commentiScadenze = Map<String, String>.from(cantiere.commentiScadenze);
    if (commento.isEmpty) {
      commentiScadenze.remove(campo);
    } else {
      commentiScadenze[campo] = commento;
    }
    final record = await _pb.collection('cantieri').update(cantiere.id, body: {
      campo: data.toIso8601String(),
      'commenti_scadenze': commentiScadenze,
    });
    _sostituisci(Cantiere.fromRecord(record));
  }

  /// Elimina una singola scadenza generale del cantiere insieme alla sua nota
  /// e al suo commento. Per le scadenze generiche gli slot successivi risalgono
  /// di una posizione — come fa il form delle scadenze generali — così la
  /// numerazione resta compatta e non restano buchi in mezzo.
  Future<void> eliminaScadenzaGenerale(Cantiere cantiere, String campo) async {
    final noteScadenze = Map<String, String>.from(cantiere.noteScadenze);
    final commentiScadenze = Map<String, String>.from(cantiere.commentiScadenze);
    final body = <String, dynamic>{};

    if (campo == _campoMessaATerra) {
      body[_campoMessaATerra] = null;
      noteScadenze.remove(campo);
      commentiScadenze.remove(campo);
    } else {
      final indice = _campiScadenzeGeneriche.indexOf(campo);
      if (indice < 0) throw ArgumentError('Campo scadenza sconosciuto: $campo');

      final date = [
        cantiere.scadenzaGenerica1,
        cantiere.scadenzaGenerica2,
        cantiere.scadenzaGenerica3,
        cantiere.scadenzaGenerica4,
        cantiere.scadenzaGenerica5,
      ];
      final nomi = [
        cantiere.nomeScadenzaGenerica1,
        cantiere.nomeScadenzaGenerica2,
        cantiere.nomeScadenzaGenerica3,
        cantiere.nomeScadenzaGenerica4,
        cantiere.nomeScadenzaGenerica5,
      ];
      final note = [for (final c in _campiScadenzeGeneriche) noteScadenze[c] ?? ''];
      final commenti = [for (final c in _campiScadenzeGeneriche) commentiScadenze[c] ?? ''];

      for (var i = indice; i < _campiScadenzeGeneriche.length - 1; i++) {
        date[i] = date[i + 1];
        nomi[i] = nomi[i + 1];
        note[i] = note[i + 1];
        commenti[i] = commenti[i + 1];
      }
      date.last = '';
      nomi.last = '';
      note.last = '';
      commenti.last = '';

      for (var i = 0; i < _campiScadenzeGeneriche.length; i++) {
        final c = _campiScadenzeGeneriche[i];
        body[c] = date[i].isEmpty ? null : date[i];
        body['${c}_nome'] = nomi[i];
        if (note[i].isEmpty) {
          noteScadenze.remove(c);
        } else {
          noteScadenze[c] = note[i];
        }
        if (commenti[i].isEmpty) {
          commentiScadenze.remove(c);
        } else {
          commentiScadenze[c] = commenti[i];
        }
      }
    }

    body['note_scadenze'] = noteScadenze;
    body['commenti_scadenze'] = commentiScadenze;
    final record = await _pb.collection('cantieri').update(cantiere.id, body: body);
    _sostituisci(Cantiere.fromRecord(record));
  }

  /// Nota "prenotato"/"prenotata" per una singola scadenza del cantiere:
  /// scriverla blocca l'invio della mail di sollecito per quella scadenza
  /// (vedi backend/pb_hooks/notifiche.pb.js). Modificabile solo dalla
  /// sezione "Scadenze imminenti". [campo] è il nome stabile del campo
  /// scadenza ("scadenza_messa_a_terra", "scadenza_generica1", ...), non
  /// l'etichetta visualizzata.
  Future<void> updateNotaScadenza(Cantiere cantiere, String campo, String nota) async {
    final noteScadenze = Map<String, String>.from(cantiere.noteScadenze);
    if (nota.isEmpty) {
      noteScadenze.remove(campo);
    } else {
      noteScadenze[campo] = nota;
    }
    final record = await _pb
        .collection('cantieri')
        .update(cantiere.id, body: {'note_scadenze': noteScadenze});
    _sostituisci(Cantiere.fromRecord(record));
  }

  /// Commento libero per una singola scadenza del cantiere, indipendente da
  /// [updateNotaScadenza]: non blocca alcuna mail, è solo un promemoria
  /// modificabile in qualsiasi momento dalla pagina di dettaglio del
  /// cantiere.
  Future<void> updateCommentoScadenza(Cantiere cantiere, String campo, String commento) async {
    final commentiScadenze = Map<String, String>.from(cantiere.commentiScadenze);
    if (commento.isEmpty) {
      commentiScadenze.remove(campo);
    } else {
      commentiScadenze[campo] = commento;
    }
    final record = await _pb
        .collection('cantieri')
        .update(cantiere.id, body: {'commenti_scadenze': commentiScadenze});
    _sostituisci(Cantiere.fromRecord(record));
  }

  /// Elimina il cantiere. La pulizia delle tracce collegate (documenti del
  /// cantiere, id rimosso dagli elenchi `cantieri` di subappaltatori e
  /// dipendenti) la fa PocketBase a cascata: i provider interessati vanno
  /// riallineati dopo, cosa di cui si occupa `eliminaCantiereConTracce`.
  Future<void> delete(String id) async {
    await _pb.collection('cantieri').delete(id);
    rimuoviLocale(_cantieri, {id}, (c) => c.id);
    notifyListeners();
  }

  void _sostituisci(Cantiere cantiere) {
    sostituisciOrdinato(_cantieri, cantiere, (c) => c.id, _perNome);
    notifyListeners();
  }
}
