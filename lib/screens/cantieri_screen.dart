import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badges;

import '../l10n/app_localizations.dart';
import '../models/cantiere.dart';
import '../models/dipendente_subappaltatore.dart';
import '../models/documento.dart';
import '../models/subappaltatore.dart';
import '../providers/cantieri_provider.dart';
import '../providers/dipendenti_subappaltatori_provider.dart';
import '../providers/documenti_provider.dart';
import '../providers/subappaltatori_provider.dart';
import '../providers/tipi_scadenze_provider.dart';
import '../services/eliminazione_cascata.dart';
import '../services/stato_scadenze.dart';
import '../widgets/app_bar.dart';
import '../widgets/app_drawer.dart';
import '../widgets/cantiere_card.dart';
import '../widgets/cantiere_form_dialog.dart';
import '../widgets/confirm_dialog.dart';
import '../widgets/info_dialog.dart';
import '../widgets/nota_cantiere_dialog.dart';
import '../widgets/nota_scadenza_documento_dialog.dart';
import '../widgets/responsive_card_grid.dart';
import '../widgets/stato_badge.dart';
import '../widgets/voce_info.dart';

class CantieriScreen extends StatefulWidget {
  const CantieriScreen({super.key});

  @override
  State<CantieriScreen> createState() => _CantieriScreenState();
}

class _CantieriScreenState extends State<CantieriScreen> {
  final _searchController = TextEditingController();
  String _query = '';
  bool _loaded = false;
  bool _scadenzeImminentiEspanse = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_loaded) {
      _loaded = true;
      final cantieriProvider = context.read<CantieriProvider>();
      final subappaltatoriProvider = context.read<SubappaltatoriProvider>();
      final tipiScadenzeProvider = context.read<TipiScadenzeProvider>();
      final documentiProvider = context.read<DocumentiProvider>();
      final dipendentiProvider = context.read<DipendentiSubappaltatoriProvider>();
      Future.microtask(() {
        cantieriProvider.load();
        subappaltatoriProvider.load();
        tipiScadenzeProvider.load();
        documentiProvider.load();
        dipendentiProvider.load();
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
    final primaryBlue = Theme.of(context).colorScheme.primary;
    final isMobile = MediaQuery.sizeOf(context).width < kMobileAppBarBreakpoint;
    final l10n = AppLocalizations.of(context)!;
    final cantieriProvider = context.watch<CantieriProvider>();
    final subappaltatoriProvider = context.watch<SubappaltatoriProvider>();
    final documentiProvider = context.watch<DocumentiProvider>();
    final dipendentiProvider = context.watch<DipendentiSubappaltatoriProvider>();

    final erroreCaricamento = cantieriProvider.errorMessage ??
        subappaltatoriProvider.errorMessage ??
        documentiProvider.errorMessage;

    final query = _query.toLowerCase();
    final cantieriAttivi = cantieriProvider.cantieri.where((c) => c.stato != 'concluso').toList();
    final cantieriFiltrati = cantieriAttivi
        .where((c) =>
            c.nome.toLowerCase().contains(query) ||
            c.comune.toLowerCase().contains(query))
        .toList();

    final documentiInScadenza = documentiScadenzeCantieri(
      cantieri: cantieriProvider.cantieri,
      subappaltatori: subappaltatoriProvider.subappaltatori,
      dipendenti: dipendentiProvider.dipendenti,
      documentiProvider: documentiProvider,
    )
        .where((d) =>
            computeStato(d.dataScadenza, giorniPreavviso: d.giorniPreavviso) !=
            StatoScadenza.valido)
        .toList();

    // Scadenze generali dei cantieri stessi (messa a terra + scadenze
    // generiche), da mostrare insieme ai documenti in scadenza.
    final scadenzeCantieriInScadenza = cantieriAttivi
        .expand((c) => scadenzeGeneraliCantiere(c)
            .where((s) => computeStato(s.data) != StatoScadenza.valido)
            .map((s) => (cantiere: c, voce: s)))
        .toList();

    final vociImminenti = <_VoceScadenzaImminente>[
      ...documentiInScadenza.map((d) => _voceDaDocumento(
            context,
            d,
            cantieri: cantieriProvider.cantieri,
            subappaltatori: subappaltatoriProvider.subappaltatori,
            dipendenti: dipendentiProvider.dipendenti,
            documentiProvider: documentiProvider,
          )),
      ...scadenzeCantieriInScadenza.map((e) {
        final nota = e.cantiere.noteScadenze[e.voce.campo] ?? '';
        return _VoceScadenzaImminente(
          stato: computeStato(e.voce.data),
          data: e.voce.data,
          titolo: e.voce.etichetta,
          sottotitolo: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              VoceInfo(l10n.cantieriScreenSiteLabel, e.cantiere.nome),
              if (nota.isNotEmpty) VoceInfo(l10n.cantieriScreenDeadlineNoteLabel, nota),
            ],
          ),
          trailingAction: IconButton(
            icon: Icon(Icons.edit_note_rounded, color: primaryBlue, size: isMobile ? 18 : 22),
            tooltip: l10n.cantieriScreenEditNoteTooltip,
            onPressed: () => showNotaCantiereDialog(
              context,
              titolo: l10n.cantieriScreenNoteDialogTitle(e.cantiere.nome, e.voce.etichetta),
              valoreIniziale: nota,
              onSalva: (v) => cantieriProvider.updateNotaScadenza(e.cantiere, e.voce.campo, v),
            ),
          ),
          onTap: () => context.push('/cantieri/${e.cantiere.id}'),
        );
      }),
    ]..sort((a, b) {
        final da = a.data ?? DateTime(2100);
        final db = b.data ?? DateTime(2100);
        return da.compareTo(db);
      });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: l10n.cantieriScreenTitle,
        actions: [
          AppBarAction(
            icon: Icons.add,
            label: l10n.cantieriScreenNewSiteAction,
            onPressed: () => showCantiereFormDialog(context, provider: cantieriProvider),
          ),
        ],
          iconActions: isMobile //Mostra le icone solo se non da mobile
            ? null
            : [
                AppBarAction(
                  icon: Icons.groups_outlined,
                  label: l10n.cantieriScreenSubcontractorsAction,
                  onPressed: () => context.push('/subappaltatori'),
                ),
                AppBarAction(
                  icon: Icons.archive_outlined,
                  label: l10n.cantieriScreenArchiveAction,
                  onPressed: () => context.push('/archivio-cantieri'),
                ),
                AppBarAction(
                  icon: Icons.description_outlined,
                  label: l10n.cantieriScreenDeadlineTypesAction,
                  onPressed: () => context.push('/tipi-scadenze'),
                ),
              ],
      ),
      drawer: const AppDrawer(current: 'Cantieri'),
      body: cantieriProvider.isLoading && cantieriProvider.cantieri.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async {
                await cantieriProvider.load();
                await subappaltatoriProvider.load();
                await documentiProvider.load();
                await dipendentiProvider.load();
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
                  if (vociImminenti.isNotEmpty) ...[
                    Row(
                      children: [
                        badges.Badge(
                          badgeContent: Text(
                            '${vociImminenti.length}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          badgeStyle: badges.BadgeStyle(badgeColor: Colors.black),
                          position: badges.BadgePosition.topEnd(top: -10, end: -25),
                          child: Text(
                            l10n.cantieriScreenUpcomingDeadlinesTitle,
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
                              ? l10n.cantieriScreenHideDeadlinesTooltip
                              : l10n.cantieriScreenShowDeadlinesTooltip,
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
                              voci: vociImminenti,
                            ),
                    ),
                    const SizedBox(height: 24),
                  ],
                  Text(
                    l10n.cantieriScreenActiveSitesTitle,
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 22, color: primaryBlue),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: Icon(Icons.search, color: primaryBlue),
                      hintText: l10n.cantieriScreenSearchHint,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                          color: Colors.black54,
                          width: 1
                        )
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: primaryBlue, width: 2),
                      ),
                    ),
                    onChanged: (v) => setState(() => _query = v),
                  ),
                  const SizedBox(height: 20),
                  if (cantieriFiltrati.isEmpty) 
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Center(
                        child: Text(
                          cantieriProvider.cantieri.isEmpty
                              ? l10n.cantieriScreenEmptyLoaded
                              : cantieriAttivi.isEmpty
                                  ? l10n.cantieriScreenEmptyAllConcluded
                                  : l10n.cantieriScreenEmptySearch(_query.trim()),
                        ),
                      ),
                    )
                  else
                    ResponsiveCardGrid(
                      children: cantieriFiltrati.map((cantiere) {
                        final subappaltatoriIds = subappaltatoriProvider
                            .perCantiere(cantiere.id)
                            .map((s) => s.id)
                            .toList();
                        final dipendentiIds = dipendentiProvider
                            .perCantiere(cantiere.id)
                            .map((d) => d.id)
                            .toList();
                        final documentiCantiere = documentiProvider.soloUltimaVersione([
                          ...documentiProvider.perCantiereConSubappaltatori(
                            cantiere.id,
                            subappaltatoriIds,
                          ),
                          ...documentiProvider.perDipendenti(dipendentiIds),
                        ]);
                        final numeroInScadenza = documentiCantiere
                            .where((d) =>
                                computeStato(d.dataScadenza, giorniPreavviso: d.giorniPreavviso) !=
                                StatoScadenza.valido)
                            .length;
                        final peggiore = documentiCantiere.fold<StatoScadenza>(
                          StatoScadenza.valido,
                          (acc, d) {
                            final s = computeStato(d.dataScadenza, giorniPreavviso: d.giorniPreavviso);
                            if (s == StatoScadenza.scaduto) return StatoScadenza.scaduto;
                            if (s == StatoScadenza.inScadenza && acc == StatoScadenza.valido) {
                              return StatoScadenza.inScadenza;
                            }
                            return acc;
                          },
                        );
                        return SizedBox(
                          height: 240,
                          child: CantiereCard(
                            nome: cantiere.nome,
                            comune: cantiere.comune,
                            stato: peggiore,
                            numeroSubappaltatori:
                                subappaltatoriProvider.perCantiere(cantiere.id).length,
                            numeroDocumentiInScadenza: numeroInScadenza,
                            statoCantiere: cantiere.stato,
                            onTap: () => context.push('/cantieri/${cantiere.id}'),
                            onEdit: () => showCantiereFormDialog(
                              context,
                              provider: cantieriProvider,
                              esistente: cantiere,
                            ),
                            onDelete: () async {
                              final confermato = await showConfirmDialog(
                                context,
                                title: l10n.cantieriScreenConfirmDeleteTitle,
                                message: l10n.cantieriScreenConfirmDeleteMessage(cantiere.nome),
                              );
                              if (confermato && context.mounted) {
                                await eliminaCantiereConTracce(context, cantiere.id);
                              }
                            },
                          ),
                        );
                      }).toList(),
                    ),
                ],
              ),
            ),
    );
  }
}

/// Una riga della sezione "Scadenze imminenti" della home cantieri: può
/// derivare da un documento in scadenza o da una scadenza generale di un
/// cantiere (messa a terra / scadenze generiche), da cui il campo
/// [trailingAction] opzionale (solo i documenti hanno una nota da modificare).
class _VoceScadenzaImminente {
  const _VoceScadenzaImminente({
    required this.stato,
    required this.data,
    required this.titolo,
    required this.sottotitolo,
    this.subappaltatore,
    this.trailingAction,
    this.onTap,
  });

  final StatoScadenza stato;
  final DateTime? data;
  final String titolo;

  /// `null` quando non c'è nulla da mostrare sotto al titolo, così che la
  /// ListTile centri verticalmente il titolo invece di lasciare una riga vuota.
  final Widget? sottotitolo;

  /// Ragione sociale del subappaltatore a cui la voce fa capo, usata per
  /// raggruppare le righe della sezione. È `null` per le scadenze generali
  /// dei cantieri, che non appartengono ad alcun subappaltatore.
  final String? subappaltatore;
  final Widget? trailingAction;
  final VoidCallback? onTap;
}

/// Nomi dei cantieri attivi tra quelli indicati, in ordine alfabetico: i
/// cantieri conclusi non vengono elencati.
List<String> _nomiCantieriAttivi(List<Cantiere> cantieri, List<String> ids) =>
    cantieri
        .where((c) => c.stato != 'concluso' && ids.contains(c.id))
        .map((c) => c.nome)
        .toList()
      ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));

_VoceScadenzaImminente _voceDaDocumento(
  BuildContext context,
  Documento d, {
  required List<Cantiere> cantieri,
  required List<Subappaltatore> subappaltatori,
  required List<DipendenteSubappaltatore> dipendenti,
  required DocumentiProvider documentiProvider,
}) {
  final primaryBlue = Theme.of(context).colorScheme.primary;
  final isMobile = MediaQuery.sizeOf(context).width < kMobileAppBarBreakpoint;
  final l10n = AppLocalizations.of(context)!;
  final candidatiCantiere = cantieri.where((c) => c.id == d.cantiereId);
  final cantiere = candidatiCantiere.isEmpty ? null : candidatiCantiere.first;
  final candidatiSub = subappaltatori.where((s) => s.id == d.subappaltatoreId);
  final subappaltatore = candidatiSub.isEmpty ? null : candidatiSub.first;

  Widget? sottotitolo;
  String? nomeSubappaltatore;
  VoidCallback? onTap;
  if (d.isDocumentoDipendente) {
    final candidatiDipendente = dipendenti.where((e) => e.id == d.dipendenteId);
    final dipendente = candidatiDipendente.isEmpty ? null : candidatiDipendente.first;
    final candidatiSubDipendente =
        subappaltatori.where((s) => s.id == dipendente?.subappaltatoreId);
    final subappaltatoreDipendente =
        candidatiSubDipendente.isEmpty ? null : candidatiSubDipendente.first;
    nomeSubappaltatore = subappaltatoreDipendente?.ragioneSociale;
    final cantieriDipendente = dipendente == null
        ? const <String>[]
        : _nomiCantieriAttivi(cantieri, dipendente.cantieriIds);
    sottotitolo = dipendente == null
        ? null
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              VoceInfo(l10n.cantieriScreenEmployeeLabel, dipendente.nomeCompleto),
              if (cantieriDipendente.isNotEmpty)
                VoceInfo(l10n.cantieriScreenSitesPresentLabel, cantieriDipendente.join(', ')),
              if (d.note.isNotEmpty) VoceInfo(l10n.commonNoteLabel, d.note),
              if (d.notaScadenza.isNotEmpty) VoceInfo(l10n.cantieriScreenDeadlineNoteLabel, d.notaScadenza),
            ],
          );
    // Nessun collegamento ai dipendenti aziendali: quelli interni
    // sono ora gestiti nella pagina Amministrazione.
    if (dipendente != null && subappaltatoreDipendente != null) {
      onTap = () => context
          .push('/subappaltatori/${subappaltatoreDipendente.id}/dipendenti/${dipendente.id}');
    } else {
      onTap = null;
    }
  } else {
    nomeSubappaltatore = subappaltatore?.ragioneSociale;
    // I documenti generali del subappaltatore (es. DURC) non fanno capo ad
    // alcun cantiere: al posto della riga "Cantiere" si elencano i cantieri
    // attivi in cui il subappaltatore è impegnato, che sono poi il motivo per
    // cui la scadenza compare qui.
    final cantieriSubappaltatore =
        d.isDocumentoSubappaltatoreGenerale && subappaltatore != null
            ? _nomiCantieriAttivi(cantieri, subappaltatore.cantieriIds)
            : const <String>[];
    final righe = <Widget>[
      if (cantiere != null) VoceInfo(l10n.cantieriScreenSiteLabel, cantiere.nome),
      if (cantieriSubappaltatore.isNotEmpty)
        VoceInfo(l10n.cantieriScreenSitesPresentLabel, cantieriSubappaltatore.join(', ')),
      if (d.note.isNotEmpty) VoceInfo(l10n.commonNoteLabel, d.note),
      if (d.notaScadenza.isNotEmpty) VoceInfo(l10n.cantieriScreenDeadlineNoteLabel, d.notaScadenza),
    ];
    sottotitolo = righe.isEmpty
        ? null
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: righe
          );
    if (cantiere != null) {
      onTap = () => context.push('/cantieri/${cantiere.id}');
    } else if (subappaltatore != null) {
      onTap = () => context.push('/subappaltatori/${subappaltatore.id}');
    } else {
      onTap = null;
    }
  }

  return _VoceScadenzaImminente(
    stato: computeStato(d.dataScadenza, giorniPreavviso: d.giorniPreavviso),
    data: d.dataScadenza,
    titolo: d.tipoDocumentoNome ?? l10n.cantieriScreenDefaultDocumentType,
    sottotitolo: sottotitolo,
    subappaltatore: nomeSubappaltatore,
    trailingAction: IconButton(
      icon: Icon(Icons.edit_note_rounded, color: primaryBlue, size: isMobile ? 18 : 22),
      tooltip: l10n.cantieriScreenEditNoteTooltip,
      onPressed: () => showNotaScadenzaDocumentoDialog(
        context,
        documentiProvider: documentiProvider,
        documento: d,
      ),
    ),
    onTap: onTap,
  );
}

class _ScadenzeImminenti extends StatelessWidget {
  const _ScadenzeImminenti({required this.voci});

  final List<_VoceScadenzaImminente> voci;

  /// Raggruppa le voci per subappaltatore: i gruppi sono in ordine alfabetico
  /// e, dentro ciascuno, resta l'ordinamento per data già applicato a [voci].
  /// In coda vanno le scadenze generali dei cantieri, che non fanno capo ad
  /// alcun subappaltatore.
  List<({String etichetta, List<_VoceScadenzaImminente> voci})> _gruppi(AppLocalizations l10n) {
    final perSubappaltatore = <String, List<_VoceScadenzaImminente>>{};
    final senzaSubappaltatore = <_VoceScadenzaImminente>[];
    for (final voce in voci) {
      final nome = voce.subappaltatore;
      if (nome == null || nome.isEmpty) {
        senzaSubappaltatore.add(voce);
      } else {
        perSubappaltatore.putIfAbsent(nome, () => []).add(voce);
      }
    }
    final nomi = perSubappaltatore.keys.toList()
      ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
    return [
      for (final nome in nomi) (etichetta: nome, voci: perSubappaltatore[nome]!),
      if (senzaSubappaltatore.isNotEmpty)
        (etichetta: l10n.cantieriScreenSiteDeadlinesGroup, voci: senzaSubappaltatore),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < kMobileAppBarBreakpoint;
    final primaryBlue = Theme.of(context).colorScheme.primary;
    final l10n = AppLocalizations.of(context)!;
    final gruppi = _gruppi(l10n);

    return Card(
      child: Column(
        children: [
          for (var g = 0; g < gruppi.length; g++) ...[
            if (g > 0) const Divider(height: 1, color: Color(0xFFE0E0E0)),
            Container(
              width: double.infinity,
              color: const Color(0xFFF3F5F9),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Text(
                gruppi[g].etichetta,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: isMobile ? 14 : 16,
                  color: primaryBlue,
                ),
              ),
            ),
            for (final voce in gruppi[g].voci) ...[
              const Divider(height: 1, color: Color(0xFFE0E0E0)),
              ListTile(
                leading: StatoBadge(stato: voce.stato, showLabel: !isMobile),
                title: Text(voce.titolo),
                subtitle: voce.sottotitolo,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (voce.trailingAction != null) ...[
                      voce.trailingAction!,
                      const SizedBox(width: 5),
                    ],
                    if (voce.data != null)
                      Text('${voce.data!.day}/${voce.data!.month}/${voce.data!.year}'),
                  ],
                ),
                onTap: voce.onTap,
              ),
            ],
          ],
        ],
      ),
    );
  }
}
