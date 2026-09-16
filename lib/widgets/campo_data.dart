import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../l10n/app_localizations.dart';

final dateFormat = DateFormat('dd/MM/yyyy');

/// Anni accettati da un campo data: fuori da questo intervallo si tratta quasi
/// sempre di un errore di battitura sull'anno (es. 30/05/0226 invece di 2026).
const annoMinimo = 1900;
int annoMassimo() => DateTime.now().year + 30;

final _formaCompleta = RegExp(r'^\d{2}/\d{2}/\d{4}$');

/// Legge una data scritta a mano come gg/mm/aaaa; null se incompleta o
/// inesistente (parseStrict rifiuta anche i giorni fuori mese, es. 31/02/2026).
/// Il controllo sulla forma serve perché parseStrict accetterebbe anche un anno
/// a metà, leggendo 30/05/202 come l'anno 202.
DateTime? parseDataItaliana(String value) {
  final testo = value.trim();
  if (!_formaCompleta.hasMatch(testo)) return null;
  try {
    return dateFormat.parseStrict(testo);
  } catch (_) {
    return null;
  }
}

String formattaData(DateTime? data) => data == null ? '' : dateFormat.format(data);

/// Messaggio d'errore per una data digitata, null se va bene (vuoto compreso).
String? validaData(
  String? value,
  AppLocalizations l10n, {
  int primoAnno = annoMinimo,
  int? ultimoAnno,
}) {
  if (value == null || value.trim().isEmpty) return null;
  final data = parseDataItaliana(value);
  if (data == null) return l10n.campoDataInvalidDate;
  final max = ultimoAnno ?? annoMassimo();
  if (data.year < primoAnno || data.year > max) {
    return l10n.campoDataYearRange(primoAnno, max);
  }
  return null;
}

/// Inserisce le "/" mentre si digita: scrivendo 30052026 si ottiene 30/05/2026.
class DataInputFormatter extends TextInputFormatter {
  const DataInputFormatter();

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String soloCifre(String s) => s.replaceAll(RegExp(r'[^0-9]'), '');

    final cifre = soloCifre(newValue.text);
    final limitate = cifre.length > 8 ? cifre.substring(0, 8) : cifre;

    final buffer = StringBuffer();
    for (var i = 0; i < limitate.length; i++) {
      if (i == 2 || i == 4) buffer.write('/');
      buffer.write(limitate[i]);
    }
    final testo = buffer.toString();

    // Mantiene il cursore sulla stessa cifra anche dopo l'inserimento delle "/".
    final fineSelezione = newValue.selection.end.clamp(0, newValue.text.length);
    final cifrePrimaDelCursore = soloCifre(newValue.text.substring(0, fineSelezione)).length;
    final offset = cifrePrimaDelCursore +
        (cifrePrimaDelCursore > 2 ? 1 : 0) +
        (cifrePrimaDelCursore > 4 ? 1 : 0);

    return TextEditingValue(
      text: testo,
      selection: TextSelection.collapsed(offset: offset.clamp(0, testo.length)),
    );
  }
}

/// Campo data digitabile: le "/" compaiono da sole, quindi basta scrivere
/// 30052026 per ottenere 30/05/2026. Resta comunque disponibile il calendario.
///
/// [onChanged] riceve null finché la data non è completa e valida.
/// [onRimuovi], se presente, sostituisce il pulsante "pulisci data" con uno che
/// toglie del tutto il campo dal form (usato per i campi opzionali).
class CampoData extends StatefulWidget {
  const CampoData({
    super.key,
    required this.label,
    required this.valore,
    required this.onChanged,
    this.onRimuovi,
    this.tooltipRimuovi,
    this.primoAnno = annoMinimo,
    this.ultimoAnno,
  });

  final String label;
  final DateTime? valore;
  final ValueChanged<DateTime?> onChanged;
  final VoidCallback? onRimuovi;
  final String? tooltipRimuovi;
  final int primoAnno;
  final int? ultimoAnno;

  @override
  State<CampoData> createState() => _CampoDataState();
}

class _CampoDataState extends State<CampoData> {
  late final _controller = TextEditingController(text: formattaData(widget.valore));

  int get _ultimoAnno => widget.ultimoAnno ?? annoMassimo();

  @override
  void didUpdateWidget(CampoData oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_testoDaRiscrivere) return;
    // Il testo si riscrive a frame concluso: farlo qui notificherebbe il
    // TextFormField mentre il Form attorno si sta già costruendo, e il
    // Form.setState che ne segue farebbe scattare l'assert del framework.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_testoDaRiscrivere) return;
      _controller.text = formattaData(widget.valore);
    });
  }

  /// Vero quando la data arrivata da fuori (es. una scadenza calcolata in
  /// automatico) non è quella già presente nel campo. Finché si sta scrivendo
  /// una data incompleta il testo resta com'è, per non disturbare.
  bool get _testoDaRiscrivere {
    final dataNelCampo = parseDataItaliana(_controller.text);
    if (widget.valore == null && dataNelCampo == null) return false;
    if (widget.valore != null &&
        dataNelCampo != null &&
        formattaData(widget.valore) == formattaData(dataNelCampo)) {
      return false;
    }
    return true;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _apriCalendario() async {
    final now = DateTime.now();
    final selezionata = await showDatePicker(
      context: context,
      initialDate: parseDataItaliana(_controller.text) ?? now,
      firstDate: DateTime(widget.primoAnno),
      lastDate: DateTime(_ultimoAnno, 12, 31),
      initialEntryMode: DatePickerEntryMode.input,
    );
    if (selezionata == null) return;
    _controller.text = formattaData(selezionata);
    widget.onChanged(selezionata);
  }

  @override
  Widget build(BuildContext context) {
    final primaryBlue = Theme.of(context).primaryColor;
    final l10n = AppLocalizations.of(context)!;
    return TextFormField(
      controller: _controller,
      keyboardType: TextInputType.number,
      inputFormatters: const [DataInputFormatter()],
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: l10n.campoDataFormatHint,
        suffixIcon: ValueListenableBuilder<TextEditingValue>(
          valueListenable: _controller,
          builder: (context, valore, _) => Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.onRimuovi != null)
                IconButton(
                  icon: Icon(Icons.delete_outline, color: Colors.redAccent, size: 18),
                  tooltip: widget.tooltipRimuovi ?? l10n.campoDataRemoveFieldTooltip,
                  onPressed: widget.onRimuovi,
                )
              else if (valore.text.isNotEmpty)
                IconButton(
                  icon: Icon(Icons.clear, color: Colors.redAccent, size: 18),
                  tooltip: l10n.campoDataClearDateTooltip,
                  onPressed: () {
                    _controller.clear();
                    widget.onChanged(null);
                  },
                ),
              IconButton(
                icon: Icon(Icons.calendar_today, color: primaryBlue, size: 18),
                tooltip: l10n.campoDataPickDateTooltip,
                onPressed: _apriCalendario,
              ),
            ],
          ),
        ),
      ),
      validator: (v) => validaData(v, l10n, primoAnno: widget.primoAnno, ultimoAnno: _ultimoAnno),
      onChanged: (v) => widget.onChanged(parseDataItaliana(v)),
    );
  }
}
