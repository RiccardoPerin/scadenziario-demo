import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cantieri_provider.dart';
import '../providers/dipendenti_subappaltatori_provider.dart';
import '../providers/documenti_provider.dart';
import '../providers/subappaltatori_provider.dart';
import '../providers/tipi_scadenze_provider.dart';

/// Garantisce che le collection dell'area cantieri siano in memoria prima di
/// mostrare [child].
///
/// Le pagine di dettaglio (cantiere, subappaltatore, dipendente) leggono il
/// record che devono mostrare dalla lista già caricata dal provider e, se non
/// lo trovano, mostrano uno spinner in attesa. Arrivandoci dalla schermata
/// precedente i dati ci sono; aprendo invece l'indirizzo direttamente — un
/// link condiviso o un refresh del browser — nessuno li ha mai caricati e lo
/// spinner resterebbe lì per sempre.
///
/// Carica solo ciò che manca, quindi nella navigazione normale non costa
/// alcuna richiesta in più.
class DatiCantieriCaricati extends StatefulWidget {
  const DatiCantieriCaricati({super.key, required this.child});

  final Widget child;

  @override
  State<DatiCantieriCaricati> createState() => _DatiCantieriCaricatiState();
}

class _DatiCantieriCaricatiState extends State<DatiCantieriCaricati> {
  bool _richiesto = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_richiesto) return;
    _richiesto = true;

    final cantieri = context.read<CantieriProvider>();
    final subappaltatori = context.read<SubappaltatoriProvider>();
    final dipendenti = context.read<DipendentiSubappaltatoriProvider>();
    final documenti = context.read<DocumentiProvider>();
    final tipiScadenze = context.read<TipiScadenzeProvider>();

    Future.microtask(() {
      if (cantieri.cantieri.isEmpty) cantieri.load();
      if (subappaltatori.subappaltatori.isEmpty) subappaltatori.load();
      if (dipendenti.dipendenti.isEmpty) dipendenti.load();
      if (documenti.documenti.isEmpty) documenti.load();
      if (tipiScadenze.tipiScadenze.isEmpty) tipiScadenze.load();
    });
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
