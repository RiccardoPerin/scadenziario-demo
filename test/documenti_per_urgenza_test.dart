import 'package:flutter_test/flutter_test.dart';
import 'package:gestionale_edile/models/documento.dart';
import 'package:gestionale_edile/services/stato_scadenze.dart';
import 'package:pocketbase/pocketbase.dart';

/// Le date sono relative a oggi perché [computeStato] confronta con
/// `DateTime.now()`: con date fisse il test cambierebbe esito col passare
/// del tempo.
final _oggi = DateTime.now();
DateTime _fraGiorni(int giorni) => _oggi.add(Duration(days: giorni));

Documento _documento(
  String id, {
  DateTime? scadenza,
  DateTime? caricatoIl,
}) {
  return Documento.fromRecord(RecordModel({
    'id': id,
    'data_scadenza': scadenza?.toIso8601String() ?? '',
    'created': (caricatoIl ?? DateTime(2020)).toIso8601String(),
  }));
}

List<String> _ids(List<Documento> documenti) =>
    documenti.map((d) => d.record.id).toList();

void main() {
  group('documentiPerUrgenza', () {
    test('mette prima gli scaduti, poi gli in scadenza, infine i validi', () {
      final ordinati = documentiPerUrgenza([
        _documento('valido', scadenza: _fraGiorni(100)),
        _documento('in-scadenza', scadenza: _fraGiorni(10)),
        _documento('scaduto', scadenza: _fraGiorni(-5)),
      ]);
      expect(_ids(ordinati), ['scaduto', 'in-scadenza', 'valido']);
    });

    test('fra gli scaduti viene prima quello fermo da più tempo', () {
      final ordinati = documentiPerUrgenza([
        _documento('scaduto-ieri', scadenza: _fraGiorni(-1)),
        _documento('scaduto-da-mesi', scadenza: _fraGiorni(-90)),
      ]);
      expect(_ids(ordinati), ['scaduto-da-mesi', 'scaduto-ieri']);
    });

    test('fra gli in scadenza viene prima quello più imminente', () {
      final ordinati = documentiPerUrgenza([
        _documento('fra-25-giorni', scadenza: _fraGiorni(25)),
        _documento('domani', scadenza: _fraGiorni(1)),
      ]);
      expect(_ids(ordinati), ['domani', 'fra-25-giorni']);
    });

    test('i documenti senza scadenza chiudono la lista', () {
      final ordinati = documentiPerUrgenza([
        _documento('senza-scadenza'),
        _documento('valido', scadenza: _fraGiorni(200)),
        _documento('scaduto', scadenza: _fraGiorni(-3)),
      ]);
      expect(_ids(ordinati), ['scaduto', 'valido', 'senza-scadenza']);
    });

    test('a parità di stato e scadenza viene prima il caricamento più recente', () {
      final scadenza = _fraGiorni(-10);
      final ordinati = documentiPerUrgenza([
        _documento('vecchio', scadenza: scadenza, caricatoIl: DateTime(2024, 1, 1)),
        _documento('recente', scadenza: scadenza, caricatoIl: DateTime(2025, 1, 1)),
      ]);
      expect(_ids(ordinati), ['recente', 'vecchio']);
    });

    test('non modifica la lista ricevuta', () {
      final originale = [
        _documento('valido', scadenza: _fraGiorni(100)),
        _documento('scaduto', scadenza: _fraGiorni(-5)),
      ];
      documentiPerUrgenza(originale);
      expect(_ids(originale), ['valido', 'scaduto']);
    });

    test('lista vuota', () {
      expect(documentiPerUrgenza([]), isEmpty);
    });
  });
}
