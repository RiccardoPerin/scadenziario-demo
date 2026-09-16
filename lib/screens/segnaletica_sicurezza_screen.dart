import 'package:flutter/material.dart';
import 'package:gestionale_edile/widgets/info_dialog.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../widgets/app_bar.dart';
import '../widgets/app_drawer.dart';
import '../widgets/campo_info.dart';
import '../widgets/confirm_dialog.dart';
import '../widgets/responsive_card_grid.dart';
import '../widgets/stato_badge.dart';
import '../providers/segnali_provider.dart';
import '../providers/controlli_segnali_provider.dart';
import '../models/segnale.dart';
import '../models/controllo_segnale.dart';
import '../services/pocketbase_service.dart';
import '../services/stato_scadenze.dart';
import '../widgets/controllo_segnale_form_dialog.dart';
import '../widgets/crea_segnale_form_dialog.dart';
import '../widgets/voce_info.dart';

/// Zone previste dalla collection `segnaletica`, nell'ordine in cui vanno
/// mostrate. I cartelli senza zona (campo vuoto o valore non previsto) finiscono
/// nella sezione [_zonaNonSpecificata] per non sparire dall'elenco.
const _zoneOrdinate = ['ufficio', 'magazzino'];
const _zonaNonSpecificata = '';

String _titoloZona(String zona, AppLocalizations l10n) {
  switch (zona) {
    case 'ufficio':
      return l10n.segnaleticaSicurezzaScreenZonaUfficio;
    case 'magazzino':
      return l10n.segnaleticaSicurezzaScreenZonaMagazzino;
    default:
      return l10n.segnaleticaSicurezzaScreenZonaNonSpecificata;
  }
}

String _esitiTesto(ControlloSegnale c, AppLocalizations l10n) {
  if (!c.esiste) return l10n.segnaleticaSicurezzaScreenEsitoCartelloAssente;
  return [
    l10n.segnaleticaSicurezzaScreenEsitoPresente,
    c.posizioneIdonea
        ? l10n.segnaleticaSicurezzaScreenEsitoPosizioneIdonea
        : l10n.segnaleticaSicurezzaScreenEsitoPosizioneNonIdonea,
    c.buonoStato
        ? l10n.segnaleticaSicurezzaScreenEsitoBuonoStato
        : l10n.segnaleticaSicurezzaScreenEsitoDaSostituire,
  ].join(' - ');
}

class SegnaleticaSicurezzaScreen extends StatefulWidget {
  const SegnaleticaSicurezzaScreen({super.key});

  @override
  State<SegnaleticaSicurezzaScreen> createState() =>
      _SegnaleticaSicurezzaScreenState();
}

class _SegnaleticaSicurezzaScreenState
    extends State<SegnaleticaSicurezzaScreen> {
  bool _loaded = false;
  final _espanse = <String>{};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_loaded) {
      _loaded = true;
      final segnaliProvider = context.read<SegnaliProvider>();
      final controlliProvider = context.read<ControlliSegnaliProvider>();
      Future.microtask(() {
        segnaliProvider.load();
        controlliProvider.load();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final titolo = l10n.segnaleticaSicurezzaScreenTitle;
    final primaryBlue = Theme.of(context).colorScheme.primary;
    final segnaliProvider = context.watch<SegnaliProvider>();
    final controlliProvider = context.watch<ControlliSegnaliProvider>();
    final isMobile = MediaQuery.sizeOf(context).width < kMobileAppBarBreakpoint;

    final erroreCaricamento =
        segnaliProvider.errorMessage ?? controlliProvider.errorMessage;

    // Un gruppo per zona: le zone previste sempre presenti (anche vuote, così
    // si vede che la sezione esiste), quella non specificata solo se serve.
    final perZona = <String, List<Segnale>>{
      for (final zona in _zoneOrdinate) zona: <Segnale>[],
    };
    for (final segnale in segnaliProvider.segnali) {
      final zona = _zoneOrdinate.contains(segnale.zona)
          ? segnale.zona
          : _zonaNonSpecificata;
      perZona.putIfAbsent(zona, () => <Segnale>[]).add(segnale);
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: isMobile ? l10n.segnaleticaSicurezzaScreenTitleShort : titolo,
        actions: [
          AppBarAction(
            icon: Icons.add_outlined,
            label: l10n.segnaleticaSicurezzaScreenNuovoControllo,
            onPressed: () => showControlloSegnaleFormDialog(
              context,
              provider: controlliProvider,
              segnali: segnaliProvider.segnali,
            ),
          ),
          AppBarAction(
            icon: Icons.signpost_outlined,
            label: l10n.segnaleticaSicurezzaScreenNuovoSegnale,
            onPressed: () =>
                showSegnaleFormDialog(context, provider: segnaliProvider),
          ),
        ],
      ),
      drawer: const AppDrawer(current: 'Segnaletica Sicurezza'),
      body:
          controlliProvider.isLoading &&
              controlliProvider.controlli.isEmpty &&
              segnaliProvider.isLoading &&
              segnaliProvider.segnali.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async {
                await controlliProvider.load();
                await segnaliProvider.load();
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
                  Row(
                    children: [
                      Text(
                        l10n.segnaleticaSicurezzaScreenSegnaleticaPresente,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 22,
                          color: primaryBlue,
                        ),
                      ),
                      IconButton(
                        tooltip: l10n.segnaleticaSicurezzaScreenInfoEmailScadenza,
                        onPressed: () =>
                            showEmailScadenzaInfoDialog(context, titolo),
                        icon: Icon(
                          Icons.info_outline,
                          size: 20,
                          color: primaryBlue,
                        ),
                      ),
                    ],
                  ),
                  for (final zona in perZona.keys) ...[
                    _sezioneZona(
                      zona: zona,
                      segnali: perZona[zona]!,
                      segnaliProvider: segnaliProvider,
                      controlliProvider: controlliProvider,
                      primaryBlue: primaryBlue,
                      l10n: l10n,
                    ),
                    const SizedBox(height: 24),
                  ],
                ],
              ),
            ),
    );
  }

  Widget _sezioneZona({
    required String zona,
    required List<Segnale> segnali,
    required SegnaliProvider segnaliProvider,
    required ControlliSegnaliProvider controlliProvider,
    required Color primaryBlue,
    required AppLocalizations l10n,
  }) {
    // "Espandi tutti" è derivato dalle card già aperte: nessuno stato extra da
    // tenere allineato quando si apre o chiude una singola card.
    final idsZona = segnali.map((s) => s.id).toSet();
    final tutteEspanse = idsZona.isNotEmpty && _espanse.containsAll(idsZona);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Divider(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Spacer a sinistra ed Expanded a destra hanno lo stesso flex:
            // il bottone sta in fondo alla riga e il titolo resta comunque
            // centrato rispetto alla sezione.
            const Spacer(),
            Text(
              _titoloZona(zona, l10n),
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 22,
                color: primaryBlue,
              ),
            ),
            if (segnali.isNotEmpty)
              IconButton(
                tooltip: tutteEspanse
                    ? l10n.segnaleticaSicurezzaScreenChiudiTutti
                    : l10n.segnaleticaSicurezzaScreenEspandiTutti,
                onPressed: () => setState(() {
                  if (tutteEspanse) {
                    _espanse.removeAll(idsZona);
                  } else {
                    _espanse.addAll(idsZona);
                  }
                }),
                icon: Icon(
                  tutteEspanse
                      ? Icons.unfold_less_outlined
                      : Icons.unfold_more_outlined,
                  color: primaryBlue,
                  size: 20,
                ),
              ),
            // Scorciatoia del caso normale: un solo controllo positivo su
            // tutti i cartelli della zona, con la sola data da inserire.
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: segnali.isEmpty
                      ? null
                      : () => showControlloSegnaleZonaFormDialog(
                          context,
                          provider: controlliProvider,
                          segnali: segnali,
                          titoloZona: _titoloZona(zona, l10n),
                        ),
                  label: Text(l10n.segnaleticaSicurezzaScreenControllaTutti),
                  icon: const Icon(Icons.checklist_outlined),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (segnali.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Center(
              child: Text(l10n.segnaleticaSicurezzaScreenNessunCartelloZona),
            ),
          )
        else
          ColumnsCardGrid(
            maxColumns: 2,
            minWidth: 380,
            children: segnali.map((segnale) {
              final espansa = _espanse.contains(segnale.id);
              return _SegnaleCard(
                segnale: segnale,
                segnali: segnaliProvider.segnali,
                controlli: controlliProvider.perSegnale(segnale.id),
                segnaliProvider: segnaliProvider,
                controlliProvider: controlliProvider,
                espansa: espansa,
                onToggleEspansa: () => setState(() {
                  if (espansa) {
                    _espanse.remove(segnale.id);
                  } else {
                    _espanse.add(segnale.id);
                  }
                }),
              );
            }).toList(),
          ),
      ],
    );
  }
}

class _SegnaleCard extends StatelessWidget {
  const _SegnaleCard({
    required this.segnale,
    required this.segnali,
    required this.controlli,
    required this.segnaliProvider,
    required this.controlliProvider,
    required this.espansa,
    required this.onToggleEspansa,
  });

  final Segnale segnale;
  final List<Segnale> segnali;

  /// Controlli del solo [segnale], dal più recente al più vecchio.
  final List<ControlloSegnale> controlli;
  final SegnaliProvider segnaliProvider;
  final ControlliSegnaliProvider controlliProvider;
  final bool espansa;
  final VoidCallback onToggleEspansa;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final primaryBlue = Theme.of(context).colorScheme.primary;
    final isMobile = MediaQuery.sizeOf(context).width < kMobileAppBarBreakpoint;
    final ultimo = ultimoControlloSegnale(segnale.id, controlli);

    final azioni = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(
            Icons.playlist_add_check_outlined,
            color: primaryBlue,
            size: isMobile ? 18 : 22,
          ),
          tooltip: l10n.segnaleticaSicurezzaScreenNuovoControllo,
          onPressed: () => showControlloSegnaleFormDialog(
            context,
            provider: controlliProvider,
            segnali: segnali,
            segnale: segnale,
          ),
        ),
        IconButton(
          icon: Icon(
            Icons.edit_outlined,
            color: primaryBlue,
            size: isMobile ? 18 : 22,
          ),
          tooltip: l10n.segnaleticaSicurezzaScreenModificaCartello,
          onPressed: () => showSegnaleFormDialog(
            context,
            provider: segnaliProvider,
            esistente: segnale,
          ),
        ),
        IconButton(
          icon: Icon(
            Icons.delete_outline,
            color: primaryBlue,
            size: isMobile ? 18 : 22,
          ),
          tooltip: l10n.segnaleticaSicurezzaScreenEliminaCartello,
          onPressed: () async {
            final confermato = await showConfirmDialog(
              context,
              title: l10n.segnaleticaSicurezzaScreenEliminareCartelloTitle,
              message: l10n.segnaleticaSicurezzaScreenEliminareCartelloMessage(
                segnale.nome,
              ),
            );
            if (confermato) {
              await segnaliProvider.delete(segnale.id);
              await controlliProvider.load();
            }
          },
        ),
        IconButton(
          tooltip: espansa
              ? l10n.segnaleticaSicurezzaScreenNascondiInfo
              : l10n.segnaleticaSicurezzaScreenMostraInfo,
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
    );

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 8, 4),
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Le card possono essere strette (una colonna della griglia su
                // schermi medi): sotto una certa larghezza le quattro azioni
                // non stanno sulla stessa riga di anteprima e testo senza
                // schiacciarli, quindi vanno a capo sotto l'intestazione.
                final azioniInLinea = constraints.maxWidth >= 460;

                // Lo slot dell'anteprima c'è sempre, anche senza immagine
                // caricata: è quello che dà all'intestazione la sua altezza
                // minima, così le card con poche informazioni restano alte
                // uguali e i titoli allineati. Chi ha più voci (ubicazione,
                // note) cresce invece di andare in overflow.
                final intestazione = Row(
                  children: [
                      StatoBadge(
                        stato: statoControlloSegnale(ultimo),
                        showLabel: false,
                        colorOverride: ultimo == null ? Colors.grey : null,
                      ),
                      const SizedBox(width: 12),
                      _AnteprimaCartello(segnale: segnale),
                      const SizedBox(width: 12),
                      // Expanded: titolo e sottotitolo prendono lo spazio che
                      // resta e vanno in ellissi invece di andare in overflow.
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              segnale.nome,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 17
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (segnale.ubicazione.isNotEmpty) VoceInfo(l10n.segnaleticaSicurezzaScreenCampoUbicazione, segnale.ubicazione, maxLines: 1),
                                VoceInfo(l10n.segnaleticaSicurezzaScreenUltimoControllo, ultimo == null
                                      ? l10n.segnaleticaSicurezzaScreenMaiControllato
                                      : formatData(ultimo.dataIspezione),
                                  maxLines: 1,
                                ),
                                // Nota in anteprima su una riga sola: il testo
                                // completo resta nel riquadro "Dati del
                                // cartello" che si apre con la freccia.
                                if (segnale.note.isNotEmpty)
                                  VoceInfo(l10n.commonNoteLabel, segnale.note, maxLines: 1),
                              ],
                            )
                          ],
                        ),
                      ),
                    if (azioniInLinea) azioni,
                  ],
                );

                if (azioniInLinea) return intestazione;
                return Column(
                  children: [
                    intestazione,
                    Align(alignment: Alignment.centerRight, child: azioni),
                  ],
                );
              },
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
                          l10n.segnaleticaSicurezzaScreenDatiCartello,
                          style: TextStyle(
                            color: primaryBlue,
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            campoInfo(l10n.segnaleticaSicurezzaScreenCampoZona, _titoloZona(segnale.zona, l10n)),
                            campoInfo(l10n.segnaleticaSicurezzaScreenCampoUbicazione, segnale.ubicazione),
                            campoInfo(
                              l10n.segnaleticaSicurezzaScreenControlliRegistrati,
                              '${controlli.length}',
                            ),
                          ],
                        ),
                        // Le note stanno su una riga a sé, a tutta larghezza:
                        // sono libere e affiancate agli altri campi finirebbero
                        // in una colonna troppo stretta per leggerle.
                        if (segnale.note.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Row(children: [campoInfo(l10n.commonNoteLabel, segnale.note)]),
                        ],
                        const SizedBox(height: 12),
                        Text(
                          l10n.segnaleticaSicurezzaScreenControlliHeader,
                          style: TextStyle(
                            color: primaryBlue,
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                        if (controlli.isEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Text(l10n.segnaleticaSicurezzaScreenNessunControlloRegistrato),
                          )
                        else
                          for (var i = 0; i < controlli.length; i++) ...[
                            if (i > 0)
                              const Divider(
                                height: 1,
                                color: Color(0xFFE0E0E0),
                              ),
                            _RigaControllo(
                              controllo: controlli[i],
                              segnale: segnale,
                              segnali: segnali,
                              provider: controlliProvider,
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

/// Lato del riquadro dell'anteprima: fisso per tutte le card, con o senza
/// immagine.
const double _altezzaAnteprima = 56;

/// Miniatura del cartello a lato fisso: l'immagine viene rimpicciolita dentro
/// un riquadro quadrato (`BoxFit.contain`, quindi senza tagli e con le
/// proporzioni originali) invece di occupare la larghezza intrinseca del file,
/// che è la causa degli overflow nell'intestazione della card. Al tap si apre
/// l'immagine a piena risoluzione, così la miniatura piccola non fa perdere
/// leggibilità al cartello. Senza immagine caricata resta il riquadro vuoto con
/// l'icona segnaposto, per non far cambiare altezza e allineamenti alla card.
class _AnteprimaCartello extends StatelessWidget {
  const _AnteprimaCartello({required this.segnale});

  final Segnale segnale;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final pb = PocketBaseService.instance.pb;

    if (!segnale.haCartello) {
      return _Riquadro(
        child: Icon(
          Icons.image_not_supported_outlined,
          size: 20,
          color: Colors.grey.shade400,
        ),
      );
    }

    return Tooltip(
      message: l10n.segnaleticaSicurezzaScreenIngrandisciCartello,
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
                    segnale.nome,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 400),
                    child: Image.network(
                      segnale.getImageUrl(pb),
                      fit: BoxFit.contain,
                      errorBuilder: (_, _, _) =>
                          Text(l10n.segnaleticaSicurezzaScreenImmagineNonDisponibile),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        child: _Riquadro(
          child: Image.network(
            segnale.getImageUrl(pb, thumb: '0x240'),
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

/// Riquadro quadrato di lato [_altezzaAnteprima] che contiene l'anteprima (o il
/// segnaposto): è quello che dà a tutte le card la stessa altezza.
class _Riquadro extends StatelessWidget {
  const _Riquadro({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _altezzaAnteprima,
      height: _altezzaAnteprima,
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

class _RigaControllo extends StatelessWidget {
  const _RigaControllo({
    required this.controllo,
    required this.segnale,
    required this.segnali,
    required this.provider,
  });

  final ControlloSegnale controllo;
  final Segnale segnale;
  final List<Segnale> segnali;
  final ControlliSegnaliProvider provider;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final primaryBlue = Theme.of(context).colorScheme.primary;
    final isMobile = MediaQuery.sizeOf(context).width < kMobileAppBarBreakpoint;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: StatoBadge(
        stato: statoControlloSegnale(controllo),
        showLabel: false,
      ),
      title: Text(
        formatData(controllo.dataIspezione),
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          VoceInfo(l10n.segnaleticaSicurezzaScreenEsitiLabel, _esitiTesto(controllo, l10n)),
          if (controllo.note != '') VoceInfo(l10n.segnaleticaSicurezzaScreenNoteControllo, controllo.note)
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
            tooltip: l10n.segnaleticaSicurezzaScreenModificaControllo,
            onPressed: () => showControlloSegnaleFormDialog(
              context,
              provider: provider,
              segnali: segnali,
              segnale: segnale,
              esistente: controllo,
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.delete_outline,
              color: primaryBlue,
              size: isMobile ? 18 : 22,
            ),
            tooltip: l10n.segnaleticaSicurezzaScreenEliminaControllo,
            onPressed: () async {
              final confermato = await showConfirmDialog(
                context,
                title: l10n.segnaleticaSicurezzaScreenEliminareControlloTitle,
                message: l10n.segnaleticaSicurezzaScreenEliminareControlloMessage(
                  formatData(controllo.dataIspezione),
                  segnale.nome,
                ),
              );
              if (confermato) await provider.delete(controllo.id);
            },
          ),
        ],
      ),
    );
  }
}
