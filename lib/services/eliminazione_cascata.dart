import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cantieri_provider.dart';
import '../providers/dipendenti_subappaltatori_provider.dart';
import '../providers/documenti_provider.dart';
import '../providers/subappaltatori_provider.dart';

/// Eliminazione di un record e di tutte le sue tracce collegate.
///
/// La pulizia vera e propria la fa PocketBase, in un'unica transazione, grazie
/// al `cascadeDelete` attivato sulle relazioni dalla migrazione
/// `1787662800_cascata_eliminazione.js`. Qui resta solo da riallineare le
/// liste tenute in memoria dai provider delle collection toccate di rimbalzo,
/// che non se ne accorgerebbero altrimenti.
///
/// Prima queste funzioni percorrevano la gerarchia a mano, un record alla
/// volta, e ogni singola scrittura si portava dietro una rilettura completa
/// della collection: eliminare un cantiere con qualche subappaltatore poteva
/// costare decine di richieste in sequenza.

/// Elimina un subappaltatore. PocketBase elimina a catena i suoi dipendenti,
/// i suoi documenti e i documenti di quei dipendenti.
Future<void> eliminaSubappaltatoreConTracce(
  BuildContext context,
  String subappaltatoreId,
) async {
  final subappaltatoriProvider = context.read<SubappaltatoriProvider>();
  final dipendentiProvider = context.read<DipendentiSubappaltatoriProvider>();
  final documentiProvider = context.read<DocumentiProvider>();

  await subappaltatoriProvider.delete(subappaltatoreId);
  await Future.wait([dipendentiProvider.load(), documentiProvider.load()]);
}

/// Elimina un dipendente di un subappaltatore. PocketBase elimina a catena i
/// suoi documenti (storico compreso); la presenza nei cantieri è salvata sul
/// dipendente stesso (campo `cantieri`), quindi sparisce con lui.
Future<void> eliminaDipendenteSubappaltatoreConTracce(
  BuildContext context,
  String dipendenteId,
) async {
  final dipendentiProvider = context.read<DipendentiSubappaltatoriProvider>();
  final documentiProvider = context.read<DocumentiProvider>();

  await dipendentiProvider.delete(dipendenteId);
  await documentiProvider.load();
}

/// Elimina un cantiere. PocketBase elimina a catena i documenti del cantiere
/// (compresi quelli specifici dei subappaltatori che vi lavoravano) e toglie
/// l'id del cantiere dagli elenchi `cantieri` di subappaltatori e dipendenti,
/// che restano invece al loro posto.
Future<void> eliminaCantiereConTracce(
  BuildContext context,
  String cantiereId,
) async {
  final cantieriProvider = context.read<CantieriProvider>();
  final subappaltatoriProvider = context.read<SubappaltatoriProvider>();
  final dipendentiProvider = context.read<DipendentiSubappaltatoriProvider>();
  final documentiProvider = context.read<DocumentiProvider>();

  await cantieriProvider.delete(cantiereId);
  await Future.wait([
    subappaltatoriProvider.load(),
    dipendentiProvider.load(),
    documentiProvider.load(),
  ]);
}

/// Elimina più cantieri (con le stesse regole di [eliminaCantiereConTracce])
/// riallineando i provider una sola volta alla fine, invece di una volta per
/// cantiere: serve a "Elimina cantieri" dell'archivio.
Future<void> eliminaCantieriConTracce(
  BuildContext context,
  List<String> cantieriIds,
) async {
  if (cantieriIds.isEmpty) return;
  final cantieriProvider = context.read<CantieriProvider>();
  final subappaltatoriProvider = context.read<SubappaltatoriProvider>();
  final dipendentiProvider = context.read<DipendentiSubappaltatoriProvider>();
  final documentiProvider = context.read<DocumentiProvider>();

  for (final id in cantieriIds) {
    await cantieriProvider.delete(id);
  }
  await Future.wait([
    subappaltatoriProvider.load(),
    dipendentiProvider.load(),
    documentiProvider.load(),
  ]);
}
