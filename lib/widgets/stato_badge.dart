import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';

enum StatoScadenza { valido, inScadenza, scaduto }

/// Calcola lo stato di scadenza al volo (mai salvato come campo, vedi
/// sezione 4.1 del piano). [giorniPreavviso] sono le soglie configurate sul
/// tipo di documento (es. [30, 15, 7, 1]); se vuote si usa una soglia di 30gg.
StatoScadenza computeStato(DateTime? dataScadenza, {List<int> giorniPreavviso = const []}) {
  if (dataScadenza == null) return StatoScadenza.valido;

  final oggi = DateTime.now();
  final oggiSenzaOra = DateTime(oggi.year, oggi.month, oggi.day);
  final scadenzaSenzaOra =
      DateTime(dataScadenza.year, dataScadenza.month, dataScadenza.day);
  final giorniRimanenti = scadenzaSenzaOra.difference(oggiSenzaOra).inDays;

  if (giorniRimanenti < 0) return StatoScadenza.scaduto;

  final soglia = giorniPreavviso.isEmpty
      ? 30
      : giorniPreavviso.reduce((a, b) => a > b ? a : b);

  if (giorniRimanenti <= soglia) return StatoScadenza.inScadenza;
  return StatoScadenza.valido;
}

class StatoBadge extends StatelessWidget {
  const StatoBadge({
    super.key,
    required this.stato,
    this.label,
    this.showLabel = true,
    this.colorOverride,
  });

  final StatoScadenza stato;
  final String? label;
  final bool showLabel;

  /// Colore da usare al posto di quello standard associato a [stato] (es. per
  /// distinguere, nel drawer, i DPI mai assegnati da quelli realmente scaduti).
  final Color? colorOverride;

  Color get _colore {
    if (colorOverride != null) return colorOverride!;
    switch (stato) {
      case StatoScadenza.valido:
        return Colors.green;
      case StatoScadenza.inScadenza:
        return Colors.amber.shade800;
      case StatoScadenza.scaduto:
        return Colors.red;
    }
  }

  String _testo(AppLocalizations l10n) {
    if (label != null) return label!;
    switch (stato) {
      case StatoScadenza.valido:
        return l10n.statoBadgeValido;
      case StatoScadenza.inScadenza:
        return l10n.statoBadgeInScadenza;
      case StatoScadenza.scaduto:
        return l10n.statoBadgeScaduto;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!showLabel) {
      return Container(
        width: 16,
        height: 16,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _colore.withValues(alpha: 0.15),
          border: Border.all(color: _colore, width: 2),
        ),
      );
    }
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _colore.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _colore),
      ),
      child: Text(
        _testo(l10n),
        style: TextStyle(color: _colore, fontWeight: FontWeight.w600, fontSize: 12),
      ),
    );
  }
}
