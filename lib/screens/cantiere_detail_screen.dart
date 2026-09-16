import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../models/cantiere.dart';
import '../providers/auth_provider.dart';
import '../providers/cantieri_provider.dart';
import '../providers/dipendenti_subappaltatori_provider.dart';
import '../providers/documenti_provider.dart';
import '../providers/subappaltatori_provider.dart';
import '../providers/tipi_scadenze_provider.dart';
import '../services/stato_scadenze.dart';
import '../widgets/app_bar.dart';
import '../widgets/breadcrumb_app_bar.dart';
import '../widgets/cantiere_form_dialog.dart';
import '../widgets/confirm_dialog.dart';
import '../widgets/dipendenti_presenti_dialog.dart';
import '../widgets/document_form_dialog.dart';
import '../widgets/documento_tile.dart';
import '../widgets/scadenza_cantiere_form_dialog.dart';
import '../widgets/scadenza_cantiere_tile.dart';
import '../widgets/stato_badge.dart';
import '../widgets/subappaltatore_form_dialog.dart';
import '../widgets/voce_info.dart';

final _dateFormat = DateFormat('dd/MM/yyyy');

String _formatData(String value, AppLocalizations l10n) {
  final parsed = DateTime.tryParse(value);
  return parsed == null ? l10n.cantiereDetailScreenNotSet : _dateFormat.format(parsed);
}

/// Icona "excavator" di Material Design Icons (`MdiIcons.excavator`).
///
/// Il codepoint e' scritto a mano invece di usare `MdiIcons.excavator`:
/// riferirsi alla classe `MdiIcons` tiene in vita tutte le sue costanti e
/// impedisce il tree-shaking del font (oltre 1 MB in piu' nel bundle web).
const IconData _iconaEscavatore = IconData(
  0xF1025,
  fontFamily: 'Material Design Icons',
  fontPackage: 'flutter_material_design_icons',
);

/// Escavatore attraversato da una barra diagonale: uscita da un cantiere.
class IconaRimuoviDaCantiere extends StatelessWidget {
  const IconaRimuoviDaCantiere({
    super.key,
    required this.color,
    this.size = 24,
    this.coloreSfondo,
  });

  final Color color;
  final double size;

  /// Colore dello sfondo su cui poggia l'icona: serve a creare lo stacco
  /// tra la barra e l'escavatore sottostante (come nelle icone "-off" di MDI).
  final Color? coloreSfondo;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: CustomPaint(
        foregroundPainter: _BarraDiagonalePainter(
          color: color,
          coloreSfondo: coloreSfondo ?? Theme.of(context).cardColor,
        ),
        child: Icon(_iconaEscavatore, size: size, color: color),
      ),
    );
  }
}

class _BarraDiagonalePainter extends CustomPainter {
  _BarraDiagonalePainter({required this.color, required this.coloreSfondo});

  final Color color;
  final Color coloreSfondo;

  @override
  void paint(Canvas canvas, Size size) {
    final spessore = size.shortestSide / 12;
    final inizio = Offset(size.width * 0.14, size.height * 0.14);
    final fine = Offset(size.width * 0.86, size.height * 0.86);

    // Prima la traccia nel colore dello sfondo, poi la barra vera e propria:
    // il risultato e' una barra staccata dal disegno dell'escavatore.
    final stacco = Paint()
      ..color = coloreSfondo
      ..strokeWidth = spessore * 2.6
      ..strokeCap = StrokeCap.round;
    final barra = Paint()
      ..color = color
      ..strokeWidth = spessore
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(inizio, fine, stacco);
    canvas.drawLine(inizio, fine, barra);
  }

  @override
  bool shouldRepaint(_BarraDiagonalePainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.coloreSfondo != coloreSfondo;
}

class CantiereDetailScreen extends StatelessWidget {
  const CantiereDetailScreen({super.key, required this.cantiereId});

  final String cantiereId;

  @override
  Widget build(BuildContext context) {
    final primaryBlue = Theme.of(context).primaryColor;
    final isMobile = MediaQuery.sizeOf(context).width < kMobileAppBarBreakpoint;
    final l10n = AppLocalizations.of(context)!;
    final cantieriProvider = context.watch<CantieriProvider>();
    final subappaltatoriProvider = context.watch<SubappaltatoriProvider>();
    final documentiProvider = context.watch<DocumentiProvider>();
    final tipiScadenzeProvider = context.watch<TipiScadenzeProvider>();
    final dipendentiProvider = context.watch<DipendentiSubappaltatoriProvider>();
    final authProvider = context.watch<AuthProvider>();

    final candidati = cantieriProvider.cantieri.where((c) => c.id == cantiereId);
    if (candidati.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final Cantiere cantiere = candidati.first;

    final documentiCantiere = documentiPerUrgenza(
      documentiProvider.soloUltimaVersione(documentiProvider.perCantiere(cantiereId)),
    );
    final subappaltatori = subappaltatoriProvider.perCantiere(cantiereId);
    final scadenzeGenerali = scadenzeGeneraliCantiere(cantiere);

    return Scaffold(
      appBar: BreadcrumbAppBar(
        items: [
          BreadcrumbItem(label: l10n.cantiereDetailScreenBreadcrumbSites, onTap: () => context.go('/cantieri')),
          BreadcrumbItem(label: cantiere.nome),
        ],
        actions: [
          if (cantiere.stato == 'concluso')
            AppBarAction(
              icon: Icons.delete_forever_outlined,
              label: l10n.cantiereDetailScreenDeleteDataAction,
              color: Colors.red,
              onPressed: () async {
                final confermato = await showConfirmDialog(
                  context,
                  title: l10n.cantiereDetailScreenConfirmDeleteTitle,
                  message: l10n.cantiereDetailScreenConfirmDeleteMessage(cantiere.nome),
                );
                if (confermato) {
                  await documentiProvider.deletePerCantiere(cantiere.id);
                }
              },
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 5, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(l10n.cantiereDetailScreenInfoSectionTitle, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18, color: primaryBlue)),
                      IconButton(
                        icon: Icon(Icons.edit, color: primaryBlue, size: isMobile ? 18 : 22),
                        onPressed: () => showCantiereFormDialog(
                          context,
                          provider: cantieriProvider,
                          esistente: cantiere,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  VoceInfo(l10n.cantiereDetailScreenAddressLabel, cantiere.indirizzo, valoreSecondario: cantiere.comune),
                  if (cantiere.cap.isNotEmpty) VoceInfo(l10n.cantiereDetailScreenPostalCodeLabel, cantiere.cap),
                  VoceInfo(l10n.cantiereDetailScreenStartDateLabel, _formatData(cantiere.dataInizio, l10n)),
                  if (cantiere.stato == 'concluso' || cantiere.stato == 'sospeso')
                    VoceInfo(
                      cantiere.stato == 'sospeso'
                          ? l10n.cantiereDetailScreenSuspensionDateLabel
                          : l10n.cantiereDetailScreenEndDateLabel,
                      _formatData(cantiere.dataFine, l10n),
                    ),
                  if (cantiere.note.isNotEmpty) ...[
                    VoceInfo(l10n.commonNoteLabel, cantiere.note)
                  ],
                ],
              ),
            ),
          ),  
          const SizedBox(height: 24),
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            runSpacing: 8,
            children: [
              Text(l10n.cantiereDetailScreenGeneralDeadlinesTitle, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18, color: primaryBlue)),
              TextButton.icon(
                icon: const Icon(Icons.add),
                label: Text(l10n.cantiereDetailScreenAddDeadlineLabel),
                onPressed: () => showScadenzaCantiereFormDialog(
                  context,
                  provider: cantieriProvider,
                  cantiere: cantiere,
                ),
              ),
            ],
          ),
          if (scadenzeGenerali.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(l10n.cantiereDetailScreenNoGeneralDeadlines),
            )
          else
            Card(
              child: Column(
                children: [
                  ...ListTile.divideTiles(
                      context: context,
                      color: Colors.blueGrey.shade200,
                      tiles: scadenzeGenerali.map((s) => ScadenzaCantiereTile(
                        cantiere: cantiere,
                        cantieriProvider: cantieriProvider,
                        campo: s.campo,
                        etichetta: s.etichetta,
                        data: s.data,
                        nascondiStato: cantiere.stato == 'concluso',
                      ))
                    )
                ]
              ),
            ),
          const SizedBox(height: 32),
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            runSpacing: 8,
            children: [
              Text(l10n.cantiereDetailScreenDeadlinesTitle, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18, color: primaryBlue)),
              TextButton.icon(
                icon: const Icon(Icons.add),
                label: Text(l10n.cantiereDetailScreenAddDeadlineLabel),
                onPressed: () => showDocumentFormDialog(
                  context,
                  documentiProvider: documentiProvider,
                  tipiScadenzeProvider: tipiScadenzeProvider,
                  caricatoDaId: authProvider.currentUser?.id ?? '',
                  cantiereId: cantiereId,
                ),
              ),
            ],
          ),
          if (documentiCantiere.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(l10n.cantiereDetailScreenNoDeadlines),
            )
          else
            Card(
              child: Column(
                children: ListTile.divideTiles(
                  context: context,
                  color: Colors.grey.shade300,
                  tiles: documentiCantiere.map((d) => DocumentoTile(
                    documento: d, 
                    documentiProvider: documentiProvider
                  ))
                ).toList(),
              ),
            ),
          const SizedBox(height: 32),
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            runSpacing: 8,
            children: [
              Text(l10n.cantiereDetailScreenSubcontractorsTitle, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18, color: primaryBlue)),
              TextButton.icon(
                icon: const Icon(Icons.add),
                label: Text(l10n.cantiereDetailScreenAddSubcontractorLabel),
                onPressed: () => showSubappaltatoreFormDialog(
                  context,
                  provider: subappaltatoriProvider,
                  tuttiCantieri: cantieriProvider.cantieri,
                  cantierePreselezionato: cantiereId,
                ),
              ),
            ],
          ),
          if (subappaltatori.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(l10n.cantiereDetailScreenNoSubcontractors),
            )
          else
            ...subappaltatori.map(
              (s) {
              final dipendentiDelSub = dipendentiProvider
                  .perSubappaltatore(s.id)
                  .where((d) => d.cantieriIds.contains(cantiereId))
                  .toList();
              final numeroDipendenti = dipendentiDelSub.length;
              final documentiSubappaltatore = documentiProvider.soloUltimaVersione([
                ...documentiProvider.perSubappaltatore(cantiereId, s.id),
                ...documentiProvider.perDipendenti(dipendentiDelSub.map((d) => d.id).toList()),
              ]);
              final peggiore = documentiSubappaltatore.fold<StatoScadenza>(
                StatoScadenza.valido,
                (acc, d) {
                  final stato = computeStato(d.dataScadenza, giorniPreavviso: d.giorniPreavviso);
                  if (stato == StatoScadenza.scaduto) return StatoScadenza.scaduto;
                  if (stato == StatoScadenza.inScadenza && acc == StatoScadenza.valido) {
                    return StatoScadenza.inScadenza;
                  }
                  return acc;
                },
              );
              return Card(
                child: ListTile(
                  leading: (cantiere.stato == 'concluso')
                      ? null
                      : StatoBadge(stato: peggiore, showLabel: false),
                  title: Text(s.ragioneSociale, style: TextStyle(fontWeight: FontWeight.w600),),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      VoceInfo(l10n.cantiereDetailScreenEmployeesPresentLabel, numeroDipendenti > 0 ? numeroDipendenti.toString() : l10n.cantiereDetailScreenNoneValue),
                      if (s.note != '') VoceInfo(l10n.commonNoteLabel, s.note)
                    ],
                  ),

                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.person_outline, color: primaryBlue, size: isMobile ? 18 : 22),
                        tooltip: l10n.cantiereDetailScreenEmployeesPresentTooltip,
                        onPressed: () => showDipendentiPresentiDialog(
                          context,
                          dipendentiProvider: dipendentiProvider,
                          subappaltatoreId: s.id,
                          subappaltatoreNome: s.ragioneSociale,
                          cantiereId: cantiereId,
                        ),
                      ),
                      IconButton(
                        icon: IconaRimuoviDaCantiere(color: primaryBlue, size: isMobile ? 18 : 22),
                        tooltip: l10n.cantiereDetailScreenRemoveFromSiteTooltip,
                        onPressed: () async {
                          final confermato = await showConfirmDialog(
                            context,
                            title: l10n.cantiereDetailScreenConfirmRemoveTitle,
                            message: l10n.cantiereDetailScreenConfirmRemoveMessage(s.ragioneSociale),
                          );
                          if (confermato) {
                            await subappaltatoriProvider.removeCantiereFromSubappaltatore(
                              s.id,
                              cantiereId,
                            );
                            await dipendentiProvider.rimuoviCantiereDaiDipendentiDiSubappaltatore(
                              s.id,
                              cantiereId,
                            );
                          }
                        },
                      ),
                      Icon(Icons.chevron_right, color: primaryBlue, size: isMobile ? 18 : 22),
                    ],
                  ),
                  onTap: () => context.push('/cantieri/$cantiereId/subappaltatori/${s.id}'),
                ),
              );
            }),
        ],
      ),
    );
  }
}
