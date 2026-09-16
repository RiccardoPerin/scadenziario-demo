import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badges;

import '../l10n/app_localizations.dart';
import '../models/scala.dart';
import '../models/cantiere.dart';
import '../widgets/app_bar.dart';
import '../widgets/app_drawer.dart';
import '../widgets/stato_badge.dart';
import '../widgets/scala_form_dialog.dart';
import '../widgets/campo_info.dart';
import '../providers/scale_provider.dart';
import '../providers/cantieri_provider.dart';
import '../services/ordinamento_codici.dart';
import '../services/stato_scadenze.dart';
import '../widgets/info_dialog.dart';
import '../widgets/nota_scadenza_scala_dialog.dart';
import '../widgets/responsive_card_grid.dart';
import '../widgets/confirm_dialog.dart';
import '../widgets/voce_info.dart';
import '../services/stampa_tabella.dart';

String _ubicazioneTesto(
  Scala s,
  List<Cantiere> cantieri,
) {
  final parti = <String>[];
  if (s.inMagazzino) parti.add('magazzino');
  if (s.ubicazioneCantiereId.isNotEmpty) {
    parti.add('cantiere');
    final nome = cantieri
        .where((c) => c.id == s.ubicazioneCantiereId)
        .map((c) => c.nome)
        .firstOrNull;
    if (nome != null) parti.add(nome);
  }
  return parti.join(' ');
}

List<String> _descrizioneUbicazione(
  Scala s,
  List<Cantiere> cantieri,
  AppLocalizations l10n,
) {
  final descrizioni = <String>[];
  if (s.inMagazzino) descrizioni.add(l10n.scaleScreenInMagazzino);
  if (s.ubicazioneCantiereId.isNotEmpty) {
    final nome =
        cantieri
            .where((c) => c.id == s.ubicazioneCantiereId)
            .map((c) => c.nome)
            .firstOrNull ??
        s.ubicazioneCantiereId;
    descrizioni.add(l10n.scaleScreenInCantiere(nome));
  }
  return descrizioni;
}

String _ubicazioneVoce(
  Scala s,
  List<Cantiere> cantieri,
  AppLocalizations l10n,
) {
  final descrizioni = _descrizioneUbicazione(s, cantieri, l10n);
  return descrizioni.isEmpty ? l10n.scaleScreenNonSpecificata : descrizioni.join(', ');
}

typedef _VoceScadenza = ({
  Scala scala,
  String tipo,
  DateTime scadenza,
  StatoScadenza stato,
});

List<String> _colonnePdf(AppLocalizations l10n) => [
  l10n.scaleScreenCodice,
  l10n.scaleScreenMateriale,
  l10n.scaleScreenDescrizione,
  l10n.scaleScreenUbicazione,
  l10n.scaleScreenUltimaVerifica,
  l10n.scaleScreenProssimaVerifica,
  l10n.commonNoteLabel,
];

List<List<CellaPdf>> _righePdf(
  List<Scala> scale, {
  required List<Cantiere> cantieri,
  required AppLocalizations l10n,
}) {
  return scale.map((s) {
    return [
      CellaPdf(s.codice, grassetto: true),
      CellaPdf(s.materiale),
      CellaPdf(s.descrizione),
      CellaPdf(_descrizioneUbicazione(s, cantieri, l10n)[0]),
      CellaPdf(formatData(s.ultimaVerifica)),
      cellaScadenza(s.prossimaVerifica),
      CellaPdf(s.note),
    ];
  }).toList();
}

/// Una voce per ogni scadenza (non per macchinario) in scadenza o scaduta,
/// per la sezione "Scadenze imminenti" in cima alla pagina.
List<_VoceScadenza> _vociScadenza(List<Scala> scale, AppLocalizations l10n) {
  final voci = <_VoceScadenza>[];
  for (final s in scale) {
    final campi = {
      l10n.scaleScreenProssimaVerifica: s.prossimaVerifica,
    };
    for (final entry in campi.entries) {
      final data = parseData(entry.value);
      if (data == null) continue;
      final stato = computeStato(data);
      if (stato == StatoScadenza.valido) continue;
      voci.add((scala: s, tipo: entry.key, scadenza: data, stato: stato));
    }
  }
  voci.sort((a, b) => a.scadenza.compareTo(b.scadenza));
  return voci;
}

class ScaleScreen extends StatefulWidget {
  const ScaleScreen({super.key});

  @override
  State<ScaleScreen> createState() => _ScaleScreenState();
}

class _ScaleScreenState extends State<ScaleScreen> {
  bool _loaded = false;
  final _searchController = TextEditingController();
  String _query = '';
  final _espanse = <String>{};
  bool _scadenzeImminentiEspanse = false;
  bool _scaleEspanse = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_loaded) {
      _loaded = true;
      final cantieriProvider = context.read<CantieriProvider>();
      final scaleProvider = context.read<ScaleProvider>();
      Future.microtask(() {
        scaleProvider.load();
        cantieriProvider.load();
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _stampa({
    required List<Scala> scale,
    required List<Cantiere> cantieri,
  }) async {
    final l10n = AppLocalizations.of(context)!;
    final ordinati = [...scale]..sort((a, b) => confrontaCodici(a.codice, b.codice));
    final filtro = _query.trim();
    try {
      await stampaTabellaPdf(
        titolo: l10n.scaleScreenTitle,
        sottotitolo: [
          l10n.scaleScreenPdfCount(ordinati.length),
          if (filtro.isNotEmpty) l10n.scaleScreenPdfFiltro(filtro),
        ].join(' - '),
        colonne: _colonnePdf(l10n),
        righe: _righePdf(ordinati, cantieri: cantieri, l10n: l10n),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.scaleScreenStampaErrore(e.toString()))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final primaryBlue = Theme.of(context).colorScheme.primary;
    final cantieriProvider = context.watch<CantieriProvider>();
    final scaleProvider = context.watch<ScaleProvider>();

    final erroreCaricamento =
        cantieriProvider.errorMessage ??
        scaleProvider.errorMessage;

    final query = _query.trim().toLowerCase();
    final scaleFiltrate = scaleProvider.scale
        .where(
          (s) => query.isEmpty || s.codice.toLowerCase().contains(query)
          || s.materiale.toLowerCase().contains(query) ||
          _ubicazioneTesto(
                s,
                cantieriProvider.cantieri,
              ).toLowerCase().contains(query),
        )
        .toList()
      // PocketBase ordina i codici come stringhe, quindi manderebbe L10 e L11
      // prima di L2: qui si rimette l'ordine naturale.
      ..sort((a, b) => confrontaCodici(a.codice, b.codice));
    final scadenzeImminenti = _vociScadenza(scaleProvider.scale, l10n);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: l10n.scaleScreenTitle,
        actions: [
          AppBarAction(
            icon: Icons.add_outlined,
            label: l10n.scaleScreenNuovaScala,
            onPressed: () => showScalaFormDialog(
              context,
              provider: scaleProvider,
              scale: scaleProvider.scale,
              cantieri: cantieriProvider.cantieri
            )
          )
        ],
        iconActions: [
          AppBarAction(
            icon: Icons.print_outlined,
            label: l10n.scaleScreenStampa,
            onPressed: () => _stampa(
              scale: scaleFiltrate,
              cantieri: cantieriProvider.cantieri
            )
          )
        ],
      ),
      drawer: const AppDrawer(current: 'Scale'),
      body: scaleProvider.isLoading && cantieriProvider.isLoading 
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async {
                await cantieriProvider.load();
                await scaleProvider.load();
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
                  if (scadenzeImminenti.isNotEmpty) ... [
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
                            l10n.scaleScreenScadenzeImminenti,
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
                              ? l10n.scaleScreenNascondiScadenze
                              : l10n.scaleScreenMostraScadenze,
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
                              provider: scaleProvider,
                              cantieriProvider: cantieriProvider,
                              scale: scaleProvider.scale,
                            ),
                    ),
                    const SizedBox(height: 24),
                  ],
                  Row(
                    children: [
                      Text(
                        l10n.scaleScreenPresenti,
                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 22, color: primaryBlue),
                      ),
                      IconButton(
                        tooltip: _scaleEspanse
                            ? l10n.scaleScreenNascondiTutti
                            : l10n.scaleScreenMostraTutti,
                        onPressed: () {
                          setState(() {
                            _scaleEspanse = !_scaleEspanse;
                            if (_scaleEspanse) {
                            _espanse.addAll(
                              scaleProvider.scale.map((s) => s.id),
                            );
                            }
                            else {
                              _espanse.clear();
                            }
                          });
                        },
                        icon: Icon(
                          _scaleEspanse ? Icons.unfold_less_outlined : Icons.unfold_more_outlined,
                          color: primaryBlue, size: 20,
                        ),
                      ),
                    ]
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: Icon(Icons.search, color: primaryBlue),
                      hintText: l10n.scaleScreenSearchHint,
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
                  if (scaleFiltrate.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Center(
                        child: Text(
                          scaleProvider.scale.isEmpty
                              ? l10n.scaleScreenNessunElementoCaricato
                              : l10n.scaleScreenNessunElementoTrovato(_query.trim()),
                        ),
                      ),
                    )
                  else
                    ColumnsCardGrid(
                      maxColumns: 2,
                      minWidth: 380,
                      children: scaleFiltrate.map((s) {
                        final espansa = _espanse.contains(s.id);
                        return _ScalaCard(
                          scala: s,
                          scale: scaleProvider.scale,
                          provider: scaleProvider,
                          cantieri: cantieriProvider.cantieri,
                          espansa: espansa,
                          onToggleEspansa: () => setState(() {
                            if (espansa) {
                              _espanse.remove(s.id);
                            } else {
                              _espanse.add(s.id);
                            }
                          }),
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
    required this.cantieriProvider,
    required this.scale,
  });

  final List<_VoceScadenza> voci;
  final ScaleProvider provider;
  final CantieriProvider cantieriProvider;
  final List<Scala> scale;

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
                    voce.scala.notaScadenza;
                final ubicazione = _ubicazioneVoce(voce.scala, cantieriProvider.cantieri, l10n);
                return ListTile(
                  leading: StatoBadge(stato: voce.stato, showLabel: !isMobile,),
                  title: Text(voce.tipo, style: const TextStyle(fontWeight: FontWeight.w700)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      VoceInfo(l10n.scaleScreenCodiceScala, voce.scala.codice),
                      VoceInfo(l10n.scaleScreenUbicazione, ubicazione),
                      if (notaScadenza.isNotEmpty)
                        VoceInfo(l10n.scaleScreenNotaScadenza, notaScadenza),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit_note_rounded, color: primaryBlue, size: isMobile ? 18 : 22),
                        tooltip: l10n.scaleScreenModificaNota,
                        onPressed: () => showNotaScalaDialog(
                          context,
                          provider: provider,
                          scala: voce.scala,
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
                  onTap: () => showScalaFormDialog(
                    context,
                    provider: provider,
                    scale: scale,
                    cantieri: cantieriProvider.cantieri,
                    esistente: voce.scala,
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

class _ScalaCard extends StatelessWidget {
  const _ScalaCard({
    required this.scala,
    required this.scale,
    required this.provider,
    required this.cantieri,
    required this.espansa,
    required this.onToggleEspansa,
  });

  final Scala scala;
  final List<Scala> scale;
  final ScaleProvider provider;
  final List<Cantiere> cantieri;
  final bool espansa;
  final VoidCallback onToggleEspansa;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final primaryBlue = Theme.of(context).colorScheme.primary;
    final isMobile = MediaQuery.sizeOf(context).width < kMobileAppBarBreakpoint;
    final scaleProvider = context.watch<ScaleProvider>();
    final stato = statoScadenzaScale(scaleProvider.scale);
    final ubicazione = _ubicazioneVoce(scala, cantieri, l10n);

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: StatoBadge(stato: stato, showLabel: false),
            title: Text(scala.codice, style: const TextStyle(fontWeight: FontWeight.w700)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                VoceInfo(l10n.scaleScreenUbicazione, ubicazione),
                VoceInfo(l10n.scaleScreenDescrizione, scala.descrizione),
                if (scala.note != '') VoceInfo(l10n.commonNoteLabel, scala.note),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit_outlined, color: primaryBlue, size: isMobile ? 18 : 22),
                  tooltip: l10n.commonEdit,
                  onPressed: () => showScalaFormDialog(
                    context,
                    provider: provider,
                    scale: scale,
                    cantieri: cantieri,
                    esistente: scala,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.delete_outline, color: primaryBlue, size: isMobile ? 18 : 22),
                  tooltip: l10n.scaleScreenEliminaScala,
                  onPressed: () async {
                    final confermato = await showConfirmDialog(
                      context,
                      title: l10n.scaleScreenEliminareScalaTitle,
                      message: l10n.scaleScreenConfirmDeleteMessage(scala.codice),
                    );
                    if (confermato) {
                      await scaleProvider.delete(
                        scala.id,
                      );
                    }
                  },
                ),
                IconButton(
                  tooltip: espansa ? l10n.scaleScreenNascondiInfo : l10n.scaleScreenMostraInfo,
                  onPressed: onToggleEspansa,
                  icon: Icon(
                    espansa ? Icons.keyboard_arrow_up_outlined : Icons.keyboard_arrow_down_outlined,
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
                        Text(l10n.scaleScreenAnagrafica, style: TextStyle(fontWeight: FontWeight.w600, color: primaryBlue)),
                        const SizedBox(height: 8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            campoInfo(l10n.scaleScreenCodice, scala.codice),
                            campoInfo(l10n.scaleScreenMateriale, scala.materiale),
                            campoInfo(l10n.scaleScreenDescrizione, scala.descrizione)
                          ]
                        ),
                        const SizedBox(height: 12),
                        Text(l10n.scaleScreenUbicazione, style: TextStyle(fontWeight: FontWeight.w600, color: primaryBlue)),
                        const SizedBox(height: 8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            campoInfo(l10n.scaleScreenUbicazione, _descrizioneUbicazione(scala, cantieri, l10n).join(', ')),
                          ]
                        ),
                        const SizedBox(height: 12),
                        Text(l10n.scaleScreenControlli, style: TextStyle(fontWeight: FontWeight.w600, color: primaryBlue)),
                        const SizedBox(height: 8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            campoInfo(l10n.scaleScreenUltimaVerifica, formatData(scala.ultimaVerifica)),
                            campoScadenza(l10n.scaleScreenProssimaVerifica, scala.prossimaVerifica),
                            campoInfo(l10n.commonNoteLabel, scala.note)
                          ]
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