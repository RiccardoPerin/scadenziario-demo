import 'dart:math' as math;
import 'dart:typed_data';

import 'package:flutter/services.dart' show rootBundle;
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../widgets/campo_info.dart' show formatData;
import '../widgets/stato_badge.dart';
import 'stato_scadenze.dart';

/// Blu istituzionale dell'app (`ColorScheme.primary`), replicato qui perché il
/// pacchetto `pdf` usa i suoi colori e non quelli di Material.
const _blu = PdfColor.fromInt(0xFF0164B1);
const _grigioBordo = PdfColor.fromInt(0xFF9E9E9E);
const _grigioRiga = PdfColor.fromInt(0xFFF2F5F8);
const _rosso = PdfColor.fromInt(0xFFC62828);
const _ambra = PdfColor.fromInt(0xFFFF8F00);

const _dimensioneTesto = 7.5;

/// Altezza minima di una riga: le 25 pixel a 96 dpi che Excel usa di default,
/// cioè 18,75 punti PDF. Le righe con testo che va a capo crescono da sole.
const _altezzaRiga = 25 * 72 / 96;
const _marginePagina = 1.0 * PdfPageFormat.cm;

/// Spazio orizzontale che una cella aggiunge al testo (padding su entrambi i
/// lati più il bordo): va sommato alla larghezza misurata del contenuto.
const _spazioCella = 9.0;

/// Limiti di larghezza di una colonna: sotto il minimo le intestazioni
/// diventano illeggibili, sopra il massimo una singola nota lunga si
/// prenderebbe mezza pagina (meglio mandarla a capo).
const _larghezzaMinimaColonna = 1.1 * PdfPageFormat.cm;
const _larghezzaMassimaColonna = 6.5 * PdfPageFormat.cm;

/// Larghezza oltre la quale mandare a capo il contenuto di una colonna non è
/// un problema (note, ubicazioni, descrizioni): serve a decidere il formato
/// della pagina senza che un solo testo lungo faccia passare tutto all'A3.
const _larghezzaComodaColonna = 3.0 * PdfPageFormat.cm;

final _dataOraFormat = DateFormat('dd/MM/yyyy HH:mm');
final _dataFileFormat = DateFormat('yyyy-MM-dd');

/// Una cella della tabella PDF: testo già formattato, con l'eventuale colore
/// (usato per le scadenze) e il grassetto.
class CellaPdf {
  const CellaPdf(this.testo, {this.colore, this.grassetto = false});

  final String testo;
  final PdfColor? colore;
  final bool grassetto;
}

/// Cella di una data di scadenza grezza (come arriva da PocketBase): la
/// formatta in gg/mm/aaaa e la colora come nelle card (rosso se scaduta,
/// ambra se in scadenza). [giorniPreavviso] sono le soglie proprie del
/// tipo, per le scadenze che ne hanno (documenti, DPI).
CellaPdf cellaScadenza(
  String valoreGrezzo, {
  List<int> giorniPreavviso = const [],
}) {
  final data = parseData(valoreGrezzo);
  if (data == null) return const CellaPdf('-');
  final colore = switch (computeStato(data, giorniPreavviso: giorniPreavviso)) {
    StatoScadenza.scaduto => _rosso,
    StatoScadenza.inScadenza => _ambra,
    StatoScadenza.valido => null,
  };
  return CellaPdf(
    formatData(valoreGrezzo),
    colore: colore,
    grassetto: colore != null,
  );
}

/// Logo aziendale per l'intestazione del PDF, `null` se non caricabile
/// (il documento resta comunque stampabile).
Future<pw.MemoryImage?> _logo() async {
  try {
    final bytes = await rootBundle.load('assets/demo.png');
    return pw.MemoryImage(bytes.buffer.asUint8List());
  } catch (_) {
    return null;
  }
}

/// Font TTF già registrato nel documento: permette di misurare il testo prima
/// di costruire le pagine e di disegnarlo poi con lo stesso font, senza
/// incorporarlo due volte nel PDF.
class _FontRegistrato extends pw.Font {
  _FontRegistrato(this.pdfFont);

  final PdfFont pdfFont;

  @override
  PdfFont buildFont(PdfDocument _) => pdfFont;

  @override
  String get fontName => pdfFont.fontName;
}

/// Coppia di font (normale e grassetto) usata in tutto il documento.
///
/// I font standard del PDF (Helvetica & co.) sanno scrivere solo caratteri
/// Latin-1 e lanciano "Helvetica has no Unicode support" appena nei dati
/// compare un €, un trattino lungo o un apice tipografico incollato da Word:
/// per questo si incorpora Roboto, che copre tutto. Se per qualche motivo gli
/// asset non fossero disponibili si ripiega su Helvetica, in modo che la
/// stampa resti possibile.
Future<({_FontRegistrato normale, _FontRegistrato grassetto})> _font(
  PdfDocument documento,
) async {
  try {
    final normale = await rootBundle.load('assets/fonts/Roboto-Regular.ttf');
    final grassetto = await rootBundle.load('assets/fonts/Roboto-Bold.ttf');
    return (
      normale: _FontRegistrato(PdfTtfFont(documento, normale)),
      grassetto: _FontRegistrato(PdfTtfFont(documento, grassetto)),
    );
  } catch (_) {
    return (
      normale: _FontRegistrato(PdfFont.helvetica(documento)),
      grassetto: _FontRegistrato(PdfFont.helveticaBold(documento)),
    );
  }
}

/// Genera una tabella in stile foglio Excel (righe a zebra, griglia completa,
/// intestazione ripetuta su ogni pagina) e apre la finestra di stampa del
/// browser/sistema, da cui si può stampare davvero o salvare in PDF.
///
/// [colonne] sono le intestazioni; ogni riga di [righe] deve avere lo stesso
/// numero di celle. La larghezza delle colonne è calcolata dal contenuto (come
/// l'adatta-larghezza di Excel), e il formato della pagina è scelto di
/// conseguenza: A4 orizzontale se le colonne ci stanno, altrimenti A3
/// orizzontale. [formato] forza un formato preciso, [larghezze] i pesi
/// relativi delle colonne.
Future<void> stampaTabellaPdf({
  required String titolo,
  required List<String> colonne,
  required List<List<CellaPdf>> righe,
  List<double>? larghezze,
  String? sottotitolo,
  PdfPageFormat? formato,
}) async {
  final pdf = await _generaTabella(
    titolo: titolo,
    colonne: colonne,
    righe: righe,
    larghezze: larghezze,
    sottotitolo: sottotitolo,
    formato: formato,
  );
  await Printing.layoutPdf(
    onLayout: (_) => pdf.byte,
    name: '${_nomeFile(titolo)}_${_dataFileFormat.format(DateTime.now())}.pdf',
    format: pdf.pagina,
  );
}

/// Come [stampaTabellaPdf], ma restituisce il PDF senza aprire la finestra di
/// stampa: serve a salvarlo o ad allegarlo altrove.
Future<Uint8List> generaTabellaPdf({
  required String titolo,
  required List<String> colonne,
  required List<List<CellaPdf>> righe,
  List<double>? larghezze,
  String? sottotitolo,
  PdfPageFormat? formato,
}) async => (await _generaTabella(
  titolo: titolo,
  colonne: colonne,
  righe: righe,
  larghezze: larghezze,
  sottotitolo: sottotitolo,
  formato: formato,
)).byte;

/// Il PDF con il formato di pagina scelto, che serve anche alla finestra di
/// stampa per proporre la carta giusta.
Future<({Uint8List byte, PdfPageFormat pagina})> _generaTabella({
  required String titolo,
  required List<String> colonne,
  required List<List<CellaPdf>> righe,
  required List<double>? larghezze,
  required String? sottotitolo,
  required PdfPageFormat? formato,
}) async {
  assert(
    larghezze == null || larghezze.length == colonne.length,
    'larghezze deve avere un valore per ogni colonna',
  );
  assert(
    righe.every((r) => r.length == colonne.length),
    'ogni riga deve avere una cella per ogni colonna',
  );

  final documento = pw.Document(title: titolo);
  final font = await _font(documento.document);
  final misure = _misureColonne(
    colonne: colonne,
    righe: righe,
    normale: font.normale.pdfFont,
    grassetto: font.grassetto.pdfFont,
  );
  final pagina = _formatoPagina(formato, misure.minime);

  final generatoIl = _dataOraFormat.format(DateTime.now());
  final logo = await _logo();

  documento.addPage(
    pw.MultiPage(
      pageFormat: pagina,
      theme: pw.ThemeData.withFont(
        base: font.normale,
        bold: font.grassetto,
      ),
      // Il default (20) troncherebbe silenziosamente gli elenchi lunghi.
      maxPages: 500,
      header: (context) => _intestazione(
        context: context,
        titolo: titolo,
        sottotitolo: sottotitolo,
        logo: logo,
      ),
      footer: (context) => _piePagina(context, generatoIl),
      build: (context) => [
        if (righe.isEmpty)
          pw.Text(
            'Nessun dato da stampare.',
            style: const pw.TextStyle(fontSize: 10),
          )
        else
          _tabella(
            colonne: colonne,
            righe: righe,
            larghezze: larghezze ?? misure.ideali,
          ),
      ],
    ),
  );

  return (byte: await documento.save(), pagina: pagina);
}

/// A4 orizzontale se le colonne ci stanno alla loro larghezza minima
/// accettabile, altrimenti A3 orizzontale (oltre l'A3 il testo va a capo nelle
/// celle: allargare ancora la carta renderebbe il foglio ingestibile).
PdfPageFormat _formatoPagina(PdfPageFormat? richiesto, List<double> minime) {
  final base =
      richiesto ??
      (minime.fold(0.0, (t, l) => t + l) <=
              PdfPageFormat.a4.landscape.width - 2 * _marginePagina
          ? PdfPageFormat.a4.landscape
          : PdfPageFormat.a3.landscape);
  return PdfPageFormat(base.width, base.height, marginAll: _marginePagina);
}

/// Le due larghezze di ogni colonna:
///
/// - [ideali]: quella che il contenuto avrebbe su una riga sola (intestazione
///   compresa), usata come peso per distribuire la larghezza della pagina;
/// - [minime]: quella sotto la quale la colonna diventa illeggibile, usata solo
///   per scegliere il formato della pagina. Un'intestazione può andare a capo
///   (basta che ci stia la parola più lunga) e un testo libero lungo pure
///   (oltre [_larghezzaComodaColonna] va a capo senza danno), quindi qui i
///   contenuti lunghi non pesano quanto nella larghezza ideale.
({List<double> ideali, List<double> minime}) _misureColonne({
  required List<String> colonne,
  required List<List<CellaPdf>> righe,
  required PdfFont normale,
  required PdfFont grassetto,
}) {
  final ideali = <double>[];
  final minime = <double>[];
  for (var i = 0; i < colonne.length; i++) {
    final contenuto = righe.fold(
      0.0,
      (larghezza, riga) => math.max(
        larghezza,
        _larghezzaTesto(riga[i].testo, riga[i].grassetto ? grassetto : normale),
      ),
    );
    final intestazione = _larghezzaTesto(colonne[i], grassetto);
    final parolaPiuLunga = colonne[i]
        .split(RegExp(r'\s+'))
        .fold(0.0, (l, p) => math.max(l, _larghezzaTesto(p, grassetto)));

    ideali.add(
      _limita(math.max(contenuto, intestazione) + _spazioCella,
          massimo: _larghezzaMassimaColonna),
    );
    minime.add(
      _limita(
        math.max(parolaPiuLunga, math.min(contenuto, _larghezzaComodaColonna)) +
            _spazioCella,
        massimo: _larghezzaComodaColonna + _spazioCella,
      ),
    );
  }
  return (ideali: ideali, minime: minime);
}

double _limita(double larghezza, {required double massimo}) =>
    math.min(massimo, math.max(_larghezzaMinimaColonna, larghezza));

/// Larghezza del testo alla dimensione usata nelle celle, misurata sul font
/// reale del PDF. Un testo su più righe conta per la sua riga più lunga.
double _larghezzaTesto(String testo, PdfFont font) {
  var larghezza = 0.0;
  for (final riga in testo.split('\n')) {
    try {
      final metriche = font.stringMetrics(riga);
      larghezza = math.max(
        larghezza,
        math.max(metriche.advanceWidth, metriche.width) * _dimensioneTesto,
      );
    } catch (_) {
      // Caratteri fuori dal set Latin-1 (che il font standard non sa
      // misurare): stima grossolana, serve solo a scegliere la larghezza.
      larghezza = math.max(larghezza, riga.length * _dimensioneTesto * 0.55);
    }
  }
  return larghezza;
}

String _nomeFile(String titolo) => titolo
    .toLowerCase()
    .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
    .replaceAll(RegExp(r'^_|_$'), '');

pw.Widget _intestazione({
  required pw.Context context,
  required String titolo,
  required String? sottotitolo,
  required pw.MemoryImage? logo,
}) {
  final primaPagina = context.pageNumber == 1;
  return pw.Container(
    margin: const pw.EdgeInsets.only(bottom: 10),
    padding: const pw.EdgeInsets.only(bottom: 6),
    decoration: const pw.BoxDecoration(
      border: pw.Border(bottom: pw.BorderSide(color: _blu, width: 1)),
    ),
    child: pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        if (logo != null && primaPagina) ...[
          pw.Image(logo, height: 34),
          pw.SizedBox(width: 12),
        ],
        pw.Expanded(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                titolo,
                style: pw.TextStyle(
                  fontSize: primaPagina ? 18 : 12,
                  fontWeight: pw.FontWeight.bold,
                  color: _blu,
                ),
              ),
              if (sottotitolo != null && primaPagina) ...[
                pw.SizedBox(height: 2),
                pw.Text(
                  sottotitolo,
                  style: const pw.TextStyle(
                    fontSize: 9,
                    color: PdfColors.grey700,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    ),
  );
}

pw.Widget _piePagina(pw.Context context, String generatoIl) {
  return pw.Container(
    margin: const pw.EdgeInsets.only(top: 8),
    child: pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(
          'Generato il $generatoIl',
          style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey700),
        ),
        pw.Text(
          'Pagina ${context.pageNumber} di ${context.pagesCount}',
          style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey700),
        ),
      ],
    ),
  );
}

pw.Widget _tabella({
  required List<String> colonne,
  required List<List<CellaPdf>> righe,
  required List<double> larghezze,
}) {
  return pw.Table(
    border: pw.TableBorder.all(color: _grigioBordo, width: 0.5),
    columnWidths: {
      for (var i = 0; i < colonne.length; i++) i: pw.FlexColumnWidth(larghezze[i]),
    },
    children: [
      pw.TableRow(
        // Ripete l'intestazione in cima a ogni pagina, come il blocco titoli
        // di un foglio Excel.
        repeat: true,
        verticalAlignment: pw.TableCellVerticalAlignment.middle,
        decoration: const pw.BoxDecoration(color: _blu),
        children: [
          for (final colonna in colonne)
            _cella(
              colonna,
              stile: pw.TextStyle(
                fontSize: _dimensioneTesto,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.white,
              ),
            ),
        ],
      ),
      for (var i = 0; i < righe.length; i++)
        pw.TableRow(
          // Testo centrato in verticale: nelle righe in cui una cella va a
          // capo le altre restano allineate a metà altezza.
          verticalAlignment: pw.TableCellVerticalAlignment.middle,
          decoration: i.isOdd
              ? const pw.BoxDecoration(color: _grigioRiga)
              : null,
          children: [
            for (final cella in righe[i])
              _cella(
                cella.testo.isEmpty ? '-' : cella.testo,
                stile: pw.TextStyle(
                  fontSize: _dimensioneTesto,
                  color: cella.colore,
                  fontWeight: cella.grassetto
                      ? pw.FontWeight.bold
                      : pw.FontWeight.normal,
                ),
              ),
          ],
        ),
    ],
  );
}

/// Cella alta almeno [_altezzaRiga], con il testo a sinistra e centrato in
/// verticale.
pw.Widget _cella(String testo, {required pw.TextStyle stile}) {
  return pw.Container(
    constraints: const pw.BoxConstraints(minHeight: _altezzaRiga),
    alignment: pw.Alignment.centerLeft,
    padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 3),
    child: pw.Text(testo, style: stile),
  );
}
