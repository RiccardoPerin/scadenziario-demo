import 'package:flutter/material.dart';
import 'package:gestionale_edile/providers/scale_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../providers/articoli_cassette_ps_provider.dart';
import '../providers/automezzi_provider.dart';
import '../providers/cantieri_provider.dart';
import '../providers/cassette_ps_provider.dart';
import '../providers/dipendenti_subappaltatori_provider.dart';
import '../providers/documenti_provider.dart';
import '../providers/estintori_provider.dart';
import '../providers/impostazioni_provider.dart';
import '../providers/macchinari_provider.dart';
import '../providers/dipendenti_aziendali_provider.dart';
import '../providers/impianti_provider.dart';
import '../providers/tipi_dpi_provider.dart';
import '../providers/regole_dpi_mansione_provider.dart';
import '../providers/dpi_assegnati_provider.dart';
import '../providers/rifiuti_provider.dart';
import '../providers/misure_provider.dart';
import '../providers/controlli_segnali_provider.dart';
import '../providers/segnali_provider.dart';
import '../providers/subappaltatori_provider.dart';
import '../providers/scaffalature_provider.dart';
import '../providers/fasce_catene_provider.dart';
import '../providers/benne_provider.dart';
import '../services/stato_scadenze.dart';
import 'app_bar.dart' show kMobileAppBarBreakpoint;
import 'campo_data.dart' show formattaData;
import 'sospendi_solleciti_dialog.dart';
import 'stato_badge.dart';

typedef _VoceSecondaria = ({String label, String route, IconData icon});

/// Etichetta visualizzata per una voce del drawer (principale o secondaria):
/// [label] resta l'identificativo interno stabile usato per i confronti
/// (evidenziazione della voce corrente, chiave di [_AppDrawerState._vociSecondarie],
/// switch di [_AppDrawerState._statoPerVoce]), mentre questa funzione ne
/// fornisce solo la traduzione da mostrare nel testo.
String _etichettaVoce(AppLocalizations l10n, String label) {
  switch (label) {
    case 'Cantieri':
      return l10n.appDrawerCantieri;
    case 'Macchinari':
      return l10n.appDrawerMacchinari;
    case 'Automezzi':
      return l10n.appDrawerAutomezzi;
    case 'Estintori':
      return l10n.appDrawerEstintori;
    case 'Amministrazione':
      return l10n.appDrawerAmministrazione;
    case 'Primo Soccorso':
      return l10n.appDrawerPrimoSoccorso;
    case 'DPI':
      return l10n.appDrawerDpi;
    case 'Impianti':
      return l10n.appDrawerImpianti;
    case 'Misure':
      return l10n.appDrawerMisure;
    case 'Segnaletica Sicurezza':
      return l10n.appDrawerSegnaleticaSicurezza;
    case 'Rifiuti':
      return l10n.appDrawerRifiuti;
    case 'Scale':
      return l10n.appDrawerScale;
    case 'Fasce/Catene':
      return l10n.appDrawerFasceCatene;
    case 'Scaffalature':
      return l10n.appDrawerScaffalature;
    case 'Subappaltatori':
      return l10n.appDrawerSubappaltatori;
    case 'Archivio cantieri':
      return l10n.appDrawerArchivioCantieri;
    case 'Tipi scadenze':
      return l10n.appDrawerTipiScadenze;
    case 'Contenuto Standard':
      return l10n.appDrawerContenutoStandard;
    case 'Tipi di DPI':
      return l10n.appDrawerTipiDpi;
    default:
      return label;
  }
}

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key, required this.current});

  final String current;

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  static const _voci = [
    (label: 'Cantieri', route: '/cantieri'),
    (label: 'Macchinari', route: '/macchinari'),
    (label: 'Automezzi', route: '/automezzi'),
    (label: 'Estintori', route: '/estintori'),
    (label: 'Amministrazione', route: '/amministrazione'),
    (label: 'Primo Soccorso', route: '/primo-soccorso'),
    (label: 'DPI', route: '/dpi'),
    (label: 'Impianti', route: '/impianti'),
    (label: 'Misure', route: '/misure'),
    (label: 'Segnaletica Sicurezza', route: '/segnaletica-sicurezza'),
    (label: 'Rifiuti', route: '/rifiuti'),
    (label: 'Scale', route: '/scale'),
    (label: 'Fasce/Catene', route: '/fasce-catene'),
    (label: 'Scaffalature', route: '/scaffalature'),
  ];

  static const Map<String, List<_VoceSecondaria>> _vociSecondarie = {
    'Cantieri': [
      (label: 'Subappaltatori', route: '/subappaltatori', icon: Icons.groups_outlined),
      (label: 'Archivio cantieri', route: '/archivio-cantieri', icon: Icons.archive_outlined),
      (label: 'Tipi scadenze', route: '/tipi-scadenze', icon: Icons.description_outlined),
    ],
    'Primo Soccorso': [
      (label: 'Contenuto Standard', route: '/prodotti-standard', icon: Icons.checklist_outlined),
    ],
    'DPI': [
      (label: 'Tipi di DPI', route: '/tipi-dpi', icon: Icons.list_alt_outlined),
    ],
  };

  final Set<String> _espansi = {};

  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    // La voce corrente parte già espansa, se ha sottosezioni.
    if (_vociSecondarie.containsKey(widget.current)) {
      _espansi.add(widget.current);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_loaded) {
      _loaded = true;
      final cantieriProvider = context.read<CantieriProvider>();
      final documentiProvider = context.read<DocumentiProvider>();
      final dipendentiProvider = context.read<DipendentiSubappaltatoriProvider>();
      final subappaltatoriProvider = context.read<SubappaltatoriProvider>();
      final macchinariProvider = context.read<MacchinariProvider>();
      final automezziProvider = context.read<AutomezziProvider>();
      final estintoriProvider = context.read<EstintoriProvider>();
      final cassetteProvider = context.read<CassettePsProvider>();
      final articoliCassetteProvider = context.read<ArticoliCassettePsProvider>();
      final dipendentiAziendaliProvider = context.read<DipendentiAziendaliProvider>();
      final impiantiProvider = context.read<ImpiantiProvider>();
      final tipiDpiProvider = context.read<TipiDpiProvider>();
      final dpiAssegnatiProvider = context.read<DpiAssegnatiProvider>();
      final regoleDpiProvider = context.read<RegoleDpiMansioneProvider>();
      final rifiutiProvider = context.read<RifiutiProvider>();
      final segnaleticaProvider = context.read<SegnaliProvider>();
      final controlliSegnaleticaProvider = context.read<ControlliSegnaliProvider>();
      final impostazioniProvider = context.read<ImpostazioniProvider>();
      final scaffalatureProvider = context.read<ScaffalatureProvider>();
      final fasceCateneProvider = context.read<FasceCateneProvider>();
      final benneProvider = context.read<BenneProvider>();

      Future.microtask(() {
        cantieriProvider.load();
        documentiProvider.load();
        dipendentiProvider.load();
        subappaltatoriProvider.load();
        macchinariProvider.load();
        automezziProvider.load();
        estintoriProvider.load();
        cassetteProvider.load();
        articoliCassetteProvider.load();
        dipendentiAziendaliProvider.load();
        impiantiProvider.load();
        tipiDpiProvider.load();
        dpiAssegnatiProvider.load();
        regoleDpiProvider.load();
        rifiutiProvider.load();
        impostazioniProvider.load();
        segnaleticaProvider.load();
        controlliSegnaleticaProvider.load();
        scaffalatureProvider.load();
        fasceCateneProvider.load();
        benneProvider.load();
      });
    }
  }

  /// Stato di scadenza per ogni voce del drawer con dati propri; null per le
  /// sezioni che non hanno ancora un modello di scadenze (nessun pallino).
  StatoScadenza? _statoPerVoce(String label) {
    switch (label) {
      case 'Cantieri':
        return statoScadenzaCantieri(
          cantieri: context.watch<CantieriProvider>().cantieri,
          subappaltatori: context.watch<SubappaltatoriProvider>().subappaltatori,
          dipendenti: context.watch<DipendentiSubappaltatoriProvider>().dipendenti,
          documentiProvider: context.watch<DocumentiProvider>(),
        );
      case 'Macchinari':
        return statoScadenzaMacchinari(context.watch<MacchinariProvider>().macchinari);
      case 'Automezzi':
        return statoScadenzaAutomezzi(context.watch<AutomezziProvider>().automezzi);
      case 'Estintori':
        return statoScadenzaEstintori(context.watch<EstintoriProvider>().estintori);
      case 'Amministrazione':
        return statoScadenzaDipendentiAziendali(context.watch<DipendentiAziendaliProvider>().dipendenti);
      case 'Primo Soccorso':
        return statoScadenzaCassettePs(
          cassette: context.watch<CassettePsProvider>().cassette,
          articoli: context.watch<ArticoliCassettePsProvider>().articoli,
        );
      case 'DPI':
        return statoScadenzaDpi(
          dipendenti: context.watch<DipendentiAziendaliProvider>().dipendenti,
          assegnati: context.watch<DpiAssegnatiProvider>().dpiAssegnati,
          tipiDpi: context.watch<TipiDpiProvider>().tipiDpi,
          regole: context.watch<RegoleDpiMansioneProvider>().regole,
        );
      case 'Impianti':
        return statoScadenzaImpianti(context.watch<ImpiantiProvider>().impianti);
      case 'Misure':
        return statoScadenzaMisure(context.watch<MisureProvider>().misure);
      case 'Segnaletica Sicurezza':
        return statoScadenzaSegnaletica(
          segnali: context.watch<SegnaliProvider>().segnali,
          controlli: context.watch<ControlliSegnaliProvider>().controlli,
        );
      case 'Rifiuti':
        return statoScadenzaRifiuti(context.watch<RifiutiProvider>().rifiuti);
      case 'Scale':
        return statoScadenzaScale(context.watch<ScaleProvider>().scale);
      case 'Scaffalature':
        return statoScadenzaScaffalature(
          context.watch<ScaffalatureProvider>().scaffalature,
        );
      case 'Fasce/Catene':
        // Le benne sono elencate nella stessa pagina, quindi concorrono allo
        // stesso pallino.
        return statoPeggioreTra([
          statoScadenzaFasceCatene(context.watch<FasceCateneProvider>().fasceCatene),
          statoScadenzaBenne(context.watch<BenneProvider>().benne),
        ]);
      default:
        return null;
    }
  }

  /// Per la voce DPI, se lo stato è "scaduto" solo perché un DPI obbligatorio
  /// non è mai stato assegnato (nessuna scadenza realmente superata), il
  /// pallino usa il girgio invece del rosso.
  Color? _colorOverridePerDpi(Color primaryBlue, StatoScadenza stato) {
    if (stato != StatoScadenza.scaduto) return null;
    final haScadenzaReale = statoScadenzaDpiHaScadenzaReale(
      assegnati: context.watch<DpiAssegnatiProvider>().dpiAssegnati,
      tipiDpi: context.watch<TipiDpiProvider>().tipiDpi,
    );
    return haScadenzaReale ? null : Colors.grey;
  }

  /// Per la voce Segnaletica, "scaduto" dovuto ai soli cartelli mai controllati
  /// usa il grigio come sulle tile della pagina: rosso solo quando un controllo
  /// ha davvero dato esito negativo.
  Color? _colorOverridePerSegnaletica(StatoScadenza stato) {
    if (stato != StatoScadenza.scaduto) return null;
    final haEsitoNegativo = segnaleticaHaEsitoNegativo(
      segnali: context.watch<SegnaliProvider>().segnali,
      controlli: context.watch<ControlliSegnaliProvider>().controlli,
    );
    return haEsitoNegativo ? null : Colors.grey;
  }

  /// Chevron a sinistra della voce: per le voci con sottosezioni (solo su
  /// mobile) è cliccabile e passa da destra a giù, per le altre resta
  /// un'icona statica. Padding e constraints azzerati così il bottone occupa
  /// gli stessi 24px dell'icona semplice e tutte le voci restano allineate.
  Widget _leadingChevron(
    AppLocalizations l10n,
    String label,
    Color primaryBlue,
    bool espandibile,
  ) {
    final color = label == widget.current ? primaryBlue : null;
    if (!espandibile) {
      return Icon(Icons.chevron_right_outlined, color: color);
    }
    final espansa = _espansi.contains(label);
    return IconButton(
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      icon: Icon(
        espansa ? Icons.expand_more_outlined : Icons.chevron_right_outlined,
        color: color,
      ),
      tooltip: espansa ? l10n.appDrawerHideSubsections : l10n.appDrawerShowSubsections,
      onPressed: () => setState(() {
        if (espansa) {
          _espansi.remove(label);
        } else {
          _espansi.add(label);
        }
      }),
    );
  }

  /// Ultima voce del drawer: sospende i solleciti sulle voci già scadute
  /// durante le chiusure aziendali (i preavvisi continuano ad arrivare).
  /// Da sospesa resta ambra, così lo stato è visibile aprendo il menù.
  Widget _voceSospendiSolleciti() {
    final l10n = AppLocalizations.of(context)!;
    final impostazioni = context.watch<ImpostazioniProvider>();
    final sospesi = impostazioni.sollecitiSospesi;
    return ListTile(
      leading: Icon(
        sospesi ? Icons.notifications_off_outlined : Icons.notifications_paused_outlined,
        color: sospesi ? Colors.amber[800] : null,
      ),
      title: Text(
        sospesi ? l10n.appDrawerRemindersSuspended : l10n.appDrawerSuspendReminders,
        style: TextStyle(
          fontSize: 16,
          fontWeight: sospesi ? FontWeight.w600 : FontWeight.w500,
          color: sospesi ? Colors.amber[800] : null,
        ),
      ),
      subtitle: Text(
        sospesi
            ? l10n.appDrawerSuspendedUntil(formattaData(impostazioni.sospensioneScadutiFino))
            : l10n.appDrawerSuspendReminderSubtitle,
        style: const TextStyle(fontSize: 13),
      ),
      onTap: () => showSospendiSollecitiDialog(context, provider: impostazioni),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final primaryBlue = Theme.of(context).colorScheme.primary;
    final isMobile = MediaQuery.sizeOf(context).width < kMobileAppBarBreakpoint;
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          SizedBox(
            height: 70,
            child: DrawerHeader(
              duration: const Duration(milliseconds: 400),
              //decoration: ,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(l10n.appDrawerOtherSectionsTitle, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: primaryBlue)),
                  IconButton(
                    icon: Icon(Icons.home_outlined, color: primaryBlue,),
                    tooltip: l10n.appDrawerUpcomingDeadlinesTooltip,
                    onPressed: () => context.go('/')
                  )
                ],
              )
            ),
          ),
          for (final voce in _voci) ...[
            ListTile(
              leading: _leadingChevron(
                l10n,
                voce.label,
                primaryBlue,
                isMobile && _vociSecondarie.containsKey(voce.label),
              ),
              title: Text(
                _etichettaVoce(l10n, voce.label),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: voce.label == widget.current ? FontWeight.w600 : FontWeight.w500,
                  color: voce.label == widget.current ? primaryBlue : null,
                ),
              ),
              trailing: () {
                final stato = _statoPerVoce(voce.label);
                if (stato == null) return null;
                final colorOverride = switch (voce.label) {
                  'DPI' => _colorOverridePerDpi(primaryBlue, stato),
                  'Segnaletica Sicurezza' => _colorOverridePerSegnaletica(stato),
                  _ => null,
                };
                return StatoBadge(stato: stato, showLabel: false, colorOverride: colorOverride);
              }(),
              onTap: () {
                Navigator.of(context).pop();
                if (voce.label != widget.current) {
                  Router.neglect(context, () => context.go(voce.route));
                }
              },
            ),
            if (isMobile && _espansi.contains(voce.label))
              for (final secondaria in _vociSecondarie[voce.label]!)
                ListTile(
                  contentPadding: const EdgeInsets.only(left: 40, right: 16),
                  leading: Icon(secondaria.icon),
                  title: Text(_etichettaVoce(l10n, secondaria.label), style: const TextStyle(fontSize: 16)),
                  onTap: () {
                    Navigator.of(context).pop();
                    context.push(secondaria.route);
                  },
                ),
          ],
          const Divider(height: 24),
          _voceSospendiSolleciti(),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
