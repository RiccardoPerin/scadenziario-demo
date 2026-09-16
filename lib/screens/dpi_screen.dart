import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badges;

import '../l10n/app_localizations.dart';
import '../widgets/app_bar.dart';
import '../widgets/app_drawer.dart';
import '../widgets/campo_info.dart';
import '../widgets/confirm_dialog.dart';
import '../widgets/dpi_assegnato_form_dialog.dart';
import '../widgets/info_dialog.dart';
import '../widgets/nota_dipendente_aziendale_dialog.dart';
import '../widgets/nota_dpi_assegnato_dialog.dart';
import '../widgets/responsive_card_grid.dart';
import '../widgets/ritiro_dpi_quota_dialog.dart';
import '../widgets/stato_badge.dart';
import '../widgets/voce_info.dart';

import '../models/dipendente_aziendale.dart';
import '../models/dpi_assegnato.dart';
import '../models/tipo_dpi.dart';

import '../providers/dpi_assegnati_provider.dart';
import '../providers/tipi_dpi_provider.dart';
import '../providers/regole_dpi_mansione_provider.dart';
import '../providers/dipendenti_aziendali_provider.dart';

import '../services/stato_scadenze.dart';

String _formattaData(DateTime d) =>
    '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

typedef _VoceScadenza = ({
  DpiAssegnato assegnato,
  DipendenteAziendale dipendente,
  TipoDpi tipo,
  DateTime scadenza,
  StatoScadenza stato,
});

List<_VoceScadenza> _vociScadenza(
  List<DpiAssegnato> assegnati,
  Map<String, DipendenteAziendale> dipendentiById,
  Map<String, TipoDpi> tipiById,
) {
  final voci = <_VoceScadenza>[];
  for (final a in assegnati) {
    final data = parseData(a.dataScadenza);
    if (data == null) continue;
    final tipo = tipiById[a.tipoDpi];
    final dipendente = dipendentiById[a.dipendente];
    if (tipo == null || dipendente == null) continue;
    final stato = computeStato(data, giorniPreavviso: tipo.giorniPreavviso);
    if (stato == StatoScadenza.valido) continue;
    voci.add((assegnato: a, dipendente: dipendente, tipo: tipo, scadenza: data, stato: stato));
  }
  voci.sort((a, b) => a.scadenza.compareTo(b.scadenza));
  return voci;
}

class DpiScreen extends StatefulWidget {
  const DpiScreen({super.key});

  @override
  State<DpiScreen> createState() => _DpiScreenState();
}

class _DpiScreenState extends State<DpiScreen> {
  final _searchController = TextEditingController();
  String _query = '';
  bool _loaded = false;
  final _espanse = <String>{};
  bool _scadenzeImminentiEspanse = false;
  bool _dpiEspansi = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_loaded) {
      _loaded = true;
      final tipiDpiProvider = context.read<TipiDpiProvider>();
      final dpiAssegnatiProvider = context.read<DpiAssegnatiProvider>();
      final regoleProvider = context.read<RegoleDpiMansioneProvider>();
      final dipendentiProvider = context.read<DipendentiAziendaliProvider>();
      Future.microtask(() {
        tipiDpiProvider.load();
        dpiAssegnatiProvider.load();
        regoleProvider.load();
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
    final tipiDpiProvider = context.watch<TipiDpiProvider>();
    final dpiAssegnatiProvider = context.watch<DpiAssegnatiProvider>();
    final regoleProvider = context.watch<RegoleDpiMansioneProvider>();
    final dipendentiProvider = context.watch<DipendentiAziendaliProvider>();

    final erroreCaricamento = tipiDpiProvider.errorMessage ??
        dpiAssegnatiProvider.errorMessage ??
        regoleProvider.errorMessage ??
        dipendentiProvider.errorMessage;

    final tipiDpi = tipiDpiProvider.tipiDpi;
    final regole = regoleProvider.regole;
    final dipendentiById = {for (final d in dipendentiProvider.dipendenti) d.id: d};
    final tipiById = {for (final t in tipiDpi) t.id: t};

    final query = _query.trim().toLowerCase();
    final dipendentiDpi = dipendentiProvider.dipendenti
        .where((d) => mansioniConDpi.contains(d.mansione))
        .where((d) => query.isEmpty || d.nomeCompleto.toLowerCase().contains(query))
        .toList()
      ..sort((a, b) => a.mansione.compareTo(b.mansione));

    final scadenzeImminenti =
        _vociScadenza(dpiAssegnatiProvider.dpiAssegnati, dipendentiById, tipiById);

    final isLoading = (tipiDpiProvider.isLoading && tipiDpi.isEmpty) ||
        (dipendentiProvider.isLoading && dipendentiProvider.dipendenti.isEmpty);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: l10n.dpiScreenTitle,
        actions: [
          AppBarAction(
            icon: Icons.add_outlined,
            label: l10n.dpiScreenAssegnaDpi,
            onPressed: () => showDpiAssegnatoFormDialog(
              context,
              provider: dpiAssegnatiProvider,
              dipendenti: dipendentiProvider.dipendenti,
              tipiDpi: tipiDpi,
            ),
          ),
        ],
        iconActions: [
          AppBarAction(
            icon: Icons.list_alt_outlined,
            label: l10n.dpiScreenTipiDpi,
            onPressed: () => context.push('/dpi/tipi-dpi'),
          ),
        ],
      ),
      drawer: const AppDrawer(current: 'DPI'),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async {
                await Future.wait([
                  tipiDpiProvider.load(),
                  dpiAssegnatiProvider.load(),
                  regoleProvider.load(),
                  dipendentiProvider.load(),
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
                            l10n.dpiScreenScadenzeImminenti,
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
                              ? l10n.dpiScreenNascondiScadenze
                              : l10n.dpiScreenMostraScadenze,
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
                              provider: dpiAssegnatiProvider,
                              dipendenti: dipendentiProvider.dipendenti,
                              tipiDpi: tipiDpi,
                            ),
                    ),
                    const SizedBox(height: 24),
                  ],
                  Row(
                    children: [
                      Text(
                        l10n.dpiScreenDipendentiConDpiObbligatori,
                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 22, color: primaryBlue),
                      ),
                      IconButton(
                        tooltip: _dpiEspansi ? l10n.dpiScreenNascondiTutti : l10n.dpiScreenMostraTutti,
                        icon: Icon(
                          _dpiEspansi ? Icons.unfold_less_outlined : Icons.unfold_more_outlined,
                          color: primaryBlue, size: 20,
                        ),
                        onPressed: () {
                          _dpiEspansi = !_dpiEspansi;
                          setState(() {
                            if (_dpiEspansi) {
                              _espanse.addAll(dipendentiProvider.dipendenti.map((d) => d.id));
                            }
                            else {
                              _espanse.clear();
                            }
                          });
                        },
                      )
                    ],
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: Icon(Icons.search, color: primaryBlue),
                      hintText: l10n.dpiScreenCercaPerNome,
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
                  if (dipendentiDpi.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Center(
                        child: Text(
                          dipendentiProvider.dipendenti
                                  .where((d) => mansioniConDpi.contains(d.mansione))
                                  .isEmpty
                              ? l10n.dpiScreenNessunDipendenteMansione
                              : l10n.dpiScreenNessunDipendenteTrovato(_query.trim()),
                        ),
                      ),
                    )
                  else
                    ColumnsCardGrid(
                      maxColumns: 2,
                      minWidth: 380,
                      children: dipendentiDpi.map((d) {
                        final espansa = _espanse.contains(d.id);
                        return _DipendenteDpiCard(
                          dipendente: d,
                          richiesti: dpiRichiesti(d, regole, tipiDpi),
                          assegnati: dpiAssegnatiProvider.perDipendente(d.id),
                          tipiDpi: tipiDpi,
                          dipendenti: dipendentiProvider.dipendenti,
                          provider: dpiAssegnatiProvider,
                          dipendentiProvider: dipendentiProvider,
                          espansa: espansa,
                          onToggleEspansa: () => setState(() {
                            if (espansa) {
                              _espanse.remove(d.id);
                            } else {
                              _espanse.add(d.id);
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
    required this.dipendenti,
    required this.tipiDpi,
  });

  final List<_VoceScadenza> voci;
  final DpiAssegnatiProvider provider;
  final List<DipendenteAziendale> dipendenti;
  final List<TipoDpi> tipiDpi;

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
                final titolo = '${voce.dipendente.nomeCompleto} — ${voce.tipo.nome}';
                return ListTile(
                  leading: StatoBadge(stato: voce.stato, showLabel: !isMobile),
                  title: Text(voce.tipo.nome, style: const TextStyle(fontWeight: FontWeight.w700)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      VoceInfo(l10n.dpiScreenCampoDipendente, voce.dipendente.nomeCompleto),
                      if (voce.assegnato.matricola.isNotEmpty) VoceInfo(l10n.dpiScreenCampoMatricola, voce.assegnato.matricola),
                      if (voce.dipendente.note != '') VoceInfo(l10n.commonNoteLabel, voce.dipendente.note),
                      if (voce.assegnato.notaScadenza.isNotEmpty) VoceInfo(l10n.dpiScreenNotaScadenza, voce.assegnato.notaScadenza)
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit_note_rounded, color: primaryBlue, size: isMobile ? 18 : 22),
                        tooltip: l10n.dpiScreenModificaNota,
                        onPressed: () => showNotaDpiAssegnatoDialog(
                          context,
                          provider: provider,
                          dpiAssegnato: voce.assegnato,
                          titolo: titolo,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(_formattaData(voce.scadenza)),
                    ],
                  ),
                  onTap: () => showDpiAssegnatoFormDialog(
                    context,
                    provider: provider,
                    dipendenti: dipendenti,
                    tipiDpi: tipiDpi,
                    esistente: voce.assegnato,
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

class _DipendenteDpiCard extends StatelessWidget {
  const _DipendenteDpiCard({
    required this.dipendente,
    required this.richiesti,
    required this.assegnati,
    required this.tipiDpi,
    required this.dipendenti,
    required this.provider,
    required this.dipendentiProvider,
    required this.espansa,
    required this.onToggleEspansa,
  });

  final DipendenteAziendale dipendente;
  final List<TipoDpi> richiesti;
  final List<DpiAssegnato> assegnati;
  final List<TipoDpi> tipiDpi;
  final List<DipendenteAziendale> dipendenti;
  final DpiAssegnatiProvider provider;
  final DipendentiAziendaliProvider dipendentiProvider;
  final bool espansa;
  final VoidCallback onToggleEspansa;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final primaryBlue = Theme.of(context).colorScheme.primary;
    final isMobile = MediaQuery.sizeOf(context).width < kMobileAppBarBreakpoint;
    final richiestiIds = richiesti.map((t) => t.id).toSet();
    final altri = assegnati.where((a) => !richiestiIds.contains(a.tipoDpi)).toList();
    final tipiById = {for (final t in tipiDpi) t.id: t};
    final stato = statoScadenzaDipendenteDpi(richiesti, assegnati);
    final haScadenzaReale =
        statoScadenzaDpiHaScadenzaReale(assegnati: assegnati, tipiDpi: tipiDpi);
    final colorOverride =
        stato == StatoScadenza.scaduto && !haScadenzaReale ? Colors.grey : null;
    final assegnatiCount =
        richiesti.where((t) => assegnati.any((a) => a.tipoDpi == t.id)).length;

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: StatoBadge(stato: stato, showLabel: false, colorOverride: colorOverride),
            title: Text(dipendente.nomeCompleto, style: const TextStyle(fontWeight: FontWeight.w700)),
            subtitle: richiesti.isEmpty && dipendente.mansione.isEmpty
                ? null
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      VoceInfo(l10n.dpiScreenCampoMansione, dipendente.mansione),
                      if (richiesti.isNotEmpty) VoceInfo(l10n.dpiScreenCampoAssegnati, '$assegnatiCount/${richiesti.length}'),
                      if (dipendente.note != '') VoceInfo(l10n.dpiScreenCampoNota, dipendente.note)
                    ],
                  ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.add, color: primaryBlue, size: isMobile ? 18 : 22),
                  tooltip: l10n.dpiScreenAssegnaAltroDpi,
                  onPressed: () => showDpiAssegnatoFormDialog(
                    context,
                    provider: provider,
                    dipendenti: dipendenti,
                    tipiDpi: tipiDpi,
                    dipendenteInizialeId: dipendente.id,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.edit_note_rounded, color: primaryBlue, size: isMobile ? 18 : 22),
                  tooltip: l10n.dpiScreenModificaNota,
                  onPressed: () => showNotaDipendenteAziendaleDialog(
                    context,
                    provider: dipendentiProvider,
                    dipendente: dipendente,
                  ),
                ),
                IconButton(
                  tooltip: espansa ? l10n.dpiScreenNascondiDpi : l10n.dpiScreenMostraDpi,
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
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Divider(height: 1, color: Color(0xFFE0E0E0)),
                      if (richiesti.isEmpty)
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            l10n.dpiScreenNessunaRegolaDpi,
                            style: const TextStyle(color: Colors.black54),
                          ),
                        )
                      else
                        for (final tipo in richiesti)
                          _RigaDpi(
                            tipo: tipo,
                            assegnato: assegnati.where((a) => a.tipoDpi == tipo.id).firstOrNull,
                            dipendente: dipendente,
                            dipendenti: dipendenti,
                            tipiDpi: tipiDpi,
                            provider: provider,
                          ),
                      if (altri.isNotEmpty) ...[
                        const Divider(height: 1, color: Color(0xFFE0E0E0)),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                          child: Text(
                            l10n.dpiScreenAltriDpiAssegnati,
                            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12, color: Colors.black54),
                          ),
                        ),
                        for (final a in altri)
                          if (tipiById[a.tipoDpi] != null)
                            _RigaDpi(
                              tipo: tipiById[a.tipoDpi]!,
                              assegnato: a,
                              dipendente: dipendente,
                              dipendenti: dipendenti,
                              tipiDpi: tipiDpi,
                              provider: provider,
                            ),
                      ],
                      const SizedBox(height: 8),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

class _RigaDpi extends StatelessWidget {
  const _RigaDpi({
    required this.tipo,
    required this.assegnato,
    required this.dipendente,
    required this.dipendenti,
    required this.tipiDpi,
    required this.provider,
  });

  final TipoDpi tipo;
  final DpiAssegnato? assegnato;
  final DipendenteAziendale dipendente;
  final List<DipendenteAziendale> dipendenti;
  final List<TipoDpi> tipiDpi;
  final DpiAssegnatiProvider provider;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final primaryBlue = Theme.of(context).primaryColor;
    final isMobile = MediaQuery.sizeOf(context).width < kMobileAppBarBreakpoint;
    if (assegnato == null) {
      return ListTile(
        dense: true,
        title: Text(
          tipo.nome,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 15,
            color: Colors.grey,
          ),
        ),
        subtitle: Text(l10n.dpiScreenNonAssegnato, style: TextStyle(color: primaryBlue)),
        trailing: IconButton(
          onPressed: () => showDpiAssegnatoFormDialog(
            context,
            provider: provider,
            dipendenti: dipendenti,
            tipiDpi: tipiDpi,
            dipendenteInizialeId: dipendente.id,
            tipoDpiInizialeId: tipo.id,
          ),
          icon: Icon(Icons.add_outlined, color: primaryBlue, size: isMobile ? 18 : 22),
          tooltip: l10n.dpiScreenAssegnaDpi,
        ),
      );
    }

    final a = assegnato!;
    final scadenza = parseData(a.dataScadenza);
    final stato = computeStato(scadenza, giorniPreavviso: tipo.giorniPreavviso);
    final colore = coloreStato(stato);

    return ListTile(
      dense: true,
      title: Text(
        tipo.nome,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 15,
          decoration: a.ritiratoDPIQuota ? TextDecoration.lineThrough : null,
          decorationColor: a.ritiratoDPIQuota ? coloreRitiroQuota : null,
          decorationThickness: a.ritiratoDPIQuota ? 1.5 : null,
          color: colore ?? Colors.green,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if(a.produttore.isNotEmpty) VoceInfo(l10n.dpiScreenCampoProduttore, a.produttore),
          if (a.matricola.isNotEmpty) VoceInfo(l10n.dpiScreenCampoMatricola, a.matricola),
          if (a.taglia != 0) VoceInfo(l10n.dpiScreenCampoTaglia, a.taglia.toString()),
          VoceInfo(
            l10n.dpiScreenCampoScadenza,
            scadenza!=null ? _formattaData(scadenza) : l10n.dpiScreenNonImpostata,
            stileValore: colore == null
                ? null
                : TextStyle(color: colore, fontWeight: FontWeight.w600),
          ),
          if (a.ritiratoDPIQuota) VoceInfo(l10n.dpiScreenDpiRitirato, l10n.commonYes, stileEtichetta: TextStyle(fontWeight: FontWeight.w700)),
          if (a.note != '') VoceInfo(l10n.commonNoteLabel, a.note)
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (tipo.lavoriInQuota)
            IconButton(
              icon: Icon(
                a.ritiratoDPIQuota ? Icons.unarchive_outlined : Icons.archive_outlined,
                color: a.ritiratoDPIQuota ? coloreRitiroQuota : primaryBlue,
                size: isMobile ? 18 : 22,
              ),
              tooltip: a.ritiratoDPIQuota
                  ? l10n.dpiScreenRiconsegnaDpiQuota
                  : l10n.dpiScreenRitiraDpiQuota,
              onPressed: () => showRitiroDpiQuotaDialog(
                context,
                provider: provider,
                assegnato: a,
                nomeTipo: tipo.nome,
                nomeDipendente: dipendente.nomeCompleto,
              ),
            ),
          IconButton(
            icon: Icon(Icons.edit_outlined, color: primaryBlue, size: isMobile ? 18 : 22),
            tooltip: l10n.dpiScreenModificaDpiAssegnato,
            onPressed: () => showDpiAssegnatoFormDialog(
              context,
              provider: provider,
              dipendenti: dipendenti,
              tipiDpi: tipiDpi,
              esistente: a,
            ),
          ),
          IconButton(
            icon: Icon(Icons.delete_outline, color: primaryBlue, size: isMobile ? 18 : 22),
            tooltip: l10n.dpiScreenEliminaDpiAssegnato,
            onPressed: () async {
              final confermato = await showConfirmDialog(
                context,
                title: l10n.dpiScreenEliminareDpiAssegnatoTitle,
                message: l10n.dpiScreenEliminareDpiAssegnatoMessage(
                  tipo.nome,
                  dipendente.nomeCompleto,
                ),
              );
              if (confermato) await provider.delete(a.id);
            },
          ),
        ],
      ),
    );
  }
}
