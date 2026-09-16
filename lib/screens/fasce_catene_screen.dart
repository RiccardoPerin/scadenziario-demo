import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//import 'package:badges/badges.dart' as badges;

import '../l10n/app_localizations.dart';
import '../models/automezzo.dart';
import '../models/benna.dart';
import '../models/cantiere.dart';
import '../models/fascia_catena.dart';
import '../providers/automezzi_provider.dart';
import '../providers/benne_provider.dart';
import '../providers/cantieri_provider.dart';
import '../providers/fasce_catene_provider.dart';
import '../services/ordinamento_codici.dart';
import '../services/pocketbase_service.dart';
import '../services/stato_scadenze.dart';
import '../widgets/app_bar.dart';
import '../widgets/app_drawer.dart';
import '../widgets/campo_info.dart';
import '../widgets/benna_form_dialog.dart';
import '../widgets/confirm_dialog.dart';
import '../widgets/fascia_catena_form_dialog.dart';
import '../widgets/info_dialog.dart';
//import '../widgets/nota_scadenza_benna_dialog.dart';
//import '../widgets/nota_scadenza_fascia_catena_dialog.dart';
import '../widgets/responsive_card_grid.dart';
import '../widgets/stato_badge.dart';
import '../widgets/voce_info.dart';

/// Testo su cui lavora la ricerca libera: tutto ciò che identifica una
/// fascia/catena (id interno, numero di serie, tipo, colore) più la sua
/// ubicazione, così da poterla cercare anche per nome del cantiere.
String _testoRicerca(
  FasciaCatena f,
  List<Cantiere> cantieri,
  List<Automezzo> automezzi,
  AppLocalizations l10n,
) {
  return [
    f.idInterno,
    f.numeroSerie,
    etichettaTipoFascia(f.tipoFascia),
    f.colore,
    ..._descrizioneUbicazione(f, cantieri, automezzi, l10n),
  ].join(' ').toLowerCase();
}

List<String> _descrizioneUbicazione(
  FasciaCatena f,
  List<Cantiere> cantieri,
  List<Automezzo> automezzi,
  AppLocalizations l10n,
) {
  final descrizioni = <String>[];
  if (f.inMagazzino) descrizioni.add(l10n.fasceCateneScreenInMagazzino);
  if (f.ubicazioneCantiereId.isNotEmpty) {
    final nome =
        cantieri
            .where((c) => c.id == f.ubicazioneCantiereId)
            .map((c) => c.nome)
            .firstOrNull ??
        f.ubicazioneCantiereId;
    descrizioni.add(l10n.fasceCateneScreenInCantiere(nome));
  }
  if (f.ubicazioneAutomezzoId.isNotEmpty) {
    final nome =
        automezzi
            .where((a) => a.id == f.ubicazioneAutomezzoId)
            .map((a) => a.descrizioneConTarga)
            .firstOrNull ??
        f.ubicazioneAutomezzoId;
    descrizioni.add(l10n.fasceCateneScreenSuAutomezzo(nome));
  }
  return descrizioni;
}

String _ubicazioneVoce(
  FasciaCatena f,
  List<Cantiere> cantieri,
  List<Automezzo> automezzi,
  AppLocalizations l10n,
) {
  final descrizioni = _descrizioneUbicazione(f, cantieri, automezzi, l10n);
  return descrizioni.isEmpty
      ? l10n.fasceCateneScreenNonSpecificata
      : descrizioni.join(', ');
}

String _ubicazioneTesto(
  FasciaCatena f,
  List<Cantiere> cantieri,
  List<Automezzo> automezzi,
  AppLocalizations l10n,
) {
  final descrizioni = _descrizioneUbicazione(f, cantieri, automezzi, l10n);
  return descrizioni.isEmpty ? '-' : descrizioni.join(', ');
}

/// Come [_descrizioneUbicazione], per le benne: la loro collection non ha il
/// campo `ubicazione_automezzo`, quindi restano magazzino e cantiere.
List<String> _descrizioneUbicazioneBenna(
  Benna b,
  List<Cantiere> cantieri,
  AppLocalizations l10n,
) {
  final descrizioni = <String>[];
  if (b.inMagazzino) descrizioni.add(l10n.fasceCateneScreenInMagazzino);
  if (b.ubicazioneCantiereId.isNotEmpty) {
    final nome =
        cantieri
            .where((c) => c.id == b.ubicazioneCantiereId)
            .map((c) => c.nome)
            .firstOrNull ??
        b.ubicazioneCantiereId;
    descrizioni.add(l10n.fasceCateneScreenInCantiere(nome));
  }
  return descrizioni;
}

String _ubicazioneVoceBenna(
  Benna b,
  List<Cantiere> cantieri,
  AppLocalizations l10n,
) {
  final descrizioni = _descrizioneUbicazioneBenna(b, cantieri, l10n);
  return descrizioni.isEmpty
      ? l10n.fasceCateneScreenNonSpecificata
      : descrizioni.join(', ');
}

String _ubicazioneTestoBenna(
  Benna b,
  List<Cantiere> cantieri,
  AppLocalizations l10n,
) {
  final descrizioni = _descrizioneUbicazioneBenna(b, cantieri, l10n);
  return descrizioni.isEmpty ? '-' : descrizioni.join(', ');
}

String _testoRicercaBenna(Benna b, List<Cantiere> cantieri, AppLocalizations l10n) {
  return [
    b.idInterno,
    b.numeroSerie,
    'benna',
    b.descrizione,
    ..._descrizioneUbicazioneBenna(b, cantieri, l10n),
  ].join(' ').toLowerCase();
}

/// Confronta due tile in base al nome del file della foto, con i numeri letti
/// come numeri (foto10 dopo foto2). Chi non ha una foto non ha nulla da
/// confrontare e chiude l'elenco del suo gruppo.
int _perNomeFoto(String a, String b) {
  if (a.isEmpty || b.isEmpty) return a.isEmpty ? (b.isEmpty ? 0 : 1) : -1;
  return confrontaCodici(a, b);
}

/// Le fasce/catene raggruppate per tipo, nell'ordine di [tipiFascia]; i record
/// senza tipo (o con un tipo non più previsto dalla collection) finiscono in
/// un gruppo finale, così non spariscono dalla pagina. Dentro ogni gruppo le
/// tile sono in ordine di nome del file della foto. I gruppi vuoti non vengono
/// restituiti.
List<({String tipo, List<FasciaCatena> fasceCatene})> _perTipo(
  List<FasciaCatena> fasceCatene,
) {
  final gruppi = <String, List<FasciaCatena>>{};
  for (final f in fasceCatene) {
    final tipo = tipiFascia.contains(f.tipoFascia) ? f.tipoFascia : '';
    gruppi.putIfAbsent(tipo, () => []).add(f);
  }
  for (final gruppo in gruppi.values) {
    gruppo.sort((a, b) => _perNomeFoto(a.foto, b.foto));
  }
  return [
    for (final tipo in [...tipiFascia, ''])
      if (gruppi[tipo] != null) (tipo: tipo, fasceCatene: gruppi[tipo]!),
  ];
}

/*
/// Una riga della sezione "Scadenze imminenti". Testi e azioni sono già
/// risolti da chi la costruisce, così la stessa riga vale sia per una
/// fascia/catena sia per una benna.
typedef _VoceScadenza = ({
  String titolo,
  String sottotitolo,
  DateTime scadenza,
  StatoScadenza stato,
  void Function(BuildContext context) apriScheda,
  void Function(BuildContext context) apriNota,
});
*/

/// L'esito ha senso solo se una verifica è stata fatta: senza data resta '-'
/// invece di un "Negativo" che nessuno ha mai registrato.
String _esitoTesto(String dataUltimaVerifica, bool esitoVerifica, AppLocalizations l10n) {
  if (dataUltimaVerifica.isEmpty) return '-';
  return esitoVerifica ? l10n.fasceCateneScreenEsitoPositivo : l10n.fasceCateneScreenEsitoNegativo;
}

/*
List<_VoceScadenza> _vociScadenza({
  required List<FasciaCatena> fasceCatene,
  required List<Benna> benne,
  required List<Cantiere> cantieri,
  required List<Automezzo> automezzi,
  required FasceCateneProvider fasceCateneProvider,
  required BenneProvider benneProvider,
}) {
  final voci = <_VoceScadenza>[];

  void aggiungi({
    required String idInterno,
    required String descrizioneTipo,
    required List<String> ubicazione,
    required String notaScadenza,
    required String dataUltimaVerifica,
    required String dataProssimaVerifica,
    required bool scartato,
    required void Function(BuildContext) apriScheda,
    required void Function(BuildContext) apriNota,
  }) {
    final sottotitolo = [
      'ID: $idInterno',
      descrizioneTipo,
      ...ubicazione,
      if (notaScadenza.isNotEmpty) 'Nota scadenza: $notaScadenza',
    ].join(' · ');

    if (scartato) {
      voci.add((
        titolo: 'Verifica con esito negativo',
        sottotitolo: sottotitolo,
        scadenza: parseData(dataUltimaVerifica) ?? DateTime.now(),
        stato: StatoScadenza.scaduto,
        apriScheda: apriScheda,
        apriNota: apriNota,
      ));
      return;
    }
    final data = parseData(dataProssimaVerifica);
    if (data == null) return;
    final stato = computeStato(data);
    if (stato == StatoScadenza.valido) return;
    voci.add((
      titolo: 'Prossima verifica',
      sottotitolo: sottotitolo,
      scadenza: data,
      stato: stato,
      apriScheda: apriScheda,
      apriNota: apriNota,
    ));
  }

  for (final f in fasceCatene) {
    aggiungi(
      idInterno: f.idInterno,
      descrizioneTipo: etichettaTipoFascia(f.tipoFascia),
      ubicazione: _descrizioneUbicazione(f, cantieri, automezzi),
      notaScadenza: f.notaScadenza,
      dataUltimaVerifica: f.dataUltimaVerificaInterna,
      dataProssimaVerifica: f.dataProssimaVerifica,
      scartato: fasciaCatenaScartata(f),
      apriScheda: (context) => showFasciaCatenaFormDialog(
        context,
        provider: fasceCateneProvider,
        cantieri: cantieri,
        automezzi: automezzi,
        esistente: f,
      ),
      apriNota: (context) => showNotaFasciaCatenaDialog(
        context,
        provider: fasceCateneProvider,
        fasciaCatena: f,
      ),
    );
  }

  for (final b in benne) {
    aggiungi(
      idInterno: b.idInterno,
      descrizioneTipo: 'Benna',
      ubicazione: _descrizioneUbicazioneBenna(b, cantieri),
      notaScadenza: b.notaScadenza,
      dataUltimaVerifica: b.dataUltimaVerificaInterna,
      dataProssimaVerifica: b.dataProssimaVerifica,
      scartato: bennaScartata(b),
      apriScheda: (context) => showBennaFormDialog(
        context,
        provider: benneProvider,
        cantieri: cantieri,
        esistente: b,
      ),
      apriNota: (context) => showNotaBennaDialog(
        context,
        provider: benneProvider,
        benna: b,
      ),
    );
  }

  voci.sort((a, b) => a.scadenza.compareTo(b.scadenza));
  return voci;
}
*/

class FasceCateneScreen extends StatefulWidget {
  const FasceCateneScreen({super.key});

  @override
  State<FasceCateneScreen> createState() => _FasceCateneScreenState();
}

class _FasceCateneScreenState extends State<FasceCateneScreen> {
  bool _loaded = false;
  final _searchController = TextEditingController();
  String _query = '';
  final _espanse = <String>{};
  //bool _scadenzeImminentiEspanse = false;
  bool _fasceCateneEspanse = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_loaded) {
      _loaded = true;
      final cantieriProvider = context.read<CantieriProvider>();
      final automezziProvider = context.read<AutomezziProvider>();
      final fasceCateneProvider = context.read<FasceCateneProvider>();
      final benneProvider = context.read<BenneProvider>();
      Future.microtask(() {
        fasceCateneProvider.load();
        benneProvider.load();
        cantieriProvider.load();
        automezziProvider.load();
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final titolo = l10n.fasceCateneScreenTitle;
    final primaryBlue = Theme.of(context).colorScheme.primary;
    final cantieriProvider = context.watch<CantieriProvider>();
    final automezziProvider = context.watch<AutomezziProvider>();
    final fasceCateneProvider = context.watch<FasceCateneProvider>();
    final benneProvider = context.watch<BenneProvider>();

    final erroreCaricamento =
        cantieriProvider.errorMessage ??
        automezziProvider.errorMessage ??
        fasceCateneProvider.errorMessage ??
        benneProvider.errorMessage;

    final query = _query.trim().toLowerCase();
    final fasceCateneFiltrate = fasceCateneProvider.fasceCatene
        .where(
          (f) =>
              query.isEmpty ||
              _testoRicerca(
                f,
                cantieriProvider.cantieri,
                automezziProvider.automezzi,
                l10n,
              ).contains(query),
        )
        .toList();
    // Le benne sono un gruppo a sé: anche qui le tile seguono il nome della
    // foto, come dentro i gruppi per tipo.
    final benneFiltrate = benneProvider.benne
        .where(
          (b) =>
              query.isEmpty ||
              _testoRicercaBenna(b, cantieriProvider.cantieri, l10n).contains(query),
        )
        .toList()
      ..sort((a, b) => _perNomeFoto(a.foto, b.foto));
    final gruppi = _perTipo(fasceCateneFiltrate);
    
    /*
    final scadenzeImminenti = _vociScadenza(
      fasceCatene: fasceCateneProvider.fasceCatene,
      benne: benneProvider.benne,
      cantieri: cantieriProvider.cantieri,
      automezzi: automezziProvider.automezzi,
      fasceCateneProvider: fasceCateneProvider,
      benneProvider: benneProvider,
    );
    */

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: titolo,
        actions: [
          AppBarAction(
            icon: Icons.add_outlined,
            label: l10n.fasceCateneScreenNuovaFasciaCatena,
            onPressed: () => showFasciaCatenaFormDialog(
              context,
              provider: fasceCateneProvider,
              cantieri: cantieriProvider.cantieri,
              automezzi: automezziProvider.automezzi,
            ),
          ),
          AppBarAction(
            icon: Icons.add_outlined,
            label: l10n.fasceCateneScreenInserisciBenna,
            onPressed: () => showBennaFormDialog(
              context,
              provider: benneProvider,
              cantieri: cantieriProvider.cantieri,
            ),
          ),
        ],
      ),
      drawer: const AppDrawer(current: 'Fasce/Catene'),
      body: fasceCateneProvider.isLoading && cantieriProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async {
                await cantieriProvider.load();
                await automezziProvider.load();
                await fasceCateneProvider.load();
                await benneProvider.load();
              },
              child: ListView(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
                children: [
                  const SizedBox(height: 15),
                  if (erroreCaricamento != null) ...[
                    Card(
                      color: Theme.of(context).colorScheme.errorContainer,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            const Icon(Icons.error_outline),
                            const SizedBox(width: 8),
                            Expanded(child: Text(erroreCaricamento)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  /*
                  if (scadenzeImminenti.isNotEmpty) ...[
                    Row(
                      children: [
                        badges.Badge(
                          badgeContent: Text(
                            '${scadenzeImminenti.length}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          badgeStyle: badges.BadgeStyle(badgeColor: Colors.black),
                          position: badges.BadgePosition.topEnd(top: -10, end: -25),
                          child: const Text(
                            'Scadenze imminenti',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 22,
                            ),
                          ),
                        ),
                        const SizedBox(width: 25),
                        IconButton(
                          onPressed: () => showNoteScadenzaInfoDialog(context),
                          icon: Icon(Icons.info_outline, size: 20, color: Colors.black),
                        ),
                        IconButton(
                          tooltip: _scadenzeImminentiEspanse
                              ? 'Nascondi scadenze'
                              : 'Mostra scadenze',
                          onPressed: () => setState(
                            () => _scadenzeImminentiEspanse = !_scadenzeImminentiEspanse,
                          ),
                          icon: Icon(
                            _scadenzeImminentiEspanse
                                ? Icons.unfold_less_outlined
                                : Icons.unfold_more_outlined,
                            color: Colors.black,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    AnimatedSize(
                      duration: const Duration(milliseconds: 400),
                      alignment: Alignment.topCenter,
                      child: !_scadenzeImminentiEspanse
                          ? const SizedBox(width: double.infinity)
                          : _ScadenzeImminenti(voci: scadenzeImminenti),
                    ),
                    const SizedBox(height: 24),
                  ],
                  */
                  Row(
                    children: [
                      Text(
                        l10n.fasceCateneScreenPresenti,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 22,
                          color: primaryBlue,
                        ),
                      ),
                      IconButton(
                        onPressed: () => showEmailScadenzaInfoDialog(context, titolo),
                          icon: Icon(Icons.info_outline, size: 20, color: primaryBlue),
                      ),
                      IconButton(
                        tooltip: _fasceCateneEspanse
                            ? l10n.fasceCateneScreenNascondiTutti
                            : l10n.fasceCateneScreenMostraTutti,
                        onPressed: () {
                          setState(() {
                            _fasceCateneEspanse = !_fasceCateneEspanse;
                            if (_fasceCateneEspanse) {
                              _espanse.addAll(
                                fasceCateneProvider.fasceCatene.map((f) => f.id),
                              );
                              _espanse.addAll(benneProvider.benne.map((b) => b.id));
                            } else {
                              _espanse.clear();
                            }
                          });
                        },
                        icon: Icon(
                          _fasceCateneEspanse
                              ? Icons.unfold_less_outlined
                              : Icons.unfold_more_outlined,
                          color: primaryBlue,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: Icon(Icons.search, color: primaryBlue),
                      hintText: l10n.fasceCateneScreenSearchHint,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(color: Colors.black54, width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: primaryBlue, width: 2),
                      ),
                    ),
                    onChanged: (v) => setState(() => _query = v),
                  ),
                  const SizedBox(height: 20),
                  if (gruppi.isEmpty && benneFiltrate.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Center(
                        child: Text(
                          fasceCateneProvider.fasceCatene.isEmpty &&
                                  benneProvider.benne.isEmpty
                              ? l10n.fasceCateneScreenNessunElementoCaricato
                              : l10n.fasceCateneScreenNessunElementoTrovato(_query.trim()),
                        ),
                      ),
                    )
                  else ...[
                    for (var i = 0; i < gruppi.length; i++) ...[
                      if (i > 0) const SizedBox(height: 28),
                      _IntestazioneTipo(
                        etichetta: etichettaTipoFascia(gruppi[i].tipo),
                        quantita: gruppi[i].fasceCatene.length,
                      ),
                      const SizedBox(height: 12),
                      ColumnsCardGrid(
                        maxColumns: 2,
                        minWidth: 380,
                        children: gruppi[i].fasceCatene.map((f) {
                          final espansa = _espanse.contains(f.id);
                          return _FasciaCatenaCard(
                            fasciaCatena: f,
                            provider: fasceCateneProvider,
                            cantieri: cantieriProvider.cantieri,
                            automezzi: automezziProvider.automezzi,
                            espansa: espansa,
                            onToggleEspansa: () => setState(() {
                              if (espansa) {
                                _espanse.remove(f.id);
                              } else {
                                _espanse.add(f.id);
                              }
                            }),
                          );
                        }).toList(),
                      ),
                    ],
                    // Le benne chiudono sempre la pagina, dopo tutti i tipi di
                    // fascia/catena.
                    if (benneFiltrate.isNotEmpty) ...[
                      if (gruppi.isNotEmpty) const SizedBox(height: 28),
                      _IntestazioneTipo(
                        etichetta: l10n.fasceCateneScreenBenneAutoscaricanti,
                        quantita: benneFiltrate.length,
                      ),
                      const SizedBox(height: 12),
                      ColumnsCardGrid(
                        maxColumns: 2,
                        minWidth: 380,
                        children: benneFiltrate.map((b) {
                          final espansa = _espanse.contains(b.id);
                          return _BennaCard(
                            benna: b,
                            provider: benneProvider,
                            cantieri: cantieriProvider.cantieri,
                            espansa: espansa,
                            onToggleEspansa: () => setState(() {
                              if (espansa) {
                                _espanse.remove(b.id);
                              } else {
                                _espanse.add(b.id);
                              }
                            }),
                          );
                        }).toList(),
                      ),
                    ],
                  ],
                ],
              ),
            ),
    );
  }
}

/// Titolo di un gruppo di tile ("Fasce di carico", ...) con il numero di
/// elementi e la riga che lo separa dal gruppo precedente.
class _IntestazioneTipo extends StatelessWidget {
  const _IntestazioneTipo({required this.etichetta, required this.quantita});

  final String etichetta;
  final int quantita;

  @override
  Widget build(BuildContext context) {
    final primaryBlue = Theme.of(context).colorScheme.primary;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              etichetta,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 17,
                color: primaryBlue,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '($quantita)',
              style: const TextStyle(color: Colors.black54, fontSize: 14),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Divider(height: 1, color: primaryBlue.withValues(alpha: 0.35)),
      ],
    );
  }
}

/*
class _ScadenzeImminenti extends StatelessWidget {
  const _ScadenzeImminenti({required this.voci});

  final List<_VoceScadenza> voci;

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < kMobileAppBarBreakpoint;
    final primaryBlue = Theme.of(context).colorScheme.primary;
    final elenco = voci.take(10).toList();
    return Card(
      child: Column(
        children: [
          for (var i = 0; i < elenco.length; i++) ...[
            if (i > 0) const Divider(height: 1, color: Color(0xFFE0E0E0)),
            Builder(
              builder: (context) {
                final voce = elenco[i];
                return ListTile(
                  leading: StatoBadge(stato: voce.stato, showLabel: !isMobile),
                  title: Text(
                    voce.titolo,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  subtitle: Text(voce.sottotitolo),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.edit_note_rounded,
                          color: primaryBlue,
                          size: isMobile ? 18 : 22,
                        ),
                        tooltip: 'Modifica nota',
                        onPressed: () => voce.apriNota(context),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        '${voce.scadenza.day.toString().padLeft(2, '0')}/'
                        '${voce.scadenza.month.toString().padLeft(2, '0')}/'
                        '${voce.scadenza.year}',
                      ),
                    ],
                  ),
                  onTap: () => voce.apriScheda(context),
                );
              },
            ),
          ],
        ],
      ),
    );
  }
}
*/

class _FasciaCatenaCard extends StatelessWidget {
  const _FasciaCatenaCard({
    required this.fasciaCatena,
    required this.provider,
    required this.cantieri,
    required this.automezzi,
    required this.espansa,
    required this.onToggleEspansa,
  });

  final FasciaCatena fasciaCatena;
  final FasceCateneProvider provider;
  final List<Cantiere> cantieri;
  final List<Automezzo> automezzi;
  final bool espansa;
  final VoidCallback onToggleEspansa;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final primaryBlue = Theme.of(context).colorScheme.primary;
    final isMobile = MediaQuery.sizeOf(context).width < kMobileAppBarBreakpoint;
    final stato = statoScadenzaFasciaCatena(fasciaCatena);
    final scartata = fasciaCatenaScartata(fasciaCatena);

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                StatoBadge(stato: stato, showLabel: false),
                const SizedBox(width: 12),
                _AnteprimaFoto(
                  haFoto: fasciaCatena.haFoto,
                  urlFoto: fasciaCatena.getImageUrl(PocketBaseService.instance.pb),
                  urlMiniatura: fasciaCatena.getImageUrl(
                    PocketBaseService.instance.pb,
                    thumb: '0x240',
                  ),
                  titolo: [
                    fasciaCatena.idInterno,
                    etichettaTipoFascia(fasciaCatena.tipoFascia),
                  ].join(' - '),
                ),
              ],
            ),
            title: Text(
              fasciaCatena.idInterno,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (fasciaCatena.numeroSerie != '')
                  VoceInfo(l10n.fasceCateneScreenNumeroSerie, fasciaCatena.numeroSerie),
                VoceInfo(
                  l10n.fasceCateneScreenUbicazione,
                  _ubicazioneVoce(fasciaCatena, cantieri, automezzi, l10n),
                ),
                VoceInfo(
                  l10n.fasceCateneScreenVerificaConEsito,
                  scartata
                      ? l10n.fasceCateneScreenEsitoNegativoLower
                      : l10n.fasceCateneScreenEsitoPositivoLower,
                ),
                if (fasciaCatena.note.isNotEmpty)
                  VoceInfo(l10n.commonNoteLabel, fasciaCatena.note),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.edit_outlined,
                    color: primaryBlue,
                    size: isMobile ? 18 : 22,
                  ),
                  tooltip: l10n.commonEdit,
                  onPressed: () => showFasciaCatenaFormDialog(
                    context,
                    provider: provider,
                    cantieri: cantieri,
                    automezzi: automezzi,
                    esistente: fasciaCatena,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.delete_outline,
                    color: primaryBlue,
                    size: isMobile ? 18 : 22,
                  ),
                  tooltip: l10n.commonDelete,
                  onPressed: () async {
                    final confermato = await showConfirmDialog(
                      context,
                      title: l10n.fasceCateneScreenEliminareFasciaCatenaTitle,
                      message: l10n.fasceCateneScreenConfirmDeleteMessage(fasciaCatena.idInterno),
                    );
                    if (confermato) {
                      await provider.delete(fasciaCatena.id);
                    }
                  },
                ),
                IconButton(
                  tooltip: espansa
                      ? l10n.fasceCateneScreenNascondiInfo
                      : l10n.fasceCateneScreenMostraInfo,
                  onPressed: onToggleEspansa,
                  icon: Icon(
                    espansa
                        ? Icons.keyboard_arrow_up_outlined
                        : Icons.keyboard_arrow_down_outlined,
                    color: primaryBlue,
                    size: isMobile ? 18 : 22,
                  ),
                ),
              ],
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 400),
            alignment: Alignment.topCenter,
            child: !espansa
                ? const SizedBox(width: double.infinity)
                : Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Divider(height: 1, color: Color(0xFFE0E0E0)),
                        const SizedBox(height: 12),
                        Text(
                          l10n.fasceCateneScreenAnagrafica,
                          style: TextStyle(fontWeight: FontWeight.w600, color: primaryBlue),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            campoInfo(l10n.fasceCateneScreenIdInterno, fasciaCatena.idInterno),
                            campoInfo(
                              l10n.fasceCateneScreenTipo,
                              etichettaTipoFascia(fasciaCatena.tipoFascia),
                              sotto: fasciaCatena.cricchetto ? l10n.fasceCateneScreenCricchetto : null,
                            ),
                            campoInfo(l10n.fasceCateneScreenNumeroSerieProduttore, fasciaCatena.numeroSerie),
                            campoInfo(l10n.fasceCateneScreenColore, fasciaCatena.colore),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          l10n.fasceCateneScreenCaratteristiche,
                          style: TextStyle(fontWeight: FontWeight.w600, color: primaryBlue),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            campoInfo(l10n.fasceCateneScreenPortataKg, fasciaCatena.portata),
                            campoInfo(l10n.fasceCateneScreenSpessoreMm, fasciaCatena.spessore),
                            if (fasciaCatena.tipoFascia == 'braca di catene')
                              campoInfo(l10n.fasceCateneScreenDiametroMm, fasciaCatena.diametro)
                            else
                              campoInfo(l10n.fasceCateneScreenLarghezzaMm, fasciaCatena.larghezza),
                            campoInfo(l10n.fasceCateneScreenLunghezzaM, fasciaCatena.lunghezza),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          l10n.fasceCateneScreenUbicazioneEAcquisto,
                          style: TextStyle(fontWeight: FontWeight.w600, color: primaryBlue),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            campoInfo(
                              l10n.fasceCateneScreenUbicazione,
                              _ubicazioneTesto(fasciaCatena, cantieri, automezzi, l10n),
                            ),
                            campoInfo(l10n.fasceCateneScreenDataAcquisto, formatData(fasciaCatena.dataAcquisto)),
                            campoInfo(l10n.fasceCateneScreenLuogoAcquisto, fasciaCatena.luogoAcquisto),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          l10n.fasceCateneScreenVerificaInterna,
                          style: TextStyle(fontWeight: FontWeight.w600, color: primaryBlue),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            campoInfo(
                              l10n.fasceCateneScreenUltimaVerifica,
                              formatData(fasciaCatena.dataUltimaVerificaInterna),
                            ),
                            campoInfo(
                              l10n.fasceCateneScreenEsito,
                              _esitoTesto(
                                fasciaCatena.dataUltimaVerificaInterna,
                                fasciaCatena.esitoVerifica,
                                l10n,
                              ),
                              colore: scartata ? Colors.red : Colors.green,
                            ),
                            campoScadenza(l10n.fasceCateneScreenProssimaVerifica, fasciaCatena.dataProssimaVerifica),
                            campoInfo(l10n.commonNoteLabel, fasciaCatena.note),
                          ],
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _BennaCard extends StatelessWidget {
  const _BennaCard({
    required this.benna,
    required this.provider,
    required this.cantieri,
    required this.espansa,
    required this.onToggleEspansa,
  });

  final Benna benna;
  final BenneProvider provider;
  final List<Cantiere> cantieri;
  final bool espansa;
  final VoidCallback onToggleEspansa;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final primaryBlue = Theme.of(context).colorScheme.primary;
    final isMobile = MediaQuery.sizeOf(context).width < kMobileAppBarBreakpoint;
    final stato = statoScadenzaBenna(benna);
    final scartata = bennaScartata(benna);

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                StatoBadge(stato: stato, showLabel: false),
                const SizedBox(width: 12),
                _AnteprimaFoto(
                  haFoto: benna.haFoto,
                  urlFoto: benna.getImageUrl(PocketBaseService.instance.pb),
                  urlMiniatura: benna.getImageUrl(
                    PocketBaseService.instance.pb,
                    thumb: '0x240',
                  ),
                  titolo: l10n.fasceCateneScreenBennaTitolo(benna.idInterno),
                ),
              ],
            ),
            title: Text(
              benna.idInterno,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (benna.descrizione.isNotEmpty)
                  VoceInfo(l10n.fasceCateneScreenDescrizione, benna.descrizione),
                if (benna.numeroSerie.isNotEmpty)
                  VoceInfo(l10n.fasceCateneScreenNumeroSerie, benna.numeroSerie),
                VoceInfo(
                  l10n.fasceCateneScreenUbicazione,
                  _ubicazioneVoceBenna(benna, cantieri, l10n),
                ),
                VoceInfo(
                  l10n.fasceCateneScreenVerificaConEsito,
                  scartata
                      ? l10n.fasceCateneScreenEsitoNegativoLower
                      : l10n.fasceCateneScreenEsitoPositivoLower,
                ),
                if (benna.note.isNotEmpty) VoceInfo(l10n.commonNoteLabel, benna.note)
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.edit_outlined,
                    color: primaryBlue,
                    size: isMobile ? 18 : 22,
                  ),
                  tooltip: l10n.commonEdit,
                  onPressed: () => showBennaFormDialog(
                    context,
                    provider: provider,
                    cantieri: cantieri,
                    esistente: benna,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.delete_outline,
                    color: primaryBlue,
                    size: isMobile ? 18 : 22,
                  ),
                  tooltip: l10n.commonDelete,
                  onPressed: () async {
                    final confermato = await showConfirmDialog(
                      context,
                      title: l10n.fasceCateneScreenEliminareBennaTitle,
                      message: l10n.fasceCateneScreenConfirmDeleteMessage(benna.idInterno),
                    );
                    if (confermato) {
                      await provider.delete(benna.id);
                    }
                  },
                ),
                IconButton(
                  tooltip: espansa
                      ? l10n.fasceCateneScreenNascondiInfo
                      : l10n.fasceCateneScreenMostraInfo,
                  onPressed: onToggleEspansa,
                  icon: Icon(
                    espansa
                        ? Icons.keyboard_arrow_up_outlined
                        : Icons.keyboard_arrow_down_outlined,
                    color: primaryBlue,
                    size: isMobile ? 18 : 22,
                  ),
                ),
              ],
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 400),
            alignment: Alignment.topCenter,
            child: !espansa
                ? const SizedBox(width: double.infinity)
                : Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Divider(height: 1, color: Color(0xFFE0E0E0)),
                        const SizedBox(height: 12),
                        Text(
                          l10n.fasceCateneScreenAnagrafica,
                          style: TextStyle(fontWeight: FontWeight.w600, color: primaryBlue),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            campoInfo(l10n.fasceCateneScreenIdInterno, benna.idInterno),
                            campoInfo(l10n.fasceCateneScreenDescrizione, benna.descrizione),
                            campoInfo(l10n.fasceCateneScreenNumeroSerieProduttore, benna.numeroSerie),
                            campoInfo(l10n.fasceCateneScreenCapacitaCarico, benna.capacitaCarico),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          l10n.fasceCateneScreenUbicazioneEAcquisto,
                          style: TextStyle(fontWeight: FontWeight.w600, color: primaryBlue),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            campoInfo(
                              l10n.fasceCateneScreenUbicazione,
                              _ubicazioneTestoBenna(benna, cantieri, l10n),
                            ),
                            campoInfo(l10n.fasceCateneScreenDataAcquisto, formatData(benna.dataAcquisto)),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          l10n.fasceCateneScreenVerificaInterna,
                          style: TextStyle(fontWeight: FontWeight.w600, color: primaryBlue),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            campoInfo(
                              l10n.fasceCateneScreenUltimaVerifica,
                              formatData(benna.dataUltimaVerificaInterna),
                            ),
                            campoInfo(
                              l10n.fasceCateneScreenEsito,
                              _esitoTesto(
                                benna.dataUltimaVerificaInterna,
                                benna.esitoVerifica,
                                l10n,
                              ),
                              colore: scartata ? Colors.red : null,
                            ),
                            campoScadenza(l10n.fasceCateneScreenProssimaVerifica, benna.dataProssimaVerifica),
                            campoInfo(l10n.commonNoteLabel, benna.note),
                          ],
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

/// Lato del riquadro dell'anteprima: fisso per tutte le tile, con o senza
/// foto, così le intestazioni restano alte uguali. È anche ciò che determina
/// l'altezza della tile chiusa, essendo l'elemento più alto dell'intestazione.
const double _latoAnteprima = 56;

/// Miniatura della foto nell'intestazione della tile: l'immagine viene
/// rimpicciolita dentro un riquadro quadrato (`BoxFit.contain`, quindi senza
/// tagli e con le proporzioni originali) invece di occupare la larghezza
/// intrinseca del file, che manderebbe in overflow l'intestazione. Al tap si
/// apre a piena risoluzione, così la miniatura piccola non fa perdere
/// leggibilità. Senza foto caricata resta il riquadro vuoto con l'icona
/// segnaposto, per non far cambiare altezza e allineamenti alla card.
class _AnteprimaFoto extends StatelessWidget {
  const _AnteprimaFoto({
    required this.haFoto,
    required this.urlFoto,
    required this.urlMiniatura,
    required this.titolo,
  });

  final bool haFoto;
  final String urlFoto;
  final String urlMiniatura;

  /// Intestazione della finestra che si apre al tap (es. "B12 - Benna").
  final String titolo;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (!haFoto) {
      return _Riquadro(
        child: Icon(
          Icons.image_not_supported_outlined,
          size: 20,
          color: Colors.grey.shade400,
        ),
      );
    }

    return Tooltip(
      message: l10n.fasceCateneScreenIngrandisciFoto,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () => showDialog<void>(
          context: context,
          builder: (_) => Dialog(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    titolo,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 400),
                    child: Image.network(
                      urlFoto,
                      fit: BoxFit.contain,
                      errorBuilder: (_, _, _) =>
                          Text(l10n.fasceCateneScreenImmagineNonDisponibile),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        child: _Riquadro(
          child: Image.network(
            urlMiniatura,
            fit: BoxFit.contain,
            errorBuilder: (_, _, _) => const Icon(
              Icons.broken_image_outlined,
              size: 20,
              color: Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}

/// Riquadro quadrato di lato [_latoAnteprima] che contiene l'anteprima (o il
/// segnaposto): è quello che dà a tutte le tile la stessa altezza.
class _Riquadro extends StatelessWidget {
  const _Riquadro({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _latoAnteprima,
      height: _latoAnteprima,
      clipBehavior: Clip.antiAlias,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: child,
    );
  }
}
