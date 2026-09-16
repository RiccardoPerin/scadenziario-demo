import '../models/articolo_cassetta_ps.dart';
import '../models/automezzo.dart';
import '../models/cantiere.dart';
import '../models/cassetta_ps.dart';
import '../models/dipendente_subappaltatore.dart';
import '../models/dipendente_aziendale.dart';
import '../models/documento.dart';
import '../models/subappaltatore.dart';
import '../models/estintore.dart';
import '../models/macchinario.dart';
import '../models/impianto.dart';
import '../models/dpi_assegnato.dart';
import '../models/regola_dpi_mansione.dart';
import '../models/tipo_dpi.dart';
import '../models/rifiuto.dart';
import '../models/misura.dart';
import '../models/segnale.dart';
import '../models/controllo_segnale.dart';
import '../models/scala.dart';
import '../models/scaffalatura.dart';
import '../models/fascia_catena.dart';
import '../models/benna.dart';
import '../providers/documenti_provider.dart';
import '../widgets/stato_badge.dart';

DateTime? parseData(String value) => value.isEmpty ? null : DateTime.tryParse(value);

/// Stato peggiore (scaduto > in scadenza > valido) tra un elenco di date,
/// usando la soglia di preavviso di default di [computeStato] (30 giorni).
StatoScadenza statoPeggioreTraDate(Iterable<DateTime?> date) {
  return date.fold<StatoScadenza>(StatoScadenza.valido, (peggiore, data) {
    final stato = computeStato(data);
    if (stato == StatoScadenza.scaduto) return StatoScadenza.scaduto;
    if (stato == StatoScadenza.inScadenza && peggiore == StatoScadenza.valido) {
      return StatoScadenza.inScadenza;
    }
    return peggiore;
  });
}

List<DateTime?> _scadenzeMacchinario(Macchinario m) => [
      parseData(m.scadenzaManutenzioneInterna),
      parseData(m.scadenzaControlloFuniCatene),
      parseData(m.scadenzaVerificaAnnuale),
      parseData(m.scadenzaVerificaVentennale),
      parseData(m.scadenzaAssicurazione),
    ];

StatoScadenza statoScadenzaMacchinario(Macchinario m) =>
    statoPeggioreTraDate(_scadenzeMacchinario(m));

StatoScadenza statoScadenzaMacchinari(List<Macchinario> macchinari) =>
    statoPeggioreTraDate(macchinari.expand(_scadenzeMacchinario));

List<DateTime?> _scadenzeAutomezzo(Automezzo a) => [
      parseData(a.scadenzaNoleggioLeasing),
      parseData(a.scadenzaAssicurazione),
      parseData(a.scadenzaBollo),
      parseData(a.scadenzaRevisione),
      parseData(a.scadenzaControlloTachigrafo),
    ];

StatoScadenza statoScadenzaAutomezzo(Automezzo a) =>
    statoPeggioreTraDate(_scadenzeAutomezzo(a));

StatoScadenza statoScadenzaAutomezzi(List<Automezzo> automezzi) =>
    statoPeggioreTraDate(automezzi.expand(_scadenzeAutomezzo));

/// Data oltre la quale l'estintore va sostituito (18 anni dalla produzione,
/// indipendentemente dalle normali scadenze di revisione/collaudo).
DateTime? scadenzaSostituzioneEstintore(Estintore e) {
  final produzione = parseData(e.dataProduzione);
  if (produzione == null) return null;
  return DateTime(produzione.year + 18, produzione.month, produzione.day);
}

List<DateTime?> _scadenzeEstintore(Estintore e) => [
      parseData(e.scadenzaVerificaEsterna),
      parseData(e.scadenzaRevisione),
      parseData(e.scadenzaCollaudo),
      scadenzaSostituzioneEstintore(e),
    ];

StatoScadenza statoScadenzaEstintore(Estintore e) =>
    statoPeggioreTraDate(_scadenzeEstintore(e));

StatoScadenza statoScadenzaEstintori(List<Estintore> estintori) =>
    statoPeggioreTraDate(estintori.expand(_scadenzeEstintore));

StatoScadenza statoScadenzaCassettePs({
  required List<CassettaPs> cassette,
  required List<ArticoloCassettaPs> articoli,
}) {
  // Ignora gli articoli orfani (la cui cassetta è stata eliminata): senza
  // questo filtro un pallino rosso può restare acceso nel drawer anche a
  // pagina vuota, perché il riferimento non viene ripulito lato database.
  final idCassette = cassette.map((c) => c.id).toSet();
  return statoPeggioreTraDate([
    ...cassette.map((c) => parseData(c.prossimoControllo)),
    ...articoli
        .where((a) => idCassette.contains(a.cassettaId))
        .map((a) => parseData(a.scadenza)),
  ]);
}


const mansioneRlst = 'RLST';
const mansioneRspp = 'RSPP';
const mansioneTitolare = 'Datore di Lavoro';

bool isRlst(DipendenteAziendale d) => d.mansione == mansioneRlst;
bool isRspp(DipendenteAziendale d) => d.mansione == mansioneRspp;
bool isTitolare(DipendenteAziendale d) => d.mansione == mansioneTitolare;

/// Scadenze tracciate su un dipendente aziendale, con l'etichetta da mostrare.
/// L'ordine è quello usato nelle liste e nei riepiloghi.
///
/// I campi "data_formazione_*" (modello 231, sistema di gestione ambientale,
/// RENTRI) sono volutamente esclusi: registrano quando la formazione è stata
/// svolta e non hanno una scadenza da monitorare.
List<({String etichetta, DateTime? data})> scadenzeDipendenteAziendale(
  DipendenteAziendale d,
) {
  // Per l'RLST conta solo la scadenza del proprio incarico: eventuali altre
  // date presenti sul record non vengono considerate.
  if (isRlst(d)) {
    return [(etichetta: 'RLST', data: parseData(d.scadenzaRlst))];
  }
  if (isRspp(d)) {
    return [(etichetta: 'RSPP', data: parseData(d.scadenzaRspp))];
  }
  return [
    // Sicurezza
    (etichetta: 'Visita medica', data: parseData(d.scadenzaVisitaMedica)),
    (etichetta: 'Formazione sicurezza', data: parseData(d.scadenzaFormazioneSicurezza)),
    (etichetta: 'Lavori in quota', data: parseData(d.scadenzaLavoriQuota)),
    (etichetta: 'Antitetanica', data: parseData(d.scadenzaAntitetanica)),
    // Corsi attrezzature
    (etichetta: 'Gru su autocarro', data: parseData(d.scadenzaGruAutocarro)),
    (etichetta: 'Gru a torre', data: parseData(d.scadenzaGruTorre)),
    (
      etichetta: 'Carrelli elevatori semoventi',
      data: parseData(d.scadenzaCarrelloElevatoreSemovente)
    ),
    (etichetta: 'Conduzione escavatori', data: parseData(d.scadenzaConduzioneEscavatori)),
    (etichetta: 'Piattaforme elevatrici', data: parseData(d.scadenzaPiattaformeElevatrici)),
    (etichetta: 'Montaggio/smontaggio ponteggi', data: parseData(d.scadenzaPonteggi)),
    (etichetta: 'Corso scaffalature', data: parseData(d.scadenzaScaffalature)),
    (etichetta: 'Corso diisocianati', data: parseData(d.scadenzaCorsoDisocianati)),
    (
      etichetta: 'Corso cronotachigrafo',
      data: parseData(d.scadenzaCorsoCronotachigrafico)
    ),
    // Ruoli ed emergenze
    (etichetta: 'Preposto', data: parseData(d.scadenzaPreposto)),
    (etichetta: 'Antincendio', data: parseData(d.scadenzaAntincendio)),
    (etichetta: 'Primo soccorso', data: parseData(d.scadenzaPrimoSoccorso)),
    (etichetta: 'RSPP', data: parseData(d.scadenzaRspp)),
    // Documenti personali
    (etichetta: 'Patente', data: parseData(d.scadenzaPatente)),
    (etichetta: 'Carta tachigrafica', data: parseData(d.scadenzaCartaTachigrafica)),
    (etichetta: "Carta d'identità", data: parseData(d.scadenzaCartaIdentita)),
    (etichetta: 'Firma digitale', data: parseData(d.scadenzaFirmaDigitale)),
    (etichetta: 'Permesso di soggiorno', data: parseData(d.scadenzaPermessoSoggiorno)),
    (etichetta: 'Codice Fiscale', data: parseData(d.scadenzaCodiceFiscale)),
    (etichetta: 'Contratto', data: parseData(d.scadenzaContratto)),
  ];
}

StatoScadenza statoScadenzaDipendenteAziendale(DipendenteAziendale d) =>
    statoPeggioreTraDate(scadenzeDipendenteAziendale(d).map((s) => s.data));

StatoScadenza statoScadenzaDipendentiAziendali(List<DipendenteAziendale> dipendenti) =>
    statoPeggioreTraDate(
      dipendenti.expand((d) => scadenzeDipendenteAziendale(d).map((s) => s.data)),
    );



/// Scadenze generali del cantiere stesso (messa a terra + le 5 scadenze
/// generiche libere), con l'etichetta da mostrare: il nome dato dall'utente
/// se presente, altrimenti la posizione ("Scadenza generica 1", ...). [campo]
/// è il nome stabile del campo PocketBase ("scadenza_messa_a_terra",
/// "scadenza_generica1", ...), usato come chiave per `Cantiere.noteScadenze`
/// dato che l'etichetta può cambiare se l'utente rinomina la scadenza.
/// Solo le scadenze effettivamente impostate vengono incluse, ordinate per
/// data crescente.
List<({String campo, String etichetta, DateTime data})> scadenzeGeneraliCantiere(Cantiere c) {
  final voci = <({String campo, String etichetta, DateTime data})>[];
  void aggiungi(String campo, String etichettaDefault, String valore, String nomePersonalizzato) {
    final data = parseData(valore);
    if (data == null) return;
    final etichetta = nomePersonalizzato.trim().isEmpty ? etichettaDefault : nomePersonalizzato.trim();
    voci.add((campo: campo, etichetta: etichetta, data: data));
  }

  aggiungi('scadenza_messa_a_terra', 'Messa a terra', c.scadenzaMessaTerra, '');
  aggiungi('scadenza_generica1', 'Scadenza generica 1', c.scadenzaGenerica1, c.nomeScadenzaGenerica1);
  aggiungi('scadenza_generica2', 'Scadenza generica 2', c.scadenzaGenerica2, c.nomeScadenzaGenerica2);
  aggiungi('scadenza_generica3', 'Scadenza generica 3', c.scadenzaGenerica3, c.nomeScadenzaGenerica3);
  aggiungi('scadenza_generica4', 'Scadenza generica 4', c.scadenzaGenerica4, c.nomeScadenzaGenerica4);
  aggiungi('scadenza_generica5', 'Scadenza generica 5', c.scadenzaGenerica5, c.nomeScadenzaGenerica5);

  voci.sort((a, b) => a.data.compareTo(b.data));
  return voci;
}

/// Documenti che concorrono alle scadenze dei cantieri, già depurati dei casi
/// che non vanno segnalati. Usata sia dalla sezione "Scadenze imminenti" della
/// pagina Cantieri sia dal pallino del drawer, e allineata alle mail di
/// sollecito (backend/pb_hooks/notifiche.pb.js).
///
/// Vengono scartati:
///   - i documenti dei cantieri conclusi;
///   - i documenti dei dipendenti dei subappaltatori non presenti in alcun
///     cantiere attivo (i dipendenti aziendali hanno una collection propria e
///     sono gestiti nella pagina Amministrazione);
///   - i documenti generali dei subappaltatori (es. DURC) quando il
///     subappaltatore non è collegato ad alcun cantiere attivo: non essendo in
///     uso può avere documenti non aggiornati, e non avrebbe senso sollecitarlo.
List<Documento> documentiScadenzeCantieri({
  required List<Cantiere> cantieri,
  required List<Subappaltatore> subappaltatori,
  required List<DipendenteSubappaltatore> dipendenti,
  required DocumentiProvider documentiProvider,
}) {
  final cantieriAttiviIds =
      cantieri.where((c) => c.stato != 'concluso').map((c) => c.id).toSet();
  final dipendentiById = {for (final d in dipendenti) d.id: d};
  final subappaltatoriById = {for (final s in subappaltatori) s.id: s};

  bool inCantiereAttivo(Iterable<String> cantieriIds) =>
      cantieriIds.any(cantieriAttiviIds.contains);

  return documentiProvider
      .soloUltimaVersione(documentiProvider.documenti)
      .where((d) => d.cantiereId.isEmpty || cantieriAttiviIds.contains(d.cantiereId))
      .where((d) {
        if (d.isDocumentoDipendente) {
          final dipendente = dipendentiById[d.dipendenteId];
          return dipendente != null && inCantiereAttivo(dipendente.cantieriIds);
        }
        if (d.isDocumentoSubappaltatoreGenerale) {
          final sub = subappaltatoriById[d.subappaltatoreId];
          return sub != null && inCantiereAttivo(sub.cantieriIds);
        }
        return true;
      })
      .toList();
}

/// Stato peggiore tra i documenti che contano per i cantieri (stessa logica
/// della sezione "Scadenze imminenti" della pagina Cantieri).
StatoScadenza statoScadenzaCantieri({
  required List<Cantiere> cantieri,
  required List<Subappaltatore> subappaltatori,
  required List<DipendenteSubappaltatore> dipendenti,
  required DocumentiProvider documentiProvider,
}) {
  final documenti = documentiScadenzeCantieri(
    cantieri: cantieri,
    subappaltatori: subappaltatori,
    dipendenti: dipendenti,
    documentiProvider: documentiProvider,
  );

  return documenti.fold<StatoScadenza>(StatoScadenza.valido, (peggiore, d) {
    final stato = computeStato(d.dataScadenza, giorniPreavviso: d.giorniPreavviso);
    if (stato == StatoScadenza.scaduto) return StatoScadenza.scaduto;
    if (stato == StatoScadenza.inScadenza && peggiore == StatoScadenza.valido) {
      return StatoScadenza.inScadenza;
    }
    return peggiore;
  });
}

/// Ordina i documenti come vanno mostrati negli elenchi: prima gli scaduti,
/// poi quelli in scadenza, infine i validi.
///
/// A parità di stato vengono prima le scadenze più vicine — fra gli scaduti,
/// quindi, quelli fermi da più tempo — e i documenti senza scadenza chiudono
/// la lista. L'ultimo criterio è il caricamento più recente: serve solo a
/// rendere l'ordine deterministico, perché `List.sort` in Dart non è stabile e
/// senza di esso due documenti equivalenti potrebbero scambiarsi di posto da
/// un rebuild all'altro.
List<Documento> documentiPerUrgenza(List<Documento> documenti) {
  int rango(StatoScadenza stato) => switch (stato) {
        StatoScadenza.scaduto => 0,
        StatoScadenza.inScadenza => 1,
        StatoScadenza.valido => 2,
      };

  return [...documenti]..sort((a, b) {
      final perStato = rango(computeStato(a.dataScadenza, giorniPreavviso: a.giorniPreavviso))
          .compareTo(rango(computeStato(b.dataScadenza, giorniPreavviso: b.giorniPreavviso)));
      if (perStato != 0) return perStato;

      final scadenzaA = a.dataScadenza;
      final scadenzaB = b.dataScadenza;
      if (scadenzaA != null && scadenzaB != null) {
        final perData = scadenzaA.compareTo(scadenzaB);
        if (perData != 0) return perData;
      } else if (scadenzaA != null) {
        return -1;
      } else if (scadenzaB != null) {
        return 1;
      }

      return b.created.compareTo(a.created);
    });
}

/// Testo del tooltip sul pallino che riassume un gruppo di documenti (es. le
/// scadenze di un dipendente): elenca per nome i documenti scaduti e quelli in
/// scadenza, così da sapere quali sono senza dover aprire il gruppo.
/// `null` quando è tutto in regola: lì il pallino verde basta da solo.
String? tooltipDocumentiCritici(List<Documento> documenti) {
  final scaduti = <String>[];
  final inScadenza = <String>[];
  for (final d in documentiPerUrgenza(documenti)) {
    final nome = (d.tipoDocumentoNome ?? '').trim();
    final etichetta = nome.isEmpty ? 'Scadenza senza nome' : nome;
    switch (computeStato(d.dataScadenza, giorniPreavviso: d.giorniPreavviso)) {
      case StatoScadenza.scaduto:
        scaduti.add(etichetta);
      case StatoScadenza.inScadenza:
        inScadenza.add(etichetta);
      case StatoScadenza.valido:
        break;
    }
  }
  if (scaduti.isEmpty && inScadenza.isEmpty) return null;

  final righe = <String>[
    if (scaduti.isNotEmpty) ...[
      scaduti.length == 1 ? 'Scaduto:' : 'Scaduti:',
      ...scaduti.map((n) => '• $n'),
    ],
    if (inScadenza.isNotEmpty) ...[
      if (scaduti.isNotEmpty) '',
      'In scadenza:',
      ...inScadenza.map((n) => '• $n'),
    ],
  ];
  return righe.join('\n');
}

/// Documenti che concorrono allo stato di un subappaltatore, nella sola ultima
/// versione: i suoi (generali o specifici di un cantiere) più quelli dei suoi
/// dipendenti.
///
/// A differenza delle email di sollecito — che riguardano solo i cantieri
/// ancora aperti (vedi `backend/pb_hooks/notifiche.pb.js`) — qui non si filtra
/// per stato del cantiere: la pagina Subappaltatori è un'anagrafica, e un
/// documento scaduto va segnalato anche se al momento il subappaltatore non
/// lavora su nessun cantiere attivo.
List<Documento> documentiSubappaltatore({
  required Subappaltatore subappaltatore,
  required DocumentiProvider documentiProvider,
  required List<DipendenteSubappaltatore> dipendenti,
}) {
  final dipendentiIds = dipendenti
      .where((d) => d.subappaltatoreId == subappaltatore.id)
      .map((d) => d.id)
      .toList();

  return documentiProvider.soloUltimaVersione([
    // I documenti di un dipendente sono già coperti sotto, anche quando sul
    // record è indicato pure il subappaltatore.
    ...documentiProvider
        .perSubappaltatoreTutti(subappaltatore.id)
        .where((d) => d.dipendenteId.isEmpty),
    ...documentiProvider.perDipendenti(dipendentiIds),
  ]);
}

/// Stato peggiore tra i documenti di un subappaltatore
/// (vedi [documentiSubappaltatore]).
StatoScadenza statoScadenzaSubappaltatore({
  required Subappaltatore subappaltatore,
  required DocumentiProvider documentiProvider,
  required List<DipendenteSubappaltatore> dipendenti,
}) {
  final documenti = documentiSubappaltatore(
    subappaltatore: subappaltatore,
    documentiProvider: documentiProvider,
    dipendenti: dipendenti,
  );
  return statoPeggioreTra(documenti
      .map((d) => computeStato(d.dataScadenza, giorniPreavviso: d.giorniPreavviso)));
}

List<DateTime?> _scadenzeImpianto(Impianto i) => [
      parseData(i.scadenzaManutenzioneInterna),
      parseData(i.scadenzaManutenzioneEsterna),
    ];

StatoScadenza statoScadenzaImpianto(Impianto i) =>
    statoPeggioreTraDate(_scadenzeImpianto(i));

StatoScadenza statoScadenzaImpianti(List<Impianto> impianti) =>
    statoPeggioreTraDate(impianti.expand(_scadenzeImpianto));

const mansioneDatore = 'Datore di Lavoro';
const mansioneM02 = 'M02 - Impiegato Tecnico';
const mansioneM03 = 'M03 - Addetto Tecnico di Cantiere';
const mansioneM04 = 'M04 - Addetto Operaio Edile/Muratore';

/// Mansioni per cui esistono regole DPI da rispettare automaticamente.
const mansioniConDpi = {mansioneDatore, mansioneM02, mansioneM03, mansioneM04};

/// Stato peggiore (scaduto > in scadenza > valido) tra stati già calcolati,
/// utile per combinare più fonti di stato eterogenee (es. scadenze di date
/// insieme a penalità per DPI mai assegnati).
StatoScadenza statoPeggioreTra(Iterable<StatoScadenza> stati) {
  var peggiore = StatoScadenza.valido;
  for (final stato in stati) {
    if (stato == StatoScadenza.scaduto) return StatoScadenza.scaduto;
    if (stato == StatoScadenza.inScadenza) peggiore = StatoScadenza.inScadenza;
  }
  return peggiore;
}

/// DPI richiesti per un dipendente: quelli previsti dalla regola della sua
/// mansione, più — per gli operai (M04) con una scadenza lavori in quota
/// impostata — i DPI marcati come necessari per i lavori in quota (corde,
/// imbragature, ...), indipendentemente dalla regola della mansione.
List<TipoDpi> dpiRichiesti(
  DipendenteAziendale d,
  List<RegolaDpiMansione> regole,
  List<TipoDpi> tipiDpi,
) {
  final ids = <String>{};
  for (final r in regole) {
    if (r.mansione == d.mansione) ids.addAll(r.dpiObbligatoriIds);
  }
  if (d.mansione == mansioneM04 && d.scadenzaLavoriQuota.isNotEmpty) {
    ids.addAll(tipiDpi.where((t) => t.lavoriInQuota).map((t) => t.id));
  }
  final tipiById = {for (final t in tipiDpi) t.id: t};
  return ids.map((id) => tipiById[id]).whereType<TipoDpi>().toList()
    ..sort((a, b) => a.nome.compareTo(b.nome));
}

/// Stato peggiore tra i DPI richiesti di un dipendente: un DPI obbligatorio
/// mai assegnato conta come "scaduto" (manca la protezione), uno assegnato
/// segue la sua normale scadenza (in base ai giorni di preavviso del tipo).
StatoScadenza statoScadenzaDipendenteDpi(
  List<TipoDpi> richiesti,
  List<DpiAssegnato> assegnatiDipendente,
) {
  return statoPeggioreTra(richiesti.map((tipo) {
    final assegnato = assegnatiDipendente.where((a) => a.tipoDpi == tipo.id).firstOrNull;
    if (assegnato == null) return StatoScadenza.scaduto;
    return computeStato(parseData(assegnato.dataScadenza), giorniPreavviso: tipo.giorniPreavviso);
  }));
}

/// Indica se tra i DPI assegnati esiste una scadenza realmente superata (data
/// nel passato). Serve a distinguere questo caso da un DPI obbligatorio mai
/// assegnato, che in [statoScadenzaDpi] pesa comunque come "scaduto" pur non
/// avendo una data reale.
bool statoScadenzaDpiHaScadenzaReale({
  required List<DpiAssegnato> assegnati,
  required List<TipoDpi> tipiDpi,
}) {
  final tipiById = {for (final t in tipiDpi) t.id: t};
  return assegnati.any((a) {
    final tipo = tipiById[a.tipoDpi];
    if (tipo == null) return false;
    return computeStato(parseData(a.dataScadenza), giorniPreavviso: tipo.giorniPreavviso) ==
        StatoScadenza.scaduto;
  });
}

/// Stato peggiore complessivo dei DPI: tiene conto sia delle scadenze dei DPI
/// già assegnati (a qualunque dipendente) sia dei DPI obbligatori (M02/M03/M04,
/// eventualmente estesi dalla regola lavori in quota) che non risultano ancora
/// assegnati a nessuno.
StatoScadenza statoScadenzaDpi({
  required List<DipendenteAziendale> dipendenti,
  required List<DpiAssegnato> assegnati,
  required List<TipoDpi> tipiDpi,
  required List<RegolaDpiMansione> regole,
}) {
  final tipiById = {for (final t in tipiDpi) t.id: t};
  final statiAssegnati = assegnati.map((a) {
    final tipo = tipiById[a.tipoDpi];
    if (tipo == null) return StatoScadenza.valido;
    return computeStato(parseData(a.dataScadenza), giorniPreavviso: tipo.giorniPreavviso);
  });
  final statiDipendenti = dipendenti
      .where((d) => mansioniConDpi.contains(d.mansione))
      .map((d) => statoScadenzaDipendenteDpi(
            dpiRichiesti(d, regole, tipiDpi),
            assegnati.where((a) => a.dipendente == d.id).toList(),
          ));
  return statoPeggioreTra([...statiAssegnati, ...statiDipendenti]);
}

//// RIFIUTI ////
List<DateTime?> _scadenzeRifiuto(Rifiuto r) => [
      parseData(r.scadRifiutiNonPericolosiTrasportatore),
      parseData(r.scadRifiutiPericolosiTrasportatore),
      parseData(r.scadRifiutiNonPericolosiSmaltitore),
      parseData(r.scadRifiutiPericolosiSmaltitore),
    ];

StatoScadenza statoScadenzaRifiuto(Rifiuto r) =>
    statoPeggioreTraDate(_scadenzeRifiuto(r));

StatoScadenza statoScadenzaRifiuti(List<Rifiuto> rifiuti) =>
    statoPeggioreTraDate(rifiuti.expand(_scadenzeRifiuto));

//// MISURE //// 
List<DateTime?> _scadenzeMisura(Misura m) => [
      parseData(m.dataProssimaTaraturaEsterna),
      parseData(m.dataProssimaTaraturaInterna),
    ];

StatoScadenza statoScadenzaMisura(Misura m) =>
    statoPeggioreTraDate(_scadenzeMisura(m));

StatoScadenza statoScadenzaMisure(List<Misura> misure) =>
    statoPeggioreTraDate(misure.expand(_scadenzeMisura));

//// SEGNALETICA ////

/// Ultimo controllo registrato su un cartello, `null` se non è mai stato
/// controllato. [controlli] può essere l'elenco completo o già filtrato: la
/// scelta avviene sulla data di ispezione, non sull'ordine della lista.
ControlloSegnale? ultimoControlloSegnale(
  String segnaleId,
  List<ControlloSegnale> controlli,
) {
  ControlloSegnale? ultimo;
  DateTime? dataUltimo;
  for (final c in controlli) {
    if (c.segnaleId != segnaleId) continue;
    final data = parseData(c.dataIspezione);
    if (ultimo == null || (data != null && (dataUltimo == null || data.isAfter(dataUltimo)))) {
      ultimo = c;
      dataUltimo = data;
    }
  }
  return ultimo;
}

/// Stato di un cartello dal suo ultimo controllo: valido se l'esito è positivo
/// su tutti i punti verificati, altrimenti scaduto. Un cartello mai controllato
/// pesa anch'esso come scaduto: non è un esito negativo ma un dato che manca,
/// e chi mostra il badge lo distingue col grigio (vedi
/// [segnaleticaHaEsitoNegativo]).
StatoScadenza statoControlloSegnale(ControlloSegnale? ultimo) =>
    ultimo != null && ultimo.esitoPositivo
        ? StatoScadenza.valido
        : StatoScadenza.scaduto;

StatoScadenza statoScadenzaSegnale(
  String segnaleId,
  List<ControlloSegnale> controlli,
) => statoControlloSegnale(ultimoControlloSegnale(segnaleId, controlli));

/// Stato peggiore tra tutti i cartelli (rosso > grigio > verde): basta un
/// cartello con esito negativo o mai controllato perché l'insieme non sia
/// valido.
StatoScadenza statoScadenzaSegnaletica({
  required List<Segnale> segnali,
  required List<ControlloSegnale> controlli,
}) => statoPeggioreTra(
      segnali.map((s) => statoScadenzaSegnale(s.id, controlli)),
    );

/// Indica se almeno un cartello ha davvero un ultimo controllo con esito
/// negativo. Serve a distinguere il rosso dai soli cartelli mai controllati,
/// che pesano come scaduti ma vanno mostrati in grigio.
bool segnaleticaHaEsitoNegativo({
  required List<Segnale> segnali,
  required List<ControlloSegnale> controlli,
}) => segnali.any((s) {
      final ultimo = ultimoControlloSegnale(s.id, controlli);
      return ultimo != null && !ultimo.esitoPositivo;
    });


//// SCALE //// 
List<DateTime?> _scadenzeScala(Scala s) => [
      parseData(s.prossimaVerifica),
    ];

StatoScadenza statoScadenzaScala(Scala s) =>
    statoPeggioreTraDate(_scadenzeScala(s));

StatoScadenza statoScadenzaScale(List<Scala> scale) =>
    statoPeggioreTraDate(scale.expand(_scadenzeScala));


//// SCAFFALATURE //// 
List<DateTime?> _scadenzeScaffalatura(Scaffalatura s) => [
      parseData(s.dataProssimaVerifica),
    ];

StatoScadenza statoScadenzaScaffalatura(Scaffalatura s) =>
    statoPeggioreTraDate(_scadenzeScaffalatura(s));

StatoScadenza statoScadenzaScaffalature(List<Scaffalatura> scaffalature) =>
    statoPeggioreTraDate(scaffalature.expand(_scadenzeScaffalatura));


//// FASCE E CATENE ////

/// Una fascia/catena con esito di verifica negativo è fuori servizio e va
/// sostituita: pesa come scaduta a prescindere dalla data della prossima
/// verifica. L'esito conta però solo se una verifica è stata davvero fatta
/// (su un record mai verificato il campo è semplicemente ancora `false`).
bool fasciaCatenaScartata(FasciaCatena f) =>
    f.dataUltimaVerificaInterna.isNotEmpty && !f.esitoVerifica;

StatoScadenza statoScadenzaFasciaCatena(FasciaCatena f) {
  if (fasciaCatenaScartata(f)) return StatoScadenza.scaduto;
  return statoPeggioreTraDate([parseData(f.dataProssimaVerifica)]);
}

StatoScadenza statoScadenzaFasceCatene(List<FasciaCatena> fasceCatene) =>
    statoPeggioreTra(fasceCatene.map(statoScadenzaFasciaCatena));


//// BENNE ////

/// Come per le fasce/catene, una benna con esito di verifica negativo è fuori
/// servizio: pesa come scaduta a prescindere dalla data della prossima
/// verifica (l'esito conta solo se una verifica è stata davvero fatta).
bool bennaScartata(Benna b) =>
    b.dataUltimaVerificaInterna.isNotEmpty && !b.esitoVerifica;

StatoScadenza statoScadenzaBenna(Benna b) {
  if (bennaScartata(b)) return StatoScadenza.scaduto;
  return statoPeggioreTraDate([parseData(b.dataProssimaVerifica)]);
}

StatoScadenza statoScadenzaBenne(List<Benna> benne) =>
    statoPeggioreTra(benne.map(statoScadenzaBenna));
