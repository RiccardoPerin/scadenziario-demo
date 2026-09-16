import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';

void showInfoDialog(
  BuildContext context, {
  required Widget title,
  required Widget message,
}) {
  showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: title,
      content: message,
    ),
  );
}

/// Dialog informativo su come bloccare l'invio automatico delle email di
/// scadenza tramite la nota scadenza, condiviso tra le varie schermate.
void showNoteScadenzaInfoDialog(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  final primaryBlue = Theme.of(context).colorScheme.primary;
  showInfoDialog(
    context,
    title: RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: Theme.of(context).textTheme.titleLarge,
        children: [
          TextSpan(text: l10n.infoDialogNoteScadenzaTitle),
        ],
      ),
    ),
    message: RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: Theme.of(context).textTheme.bodyMedium,
        children: [
          TextSpan(text: l10n.infoDialogNoteScadenzaIntro),
          // Le parole "Prenotato/a" e "Ordinato/i" restano in italiano anche
          // nella versione inglese: sono le parole chiave riconosciute dal
          // sistema di invio email, non testo descrittivo da tradurre.
          TextSpan(
            text: 'Prenotato/a',
            style: TextStyle(
              fontStyle: FontStyle.italic,
              color: primaryBlue,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(text: l10n.infoDialogNoteScadenzaOr),
          TextSpan(
            text: 'Ordinato/i',
            style: TextStyle(
              fontStyle: FontStyle.italic,
              color: primaryBlue,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
            text: l10n.infoDialogNoteScadenzaOutro,
          ),
        ],
      ),
    ),
  );
}

/// Dialog informativo su come bloccare l'invio automatico delle email di
/// scadenza tramite la nota scadenza, condiviso tra le varie schermate.
void showEmailScadenzaInfoDialog(BuildContext context, String title) {
  final l10n = AppLocalizations.of(context)!;
  final primaryBlue = Theme.of(context).colorScheme.primary;
  showInfoDialog(
    context,
    title: RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: Theme.of(context).textTheme.titleLarge,
        children: [
          TextSpan(text: l10n.infoDialogEmailScadenzaTitle),
        ],
      ),
    ),
    message: RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: Theme.of(context).textTheme.bodyMedium,
        children: [
          TextSpan(text: l10n.infoDialogEmailScadenzaIntro),
          TextSpan(
            text: title,
            style: TextStyle(
              fontStyle: FontStyle.italic,
              color: primaryBlue,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(text: l10n.infoDialogEmailScadenzaMiddle),
          TextSpan(
            text: l10n.infoDialogEmailScadenzaPageName,
            style: TextStyle(
              fontStyle: FontStyle.italic,
              color: primaryBlue,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
            text: l10n.infoDialogEmailScadenzaOutro,
          ),
        ],
      ),
    ),
  );
}
