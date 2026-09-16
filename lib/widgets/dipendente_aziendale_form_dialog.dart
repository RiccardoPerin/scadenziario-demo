import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/dipendente_aziendale.dart';
import '../providers/dipendenti_aziendali_provider.dart';
import '../services/stato_scadenze.dart';
import 'campo_data.dart';

DateTime? _parseData(String value) => value.isEmpty ? null : DateTime.tryParse(value);

const mansioni = {
  'M01 - Impiegato': 'M01 - Impiegato',
  'M02 - Impiegato Tecnico': 'M02 - Impiegato Tecnico',
  'M03 - Addetto Tecnico di Cantiere': 'M03 - Addetto Tecnico di Cantiere',
  'M04 - Addetto Operaio Edile/Muratore': 'M04 - Addetto Operaio Edile/Muratore',
  'Datore di Lavoro': 'Datore di Lavoro',
  'RLST': 'RLST',
  'RSPP': 'RSPP',
};

/// Nome visualizzato del corso [key]: il testo è puramente informativo, la
/// chiave che identifica il corso (e quindi lo stato attivo/non attivo) resta
/// sempre quella interna in [chiaviCorsi].
String _corsoNome(AppLocalizations l10n, String key) {
  switch (key) {
    case 'primo_soccorso':
      return l10n.dipendenteAziendaleFormDialogCorsoPrimoSoccorsoNome;
    case 'antincendio':
      return l10n.dipendenteAziendaleFormDialogCorsoAntincendioNome;
    case 'preposto':
      return l10n.dipendenteAziendaleFormDialogCorsoPrepostoNome;
    case 'ponteggi':
      return l10n.dipendenteAziendaleFormDialogCorsoPonteggiNome;
    case 'lavori_quota':
      return l10n.dipendenteAziendaleFormDialogCorsoLavoriQuotaNome;
    case 'escavatori':
      return l10n.dipendenteAziendaleFormDialogCorsoEscavatoriNome;
    case 'gru_autocarro':
      return l10n.dipendenteAziendaleFormDialogCorsoGruAutocarroNome;
    case 'gru_torre':
      return l10n.dipendenteAziendaleFormDialogCorsoGruTorreNome;
    case 'piattaforme':
      return l10n.dipendenteAziendaleFormDialogCorsoPiattaformeNome;
    case 'carrello_elevatore':
      return l10n.dipendenteAziendaleFormDialogCorsoCarrelloElevatoreNome;
    case 'disocianati':
      return l10n.dipendenteAziendaleFormDialogCorsoDisocianatiNome;
    case 'scaffalature':
      return l10n.dipendenteAziendaleFormDialogCorsoScaffalatureNome;
    case 'formazione231':
      return l10n.dipendenteAziendaleFormDialogCorsoFormazione231Nome;
    case 'ambientale':
      return l10n.dipendenteAziendaleFormDialogCorsoAmbientaleNome;
    case 'rentri':
      return l10n.dipendenteAziendaleFormDialogCorsoRentriNome;
    case 'cronotachigrafico':
      return l10n.dipendenteAziendaleFormDialogCorsoCronotachigraficoNome;
  }
  return key;
}

/// Etichetta del campo data associato al corso [key] (vedi [_corsoNome]).
String _corsoEtichetta(AppLocalizations l10n, String key) {
  switch (key) {
    case 'primo_soccorso':
      return l10n.dipendenteAziendaleFormDialogCorsoPrimoSoccorsoEtichetta;
    case 'antincendio':
      return l10n.dipendenteAziendaleFormDialogCorsoAntincendioEtichetta;
    case 'preposto':
      return l10n.dipendenteAziendaleFormDialogCorsoPrepostoEtichetta;
    case 'ponteggi':
      return l10n.dipendenteAziendaleFormDialogCorsoPonteggiEtichetta;
    case 'lavori_quota':
      return l10n.dipendenteAziendaleFormDialogCorsoLavoriQuotaEtichetta;
    case 'escavatori':
      return l10n.dipendenteAziendaleFormDialogCorsoEscavatoriEtichetta;
    case 'gru_autocarro':
      return l10n.dipendenteAziendaleFormDialogCorsoGruAutocarroEtichetta;
    case 'gru_torre':
      return l10n.dipendenteAziendaleFormDialogCorsoGruTorreEtichetta;
    case 'piattaforme':
      return l10n.dipendenteAziendaleFormDialogCorsoPiattaformeEtichetta;
    case 'carrello_elevatore':
      return l10n.dipendenteAziendaleFormDialogCorsoCarrelloElevatoreEtichetta;
    case 'disocianati':
      return l10n.dipendenteAziendaleFormDialogCorsoDisocianatiEtichetta;
    case 'scaffalature':
      return l10n.dipendenteAziendaleFormDialogCorsoScaffalatureEtichetta;
    case 'formazione231':
      return l10n.dipendenteAziendaleFormDialogCorsoFormazione231Etichetta;
    case 'ambientale':
      return l10n.dipendenteAziendaleFormDialogCorsoAmbientaleEtichetta;
    case 'rentri':
      return l10n.dipendenteAziendaleFormDialogCorsoRentriEtichetta;
    case 'cronotachigrafico':
      return l10n.dipendenteAziendaleFormDialogCorsoCronotachigraficoEtichetta;
  }
  return key;
}

Future<void> showDipendenteAziendaleFormDialog(
  BuildContext context, {
  required DipendentiAziendaliProvider provider,
  required List<DipendenteAziendale> dipendenti,
  DipendenteAziendale? esistente,
}) {
  return showDialog(
    context: context,
    builder: (_) => _DipendenteAziendaleFormDialog(
      provider: provider,
      dipendenti: dipendenti,
      esistente: esistente,
    ),
  );
}

class _DipendenteAziendaleFormDialog extends StatefulWidget {
  const _DipendenteAziendaleFormDialog({
    required this.provider,
    required this.dipendenti,
    this.esistente,
  });

  final DipendentiAziendaliProvider provider;
  final List<DipendenteAziendale> dipendenti;
  final DipendenteAziendale? esistente;

  @override
  State<_DipendenteAziendaleFormDialog> createState() => _DipendenteAziendaleFormDialogState();
}

class _DipendenteAziendaleFormDialogState extends State<_DipendenteAziendaleFormDialog> {
  final _formKey = GlobalKey<FormState>();

  late final _nomeController =
      TextEditingController(text: widget.esistente?.nome ?? '');
  late final _cognomeController =
      TextEditingController(text: widget.esistente?.cognome ?? '');
  late final _codiceFiscaleController =
      TextEditingController(text: widget.esistente?.codiceFiscale ?? '');
  late final _luogoNascitaController =
      TextEditingController(text: widget.esistente?.luogoNascita ?? '');
  // L'età viene ricalcolata dalla data di nascita, così è già aggiornata anche
  // se il dipendente ha compiuto gli anni dopo l'ultimo salvataggio.
  late final _etaController = TextEditingController(
    text: widget.esistente == null
        ? ''
        : widget.provider.calcoloEtaDipendente(widget.esistente!),
  );
  late final _noteController =
      TextEditingController(text: widget.esistente?.note ?? '');

  String? _mansione;

  // DATE
  DateTime? _dataNascita;
  DateTime? _dataAssunzione;
  DateTime? _dataFormazione231;
  DateTime? _dataFormazioneRentri;
  DateTime? _dataFormazioneAmbientale;

  // SCADENZE
  DateTime? _scadenzaVisitaMedica;
  DateTime? _scadenzaFormazioneSicurezza;
  DateTime? _scadenzaGruAutocarro;
  DateTime? _scadenzaGruTorre;
  DateTime? _scadenzaCarrelloElevatoreSemovente;
  DateTime? _scadenzaConduzioneEscavatori;
  DateTime? _scadenzaPiattaformeElevatrici;
  DateTime? _scadenzaPonteggi;
  DateTime? _scadenzaPreposto;
  DateTime? _scadenzaAntincendio;
  DateTime? _scadenzaPrimoSoccorso;
  DateTime? _scadenzaRspp;
  DateTime? _scadenzaRlst;
  DateTime? _scadenzaPatente;
  DateTime? _scadenzaCartaTachigrafica;
  DateTime? _scadenzaCartaIdentita;
  DateTime? _scadenzaFirmaDigitale;
  DateTime? _scadenzaPermessoSoggiorno;
  DateTime? _scadenzaContratto;
  DateTime? _scadenzaLavoriQuota;
  DateTime? _scadenzaCorsoDisocianati;
  DateTime? _scadenzaScaffalature;
  DateTime? _scadenzaAntitetanica;
  DateTime? _scadenzaCorsoCronotachigrafico;
  DateTime? _scadenzaCodiceFiscale;

  bool _isSaving = false;
  bool _mostraPermessoSoggiorno = false;
  bool _mostraAntitetanica = false;
  bool _mostraScadenzaContratto = false;

  final Set<String> _corsiAttivi = {};

  late final Map<String, _Corso> _corsi = {
    'primo_soccorso': _Corso(() => _scadenzaPrimoSoccorso, (v) => _scadenzaPrimoSoccorso = v),
    'antincendio': _Corso(() => _scadenzaAntincendio, (v) => _scadenzaAntincendio = v),
    'preposto': _Corso(() => _scadenzaPreposto, (v) => _scadenzaPreposto = v),
    'ponteggi': _Corso(() => _scadenzaPonteggi, (v) => _scadenzaPonteggi = v),
    'lavori_quota': _Corso(() => _scadenzaLavoriQuota, (v) => _scadenzaLavoriQuota = v),
    'escavatori': _Corso(() => _scadenzaConduzioneEscavatori, (v) => _scadenzaConduzioneEscavatori = v),
    'gru_autocarro': _Corso(() => _scadenzaGruAutocarro, (v) => _scadenzaGruAutocarro = v),
    'gru_torre': _Corso(() => _scadenzaGruTorre, (v) => _scadenzaGruTorre = v),
    'piattaforme': _Corso(() => _scadenzaPiattaformeElevatrici, (v) => _scadenzaPiattaformeElevatrici = v),
    'carrello_elevatore': _Corso(
        () => _scadenzaCarrelloElevatoreSemovente,
        (v) => _scadenzaCarrelloElevatoreSemovente = v),
    'disocianati': _Corso(() => _scadenzaCorsoDisocianati, (v) => _scadenzaCorsoDisocianati = v),
    'scaffalature': _Corso(() => _scadenzaScaffalature, (v) => _scadenzaScaffalature = v),
    'formazione231': _Corso(() => _dataFormazione231, (v) => _dataFormazione231 = v),
    'ambientale': _Corso(() => _dataFormazioneAmbientale, (v) => _dataFormazioneAmbientale = v),
    'rentri': _Corso(() => _dataFormazioneRentri, (v) => _dataFormazioneRentri = v),
    'cronotachigrafico': _Corso(() => _scadenzaCorsoCronotachigrafico, (v) => _scadenzaCorsoCronotachigrafico = v),
  };

  @override
  void initState() {
    super.initState();
    final d = widget.esistente;
    _mansione = (d == null || d.mansione.isEmpty) ? null : d.mansione;

    _dataNascita = _parseData(d?.dataNascita ?? '');
    _dataAssunzione = _parseData(d?.dataAssunzione ?? '');
    _dataFormazione231 = _parseData(d?.dataFormazione231 ?? '');
    _dataFormazioneAmbientale = _parseData(d?.dataFormazioneAmbientale ?? '');
    _dataFormazioneRentri = _parseData(d?.dataFormazioneRentri ?? '');

    _scadenzaVisitaMedica = _parseData(d?.scadenzaVisitaMedica ?? '');
    _scadenzaFormazioneSicurezza = _parseData(d?.scadenzaFormazioneSicurezza ?? '');
    _scadenzaCodiceFiscale = _parseData(d?.scadenzaCodiceFiscale ?? '');
    _scadenzaGruAutocarro = _parseData(d?.scadenzaGruAutocarro ?? '');
    _scadenzaGruTorre = _parseData(d?.scadenzaGruTorre ?? '');
    _scadenzaCarrelloElevatoreSemovente = _parseData(d?.scadenzaCarrelloElevatoreSemovente ?? '');
    _scadenzaConduzioneEscavatori = _parseData(d?.scadenzaConduzioneEscavatori ?? '');
    _scadenzaPiattaformeElevatrici = _parseData(d?.scadenzaPiattaformeElevatrici ?? '');
    _scadenzaPonteggi = _parseData(d?.scadenzaPonteggi ?? '');
    _scadenzaPreposto = _parseData(d?.scadenzaPreposto ?? '');
    _scadenzaAntincendio = _parseData(d?.scadenzaAntincendio ?? '');
    _scadenzaPrimoSoccorso = _parseData(d?.scadenzaPrimoSoccorso ?? '');
    _scadenzaRspp = _parseData(d?.scadenzaRspp ?? '');
    _scadenzaRlst = _parseData(d?.scadenzaRlst ?? '');
    _scadenzaPatente = _parseData(d?.scadenzaPatente ?? '');
    _scadenzaCartaTachigrafica = _parseData(d?.scadenzaCartaTachigrafica ?? '');
    _scadenzaCartaIdentita = _parseData(d?.scadenzaCartaIdentita ?? '');
    _scadenzaFirmaDigitale = _parseData(d?.scadenzaFirmaDigitale ?? '');
    _scadenzaPermessoSoggiorno = _parseData(d?.scadenzaPermessoSoggiorno ?? '');
    _scadenzaContratto = _parseData(d?.scadenzaContratto ?? '');
    _scadenzaLavoriQuota = _parseData(d?.scadenzaLavoriQuota ?? '');
    _scadenzaCorsoDisocianati = _parseData(d?.scadenzaCorsoDisocianati ?? '');
    _scadenzaScaffalature = _parseData(d?.scadenzaScaffalature ?? '');
    _scadenzaAntitetanica = _parseData(d?.scadenzaAntitetanica ?? '');
    _scadenzaCorsoCronotachigrafico = _parseData(d?.scadenzaCorsoCronotachigrafico ?? '');

    _mostraPermessoSoggiorno = _scadenzaPermessoSoggiorno != null;
    _mostraAntitetanica = _scadenzaAntitetanica != null;

    // Un corso è "attivo" se il dipendente ha già una data salvata per quel corso.
    for (final corso in _corsi.entries) {
      if (corso.value.leggi() != null) _corsiAttivi.add(corso.key);
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _cognomeController.dispose();
    _codiceFiscaleController.dispose();
    _noteController.dispose();
    _luogoNascitaController.dispose();
    _etaController.dispose();
    super.dispose();
  }

  Widget _campoData(
    String label,
    DateTime? valore,
    ValueChanged<DateTime?> onChanged, {
    VoidCallback? onRimuovi,
    String? tooltipRimuovi,
  }) {
    return CampoData(
      label: label,
      valore: valore,
      onChanged: (v) => setState(() => onChanged(v)),
      onRimuovi: onRimuovi,
      tooltipRimuovi: tooltipRimuovi,
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);
    try {
      final nome = _nomeController.text.trim();
      final cognome = _cognomeController.text.trim();
      final codiceFiscale = _codiceFiscaleController.text.trim();
      final luogoNascita = _luogoNascitaController.text.trim();
      final eta = _etaController.text.trim();
      final note = _noteController.text.trim();

      if (widget.esistente == null) {
        await widget.provider.create(
          nome: nome,
          cognome: cognome,
          codiceFiscale: codiceFiscale,
          mansione: _mansione,
          luogoNascita: luogoNascita,
          eta: eta,
          dataNascita: _dataNascita,
          dataAssunzione: _dataAssunzione,
          scadenzaVisitaMedica: _scadenzaVisitaMedica,
          scadenzaFormazioneSicurezza: _scadenzaFormazioneSicurezza,
          scadenzaLavoriQuota: _scadenzaLavoriQuota,
          scadenzaAntitetanica: _scadenzaAntitetanica,
          scadenzaGruAutocarro: _scadenzaGruAutocarro,
          scadenzaGruTorre: _scadenzaGruTorre,
          scadenzaCarrelloElevatoreSemovente: _scadenzaCarrelloElevatoreSemovente,
          scadenzaConduzioneEscavatori: _scadenzaConduzioneEscavatori,
          scadenzaPiattaformeElevatrici: _scadenzaPiattaformeElevatrici,
          scadenzaPonteggi: _scadenzaPonteggi,
          scadenzaScaffalature: _scadenzaScaffalature,
          scadenzaCorsoDisocianati: _scadenzaCorsoDisocianati,
          scadenzaCorsoCronotachigrafico: _scadenzaCorsoCronotachigrafico,
          scadenzaPreposto: _scadenzaPreposto,
          scadenzaAntincendio: _scadenzaAntincendio,
          scadenzaPrimoSoccorso: _scadenzaPrimoSoccorso,
          scadenzaRspp: _scadenzaRspp,
          scadenzaRlst: _scadenzaRlst,
          scadenzaPatente: _scadenzaPatente,
          scadenzaCartaTachigrafica: _scadenzaCartaTachigrafica,
          scadenzaCartaIdentita: _scadenzaCartaIdentita,
          scadenzaFirmaDigitale: _scadenzaFirmaDigitale,
          scadenzaPermessoSoggiorno: _scadenzaPermessoSoggiorno,
          scadenzaContratto: _scadenzaContratto,
          dataFormazione231: _dataFormazione231,
          dataFormazioneAmbientale: _dataFormazioneAmbientale,
          dataFormazioneRentri: _dataFormazioneRentri,
          scadenzaCodiceFiscale : _scadenzaCodiceFiscale,
          note: note,
        );
      } else {
        await widget.provider.update(
          widget.esistente!.id,
          nome: nome,
          cognome: cognome,
          codiceFiscale: codiceFiscale,
          mansione: _mansione,
          luogoNascita: luogoNascita,
          eta: eta,
          dataNascita: _dataNascita,
          dataAssunzione: _dataAssunzione,
          scadenzaVisitaMedica: _scadenzaVisitaMedica,
          scadenzaFormazioneSicurezza: _scadenzaFormazioneSicurezza,
          scadenzaLavoriQuota: _scadenzaLavoriQuota,
          scadenzaAntitetanica: _scadenzaAntitetanica,
          scadenzaGruAutocarro: _scadenzaGruAutocarro,
          scadenzaGruTorre: _scadenzaGruTorre,
          scadenzaCarrelloElevatoreSemovente: _scadenzaCarrelloElevatoreSemovente,
          scadenzaConduzioneEscavatori: _scadenzaConduzioneEscavatori,
          scadenzaPiattaformeElevatrici: _scadenzaPiattaformeElevatrici,
          scadenzaPonteggi: _scadenzaPonteggi,
          scadenzaScaffalature: _scadenzaScaffalature,
          scadenzaCorsoDisocianati: _scadenzaCorsoDisocianati,
          scadenzaCorsoCronotachigrafico: _scadenzaCorsoCronotachigrafico,
          scadenzaPreposto: _scadenzaPreposto,
          scadenzaAntincendio: _scadenzaAntincendio,
          scadenzaPrimoSoccorso: _scadenzaPrimoSoccorso,
          scadenzaRspp: _scadenzaRspp,
          scadenzaRlst: _scadenzaRlst,
          scadenzaPatente: _scadenzaPatente,
          scadenzaCartaTachigrafica: _scadenzaCartaTachigrafica,
          scadenzaCartaIdentita: _scadenzaCartaIdentita,
          scadenzaFirmaDigitale: _scadenzaFirmaDigitale,
          scadenzaPermessoSoggiorno: _scadenzaPermessoSoggiorno,
          scadenzaContratto: _scadenzaContratto,
          dataFormazione231: _dataFormazione231,
          dataFormazioneAmbientale: _dataFormazioneAmbientale,
          dataFormazioneRentri: _dataFormazioneRentri,
          scadenzaCodiceFiscale: _scadenzaCodiceFiscale,
          note: note,
        );
      }
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.commonErrorWithDetails(e.toString()))));
        setState(() => _isSaving = false);
      }
    }
  }

  /// Campi dei corsi già aggiunti + pulsante per aggiungerne altri.
  List<Widget> _sezioneCorsi(Color primaryBlue, AppLocalizations l10n) {
    return [
      for (final corso in _corsi.entries)
        if (_corsiAttivi.contains(corso.key))
          _campoData(
            _corsoEtichetta(l10n, corso.key),
            corso.value.leggi(),
            corso.value.scrivi,
            onRimuovi: () => _rimuoviCorso(corso.key),
            tooltipRimuovi: l10n.dipendenteAziendaleFormDialogRemoveCorsoTooltip,
          ),
      Align(
        alignment: Alignment.centerLeft,
        child: TextButton.icon(
          onPressed: _mostraFinestraSceltaCorso,
          label: Text(l10n.dipendenteAziendaleFormDialogAddCorso, style: const TextStyle(fontSize: 12)),
          icon: Icon(Icons.add, color: primaryBlue, size: 12),
        ),
      ),
    ];
  }

  void _rimuoviCorso(String key) {
    setState(() {
      _corsiAttivi.remove(key);
      _corsi[key]!.scrivi(null);
      if (key == 'cronotachigrafico') _scadenzaCartaTachigrafica = null;
    });
  }

  Future<void> _mostraFinestraSceltaCorso() async {
    final l10n = AppLocalizations.of(context)!;
    final disponibili =
        _corsi.entries.where((c) => !_corsiAttivi.contains(c.key)).toList();

    if (disponibili.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.dipendenteAziendaleFormDialogAllCoursesAdded)),
      );
      return;
    }

    final selezionati = <String>{};
    final confermati = await showDialog<Set<String>>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setStateDialog) => AlertDialog(
          title: Text(l10n.dipendenteAziendaleFormDialogSelectCoursesTitle),
          content: SizedBox(
            width: 420,
            child: ListView(
              shrinkWrap: true,
              children: disponibili
                  .map(
                    (corso) => CheckboxListTile(
                      dense: true,
                      controlAffinity: ListTileControlAffinity.leading,
                      value: selezionati.contains(corso.key),
                      title: Text(_corsoNome(l10n, corso.key)),
                      onChanged: (scelto) => setStateDialog(() {
                        if (scelto ?? false) {
                          selezionati.add(corso.key);
                        } else {
                          selezionati.remove(corso.key);
                        }
                      }),
                    ),
                  )
                  .toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(l10n.commonCancel),
            ),
            FilledButton(
              onPressed: selezionati.isEmpty
                  ? null
                  : () => Navigator.of(dialogContext).pop(selezionati),
              child: Text(l10n.dipendenteAziendaleFormDialogAddCoursesCount(selezionati.length)),
            ),
          ],
        ),
      ),
    );

    if (confermati != null && confermati.isNotEmpty && mounted) {
      setState(() => _corsiAttivi.addAll(confermati));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final primaryBlue = Theme.of(context).colorScheme.primary;
    return AlertDialog(
      title: Text(widget.esistente == null
          ? l10n.dipendenteAziendaleFormDialogNewTitle
          : l10n.dipendenteAziendaleFormDialogEditTitle),
      content: Form(
        key: _formKey,
        child: SizedBox(
          width: 460,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _nomeController,
                  decoration: InputDecoration(labelText: l10n.dipendenteAziendaleFormDialogNomeLabel),
                  validator: (v) => (v == null || v.trim().isEmpty) ? l10n.commonRequiredField : null,
                ),
                TextFormField(
                  controller: _cognomeController,
                  decoration: InputDecoration(labelText: l10n.dipendenteAziendaleFormDialogCognomeLabel),
                  validator: (v) => (v == null || v.trim().isEmpty) ? l10n.commonRequiredField : null,
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String?>(
                  initialValue: _mansione,
                  decoration: InputDecoration(labelText: l10n.dipendenteAziendaleFormDialogMansioneLabel),
                  borderRadius: BorderRadius.circular(15),
                  isExpanded: true,
                  itemHeight: null,
                  items: [
                    DropdownMenuItem(value: null, child: Text(l10n.dipendenteAziendaleFormDialogMansioneNonSpecificata)),
                    ...mansioni.entries.map(
                      (d) => DropdownMenuItem(
                        value: d.key,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Text(d.value),
                        ),
                      ),
                    ),
                  ],
                  selectedItemBuilder: (context) => [
                    Text(l10n.dipendenteAziendaleFormDialogMansioneNonSpecificata),
                    ...mansioni.values.map(
                      (nome) => Text(nome, maxLines: 1, overflow: TextOverflow.ellipsis),
                    ),
                  ],
                  onChanged: (v) => setState(() => _mansione = v),
                ),
                const SizedBox(height: 8),
                if (_mansione == mansioneRlst)
                  _campoData(l10n.dipendenteAziendaleFormDialogScadenzaRlst, _scadenzaRlst, (v) => _scadenzaRlst = v)
                else if (_mansione == mansioneRspp)
                  _campoData(l10n.dipendenteAziendaleFormDialogScadenzaRspp, _scadenzaRspp, (v) => _scadenzaRspp = v)
                else ... [
                  TextFormField(
                    controller: _codiceFiscaleController,
                    decoration: InputDecoration(labelText: l10n.dipendenteAziendaleFormDialogCodiceFiscaleLabel),
                  ),
                  const SizedBox(height: 8),
                  _campoData(l10n.dipendenteAziendaleFormDialogDataNascita, _dataNascita, (v) {
                    _dataNascita = v;
                    _etaController.text = widget.provider.calcoloEta(v);
                  }),
                  TextFormField(
                    controller: _luogoNascitaController,
                    decoration: InputDecoration(labelText: l10n.dipendenteAziendaleFormDialogLuogoNascita),
                  ),
                  TextFormField(
                    controller: _etaController,
                    // Con la data di nascita l'età è derivata: si modifica a mano
                    // solo se la data non è stata inserita.
                    readOnly: _dataNascita != null,
                    decoration: InputDecoration(
                      labelText: l10n.dipendenteAziendaleFormDialogEtaLabel,
                      helperText: _dataNascita != null
                          ? l10n.dipendenteAziendaleFormDialogEtaHelper
                          : null,
                    ),
                  ),
                  if (_mansione != mansioneTitolare && _mansione != mansioneRlst && _mansione != mansioneRspp) ... [
                    const Divider(height: 24),
                    Text(l10n.dipendenteAziendaleFormDialogSectionContratto, style: TextStyle(fontWeight: FontWeight.w600, color: primaryBlue)),
                    _campoData(l10n.dipendenteAziendaleFormDialogDataAssunzione, _dataAssunzione, (v) => _dataAssunzione = v),
                    if (_mostraScadenzaContratto)
                      _campoData(
                        l10n.dipendenteAziendaleFormDialogScadenzaContratto,
                        _scadenzaContratto,
                        (v) => _scadenzaContratto = v,
                        onRimuovi: () => setState(() {
                          _mostraScadenzaContratto = false;
                          _scadenzaContratto = null;
                        }),
                        tooltipRimuovi: l10n.dipendenteAziendaleFormDialogRemoveScadenzaContrattoTooltip,
                      )
                    else
                      Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton.icon(
                        onPressed: () => setState(() => _mostraScadenzaContratto = true),
                        label: Text(l10n.dipendenteAziendaleFormDialogAddScadenzaContratto, style: const TextStyle(fontSize: 12)),
                        icon: Icon(Icons.add, color: primaryBlue, size: 12),
                      ),
                    ),
                  ],
                  const Divider(height: 24),
                  Text(l10n.dipendenteAziendaleFormDialogSectionPersonali, style: TextStyle(fontWeight: FontWeight.w600, color: primaryBlue)),
                  _campoData(l10n.dipendenteAziendaleFormDialogScadenzaVisitaMedica, _scadenzaVisitaMedica, (v) => _scadenzaVisitaMedica = v),
                  _campoData(l10n.dipendenteAziendaleFormDialogScadenzaPatente, _scadenzaPatente, (v) => _scadenzaPatente = v),
                  if (_corsiAttivi.contains('cronotachigrafico')) ... [
                    if (_mansione == mansioneTitolare) ... [
                      _campoData(
                        l10n.dipendenteAziendaleFormDialogScadenzaCartaTachigraficaAzienda,
                        _scadenzaCartaTachigrafica,
                        (v) => _scadenzaCartaTachigrafica = v,
                      ),
                    ]
                    else ... [
                      _campoData(
                        l10n.dipendenteAziendaleFormDialogScadenzaCartaTachigrafica,
                        _scadenzaCartaTachigrafica,
                        (v) => _scadenzaCartaTachigrafica = v,
                      ),
                    ],
                  ],
                  _campoData(l10n.dipendenteAziendaleFormDialogScadenzaCartaIdentita, _scadenzaCartaIdentita, (v) => _scadenzaCartaIdentita = v),
                  if (_mansione == mansioneTitolare)
                    _campoData(
                      l10n.dipendenteAziendaleFormDialogScadenzaFirmaDigitale,
                      _scadenzaFirmaDigitale,
                      (v) => _scadenzaFirmaDigitale = v,
                    ),
                  _campoData(l10n.dipendenteAziendaleFormDialogScadenzaCodiceFiscale, _scadenzaCodiceFiscale, (v) => _scadenzaCodiceFiscale = v),
                  if (_mostraPermessoSoggiorno)
                    _campoData(
                      l10n.dipendenteAziendaleFormDialogScadenzaPermessoSoggiorno,
                      _scadenzaPermessoSoggiorno,
                      (v) => _scadenzaPermessoSoggiorno = v,
                      onRimuovi: () => setState(() {
                        _mostraPermessoSoggiorno = false;
                        _scadenzaPermessoSoggiorno = null;
                      }),
                      tooltipRimuovi: l10n.dipendenteAziendaleFormDialogRemovePermessoSoggiornoTooltip,
                    )
                  else
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton.icon(
                        onPressed: () => setState(() => _mostraPermessoSoggiorno = true),
                        label: Text(l10n.dipendenteAziendaleFormDialogAddPermessoSoggiorno, style: const TextStyle(fontSize: 12)),
                        icon: Icon(Icons.add, color: primaryBlue, size: 12),
                      ),
                    ),
                  if (_mostraAntitetanica)
                    _campoData(
                      l10n.dipendenteAziendaleFormDialogScadenzaAntitetanica,
                      _scadenzaAntitetanica,
                      (v) => _scadenzaAntitetanica = v,
                      onRimuovi: () => setState(() {
                        _mostraAntitetanica = false;
                        _scadenzaAntitetanica = null;
                      }),
                      tooltipRimuovi: l10n.dipendenteAziendaleFormDialogRemoveAntitetanicaTooltip,
                    )
                  else
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton.icon(
                        onPressed: () => setState(() => _mostraAntitetanica = true),
                        label: Text(l10n.dipendenteAziendaleFormDialogAddAntitetanica, style: const TextStyle(fontSize: 12)),
                        icon: Icon(Icons.add, color: primaryBlue, size: 12),
                      ),
                    ),
                  const Divider(height: 24),
                  Text(l10n.dipendenteAziendaleFormDialogSectionCorsi, style: TextStyle(fontWeight: FontWeight.w600, color: primaryBlue)),
                  if (_mansione == mansioneTitolare)
                    _campoData(l10n.dipendenteAziendaleFormDialogScadenzaRspp, _scadenzaRspp, (v) => _scadenzaRspp = v),
                  if (_mansione != mansioneTitolare)
                    _campoData(l10n.dipendenteAziendaleFormDialogScadenzaFormazioneGenerale, _scadenzaFormazioneSicurezza, (v) => _scadenzaFormazioneSicurezza = v),
                  ..._sezioneCorsi(primaryBlue, l10n),
                ],
                const Divider(height: 24),
                TextField(
                  controller: _noteController,
                  decoration: InputDecoration(labelText: l10n.dipendenteAziendaleFormDialogNoteAggiuntive)
                )
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSaving ? null : () => Navigator.of(context).pop(),
          child: Text(l10n.commonCancel),
        ),
        FilledButton(
          onPressed: _isSaving ? null : _submit,
          child: _isSaving
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(l10n.commonSave),
        ),
      ],
    );
  }
}

class _Corso {
  const _Corso(this.leggi, this.scrivi);

  final DateTime? Function() leggi;
  final ValueChanged<DateTime?> scrivi;
}
