import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../widgets/app_bar.dart';
import '../widgets/app_drawer.dart';
import '../widgets/campo_info.dart';
import '../widgets/responsive_card_grid.dart';
import '../widgets/stato_badge.dart';
import '../widgets/dipendente_aziendale_form_dialog.dart';
import '../widgets/nota_dipendente_aziendale_dialog.dart';
import '../widgets/confirm_dialog.dart';
import '../widgets/info_dialog.dart';
import '../widgets/nota_scadenza_generale_dialog.dart';
import '../widgets/scadenza_generale_form_dialog.dart';
import '../widgets/voce_info.dart';

import '../models/dipendente_aziendale.dart';
import '../models/scadenza_generale.dart';

import '../providers/dipendenti_aziendali_provider.dart';
import '../providers/dpi_assegnati_provider.dart';
import '../providers/scadenze_generali_provider.dart';

import '../services/stato_scadenze.dart';

typedef _VoceScadenza = ({
  DipendenteAziendale dipendenteAziendale,
  String tipo,
  DateTime scadenza,
  StatoScadenza stato,
});

/// Una voce per ogni scadenza (non per macchinario) in scadenza o scaduta,
/// per la sezione "Scadenze imminenti" in cima alla pagina.
List<_VoceScadenza> _vociScadenza(List<DipendenteAziendale> dipendenti) {
  final voci = <_VoceScadenza>[];
  for (final d in dipendenti) {
    final tachigraficoLabel = isTitolare(d)
        ? 'Scadenza Carta Tachigrafica + Azienda'
        : 'Scadenza Carta Tachigrafica';
    final campi = {
      'Scadenza Visita Medica': d.scadenzaVisitaMedica,
      'Scadenza Formazione Sicurezza': d.scadenzaFormazioneSicurezza,
      'Scadenza Gru Autocarro': d.scadenzaGruAutocarro,
      'Scadenza Gru a Torre': d.scadenzaGruTorre,
      'Scadenza Carrello elevatore semovente':
          d.scadenzaCarrelloElevatoreSemovente,
      'Scadenza Conduzione Escavatori': d.scadenzaConduzioneEscavatori,
      'Scadenza Piattaforme elevatrici': d.scadenzaPiattaformeElevatrici,
      'Scadenza Montaggio/Smontaggio ponteggi': d.scadenzaPonteggi,
      'Scadenza Preposto': d.scadenzaPreposto,
      'Scadenza Antincendio': d.scadenzaAntincendio,
      'Scadenza Primo Soccorso': d.scadenzaPrimoSoccorso,
      'Scadenza RSPP': d.scadenzaRspp,
      'Scadenza RLST': d.scadenzaRlst,
      'Scadenza Patente': d.scadenzaPatente,
      tachigraficoLabel: d.scadenzaCartaTachigrafica,
      'Scadenza Carta Identità': d.scadenzaCartaIdentita,
      'Scadenza Firma Digitale': d.scadenzaFirmaDigitale,
      'Scadenza Codice Fiscale': d.scadenzaCodiceFiscale,
      'Scadenza Permesso di Soggiorno': d.scadenzaPermessoSoggiorno,
      'Scadenza Contratto': d.scadenzaContratto,
      'Scadenza Lavori in Quota': d.scadenzaLavoriQuota,
      'Scadenza corso Diisocianati': d.scadenzaCorsoDisocianati,
      'Scadenza corso Scaffalature': d.scadenzaScaffalature,
      'Scadenza Antitetanica': d.scadenzaAntitetanica,
      'Scadenza corso Cronotachigrafico': d.scadenzaCorsoCronotachigrafico,
    };
    for (final entry in campi.entries) {
      final data = parseData(entry.value);
      if (data == null) continue;
      final stato = computeStato(data);
      if (stato == StatoScadenza.valido) continue;
      voci.add((
        dipendenteAziendale: d,
        tipo: entry.key,
        scadenza: data,
        stato: stato,
      ));
    }
  }
  voci.sort((a, b) => a.scadenza.compareTo(b.scadenza));
  return voci;
}

/// Etichetta localizzata per un tipo di scadenza dipendente: le chiavi restano
/// in italiano (sono anche la chiave con cui le note per scadenza vengono
/// salvate su [DipendenteAziendale.noteScadenze]), qui si traduce solo il
/// testo mostrato all'utente.
String _etichettaTipoScadenza(String tipo, AppLocalizations l10n) {
  switch (tipo) {
    case 'Scadenza Visita Medica':
      return l10n.amministrazioneScreenDlMedicalCheckup;
    case 'Scadenza Formazione Sicurezza':
      return l10n.amministrazioneScreenDlSafetyTraining;
    case 'Scadenza Gru Autocarro':
      return l10n.amministrazioneScreenDlTruckCrane;
    case 'Scadenza Gru a Torre':
      return l10n.amministrazioneScreenDlTowerCrane;
    case 'Scadenza Carrello elevatore semovente':
      return l10n.amministrazioneScreenDlForklift;
    case 'Scadenza Conduzione Escavatori':
      return l10n.amministrazioneScreenDlExcavator;
    case 'Scadenza Piattaforme elevatrici':
      return l10n.amministrazioneScreenDlAerialPlatform;
    case 'Scadenza Montaggio/Smontaggio ponteggi':
      return l10n.amministrazioneScreenDlScaffolding;
    case 'Scadenza Preposto':
      return l10n.amministrazioneScreenDlSupervisor;
    case 'Scadenza Antincendio':
      return l10n.amministrazioneScreenDlFirefighting;
    case 'Scadenza Primo Soccorso':
      return l10n.amministrazioneScreenDlFirstAid;
    case 'Scadenza RSPP':
      return l10n.amministrazioneScreenDlRspp;
    case 'Scadenza RLST':
      return l10n.amministrazioneScreenDlRlst;
    case 'Scadenza Patente':
      return l10n.amministrazioneScreenDlLicense;
    case 'Scadenza Carta Tachigrafica + Azienda':
      return l10n.amministrazioneScreenDlTachographCompany;
    case 'Scadenza Carta Tachigrafica':
      return l10n.amministrazioneScreenDlTachograph;
    case 'Scadenza Carta Identità':
      return l10n.amministrazioneScreenDlIdCard;
    case 'Scadenza Firma Digitale':
      return l10n.amministrazioneScreenDlDigitalSignature;
    case 'Scadenza Codice Fiscale':
      return l10n.amministrazioneScreenDlTaxCode;
    case 'Scadenza Permesso di Soggiorno':
      return l10n.amministrazioneScreenDlResidencePermit;
    case 'Scadenza Contratto':
      return l10n.amministrazioneScreenDlContract;
    case 'Scadenza Lavori in Quota':
      return l10n.amministrazioneScreenDlHeightWork;
    case 'Scadenza corso Diisocianati':
      return l10n.amministrazioneScreenDlIsocyanates;
    case 'Scadenza corso Scaffalature':
      return l10n.amministrazioneScreenDlShelving;
    case 'Scadenza Antitetanica':
      return l10n.amministrazioneScreenDlTetanus;
    case 'Scadenza corso Cronotachigrafico':
      return l10n.amministrazioneScreenDlTachographCourse;
  }
  return tipo;
}

/// Riga di campi scadenza: [campi] è (etichetta, data grezza); i campi senza
/// data vengono omessi, il testo è colorato in base allo stato di scadenza a
/// meno che [colora] sia `false` (date senza vera scadenza, es. formazione
/// già svolta).
List<Widget> _rigaCampi(
  List<(String label, String valoreGrezzo)> campi, {
  int colonne = 3,
  bool colora = true,
}) {
  final presenti = [
    for (final campo in campi)
      if (campo.$2.isNotEmpty)
        colora
            ? campoScadenza(campo.$1, campo.$2)
            : campoInfo(campo.$1, formatData(campo.$2)),
  ];
  return [
    ...presenti,
    for (var i = presenti.length; i < colonne; i++)
      const Expanded(child: SizedBox()),
  ];
}

/// Spezza un elenco di campi scadenza (etichetta, data grezza) in più righe
/// da [colonne] colonne ciascuna, omettendo quelli senza data.
List<Widget> _righeCampi(
  List<(String label, String valoreGrezzo)> campi, {
  int colonne = 3,
  bool colora = true,
}) {
  final presenti = [
    for (final campo in campi)
      if (campo.$2.isNotEmpty) campo,
  ];
  return [
    for (var i = 0; i < presenti.length; i += colonne)
      Row(
        children: _rigaCampi(
          presenti.sublist(
            i,
            i + colonne > presenti.length ? presenti.length : i + colonne,
          ),
          colonne: colonne,
          colora: colora,
        ),
      ),
  ];
}

typedef _VoceScadenzaGenerale = ({
  ScadenzaGenerale scadenzaGenerale,
  DateTime scadenza,
  StatoScadenza stato,
});

/// Scadenze generali in scadenza o scadute, per la sezione "Scadenze
/// imminenti" in cima alla pagina.
List<_VoceScadenzaGenerale> _vociScadenzaGenerali(
  List<ScadenzaGenerale> scadenze,
) {
  final voci = <_VoceScadenzaGenerale>[];
  for (final s in scadenze) {
    final data = parseData(s.scadenza);
    if (data == null) continue;
    final stato = computeStato(data, giorniPreavviso: s.giorniPreavviso);
    if (stato == StatoScadenza.valido) continue;
    voci.add((scadenzaGenerale: s, scadenza: data, stato: stato));
  }
  voci.sort((a, b) => a.scadenza.compareTo(b.scadenza));
  return voci;
}

class AmministrazioneScreen extends StatefulWidget {
  const AmministrazioneScreen({super.key});

  @override
  State<AmministrazioneScreen> createState() => _AmministrazioneScreenState();
}

class _AmministrazioneScreenState extends State<AmministrazioneScreen> {
  final _searchDipendentiController = TextEditingController();
  final _searchScadenzeController = TextEditingController();
  String _queryDipendenti = '';
  String _queryScadenze = '';
  bool _loaded = false;
  bool _dipendentiEspansi = false;
  bool _scadenzeImminentiEspanse = false;
  final _espanse = <String>{};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_loaded) {
      final dipendentiAziendaliProvider = context
          .read<DipendentiAziendaliProvider>();
      final scadenzeGeneraliProvider = context.read<ScadenzeGeneraliProvider>();
      _loaded = true;
      Future.microtask(() {
        dipendentiAziendaliProvider.load();
        scadenzeGeneraliProvider.load();
      });
    }
  }

  @override
  void dispose() {
    _searchDipendentiController.dispose();
    _searchScadenzeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < kMobileAppBarBreakpoint;
    final primaryBlue = Theme.of(context).colorScheme.primary;
    final l10n = AppLocalizations.of(context)!;
    final dipendentiAziendaliProvider = context
        .watch<DipendentiAziendaliProvider>();
    final scadenzeGeneraliProvider = context.watch<ScadenzeGeneraliProvider>();
    final erroreCaricamento = dipendentiAziendaliProvider.errorMessage;

    final queryDipendenti = _queryDipendenti.trim().toLowerCase();
    final queryScadenze = _queryScadenze.trim().toLowerCase();
    final scadenzeFiltrate = scadenzeGeneraliProvider.scadenze
        .where(
          (s) =>
              queryScadenze.isEmpty ||
              s.nome.toLowerCase().contains(queryScadenze) ||
              s.note.toLowerCase().contains(queryScadenze),
        )
        .toList();
    final dipendentiFiltrati =
        dipendentiAziendaliProvider.dipendenti
            .where(
              (d) =>
                  queryDipendenti.isEmpty ||
                  d.nome.toLowerCase().contains(queryDipendenti) ||
                  d.cognome.toLowerCase().contains(queryDipendenti) ||
                  d.mansione.toLowerCase().contains(queryDipendenti),
            )
            .toList()
          ..sort((a, b) {
            bool isDatoreDiLavoro(DipendenteAziendale d) =>
                d.nome == 'Stefano' && d.cognome == 'Perin';
            int mansioneRank(DipendenteAziendale d) {
              final mansione = d.mansione.toUpperCase();
              if (mansione == 'RLST') return 1;
              if (mansione == 'RSPP') return 2;
              return 0;
            }

            final aBoss = isDatoreDiLavoro(a);
            final bBoss = isDatoreDiLavoro(b);
            if (aBoss != bBoss) return aBoss ? -1 : 1;
            final aRank = mansioneRank(a);
            final bRank = mansioneRank(b);
            if (aRank != bRank) return aRank.compareTo(bRank);
            return a.cognome.toLowerCase().compareTo(b.cognome.toLowerCase());
          });
    final scadenzeGeneraliFiltrateOrdinate = scadenzeFiltrate.toList()
      ..sort((a, b) {
        final dataA = parseData(a.scadenza);
        final dataB = parseData(b.scadenza);
        if (dataA == null && dataB == null) return 0;
        if (dataA == null) return 1;
        if (dataB == null) return -1;
        return dataA.compareTo(dataB);
      });
    final scadenzeImminenti = _vociScadenza(
      dipendentiAziendaliProvider.dipendenti,
    );
    final scadenzeGeneraliImminenti = _vociScadenzaGenerali(
      scadenzeGeneraliProvider.scadenze,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: l10n.amministrazioneScreenTitle),
      drawer: const AppDrawer(current: 'Amministrazione'),
      body:
          dipendentiAziendaliProvider.isLoading &&
              dipendentiAziendaliProvider.dipendenti.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async {
                await dipendentiAziendaliProvider.load();
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
                  if (scadenzeImminenti.isNotEmpty ||
                      scadenzeGeneraliImminenti.isNotEmpty) ...[
                    Row(
                      children: [
                        badges.Badge(
                          badgeContent: Text(
                            '${scadenzeImminenti.length + scadenzeGeneraliImminenti.length}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          badgeStyle: badges.BadgeStyle(
                            badgeColor: Colors.black,
                          ),
                          position: badges.BadgePosition.topEnd(
                            top: -10,
                            end: -25,
                          ),
                          child: Text(
                            l10n.amministrazioneScreenUpcomingDeadlinesTitle,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 22,
                            ),
                          ),
                        ),
                        const SizedBox(width: 25),
                        IconButton(
                          onPressed: () => showNoteScadenzaInfoDialog(context),
                          icon: Icon(
                            Icons.info_outline,
                            size: 20,
                            color: Colors.black,
                          ),
                        ),
                        IconButton(
                          tooltip: _scadenzeImminentiEspanse
                              ? l10n.amministrazioneScreenHideDeadlinesTooltip
                              : l10n.amministrazioneScreenShowDeadlinesTooltip,
                          onPressed: () => setState(
                            () => _scadenzeImminentiEspanse =
                                !_scadenzeImminentiEspanse,
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
                          : ResponsiveSplit(
                              left: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    l10n.amministrazioneScreenEmployeeDeadlinesTitle,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
                                      color: primaryBlue,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  if (scadenzeImminenti.isEmpty)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                      ),
                                      child: Text(
                                        l10n.amministrazioneScreenNoUpcomingDeadlines,
                                      ),
                                    )
                                  else
                                    _ScadenzeImminenti(
                                      voci: scadenzeImminenti,
                                      provider: dipendentiAziendaliProvider,
                                      dipendenti: dipendentiAziendaliProvider
                                          .dipendenti,
                                    ),
                                ],
                              ),
                              right: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    l10n.amministrazioneScreenGeneralDeadlinesTitle,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
                                      color: primaryBlue,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  if (scadenzeGeneraliImminenti.isEmpty)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                      ),
                                      child: Text(
                                        l10n.amministrazioneScreenNoUpcomingDeadlines,
                                      ),
                                    )
                                  else
                                    _ScadenzeGeneraliImminenti(
                                      voci: scadenzeGeneraliImminenti,
                                      provider: scadenzeGeneraliProvider,
                                    ),
                                ],
                              ),
                            ),
                    ),
                    const SizedBox(height: 24),
                  ],
                  ResponsiveSplit(
                    leftFlex: 2,
                    rightFlex: 1,
                    left: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Wrap(
                          alignment: WrapAlignment.spaceBetween,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          runSpacing: 8,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.amministrazioneScreenEmployeesTitle,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 20,
                                    color: primaryBlue,
                                  ),
                                ),
                                IconButton(
                                  tooltip: _dipendentiEspansi
                                      ? l10n.amministrazioneScreenHideAllTooltip
                                      : l10n.amministrazioneScreenShowAllTooltip,
                                  icon: Icon(
                                    _dipendentiEspansi
                                        ? Icons.unfold_less_outlined
                                        : Icons.unfold_more_outlined,
                                    color: primaryBlue,
                                    size: isMobile ? 18 : 22,
                                  ),
                                  onPressed: () {
                                    _dipendentiEspansi = !_dipendentiEspansi;
                                    setState(() {
                                      if (_dipendentiEspansi) {
                                        _espanse.addAll(
                                          dipendentiFiltrati.map((d) => d.id),
                                        );
                                      } else {
                                        _espanse.clear();
                                      }
                                    });
                                  },
                                ),
                              ],
                            ),
                            TextButton.icon(
                              onPressed: () =>
                                  showDipendenteAziendaleFormDialog(
                                    context,
                                    provider: dipendentiAziendaliProvider,
                                    dipendenti:
                                        dipendentiAziendaliProvider.dipendenti,
                                  ),
                              icon: Icon(Icons.add, color: primaryBlue),
                              label: Text(
                                l10n.commonAdd,
                                style: TextStyle(
                                  color: primaryBlue,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _searchDipendentiController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            prefixIcon: Icon(Icons.search, color: primaryBlue),
                            hintText: l10n.amministrazioneScreenSearchEmployeesHint,
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
                              borderSide: BorderSide(
                                color: primaryBlue,
                                width: 2,
                              ),
                            ),
                          ),
                          onChanged: (v) =>
                              setState(() => _queryDipendenti = v),
                        ),
                        const SizedBox(height: 20),
                        if (dipendentiFiltrati.isEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 24),
                            child: Center(
                              child: Text(
                                dipendentiAziendaliProvider.dipendenti.isEmpty
                                    ? l10n.amministrazioneScreenEmptyEmployeesLoaded
                                    : l10n.amministrazioneScreenEmptyEmployeesSearch(_queryDipendenti.trim()),
                              ),
                            ),
                          )
                        else
                          ColumnsCardGrid(
                            maxColumns: 2,
                            minWidth: 300,
                            children: dipendentiFiltrati.map((dipendente) {
                              final espansa = _espanse.contains(dipendente.id);
                              return _DipendenteCard(
                                dipendenteAziendale: dipendente,
                                provider: dipendentiAziendaliProvider,
                                espansa: espansa,
                                onToggleEspansa: () => setState(() {
                                  if (espansa) {
                                    _espanse.remove(dipendente.id);
                                  } else {
                                    _espanse.add(dipendente.id);
                                  }
                                }),
                              );
                            }).toList(),
                          ),
                      ],
                    ),
                    right: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Wrap(
                          alignment: WrapAlignment.spaceBetween,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          runSpacing: 8,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.amministrazioneScreenGeneralDeadlinesTitle,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 20,
                                    color: primaryBlue,
                                  ),
                                ),
                              ],
                            ),
                            TextButton.icon(
                              onPressed: () => showScadenzaGeneraleFormDialog(
                                context,
                                provider: scadenzeGeneraliProvider,
                                scadenze: scadenzeGeneraliProvider.scadenze,
                              ),
                              icon: Icon(Icons.add, color: primaryBlue),
                              label: Text(
                                l10n.commonAdd,
                                style: TextStyle(
                                  color: primaryBlue,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        TextField(
                          controller: _searchScadenzeController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            prefixIcon: Icon(Icons.search, color: primaryBlue),
                            hintText: l10n.amministrazioneScreenSearchDeadlinesHint,
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
                              borderSide: BorderSide(
                                color: primaryBlue,
                                width: 2,
                              ),
                            ),
                          ),
                          onChanged: (v) => setState(() => _queryScadenze = v),
                        ),
                        const SizedBox(height: 12),
                        AnimatedSize(
                          duration: const Duration(milliseconds: 400),
                          alignment: Alignment.topCenter,
                          child: scadenzeFiltrate.isEmpty
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 24,
                                  ),
                                  child: Center(
                                    child: Text(
                                      dipendentiAziendaliProvider
                                              .dipendenti
                                              .isEmpty
                                          ? l10n.amministrazioneScreenEmptyDeadlinesLoaded
                                          : l10n.amministrazioneScreenEmptyDeadlinesSearch(_queryScadenze.trim()),
                                    ),
                                  ),
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    for (final s
                                        in scadenzeGeneraliFiltrateOrdinate) ...[
                                      Builder(
                                        builder: (context) {
                                          final data = parseData(s.scadenza);
                                          final stato = computeStato(
                                            data,
                                            giorniPreavviso: s.giorniPreavviso,
                                          );
                                          final sottotitolo = Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              if (data != null)
                                              VoceInfo(l10n.amministrazioneScreenDeadlineDateLabel,
                                                '${data.day.toString().padLeft(2, '0')}/'
                                                '${data.month.toString().padLeft(2, '0')}/'
                                                '${data.year}'
                                              ),
                                              if (s.note.isNotEmpty) VoceInfo(l10n.commonNoteLabel, s.note)

                                            ],
                                          );

                                          return Card(
                                            child: ListTile(
                                              leading: StatoBadge(
                                                stato: stato,
                                                showLabel: false,
                                              ),
                                              title: Text(s.nome, style: const TextStyle(fontWeight: FontWeight.w700)),
                                              subtitle: sottotitolo,
                                              onTap: () =>
                                                  showScadenzaGeneraleFormDialog(
                                                    context,
                                                    provider:
                                                        scadenzeGeneraliProvider,
                                                    scadenze:
                                                        scadenzeGeneraliProvider
                                                            .scadenze,
                                                    esistente: s,
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
                                                    tooltip:
                                                        l10n.amministrazioneScreenEditDeadlineTooltip,
                                                    onPressed: () =>
                                                        showScadenzaGeneraleFormDialog(
                                                          context,
                                                          provider:
                                                              scadenzeGeneraliProvider,
                                                          scadenze:
                                                              scadenzeGeneraliProvider
                                                                  .scadenze,
                                                          esistente: s,
                                                        ),
                                                  ),
                                                  IconButton(
                                                    icon: Icon(
                                                      Icons.delete_outline,
                                                      color: primaryBlue,
                                                      size: isMobile ? 18 : 22,
                                                    ),
                                                    tooltip: l10n.amministrazioneScreenDeleteDeadlineTooltip,
                                                    onPressed: () async {
                                                      final confermato =
                                                          await showConfirmDialog(
                                                            context,
                                                            title:
                                                                l10n.amministrazioneScreenConfirmDeleteDeadlineTitle,
                                                            message:
                                                                l10n.amministrazioneScreenConfirmDeleteDeadlineMessage(s.nome),
                                                          );
                                                      if (confermato) {
                                                        await scadenzeGeneraliProvider
                                                            .delete(s.id);
                                                      }
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ],
                                ),
                        ),
                      ],
                    ),
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
  });

  final List<_VoceScadenza> voci;
  final DipendentiAziendaliProvider provider;
  final List<DipendenteAziendale> dipendenti;

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < kMobileAppBarBreakpoint;
    final primaryBlue = Theme.of(context).primaryColor;
    final l10n = AppLocalizations.of(context)!;
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
                    voce.dipendenteAziendale.noteScadenze[voce.tipo] ?? '';
                return ListTile(
                  leading: StatoBadge(stato: voce.stato, showLabel: !isMobile),
                  title: Text(_etichettaTipoScadenza(voce.tipo, l10n), style: const TextStyle(fontWeight: FontWeight.w700)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      VoceInfo(l10n.amministrazioneScreenEmployeeLabel, '${voce.dipendenteAziendale.nome} ${voce.dipendenteAziendale.cognome}'),
                      if (voce.dipendenteAziendale.note != '') VoceInfo(l10n.commonNoteLabel, voce.dipendenteAziendale.note),
                      if (notaScadenza.isNotEmpty) VoceInfo(l10n.amministrazioneScreenDeadlineNoteLabel, notaScadenza)
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.edit_note_rounded,
                          color: primaryBlue,
                          size: isMobile ? 18 : 22,
                        ),
                        tooltip: l10n.amministrazioneScreenEditNoteTooltip,
                        onPressed: () => showNotaDipendenteAziendaleDialog(
                          context,
                          provider: provider,
                          dipendente: voce.dipendenteAziendale,
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
                  onTap: () => showDipendenteAziendaleFormDialog(
                    context,
                    provider: provider,
                    dipendenti: dipendenti,
                    esistente: voce.dipendenteAziendale,
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

class _ScadenzeGeneraliImminenti extends StatelessWidget {
  const _ScadenzeGeneraliImminenti({
    required this.voci,
    required this.provider,
  });

  final List<_VoceScadenzaGenerale> voci;
  final ScadenzeGeneraliProvider provider;

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < kMobileAppBarBreakpoint;
    final primaryBlue = Theme.of(context).primaryColor;
    final l10n = AppLocalizations.of(context)!;
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
                  title: Text(voce.scadenzaGenerale.nome, style: const TextStyle(fontWeight: FontWeight.w700)),
                  subtitle: voce.scadenzaGenerale.notaScadenza.isEmpty
                      ? null
                      : VoceInfo(l10n.amministrazioneScreenDeadlineNoteLabel, voce.scadenzaGenerale.notaScadenza),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.edit_note_rounded,
                          color: primaryBlue,
                          size: isMobile ? 18 : 22,
                        ),
                        tooltip: l10n.amministrazioneScreenEditNoteTooltip,
                        onPressed: () => showNotaScadenzaGeneraleDialog(
                          context,
                          provider: provider,
                          scadenza: voce.scadenzaGenerale,
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

                  onTap: () => showScadenzaGeneraleFormDialog(
                    context,
                    provider: provider,
                    scadenze: provider.scadenze,
                    esistente: voce.scadenzaGenerale,
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

class _DipendenteCard extends StatelessWidget {
  const _DipendenteCard({
    required this.dipendenteAziendale,
    required this.provider,
    required this.espansa,
    required this.onToggleEspansa,
  });

  final DipendenteAziendale dipendenteAziendale;
  final DipendentiAziendaliProvider provider;
  final bool espansa;
  final VoidCallback onToggleEspansa;

  @override
  Widget build(BuildContext context) {
    final primaryBlue = Theme.of(context).colorScheme.primary;
    final isMobile = MediaQuery.sizeOf(context).width < kMobileAppBarBreakpoint;
    final l10n = AppLocalizations.of(context)!;
    final dipendentiAziendaliProvider = context
        .watch<DipendentiAziendaliProvider>();
    final dpiAssegnatiProvider = context.watch<DpiAssegnatiProvider>();
    final stato = statoScadenzaDipendenteAziendale(dipendenteAziendale);

    if (dipendenteAziendale.mansione == 'RSPP' ||
        dipendenteAziendale.mansione == 'RLST') {
      return _DipendenteEsternoCard(
        dipendenteAziendale: dipendenteAziendale,
        provider: provider,
        espansa: espansa,
        onToggleEspansa: onToggleEspansa,
      );
    } else {
      return Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: StatoBadge(stato: stato, showLabel: false),
              title: Text(
                '${dipendenteAziendale.cognome} ${dipendenteAziendale.nome}',
                style: const TextStyle(fontWeight: FontWeight.w700)
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (dipendenteAziendale.mansione != '') VoceInfo(l10n.amministrazioneScreenFieldRole, dipendenteAziendale.mansione),
                  if (dipendenteAziendale.note != '') VoceInfo(l10n.commonNoteLabel, dipendenteAziendale.note)
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
                    tooltip: l10n.amministrazioneScreenEditEmployeeTooltip,
                    onPressed: () => showDipendenteAziendaleFormDialog(
                      context,
                      provider: dipendentiAziendaliProvider,
                      dipendenti: dipendentiAziendaliProvider.dipendenti,
                      esistente: dipendenteAziendale,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.delete_outline,
                      color: primaryBlue,
                      size: isMobile ? 18 : 22,
                    ),
                    tooltip: l10n.amministrazioneScreenDeleteEmployeeTooltip,
                    onPressed: () async {
                      final confermato = await showConfirmDialog(
                        context,
                        title: l10n.amministrazioneScreenConfirmDeleteEmployeeTitle,
                        message: l10n.amministrazioneScreenConfirmDeleteEmployeeMessage(
                          '${dipendenteAziendale.nome} ${dipendenteAziendale.cognome}',
                        ),
                      );
                      if (confermato) {
                        await dpiAssegnatiProvider.deletePerDipendente(
                          dipendenteAziendale.id,
                        );
                        await dipendentiAziendaliProvider.delete(
                          dipendenteAziendale.id,
                        );
                      }
                    },
                  ),
                  IconButton(
                    tooltip: espansa
                        ? l10n.amministrazioneScreenHideDetailsTooltip
                        : l10n.amministrazioneScreenShowDetailsTooltip,
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
                            l10n.amministrazioneScreenSectionPersonalInfo,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: primaryBlue,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              campoInfo(
                                l10n.amministrazioneScreenFieldName,
                                '${dipendenteAziendale.nome} ${dipendenteAziendale.cognome}',
                              ),
                              campoInfo(
                                l10n.amministrazioneScreenFieldRole,
                                mansioni[dipendenteAziendale.mansione] ??
                                    dipendenteAziendale.mansione,
                              ),
                              if (dipendenteAziendale.dataNascita != '0')
                                campoInfo(
                                  l10n.amministrazioneScreenFieldBirthDate,
                                  formatData(dipendenteAziendale.dataNascita),
                                ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              campoInfo(
                                l10n.amministrazioneScreenFieldBirthPlace,
                                dipendenteAziendale.luogoNascita,
                              ),
                              campoInfo(
                                l10n.amministrazioneScreenFieldAge,
                                provider.calcoloEtaDipendente(
                                  dipendenteAziendale,
                                ),
                              ),
                              campoInfo(
                                l10n.amministrazioneScreenFieldTaxCode,
                                dipendenteAziendale.codiceFiscale,
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            l10n.amministrazioneScreenSectionPersonalDeadlines,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: primaryBlue,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: _rigaCampi([
                              (
                                l10n.amministrazioneScreenFieldMedicalCheckup,
                                dipendenteAziendale.scadenzaVisitaMedica,
                              ),
                              (l10n.amministrazioneScreenFieldLicense, dipendenteAziendale.scadenzaPatente),
                              (
                                l10n.amministrazioneScreenFieldIdCard,
                                dipendenteAziendale.scadenzaCartaIdentita,
                              ),
                            ]),
                          ),
                          Row(
                            children: _rigaCampi([
                              (
                                l10n.amministrazioneScreenFieldTachograph,
                                dipendenteAziendale.scadenzaCartaTachigrafica,
                              ),
                              (
                                l10n.amministrazioneScreenFieldDigitalSignature,
                                dipendenteAziendale.scadenzaFirmaDigitale,
                              ),
                              (
                                l10n.amministrazioneScreenFieldHealthCard,
                                dipendenteAziendale.scadenzaCodiceFiscale,
                              ),
                            ]),
                          ),
                          Row(
                            children: _rigaCampi([
                              (
                                l10n.amministrazioneScreenFieldResidencePermit,
                                dipendenteAziendale.scadenzaPermessoSoggiorno,
                              ),
                              (
                                l10n.amministrazioneScreenFieldTetanus,
                                dipendenteAziendale.scadenzaAntitetanica,
                              ),
                            ]),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            l10n.amministrazioneScreenSectionCoursesCompleted,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: primaryBlue,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ..._righeCampi([
                            (l10n.amministrazioneScreenFieldRspp, dipendenteAziendale.scadenzaRspp),
                            (l10n.amministrazioneScreenFieldRlst, dipendenteAziendale.scadenzaRlst),
                            (l10n.amministrazioneScreenFieldGeneralSafetyTraining, dipendenteAziendale.scadenzaFormazioneSicurezza),
                            (l10n.amministrazioneScreenFieldFirstAid, dipendenteAziendale.scadenzaPrimoSoccorso),
                            (l10n.amministrazioneScreenFieldFirefighting, dipendenteAziendale.scadenzaAntincendio),
                            (l10n.amministrazioneScreenFieldSupervisor, dipendenteAziendale.scadenzaPreposto),
                            (l10n.amministrazioneScreenFieldScaffolding, dipendenteAziendale.scadenzaPonteggi),
                            (l10n.amministrazioneScreenFieldHeightWork, dipendenteAziendale.scadenzaLavoriQuota),
                            (l10n.amministrazioneScreenFieldExcavator, dipendenteAziendale.scadenzaConduzioneEscavatori),
                            (l10n.amministrazioneScreenFieldTruckCrane, dipendenteAziendale.scadenzaGruAutocarro),
                            (l10n.amministrazioneScreenFieldTowerCrane, dipendenteAziendale.scadenzaGruTorre),
                            (l10n.amministrazioneScreenFieldAerialPlatform, dipendenteAziendale.scadenzaPiattaformeElevatrici),
                            (l10n.amministrazioneScreenFieldForklift, dipendenteAziendale.scadenzaCarrelloElevatoreSemovente),
                            (l10n.amministrazioneScreenFieldIsocyanates, dipendenteAziendale.scadenzaCorsoDisocianati),
                            (l10n.amministrazioneScreenFieldShelving, dipendenteAziendale.scadenzaScaffalature),
                            (l10n.amministrazioneScreenFieldTachographCourse, dipendenteAziendale.scadenzaCorsoCronotachigrafico),
                          ]),
                          if (
                            dipendenteAziendale.dataFormazione231 != '' ||
                            dipendenteAziendale.dataFormazioneAmbientale != '' ||
                            dipendenteAziendale.dataFormazioneRentri != ''
                          ) ... [
                            const SizedBox(height: 12),
                            Text(
                              l10n.amministrazioneScreenSectionTrainingDates,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: primaryBlue,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 8),
                            ..._righeCampi([
                              (l10n.amministrazioneScreenFieldModel231, dipendenteAziendale.dataFormazione231),
                              (l10n.amministrazioneScreenFieldRentri, dipendenteAziendale.dataFormazioneRentri),
                              (l10n.amministrazioneScreenFieldEnvironmentalManagement, dipendenteAziendale.dataFormazioneAmbientale),
                            ], colora: false),
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
}

class _DipendenteEsternoCard extends StatelessWidget {
  const _DipendenteEsternoCard({
    required this.dipendenteAziendale,
    required this.provider,
    required this.espansa,
    required this.onToggleEspansa,
  });

  final DipendenteAziendale dipendenteAziendale;
  final DipendentiAziendaliProvider provider;
  final bool espansa;
  final VoidCallback onToggleEspansa;

  @override
  Widget build(BuildContext context) {
    final primaryBlue = Theme.of(context).colorScheme.primary;
    final isMobile = MediaQuery.sizeOf(context).width < kMobileAppBarBreakpoint;
    final l10n = AppLocalizations.of(context)!;
    final dipendentiAziendaliProvider = context
        .watch<DipendentiAziendaliProvider>();
    final dpiAssegnatiProvider = context.watch<DpiAssegnatiProvider>();
    final stato = statoScadenzaDipendenteAziendale(dipendenteAziendale);

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: StatoBadge(stato: stato, showLabel: false),
            title: Text(
              '${dipendenteAziendale.cognome} ${dipendenteAziendale.nome}',
              style: const TextStyle(fontWeight: FontWeight.w700)
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (dipendenteAziendale.mansione != '') VoceInfo(l10n.amministrazioneScreenFieldRole, dipendenteAziendale.mansione),
                if (dipendenteAziendale.note != '') VoceInfo(l10n.commonNoteLabel, dipendenteAziendale.note)
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
                  tooltip: l10n.amministrazioneScreenEditEmployeeTooltip,
                  onPressed: () => showDipendenteAziendaleFormDialog(
                    context,
                    provider: dipendentiAziendaliProvider,
                    dipendenti: dipendentiAziendaliProvider.dipendenti,
                    esistente: dipendenteAziendale,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.delete_outline,
                    color: primaryBlue,
                    size: isMobile ? 18 : 22,
                  ),
                  tooltip: l10n.amministrazioneScreenDeleteEmployeeTooltip,
                  onPressed: () async {
                    final confermato = await showConfirmDialog(
                      context,
                      title: l10n.amministrazioneScreenConfirmDeleteEmployeeTitle,
                      message: l10n.amministrazioneScreenConfirmDeleteEmployeeMessage(
                        '${dipendenteAziendale.nome} ${dipendenteAziendale.cognome}',
                      ),
                    );
                    if (confermato) {
                      await dpiAssegnatiProvider.deletePerDipendente(
                        dipendenteAziendale.id,
                      );
                      await dipendentiAziendaliProvider.delete(
                        dipendenteAziendale.id,
                      );
                    }
                  },
                ),
                IconButton(
                  tooltip: espansa
                      ? l10n.amministrazioneScreenHideDetailsTooltip
                      : l10n.amministrazioneScreenShowDetailsTooltip,
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
                          l10n.amministrazioneScreenSectionPersonalInfo,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: primaryBlue,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            campoInfo(
                              l10n.amministrazioneScreenFieldName,
                              '${dipendenteAziendale.nome} ${dipendenteAziendale.cognome}',
                            ),
                            campoInfo(
                              l10n.amministrazioneScreenFieldRole,
                              mansioni[dipendenteAziendale.mansione] ??
                                  dipendenteAziendale.mansione,
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          l10n.amministrazioneScreenSectionCoursesCompleted,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: primaryBlue,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ..._righeCampi([
                          (l10n.amministrazioneScreenFieldRspp, dipendenteAziendale.scadenzaRspp),
                          (l10n.amministrazioneScreenFieldRlst, dipendenteAziendale.scadenzaRlst),
                        ]),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

