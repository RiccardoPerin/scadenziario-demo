import 'package:flutter/material.dart';

/// Riga "Etichetta: valore" delle schede informative (dettaglio cantiere,
/// subappaltatore, dipendente...), con l'etichetta in grassetto e il valore
/// in tondo. Il testo è uno solo, così etichetta e valore vanno a capo
/// insieme invece di spezzarsi su due widget affiancati.
///
/// [valoreSecondario], se presente, viene accodato dopo una virgola: serve
/// per i valori che si leggono come una cosa sola (es. indirizzo e comune).
///
/// Il colore è quello delle informazioni secondarie del tema
/// (`colorScheme.onSurfaceVariant`), lo stesso che Material dà da solo al
/// `subtitle` di una [ListTile]: così le voci hanno lo stesso grigio in tutta
/// l'app, dentro e fuori dalle [ListTile]. Per un colore diverso su una
/// singola voce bastano [stileEtichetta] e [stileValore], che vincono su
/// quello di base.
///
/// [stileValore], se presente, viene applicato al solo valore (e al
/// [valoreSecondario]): serve ad esempio per colorare in giallo o rosso le
/// scadenze imminenti. Se omesso il valore resta com'è, in tondo.
///
/// [stileEtichetta] fa lo stesso per l'etichetta: viene fuso sopra al
/// grassetto di base, così indicando solo il colore il grassetto resta
/// (per toglierlo basta passare un [TextStyle] con un `fontWeight` diverso).
///
/// [maxLines], se presente, limita le righe e manda il testo in ellissi:
/// serve dove la voce sta in uno spazio di altezza fissa (es. l'intestazione
/// delle card) e andare a capo la farebbe traboccare.
class VoceInfo extends StatelessWidget {
  const VoceInfo(
    this.etichetta,
    this.valore, {
    this.valoreSecondario,
    this.stileEtichetta,
    this.stileValore,
    this.maxLines,
    super.key,
  });

  final String etichetta;
  final String valore;
  final String? valoreSecondario;
  final TextStyle? stileEtichetta;
  final TextStyle? stileValore;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        children: [
          TextSpan(
            text: '$etichetta: ',
            style: const TextStyle(fontWeight: FontWeight.w700)
                .merge(stileEtichetta),
          ),
          TextSpan(text: valore, style: stileValore),
          if (valoreSecondario != null)
            TextSpan(text: ', $valoreSecondario', style: stileValore),
        ],
      ),
      maxLines: maxLines,
      overflow: maxLines == null ? TextOverflow.clip : TextOverflow.ellipsis,
    );
  }
}
