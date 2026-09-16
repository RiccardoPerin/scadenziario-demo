import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badges;

import '../l10n/app_localizations.dart';
import '../widgets/app_bar.dart';
import '../widgets/app_drawer.dart';
import '../widgets/campo_info.dart';
import '../widgets/nota_rifiuto_dialog.dart';
import '../widgets/stato_badge.dart';
import '../widgets/info_dialog.dart';
import '../widgets/responsive_card_grid.dart';
import '../widgets/rifiuto_form_dialog.dart';
import '../widgets/voce_info.dart';
import '../models/rifiuto.dart';
import '../providers/rifiuti_provider.dart';
import '../services/stato_scadenze.dart';
import '../widgets/confirm_dialog.dart';

typedef _VoceScadenza = ({
  Rifiuto rifiuto,
  String tipo,
  DateTime scadenza,
  StatoScadenza stato,
});

/// Etichetta localizzata per un tipo di scadenza rifiuti: la chiave italiana
/// resta quella salvata in [Rifiuto.noteScadenze] (usata anche come Map key),
/// solo il testo mostrato all'utente cambia lingua.
String _tipoScadenzaLabel(String tipo, AppLocalizations l10n) {
  switch (tipo) {
    case 'Scadenza Rifiuti Non Pericolosi Trasportatore':
      return l10n.rifiutiScreenTipoNonPericolosiTrasportatore;
    case 'Scadenza Rifiuti Pericolosi Trasportatore':
      return l10n.rifiutiScreenTipoPericolosiTrasportatore;
    case 'Scadenza Rifiuti Non Pericolosi Smaltitore':
      return l10n.rifiutiScreenTipoNonPericolosiSmaltitore;
    case 'Scadenza Rifiuti Pericolosi Smaltitore':
      return l10n.rifiutiScreenTipoPericolosiSmaltitore;
    default:
      return tipo;
  }
}

List<_VoceScadenza> _vociScadenza(List<Rifiuto> rifiuti) {
  final voci = <_VoceScadenza>[];
  for (final r in rifiuti) {
    final campi = {
      'Scadenza Rifiuti Non Pericolosi Trasportatore': r.scadRifiutiNonPericolosiTrasportatore,
      'Scadenza Rifiuti Pericolosi Trasportatore': r.scadRifiutiPericolosiTrasportatore,
      'Scadenza Rifiuti Non Pericolosi Smaltitore': r.scadRifiutiNonPericolosiSmaltitore,
      'Scadenza Rifiuti Pericolosi Smaltitore': r.scadRifiutiPericolosiSmaltitore,
    };
    for (final entry in campi.entries) {
      final data = parseData(entry.value);
      if (data == null) continue;
      final stato = computeStato(data);
      if (stato == StatoScadenza.valido) continue;
      voci.add((rifiuto: r, tipo: entry.key, scadenza: data, stato: stato));
    }
  }
  voci.sort((a, b) => a.scadenza.compareTo(b.scadenza));
  return voci;
}

class RifiutiScreen extends StatefulWidget {
  const RifiutiScreen({super.key});

  @override
  State<RifiutiScreen> createState() => _RifiutiScreenState();
}

class _RifiutiScreenState extends State<RifiutiScreen> {
  final _searchController = TextEditingController();
  String _query = '';
  bool _loaded = false;
  final _espanse = <String>{};
  bool _scadenzeImminentiEspanse = false;
  bool _rifiutiEspansi = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_loaded) {
      final rifiutiProvider = context.read<RifiutiProvider>();
      _loaded = true;
      Future.microtask(() {
        rifiutiProvider.load();
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
    final rifiutiProvider = context.watch<RifiutiProvider>();

    final erroreCaricamento = rifiutiProvider.errorMessage;
    final query = _query.trim().toLowerCase();
    final rifiutiFiltrati = rifiutiProvider.rifiuti
        .where(
          (r) =>
              query.isEmpty ||
              r.nomeDitta.toLowerCase().contains(query)
        ).toList();
    final scadenzeImminenti = _vociScadenza(rifiutiProvider.rifiuti);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: l10n.rifiutiScreenTitle,
        actions: [
          AppBarAction(
            icon: Icons.add_outlined,
            label: l10n.commonAdd,
            onPressed: () => showRifiutoFormDialog(
              context, 
              provider: rifiutiProvider, 
              rifiuti: rifiutiProvider.rifiuti
            )
          )
        ],
      ),
      drawer: const AppDrawer(current: 'Rifiuti'),
      body: rifiutiProvider.isLoading && rifiutiProvider.rifiuti.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async {
                await Future.wait([
                  rifiutiProvider.load(),
                ]);
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
                            l10n.rifiutiScreenScadenzeImminenti,
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
                              ? l10n.rifiutiScreenNascondiScadenze
                              : l10n.rifiutiScreenMostraScadenze,
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
                              provider: rifiutiProvider,
                              rifiuti: rifiutiProvider.rifiuti,
                            ),
                    ),
                    const SizedBox(height: 24),
                  ],
                  Row(
                    children: [
                      Text(
                        l10n.rifiutiScreenAziendePerRaccolta,
                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 22, color: primaryBlue),
                      ),
                      IconButton(
                        tooltip: _rifiutiEspansi ? l10n.rifiutiScreenNascondiTutti : l10n.rifiutiScreenMostraTutti,
                        onPressed: () {
                          setState(() {
                            _rifiutiEspansi = !_rifiutiEspansi;
                            if (_rifiutiEspansi) {
                            _espanse.addAll(
                              rifiutiProvider.rifiuti.map((r) => r.id),
                            );
                            }
                            else {
                              _espanse.clear();
                            }
                          });
                        },
                        icon: Icon(
                          _rifiutiEspansi ? Icons.unfold_less_outlined : Icons.unfold_more_outlined,
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
                      hintText: l10n.rifiutiScreenCercaPerNomeDitta,
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
                  if (rifiutiFiltrati.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Center(
                        child: Text(
                          rifiutiProvider.rifiuti.isEmpty
                              ? l10n.rifiutiScreenNessunElementoCaricato
                              : l10n.rifiutiScreenNessunElementoTrovato(_query.trim()),
                        ),
                      ),
                    )
                  else
                    ColumnsCardGrid(
                      maxColumns: 2,
                      minWidth: 380,
                      children: rifiutiFiltrati.map((r) {
                        final espansa = _espanse.contains(r.id);
                        return _RifiutoCard(
                          rifiuto: r,
                          rifiuti: rifiutiProvider.rifiuti,
                          provider: rifiutiProvider,
                          espansa: espansa,
                          onToggleEspansa: () => setState(() {
                            if (espansa) {
                              _espanse.remove(r.id);
                            } else {
                              _espanse.add(r.id);
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
    required this.rifiuti,
  });

  final List<_VoceScadenza> voci;
  final RifiutiProvider provider;
  final List<Rifiuto> rifiuti;

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
                    voce.rifiuto.noteScadenze[voce.tipo] ?? '';
                return ListTile(
                  leading: StatoBadge(stato: voce.stato, showLabel: !isMobile,),
                  title: Text(_tipoScadenzaLabel(voce.tipo, l10n), style: const TextStyle(fontWeight: FontWeight.w700)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      VoceInfo(l10n.rifiutiScreenCampoDitta, voce.rifiuto.nomeDitta),
                      if (notaScadenza.isNotEmpty) VoceInfo(l10n.rifiutiScreenNotaScadenza, notaScadenza)
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit_note_rounded, color: primaryBlue, size: isMobile ? 18 : 22),
                        tooltip: l10n.rifiutiScreenModificaNota,
                        onPressed: () => showNotaRifiutoDialog(
                          context,
                          provider: provider,
                          rifiuto: voce.rifiuto,
                          tipo: voce.tipo,
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
                  onTap: () => showRifiutoFormDialog(
                    context,
                    provider: provider,
                    rifiuti: rifiuti,
                    esistente: voce.rifiuto,
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

class _RifiutoCard extends StatelessWidget {
  const _RifiutoCard({
    required this.rifiuto,
    required this.rifiuti,
    required this.provider,
    required this.espansa,
    required this.onToggleEspansa,
  });

  final Rifiuto rifiuto;
  final List<Rifiuto> rifiuti;
  final RifiutiProvider provider;
  final bool espansa;
  final VoidCallback onToggleEspansa;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final primaryBlue = Theme.of(context).colorScheme.primary;
    final isMobile = MediaQuery.sizeOf(context).width < kMobileAppBarBreakpoint;
    final rifiutiProvider = context.watch<RifiutiProvider>();
    final stato = statoScadenzaRifiuti(rifiutiProvider.rifiuti);

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: StatoBadge(stato: stato, showLabel: false),
            title: Text(rifiuto.nomeDitta, style: const TextStyle(fontWeight: FontWeight.w700)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (rifiuto.trasportatore) VoceInfo(l10n.rifiutiScreenCampoTrasportatore, l10n.commonYes),
                if (rifiuto.noteTrasportatore != '') VoceInfo(l10n.rifiutiScreenNoteTrasportatore, rifiuto.noteTrasportatore),
                if (rifiuto.smaltitore) VoceInfo(l10n.rifiutiScreenCampoSmaltitore, l10n.commonYes),
                if (rifiuto.noteSmaltitore != '') VoceInfo(l10n.rifiutiScreenNoteSmaltitore, rifiuto.noteSmaltitore),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit_outlined, color: primaryBlue, size: isMobile ? 18 : 22),
                  tooltip: l10n.commonEdit,
                  onPressed: () => showRifiutoFormDialog(
                    context,
                    provider: provider,
                    rifiuti: rifiuti,
                    esistente: rifiuto,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.delete_outline, color: primaryBlue, size: isMobile ? 18 : 22),
                  tooltip: l10n.rifiutiScreenEliminaAzienda,
                  onPressed: () async {
                    final confermato = await showConfirmDialog(
                      context,
                      title: l10n.rifiutiScreenEliminareAziendaTitle,
                      message: l10n.rifiutiScreenEliminareAziendaMessage(rifiuto.nomeDitta),
                    );
                    if (confermato) {
                      await rifiutiProvider.delete(
                        rifiuto.id,
                      );
                    }
                  },
                ),
                IconButton(
                  tooltip: espansa ? l10n.rifiutiScreenNascondiInfo : l10n.rifiutiScreenMostraInfo,
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
                        if (rifiuto.trasportatore) ... [
                          const SizedBox(height: 12),
                          Text(l10n.rifiutiScreenCampoTrasportatore, style: TextStyle(fontWeight: FontWeight.w600, color: primaryBlue, fontSize: 15)),
                          const SizedBox(height: 8),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              campoInfo(l10n.rifiutiScreenNrAutorizzazione, rifiuto.nrAutorizzazioneTrasportatore),
                              campoScadenza(l10n.rifiutiScreenScadNonPericolosi, rifiuto.scadRifiutiNonPericolosiTrasportatore),
                              rifiuto.autorizzazioneRifiutiPericolosiTrasportatore
                                  ? campoScadenza(l10n.rifiutiScreenScadPericolosi, rifiuto.scadRifiutiPericolosiTrasportatore)
                                  : const Expanded(child: SizedBox.shrink()),
                            ],
                          ),
                        ],
                        if (rifiuto.smaltitore) ... [
                          SizedBox(height: rifiuto.trasportatore ? 16 : 12),
                          Text(l10n.rifiutiScreenCampoSmaltitore, style: TextStyle(fontWeight: FontWeight.w600, color: primaryBlue, fontSize: 15)),
                          const SizedBox(height: 8),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              campoInfo(l10n.rifiutiScreenNrAutorizzazione, rifiuto.nrAutorizzazioneSmaltitore),
                              campoScadenza(l10n.rifiutiScreenScadNonPericolosi, rifiuto.scadRifiutiNonPericolosiSmaltitore),
                              rifiuto.autorizzazioneRifiutiPericolosiSmaltitore
                                  ? campoScadenza(l10n.rifiutiScreenScadPericolosi, rifiuto.scadRifiutiPericolosiSmaltitore)
                                  : const Expanded(child: SizedBox.shrink()),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}