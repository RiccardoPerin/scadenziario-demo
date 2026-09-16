/// Aggiornamento in memoria della lista di un provider dopo una scrittura,
/// al posto di rileggere l'intera collection dal server.
///
/// PocketBase restituisce già il record creato/aggiornato, quindi una
/// scrittura può costare una sola richiesta invece di due (di cui una
/// `getFullList`). L'ordinamento viene mantenuto con lo stesso criterio usato
/// nel parametro `sort` della `load()` del provider, così la lista in memoria
/// resta identica a quella che tornerebbe dal server.
library;

/// Inserisce [nuovo] nella posizione che gli spetta secondo [confronta].
void inserisciOrdinato<T>(List<T> lista, T nuovo, int Function(T, T) confronta) {
  final posizione = lista.indexWhere((e) => confronta(nuovo, e) < 0);
  if (posizione < 0) {
    lista.add(nuovo);
  } else {
    lista.insert(posizione, nuovo);
  }
}

/// Sostituisce l'elemento con lo stesso id di [aggiornato], riposizionandolo
/// se la chiave di ordinamento è cambiata (es. un cantiere rinominato).
/// Se l'elemento non è in lista viene semplicemente inserito.
void sostituisciOrdinato<T>(
  List<T> lista,
  T aggiornato,
  String Function(T) idDi,
  int Function(T, T) confronta,
) {
  lista.removeWhere((e) => idDi(e) == idDi(aggiornato));
  inserisciOrdinato(lista, aggiornato, confronta);
}

/// Rimuove dalla lista gli elementi con uno degli [ids] indicati.
void rimuoviLocale<T>(List<T> lista, Set<String> ids, String Function(T) idDi) {
  lista.removeWhere((e) => ids.contains(idDi(e)));
}
