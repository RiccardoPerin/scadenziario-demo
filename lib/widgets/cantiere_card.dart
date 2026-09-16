import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../l10n/app_localizations.dart';
import 'stato_badge.dart';

final _dateFormat = DateFormat('dd/MM/yyyy');

String _formatData(String value) {
  final parsed = DateTime.tryParse(value);
  return parsed == null ? value : _dateFormat.format(parsed);
}

class CantiereCard extends StatelessWidget {
  const CantiereCard({
    super.key,
    required this.nome,
    required this.comune,
    required this.stato,
    required this.numeroSubappaltatori,
    required this.numeroDocumentiInScadenza,
    required this.onTap,
    this.dataChiusura,
    this.statoCantiere,
    this.onEdit,
    this.onDelete,
  });

  final String nome;
  final String comune;
  final StatoScadenza stato;
  final int numeroSubappaltatori;
  final int numeroDocumentiInScadenza;
  final String? dataChiusura;
  final String? statoCantiere;
  final VoidCallback onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final primaryBlue = Theme.of(context).colorScheme.primary;
    final cardColor = (statoCantiere == 'sospeso' || statoCantiere == 'concluso') ? Colors.grey : primaryBlue;
    return Card(
      color: cardColor,
      elevation: 8,
      shadowColor: cardColor.withValues(alpha: 0.4),
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          nome,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (statoCantiere != 'concluso') ...[
                        const SizedBox(width: 10),
                        StatoBadge(stato: stato, showLabel: statoCantiere != 'sospeso'),
                      ],
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (comune.isNotEmpty)
                    Text(
                      comune,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: Colors.white70),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  if (dataChiusura != null && dataChiusura!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        l10n.cantiereCardClosedOn(_formatData(dataChiusura!)),
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: Colors.white70),
                      ),
                    ),
                  const Spacer(),
                  const Divider(color: Colors.white24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.groups_outlined, size: 16, color: Colors.white),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                l10n.cantiereCardSubappaltatoriCount(numeroSubappaltatori),
                                style: const TextStyle(color: Colors.white),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10,),
                      if (numeroDocumentiInScadenza > 0)
                        Flexible(
                          child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.warning_amber_rounded,
                                size: 16,
                                color: stato == StatoScadenza.scaduto
                                    ? Colors.redAccent
                                    : Colors.amber[800]),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                l10n.cantiereCardExpiringCount(numeroDocumentiInScadenza),
                                style: const TextStyle(color: Colors.white),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (statoCantiere == 'sospeso')
            Positioned(
              bottom: 55,
              left: 20,
              child: Text(
                l10n.cantiereCardSuspendedLabel,
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          if (onEdit != null || onDelete != null)
            Positioned(
              bottom: 45,
              right: 4,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (onEdit != null)
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, color: Colors.white, size: 20),
                      tooltip: l10n.cantiereCardEditTooltip,
                      splashRadius: 20,
                      onPressed: onEdit,
                    ),
                  if (onDelete != null)
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.white, size: 20),
                      tooltip: l10n.cantiereCardDeleteTooltip,
                      splashRadius: 20,
                      onPressed: onDelete,
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
