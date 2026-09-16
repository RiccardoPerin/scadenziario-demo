import 'package:flutter_test/flutter_test.dart';
import 'package:gestionale_edile/providers/lista_locale.dart';

/// Elemento minimo con un id e una chiave di ordinamento, per verificare che
/// la lista aggiornata in memoria dopo una scrittura resti ordinata come
/// quella che tornerebbe dal server.
class _Voce {
  const _Voce(this.id, this.nome);
  final String id;
  final String nome;
}

String _id(_Voce v) => v.id;
int _perNome(_Voce a, _Voce b) => a.nome.compareTo(b.nome);

List<String> _nomi(List<_Voce> lista) => lista.map((v) => v.nome).toList();

void main() {
  group('inserisciOrdinato', () {
    test('inserisce in mezzo mantenendo l\'ordine', () {
      final lista = [const _Voce('1', 'Alfa'), const _Voce('3', 'Gamma')];
      inserisciOrdinato(lista, const _Voce('2', 'Beta'), _perNome);
      expect(_nomi(lista), ['Alfa', 'Beta', 'Gamma']);
    });

    test('inserisce in testa e in coda', () {
      final lista = [const _Voce('2', 'Beta')];
      inserisciOrdinato(lista, const _Voce('1', 'Alfa'), _perNome);
      inserisciOrdinato(lista, const _Voce('3', 'Gamma'), _perNome);
      expect(_nomi(lista), ['Alfa', 'Beta', 'Gamma']);
    });

    test('su lista vuota', () {
      final lista = <_Voce>[];
      inserisciOrdinato(lista, const _Voce('1', 'Alfa'), _perNome);
      expect(_nomi(lista), ['Alfa']);
    });

    test('a parità di chiave non scavalca chi c\'era già', () {
      final lista = [const _Voce('1', 'Alfa'), const _Voce('2', 'Beta')];
      inserisciOrdinato(lista, const _Voce('3', 'Alfa'), _perNome);
      expect(lista.map(_id).toList(), ['1', '3', '2']);
    });

    test('ordina come il sort di PocketBase, che distingue le maiuscole', () {
      final lista = <_Voce>[];
      for (final nome in ['beta', 'Alfa', 'Beta', 'alfa']) {
        inserisciOrdinato(lista, _Voce(nome, nome), _perNome);
      }
      final atteso = ['beta', 'Alfa', 'Beta', 'alfa']..sort();
      expect(_nomi(lista), atteso);
    });
  });

  group('sostituisciOrdinato', () {
    test('sostituisce sul posto quando la chiave non cambia', () {
      final lista = [
        const _Voce('1', 'Alfa'),
        const _Voce('2', 'Beta'),
        const _Voce('3', 'Gamma'),
      ];
      sostituisciOrdinato(lista, const _Voce('2', 'Beta'), _id, _perNome);
      expect(lista.map(_id).toList(), ['1', '2', '3']);
      expect(lista.length, 3);
    });

    test('riposiziona quando la chiave di ordinamento cambia', () {
      final lista = [
        const _Voce('1', 'Alfa'),
        const _Voce('2', 'Beta'),
        const _Voce('3', 'Gamma'),
      ];
      sostituisciOrdinato(lista, const _Voce('1', 'Zeta'), _id, _perNome);
      expect(_nomi(lista), ['Beta', 'Gamma', 'Zeta']);
      expect(lista.length, 3);
    });

    test('inserisce se l\'elemento non era in lista', () {
      final lista = [const _Voce('1', 'Alfa')];
      sostituisciOrdinato(lista, const _Voce('2', 'Beta'), _id, _perNome);
      expect(_nomi(lista), ['Alfa', 'Beta']);
    });
  });

  group('rimuoviLocale', () {
    test('rimuove solo gli id indicati', () {
      final lista = [
        const _Voce('1', 'Alfa'),
        const _Voce('2', 'Beta'),
        const _Voce('3', 'Gamma'),
      ];
      rimuoviLocale(lista, {'1', '3'}, _id);
      expect(lista.map(_id).toList(), ['2']);
    });

    test('ignora gli id non presenti', () {
      final lista = [const _Voce('1', 'Alfa')];
      rimuoviLocale(lista, {'99'}, _id);
      expect(lista.length, 1);
    });
  });
}
