import 'package:flutter_test/flutter_test.dart';
import 'package:gestionale_edile/services/stampa_tabella.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('genera il PDF anche con caratteri fuori dal set Latin-1', () async {
    final byte = await generaTabellaPdf(
      titolo: 'Macchinari',
      sottotitolo: '2 macchinari',
      colonne: const ['Modello', 'Proprietà', 'Note'],
      righe: [
        [
          const CellaPdf('Liebherr 132 EC-H8', grassetto: true),
          const CellaPdf('Leasing – UniCredit €1.200/mese'),
          const CellaPdf('“da revisionare” — officina Rossi'),
        ],
        [
          const CellaPdf('Manitou MT 1840', grassetto: true),
          const CellaPdf('Proprietà'),
          cellaScadenza('2020-01-15'),
        ],
      ],
    );

    expect(byte, isNotEmpty);
    expect(String.fromCharCodes(byte.take(4)), '%PDF');
  });
}
