import 'package:flutter/foundation.dart';
import 'package:pocketbase/pocketbase.dart';

import '../models/documento.dart';
import '../models/tipo_scadenza.dart';
import '../services/pocketbase_service.dart';
import 'lista_locale.dart';
import '../l10n/app_localizations.dart';
import 'locale_provider.dart';

class DocumentiProvider extends ChangeNotifier {
  final PocketBase _pb = PocketBaseService.instance.pb;

  List<Documento> _documenti = [];
  List<Documento> get documenti => _documenti;

  bool isLoading = false;
  String? errorMessage;

  Future<void> load() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      final records = await _pb.collection('scadenze').getFullList(
            sort: '-created',
            expand: 'tipo_documento',
          );
      _documenti = records.map(Documento.fromRecord).toList();
    } on ClientException catch (e) {
      errorMessage = e.response['message'] as String? ?? lookupAppLocalizations(LocaleProvider.current).errorLoadingDocumenti;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Stesso ordinamento del `sort: '-created'` usato in [load]: il documento
  /// appena caricato è il più recente e finisce in cima.
  static int _perCreatedDecrescente(Documento a, Documento b) =>
      b.created.compareTo(a.created);

  /// Documenti generali di un cantiere (subappaltatore non compilato).
  List<Documento> perCantiere(String cantiereId) {
    return _documenti
        .where((d) => d.cantiereId == cantiereId && d.subappaltatoreId.isEmpty)
        .toList();
  }

  /// Documenti specifici cantiere+subappaltatore, e documenti generali del
  /// subappaltatore (validi su più cantieri, etichettati "condiviso" in UI).
  List<Documento> perSubappaltatore(String cantiereId, String subappaltatoreId) {
    return _documenti
        .where((d) =>
            d.subappaltatoreId == subappaltatoreId &&
            (d.cantiereId == cantiereId || d.cantiereId.isEmpty))
        .toList();
  }

  /// Tutti i documenti di un subappaltatore, su qualsiasi cantiere (o nessuno).
  List<Documento> perSubappaltatoreTutti(String subappaltatoreId) {
    return _documenti.where((d) => d.subappaltatoreId == subappaltatoreId).toList();
  }

  /// Documenti/certificazioni di un dipendente.
  List<Documento> perDipendente(String dipendenteId) {
    return _documenti.where((d) => d.dipendenteId == dipendenteId).toList();
  }

  /// Documenti/certificazioni di un insieme di dipendenti (es. quelli
  /// presenti in un cantiere per un dato subappaltatore).
  List<Documento> perDipendenti(List<String> dipendentiIds) {
    return _documenti.where((d) => dipendentiIds.contains(d.dipendenteId)).toList();
  }

  /// Documenti rilevanti per lo stato complessivo di un cantiere: quelli
  /// generali del cantiere più quelli dei subappaltatori assegnati ad esso.
  List<Documento> perCantiereConSubappaltatori(
    String cantiereId,
    List<String> subappaltatoriIds,
  ) {
    return [
      ...perCantiere(cantiereId),
      for (final subappaltatoreId in subappaltatoriIds)
        ...perSubappaltatore(cantiereId, subappaltatoreId),
    ];
  }

  /// Raggruppa per tipo_documento+cantiere+subappaltatore+dipendente e tiene
  /// solo la versione più recente (created decrescente) per la vista principale.
  List<Documento> soloUltimaVersione(List<Documento> lista) {
    final ordinati = [...lista]..sort((a, b) => b.created.compareTo(a.created));
    final visti = <String>{};
    final risultato = <Documento>[];
    for (final d in ordinati) {
      final chiave = _chiaveVersione(d);
      if (visti.add(chiave)) {
        risultato.add(d);
      }
    }
    return risultato;
  }

  /// Tutte le voci registrate nel tempo per una combinazione, più recente
  /// prima. Non è più consultabile dall'interfaccia (la scadenza si corregge
  /// con [updateScadenza]): serve a tenere insieme i record vecchi, che
  /// [soloUltimaVersione] nasconde e [deleteConStorico] elimina in blocco.
  List<Documento> storico(Documento riferimento) {
    return _documenti
        .where((d) => _chiaveVersione(d) == _chiaveVersione(riferimento))
        .toList()
      ..sort((a, b) => b.created.compareTo(a.created));
  }

  String _chiaveVersione(Documento d) =>
      '${d.tipoDocumentoId}|${d.cantiereId}|${d.subappaltatoreId}|${d.dipendenteId}';

  /// Registra la scadenza di un documento: il file non viene caricato, la
  /// copia resta archiviata in sede.
  Future<void> create({
    required String tipoDocumentoId,
    String? cantiereId,
    String? subappaltatoreId,
    String? dipendenteId,
    DateTime? dataScadenza,
    String? note,
    required String caricatoDaId,
  }) async {
    final record = await _pb.collection('scadenze').create(
      // L'expand serve per avere subito nome e giorni di preavviso della
      // tipologia, che il modello legge da lì (vedi Documento.fromRecord).
      expand: 'tipo_documento',
      body: {
        'tipo_documento': tipoDocumentoId,
        if (cantiereId != null && cantiereId.isNotEmpty) 'cantiere': cantiereId,
        if (subappaltatoreId != null && subappaltatoreId.isNotEmpty)
          'subappaltatore': subappaltatoreId,
        if (dipendenteId != null && dipendenteId.isNotEmpty)
          'dipendente': dipendenteId,
        if (dataScadenza != null)
          'data_scadenza': dataScadenza.toIso8601String(),
        'note': note ?? '',
        'caricato_da': caricatoDaId,
      },
    );
    inserisciOrdinato(_documenti, Documento.fromRecord(record), _perCreatedDecrescente);
    notifyListeners();
  }

  Future<void> delete(String id) async {
    await _pb.collection('scadenze').delete(id);
    rimuoviLocale(_documenti, {id}, (d) => d.record.id);
    notifyListeners();
  }

  /// Elimina un documento insieme a tutto il suo storico (tutte le versioni
  /// precedenti): senza questo, cancellare solo l'ultima versione fa
  /// "riemergere" quella precedente come nuova versione corrente, dando
  /// l'impressione che l'eliminazione non abbia avuto effetto.
  Future<void> deleteConStorico(Documento documento) async {
    await _eliminaTutti(storico(documento));
  }

  /// Corregge data di scadenza e nota di una scadenza già registrata: il
  /// rinnovo si fa cambiando la data qui, senza aggiungere una nuova voce.
  Future<void> updateScadenza(
    String id, {
    required DateTime? dataScadenza,
    required String note,
  }) async {
    final record = await _pb.collection('scadenze').update(
      id,
      // Stringa vuota: è così che si svuota un campo data su PocketBase.
      body: {
        'data_scadenza': dataScadenza?.toIso8601String() ?? '',
        'note': note,
      },
      expand: 'tipo_documento',
    );
    _sostituisci(Documento.fromRecord(record));
  }

  /// Nota "prenotato"/"prenotata" per questo documento, indipendente dalla
  /// nota generale ([updateNote]): blocca l'invio della mail di sollecito.
  /// Un record di documenti è già una sola scadenza, quindi basta un campo
  /// di testo (non serve una mappa per tipo come per macchinari/cantieri).
  Future<void> updateNotaScadenza(String id, String nota) async {
    final record = await _pb
        .collection('scadenze')
        .update(id, body: {'nota_scadenza': nota}, expand: 'tipo_documento');
    _sostituisci(Documento.fromRecord(record));
  }

  /// Elimina tutti i documenti legati a un cantiere (generali o specifici di
  /// un subappaltatore), senza toccare il cantiere: serve al pulsante
  /// "Elimina dati" di un cantiere concluso. Quando è il cantiere stesso a
  /// essere eliminato non serve chiamarla, ci pensa la cascata di PocketBase.
  Future<void> deletePerCantiere(String cantiereId) async {
    await _eliminaTutti(_documenti.where((d) => d.cantiereId == cantiereId).toList());
  }

  /// Elimina più documenti in parallelo con un solo aggiornamento della lista
  /// alla fine, invece di una rilettura completa della collection per ognuno.
  Future<void> _eliminaTutti(List<Documento> documenti) async {
    if (documenti.isEmpty) return;
    await Future.wait(
      documenti.map((d) => _pb.collection('scadenze').delete(d.record.id)),
    );
    rimuoviLocale(
      _documenti,
      documenti.map((d) => d.record.id).toSet(),
      (d) => d.record.id,
    );
    notifyListeners();
  }

  /// Riallinea le scadenze già caricate dopo la modifica di una tipologia.
  ///
  /// Nome e giorni di preavviso vivono sul tipo scadenza ma viaggiano dentro
  /// ogni documento come copia dell'`expand`: senza questo passaggio una
  /// tipologia rinominata continuerebbe a comparire col vecchio nome (e con la
  /// vecchia soglia di preavviso) su cantieri, subappaltatori e dipendenti fino
  /// al successivo caricamento completo.
  void aggiornaTipoScadenza(TipoScadenza tipo) {
    var modificati = false;
    for (var i = 0; i < _documenti.length; i++) {
      final documento = _documenti[i];
      if (documento.tipoDocumentoId != tipo.id) continue;
      _documenti[i] = documento.conTipoAggiornato(
        nome: tipo.nome,
        giorniPreavviso: tipo.giorniPreavviso,
      );
      modificati = true;
    }
    if (modificati) notifyListeners();
  }

  void _sostituisci(Documento documento) {
    sostituisciOrdinato(
      _documenti,
      documento,
      (d) => d.record.id,
      _perCreatedDecrescente,
    );
    notifyListeners();
  }
}
