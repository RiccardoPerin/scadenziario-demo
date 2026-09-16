import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/documento.dart';
import '../providers/documenti_provider.dart';
import 'app_bar.dart';
import 'confirm_dialog.dart';
import 'modifica_scadenza_documento_dialog.dart';
import 'stato_badge.dart';
import 'voce_info.dart';

class DocumentoTile extends StatelessWidget {
  const DocumentoTile({
    super.key,
    required this.documento,
    required this.documentiProvider,
    this.condiviso = false,
    this.nascondiStato = false,
    this.dipendenteNome,
    this.note,
  });

  final Documento documento;
  final DocumentiProvider documentiProvider;
  final bool condiviso;
  final bool nascondiStato;
  final String? dipendenteNome;
  final String? note;

  Future<void> _confermaElimina(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final confermato = await showConfirmDialog(
      context,
      title: l10n.documentoTileDeleteConfirmTitle,
      message: l10n.documentoTileDeleteConfirmMessage(
        documento.tipoDocumentoNome ?? l10n.documentoTileDefaultDocumentName,
      ),
    );
    if (confermato) await documentiProvider.deleteConStorico(documento);
  }

  Future<void> _modifica(BuildContext context) => showModificaScadenzaDocumentoDialog(
        context,
        documentiProvider: documentiProvider,
        documento: documento,
      );

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final stato = computeStato(documento.dataScadenza, giorniPreavviso: documento.giorniPreavviso);
    final dataScadenza = documento.dataScadenza;
    final isMobile = MediaQuery.sizeOf(context).width < kMobileAppBarBreakpoint;
    final primaryBlue = Theme.of(context).colorScheme.primary;
    final iconSize = isMobile ? 18.0 : 22.0;

    return ListTile(
      leading: nascondiStato ? null : StatoBadge(stato: stato, showLabel: !isMobile),
      title: Row(
        children: [
          Flexible(
            child: Text(
              '${documento.tipoDocumentoNome}', 
              style: TextStyle(
                fontWeight: stato == StatoScadenza.scaduto ? FontWeight.w600 : FontWeight.w500,
                color: stato == StatoScadenza.scaduto 
                    ? Colors.redAccent 
                    : stato == StatoScadenza.inScadenza
                        ? Colors.amber[800]
                        : Colors.black 
              ),
            )
          ),
          if (condiviso) ...[
            const SizedBox(width: 8),
            Text(l10n.documentoTileSharedSuffix,
                style: TextStyle(fontSize: 12, color: primaryBlue, fontWeight: FontWeight.w500)),
          ],
          if (dipendenteNome != null) ...[
            Text(dipendenteNome!),
          ],
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (dataScadenza != null)
            VoceInfo(l10n.documentoTileLabelScadenza, '${dataScadenza.day}/${dataScadenza.month}/${dataScadenza.year}')
          else
            VoceInfo(l10n.documentoTileLabelScadenza, l10n.documentoTileNotRequired),
          if (documento.note != '') VoceInfo(l10n.documentoTileLabelNota, documento.note),
        ],
      ),
      trailing: isMobile
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                PopupMenuButton<VoidCallback>(
                  icon: Icon(Icons.more_vert, color: primaryBlue, size: iconSize),
                  borderRadius: BorderRadius.circular(15),
                  onSelected: (azione) => azione(),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: () => _modifica(context),
                      child: Text(l10n.documentoTileEditDeadline),
                    ),
                    PopupMenuItem(
                      value: () => _confermaElimina(context),
                      child: Text(l10n.documentoTileDeleteDeadline),
                    ),
                  ],
                ),
              ],
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit_calendar_outlined, color: primaryBlue, size: iconSize),
                  tooltip: l10n.documentoTileEditDeadline,
                  onPressed: () => _modifica(context),
                ),
                IconButton(
                  icon: Icon(Icons.delete_outline, color: primaryBlue, size: iconSize),
                  tooltip: l10n.documentoTileDeleteDeadline,
                  onPressed: () => _confermaElimina(context),
                ),
              ],
            ),
    );
  }
}
