/// Confronto "naturale" per i codici che mescolano lettere e numeri (A1, L2,
/// L10, ...). L'ordinamento alfabetico normale metterebbe L10 e L11 prima di
/// L2, perché confronta "1" con "2" carattere per carattere: qui invece i
/// gruppi di cifre si confrontano come numeri.
library;

/// Spezza il codice in blocchi alternati di cifre e non-cifre.
final _blocchi = RegExp(r'\d+|\D+');
final _soloCifre = RegExp(r'^\d+$');

/// Confronta due numeri scritti come stringa senza convertirli, così anche i
/// codici con tante cifre restano ordinati bene sul web (dove gli interi
/// grandi perdono precisione). A parità di cifre significative vince l'ordine
/// alfabetico, che sui numeri coincide con quello numerico.
int _confrontaNumeri(String a, String b) {
  final senzaZeri = RegExp(r'^0+(?=\d)');
  final na = a.replaceFirst(senzaZeri, '');
  final nb = b.replaceFirst(senzaZeri, '');
  if (na.length != nb.length) return na.length.compareTo(nb.length);
  return na.compareTo(nb);
}

/// Ordina i codici come li leggerebbe una persona: A1, A2, A8, L1, L2, L10,
/// L11. Le lettere sono confrontate ignorando maiuscole e minuscole.
int confrontaCodici(String a, String b) {
  final pezziA = _blocchi.allMatches(a.toLowerCase()).map((m) => m[0]!).toList();
  final pezziB = _blocchi.allMatches(b.toLowerCase()).map((m) => m[0]!).toList();
  for (var i = 0; i < pezziA.length && i < pezziB.length; i++) {
    final x = pezziA[i];
    final y = pezziB[i];
    final entrambiNumeri = _soloCifre.hasMatch(x) && _soloCifre.hasMatch(y);
    final esito = entrambiNumeri ? _confrontaNumeri(x, y) : x.compareTo(y);
    if (esito != 0) return esito;
  }
  // Il codice più corto (L1 rispetto a L1-bis) viene prima.
  return pezziA.length.compareTo(pezziB.length);
}
