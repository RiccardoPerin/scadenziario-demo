import 'package:flutter/material.dart';
import 'package:gestionale_edile/widgets/voce_info.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badges;

import '../l10n/app_localizations.dart';
import '../widgets/app_bar.dart';
import '../widgets/app_drawer.dart';
import '../widgets/stato_badge.dart';
import '../widgets/campo_info.dart';
import '../widgets/info_dialog.dart';
import '../widgets/confirm_dialog.dart';
import '../widgets/misure_form_dialog.dart';
import '../widgets/nota_misura_dialog.dart';
import '../widgets/responsive_card_grid.dart';
import '../services/stato_scadenze.dart';

import '../models/dipendente_aziendale.dart';
import '../models/misura.dart';
import '../providers/misure_provider.dart';
import '../providers/dipendenti_aziendali_provider.dart';

List<Widget> _rigaCampi(List<Widget> campi, {int colonne = 3}) {
  return [
    ...campi,
    for (var i = campi.length; i < colonne; i++) const Expanded(child: SizedBox()),
  ];
}

/// L'incaricato della taratura interna è salvato come id del dipendente
/// aziendale: va risolto nel nome completo prima di mostrarlo. Se il
/// dipendente non esiste più si tiene il valore salvato.
String _nomeIncaricato(String valore, List<DipendenteAziendale> dipendenti) {
  if (valore.isEmpty) return valore;
  for (final dipendente in dipendenti) {
    if (dipendente.id == valore) return dipendente.nomeCompleto;
  }
  return valore;
}

typedef _VoceScadenza = ({
  Misura misura,
  String tipo,
  DateTime scadenza,
  StatoScadenza stato,
});

/// Una voce per ogni scadenza (non per macchinario) in scadenza o scaduta,
/// per la sezione "Scadenze imminenti" in cima alla pagina.
List<_VoceScadenza> _vociScadenza(List<Misura> misure) {
  final voci = <_VoceScadenza>[];
  for (final m in misure) {
    final campi = {
      'Prossima taratura interna': m.dataProssimaTaraturaInterna,
      'Prossima taratura esterna': m.dataProssimaTaraturaEsterna,
    };
    for (final entry in campi.entries) {
      final data = parseData(entry.value);
      if (data == null) continue;
      final stato = computeStato(data);
      if (stato == StatoScadenza.valido) continue;
      voci.add((misura: m, tipo: entry.key, scadenza: data, stato: stato));
    }
  }
  voci.sort((a, b) => a.scadenza.compareTo(b.scadenza));
  return voci;
}

/// Etichetta leggibile per il [tipo] di scadenza (le chiavi restano in
/// italiano perché usate anche come chiave di [Misura.noteScadenze] e per
/// confronti interni).
String _tipoScadenzaLabel(AppLocalizations l10n, String tipo) {
  switch (tipo) {
    case 'Prossima taratura interna':
      return l10n.misureScreenTipoProssimaTaraturaInterna;
    case 'Prossima taratura esterna':
      return l10n.misureScreenTipoProssimaTaraturaEsterna;
    default:
      return tipo;
  }
}

class MisureScreen extends StatefulWidget {
  const MisureScreen({super.key});

  @override
  State<MisureScreen> createState() => _MisureScreenState();
}

class _MisureScreenState extends State<MisureScreen> {
  final _searchController = TextEditingController();
  String _query = '';
  bool _loaded = false;
  final _espanse = <String>{};
  bool _scadenzeImminentiEspanse = false;
  bool _misureEspanse = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_loaded) {
      final misureProvider = context.read<MisureProvider>();
      final dipendentiProvider = context.read<DipendentiAziendaliProvider>();
      _loaded = true;
      Future.microtask(() {
        misureProvider.load();
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
    final l10n = AppLocalizations.of(context)!;
    final primaryBlue = Theme.of(context).colorScheme.primary;
    final misureProvider = context.watch<MisureProvider>();
    final dipendentiProvider = context.watch<DipendentiAziendaliProvider>();
    final erroreCaricamento = misureProvider.errorMessage ?? dipendentiProvider.errorMessage;

    final query = _query.trim().toLowerCase();
    final misureFiltrate = misureProvider.misure
        .where((m) => query.isEmpty || m.nome.toLowerCase().contains(query))
        .toList();
    final scadenzeImminenti = _vociScadenza(misureProvider.misure);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: l10n.misureScreenTitle,
        actions: [
          AppBarAction(
            icon: Icons.add,
            label: l10n.misureScreenNewButton,
            onPressed: () => showMisureFormDialog(
              context,
              provider: misureProvider,
              dipProvider: dipendentiProvider,
              misure: misureProvider.misure, 
            )
          )
        ],
      ),
      drawer: const AppDrawer(current: 'Misure'),
      body:
          misureProvider.isLoading && misureProvider.misure.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async {
                await misureProvider.load();
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
                            l10n.misureScreenUpcomingDeadlines,
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
                          tooltip: _scadenzeImminentiEspanse ? l10n.misureScreenHideDeadlines : l10n.misureScreenShowDeadlines,
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
                              provider: misureProvider,
                              misure: misureProvider.misure,
                            ),
                    ),
                    const SizedBox(height: 24),
                  ],
                  Row(
                    children: [
                      Text(
                        l10n.misureScreenSectionTitle,
                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 22, color: primaryBlue),
                      ),
                      IconButton(
                        tooltip: _misureEspanse ? l10n.misureScreenCollapseAll : l10n.misureScreenExpandAll,
                        onPressed: () {
                          setState(() {
                            _misureEspanse = !_misureEspanse;
                            if (_misureEspanse) {
                              _espanse.addAll(
                                misureProvider.misure.map((m) => m.id),
                              );
                            } else {
                              _espanse.clear();
                            }
                          });
                        },
                        icon: Icon(
                          _misureEspanse ? Icons.unfold_less_outlined : Icons.unfold_more_outlined,
                          color: primaryBlue, size: 20
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
                      hintText: l10n.misureScreenSearchHint,
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
                  if (misureFiltrate.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Center(
                        child: Text(
                          misureProvider.misure.isEmpty
                              ? l10n.misureScreenEmptyNone
                              : l10n.misureScreenEmptySearch(_query.trim()),
                        ),
                      ),
                    )
                  else
                    ColumnsCardGrid(
                      maxColumns: 2,
                      minWidth: 380,
                      children: misureFiltrate.map((misura) {
                        final espansa = _espanse.contains(misura.id);
                        return _MisuraCard(
                          misura: misura, 
                          misure: misureProvider.misure, 
                          provider: misureProvider, 
                          espansa: espansa, 
                          onToggleEspansa: () => setState(() {
                            if (espansa) {
                              _espanse.remove(misura.id);
                            } else {
                              _espanse.add(misura.id);
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
    required this.misure,
  });

  final List<_VoceScadenza> voci;
  final MisureProvider provider;
  final List<Misura> misure;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isMobile = MediaQuery.sizeOf(context).width < kMobileAppBarBreakpoint;
    final primaryBlue = Theme.of(context).colorScheme.primary;
    final dipendenti = context.watch<DipendentiAziendaliProvider>().dipendenti;
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
                    voce.misura.noteScadenze[voce.tipo] ?? '';
                return ListTile(
                  leading: StatoBadge(stato: voce.stato, showLabel: !isMobile),
                  title: Text(_tipoScadenzaLabel(l10n, voce.tipo), style: const TextStyle(fontWeight: FontWeight.w700)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      VoceInfo(l10n.misureScreenLabelModello, voce.misura.nome),
                      if (voce.tipo == 'Prossima taratura interna') VoceInfo(l10n.misureScreenLabelIncaricato, _nomeIncaricato(voce.misura.incaricatoTaraturaInterna, dipendenti)),
                      if (voce.tipo == 'Prossima taratura esterna') VoceInfo(l10n.misureScreenLabelIncaricato, voce.misura.incaricatoTaraturaEsterna),
                      if (voce.misura.note != '') VoceInfo(l10n.commonNoteLabel, voce.misura.note),
                      if (notaScadenza != '') VoceInfo(l10n.misureScreenLabelNotaScadenza, notaScadenza),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit_note_rounded, color: primaryBlue, size: isMobile ? 18 : 22),
                        tooltip: l10n.misureScreenEditNoteTooltip,
                        onPressed: () => showNotaMisuraDialog(
                          context,
                          provider: provider,
                          misura: voce.misura,
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
                  onTap: () => showMisureFormDialog(
                    context,
                    provider: provider,
                    dipProvider: context.read<DipendentiAziendaliProvider>(),
                    misure: misure,
                    esistente: voce.misura,
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

class _MisuraCard extends StatelessWidget{
  const _MisuraCard({
    required this.misura,
    required this.misure,
    required this.provider,
    required this.espansa,
    required this.onToggleEspansa,
  });

  final Misura misura;
  final List<Misura> misure;
  final MisureProvider provider;
  final bool espansa;
  final VoidCallback onToggleEspansa;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final primaryBlue = Theme.of(context).colorScheme.primary;
    final isMobile = MediaQuery.sizeOf(context).width < kMobileAppBarBreakpoint;
    final misureProvider = context.watch<MisureProvider>();
    final dipendentiProvider = context.watch<DipendentiAziendaliProvider>();
    final stato = statoScadenzaMisure([misura]);

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: StatoBadge(
              stato: stato,
              showLabel: false,
            ),
            title: Text(misura.nome, style: const TextStyle(fontWeight: FontWeight.w700)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                VoceInfo(l10n.misureScreenLabelMatricola, misura.matricola),
                if (misura.note != '') VoceInfo(l10n.commonNoteLabel, misura.note)
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit_outlined, color: primaryBlue, size: isMobile ? 18 : 22),
                  tooltip: l10n.misureScreenEditTooltip,
                  onPressed: () => showMisureFormDialog(
                    context,
                    provider: misureProvider,
                    dipProvider: dipendentiProvider,
                    misure: misure,
                    esistente: misura,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.delete_outline, color: primaryBlue, size: isMobile ? 18 : 22),
                  tooltip: l10n.misureScreenDeleteTooltip,
                  onPressed: () async {
                    final confermato = await showConfirmDialog(
                      context,
                      title: l10n.misureScreenDeleteConfirmTitle,
                      message: l10n.misureScreenDeleteConfirmMessage(misura.nome),
                    );
                    if (confermato) {
                      await misureProvider.delete(
                        misura.id,
                      );
                    }
                  },
                ),
                IconButton(
                  tooltip: espansa ? l10n.misureScreenHideInfo : l10n.misureScreenShowInfo,
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
                        Text(l10n.misureScreenSectionGeneralData, style: TextStyle(fontWeight: FontWeight.w600, color: primaryBlue, fontSize: 15)),
                        const SizedBox(height: 8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: _rigaCampi([
                            if (misura.riferimento != '') campoInfo(l10n.misureScreenLabelRifAcq, misura.riferimento),
                            if (misura.matricola != '') campoInfo(l10n.misureScreenLabelMatricola, misura.matricola),
                            if (misura.note != '') campoInfo(l10n.commonNoteLabel, misura.note),
                          ]),
                        ),
                        const SizedBox(height: 12),
                        Text(l10n.misureScreenSectionTaraturaInterna, style: TextStyle(fontWeight: FontWeight.w600, color: primaryBlue, fontSize: 15)),
                        const SizedBox(height: 8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                          campoInfo(l10n.misureScreenLabelIncaricato, _nomeIncaricato(misura.incaricatoTaraturaInterna, dipendentiProvider.dipendenti)),
                          campoInfo(l10n.misureScreenLabelDataUltimaTaratura, formatData(misura.dataTaraturaInterna)),
                          campoScadenza(l10n.misureScreenLabelDataProssimaTaratura, misura.dataProssimaTaraturaInterna),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(l10n.misureScreenSectionTaraturaEsterna, style: TextStyle(fontWeight: FontWeight.w600, color: primaryBlue, fontSize: 15)),
                        const SizedBox(height: 8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                          campoInfo(l10n.misureScreenLabelIncaricato, misura.incaricatoTaraturaEsterna),
                          campoInfo(l10n.misureScreenLabelDataUltimaTaratura, formatData(misura.dataTaraturaEsterna)),
                          campoScadenza(l10n.misureScreenLabelDataProssimaTaratura, misura.dataProssimaTaraturaEsterna),
                          ],
                        ),
                      ]
                    ),
                  )
          )
        ],
      )
    );
  }
}