import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../l10n/app_localizations.dart';
import '../models/cantiere.dart';
import '../providers/cantieri_provider.dart';
import 'app_bar.dart';
import 'confirm_dialog.dart';
import 'modifica_scadenza_cantiere_dialog.dart';
import 'stato_badge.dart';

final _dateFormat = DateFormat('dd/MM/yyyy');

/// Riga di una scadenza generale del cantiere (messa a terra o generica), con
/// gli stessi comandi di [DocumentoTile]: modifica e eliminazione della
/// scadenza, raccolti in un menu sul mobile.
class ScadenzaCantiereTile extends StatelessWidget {
  const ScadenzaCantiereTile({
    super.key,
    required this.cantiere,
    required this.cantieriProvider,
    required this.campo,
    required this.etichetta,
    required this.data,
    this.nascondiStato = false,
  });

  final Cantiere cantiere;
  final CantieriProvider cantieriProvider;

  /// Nome stabile del campo ("scadenza_messa_a_terra", "scadenza_generica1",
  /// ...), non l'etichetta visualizzata.
  final String campo;
  final String etichetta;
  final DateTime data;
  final bool nascondiStato;

  Future<void> _modifica(BuildContext context) => showModificaScadenzaCantiereDialog(
        context,
        provider: cantieriProvider,
        cantiere: cantiere,
        campo: campo,
        etichetta: etichetta,
        data: data,
      );

  Future<void> _confermaElimina(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final confermato = await showConfirmDialog(
      context,
      title: l10n.scadenzaCantiereTileConfirmDeleteTitle,
      message: l10n.scadenzaCantiereTileConfirmDeleteMessage(etichetta, cantiere.nome),
    );
    if (!confermato) return;
    try {
      await cantieriProvider.eliminaScadenzaGenerale(cantiere, campo);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(l10n.commonErrorWithDetails(e.toString()))));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < kMobileAppBarBreakpoint;
    final primaryBlue = Theme.of(context).colorScheme.primary;
    final l10n = AppLocalizations.of(context)!;
    final iconSize = isMobile ? 18.0 : 22.0;
    final commento = cantiere.commentiScadenze[campo] ?? '';

    return ListTile(
      leading: nascondiStato
          ? null
          : StatoBadge(stato: computeStato(data), showLabel: false),
      title: Text(etichetta),
      subtitle: Text([
        l10n.scadenzaCantiereTileDueDate(_dateFormat.format(data)),
        if (commento.isNotEmpty) l10n.scadenzaCantiereTileNotesLine(commento),
      ].join(' · ')),
      trailing: isMobile
          ? PopupMenuButton<VoidCallback>(
              icon: Icon(Icons.more_vert, color: primaryBlue, size: iconSize),
              borderRadius: BorderRadius.circular(15),
              onSelected: (azione) => azione(),
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: () => _modifica(context),
                  child: Text(l10n.scadenzaCantiereTileEditTooltip),
                ),
                PopupMenuItem(
                  value: () => _confermaElimina(context),
                  child: Text(l10n.scadenzaCantiereTileDeleteTooltip),
                ),
              ],
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit_calendar_outlined, color: primaryBlue, size: iconSize),
                  tooltip: l10n.scadenzaCantiereTileEditTooltip,
                  onPressed: () => _modifica(context),
                ),
                IconButton(
                  icon: Icon(Icons.delete_outline, color: primaryBlue, size: iconSize),
                  tooltip: l10n.scadenzaCantiereTileDeleteTooltip,
                  onPressed: () => _confermaElimina(context),
                ),
              ],
            ),
    );
  }
}
