import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badges;

import '../models/automezzo.dart';
import '../models/cantiere.dart';
import '../models/cassetta_ps.dart';
import '../models/dipendente_aziendale.dart';
import '../models/dipendente_subappaltatore.dart';
import '../models/documento.dart';
import '../models/estintore.dart';
import '../models/scala.dart';
import '../models/subappaltatore.dart';

import '../providers/articoli_cassette_ps_provider.dart';
import '../providers/articoli_standard_cassette_ps_provider.dart';
import '../providers/automezzi_provider.dart';
import '../providers/cantieri_provider.dart';
import '../providers/cassette_ps_provider.dart';
import '../providers/dipendenti_aziendali_provider.dart';
import '../providers/dipendenti_subappaltatori_provider.dart';
import '../providers/documenti_provider.dart';
import '../providers/dpi_assegnati_provider.dart';
import '../providers/estintori_provider.dart';
import '../providers/impianti_provider.dart';
import '../providers/macchinari_provider.dart';
import '../providers/misure_provider.dart';
import '../providers/rifiuti_provider.dart';
import '../providers/scadenze_generali_provider.dart';
import '../providers/scaffalature_provider.dart';
import '../providers/scale_provider.dart';
import '../providers/subappaltatori_provider.dart';
import '../providers/tipi_dpi_provider.dart';

import '../services/stato_scadenze.dart';

import '../l10n/app_localizations.dart';
import '../widgets/app_bar.dart';
import '../widgets/app_drawer.dart';
import '../widgets/campo_info.dart';
import '../widgets/stato_badge.dart';
import '../widgets/voce_info.dart';

import '../widgets/automezzo_form_dialog.dart' show showAutomezzoFormDialog;
import '../widgets/cassetta_ps_form_dialog.dart' show showCassettaFormDialog;
import '../widgets/dipendente_aziendale_form_dialog.dart'
    show showDipendenteAziendaleFormDialog;
import '../widgets/dpi_assegnato_form_dialog.dart' show showDpiAssegnatoFormDialog;
import '../widgets/estintore_form_dialog.dart' show showEstintoreFormDialog;
import '../widgets/impianti_form_dialog.dart' show showImpiantoFormDialog;
import '../widgets/macchinario_form_dialog.dart' show showMacchinarioFormDialog;
import '../widgets/misure_form_dialog.dart' show showMisureFormDialog;
import '../widgets/rifiuto_form_dialog.dart' show showRifiutoFormDialog;
import '../widgets/scadenza_generale_form_dialog.dart'
    show showScadenzaGeneraleFormDialog;
import '../widgets/scaffalatura_form_dialog.dart' show showScaffalaturaFormDialog;
import '../widgets/scala_form_dialog.dart' show showScalaFormDialog;

import '../widgets/nota_automezzo_dialog.dart';
import '../widgets/nota_cantiere_dialog.dart';
import '../widgets/nota_dipendente_aziendale_dialog.dart';
import '../widgets/nota_dpi_assegnato_dialog.dart';
import '../widgets/nota_estintore_dialog.dart';
import '../widgets/nota_impianto_dialog.dart';
import '../widgets/nota_macchinario_dialog.dart';
import '../widgets/nota_misura_dialog.dart';
import '../widgets/nota_rifiuto_dialog.dart';
import '../widgets/nota_scadenza_documento_dialog.dart';
import '../widgets/nota_scadenza_generale_dialog.dart';
import '../widgets/nota_scadenza_scala_dialog.dart';
import '../widgets/nota_scaffalatura_dialog.dart';

/// Una riga della pagina: una singola scadenza (scaduta o in scadenza) di un
/// qualunque ambito, con le stesse informazioni e le stesse azioni che mostra
/// la sezione "Scadenze imminenti" della pagina di quell'ambito.
class _Voce {
  const _Voce({
    required this.stato,
    required this.data,
    required this.titolo,
    this.sottotitolo,
    this.azioneNota,
    this.onTap,
  });

  final StatoScadenza stato;
  final DateTime data;
  final String titolo;

  /// `null` quando non c'è nulla da mostrare sotto al titolo, così che la
  /// ListTile centri verticalmente il titolo invece di lasciare una riga vuota.
  final Widget? sottotitolo;

  /// Pulsante "Modifica nota", dove la scadenza ha una nota associata.
  final Widget? azioneNota;
  final VoidCallback? onTap;
}

/// Un ambito della pagina (Cantieri, Automezzi, ...) con le sue scadenze già
/// ordinate per data: è l'unità che si apre e si chiude col pulsante mostra/
/// nascondi.
typedef _Sezione = ({String titolo, String rotta, List<_Voce> voci});

String _formattaData(DateTime d) =>
    '${d.day.toString().padLeft(2, '0')}/'
    '${d.month.toString().padLeft(2, '0')}/'
    '${d.year}';

/// Ordina le voci di una sezione per data crescente: prima gli scaduti da più
/// tempo, poi le scadenze più vicine.
List<_Voce> _perData(List<_Voce> voci) =>
    [...voci]..sort((a, b) => a.data.compareTo(b.data));

Widget? _sottotitolo(List<Widget> righe) => righe.isEmpty
    ? null
    : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: righe,
      );

Widget _bottoneNota(BuildContext context, VoidCallback onPressed) {
  final l10n = AppLocalizations.of(context)!;
  final isMobile = MediaQuery.sizeOf(context).width < kMobileAppBarBreakpoint;
  return IconButton(
    icon: Icon(
      Icons.edit_note_rounded,
      color: Theme.of(context).colorScheme.primary,
      size: isMobile ? 18 : 22,
    ),
    tooltip: l10n.scadenzeImminentiScreenEditNoteTooltip,
    onPressed: onPressed,
  );
}

/// Etichetta visualizzata per un tipo di scadenza: la chiave (es. 'Scadenza
/// Assicurazione') resta l'identificativo interno stabile usato per leggere e
/// salvare la nota di quella scadenza (chiave di `noteScadenze`, passata alle
/// dialog di nota di automezzi/macchinari/estintori/impianti/rifiuti/misure/
/// dipendenti aziendali), mentre questa funzione ne fornisce solo la
/// traduzione da mostrare come titolo della voce.
String _etichettaTipoScadenza(AppLocalizations l10n, String chiave) {
  switch (chiave) {
    case 'Scadenza Assicurazione':
      return l10n.scadenzeImminentiScreenInsuranceDeadline;
    case 'Scadenza Noleggio/Leasing':
      return l10n.scadenzeImminentiScreenLeaseRentalDeadline;
    case 'Scadenza Bollo':
      return l10n.scadenzeImminentiScreenRoadTaxDeadline;
    case 'Scadenza Revisione':
      return l10n.scadenzeImminentiScreenInspectionDeadline;
    case 'Scadenza Tachigrafo':
      return l10n.scadenzeImminentiScreenTachographDeadline;
    case 'Manutenzione annuale':
      return l10n.scadenzeImminentiScreenAnnualMaintenance;
    case 'Controllo funi/catene':
      return l10n.scadenzeImminentiScreenRopesChainsCheck;
    case 'Verifica annuale':
      return l10n.scadenzeImminentiScreenAnnualCheck;
    case 'Verifica ventennale':
      return l10n.scadenzeImminentiScreenTwentyYearCheck;
    case 'Scadenza Collaudo':
      return l10n.scadenzeImminentiScreenTestingDeadline;
    case 'Scadenza Verifica Esterna':
      return l10n.scadenzeImminentiScreenExternalCheckDeadline;
    case 'Sostituzione (18 anni)':
      return l10n.scadenzeImminentiScreenReplacement18Years;
    case 'Scadenza Manutenzione Interna':
      return l10n.scadenzeImminentiScreenInternalMaintenanceDeadline;
    case 'Scadenza Manutenzione Esterna':
      return l10n.scadenzeImminentiScreenExternalMaintenanceDeadline;
    case 'Scadenza Rifiuti Non Pericolosi Trasportatore':
      return l10n.scadenzeImminentiScreenNonHazardousWasteCarrierDeadline;
    case 'Scadenza Rifiuti Pericolosi Trasportatore':
      return l10n.scadenzeImminentiScreenHazardousWasteCarrierDeadline;
    case 'Scadenza Rifiuti Non Pericolosi Smaltitore':
      return l10n.scadenzeImminentiScreenNonHazardousWasteDisposerDeadline;
    case 'Scadenza Rifiuti Pericolosi Smaltitore':
      return l10n.scadenzeImminentiScreenHazardousWasteDisposerDeadline;
    case 'Prossima taratura interna':
      return l10n.scadenzeImminentiScreenNextInternalCalibration;
    case 'Prossima taratura esterna':
      return l10n.scadenzeImminentiScreenNextExternalCalibration;
    case 'Scadenza Visita Medica':
      return l10n.scadenzeImminentiScreenMedicalExamDeadline;
    case 'Scadenza Formazione Sicurezza':
      return l10n.scadenzeImminentiScreenSafetyTrainingDeadline;
    case 'Scadenza Gru Autocarro':
      return l10n.scadenzeImminentiScreenLorryCraneDeadline;
    case 'Scadenza Gru a Torre':
      return l10n.scadenzeImminentiScreenTowerCraneDeadline;
    case 'Scadenza Carrello elevatore semovente':
      return l10n.scadenzeImminentiScreenForkliftDeadline;
    case 'Scadenza Conduzione Escavatori':
      return l10n.scadenzeImminentiScreenExcavatorOperationDeadline;
    case 'Scadenza Piattaforme elevatrici':
      return l10n.scadenzeImminentiScreenAerialPlatformsDeadline;
    case 'Scadenza Montaggio/Smontaggio ponteggi':
      return l10n.scadenzeImminentiScreenScaffoldingErectionDeadline;
    case 'Scadenza Preposto':
      return l10n.scadenzeImminentiScreenSupervisorDeadline;
    case 'Scadenza Antincendio':
      return l10n.scadenzeImminentiScreenFireSafetyDeadline;
    case 'Scadenza Primo Soccorso':
      return l10n.scadenzeImminentiScreenFirstAidDeadline;
    case 'Scadenza RSPP':
      return l10n.scadenzeImminentiScreenRsppDeadline;
    case 'Scadenza RLST':
      return l10n.scadenzeImminentiScreenRlstDeadline;
    case 'Scadenza Patente':
      return l10n.scadenzeImminentiScreenDrivingLicenseDeadline;
    case 'Scadenza Carta Tachigrafica + Azienda':
      return l10n.scadenzeImminentiScreenTachographCardCompanyDeadline;
    case 'Scadenza Carta Tachigrafica':
      return l10n.scadenzeImminentiScreenTachographCardDeadline;
    case 'Scadenza Carta Identità':
      return l10n.scadenzeImminentiScreenIdCardDeadline;
    case 'Scadenza Firma Digitale':
      return l10n.scadenzeImminentiScreenDigitalSignatureDeadline;
    case 'Scadenza Codice Fiscale':
      return l10n.scadenzeImminentiScreenTaxCodeDeadline;
    case 'Scadenza Permesso di Soggiorno':
      return l10n.scadenzeImminentiScreenResidencyPermitDeadline;
    case 'Scadenza Contratto':
      return l10n.scadenzeImminentiScreenContractDeadline;
    case 'Scadenza Lavori in Quota':
      return l10n.scadenzeImminentiScreenHeightWorkDeadline;
    case 'Scadenza corso Diisocianati':
      return l10n.scadenzeImminentiScreenDiisocyanatesCourseDeadline;
    case 'Scadenza corso Scaffalature':
      return l10n.scadenzeImminentiScreenShelvingCourseDeadline;
    case 'Scadenza Antitetanica':
      return l10n.scadenzeImminentiScreenTetanusDeadline;
    case 'Scadenza corso Cronotachigrafico':
      return l10n.scadenzeImminentiScreenTachographCourseDeadline;
    default:
      return chiave;
  }
}

//// CANTIERI ////

/// Nomi dei cantieri attivi tra quelli indicati, in ordine alfabetico: i
/// cantieri conclusi non vengono elencati.
List<String> _nomiCantieriAttivi(List<Cantiere> cantieri, List<String> ids) =>
    cantieri
        .where((c) => c.stato != 'concluso' && ids.contains(c.id))
        .map((c) => c.nome)
        .toList()
      ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));

/// Voce derivata da un documento in scadenza, con le stesse informazioni e lo
/// stesso collegamento della pagina Cantieri.
_Voce _voceDaDocumento(
  BuildContext context,
  Documento d, {
  required List<Cantiere> cantieri,
  required List<Subappaltatore> subappaltatori,
  required List<DipendenteSubappaltatore> dipendenti,
  required DocumentiProvider documentiProvider,
}) {
  final l10n = AppLocalizations.of(context)!;
  final cantiere = cantieri.where((c) => c.id == d.cantiereId).firstOrNull;
  final subappaltatore =
      subappaltatori.where((s) => s.id == d.subappaltatoreId).firstOrNull;

  Widget? sottotitolo;
  VoidCallback? onTap;
  if (d.isDocumentoDipendente) {
    final dipendente = dipendenti.where((e) => e.id == d.dipendenteId).firstOrNull;
    final subDipendente = subappaltatori
        .where((s) => s.id == dipendente?.subappaltatoreId)
        .firstOrNull;
    final cantieriDipendente = dipendente == null
        ? const <String>[]
        : _nomiCantieriAttivi(cantieri, dipendente.cantieriIds);
    sottotitolo = dipendente == null
        ? null
        : _sottotitolo([
            VoceInfo(l10n.scadenzeImminentiScreenEmployeeLabel, dipendente.nomeCompleto),
            if (subDipendente != null)
              VoceInfo(l10n.scadenzeImminentiScreenSubcontractorLabel, subDipendente.ragioneSociale),
            if (cantieriDipendente.isNotEmpty)
              VoceInfo(l10n.scadenzeImminentiScreenSitesPresentLabel, cantieriDipendente.join(', ')),
            if (d.note.isNotEmpty) VoceInfo(l10n.commonNoteLabel, d.note),
            if (d.notaScadenza.isNotEmpty) VoceInfo(l10n.scadenzeImminentiScreenDeadlineNoteLabel, d.notaScadenza),
          ]);
    if (dipendente != null && subDipendente != null) {
      onTap = () => context
          .push('/subappaltatori/${subDipendente.id}/dipendenti/${dipendente.id}');
    }
  } else {
    // I documenti generali del subappaltatore (es. DURC) non fanno capo ad
    // alcun cantiere: al posto della riga "Cantiere" si elencano i cantieri
    // attivi in cui il subappaltatore è impegnato, che sono poi il motivo per
    // cui la scadenza compare qui.
    final cantieriSubappaltatore =
        d.isDocumentoSubappaltatoreGenerale && subappaltatore != null
            ? _nomiCantieriAttivi(cantieri, subappaltatore.cantieriIds)
            : const <String>[];
    sottotitolo = _sottotitolo([
      if (cantiere != null) VoceInfo(l10n.scadenzeImminentiScreenSiteLabel, cantiere.nome),
      if (subappaltatore != null)
        VoceInfo(l10n.scadenzeImminentiScreenSubcontractorLabel, subappaltatore.ragioneSociale),
      if (cantieriSubappaltatore.isNotEmpty)
        VoceInfo(l10n.scadenzeImminentiScreenSitesPresentLabel, cantieriSubappaltatore.join(', ')),
      if (d.note.isNotEmpty) VoceInfo(l10n.commonNoteLabel, d.note),
      if (d.notaScadenza.isNotEmpty) VoceInfo(l10n.scadenzeImminentiScreenDeadlineNoteLabel, d.notaScadenza),
    ]);
    if (cantiere != null) {
      onTap = () => context.push('/cantieri/${cantiere.id}');
    } else if (subappaltatore != null) {
      onTap = () => context.push('/subappaltatori/${subappaltatore.id}');
    }
  }

  return _Voce(
    stato: computeStato(d.dataScadenza, giorniPreavviso: d.giorniPreavviso),
    data: d.dataScadenza!,
    titolo: d.tipoDocumentoNome ?? l10n.scadenzeImminentiScreenDocumentFallback,
    sottotitolo: sottotitolo,
    azioneNota: _bottoneNota(
      context,
      () => showNotaScadenzaDocumentoDialog(
        context,
        documentiProvider: documentiProvider,
        documento: d,
      ),
    ),
    onTap: onTap,
  );
}

/// Documenti dei cantieri attivi più le scadenze generali dei cantieri stessi
/// (messa a terra e scadenze generiche), come nella pagina Cantieri.
List<_Voce> _vociCantieri(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  final cantieriProvider = context.watch<CantieriProvider>();
  final subappaltatoriProvider = context.watch<SubappaltatoriProvider>();
  final dipendentiProvider = context.watch<DipendentiSubappaltatoriProvider>();
  final documentiProvider = context.watch<DocumentiProvider>();

  final cantieriAttivi =
      cantieriProvider.cantieri.where((c) => c.stato != 'concluso').toList();

  final documenti = documentiScadenzeCantieri(
    cantieri: cantieriProvider.cantieri,
    subappaltatori: subappaltatoriProvider.subappaltatori,
    dipendenti: dipendentiProvider.dipendenti,
    documentiProvider: documentiProvider,
  ).where((d) =>
      computeStato(d.dataScadenza, giorniPreavviso: d.giorniPreavviso) !=
      StatoScadenza.valido);

  return _perData([
    for (final d in documenti)
      _voceDaDocumento(
        context,
        d,
        cantieri: cantieriProvider.cantieri,
        subappaltatori: subappaltatoriProvider.subappaltatori,
        dipendenti: dipendentiProvider.dipendenti,
        documentiProvider: documentiProvider,
      ),
    for (final c in cantieriAttivi)
      for (final s in scadenzeGeneraliCantiere(c))
        if (computeStato(s.data) != StatoScadenza.valido)
          _Voce(
            stato: computeStato(s.data),
            data: s.data,
            titolo: s.etichetta,
            sottotitolo: _sottotitolo([
              VoceInfo(l10n.scadenzeImminentiScreenSiteLabel, c.nome),
              if ((c.noteScadenze[s.campo] ?? '').isNotEmpty)
                VoceInfo(l10n.scadenzeImminentiScreenDeadlineNoteLabel, c.noteScadenze[s.campo]!),
            ]),
            azioneNota: _bottoneNota(
              context,
              () => showNotaCantiereDialog(
                context,
                titolo: l10n.scadenzeImminentiScreenNoteTitleSiteDeadline(c.nome, s.etichetta),
                valoreIniziale: c.noteScadenze[s.campo] ?? '',
                onSalva: (v) =>
                    context.read<CantieriProvider>().updateNotaScadenza(c, s.campo, v),
              ),
            ),
            onTap: () => context.push('/cantieri/${c.id}'),
          ),
  ]);
}

//// AUTOMEZZI ////

List<_Voce> _vociAutomezzi(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  final provider = context.watch<AutomezziProvider>();
  final voci = <_Voce>[];
  for (final a in provider.automezzi) {
    final campi = {
      'Scadenza Assicurazione': a.scadenzaAssicurazione,
      'Scadenza Noleggio/Leasing': a.scadenzaNoleggioLeasing,
      'Scadenza Bollo': a.scadenzaBollo,
      'Scadenza Revisione': a.scadenzaRevisione,
      'Scadenza Tachigrafo': a.scadenzaControlloTachigrafo,
    };
    for (final entry in campi.entries) {
      final data = parseData(entry.value);
      if (data == null) continue;
      final stato = computeStato(data);
      if (stato == StatoScadenza.valido) continue;
      final nota = a.noteScadenze[entry.key] ?? '';
      voci.add(_Voce(
        stato: stato,
        data: data,
        titolo: _etichettaTipoScadenza(l10n, entry.key),
        sottotitolo: _sottotitolo([
          VoceInfo(l10n.scadenzeImminentiScreenVehicleLabel, a.nome),
          VoceInfo(l10n.scadenzeImminentiScreenPlateLabel, a.targa),
          if (nota.isNotEmpty) VoceInfo(l10n.scadenzeImminentiScreenDeadlineNoteLabel, nota),
        ]),
        azioneNota: _bottoneNota(
          context,
          () => showNotaAutomezzoDialog(
            context,
            provider: provider,
            automezzo: a,
            tipo: entry.key,
          ),
        ),
        onTap: () => showAutomezzoFormDialog(
          context,
          provider: provider,
          automezzi: provider.automezzi,
          esistente: a,
        ),
      ));
    }
  }
  return _perData(voci);
}

//// MACCHINARI ////

List<_Voce> _vociMacchinari(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  final provider = context.watch<MacchinariProvider>();
  final cantieri = context.watch<CantieriProvider>().cantieri;
  final automezzi = context.watch<AutomezziProvider>().automezzi;
  final voci = <_Voce>[];
  for (final m in provider.macchinari) {
    final campi = {
      'Manutenzione annuale': m.scadenzaManutenzioneInterna,
      'Controllo funi/catene': m.scadenzaControlloFuniCatene,
      'Verifica annuale': m.scadenzaVerificaAnnuale,
      'Verifica ventennale': m.scadenzaVerificaVentennale,
      'Scadenza Assicurazione': m.scadenzaAssicurazione,
    };
    for (final entry in campi.entries) {
      final data = parseData(entry.value);
      if (data == null) continue;
      final stato = computeStato(data);
      if (stato == StatoScadenza.valido) continue;
      final nota = m.noteScadenze[entry.key] ?? '';
      voci.add(_Voce(
        stato: stato,
        data: data,
        titolo: _etichettaTipoScadenza(l10n, entry.key),
        sottotitolo: _sottotitolo([
          VoceInfo(l10n.scadenzeImminentiScreenModelLabel, m.modello),
          if (m.note != '') VoceInfo(l10n.commonNoteLabel, m.note),
          if (nota.isNotEmpty) VoceInfo(l10n.scadenzeImminentiScreenDeadlineNoteLabel, nota),
        ]),
        azioneNota: _bottoneNota(
          context,
          () => showNotaMacchinarioDialog(
            context,
            provider: provider,
            macchinario: m,
            tipo: entry.key,
          ),
        ),
        onTap: () => showMacchinarioFormDialog(
          context,
          provider: provider,
          cantieri: cantieri,
          automezzi: automezzi,
          esistente: m,
        ),
      ));
    }
  }
  return _perData(voci);
}

//// ESTINTORI ////

String _ubicazioneEstintore(
  AppLocalizations l10n,
  Estintore e,
  List<Cantiere> cantieri,
  List<Automezzo> automezzi,
) {
  final dettaglio = e.dettaglioUbicazione;
  String conDettaglio(String base) =>
      dettaglio.isEmpty ? base : '$base ($dettaglio)';

  final descrizioni = <String>[];
  if (e.inMagazzino) descrizioni.add(conDettaglio(l10n.scadenzeImminentiScreenLocationWarehouse));
  if (e.inUfficio) descrizioni.add(conDettaglio(l10n.scadenzeImminentiScreenLocationOffice));
  if (e.ubicazioneCantiereId.isNotEmpty) {
    final nome = cantieri
            .where((c) => c.id == e.ubicazioneCantiereId)
            .map((c) => c.nome)
            .firstOrNull ??
        e.ubicazioneCantiereId;
    descrizioni.add(conDettaglio(l10n.scadenzeImminentiScreenLocationSite(nome)));
  }
  if (e.ubicazioneAutomezzoId.isNotEmpty) {
    final automezzo =
        automezzi.where((a) => a.id == e.ubicazioneAutomezzoId).firstOrNull;
    final testo = automezzo == null
        ? e.ubicazioneAutomezzoId
        : (automezzo.nome.isNotEmpty
            ? '${automezzo.nome} (${automezzo.targa})'
            : automezzo.targa);
    descrizioni.add(conDettaglio(l10n.scadenzeImminentiScreenLocationVehicle(testo)));
  }
  if (descrizioni.isEmpty && dettaglio.isNotEmpty) descrizioni.add(dettaglio);
  return descrizioni.isEmpty ? l10n.scadenzeImminentiScreenLocationNotSpecified : descrizioni.join(', ');
}

List<_Voce> _vociEstintori(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  final provider = context.watch<EstintoriProvider>();
  final cantieri = context.watch<CantieriProvider>().cantieri;
  final automezzi = context.watch<AutomezziProvider>().automezzi;

  final voci = <_Voce>[];
  for (final e in provider.estintori) {
    final campi = {
      'Scadenza Collaudo': parseData(e.scadenzaCollaudo),
      'Scadenza Revisione': parseData(e.scadenzaRevisione),
      'Scadenza Verifica Esterna': parseData(e.scadenzaVerificaEsterna),
      // Oltre i 18 anni dalla produzione l'estintore va sostituito, a
      // prescindere dalle normali scadenze di revisione e collaudo.
      'Sostituzione (18 anni)': scadenzaSostituzioneEstintore(e),
    };
    for (final entry in campi.entries) {
      final data = entry.value;
      if (data == null) continue;
      final stato = computeStato(data);
      if (stato == StatoScadenza.valido) continue;
      final nota = e.noteScadenze[entry.key] ?? '';
      voci.add(_Voce(
        stato: stato,
        data: data,
        titolo: _etichettaTipoScadenza(l10n, entry.key),
        sottotitolo: _sottotitolo([
          VoceInfo(l10n.scadenzeImminentiScreenSerialNumberLabel, e.numeroMatricola),
          VoceInfo(l10n.scadenzeImminentiScreenLocationLabel, _ubicazioneEstintore(l10n, e, cantieri, automezzi)),
          if (e.note != '') VoceInfo(l10n.commonNoteLabel, e.note),
          if (nota.isNotEmpty) VoceInfo(l10n.scadenzeImminentiScreenDeadlineNoteLabel, nota),
        ]),
        azioneNota: _bottoneNota(
          context,
          () => showNotaEstintoreDialog(
            context,
            provider: provider,
            estintore: e,
            tipo: entry.key,
          ),
        ),
        onTap: () => showEstintoreFormDialog(
          context,
          provider: provider,
          estintori: provider.estintori,
          cantieri: cantieri,
          automezzi: automezzi,
          esistente: e,
        ),
      ));
    }
  }
  return _perData(voci);
}

//// PRIMO SOCCORSO ////

String _ubicazioneCassetta(
  AppLocalizations l10n,
  CassettaPs c,
  List<Cantiere> cantieri,
  List<Automezzo> automezzi,
) {
  final dettaglio = c.dettaglioUbicazione;
  String conDettaglio(String base) =>
      dettaglio.isEmpty ? base : '$base ($dettaglio)';

  final descrizioni = <String>[];
  if (c.inMagazzino) descrizioni.add(conDettaglio(l10n.scadenzeImminentiScreenLocationWarehouse));
  if (c.inUfficio) descrizioni.add(conDettaglio(l10n.scadenzeImminentiScreenLocationOffice));
  if (c.ubicazioneCantiereId.isNotEmpty) {
    final nome = cantieri
            .where((cant) => cant.id == c.ubicazioneCantiereId)
            .map((cant) => cant.nome)
            .firstOrNull ??
        c.ubicazioneCantiereId;
    descrizioni.add(conDettaglio(l10n.scadenzeImminentiScreenLocationSite(nome)));
  }
  if (c.ubicazioneAutomezzoId.isNotEmpty) {
    final automezzo =
        automezzi.where((a) => a.id == c.ubicazioneAutomezzoId).firstOrNull;
    final nome = automezzo == null
        ? c.ubicazioneAutomezzoId
        : (automezzo.nome.isNotEmpty ? automezzo.nome : automezzo.targa);
    descrizioni.add(conDettaglio(l10n.scadenzeImminentiScreenLocationVehicle(nome)));
  }
  if (descrizioni.isEmpty && dettaglio.isNotEmpty) descrizioni.add(dettaglio);
  return descrizioni.isEmpty ? l10n.scadenzeImminentiScreenLocationNotSpecified : descrizioni.join(', ');
}

/// Controllo periodico delle cassette più la scadenza dei singoli articoli
/// contenuti, come nella pagina Primo Soccorso.
List<_Voce> _vociPrimoSoccorso(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  final provider = context.watch<CassettePsProvider>();
  final articoliProvider = context.watch<ArticoliCassettePsProvider>();
  final articoliStandardProvider =
      context.watch<ArticoliStandardCassettePsProvider>();
  final cantieri = context.watch<CantieriProvider>().cantieri;
  final automezzi = context.watch<AutomezziProvider>().automezzi;

  final voci = <_Voce>[];
  for (final c in provider.cassette) {
    final titolo = '${c.tipologia} #${c.numero}';
    final ubicazione = _ubicazioneCassetta(l10n, c, cantieri, automezzi);

    void aggiungi({
      required String tipo,
      required DateTime data,
      required StatoScadenza stato,
      required String nota,
      required Future<void> Function(String) onSalvaNota,
    }) {
      voci.add(_Voce(
        stato: stato,
        data: data,
        titolo: tipo,
        sottotitolo: _sottotitolo([
          VoceInfo(l10n.scadenzeImminentiScreenArticleLabel, titolo),
          VoceInfo(l10n.scadenzeImminentiScreenLocationLabel, ubicazione),
          if (c.note != '') VoceInfo(l10n.commonNoteLabel, c.note),
          if (nota.isNotEmpty) VoceInfo(l10n.scadenzeImminentiScreenDeadlineNoteLabel, nota),
        ]),
        azioneNota: _bottoneNota(
          context,
          // Il dialog delle note dei cantieri è generico (nota su una riga):
          // qui serve per la nota di scadenza della cassetta o dell'articolo.
          () => showNotaCantiereDialog(
            context,
            titolo: l10n.scadenzeImminentiScreenNoteTitleGeneric(titolo),
            valoreIniziale: nota,
            onSalva: onSalvaNota,
          ),
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
          esistente: c,
        ),
      ));
    }

    final controllo = parseData(c.prossimoControllo);
    if (controllo != null && computeStato(controllo) != StatoScadenza.valido) {
      aggiungi(
        tipo: l10n.scadenzeImminentiScreenNextCheckLabel,
        data: controllo,
        stato: computeStato(controllo),
        nota: c.notaScadenza,
        onSalvaNota: (nota) => provider.updateNotaScadenza(c.id, nota),
      );
    }
    for (final a in articoliProvider.articoli.where((a) => a.cassettaId == c.id)) {
      final data = parseData(a.scadenza);
      if (data == null) continue;
      final stato = computeStato(data);
      if (stato == StatoScadenza.valido) continue;
      aggiungi(
        tipo: l10n.scadenzeImminentiScreenProductDeadline(a.nomeProdotto),
        data: data,
        stato: stato,
        nota: a.notaScadenza,
        onSalvaNota: (nota) => articoliProvider.updateNotaScadenza(a.id, nota),
      );
    }
  }
  return _perData(voci);
}

//// DPI ////

List<_Voce> _vociDpi(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  final provider = context.watch<DpiAssegnatiProvider>();
  final tipiDpi = context.watch<TipiDpiProvider>().tipiDpi;
  final dipendenti = context.watch<DipendentiAziendaliProvider>().dipendenti;
  final tipiById = {for (final t in tipiDpi) t.id: t};
  final dipendentiById = {for (final d in dipendenti) d.id: d};

  final voci = <_Voce>[];
  for (final a in provider.dpiAssegnati) {
    final data = parseData(a.dataScadenza);
    if (data == null) continue;
    final tipo = tipiById[a.tipoDpi];
    final dipendente = dipendentiById[a.dipendente];
    if (tipo == null || dipendente == null) continue;
    final stato = computeStato(data, giorniPreavviso: tipo.giorniPreavviso);
    if (stato == StatoScadenza.valido) continue;
    voci.add(_Voce(
      stato: stato,
      data: data,
      titolo: tipo.nome,
      sottotitolo: _sottotitolo([
        VoceInfo(l10n.scadenzeImminentiScreenEmployeeLabel, dipendente.nomeCompleto),
        if (a.matricola.isNotEmpty) VoceInfo(l10n.scadenzeImminentiScreenSerialNumberLabel, a.matricola),
        if (dipendente.note != '') VoceInfo(l10n.commonNoteLabel, dipendente.note),
        if (a.notaScadenza.isNotEmpty) VoceInfo(l10n.scadenzeImminentiScreenDeadlineNoteLabel, a.notaScadenza),
      ]),
      azioneNota: _bottoneNota(
        context,
        () => showNotaDpiAssegnatoDialog(
          context,
          provider: provider,
          dpiAssegnato: a,
          titolo: '${dipendente.nomeCompleto} — ${tipo.nome}',
        ),
      ),
      onTap: () => showDpiAssegnatoFormDialog(
        context,
        provider: provider,
        dipendenti: dipendenti,
        tipiDpi: tipiDpi,
        esistente: a,
      ),
    ));
  }
  return _perData(voci);
}

//// IMPIANTI ////

List<_Voce> _vociImpianti(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  final provider = context.watch<ImpiantiProvider>();
  final voci = <_Voce>[];
  for (final i in provider.impianti) {
    final campi = {
      'Scadenza Manutenzione Interna': i.scadenzaManutenzioneInterna,
      'Scadenza Manutenzione Esterna': i.scadenzaManutenzioneEsterna,
    };
    for (final entry in campi.entries) {
      final data = parseData(entry.value);
      if (data == null) continue;
      final stato = computeStato(data);
      if (stato == StatoScadenza.valido) continue;
      final nota = i.noteScadenze[entry.key] ?? '';
      final ubicazione = i.inUfficio
          ? l10n.scadenzeImminentiScreenLocationInOfficeLower
          : i.inMagazzino
              ? l10n.scadenzeImminentiScreenLocationInWarehouseLower
              : l10n.scadenzeImminentiScreenLocationNotSpecifiedLower;
      voci.add(_Voce(
        stato: stato,
        data: data,
        titolo: _etichettaTipoScadenza(l10n, entry.key),
        sottotitolo: _sottotitolo([
          VoceInfo(l10n.scadenzeImminentiScreenTypeLabel, i.tipologia),
          VoceInfo(l10n.scadenzeImminentiScreenLocationLabel, ubicazione),
          if (i.note != '') VoceInfo(l10n.commonNoteLabel, i.note),
          if (nota.isNotEmpty) VoceInfo(l10n.scadenzeImminentiScreenDeadlineNoteLabel, nota),
        ]),
        azioneNota: _bottoneNota(
          context,
          () => showNotaImpiantoDialog(
            context,
            provider: provider,
            impianto: i,
            tipo: entry.key,
          ),
        ),
        onTap: () => showImpiantoFormDialog(
          context,
          provider: provider,
          impianti: provider.impianti,
          esistente: i,
        ),
      ));
    }
  }
  return _perData(voci);
}

//// RIFIUTI ////

List<_Voce> _vociRifiuti(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  final provider = context.watch<RifiutiProvider>();
  final voci = <_Voce>[];
  for (final r in provider.rifiuti) {
    final campi = {
      'Scadenza Rifiuti Non Pericolosi Trasportatore':
          r.scadRifiutiNonPericolosiTrasportatore,
      'Scadenza Rifiuti Pericolosi Trasportatore':
          r.scadRifiutiPericolosiTrasportatore,
      'Scadenza Rifiuti Non Pericolosi Smaltitore':
          r.scadRifiutiNonPericolosiSmaltitore,
      'Scadenza Rifiuti Pericolosi Smaltitore': r.scadRifiutiPericolosiSmaltitore,
    };
    for (final entry in campi.entries) {
      final data = parseData(entry.value);
      if (data == null) continue;
      final stato = computeStato(data);
      if (stato == StatoScadenza.valido) continue;
      final nota = r.noteScadenze[entry.key] ?? '';
      voci.add(_Voce(
        stato: stato,
        data: data,
        titolo: _etichettaTipoScadenza(l10n, entry.key),
        sottotitolo: _sottotitolo([
          VoceInfo(l10n.scadenzeImminentiScreenCompanyLabel, r.nomeDitta),
          if (nota.isNotEmpty) VoceInfo(l10n.scadenzeImminentiScreenDeadlineNoteLabel, nota),
        ]),
        azioneNota: _bottoneNota(
          context,
          () => showNotaRifiutoDialog(
            context,
            provider: provider,
            rifiuto: r,
            tipo: entry.key,
          ),
        ),
        onTap: () => showRifiutoFormDialog(
          context,
          provider: provider,
          rifiuti: provider.rifiuti,
          esistente: r,
        ),
      ));
    }
  }
  return _perData(voci);
}

//// MISURE ////

String _nomeIncaricato(String valore, List<DipendenteAziendale> dipendenti) {
  if (valore.isEmpty) return valore;
  for (final dipendente in dipendenti) {
    if (dipendente.id == valore) return dipendente.nomeCompleto;
  }
  return valore;
}

List<_Voce> _vociMisure(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  final provider = context.watch<MisureProvider>();
  final dipendentiProvider = context.watch<DipendentiAziendaliProvider>();
  final voci = <_Voce>[];
  for (final m in provider.misure) {
    final campi = {
      'Prossima taratura interna': m.dataProssimaTaraturaInterna,
      'Prossima taratura esterna': m.dataProssimaTaraturaEsterna,
    };
    for (final entry in campi.entries) {
      final data = parseData(entry.value);
      if (data == null) continue;
      final stato = computeStato(data);
      if (stato == StatoScadenza.valido) continue;
      final nota = m.noteScadenze[entry.key] ?? '';
      final interna = entry.key == 'Prossima taratura interna';
      voci.add(_Voce(
        stato: stato,
        data: data,
        titolo: _etichettaTipoScadenza(l10n, entry.key),
        sottotitolo: _sottotitolo([
          VoceInfo(l10n.scadenzeImminentiScreenModelLabel, m.nome),
          VoceInfo(
            l10n.scadenzeImminentiScreenAssigneeLabel,
            interna
                ? _nomeIncaricato(
                    m.incaricatoTaraturaInterna, dipendentiProvider.dipendenti)
                : m.incaricatoTaraturaEsterna,
          ),
          if (m.note != '') VoceInfo(l10n.commonNoteLabel, m.note),
          if (nota.isNotEmpty) VoceInfo(l10n.scadenzeImminentiScreenDeadlineNoteLabel, nota),
        ]),
        azioneNota: _bottoneNota(
          context,
          () => showNotaMisuraDialog(
            context,
            provider: provider,
            misura: m,
            tipo: entry.key,
          ),
        ),
        onTap: () => showMisureFormDialog(
          context,
          provider: provider,
          dipProvider: dipendentiProvider,
          misure: provider.misure,
          esistente: m,
        ),
      ));
    }
  }
  return _perData(voci);
}

//// SCALE ////

String _ubicazioneScala(AppLocalizations l10n, Scala s, List<Cantiere> cantieri) {
  final descrizioni = <String>[];
  if (s.inMagazzino) descrizioni.add(l10n.scadenzeImminentiScreenLocationWarehouse);
  if (s.ubicazioneCantiereId.isNotEmpty) {
    final nome = cantieri
            .where((c) => c.id == s.ubicazioneCantiereId)
            .map((c) => c.nome)
            .firstOrNull ??
        s.ubicazioneCantiereId;
    descrizioni.add(l10n.scadenzeImminentiScreenLocationSite(nome));
  }
  return descrizioni.isEmpty ? l10n.scadenzeImminentiScreenLocationNotSpecified : descrizioni.join(', ');
}

List<_Voce> _vociScale(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  final provider = context.watch<ScaleProvider>();
  final cantieri = context.watch<CantieriProvider>().cantieri;
  final voci = <_Voce>[];
  for (final s in provider.scale) {
    final data = parseData(s.prossimaVerifica);
    if (data == null) continue;
    final stato = computeStato(data);
    if (stato == StatoScadenza.valido) continue;
    voci.add(_Voce(
      stato: stato,
      data: data,
      titolo: l10n.scadenzeImminentiScreenNextVerificationLabel,
      sottotitolo: _sottotitolo([
        VoceInfo(l10n.scadenzeImminentiScreenLadderCodeLabel, s.codice),
        VoceInfo(l10n.scadenzeImminentiScreenLocationLabel, _ubicazioneScala(l10n, s, cantieri)),
        if (s.notaScadenza.isNotEmpty) VoceInfo(l10n.scadenzeImminentiScreenDeadlineNoteLabel, s.notaScadenza),
      ]),
      azioneNota: _bottoneNota(
        context,
        () => showNotaScalaDialog(context, provider: provider, scala: s),
      ),
      onTap: () => showScalaFormDialog(
        context,
        provider: provider,
        scale: provider.scale,
        cantieri: cantieri,
        esistente: s,
      ),
    ));
  }
  return _perData(voci);
}

//// SCAFFALATURE ////

List<_Voce> _vociScaffalature(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  final provider = context.watch<ScaffalatureProvider>();
  final tipo = l10n.scadenzeImminentiScreenShelvingNextCheckLabel;
  final voci = <_Voce>[];
  for (final s in provider.scaffalature) {
    final data = parseData(s.dataProssimaVerifica);
    if (data == null) continue;
    final stato = computeStato(data);
    if (stato == StatoScadenza.valido) continue;
    voci.add(_Voce(
      stato: stato,
      data: data,
      titolo: tipo,
      sottotitolo: _sottotitolo([
        VoceInfo(l10n.scadenzeImminentiScreenShelvingIdLabel, s.idInterno),
        VoceInfo(l10n.scadenzeImminentiScreenLastCheckLabel, formatData(s.dataVerifica)),
        if (s.note != '') VoceInfo(l10n.commonNoteLabel, s.note),
        if (s.notaScadenza.isNotEmpty) VoceInfo(l10n.scadenzeImminentiScreenDeadlineNoteLabel, s.notaScadenza),
      ]),
      azioneNota: _bottoneNota(
        context,
        () => showNotaScaffalaturaDialog(
          context,
          provider: provider,
          scaffalatura: s,
          tipo: tipo,
        ),
      ),
      onTap: () => showScaffalaturaFormDialog(
        context,
        provider: provider,
        scaffalature: provider.scaffalature,
        esistente: s,
      ),
    ));
  }
  return _perData(voci);
}

//// DIPENDENTI AZIENDALI ////

List<_Voce> _vociDipendentiAziendali(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  final provider = context.watch<DipendentiAziendaliProvider>();
  final voci = <_Voce>[];
  for (final d in provider.dipendenti) {
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
      final nota = d.noteScadenze[entry.key] ?? '';
      voci.add(_Voce(
        stato: stato,
        data: data,
        titolo: _etichettaTipoScadenza(l10n, entry.key),
        sottotitolo: _sottotitolo([
          VoceInfo(l10n.scadenzeImminentiScreenEmployeeLabel, '${d.nome} ${d.cognome}'),
          if (d.note != '') VoceInfo(l10n.commonNoteLabel, d.note),
          if (nota.isNotEmpty) VoceInfo(l10n.scadenzeImminentiScreenDeadlineNoteLabel, nota),
        ]),
        azioneNota: _bottoneNota(
          context,
          () => showNotaDipendenteAziendaleDialog(
            context,
            provider: provider,
            dipendente: d,
            tipo: entry.key,
          ),
        ),
        onTap: () => showDipendenteAziendaleFormDialog(
          context,
          provider: provider,
          dipendenti: provider.dipendenti,
          esistente: d,
        ),
      ));
    }
  }
  return _perData(voci);
}

//// SCADENZE GENERALI ////

List<_Voce> _vociScadenzeGenerali(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  final provider = context.watch<ScadenzeGeneraliProvider>();
  final voci = <_Voce>[];
  for (final s in provider.scadenze) {
    final data = parseData(s.scadenza);
    if (data == null) continue;
    final stato = computeStato(data, giorniPreavviso: s.giorniPreavviso);
    if (stato == StatoScadenza.valido) continue;
    voci.add(_Voce(
      stato: stato,
      data: data,
      titolo: s.nome,
      sottotitolo: s.notaScadenza.isEmpty
          ? null
          : VoceInfo(l10n.scadenzeImminentiScreenDeadlineNoteLabel, s.notaScadenza),
      azioneNota: _bottoneNota(
        context,
        () => showNotaScadenzaGeneraleDialog(
          context,
          provider: provider,
          scadenza: s,
        ),
      ),
      onTap: () => showScadenzaGeneraleFormDialog(
        context,
        provider: provider,
        scadenze: provider.scadenze,
        esistente: s,
      ),
    ));
  }
  return _perData(voci);
}

/// Riepilogo di tutte le scadenze scadute o in scadenza dell'applicazione,
/// divise per ambito: ogni sezione si apre e si chiude per conto suo, così da
/// tenere sott'occhio solo quello che interessa.
class ScadenzeImminentiScreen extends StatefulWidget {
  const ScadenzeImminentiScreen({super.key});

  @override
  State<ScadenzeImminentiScreen> createState() => _ScadenzeImminentiScreenState();
}

class _ScadenzeImminentiScreenState extends State<ScadenzeImminentiScreen> {
  bool _loaded = false;

  /// Titoli delle sezioni aperte: di default sono tutte chiuse, così la pagina
  /// si apre come un indice con i conteggi per ambito.
  final _sezioniAperte = <String>{};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_loaded) {
      _loaded = true;
      final caricamenti = <Future<void> Function()>[
        context.read<CantieriProvider>().load,
        context.read<SubappaltatoriProvider>().load,
        context.read<DipendentiSubappaltatoriProvider>().load,
        context.read<DocumentiProvider>().load,
        context.read<AutomezziProvider>().load,
        context.read<MacchinariProvider>().load,
        context.read<EstintoriProvider>().load,
        context.read<CassettePsProvider>().load,
        context.read<ArticoliCassettePsProvider>().load,
        context.read<ArticoliStandardCassettePsProvider>().load,
        context.read<DpiAssegnatiProvider>().load,
        context.read<TipiDpiProvider>().load,
        context.read<ImpiantiProvider>().load,
        context.read<RifiutiProvider>().load,
        context.read<MisureProvider>().load,
        context.read<ScaleProvider>().load,
        context.read<ScaffalatureProvider>().load,
        context.read<ScadenzeGeneraliProvider>().load,
        context.read<DipendentiAziendaliProvider>().load,
      ];
      Future.microtask(() {
        for (final carica in caricamenti) {
          carica();
        }
      });
    }
  }

  Future<void> _ricarica() async {
    await Future.wait([
      context.read<CantieriProvider>().load(),
      context.read<SubappaltatoriProvider>().load(),
      context.read<DipendentiSubappaltatoriProvider>().load(),
      context.read<DocumentiProvider>().load(),
      context.read<AutomezziProvider>().load(),
      context.read<MacchinariProvider>().load(),
      context.read<EstintoriProvider>().load(),
      context.read<CassettePsProvider>().load(),
      context.read<ArticoliCassettePsProvider>().load(),
      context.read<ArticoliStandardCassettePsProvider>().load(),
      context.read<DpiAssegnatiProvider>().load(),
      context.read<TipiDpiProvider>().load(),
      context.read<ImpiantiProvider>().load(),
      context.read<RifiutiProvider>().load(),
      context.read<MisureProvider>().load(),
      context.read<ScaleProvider>().load(),
      context.read<ScaffalatureProvider>().load(),
      context.read<ScadenzeGeneraliProvider>().load(),
      context.read<DipendentiAziendaliProvider>().load(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final sezioni = <_Sezione>[
      (titolo: l10n.appDrawerCantieri, rotta: '/cantieri', voci: _vociCantieri(context)),
      (titolo: l10n.appDrawerMacchinari, rotta: '/macchinari', voci: _vociMacchinari(context)),
      (titolo: l10n.appDrawerAutomezzi, rotta: '/automezzi', voci: _vociAutomezzi(context)),
      (titolo: l10n.appDrawerEstintori, rotta: '/estintori', voci: _vociEstintori(context)),
      (titolo: l10n.scadenzeImminentiScreenCompanyEmployeesSection, rotta: '/amministrazione', voci: _vociDipendentiAziendali(context)),
      (titolo: l10n.scadenzeImminentiScreenGeneralDeadlinesSection, rotta: '/amministrazione', voci: _vociScadenzeGenerali(context)),
      (titolo: l10n.scadenzeImminentiScreenFirstAidSection, rotta: '/primo-soccorso', voci: _vociPrimoSoccorso(context)),
      (titolo: l10n.appDrawerDpi, rotta: '/dpi', voci: _vociDpi(context)),
      (titolo: l10n.appDrawerImpianti, rotta: '/impianti', voci: _vociImpianti(context)),
      (titolo: l10n.appDrawerMisure, rotta: '/misure', voci: _vociMisure(context)),
      (titolo: l10n.appDrawerRifiuti, rotta: '/rifiuti', voci: _vociRifiuti(context)),
      (titolo: l10n.appDrawerScale, rotta: '/scale', voci: _vociScale(context)),
      (titolo: l10n.appDrawerScaffalature, rotta: '/scaffalature', voci: _vociScaffalature(context)),
    ];

    final totale = sezioni.fold<int>(0, (somma, s) => somma + s.voci.length);
    final tutteAperte = sezioni
        .where((s) => s.voci.isNotEmpty)
        .every((s) => _sezioniAperte.contains(s.titolo));

    final erroreCaricamento = context.watch<CantieriProvider>().errorMessage ??
        context.watch<DocumentiProvider>().errorMessage ??
        context.watch<AutomezziProvider>().errorMessage ??
        context.watch<MacchinariProvider>().errorMessage ??
        context.watch<EstintoriProvider>().errorMessage ??
        context.watch<CassettePsProvider>().errorMessage ??
        context.watch<DpiAssegnatiProvider>().errorMessage ??
        context.watch<ImpiantiProvider>().errorMessage ??
        context.watch<RifiutiProvider>().errorMessage ??
        context.watch<MisureProvider>().errorMessage ??
        context.watch<ScaleProvider>().errorMessage ??
        context.watch<ScaffalatureProvider>().errorMessage ??
        context.watch<ScadenzeGeneraliProvider>().errorMessage ??
        context.watch<DipendentiAziendaliProvider>().errorMessage;

    // Il primo caricamento riempie i provider uno alla volta: finché non c'è
    // nulla da mostrare si resta sulla rotella, poi la pagina si popola.
    final inCaricamento = totale == 0 &&
        (context.watch<CantieriProvider>().isLoading ||
            context.watch<DocumentiProvider>().isLoading ||
            context.watch<AutomezziProvider>().isLoading ||
            context.watch<MacchinariProvider>().isLoading ||
            context.watch<EstintoriProvider>().isLoading ||
            context.watch<CassettePsProvider>().isLoading ||
            context.watch<DpiAssegnatiProvider>().isLoading ||
            context.watch<ImpiantiProvider>().isLoading ||
            context.watch<RifiutiProvider>().isLoading ||
            context.watch<MisureProvider>().isLoading ||
            context.watch<ScaleProvider>().isLoading ||
            context.watch<ScaffalatureProvider>().isLoading ||
            context.watch<ScadenzeGeneraliProvider>().isLoading ||
            context.watch<DipendentiAziendaliProvider>().isLoading);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: l10n.scadenzeImminentiScreenTitle,
        showHome: false,
      ),
      drawer: AppDrawer(current: l10n.scadenzeImminentiScreenTitle),
      body: inCaricamento
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _ricarica,
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      badges.Badge(
                        badgeContent: Text('$totale',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      badgeStyle: badges.BadgeStyle(badgeColor: Colors.black),
                      position: badges.BadgePosition.topEnd(top: -10, end: -25),
                      child: Text(l10n.scadenzeImminentiScreenSectionHeaderTitle, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
                      ),
                      const SizedBox(width: 25),
                      IconButton(
                        tooltip: tutteAperte
                            ? l10n.scadenzeImminentiScreenCollapseAll
                            : l10n.scadenzeImminentiScreenExpandAll,
                        icon: tutteAperte
                            ? Icon(Icons.unfold_less_outlined, color: Colors.black)
                            : Icon(Icons.unfold_more_outlined, color: Colors.black),
                        iconSize: 22,
                        onPressed: totale == 0
                            ? null
                            : () => setState(() {
                                  if (tutteAperte) {
                                    _sezioniAperte.clear();
                                  } else {
                                    _sezioniAperte.addAll(sezioni
                                        .where((s) => s.voci.isNotEmpty)
                                        .map((s) => s.titolo));
                                  }
                                }),
                      ),
                    ],
                  ),
                  
                  const Divider(height: 24),
                  for (final sezione in sezioni)
                    _SezioneScadenze(
                      titolo: sezione.titolo,
                      rotta: sezione.rotta,
                      voci: sezione.voci,
                      espansa: _sezioniAperte.contains(sezione.titolo),
                      onToggle: () => setState(() {
                        if (!_sezioniAperte.remove(sezione.titolo)) {
                          _sezioniAperte.add(sezione.titolo);
                        }
                      }),
                    ),
                ],
              ),
            ),
    );
  }
}

/// Sezione della pagina: intestazione con il numero di scadenze dell'ambito e
/// il pulsante mostra/nascondi, e sotto l'elenco vero e proprio.
class _SezioneScadenze extends StatelessWidget {
  const _SezioneScadenze({
    required this.titolo,
    required this.rotta,
    required this.voci,
    required this.espansa,
    required this.onToggle,
  });

  final String titolo;
  final String rotta;
  final List<_Voce> voci;
  final bool espansa;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final primaryBlue = Theme.of(context).colorScheme.primary;
    final vuota = voci.isEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            badges.Badge(
              badgeContent: Text(
                '${voci.length}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
              badgeStyle: badges.BadgeStyle(badgeColor: primaryBlue),
              position: badges.BadgePosition.topEnd(top: -10, end: -25),
              showBadge: !vuota,
              child: TextButton(
                child: Text(
                  titolo,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 22,
                    color: vuota ? Colors.black38 : primaryBlue,
                  ),
                ),
                onPressed: () => context.go(rotta),
              ),
            ),
            SizedBox(width: vuota ? 0 : 25),
            if (!vuota)
              IconButton(
                tooltip: espansa ? l10n.scadenzeImminentiScreenHideSectionTooltip : l10n.scadenzeImminentiScreenShowSectionTooltip,
                onPressed: onToggle,
                icon: Icon(
                  espansa
                      ? Icons.unfold_less_outlined
                      : Icons.unfold_more_outlined,
                  color: vuota ? Colors.black38 : primaryBlue,
                  size: 20,
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        AnimatedSize(
          duration: const Duration(milliseconds: 400),
          alignment: Alignment.topCenter,
          child: !espansa
              ? const SizedBox(width: double.infinity)
              : _ElencoVoci(voci: voci),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}

class _ElencoVoci extends StatelessWidget {
  const _ElencoVoci({required this.voci});

  final List<_Voce> voci;

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < kMobileAppBarBreakpoint;
    return Card(
      child: Column(
        children: [
          for (var i = 0; i < voci.length; i++) ...[
            if (i > 0) const Divider(height: 1, color: Color(0xFFE0E0E0)),
            ListTile(
              leading: StatoBadge(stato: voci[i].stato, showLabel: !isMobile),
              title: Text(
                voci[i].titolo,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              subtitle: voci[i].sottotitolo,
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (voci[i].azioneNota != null) ...[
                    voci[i].azioneNota!,
                    const SizedBox(width: 5),
                  ],
                  Text(_formattaData(voci[i].data)),
                ],
              ),
              onTap: voci[i].onTap,
            ),
          ],
        ],
      ),
    );
  }
}
