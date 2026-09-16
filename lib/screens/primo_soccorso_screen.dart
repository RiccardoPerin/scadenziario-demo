import 'package:flutter/material.dart';
import 'package:gestionale_edile/widgets/voce_info.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badges;

import '../l10n/app_localizations.dart';
import '../widgets/app_bar.dart';
import '../widgets/app_drawer.dart';
import '../widgets/responsive_card_grid.dart';
import '../widgets/stato_badge.dart';
import '../widgets/confirm_dialog.dart';
import '../widgets/info_dialog.dart';
import '../widgets/cassetta_ps_form_dialog.dart';
import '../widgets/campo_info.dart';
import '../widgets/show_articoli_dialog.dart';
import '../providers/automezzi_provider.dart';
import '../providers/cantieri_provider.dart';
import '../providers/cassette_ps_provider.dart';
import '../providers/articoli_cassette_ps_provider.dart';
import '../providers/articoli_standard_cassette_ps_provider.dart';
import '../models/cassetta_ps.dart';
import '../models/cantiere.dart';
import '../models/automezzo.dart';
import '../models/articolo_cassetta_ps.dart';
import '../services/stato_scadenze.dart';

typedef _VoceScadenza = ({
  CassettaPs cassettaPs,
  ArticoloCassettaPs? articolo,
  String tipo,
  DateTime scadenza,
  StatoScadenza stato,
});

String _ubicazioneTesto(
  CassettaPs c,
  List<Cantiere> cantieri,
  List<Automezzo> automezzi,
) {
  final parti = <String>[];
  if (c.inMagazzino) parti.add('magazzino');
  if (c.inUfficio) parti.add('ufficio');
  if (c.ubicazioneCantiereId.isNotEmpty) {
    parti.add('cantiere');
    final nome = cantieri
        .where((cant) => cant.id == c.ubicazioneCantiereId)
        .map((cant) => cant.nome)
        .firstOrNull;
    if (nome != null) parti.add(nome);
  }
  if (c.ubicazioneAutomezzoId.isNotEmpty) {
    parti.add('automezzo');
    final automezzo = automezzi
        .where((a) => a.id == c.ubicazioneAutomezzoId)
        .firstOrNull;
    if (automezzo != null) {
      parti.add(automezzo.nome);
      parti.add(automezzo.targa);
    }
  }
  if (c.dettaglioUbicazione.isNotEmpty) parti.add(c.dettaglioUbicazione);
  return parti.join(' ');
}

List<String> _descrizioneUbicazione(
  CassettaPs c,
  List<Cantiere> cantieri,
  List<Automezzo> automezzi,
  AppLocalizations l10n,
) {
  final dettaglio = c.dettaglioUbicazione;
  String conDettaglio(String base) =>
      dettaglio.isEmpty ? base : '$base ($dettaglio)';

  final descrizioni = <String>[];
  if (c.inMagazzino) {
    descrizioni.add(conDettaglio(l10n.primoSoccorsoScreenLocationWarehouse));
  }
  if (c.inUfficio) {
    descrizioni.add(conDettaglio(l10n.primoSoccorsoScreenLocationOffice));
  }
  if (c.ubicazioneCantiereId.isNotEmpty) {
    final nome =
        cantieri
            .where((cant) => cant.id == c.ubicazioneCantiereId)
            .map((cant) => cant.nome)
            .firstOrNull ??
        c.ubicazioneCantiereId;
    descrizioni.add(conDettaglio(l10n.primoSoccorsoScreenLocationSite(nome)));
  }
  if (c.ubicazioneAutomezzoId.isNotEmpty) {
    final automezzo = automezzi
        .where((a) => a.id == c.ubicazioneAutomezzoId)
        .firstOrNull;
    final nome = automezzo == null
        ? c.ubicazioneAutomezzoId
        : (automezzo.nome.isNotEmpty ? automezzo.nome : automezzo.targa);
    descrizioni.add(conDettaglio(l10n.primoSoccorsoScreenLocationVehicle(nome)));
  }
  // Ubicazione non specificata: mostra solo la nota di ubicazione.
  if (descrizioni.isEmpty && dettaglio.isNotEmpty) descrizioni.add(dettaglio);
  return descrizioni;
}

String _ubicazioneVoce(
  CassettaPs c,
  List<Cantiere> cantieri,
  List<Automezzo> automezzi,
  AppLocalizations l10n,
) {
  final descrizioni = _descrizioneUbicazione(c, cantieri, automezzi, l10n);
  return descrizioni.isEmpty
      ? l10n.primoSoccorsoScreenLocationUnspecified
      : descrizioni.join(', ');
}

List<_VoceScadenza> _vociScadenza(
  List<CassettaPs> cassette,
  List<ArticoloCassettaPs> articoli,
  AppLocalizations l10n,
) {
  final voci = <_VoceScadenza>[];
  for (final c in cassette) {
    final data = parseData(c.prossimoControllo);
    if (data != null) {
      final stato = computeStato(data);
      if (stato != StatoScadenza.valido) {
        voci.add((
          cassettaPs: c,
          articolo: null,
          tipo: l10n.primoSoccorsoScreenNextCheckType,
          scadenza: data,
          stato: stato,
        ));
      }
    }
    for (final a in articoli.where((a) => a.cassettaId == c.id)) {
      final scadenzaData = parseData(a.scadenza);
      if (scadenzaData == null) continue;
      final stato = computeStato(scadenzaData);
      if (stato == StatoScadenza.valido) continue;
      voci.add((
        cassettaPs: c,
        articolo: a,
        tipo: l10n.primoSoccorsoScreenProductDeadlineType(a.nomeProdotto),
        scadenza: scadenzaData,
        stato: stato,
      ));
    }
  }
  voci.sort((a, b) => a.scadenza.compareTo(b.scadenza));
  return voci;
}

class PrimoSoccorsoScreen extends StatefulWidget {
  const PrimoSoccorsoScreen({super.key});

  @override
  State<PrimoSoccorsoScreen> createState() => _PrimoSoccorsoScreenState();
}

class _PrimoSoccorsoScreenState extends State<PrimoSoccorsoScreen> {
  final _searchController = TextEditingController();
  String _query = '';
  bool _loaded = false;
  final _espanse = <String>{};
  bool _scadenzeImminentiEspanse = false;
  bool _cassetteEspanse = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_loaded) {
      final cassetteProvider = context.read<CassettePsProvider>();
      final articoliProvider = context.read<ArticoliCassettePsProvider>();
      final articoliStandardProvider = context.read<ArticoliStandardCassettePsProvider>();
      final cantieriProvider = context.read<CantieriProvider>();
      final automezziProvider = context.read<AutomezziProvider>();
      _loaded = true;
      Future.microtask(() {
        cassetteProvider.load();
        articoliProvider.load();
        articoliStandardProvider.load();
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
    final primaryBlue = Theme.of(context).colorScheme.primary;
    final cassetteProvider = context.watch<CassettePsProvider>();
    final articoliProvider = context.watch<ArticoliCassettePsProvider>();
    final articoliStandardProvider = context.watch<ArticoliStandardCassettePsProvider>();
    final cantieriProvider = context.watch<CantieriProvider>();
    final automezziProvider = context.watch<AutomezziProvider>();
    final erroreCaricamento =
        cassetteProvider.errorMessage ??
        articoliProvider.errorMessage ??
        cantieriProvider.errorMessage ??
        automezziProvider.errorMessage;

    final query = _query.trim().toLowerCase();
    final cassetteFiltrate = cassetteProvider.cassette
        .where(
          (c) =>
              query.isEmpty ||
              c.numero.toLowerCase().contains(query) ||
              c.tipologia.toLowerCase().contains(query) ||
              _ubicazioneTesto(
                c,
                cantieriProvider.cantieri,
                automezziProvider.automezzi,
              ).toLowerCase().contains(query),
        )
        .toList();
    final scadenzeImminenti = _vociScadenza(
      cassetteProvider.cassette,
      articoliProvider.articoli,
      l10n,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: l10n.primoSoccorsoScreenTitle,
        actions: [
          AppBarAction(
            icon: Icons.checklist_outlined,
            label: l10n.primoSoccorsoScreenStandardProductsLabel,
            onPressed: () => context.push('/primo-soccorso/prodotti-standard'),
          ),
          AppBarAction(
            icon: Icons.add,
            label: l10n.primoSoccorsoScreenNewItemLabel,
            onPressed: () => showCassettaFormDialog(
              context,
              provider: cassetteProvider,
              articoliProvider: articoliProvider,
              articoliStandardProvider: articoliStandardProvider,
              cassette: cassetteProvider.cassette,
              articoli: articoliProvider.articoli,
              cantieri: cantieriProvider.cantieri,
              automezzi: automezziProvider.automezzi,
            ),
          ),
        ],
      ),
      drawer: const AppDrawer(current: 'Primo Soccorso'),
      body: cassetteProvider.isLoading && cassetteProvider.cassette.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async {
                await cassetteProvider.load();
                await articoliProvider.load();
              },
              child: ListView(
                padding: EdgeInsets.fromLTRB(24, 24, 24, 24),
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
                          child: Text(
                            l10n.primoSoccorsoScreenUpcomingDeadlines,
                            style: const TextStyle(
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
                              ? l10n.primoSoccorsoScreenHideDeadlinesTooltip
                              : l10n.primoSoccorsoScreenShowDeadlinesTooltip,
                          onPressed: () => setState(
                            () => _scadenzeImminentiEspanse = !_scadenzeImminentiEspanse,
                          ),
                          icon: Icon(
                            _scadenzeImminentiEspanse ? Icons.unfold_less_outlined : Icons.unfold_more_outlined,
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
                          : _ScadenzeImminenti(
                              voci: scadenzeImminenti,
                              provider: cassetteProvider,
                              articoliProvider: articoliProvider,
                              articoliStandardProvider: articoliStandardProvider,
                              cantieri: cantieriProvider.cantieri,
                              automezzi: automezziProvider.automezzi,
                            ),
                    ),
                    const SizedBox(height: 24),
                  ],
                  Row(
                    children: [
                      Text(
                        l10n.primoSoccorsoScreenSectionTitle,
                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 22, color: primaryBlue),
                      ),
                      IconButton(
                        tooltip: _cassetteEspanse
                            ? l10n.primoSoccorsoScreenHideAllTooltip
                            : l10n.primoSoccorsoScreenShowAllTooltip,
                        icon: Icon(
                          _cassetteEspanse ? Icons.unfold_less_outlined : Icons.unfold_more_outlined,
                          size: 20, color: primaryBlue
                        ),
                        onPressed: () {
                          _cassetteEspanse = !_cassetteEspanse;
                          setState(() {
                            if (_cassetteEspanse) {
                              _espanse.addAll(cassetteProvider.cassette.map((c) => c.id));
                            }
                            else {
                              _espanse.clear();
                            }
                          });
                        },

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
                      hintText: l10n.primoSoccorsoScreenSearchHint,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(
                          color: Colors.black54,
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: primaryBlue, width: 2),
                      ),
                    ),
                    onChanged: (v) => setState(() => _query = v),
                  ),
                  const SizedBox(height: 20),
                  if (cassetteFiltrate.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Center(
                        child: Text(
                          cassetteProvider.cassette.isEmpty
                              ? l10n.primoSoccorsoScreenNoItemsLoaded
                              : l10n.primoSoccorsoScreenNoItemsFound(_query.trim()),
                        ),
                      ),
                    )
                  else
                    ColumnsCardGrid(
                      maxColumns: 2,
                      minWidth: 380,
                      children: cassetteFiltrate.map((cassetta) {
                        final espansa = _espanse.contains(cassetta.id);
                        return _CassettaCard(
                          cassetta: cassetta, 
                          cassette: cassetteProvider.cassette, 
                          provider: cassetteProvider, 
                          espansa: espansa, 
                          onToggleEspansa: () => setState(() {
                            if (espansa) {
                              _espanse.remove(cassetta.id);
                            } else {
                              _espanse.add(cassetta.id);
                            }
                          })
                        );     
                      }).toList(),
                    ),
                ],
              ),
            ),
    );
  }
}

class _ScadenzeImminenti extends StatelessWidget {
  const _ScadenzeImminenti({
    required this.voci,
    required this.provider,
    required this.articoliProvider,
    required this.articoliStandardProvider,
    required this.cantieri,
    required this.automezzi,
  });

  final List<_VoceScadenza> voci;
  final CassettePsProvider provider;
  final ArticoliCassettePsProvider articoliProvider;
  final ArticoliStandardCassettePsProvider articoliStandardProvider;
  final List<Cantiere> cantieri;
  final List<Automezzo> automezzi;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
                final notaScadenza =
                    voce.articolo?.notaScadenza ?? voce.cassettaPs.notaScadenza;
                final ubicazione = _ubicazioneVoce(
                  voce.cassettaPs,
                  cantieri,
                  automezzi,
                  l10n,
                );

                return ListTile(
                  leading: StatoBadge(stato: voce.stato, showLabel: !isMobile),
                  title: Text(voce.tipo, style: const TextStyle(fontWeight: FontWeight.w700)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      VoceInfo(l10n.primoSoccorsoScreenArticleLabel, '${voce.cassettaPs.tipologia} #${voce.cassettaPs.numero}'),
                      VoceInfo(l10n.primoSoccorsoScreenLocationLabel, ubicazione),
                      if (voce.cassettaPs.note != '') VoceInfo(l10n.commonNoteLabel, voce.cassettaPs.note),
                      if (notaScadenza.isNotEmpty) VoceInfo(l10n.primoSoccorsoScreenDeadlineNoteLabel, notaScadenza)
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit_note_rounded, color: primaryBlue, size: isMobile ? 18 : 22),
                        tooltip: l10n.primoSoccorsoScreenEditNoteTooltip,
                        onPressed: () => _showNotaScadenzaDialog(
                          context,
                          titolo: '${voce.cassettaPs.tipologia} #${voce.cassettaPs.numero}',
                          notaAttuale: notaScadenza,
                          onSalva: (nota) => voce.articolo != null
                              ? articoliProvider.updateNotaScadenza(
                                  voce.articolo!.id,
                                  nota,
                                )
                              : provider.updateNotaScadenza(
                                  voce.cassettaPs.id,
                                  nota,
                                ),
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        '${voce.scadenza.day.toString().padLeft(2, '0')}/'
                        '${voce.scadenza.month.toString().padLeft(2, '0')}/'
                        '${voce.scadenza.year}',
                      ),
                    ],
                  ),
                  onTap: () => showCassettaFormDialog(
                    context,
                    provider: provider,
                    articoliProvider: articoliProvider,
                    articoliStandardProvider: articoliStandardProvider,
                    cassette: provider.cassette,
                    articoli: articoliProvider.articoli,
                    cantieri: cantieri,
                    automezzi: automezzi,
                    esistente: voce.cassettaPs,
                  ),
                );
              },
            ),
          ],
        ],
      ),
    );
  }
}

class _CassettaCard extends StatelessWidget {
  const _CassettaCard({
    required this.cassetta,
    required this.cassette,
    required this.provider,
    required this.espansa,
    required this.onToggleEspansa,
  });

  final CassettaPs cassetta;
  final List<CassettaPs> cassette;
  final CassettePsProvider provider;
  final bool espansa;
  final VoidCallback onToggleEspansa;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isMobile = MediaQuery.sizeOf(context).width < kMobileAppBarBreakpoint;
    final primaryBlue = Theme.of(context).primaryColor;
    final articoliProvider = context.watch<ArticoliCassettePsProvider>();
    final articoliStandardProvider = context.watch<ArticoliStandardCassettePsProvider>();
    final cassetteProvider = context.watch<CassettePsProvider>();
    final cantieriProvider = context.watch<CantieriProvider>();
    final automezziProvider = context.watch<AutomezziProvider>();

    final articoliCassetta = articoliProvider.articoli
        .where((a) => a.cassettaId == cassetta.id)
        .toList();
    final scadenzeProdotti = articoliCassetta.map((a) => a.scadenza).where(
      (s) => parseData(s) != null,
    ).toList()..sort((a, b) => parseData(a)!.compareTo(parseData(b)!));
    final prossimaScadenzaProdotti =
        scadenzeProdotti.isEmpty ? '' : scadenzeProdotti.first;
    final stato = statoPeggioreTraDate([
      parseData(cassetta.prossimoControllo),
      ...articoliCassetta.map((a) => parseData(a.scadenza)),
    ]);
    final ubicazione = _ubicazioneVoce(
      cassetta,
      cantieriProvider.cantieri,
      automezziProvider.automezzi,
      l10n,
    );


    return Card(
      child: Column(
        children: [
          ListTile(
            leading: StatoBadge(
              stato: stato,
              showLabel: false,
            ),
            title: Text('${cassetta.tipologia} #${cassetta.numero}', style: const TextStyle(fontWeight: FontWeight.w700)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                VoceInfo(l10n.primoSoccorsoScreenLocationLabel, ubicazione),
                if (cassetta.note != '') VoceInfo(l10n.commonNoteLabel, cassetta.note)
              ],
            ),
            onTap: () => showArticoliDialog(
              context,
              articoli: articoliCassetta,
              cassetta: cassetta,
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit_outlined, color: primaryBlue, size: isMobile ? 18 : 22),
                  tooltip: l10n.primoSoccorsoScreenEditItemTooltip,
                  onPressed: () => showCassettaFormDialog(
                    context,
                    provider: cassetteProvider,
                    articoliProvider: articoliProvider,
                    articoliStandardProvider: articoliStandardProvider,
                    cassette: cassetteProvider.cassette,
                    articoli: articoliProvider.articoli,
                    cantieri: cantieriProvider.cantieri,
                    automezzi: automezziProvider.automezzi,
                    esistente: cassetta,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.delete_outline, color: primaryBlue, size: isMobile ? 18 : 22),
                  tooltip: l10n.primoSoccorsoScreenDeleteItemTooltip,
                  onPressed: () async {
                    final confermato = await showConfirmDialog(
                      context,
                      title: l10n.primoSoccorsoScreenDeleteConfirmTitle,
                      message: l10n.primoSoccorsoScreenDeleteConfirmMessage(cassetta.numero),
                    );
                    if (confermato) {
                      await cassetteProvider.delete(
                        cassetta.id,
                      );
                      await articoliProvider.load();
                    }
                  },
                ),
                IconButton(
                  tooltip: espansa
                      ? l10n.primoSoccorsoScreenHideInfoTooltip
                      : l10n.primoSoccorsoScreenShowInfoTooltip,
                  onPressed: onToggleEspansa,
                  icon: Icon(
                    espansa ? Icons.keyboard_arrow_up_outlined : Icons.keyboard_arrow_down_outlined,
                    color: primaryBlue,
                    size: isMobile ? 18 : 22
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
                  padding: EdgeInsets.fromLTRB(16, 12, 16, 12),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Divider(height: 1, color: Color(0xFFE0E0E0)),
                        const SizedBox(height: 12),
                        Text(l10n.primoSoccorsoScreenChecksSectionTitle, style: TextStyle(fontWeight: FontWeight.w600, color: primaryBlue, fontSize: 15)),
                        const SizedBox(height: 8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            campoInfo(l10n.primoSoccorsoScreenLastCheckLabel, formatData(cassetta.ultimaVerifica)),
                            campoScadenza(l10n.primoSoccorsoScreenNextCheckLabel, cassetta.prossimoControllo),
                            campoScadenza(l10n.primoSoccorsoScreenNextProductDeadlineLabel, prossimaScadenzaProdotti),
                          ],
                        ),
                      ],
                    ),
                )
          ),
        ],
      ),
    );
  }
}

Future<void> _showNotaScadenzaDialog(
  BuildContext context, {
  required String titolo,
  required String notaAttuale,
  required Future<void> Function(String nota) onSalva,
}) {
  return showDialog(
    context: context,
    builder: (_) => _NotaScadenzaDialog(
      titolo: titolo,
      notaAttuale: notaAttuale,
      onSalva: onSalva,
    ),
  );
}

class _NotaScadenzaDialog extends StatefulWidget {
  const _NotaScadenzaDialog({
    required this.titolo,
    required this.notaAttuale,
    required this.onSalva,
  });

  final String titolo;
  final String notaAttuale;
  final Future<void> Function(String nota) onSalva;

  @override
  State<_NotaScadenzaDialog> createState() => _NotaScadenzaDialogState();
}

class _NotaScadenzaDialogState extends State<_NotaScadenzaDialog> {
  late final _noteController = TextEditingController(text: widget.notaAttuale);
  bool _isSaving = false;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _isSaving = true);
    try {
      await widget.onSalva(_noteController.text.trim());
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.commonErrorWithDetails(e.toString()))));
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(l10n.primoSoccorsoScreenNotaDialogTitle(widget.titolo)),
      content: SizedBox(
        width: 400,
        child: TextField(
          controller: _noteController,
          decoration: InputDecoration(labelText: l10n.commonNoteLabel),
          maxLines: 1,
          autofocus: true,
          onSubmitted: (_) => _submit(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSaving ? null : () => Navigator.of(context).pop(),
          child: Text(l10n.commonCancel),
        ),
        FilledButton(
          onPressed: _isSaving ? null : _submit,
          child: _isSaving
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(l10n.commonSave),
        ),
      ],
    );
  }
}
