import 'package:flutter/material.dart';
import 'package:gestionale_edile/widgets/voce_info.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badges;

import '../l10n/app_localizations.dart';
import '../widgets/app_bar.dart';
import '../widgets/app_drawer.dart';
import '../widgets/campo_info.dart';
import '../widgets/stato_badge.dart';
import '../widgets/info_dialog.dart';
import '../widgets/responsive_card_grid.dart';
import '../widgets/confirm_dialog.dart';
import '../widgets/nota_scaffalatura_dialog.dart';
import '../widgets/scaffalatura_form_dialog.dart';
import '../services/stato_scadenze.dart';

import '../models/scaffalatura.dart';
import '../providers/scaffalature_provider.dart';

typedef _VoceScadenza = ({
  Scaffalatura scaffalatura,
  String tipo,
  DateTime scadenza,
  StatoScadenza stato,
});

List<_VoceScadenza> _vociScadenza(List<Scaffalatura> scaffalature, AppLocalizations l10n) {
  final voci = <_VoceScadenza>[];
  for (final s in scaffalature) {
    final campo = {l10n.scaffalatureScreenNextCheckType: s.dataProssimaVerifica};

    for (final entry in campo.entries) {
      final data = parseData(entry.value);
      if (data == null) continue;
      final stato = computeStato(data);
      if (stato == StatoScadenza.valido) continue;
      voci.add((scaffalatura: s, tipo: entry.key, scadenza: data, stato: stato));
    }
  }
  voci.sort((a, b) => a.scadenza.compareTo(b.scadenza));
  return voci;
}


class ScaffalatureScreen extends StatefulWidget {
  const ScaffalatureScreen({super.key});

  @override
  State<ScaffalatureScreen> createState() => _ScaffalatureScreenState();
}

class _ScaffalatureScreenState extends State<ScaffalatureScreen> {
  bool _loaded = false;
  final _espanse = <String>{};
  bool _scadenzeImminentiEspanse = false;
  bool _scaffalatureEspanse = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_loaded) {
      _loaded = true;
      final scaffalatureProvider = context.read<ScaffalatureProvider>();
      Future.microtask(() {
        scaffalatureProvider.load();
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final primaryBlue = Theme.of(context).colorScheme.primary;
    final scaffalatureProvider = context.watch<ScaffalatureProvider>();

    final scadenzeImminenti = _vociScadenza(scaffalatureProvider.scaffalature, l10n);

    final erroreCaricamento = scaffalatureProvider.errorMessage;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: l10n.scaffalatureScreenTitle,
        actions: [
          AppBarAction(
            icon: Icons.add_outlined,
            label: l10n.scaffalatureScreenAddLabel,
            onPressed: () => showScaffalaturaFormDialog(
              context, 
              provider: scaffalatureProvider, 
              scaffalature: scaffalatureProvider.scaffalature
            )
          )
        ],
      ),
      drawer: const AppDrawer(current: 'Scaffalature'),
      body: scaffalatureProvider.isLoading && scaffalatureProvider.scaffalature.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async {
                await Future.wait([
                  scaffalatureProvider.load(),
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
                            l10n.scaffalatureScreenUpcomingDeadlines,
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
                              ? l10n.scaffalatureScreenHideDeadlinesTooltip
                              : l10n.scaffalatureScreenShowDeadlinesTooltip,
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
                              provider: scaffalatureProvider,
                              scaffalature: scaffalatureProvider.scaffalature,
                            ),
                    ),
                    const SizedBox(height: 24),
                  ],
                  Row(
                    children: [
                      Text(
                        l10n.scaffalatureScreenSectionTitle,
                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 22, color: primaryBlue),
                      ),
                      IconButton(
                        tooltip: _scaffalatureEspanse
                            ? l10n.scaffalatureScreenHideAllTooltip
                            : l10n.scaffalatureScreenShowAllTooltip,
                        onPressed: () {
                          setState(() {
                            _scaffalatureEspanse = !_scaffalatureEspanse;
                            if (_scaffalatureEspanse) {
                            _espanse.addAll(
                              scaffalatureProvider.scaffalature.map((s) => s.id),
                            );
                            }
                            else {
                              _espanse.clear();
                            }
                          });
                        },
                        icon: Icon(
                          _scaffalatureEspanse ? Icons.unfold_less_outlined : Icons.unfold_more_outlined,
                          color: primaryBlue, size: 20,
                        ),
                      ),
                    ]
                  ),
                  const Divider(height: 12),
                  if (scaffalatureProvider.scaffalature.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Center(
                        child: Text(l10n.scaffalatureScreenNoItemsLoaded),
                      ),
                    )
                  else
                    ColumnsCardGrid(
                      maxColumns: 2,
                      minWidth: 380,
                      children: scaffalatureProvider.scaffalature.map((s) {
                        final espansa = _espanse.contains(s.id);
                        return _ScaffalaturaCard(
                          scaffalatura: s,
                          scaffalature: scaffalatureProvider.scaffalature,
                          provider: scaffalatureProvider,
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
    required this.scaffalature,
  });

  final List<_VoceScadenza> voci;
  final ScaffalatureProvider provider;
  final List<Scaffalatura> scaffalature;

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
                final notaScadenza = voce.scaffalatura.notaScadenza;
                return ListTile(
                  leading: StatoBadge(stato: voce.stato, showLabel: !isMobile,),
                  title: Text(voce.tipo, style: const TextStyle(fontWeight: FontWeight.w700)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      VoceInfo(l10n.scaffalatureScreenIdLabel, voce.scaffalatura.idInterno),
                      VoceInfo(l10n.scaffalatureScreenLastCheckLabel, formatData(voce.scaffalatura.dataVerifica)),
                      if (voce.scaffalatura.note != '') VoceInfo(l10n.commonNoteLabel, voce.scaffalatura.note),
                      if (notaScadenza.isNotEmpty) VoceInfo(l10n.scaffalatureScreenDeadlineNoteLabel, notaScadenza),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit_note_rounded, color: primaryBlue, size: isMobile ? 18 : 22),
                        tooltip: l10n.scaffalatureScreenEditNoteTooltip,
                        onPressed: () => showNotaScaffalaturaDialog(
                          context,
                          provider: provider,
                          scaffalatura: voce.scaffalatura,
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
                  onTap: () => showScaffalaturaFormDialog(
                    context,
                    provider: provider,
                    scaffalature: scaffalature,
                    esistente: voce.scaffalatura,
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

class _ScaffalaturaCard extends StatelessWidget {
  const _ScaffalaturaCard({
    required this.scaffalatura,
    required this.scaffalature,
    required this.provider,
    required this.espansa,
    required this.onToggleEspansa,
  });

  final Scaffalatura scaffalatura;
  final List<Scaffalatura> scaffalature;
  final ScaffalatureProvider provider;
  final bool espansa;
  final VoidCallback onToggleEspansa;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final primaryBlue = Theme.of(context).colorScheme.primary;
    final isMobile = MediaQuery.sizeOf(context).width < kMobileAppBarBreakpoint;
    final scaffalatureProvider = context.watch<ScaffalatureProvider>();
    final stato = statoScadenzaScaffalatura(scaffalatura);

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: StatoBadge(stato: stato, showLabel: false),
            title: Text(l10n.scaffalatureScreenCardTitle(scaffalatura.idInterno), style: const TextStyle(fontWeight: FontWeight.w700)),
            subtitle: scaffalatura.dataVerifica != '' || scaffalatura.note != ''
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (scaffalatura.dataVerifica != '') VoceInfo(l10n.scaffalatureScreenLastCheckLabel, formatData(scaffalatura.dataVerifica)),
                    if (scaffalatura.dataProssimaVerifica != '') VoceInfo(l10n.scaffalatureScreenNextCheckLabel, formatData(scaffalatura.dataProssimaVerifica)),
                    if (scaffalatura.note != '') VoceInfo(l10n.commonNoteLabel, scaffalatura.note),
                  ],
                )
              : null,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit_outlined, color: primaryBlue, size: isMobile ? 18 : 22),
                  tooltip: l10n.commonEdit,
                  onPressed: () => showScaffalaturaFormDialog(
                    context,
                    provider: provider,
                    scaffalature: scaffalature,
                    esistente: scaffalatura,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.delete_outline, color: primaryBlue, size: isMobile ? 18 : 22),
                  tooltip: l10n.scaffalatureScreenDeleteTooltip,
                  onPressed: () async {
                    final confermato = await showConfirmDialog(
                      context,
                      title: l10n.scaffalatureScreenDeleteConfirmTitle,
                      message: l10n.scaffalatureScreenDeleteConfirmMessage(scaffalatura.idInterno),
                    );
                    if (confermato) {
                      await scaffalatureProvider.delete(
                        scaffalatura.id,
                      );
                    }
                  },
                ),
                IconButton(
                  tooltip: espansa
                      ? l10n.scaffalatureScreenHideInfoTooltip
                      : l10n.scaffalatureScreenShowInfoTooltip,
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
                        Text(l10n.scaffalatureScreenChecksSectionTitle, style: TextStyle(fontWeight: FontWeight.w600, color: primaryBlue)),
                        const SizedBox(height: 8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            campoInfo(l10n.scaffalatureScreenLastCheckLabel, formatData(scaffalatura.dataVerifica)),
                            campoScadenza(l10n.scaffalatureScreenNextCheckLabel, scaffalatura.dataProssimaVerifica),
                            campoInfo(l10n.scaffalatureScreenOutcomeLabel, scaffalatura.esitoPositivo ? l10n.scaffalatureScreenOutcomePositive : l10n.scaffalatureScreenOutcomeNegative, colore: scaffalatura.esitoPositivo ? Colors.green : Colors.redAccent),
                          ],
                        ),
                        if (scaffalatura.note != '') ... [
                          const SizedBox(height: 12),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              campoInfo(l10n.commonNoteLabel, scaffalatura.note),
                            ],
                          ),
                        ],
                      ]
                    ),
                  ),
            ),
        ],
      ),
    );
  }
}