// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'Demo Scadenziario';

  @override
  String get commonCancel => 'Annulla';

  @override
  String get commonSave => 'Salva';

  @override
  String get commonDelete => 'Elimina';

  @override
  String get commonConfirm => 'Conferma';

  @override
  String get commonEdit => 'Modifica';

  @override
  String get commonClose => 'Chiudi';

  @override
  String get commonYes => 'Sì';

  @override
  String get commonNo => 'No';

  @override
  String get commonSearch => 'Cerca';

  @override
  String get commonLoading => 'Caricamento in corso...';

  @override
  String get commonError => 'Errore';

  @override
  String get commonAdd => 'Aggiungi';

  @override
  String get commonBack => 'Indietro';

  @override
  String get commonNoteLabel => 'Note';

  @override
  String get commonRequiredField => 'Campo obbligatorio';

  @override
  String commonErrorWithDetails(String details) {
    return 'Errore: $details';
  }

  @override
  String get appBarGoHome => 'Vai alla home';

  @override
  String get appBarLogout => 'Esci';

  @override
  String get appBarLogoutConfirmTitle => 'Conferma logout';

  @override
  String get appBarLogoutConfirmMessage => 'Sei sicuro di voler uscire?';

  @override
  String get appBarLogoutConfirmButton => 'Esci';

  @override
  String get appBarLanguageTooltip => 'Switch to English';

  @override
  String get confirmDialogCancel => 'Annulla';

  @override
  String get confirmDialogDeleteDefault => 'Elimina';

  @override
  String get loginWelcomeTitle => 'Benvenuto!';

  @override
  String get loginWelcomeSubtitle => 'Accedi al gestionale cantieri';

  @override
  String get loginEmailHint => 'Inserisci la tua email';

  @override
  String get loginEmailLabel => 'Email';

  @override
  String get loginEmailValidatorEmpty => 'Inserisci l\'email';

  @override
  String get loginPasswordHint => 'Inserisci la tua password';

  @override
  String get loginPasswordLabel => 'Password';

  @override
  String get loginPasswordValidatorEmpty => 'Inserisci la password';

  @override
  String get loginButton => 'Login';

  @override
  String get authInvalidCredentials => 'Credenziali non valide';

  @override
  String get errorLoadingScale => 'Errore nel caricamento delle scale';

  @override
  String get errorLoadingTipiScadenza =>
      'Errore nel caricamento dei tipi scadenza';

  @override
  String get errorLoadingScadenzeGenerali =>
      'Errore nel caricamento delle scadenze generali';

  @override
  String get errorLoadingCantieri => 'Errore nel caricamento dei cantieri';

  @override
  String get errorLoadingTipiDpi => 'Errore nel caricamento dei tipi di DPI';

  @override
  String get errorLoadingImpostazioni =>
      'Errore nel caricamento delle impostazioni';

  @override
  String get errorLoadingDocumenti => 'Errore nel caricamento dei documenti';

  @override
  String get errorLoadingMisure => 'Errore nel caricamento delle misure';

  @override
  String get errorLoadingRifiuti => 'Errore nel caricamento dei rifiuti';

  @override
  String get errorLoadingEstintori => 'Errore nel caricamento degli estintori';

  @override
  String get errorLoadingBenne => 'Errore nel caricamento delle benne';

  @override
  String get errorLoadingSegnaletica =>
      'Errore nel caricamento della segnaletica';

  @override
  String get errorLoadingCassette => 'Errore nel caricamento delle cassette';

  @override
  String get errorLoadingMacchinari => 'Errore nel caricamento dei macchinari';

  @override
  String get errorLoadingAutomezzi => 'Errore nel caricamento degli automezzi';

  @override
  String get errorLoadingRegoleDpi => 'Errore nel caricamento delle regole DPI';

  @override
  String get errorLoadingImpianti => 'Errore nel caricamento degli impianti';

  @override
  String get errorLoadingControlli => 'Errore nel caricamento dei controlli';

  @override
  String get errorLoadingFasceCatene =>
      'Errore nel caricamento di fasce e catene';

  @override
  String get errorLoadingSubappaltatori =>
      'Errore nel caricamento dei subappaltatori';

  @override
  String get errorLoadingDipendentiSubappaltatori =>
      'Errore nel caricamento dei dipendenti';

  @override
  String get errorLoadingArticoli => 'Errore nel caricamento degli articoli';

  @override
  String get errorLoadingDpiAssegnati =>
      'Errore nel caricamento dei DPI assegnati';

  @override
  String get errorLoadingProdottiStandard =>
      'Errore nel caricamento dei prodotti standard';

  @override
  String get errorLoadingDipendentiAziendali =>
      'Errore nel caricamento dei dipendenti aziendali';

  @override
  String get errorLoadingScaffalature =>
      'Errore nel caricamento delle scaffalature';

  @override
  String get errorDeletingScadenzaGenerale =>
      'Impossibile eliminare la scadenza';

  @override
  String get errorDeletingTipoScadenzaInUse =>
      'Impossibile eliminare la tipologia: probabilmente è ancora usata da una o più scadenze.';

  @override
  String get errorDeletingScaffalatura =>
      'Impossibile eliminare la scaffalatura';

  @override
  String get appDrawerAmministrazione => 'Amministrazione';

  @override
  String get appDrawerArchivioCantieri => 'Archivio cantieri';

  @override
  String get appDrawerAutomezzi => 'Automezzi';

  @override
  String get appDrawerCantieri => 'Cantieri';

  @override
  String get appDrawerContenutoStandard => 'Contenuto Standard';

  @override
  String get appDrawerDpi => 'DPI';

  @override
  String get appDrawerEstintori => 'Estintori';

  @override
  String get appDrawerFasceCatene => 'Fasce/Catene';

  @override
  String get appDrawerHideSubsections => 'Nascondi sottosezioni';

  @override
  String get appDrawerImpianti => 'Impianti';

  @override
  String get appDrawerMacchinari => 'Macchinari';

  @override
  String get appDrawerMisure => 'Misure';

  @override
  String get appDrawerOtherSectionsTitle => 'Altre sezioni';

  @override
  String get appDrawerPrimoSoccorso => 'Primo Soccorso';

  @override
  String get appDrawerRemindersSuspended => 'Solleciti sospesi';

  @override
  String get appDrawerRifiuti => 'Rifiuti';

  @override
  String get appDrawerScaffalature => 'Scaffalature';

  @override
  String get appDrawerScale => 'Scale';

  @override
  String get appDrawerSegnaleticaSicurezza => 'Segnaletica Sicurezza';

  @override
  String get appDrawerShowSubsections => 'Mostra sottosezioni';

  @override
  String get appDrawerSubappaltatori => 'Subappaltatori';

  @override
  String get appDrawerSuspendReminderSubtitle =>
      'Per i periodi di chiusura aziendale';

  @override
  String get appDrawerSuspendReminders => 'Sospendi solleciti';

  @override
  String appDrawerSuspendedUntil(String date) {
    return 'Fino al $date';
  }

  @override
  String get appDrawerTipiDpi => 'Tipi di DPI';

  @override
  String get appDrawerTipiScadenze => 'Tipi scadenze';

  @override
  String get appDrawerUpcomingDeadlinesTooltip => 'Scadenze imminenti';

  @override
  String cantiereCardClosedOn(String date) {
    return 'Concluso il $date';
  }

  @override
  String get cantiereCardDeleteTooltip => 'Elimina cantiere';

  @override
  String get cantiereCardEditTooltip => 'Modifica cantiere';

  @override
  String cantiereCardExpiringCount(int count) {
    return '$count in scadenza';
  }

  @override
  String cantiereCardSubappaltatoriCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count subappaltatori',
      one: '$count subappaltatore',
    );
    return '$_temp0';
  }

  @override
  String get cantiereCardSuspendedLabel => 'SOSPESO';

  @override
  String get dpiAssegnatoFormDialogAdditionalNotesLabel => 'Note aggiuntive';

  @override
  String get dpiAssegnatoFormDialogAssignTitle => 'Assegna DPI';

  @override
  String get dpiAssegnatoFormDialogDateInUseLabel => 'Data messa in uso';

  @override
  String get dpiAssegnatoFormDialogDeliveryDateLabel => 'Data consegna';

  @override
  String get dpiAssegnatoFormDialogDpiTypeLabel => 'Tipo di DPI*';

  @override
  String get dpiAssegnatoFormDialogEditTitle => 'Modifica DPI assegnato';

  @override
  String get dpiAssegnatoFormDialogEmployeeLabel => 'Dipendente';

  @override
  String get dpiAssegnatoFormDialogExpiryDateLabel => 'Data scadenza';

  @override
  String get dpiAssegnatoFormDialogManufactureYearLabel =>
      'Anno di fabbricazione';

  @override
  String get dpiAssegnatoFormDialogManufacturerLabel => 'Produttore';

  @override
  String get dpiAssegnatoFormDialogSelectDpiType => 'Seleziona un tipo di DPI';

  @override
  String get dpiAssegnatoFormDialogSelectEmployee => 'Seleziona un dipendente';

  @override
  String get dpiAssegnatoFormDialogSerialNumberLabel => 'Matricola';

  @override
  String get dpiAssegnatoFormDialogSizeLabel => 'Taglia';

  @override
  String get fasciaCatenaFormDialogAdditionalNotesLabel => 'Note aggiuntive';

  @override
  String get fasciaCatenaFormDialogBrowse => 'Sfoglia';

  @override
  String get fasciaCatenaFormDialogCapacityLabel => 'Portata (Kg)';

  @override
  String get fasciaCatenaFormDialogChangePhoto => 'Cambia foto';

  @override
  String get fasciaCatenaFormDialogCharacteristicsSection => 'Caratteristiche';

  @override
  String get fasciaCatenaFormDialogCheckPassedLabel =>
      'Esito verifica positivo';

  @override
  String get fasciaCatenaFormDialogColorLabel => 'Colore';

  @override
  String get fasciaCatenaFormDialogDiameterLabel => 'Diametro (mm)';

  @override
  String get fasciaCatenaFormDialogDragPhotoHint =>
      'Trascina qui la foto della fascia/catena';

  @override
  String get fasciaCatenaFormDialogEditTitle => 'Modifica fascia/catena';

  @override
  String get fasciaCatenaFormDialogFileFormatsHint =>
      'JPG, PNG o WEBP - max 5 MB';

  @override
  String get fasciaCatenaFormDialogFitForUse => 'Idonea all\'uso';

  @override
  String get fasciaCatenaFormDialogImageTooLarge =>
      'Immagine troppo grande (max 5 MB)';

  @override
  String get fasciaCatenaFormDialogImageUnavailable =>
      'Immagine non disponibile';

  @override
  String get fasciaCatenaFormDialogInternalCheckSection => 'Verifica interna';

  @override
  String get fasciaCatenaFormDialogInternalIdLabel => 'ID interno*';

  @override
  String fasciaCatenaFormDialogInvalidExtension(String extension) {
    return 'Estensione non ammessa (.$extension)';
  }

  @override
  String get fasciaCatenaFormDialogLastInternalCheckLabel =>
      'Ultima verifica interna';

  @override
  String get fasciaCatenaFormDialogLengthLabel => 'Lunghezza (m)';

  @override
  String get fasciaCatenaFormDialogLocationNotSpecified => 'Non specificata';

  @override
  String get fasciaCatenaFormDialogLocationSection => 'Ubicazione';

  @override
  String get fasciaCatenaFormDialogLocationTypeLabel => 'Tipo ubicazione';

  @override
  String get fasciaCatenaFormDialogNewTitle => 'Nuova fascia/catena';

  @override
  String get fasciaCatenaFormDialogNextCheckLabel => 'Prossima verifica';

  @override
  String get fasciaCatenaFormDialogNotFitForUse =>
      'Non idonea: da mettere fuori servizio';

  @override
  String get fasciaCatenaFormDialogPhotoSection => 'Foto';

  @override
  String get fasciaCatenaFormDialogPurchaseDateLabel => 'Data di acquisto';

  @override
  String get fasciaCatenaFormDialogPurchaseLocationLabel => 'Luogo di acquisto';

  @override
  String get fasciaCatenaFormDialogPurchaseSection => 'Acquisto';

  @override
  String get fasciaCatenaFormDialogRatchetLabel => 'Cricchetto';

  @override
  String get fasciaCatenaFormDialogRegistrySection => 'Anagrafica';

  @override
  String get fasciaCatenaFormDialogRemove => 'Rimuovi';

  @override
  String get fasciaCatenaFormDialogSelectSite => 'Seleziona un cantiere';

  @override
  String get fasciaCatenaFormDialogSelectVehicle => 'Seleziona un automezzo';

  @override
  String get fasciaCatenaFormDialogSerialNumberLabel =>
      'Numero di serie produttore';

  @override
  String get fasciaCatenaFormDialogSiteOption => 'Cantiere';

  @override
  String get fasciaCatenaFormDialogThicknessLabel => 'Spessore (mm)';

  @override
  String get fasciaCatenaFormDialogTypeLabel => 'Tipo';

  @override
  String get fasciaCatenaFormDialogTypeNotSpecified => 'Non specificato';

  @override
  String get fasciaCatenaFormDialogVehicleOption => 'Automezzo';

  @override
  String get fasciaCatenaFormDialogWarehouseOption => 'Magazzino';

  @override
  String get fasciaCatenaFormDialogWidthLabel => 'Larghezza (mm)';

  @override
  String notaDipendenteAziendaleDialogTitle(String nome, String cognome) {
    return 'Nota — $nome $cognome';
  }

  @override
  String notaDipendenteAziendaleDialogTitleConTipo(
    String nome,
    String cognome,
    String tipo,
  ) {
    return 'Nota — $nome $cognome — $tipo';
  }

  @override
  String notaEstintoreDialogTitle(String matricola, String tipo) {
    return 'Nota — $matricola — $tipo';
  }

  @override
  String notaScaffalaturaDialogTitle(String id, String tipo) {
    return 'Nota — Scaffalatura #$id — $tipo';
  }

  @override
  String get scadenzeImminentiScreenAerialPlatformsDeadline =>
      'Scadenza Piattaforme elevatrici';

  @override
  String get scadenzeImminentiScreenAnnualCheck => 'Verifica annuale';

  @override
  String get scadenzeImminentiScreenAnnualMaintenance => 'Manutenzione annuale';

  @override
  String get scadenzeImminentiScreenArticleLabel => 'Articolo';

  @override
  String get scadenzeImminentiScreenAssigneeLabel => 'Incaricato';

  @override
  String get scadenzeImminentiScreenCollapseAll => 'Nascondi tutte';

  @override
  String get scadenzeImminentiScreenCompanyEmployeesSection =>
      'Dipendenti aziendali';

  @override
  String get scadenzeImminentiScreenCompanyLabel => 'Ditta';

  @override
  String get scadenzeImminentiScreenContractDeadline => 'Scadenza Contratto';

  @override
  String get scadenzeImminentiScreenDeadlineNoteLabel => 'Nota scadenza';

  @override
  String get scadenzeImminentiScreenDigitalSignatureDeadline =>
      'Scadenza Firma Digitale';

  @override
  String get scadenzeImminentiScreenDiisocyanatesCourseDeadline =>
      'Scadenza corso Diisocianati';

  @override
  String get scadenzeImminentiScreenDocumentFallback => 'Documento';

  @override
  String get scadenzeImminentiScreenDrivingLicenseDeadline =>
      'Scadenza Patente';

  @override
  String get scadenzeImminentiScreenEditNoteTooltip => 'Modifica nota';

  @override
  String get scadenzeImminentiScreenEmployeeLabel => 'Dipendente';

  @override
  String get scadenzeImminentiScreenExcavatorOperationDeadline =>
      'Scadenza Conduzione Escavatori';

  @override
  String get scadenzeImminentiScreenExpandAll => 'Mostra tutte';

  @override
  String get scadenzeImminentiScreenExternalCheckDeadline =>
      'Scadenza Verifica Esterna';

  @override
  String get scadenzeImminentiScreenExternalMaintenanceDeadline =>
      'Scadenza Manutenzione Esterna';

  @override
  String get scadenzeImminentiScreenFireSafetyDeadline =>
      'Scadenza Antincendio';

  @override
  String get scadenzeImminentiScreenFirstAidDeadline =>
      'Scadenza Primo Soccorso';

  @override
  String get scadenzeImminentiScreenFirstAidSection => 'Primo soccorso';

  @override
  String get scadenzeImminentiScreenForkliftDeadline =>
      'Scadenza Carrello elevatore semovente';

  @override
  String get scadenzeImminentiScreenGeneralDeadlinesSection =>
      'Scadenze generali';

  @override
  String get scadenzeImminentiScreenHazardousWasteCarrierDeadline =>
      'Scadenza Rifiuti Pericolosi Trasportatore';

  @override
  String get scadenzeImminentiScreenHazardousWasteDisposerDeadline =>
      'Scadenza Rifiuti Pericolosi Smaltitore';

  @override
  String get scadenzeImminentiScreenHeightWorkDeadline =>
      'Scadenza Lavori in Quota';

  @override
  String get scadenzeImminentiScreenHideSectionTooltip => 'Nascondi scadenze';

  @override
  String get scadenzeImminentiScreenIdCardDeadline => 'Scadenza Carta Identità';

  @override
  String get scadenzeImminentiScreenInspectionDeadline => 'Scadenza Revisione';

  @override
  String get scadenzeImminentiScreenInsuranceDeadline =>
      'Scadenza Assicurazione';

  @override
  String get scadenzeImminentiScreenInternalMaintenanceDeadline =>
      'Scadenza Manutenzione Interna';

  @override
  String get scadenzeImminentiScreenLadderCodeLabel => 'Codice scala';

  @override
  String get scadenzeImminentiScreenLastCheckLabel => 'Ultima verifica';

  @override
  String get scadenzeImminentiScreenLeaseRentalDeadline =>
      'Scadenza Noleggio/Leasing';

  @override
  String get scadenzeImminentiScreenLocationInOfficeLower => 'in Ufficio';

  @override
  String get scadenzeImminentiScreenLocationInWarehouseLower => 'in Magazzino';

  @override
  String get scadenzeImminentiScreenLocationLabel => 'Ubicazione';

  @override
  String get scadenzeImminentiScreenLocationNotSpecified => 'Non specificata';

  @override
  String get scadenzeImminentiScreenLocationNotSpecifiedLower =>
      'non specificata';

  @override
  String get scadenzeImminentiScreenLocationOffice => 'In ufficio';

  @override
  String scadenzeImminentiScreenLocationSite(String site) {
    return 'In cantiere $site';
  }

  @override
  String scadenzeImminentiScreenLocationVehicle(String vehicle) {
    return 'Su automezzo $vehicle';
  }

  @override
  String get scadenzeImminentiScreenLocationWarehouse => 'In magazzino';

  @override
  String get scadenzeImminentiScreenLorryCraneDeadline =>
      'Scadenza Gru Autocarro';

  @override
  String get scadenzeImminentiScreenMedicalExamDeadline =>
      'Scadenza Visita Medica';

  @override
  String get scadenzeImminentiScreenModelLabel => 'Modello';

  @override
  String get scadenzeImminentiScreenNextCheckLabel => 'Prossimo Controllo';

  @override
  String get scadenzeImminentiScreenNextExternalCalibration =>
      'Prossima taratura esterna';

  @override
  String get scadenzeImminentiScreenNextInternalCalibration =>
      'Prossima taratura interna';

  @override
  String get scadenzeImminentiScreenNextVerificationLabel =>
      'Prossima verifica';

  @override
  String get scadenzeImminentiScreenNonHazardousWasteCarrierDeadline =>
      'Scadenza Rifiuti Non Pericolosi Trasportatore';

  @override
  String get scadenzeImminentiScreenNonHazardousWasteDisposerDeadline =>
      'Scadenza Rifiuti Non Pericolosi Smaltitore';

  @override
  String scadenzeImminentiScreenNoteTitleGeneric(String titolo) {
    return 'Nota — $titolo';
  }

  @override
  String scadenzeImminentiScreenNoteTitleSiteDeadline(
    String site,
    String label,
  ) {
    return 'Nota — $site — $label';
  }

  @override
  String get scadenzeImminentiScreenPlateLabel => 'Targa';

  @override
  String scadenzeImminentiScreenProductDeadline(String product) {
    return 'Scadenza $product';
  }

  @override
  String get scadenzeImminentiScreenReplacement18Years =>
      'Sostituzione (18 anni)';

  @override
  String get scadenzeImminentiScreenResidencyPermitDeadline =>
      'Scadenza Permesso di Soggiorno';

  @override
  String get scadenzeImminentiScreenRlstDeadline => 'Scadenza RLST';

  @override
  String get scadenzeImminentiScreenRoadTaxDeadline => 'Scadenza Bollo';

  @override
  String get scadenzeImminentiScreenRopesChainsCheck => 'Controllo funi/catene';

  @override
  String get scadenzeImminentiScreenRsppDeadline => 'Scadenza RSPP';

  @override
  String get scadenzeImminentiScreenSafetyTrainingDeadline =>
      'Scadenza Formazione Sicurezza';

  @override
  String get scadenzeImminentiScreenScaffoldingErectionDeadline =>
      'Scadenza Montaggio/Smontaggio ponteggi';

  @override
  String get scadenzeImminentiScreenSectionHeaderTitle =>
      'Scadenze da controllare';

  @override
  String get scadenzeImminentiScreenSerialNumberLabel => 'Matricola';

  @override
  String get scadenzeImminentiScreenShelvingCourseDeadline =>
      'Scadenza corso Scaffalature';

  @override
  String get scadenzeImminentiScreenShelvingIdLabel => 'ID scaffalatura';

  @override
  String get scadenzeImminentiScreenShelvingNextCheckLabel =>
      'Prossimo controllo scaffalature';

  @override
  String get scadenzeImminentiScreenShowSectionTooltip => 'Mostra scadenze';

  @override
  String get scadenzeImminentiScreenSiteLabel => 'Cantiere';

  @override
  String get scadenzeImminentiScreenSitesPresentLabel =>
      'Cantieri in cui è presente';

  @override
  String get scadenzeImminentiScreenSubcontractorLabel => 'Subappaltatore';

  @override
  String get scadenzeImminentiScreenSupervisorDeadline => 'Scadenza Preposto';

  @override
  String get scadenzeImminentiScreenTachographCardCompanyDeadline =>
      'Scadenza Carta Tachigrafica + Azienda';

  @override
  String get scadenzeImminentiScreenTachographCardDeadline =>
      'Scadenza Carta Tachigrafica';

  @override
  String get scadenzeImminentiScreenTachographCourseDeadline =>
      'Scadenza corso Cronotachigrafico';

  @override
  String get scadenzeImminentiScreenTachographDeadline => 'Scadenza Tachigrafo';

  @override
  String get scadenzeImminentiScreenTaxCodeDeadline =>
      'Scadenza Codice Fiscale';

  @override
  String get scadenzeImminentiScreenTestingDeadline => 'Scadenza Collaudo';

  @override
  String get scadenzeImminentiScreenTetanusDeadline => 'Scadenza Antitetanica';

  @override
  String get scadenzeImminentiScreenTitle => 'Scadenze imminenti';

  @override
  String get scadenzeImminentiScreenTowerCraneDeadline =>
      'Scadenza Gru a Torre';

  @override
  String get scadenzeImminentiScreenTwentyYearCheck => 'Verifica ventennale';

  @override
  String get scadenzeImminentiScreenTypeLabel => 'Tipologia';

  @override
  String get scadenzeImminentiScreenVehicleLabel => 'Veicolo';

  @override
  String get subappaltatoreDocumentiScreenAddEmployeeLabel =>
      'Inserisci dipendente';

  @override
  String get subappaltatoreDocumentiScreenAddGeneralDeadlineLabel =>
      'Inserisci scadenza generale';

  @override
  String get subappaltatoreDocumentiScreenAssociatedSitesLabel =>
      'Cantieri associati';

  @override
  String get subappaltatoreDocumentiScreenBreadcrumbCantieri => 'Cantieri';

  @override
  String get subappaltatoreDocumentiScreenBreadcrumbSubappaltatori =>
      'Subappaltatori';

  @override
  String subappaltatoreDocumentiScreenDeleteEmployeeConfirm(String nome) {
    return 'Eliminare \"$nome\"?';
  }

  @override
  String get subappaltatoreDocumentiScreenDeleteEmployeeNoDocs =>
      'Il suo nome sparirà dai cantieri in cui risulta presente.';

  @override
  String get subappaltatoreDocumentiScreenDeleteEmployeeTitle =>
      'Eliminare il dipendente?';

  @override
  String get subappaltatoreDocumentiScreenDeleteEmployeeTooltip =>
      'Elimina dipendente';

  @override
  String subappaltatoreDocumentiScreenDeleteEmployeeWithDocs(int count) {
    return 'Verranno eliminate anche le sue $count scadenze (storico compreso) e il suo nome sparirà dai cantieri in cui risulta presente.';
  }

  @override
  String get subappaltatoreDocumentiScreenDocsInOrder => 'Documenti in regola';

  @override
  String get subappaltatoreDocumentiScreenEmailLabel => 'Email';

  @override
  String get subappaltatoreDocumentiScreenEmployeesLabel => 'Dipendenti';

  @override
  String get subappaltatoreDocumentiScreenGeneralDeadlinesLabel =>
      'Scadenze generali';

  @override
  String get subappaltatoreDocumentiScreenInfoLabel => 'Informazioni:';

  @override
  String get subappaltatoreDocumentiScreenIrreversible =>
      'L\'operazione non è reversibile.';

  @override
  String get subappaltatoreDocumentiScreenNewGeneralDeadlineTooltip =>
      'Nuova scadenza generale';

  @override
  String get subappaltatoreDocumentiScreenNoDeadlinesForSite =>
      'Nessuna scadenza per questo cantiere.';

  @override
  String get subappaltatoreDocumentiScreenNoDeadlinesRegistered =>
      'Nessuna scadenza registrata';

  @override
  String get subappaltatoreDocumentiScreenNoEmployees =>
      'Nessun dipendente inserito per questo subappaltatore.';

  @override
  String get subappaltatoreDocumentiScreenNoGeneralDeadlines =>
      'Nessuna scadenza generale inserita per questo subappaltatore.';

  @override
  String get subappaltatoreDocumentiScreenOpenSiteTooltip => 'Apri cantiere';

  @override
  String get subappaltatoreDocumentiScreenSelfEmployed => 'Lavoratore autonomo';

  @override
  String subappaltatoreDocumentiScreenSiteIndexTitle(int index, String nome) {
    return '$index) $nome';
  }

  @override
  String get subappaltatoreDocumentiScreenTypeLabel => 'Tipo';

  @override
  String get subappaltatoreDocumentiScreenVatLabel => 'P. IVA';

  @override
  String get tipiDpiScreenBreadcrumbDpi => 'DPI';

  @override
  String get tipiDpiScreenBreadcrumbTipiDpi => 'Tipi di DPI';

  @override
  String tipiDpiScreenDeleteConfirmMessage(String nome) {
    return 'Eliminare la tipologia di DPI $nome? L\'operazione non è reversibile.';
  }

  @override
  String get tipiDpiScreenDeleteConfirmTitle => 'Eliminare la tipologia?';

  @override
  String get tipiDpiScreenDeleteTooltip => 'Elimina tipologia';

  @override
  String get tipiDpiScreenEditTooltip => 'Modifica tipologia';

  @override
  String get tipiDpiScreenEmptyState => 'Nessun DPI inserito.';

  @override
  String get tipiDpiScreenForHeightWork => 'Per lavori in quota';

  @override
  String get tipiDpiScreenNewDpiLabel => 'Nuovo DPI';

  @override
  String tipiDpiScreenNoteLabel(String note) {
    return 'Nota: $note';
  }

  @override
  String get campoDataClearDateTooltip => 'Rimuovi data';

  @override
  String get campoDataFormatHint => 'gg/mm/aaaa';

  @override
  String get campoDataInvalidDate => 'Data non valida';

  @override
  String get campoDataPickDateTooltip => 'Seleziona data';

  @override
  String get campoDataRemoveFieldTooltip => 'Rimuovi campo';

  @override
  String campoDataYearRange(int min, int max) {
    return 'Anno tra $min e $max';
  }

  @override
  String get creaDpiFormDialogAdditionalNotesLabel => 'Note aggiuntive';

  @override
  String get creaDpiFormDialogHeightWorkRequired =>
      'Necessario per lavori in quota';

  @override
  String get creaDpiFormDialogHeightWorkSubtitle =>
      'Richiesto automaticamente agli operai (M04) con scadenza lavori in quota impostata';

  @override
  String get creaDpiFormDialogNameLabel => 'Nome*';

  @override
  String get creaDpiFormDialogNoticeDaysHint => '30, 7, 1';

  @override
  String get creaDpiFormDialogNoticeDaysLabel => 'Giorni di Preavviso';

  @override
  String get creaDpiFormDialogTitleEdit => 'Modifica DPI';

  @override
  String get creaDpiFormDialogTitleNew => 'Nuovo DPI';

  @override
  String scadenzaCantiereTileConfirmDeleteMessage(
    String etichetta,
    String cantiere,
  ) {
    return 'Eliminare $etichetta da $cantiere? L\'operazione non è reversibile.';
  }

  @override
  String get scadenzaCantiereTileConfirmDeleteTitle => 'Eliminare la scadenza?';

  @override
  String get scadenzaCantiereTileDeleteTooltip => 'Elimina scadenza';

  @override
  String scadenzaCantiereTileDueDate(String date) {
    return 'Scadenza: $date';
  }

  @override
  String get scadenzaCantiereTileEditTooltip => 'Modifica scadenza';

  @override
  String scadenzaCantiereTileNotesLine(String note) {
    return 'Note: $note';
  }

  @override
  String notaRifiutoDialogTitle(String nomeDitta, String tipo) {
    return 'Nota — $nomeDitta — $tipo';
  }

  @override
  String notaScadenzaScalaDialogTitle(String codice) {
    return 'Nota — Scala $codice';
  }

  @override
  String get notaScadenzaDocumentoDialogDefaultType => 'documento';

  @override
  String notaScadenzaDocumentoDialogTitle(String tipo) {
    return 'Nota — $tipo';
  }

  @override
  String get creaSegnaleFormDialogBrowse => 'Sfoglia';

  @override
  String get creaSegnaleFormDialogChangeImage => 'Cambia immagine';

  @override
  String get creaSegnaleFormDialogDragDropText =>
      'Trascina qui l\'immagine del cartello';

  @override
  String creaSegnaleFormDialogExtensionNotAllowed(String estensione) {
    return 'Estensione non ammessa (.$estensione)';
  }

  @override
  String get creaSegnaleFormDialogFileTooLarge =>
      'Immagine troppo grande (max 5 MB)';

  @override
  String get creaSegnaleFormDialogFileTypesHint => 'JPG, PNG o WEBP - max 5 MB';

  @override
  String get creaSegnaleFormDialogImageSectionTitle => 'Immagine del cartello';

  @override
  String get creaSegnaleFormDialogImageUnavailable =>
      'Immagine non disponibile';

  @override
  String get creaSegnaleFormDialogLocationHint =>
      'Es. corridoio ingresso, lato nord';

  @override
  String get creaSegnaleFormDialogLocationLabel => 'Ubicazione';

  @override
  String get creaSegnaleFormDialogNameLabel => 'Nome*';

  @override
  String get creaSegnaleFormDialogRemoveImage => 'Rimuovi';

  @override
  String get creaSegnaleFormDialogTitleEdit => 'Modifica cartello';

  @override
  String get creaSegnaleFormDialogTitleNew => 'Nuovo cartello';

  @override
  String get creaSegnaleFormDialogZoneLabel => 'Zona';

  @override
  String get creaSegnaleFormDialogZoneOffice => 'Ufficio';

  @override
  String get creaSegnaleFormDialogZoneUnspecified => 'Non specificata';

  @override
  String get creaSegnaleFormDialogZoneWarehouse => 'Magazzino';

  @override
  String subappaltatoriScreenConfirmDeleteMessage(String nome) {
    return 'Eliminare \"$nome\"? L\'operazione non è reversibile.';
  }

  @override
  String get subappaltatoriScreenConfirmDeleteTitle =>
      'Eliminare subappaltatore?';

  @override
  String get subappaltatoriScreenDeleteTooltip => 'Elimina subappaltatore';

  @override
  String get subappaltatoriScreenEditTooltip => 'Modifica subappaltatore';

  @override
  String get subappaltatoriScreenEmptyLoaded =>
      'Nessun subappaltatore caricato.';

  @override
  String subappaltatoriScreenEmptySearch(String query) {
    return 'Nessun subappaltatore trovato per \"$query\".';
  }

  @override
  String get subappaltatoriScreenNewTooltip => 'Nuovo subappaltatore';

  @override
  String get subappaltatoriScreenNone => 'nessuno';

  @override
  String get subappaltatoriScreenSearchHint => 'Cerca per ragione sociale';

  @override
  String get subappaltatoriScreenSitesCount => 'Cantieri associati';

  @override
  String get subappaltatoriNumDipendenti => 'Numero di dipendenti';

  @override
  String get subappaltatoriScreenTitle => 'Subappaltatori';

  @override
  String get cantiereDetailScreenAddDeadlineLabel => 'Aggiungi scadenza';

  @override
  String get cantiereDetailScreenAddSubcontractorLabel =>
      'Aggiungi subappaltatore';

  @override
  String get cantiereDetailScreenAddressLabel => 'Indirizzo';

  @override
  String get cantiereDetailScreenBreadcrumbSites => 'Cantieri';

  @override
  String cantiereDetailScreenConfirmDeleteMessage(String nome) {
    return 'Verranno eliminate definitivamente dal server tutte le scadenze di $nome e quelle dei subappaltatori assegnati a questo cantiere.\nOPERAZIONE IRREVERSIBILE.';
  }

  @override
  String get cantiereDetailScreenConfirmDeleteTitle =>
      'Eliminare le scadenze del cantiere?';

  @override
  String cantiereDetailScreenConfirmRemoveMessage(String nome) {
    return 'Rimuovere \"$nome\" da questo cantiere? Il subappaltatore non verrà eliminato, ma le sue scadenze e quelle dei suoi dipendenti non saranno più associati a questo cantiere.';
  }

  @override
  String get cantiereDetailScreenConfirmRemoveTitle =>
      'Rimuovere subappaltatore dal cantiere?';

  @override
  String get cantiereDetailScreenDeadlinesTitle => 'Scadenze del cantiere';

  @override
  String get cantiereDetailScreenDeleteDataAction => 'Elimina dati';

  @override
  String get cantiereDetailScreenEmployeesPresentLabel => 'Dipendenti presenti';

  @override
  String get cantiereDetailScreenEmployeesPresentTooltip =>
      'Dipendenti presenti in questo cantiere';

  @override
  String get cantiereDetailScreenEndDateLabel => 'Data conclusione';

  @override
  String get cantiereDetailScreenGeneralDeadlinesTitle =>
      'Scadenze Generali del cantiere';

  @override
  String get cantiereDetailScreenInfoSectionTitle => 'Informazioni:';

  @override
  String get cantiereDetailScreenNoDeadlines =>
      'Nessuna scadenza registrata per questo cantiere.';

  @override
  String get cantiereDetailScreenNoGeneralDeadlines =>
      'Nessuna scadenza generica impostata per questo cantiere.';

  @override
  String get cantiereDetailScreenNoSubcontractors =>
      'Nessun subappaltatore associato a questo cantiere.';

  @override
  String get cantiereDetailScreenNoneValue => 'nessuno';

  @override
  String get cantiereDetailScreenNotSet => 'Non impostata';

  @override
  String get cantiereDetailScreenPostalCodeLabel => 'CAP';

  @override
  String get cantiereDetailScreenRemoveFromSiteTooltip =>
      'Rimuovi da questo cantiere';

  @override
  String get cantiereDetailScreenStartDateLabel => 'Data di inizio';

  @override
  String get cantiereDetailScreenSubcontractorsTitle => 'Subappaltatori';

  @override
  String get cantiereDetailScreenSuspensionDateLabel => 'Data sospensione';

  @override
  String get cantieriScreenActiveSitesTitle => 'Cantieri in corso';

  @override
  String get cantieriScreenArchiveAction => 'Archivio cantieri';

  @override
  String cantieriScreenConfirmDeleteMessage(String nome) {
    return 'Eliminare il cantiere $nome? L\'operazione non è reversibile.';
  }

  @override
  String get cantieriScreenConfirmDeleteTitle => 'Eliminare cantiere?';

  @override
  String get cantieriScreenDeadlineNoteLabel => 'Nota scadenza';

  @override
  String get cantieriScreenDeadlineTypesAction => 'Tipi scadenze';

  @override
  String get cantieriScreenDefaultDocumentType => 'Documento';

  @override
  String get cantieriScreenEditNoteTooltip => 'Modifica nota';

  @override
  String get cantieriScreenEmployeeLabel => 'Dipendente';

  @override
  String get cantieriScreenEmptyAllConcluded =>
      'Nessun cantiere attivo (tutti conclusi).';

  @override
  String get cantieriScreenEmptyLoaded => 'Nessun cantiere caricato.';

  @override
  String cantieriScreenEmptySearch(String query) {
    return 'Nessun cantiere trovato per \"$query\".';
  }

  @override
  String get cantieriScreenHideDeadlinesTooltip => 'Nascondi scadenze';

  @override
  String get cantieriScreenNewSiteAction => 'Nuovo cantiere';

  @override
  String cantieriScreenNoteDialogTitle(String nome, String etichetta) {
    return 'Nota — $nome — $etichetta';
  }

  @override
  String get cantieriScreenSearchHint => 'Cerca per nome o comune';

  @override
  String get cantieriScreenShowDeadlinesTooltip => 'Mostra scadenze';

  @override
  String get cantieriScreenSiteDeadlinesGroup => 'Scadenze dei cantieri';

  @override
  String get cantieriScreenSiteLabel => 'Cantiere';

  @override
  String get cantieriScreenSitesPresentLabel => 'Cantieri in cui è presente';

  @override
  String get cantieriScreenSubcontractorsAction => 'Subappaltatori';

  @override
  String get cantieriScreenTitle => 'Cantieri';

  @override
  String get cantieriScreenUpcomingDeadlinesTitle => 'Scadenze imminenti';

  @override
  String amministrazioneScreenConfirmDeleteDeadlineMessage(String nome) {
    return 'Eliminare \"$nome\"? L\'operazione non è reversibile.';
  }

  @override
  String get amministrazioneScreenConfirmDeleteDeadlineTitle =>
      'Eliminare scadenza?';

  @override
  String amministrazioneScreenConfirmDeleteEmployeeMessage(String nome) {
    return 'Eliminare \"$nome\"? L\'operazione non è reversibile.';
  }

  @override
  String get amministrazioneScreenConfirmDeleteEmployeeTitle =>
      'Eliminare dipendente?';

  @override
  String get amministrazioneScreenDeadlineDateLabel => 'Scadenza';

  @override
  String get amministrazioneScreenDeadlineNoteLabel => 'Nota scadenza';

  @override
  String get amministrazioneScreenDeleteDeadlineTooltip => 'Elimina scadenza';

  @override
  String get amministrazioneScreenDeleteEmployeeTooltip => 'Elimina dipendente';

  @override
  String get amministrazioneScreenDlAerialPlatform =>
      'Scadenza Piattaforme elevatrici';

  @override
  String get amministrazioneScreenDlContract => 'Scadenza Contratto';

  @override
  String get amministrazioneScreenDlDigitalSignature =>
      'Scadenza Firma Digitale';

  @override
  String get amministrazioneScreenDlExcavator =>
      'Scadenza Conduzione Escavatori';

  @override
  String get amministrazioneScreenDlFirefighting => 'Scadenza Antincendio';

  @override
  String get amministrazioneScreenDlFirstAid => 'Scadenza Primo Soccorso';

  @override
  String get amministrazioneScreenDlForklift =>
      'Scadenza Carrello elevatore semovente';

  @override
  String get amministrazioneScreenDlHeightWork => 'Scadenza Lavori in Quota';

  @override
  String get amministrazioneScreenDlIdCard => 'Scadenza Carta Identità';

  @override
  String get amministrazioneScreenDlIsocyanates =>
      'Scadenza corso Diisocianati';

  @override
  String get amministrazioneScreenDlLicense => 'Scadenza Patente';

  @override
  String get amministrazioneScreenDlMedicalCheckup => 'Scadenza Visita Medica';

  @override
  String get amministrazioneScreenDlResidencePermit =>
      'Scadenza Permesso di Soggiorno';

  @override
  String get amministrazioneScreenDlRlst => 'Scadenza RLST';

  @override
  String get amministrazioneScreenDlRspp => 'Scadenza RSPP';

  @override
  String get amministrazioneScreenDlSafetyTraining =>
      'Scadenza Formazione Sicurezza';

  @override
  String get amministrazioneScreenDlScaffolding =>
      'Scadenza Montaggio/Smontaggio ponteggi';

  @override
  String get amministrazioneScreenDlShelving => 'Scadenza corso Scaffalature';

  @override
  String get amministrazioneScreenDlSupervisor => 'Scadenza Preposto';

  @override
  String get amministrazioneScreenDlTachograph => 'Scadenza Carta Tachigrafica';

  @override
  String get amministrazioneScreenDlTachographCompany =>
      'Scadenza Carta Tachigrafica + Azienda';

  @override
  String get amministrazioneScreenDlTachographCourse =>
      'Scadenza corso Cronotachigrafico';

  @override
  String get amministrazioneScreenDlTaxCode => 'Scadenza Codice Fiscale';

  @override
  String get amministrazioneScreenDlTetanus => 'Scadenza Antitetanica';

  @override
  String get amministrazioneScreenDlTowerCrane => 'Scadenza Gru a Torre';

  @override
  String get amministrazioneScreenDlTruckCrane => 'Scadenza Gru Autocarro';

  @override
  String get amministrazioneScreenEditDeadlineTooltip => 'Modifica scadenza';

  @override
  String get amministrazioneScreenEditEmployeeTooltip => 'Modifica dipendente';

  @override
  String get amministrazioneScreenEditNoteTooltip => 'Modifica nota';

  @override
  String get amministrazioneScreenEmployeeDeadlinesTitle =>
      'Scadenze dipendenti';

  @override
  String get amministrazioneScreenEmployeeLabel => 'Dipendente';

  @override
  String get amministrazioneScreenEmployeesTitle => 'Dipendenti Aziendali';

  @override
  String get amministrazioneScreenEmptyDeadlinesLoaded =>
      'Nessuna scadenza caricata.';

  @override
  String amministrazioneScreenEmptyDeadlinesSearch(String query) {
    return 'Nessuna scadenza trovata per \"$query\".';
  }

  @override
  String get amministrazioneScreenEmptyEmployeesLoaded =>
      'Nessun dipendente caricato.';

  @override
  String amministrazioneScreenEmptyEmployeesSearch(String query) {
    return 'Nessun dipendente trovato per \"$query\".';
  }

  @override
  String get amministrazioneScreenFieldAerialPlatform =>
      'Piattaforme Elevatrici';

  @override
  String get amministrazioneScreenFieldAge => 'Età';

  @override
  String get amministrazioneScreenFieldBirthDate => 'Data di Nascita';

  @override
  String get amministrazioneScreenFieldBirthPlace => 'Luogo di Nascita';

  @override
  String get amministrazioneScreenFieldDigitalSignature => 'Firma Digitale';

  @override
  String get amministrazioneScreenFieldEnvironmentalManagement =>
      'Gestione Ambientale';

  @override
  String get amministrazioneScreenFieldExcavator => 'Conduzione Escavatori';

  @override
  String get amministrazioneScreenFieldFirefighting => 'Antincendio';

  @override
  String get amministrazioneScreenFieldFirstAid => 'Primo Soccorso';

  @override
  String get amministrazioneScreenFieldForklift =>
      'Carrello Elevatore Semovente';

  @override
  String get amministrazioneScreenFieldGeneralSafetyTraining =>
      'Formazione Sicurezza generale';

  @override
  String get amministrazioneScreenFieldHealthCard => 'Tessera Sanitara';

  @override
  String get amministrazioneScreenFieldHeightWork => 'Lavori in Quota';

  @override
  String get amministrazioneScreenFieldIdCard => 'Carta d\'identità';

  @override
  String get amministrazioneScreenFieldIsocyanates => 'Corso Diisocianati';

  @override
  String get amministrazioneScreenFieldLicense => 'Patente';

  @override
  String get amministrazioneScreenFieldMedicalCheckup => 'Visita Medica';

  @override
  String get amministrazioneScreenFieldModel231 => 'Modello 231';

  @override
  String get amministrazioneScreenFieldName => 'Nome';

  @override
  String get amministrazioneScreenFieldRentri => 'Rentri';

  @override
  String get amministrazioneScreenFieldResidencePermit =>
      'Permesso di soggiorno';

  @override
  String get amministrazioneScreenFieldRlst => 'RLST';

  @override
  String get amministrazioneScreenFieldRole => 'Mansione';

  @override
  String get amministrazioneScreenFieldRspp => 'RSPP';

  @override
  String get amministrazioneScreenFieldScaffolding =>
      'Montaggio/Smontaggio Ponteggi';

  @override
  String get amministrazioneScreenFieldShelving => 'Corso Scaffalature';

  @override
  String get amministrazioneScreenFieldSupervisor => 'Preposto';

  @override
  String get amministrazioneScreenFieldTachograph => 'Carta Tachigrafica';

  @override
  String get amministrazioneScreenFieldTachographCourse =>
      'Corso Cronotachigrafico';

  @override
  String get amministrazioneScreenFieldTaxCode => 'Codice Fiscale';

  @override
  String get amministrazioneScreenFieldTetanus => 'Antitetanica';

  @override
  String get amministrazioneScreenFieldTowerCrane => 'Gru a Torre';

  @override
  String get amministrazioneScreenFieldTruckCrane => 'Gru Autocarro';

  @override
  String get amministrazioneScreenGeneralDeadlinesTitle => 'Scadenze generali';

  @override
  String get amministrazioneScreenHideAllTooltip => 'Nascondi tutti';

  @override
  String get amministrazioneScreenHideDeadlinesTooltip => 'Nascondi scadenze';

  @override
  String get amministrazioneScreenHideDetailsTooltip => 'Nascondi dettagli';

  @override
  String get amministrazioneScreenNoUpcomingDeadlines =>
      'Nessuna scadenza imminente.';

  @override
  String get amministrazioneScreenSearchDeadlinesHint =>
      'Cerca per nome o nota';

  @override
  String get amministrazioneScreenSearchEmployeesHint =>
      'Cerca per nome, cognome o mansione';

  @override
  String get amministrazioneScreenSectionCoursesCompleted =>
      'Scadenza corsi effettuati';

  @override
  String get amministrazioneScreenSectionPersonalDeadlines =>
      'Scadenze Personali';

  @override
  String get amministrazioneScreenSectionPersonalInfo => 'Anagrafica';

  @override
  String get amministrazioneScreenSectionTrainingDates =>
      'Data corsi formazione effettuati';

  @override
  String get amministrazioneScreenShowAllTooltip => 'Mostra tutti';

  @override
  String get amministrazioneScreenShowDeadlinesTooltip => 'Mostra scadenze';

  @override
  String get amministrazioneScreenShowDetailsTooltip => 'Mostra dettagli';

  @override
  String get amministrazioneScreenTitle => 'Amministrazione';

  @override
  String get amministrazioneScreenUpcomingDeadlinesTitle =>
      'Scadenze imminenti';

  @override
  String get fasceCateneScreenInMagazzino => 'In magazzino';

  @override
  String fasceCateneScreenInCantiere(String nome) {
    return 'In cantiere $nome';
  }

  @override
  String fasceCateneScreenSuAutomezzo(String nome) {
    return 'Su automezzo $nome';
  }

  @override
  String get fasceCateneScreenNonSpecificata => 'Non specificata';

  @override
  String get fasceCateneScreenEsitoPositivo => 'Positivo';

  @override
  String get fasceCateneScreenEsitoNegativo => 'Negativo';

  @override
  String get fasceCateneScreenTitle => 'Fasce, Catene e Benne';

  @override
  String get fasceCateneScreenNuovaFasciaCatena => 'Nuova fascia/catena';

  @override
  String get fasceCateneScreenInserisciBenna => 'Inserisci benna';

  @override
  String get fasceCateneScreenPresenti => 'Fasce, catene e benne presenti';

  @override
  String get fasceCateneScreenNascondiTutti => 'Nascondi tutti';

  @override
  String get fasceCateneScreenMostraTutti => 'Mostra tutti';

  @override
  String get fasceCateneScreenSearchHint =>
      'Cerca per ID, numero di serie, tipo o ubicazione';

  @override
  String get fasceCateneScreenNessunElementoCaricato =>
      'Nessun elemento caricato.';

  @override
  String fasceCateneScreenNessunElementoTrovato(String query) {
    return 'Nessun elemento trovato per \"$query\".';
  }

  @override
  String get fasceCateneScreenBenneAutoscaricanti => 'Benne autoscaricanti';

  @override
  String get fasceCateneScreenAnagrafica => 'Anagrafica';

  @override
  String get fasceCateneScreenNumeroSerie => 'N. serie';

  @override
  String get fasceCateneScreenUbicazione => 'Ubicazione';

  @override
  String get fasceCateneScreenVerificaConEsito => 'Verifica con esito';

  @override
  String get fasceCateneScreenEsitoNegativoLower => 'negativo';

  @override
  String get fasceCateneScreenEsitoPositivoLower => 'positivo';

  @override
  String get fasceCateneScreenTipo => 'Tipo';

  @override
  String get fasceCateneScreenCricchetto => 'Cricchetto';

  @override
  String get fasceCateneScreenIdInterno => 'ID interno';

  @override
  String get fasceCateneScreenNumeroSerieProduttore => 'N. serie produttore';

  @override
  String get fasceCateneScreenColore => 'Colore';

  @override
  String get fasceCateneScreenCaratteristiche => 'Caratteristiche';

  @override
  String get fasceCateneScreenPortataKg => 'Portata (Kg)';

  @override
  String get fasceCateneScreenSpessoreMm => 'Spessore (mm)';

  @override
  String get fasceCateneScreenDiametroMm => 'Diametro (mm)';

  @override
  String get fasceCateneScreenLarghezzaMm => 'Larghezza (mm)';

  @override
  String get fasceCateneScreenLunghezzaM => 'Lunghezza (m)';

  @override
  String get fasceCateneScreenUbicazioneEAcquisto => 'Ubicazione e acquisto';

  @override
  String get fasceCateneScreenDataAcquisto => 'Data acquisto';

  @override
  String get fasceCateneScreenLuogoAcquisto => 'Luogo acquisto';

  @override
  String get fasceCateneScreenVerificaInterna => 'Verifica interna';

  @override
  String get fasceCateneScreenUltimaVerifica => 'Ultima verifica';

  @override
  String get fasceCateneScreenEsito => 'Esito';

  @override
  String get fasceCateneScreenProssimaVerifica => 'Prossima verifica';

  @override
  String get fasceCateneScreenEliminareFasciaCatenaTitle =>
      'Eliminare la fascia/catena?';

  @override
  String get fasceCateneScreenEliminareBennaTitle => 'Eliminare la benna?';

  @override
  String fasceCateneScreenConfirmDeleteMessage(String nome) {
    return 'Eliminare \"$nome\"? L\'operazione non è reversibile.';
  }

  @override
  String get fasceCateneScreenNascondiInfo => 'Nascondi info';

  @override
  String get fasceCateneScreenMostraInfo => 'Mostra info';

  @override
  String get fasceCateneScreenDescrizione => 'Descrizione';

  @override
  String get fasceCateneScreenCapacitaCarico => 'Capacità di carico';

  @override
  String get fasceCateneScreenIngrandisciFoto => 'Ingrandisci foto';

  @override
  String get fasceCateneScreenImmagineNonDisponibile =>
      'Immagine non disponibile';

  @override
  String fasceCateneScreenBennaTitolo(String idInterno) {
    return '$idInterno - Benna';
  }

  @override
  String get scaleScreenCodice => 'Codice';

  @override
  String get scaleScreenMateriale => 'Materiale';

  @override
  String get scaleScreenDescrizione => 'Descrizione';

  @override
  String get scaleScreenUbicazione => 'Ubicazione';

  @override
  String get scaleScreenUltimaVerifica => 'Ultima verifica';

  @override
  String get scaleScreenProssimaVerifica => 'Prossima verifica';

  @override
  String get scaleScreenInMagazzino => 'In magazzino';

  @override
  String scaleScreenInCantiere(String nome) {
    return 'In cantiere $nome';
  }

  @override
  String get scaleScreenNonSpecificata => 'Non specificata';

  @override
  String get scaleScreenTitle => 'Scale';

  @override
  String scaleScreenPdfCount(int count) {
    return '$count scale';
  }

  @override
  String scaleScreenPdfFiltro(String filtro) {
    return 'filtro di ricerca: \"$filtro\"';
  }

  @override
  String scaleScreenStampaErrore(String dettagli) {
    return 'Impossibile generare la stampa: $dettagli';
  }

  @override
  String get scaleScreenNuovaScala => 'Nuova scala';

  @override
  String get scaleScreenStampa => 'Stampa';

  @override
  String get scaleScreenScadenzeImminenti => 'Scadenze imminenti';

  @override
  String get scaleScreenNascondiScadenze => 'Nascondi scadenze';

  @override
  String get scaleScreenMostraScadenze => 'Mostra scadenze';

  @override
  String get scaleScreenPresenti => 'Scale presenti';

  @override
  String get scaleScreenNascondiTutti => 'Nascondi tutti';

  @override
  String get scaleScreenMostraTutti => 'Mostra tutti';

  @override
  String get scaleScreenSearchHint =>
      'Cerca per codice, materiale o ubicazione';

  @override
  String get scaleScreenNessunElementoCaricato => 'Nessun elemento caricato.';

  @override
  String scaleScreenNessunElementoTrovato(String query) {
    return 'Nessun elemento trovato per \"$query\".';
  }

  @override
  String get scaleScreenCodiceScala => 'Codice scala';

  @override
  String get scaleScreenNotaScadenza => 'Nota scadenza';

  @override
  String get scaleScreenModificaNota => 'Modifica nota';

  @override
  String get scaleScreenEliminaScala => 'Elimina scala';

  @override
  String get scaleScreenEliminareScalaTitle => 'Eliminare scala?';

  @override
  String scaleScreenConfirmDeleteMessage(String codice) {
    return 'Eliminare \"$codice\"? L\'operazione non è reversibile.';
  }

  @override
  String get scaleScreenNascondiInfo => 'Nascondi info';

  @override
  String get scaleScreenMostraInfo => 'Mostra info';

  @override
  String get scaleScreenAnagrafica => 'Anagrafica';

  @override
  String get scaleScreenControlli => 'Controlli';

  @override
  String bennaFormDialogEstensioneNonAmmessa(String estensione) {
    return 'Estensione non ammessa (.$estensione)';
  }

  @override
  String get bennaFormDialogImmagineTroppoGrande =>
      'Immagine troppo grande (max 5 MB)';

  @override
  String get bennaFormDialogModificaTitle => 'Modifica benna';

  @override
  String get bennaFormDialogNuovaTitle => 'Nuova benna';

  @override
  String get bennaFormDialogAnagrafica => 'Anagrafica';

  @override
  String get bennaFormDialogIdInterno => 'ID interno*';

  @override
  String get bennaFormDialogDescrizione => 'Descrizione';

  @override
  String get bennaFormDialogNumeroSerieProduttore =>
      'Numero di serie produttore';

  @override
  String get bennaFormDialogCapacitaCaricoLt => 'Capacità di carico (Lt)';

  @override
  String get bennaFormDialogUbicazione => 'Ubicazione';

  @override
  String get bennaFormDialogTipoUbicazione => 'Tipo ubicazione';

  @override
  String get bennaFormDialogNonSpecificata => 'Non specificata';

  @override
  String get bennaFormDialogMagazzino => 'Magazzino';

  @override
  String get bennaFormDialogCantiere => 'Cantiere';

  @override
  String get bennaFormDialogSelezionaCantiere => 'Seleziona un cantiere';

  @override
  String get bennaFormDialogAcquisto => 'Acquisto';

  @override
  String get bennaFormDialogDataAcquisto => 'Data di acquisto';

  @override
  String get bennaFormDialogVerificaInterna => 'Verifica interna';

  @override
  String get bennaFormDialogUltimaVerificaInterna => 'Ultima verifica interna';

  @override
  String get bennaFormDialogProssimaVerifica => 'Prossima verifica';

  @override
  String get bennaFormDialogEsitoVerificaPositivo => 'Esito verifica positivo';

  @override
  String get bennaFormDialogIdoneaUso => 'Idonea all\'uso';

  @override
  String get bennaFormDialogNonIdonea =>
      'Non idonea: da mettere fuori servizio';

  @override
  String get bennaFormDialogFoto => 'Foto';

  @override
  String get bennaFormDialogCambiaFoto => 'Cambia foto';

  @override
  String get bennaFormDialogSfoglia => 'Sfoglia';

  @override
  String get bennaFormDialogRimuovi => 'Rimuovi';

  @override
  String get bennaFormDialogNoteAggiuntive => 'Note aggiuntive';

  @override
  String get bennaFormDialogImmagineNonDisponibile =>
      'Immagine non disponibile';

  @override
  String get bennaFormDialogTrascinaFoto => 'Trascina qui la foto della benna';

  @override
  String get bennaFormDialogFormatiAmmessi => 'JPG, PNG o WEBP - max 5 MB';

  @override
  String get scadenzaCantiereFormDialogNomeScadenzaTitle => 'Nome scadenza';

  @override
  String get scadenzaCantiereFormDialogNomeScadenzaHint =>
      'Es. Ponteggio, Gru, Recinzione...';

  @override
  String get scadenzaCantiereFormDialogContinua => 'Continua';

  @override
  String get scadenzaCantiereFormDialogTitle =>
      'Scadenze generali del cantiere';

  @override
  String get scadenzaCantiereFormDialogScadenzaMessaTerra =>
      'Scadenza Messa a Terra';

  @override
  String get scadenzaCantiereFormDialogRimuoviMessaTerra =>
      'Rimuovi scadenza messa a terra';

  @override
  String get scadenzaCantiereFormDialogAggiungiMessaTerra =>
      'Aggiungi scadenza messa a terra';

  @override
  String scadenzaCantiereFormDialogScadenzaGenerica(int numero) {
    return 'Scadenza generica $numero';
  }

  @override
  String get scadenzaCantiereFormDialogRimuoviQuesta =>
      'Rimuovi questa scadenza';

  @override
  String get scadenzaCantiereFormDialogAggiungiGenerica =>
      'Aggiungi scadenza generica';

  @override
  String get tipiScadenzeScreenTitle => 'Tipi di Scadenze';

  @override
  String get tipiScadenzeScreenNuovaTipologia => 'Nuova tipologia';

  @override
  String get tipiScadenzeScreenSearchHint => 'Cerca per tipologia';

  @override
  String get tipiScadenzeScreenNessunaTipologiaCaricata =>
      'Nessuna tipologia caricata.';

  @override
  String tipiScadenzeScreenNessunaTipologiaTrovata(String query) {
    return 'Nessuna tipologia trovato per \"$query\".';
  }

  @override
  String get tipiScadenzeScreenRichiedeScadenza => 'Richiede scadenza';

  @override
  String get tipiScadenzeScreenAvviso => 'Avviso';

  @override
  String get tipiScadenzeScreenAvvisoDalGiorno => 'dal giorno dopo la scadenza';

  @override
  String get tipiScadenzeScreenPreavviso => 'Preavviso';

  @override
  String tipiScadenzeScreenGiorniPreavviso(String giorni) {
    return '$giorni giorni';
  }

  @override
  String get tipiScadenzeScreenCollegatoA => 'Collegato a';

  @override
  String get tipiScadenzeScreenModificaTipologia => 'Modifica tipologia';

  @override
  String get tipiScadenzeScreenEliminaTipologia => 'Elimina tipologia';

  @override
  String get tipiScadenzeScreenEliminareTitle => 'Eliminare la tipologia?';

  @override
  String tipiScadenzeScreenEliminareMessage(String nome) {
    return 'Eliminare la tipologia di scadenza $nome? L\'operazione non è reversibile.';
  }

  @override
  String get tipiScadenzeScreenCantiere => 'Cantiere';

  @override
  String get tipiScadenzeScreenSubappaltatore => 'Subappaltatore';

  @override
  String get tipiScadenzeScreenDipendenteSubappaltatore =>
      'Dipendente del subappaltatore';

  @override
  String get tipiScadenzeScreenDipendenteSubappaltatoreAutonomo =>
      'Dipendente del subappaltatore (e lavoratori autonomi)';

  @override
  String get tipiScadenzeScreenLavoratoreAutonomo => 'Lavoratore autonomo';

  @override
  String tipiScadenzeScreenElencoFinale(String a, String b) {
    return '$a e $b';
  }

  @override
  String get dipendenteSubappaltatoreDetailScreenCantieri => 'Cantieri';

  @override
  String get dipendenteSubappaltatoreDetailScreenSubappaltatori =>
      'Subappaltatori';

  @override
  String get dipendenteSubappaltatoreDetailScreenDipendentiAziendali =>
      'Dipendenti Aziendali';

  @override
  String get dipendenteSubappaltatoreDetailScreenInformazioni =>
      'Informazioni:';

  @override
  String get dipendenteSubappaltatoreDetailScreenTipo => 'Tipo';

  @override
  String get dipendenteSubappaltatoreDetailScreenLavoratoreAutonomo =>
      'Lavoratore autonomo';

  @override
  String get dipendenteSubappaltatoreDetailScreenNessunCantiere =>
      'Il subappaltatore non è associato a nessun cantiere.';

  @override
  String get dipendenteSubappaltatoreDetailScreenScadenzeDocumenti =>
      'Scadenze documenti e certificazioni';

  @override
  String get dipendenteSubappaltatoreDetailScreenAggiungiScadenza =>
      'Aggiungi scadenza';

  @override
  String get dipendenteSubappaltatoreDetailScreenNessunaScadenza =>
      'Nessuna scadenza registrata per questo dipendente.';

  @override
  String get dipendenteSubappaltatoreFormDialogNuovo => 'Nuovo dipendente';

  @override
  String get dipendenteSubappaltatoreFormDialogModifica =>
      'Modifica dipendente';

  @override
  String get dipendenteSubappaltatoreFormDialogNome => 'Nome*';

  @override
  String get dipendenteSubappaltatoreFormDialogCognome => 'Cognome*';

  @override
  String get dipendenteSubappaltatoreFormDialogNoteHelper =>
      'Mostrate nel riquadro \"Informazioni\" della pagina del dipendente';

  @override
  String get dipendenteSubappaltatoreFormDialogLavoratoreAutonomo =>
      'Lavoratore autonomo';

  @override
  String get dipendenteSubappaltatoreFormDialogLavoratoreAutonomoSubtitle =>
      'Oltre alle scadenze del dipendente può registrare anche quelle riservate ai lavoratori autonomi';

  @override
  String modificaScadenzaDocumentoDialogModificaTipo(String tipo) {
    return 'Modifica $tipo';
  }

  @override
  String get modificaScadenzaDocumentoDialogModificaScadenza =>
      'Modifica scadenza';

  @override
  String get modificaScadenzaDocumentoDialogDataScadenza => 'Data di scadenza';

  @override
  String notaMisuraDialogTitle(String nome, String tipo) {
    return 'Nota — $nome — $tipo';
  }

  @override
  String notaScadenzaGeneraleDialogTitle(String nome) {
    return 'Nota — $nome';
  }

  @override
  String dipendentiPresentiDialogTitle(String nome) {
    return 'Dipendenti presenti — $nome';
  }

  @override
  String get dipendentiPresentiDialogNessunDipendente =>
      'Nessun dipendente registrato per questo subappaltatore.';

  @override
  String dipendentiPresentiDialogNote(String note) {
    return 'Note: $note';
  }

  @override
  String get primoSoccorsoScreenTitle => 'Primo Soccorso';

  @override
  String get primoSoccorsoScreenStandardProductsLabel => 'Prodotti standard';

  @override
  String get primoSoccorsoScreenNewItemLabel => 'Nuovo elemento';

  @override
  String get primoSoccorsoScreenUpcomingDeadlines => 'Scadenze imminenti';

  @override
  String get primoSoccorsoScreenHideDeadlinesTooltip => 'Nascondi scadenze';

  @override
  String get primoSoccorsoScreenShowDeadlinesTooltip => 'Mostra scadenze';

  @override
  String get primoSoccorsoScreenSectionTitle =>
      'Cassette e Pacchetti di primo soccorso';

  @override
  String get primoSoccorsoScreenHideAllTooltip => 'Nascondi tutte';

  @override
  String get primoSoccorsoScreenShowAllTooltip => 'Mostra tutte';

  @override
  String get primoSoccorsoScreenSearchHint =>
      'Cerca per numero, posizione o tipologia';

  @override
  String get primoSoccorsoScreenNoItemsLoaded => 'Nessun elemento caricato.';

  @override
  String primoSoccorsoScreenNoItemsFound(String query) {
    return 'Nessun elemento trovato per \"$query\".';
  }

  @override
  String get primoSoccorsoScreenArticleLabel => 'Articolo';

  @override
  String get primoSoccorsoScreenLocationLabel => 'Ubicazione';

  @override
  String get primoSoccorsoScreenDeadlineNoteLabel => 'Nota scadenza';

  @override
  String get primoSoccorsoScreenEditNoteTooltip => 'Modifica nota';

  @override
  String get primoSoccorsoScreenEditItemTooltip => 'Modifica elemento';

  @override
  String get primoSoccorsoScreenDeleteItemTooltip => 'Elimina elemento';

  @override
  String get primoSoccorsoScreenDeleteConfirmTitle => 'Eliminare elemento?';

  @override
  String primoSoccorsoScreenDeleteConfirmMessage(String numero) {
    return 'Eliminare \"$numero\"? L\'operazione non è reversibile.';
  }

  @override
  String get primoSoccorsoScreenHideInfoTooltip => 'Nascondi info';

  @override
  String get primoSoccorsoScreenShowInfoTooltip => 'Mostra info';

  @override
  String get primoSoccorsoScreenChecksSectionTitle => 'Controlli e Scadenze';

  @override
  String get primoSoccorsoScreenLastCheckLabel => 'Ultima verifica';

  @override
  String get primoSoccorsoScreenNextCheckLabel => 'Prossimo controllo';

  @override
  String get primoSoccorsoScreenNextProductDeadlineLabel =>
      'Prossima scadenza prodotti';

  @override
  String primoSoccorsoScreenNotaDialogTitle(String titolo) {
    return 'Nota — $titolo';
  }

  @override
  String get primoSoccorsoScreenNextCheckType => 'Prossimo Controllo';

  @override
  String primoSoccorsoScreenProductDeadlineType(String nomeProdotto) {
    return 'Scadenza $nomeProdotto';
  }

  @override
  String get primoSoccorsoScreenLocationWarehouse => 'In magazzino';

  @override
  String get primoSoccorsoScreenLocationOffice => 'In ufficio';

  @override
  String primoSoccorsoScreenLocationSite(String nome) {
    return 'In cantiere $nome';
  }

  @override
  String primoSoccorsoScreenLocationVehicle(String nome) {
    return 'Su automezzo $nome';
  }

  @override
  String get primoSoccorsoScreenLocationUnspecified => 'Non specificata';

  @override
  String get impiantiScreenPdfOffice => 'Ufficio';

  @override
  String get impiantiScreenPdfWarehouse => 'Magazzino';

  @override
  String get impiantiScreenPdfUnspecified => 'Non specificato';

  @override
  String get impiantiScreenColType => 'Tipologia';

  @override
  String get impiantiScreenColLocation => 'Ubicazione';

  @override
  String get impiantiScreenColInstallerCompany => 'Ditta installazione';

  @override
  String get impiantiScreenColInstallDate => 'Data installazione';

  @override
  String get impiantiScreenColAssessmentDate => 'Data valutazione';

  @override
  String get impiantiScreenColInternalMaintDate => 'Data manut. interna';

  @override
  String get impiantiScreenColInternalMaintDeadline => 'Scad. manut. interna';

  @override
  String get impiantiScreenColInternalCheckType => 'Tipo verifica interna';

  @override
  String get impiantiScreenColExternalMaintDate => 'Data manut. esterna';

  @override
  String get impiantiScreenColExternalMaintDeadline => 'Scad. manut. esterna';

  @override
  String get impiantiScreenColExternalCheckType => 'Tipo verifica esterna';

  @override
  String get impiantiScreenColLightningAssessmentDeadline =>
      'Scad. val. scariche atmosferiche';

  @override
  String get impiantiScreenInternalMaintenanceDeadlineType =>
      'Scadenza Manutenzione Interna';

  @override
  String get impiantiScreenExternalMaintenanceDeadlineType =>
      'Scadenza Manutenzione Esterna';

  @override
  String get impiantiScreenTitle => 'Impianti';

  @override
  String impiantiScreenPdfSubtitleCount(int count) {
    return '$count impianti';
  }

  @override
  String impiantiScreenPdfSubtitleFilter(String filtro) {
    return 'filtro di ricerca: \"$filtro\"';
  }

  @override
  String impiantiScreenPrintErrorMessage(String details) {
    return 'Impossibile generare la stampa: $details';
  }

  @override
  String get impiantiScreenNewSystemLabel => 'Nuovo impianto';

  @override
  String get impiantiScreenPrintLabel => 'Stampa';

  @override
  String get impiantiScreenUpcomingDeadlines => 'Scadenze imminenti';

  @override
  String get impiantiScreenHideDeadlinesTooltip => 'Nascondi scadenze';

  @override
  String get impiantiScreenShowDeadlinesTooltip => 'Mostra scadenze';

  @override
  String get impiantiScreenActiveSystemsTitle => 'Impianti attivi';

  @override
  String get impiantiScreenCollapseAllTooltip => 'Chiudi tutti';

  @override
  String get impiantiScreenExpandAllTooltip => 'Espandi tutti';

  @override
  String get impiantiScreenSearchHint => 'Cerca per nome';

  @override
  String get impiantiScreenNoItemsLoaded => 'Nessun impianto caricato.';

  @override
  String impiantiScreenNoItemsFound(String query) {
    return 'Nessun impianto trovato per \"$query\".';
  }

  @override
  String get impiantiScreenLocationOfficeLower => 'in Ufficio';

  @override
  String get impiantiScreenLocationWarehouseLower => 'in Magazzino';

  @override
  String get impiantiScreenLocationUnspecifiedLower => 'non specificata';

  @override
  String get impiantiScreenDeadlineNoteLabel => 'Nota scadenza';

  @override
  String get impiantiScreenEditNoteTooltip => 'Modifica nota';

  @override
  String get impiantiScreenEditSystemTooltip => 'Modifica impianto';

  @override
  String get impiantiScreenDeleteSystemTooltip => 'Elimina impianto';

  @override
  String get impiantiScreenDeleteConfirmTitle => 'Eliminare impianto?';

  @override
  String impiantiScreenDeleteConfirmMessage(String tipologia) {
    return 'Eliminare \"$tipologia\"? L\'operazione non è reversibile.';
  }

  @override
  String get impiantiScreenHideInfoTooltip => 'Nascondi info';

  @override
  String get impiantiScreenShowInfoTooltip => 'Mostra info';

  @override
  String get impiantiScreenInstallationSectionTitle => 'Installazione';

  @override
  String get impiantiScreenInstallerCompanyLabel => 'Ditta installatrice';

  @override
  String get impiantiScreenInstallDateLabel => 'Data di Installazione';

  @override
  String get impiantiScreenAssessmentDateLabel => 'Data di Valutazione';

  @override
  String get impiantiScreenInternalMaintenanceSectionTitle =>
      'Manutenzione Interna';

  @override
  String get impiantiScreenInternalMaintDateLabel =>
      'Data manutenzione interna';

  @override
  String get impiantiScreenInternalMaintDeadlineLabel =>
      'Scadenza manutenzione interna';

  @override
  String get impiantiScreenCheckTypeLabel => 'Tipo di Verifica';

  @override
  String get impiantiScreenExternalMaintenanceSectionTitle =>
      'Manutenzione Esterna';

  @override
  String get impiantiScreenExternalMaintDateLabel =>
      'Data manutenzione esterna';

  @override
  String get impiantiScreenExternalMaintDeadlineLabel =>
      'Scadenza manutenzione esterna';

  @override
  String get impiantiScreenLightningSectionTitle => 'Scariche Atmosferiche';

  @override
  String get impiantiScreenLightningAssessmentDeadlineLabel =>
      'Scadenza valutazione scariche atmosferiche';

  @override
  String get impiantiScreenAdditionalNotesSectionTitle => 'Note aggiuntive';

  @override
  String get macchinarioFormDialogOwnershipOwned => 'Di Proprietà';

  @override
  String get macchinarioFormDialogOwnershipRented => 'Noleggio';

  @override
  String get macchinarioFormDialogOwnershipLeased => 'Leasing';

  @override
  String get macchinarioFormDialogNewTitle => 'Nuovo macchinario';

  @override
  String get macchinarioFormDialogEditTitle => 'Modifica macchinario';

  @override
  String get macchinarioFormDialogModelLabel => 'Modello*';

  @override
  String get macchinarioFormDialogSerialNumberLabel => 'Numero matricola';

  @override
  String get macchinarioFormDialogFactoryNumberLabel => 'Numero di fabbrica';

  @override
  String get macchinarioFormDialogPurchaseYearLabel => 'Anno di acquisto';

  @override
  String get macchinarioFormDialogTypeLabel => 'Tipologia';

  @override
  String get macchinarioFormDialogUnspecifiedOption => 'Non specificata';

  @override
  String get macchinarioFormDialogOwnershipLabel => 'Proprietà';

  @override
  String get macchinarioFormDialogLeasingCompanyLabel => 'Compagnia di Leasing';

  @override
  String get macchinarioFormDialogLeasingDeadlineLabel => 'Scadenza Leasing';

  @override
  String get macchinarioFormDialogRentalCompanyLabel => 'Azienda di Noleggio';

  @override
  String get macchinarioFormDialogRentalEmailLabel =>
      'Email dell\'azienda di noleggio';

  @override
  String get macchinarioFormDialogInvalidEmailValidator =>
      'Inserisci email valida';

  @override
  String get macchinarioFormDialogCivaInailLabel => 'Presente in CIVA/INAIL';

  @override
  String get macchinarioFormDialogInUseLabel => 'In uso?';

  @override
  String get macchinarioFormDialogLocationSectionTitle => 'Ubicazione';

  @override
  String get macchinarioFormDialogLocationTypeLabel => 'Tipo ubicazione';

  @override
  String get macchinarioFormDialogLocationWarehouse => 'Magazzino';

  @override
  String get macchinarioFormDialogLocationSite => 'Cantiere';

  @override
  String get macchinarioFormDialogLocationVehicle => 'Automezzo';

  @override
  String get macchinarioFormDialogSiteValidator => 'Seleziona un cantiere';

  @override
  String get macchinarioFormDialogVehicleValidator => 'Seleziona un automezzo';

  @override
  String get macchinarioFormDialogInsuranceCompanyLabel =>
      'Compagnia assicurativa';

  @override
  String get macchinarioFormDialogInsuranceDeadlineLabel =>
      'Scadenza Assicurazione';

  @override
  String get macchinarioFormDialogRemoveInsuranceDeadlineTooltip =>
      'Rimuovi scadenza assicurazione';

  @override
  String get macchinarioFormDialogAddInsuranceDeadlineLabel =>
      'Aggiungi scadenza assicurazione';

  @override
  String get macchinarioFormDialogInternalMaintenanceSectionTitle =>
      'Manutenzione interna';

  @override
  String get macchinarioFormDialogInterventionDateLabel => 'Data intervento';

  @override
  String get macchinarioFormDialogDeadlineLabel => 'Scadenza';

  @override
  String get macchinarioFormDialogRopeChainCheckSectionTitle =>
      'Controllo funi/catene';

  @override
  String get macchinarioFormDialogCheckDateLabel => 'Data controllo';

  @override
  String get macchinarioFormDialogAnnualCheckSectionTitle => 'Verifica annuale';

  @override
  String get macchinarioFormDialogInspectionDateLabel => 'Data verifica';

  @override
  String get macchinarioFormDialogTwentyYearCheckSectionTitle =>
      'Verifica ventennale';

  @override
  String get macchinarioFormDialogAdditionalNotesLabel => 'Note aggiuntive';

  @override
  String get scaffalatureScreenNextCheckType =>
      'Prossimo controllo scaffalature';

  @override
  String get scaffalatureScreenTitle => 'Scaffalature';

  @override
  String get scaffalatureScreenAddLabel => 'Aggiungi scaffalatura';

  @override
  String get scaffalatureScreenUpcomingDeadlines => 'Scadenze imminenti';

  @override
  String get scaffalatureScreenHideDeadlinesTooltip => 'Nascondi scadenze';

  @override
  String get scaffalatureScreenShowDeadlinesTooltip => 'Mostra scadenze';

  @override
  String get scaffalatureScreenSectionTitle => 'Scaffalature presenti';

  @override
  String get scaffalatureScreenHideAllTooltip => 'Nascondi tutti';

  @override
  String get scaffalatureScreenShowAllTooltip => 'Mostra tutti';

  @override
  String get scaffalatureScreenNoItemsLoaded => 'Nessun elemento caricato.';

  @override
  String get scaffalatureScreenIdLabel => 'ID scaffalatura';

  @override
  String get scaffalatureScreenLastCheckLabel => 'Ultima verifica';

  @override
  String get scaffalatureScreenDeadlineNoteLabel => 'Nota scadenza';

  @override
  String get scaffalatureScreenEditNoteTooltip => 'Modifica nota';

  @override
  String scaffalatureScreenCardTitle(String id) {
    return 'Scaffalatura ID #$id';
  }

  @override
  String get scaffalatureScreenNextCheckLabel => 'Prossima verifica';

  @override
  String get scaffalatureScreenDeleteTooltip => 'Elimina scaffale';

  @override
  String get scaffalatureScreenDeleteConfirmTitle => 'Eliminare scaffalatura?';

  @override
  String scaffalatureScreenDeleteConfirmMessage(String id) {
    return 'Eliminare la scaffalatura #$id? L\'operazione non è reversibile.';
  }

  @override
  String get scaffalatureScreenHideInfoTooltip => 'Nascondi info';

  @override
  String get scaffalatureScreenShowInfoTooltip => 'Mostra info';

  @override
  String get scaffalatureScreenChecksSectionTitle => 'Controlli';

  @override
  String get scaffalatureScreenOutcomeLabel => 'Esito';

  @override
  String get scaffalatureScreenOutcomePositive => 'Positivo';

  @override
  String get scaffalatureScreenOutcomeNegative => 'Negativo';

  @override
  String get impiantiFormDialogNewTitle => 'Nuovo impianto';

  @override
  String get impiantiFormDialogEditTitle => 'Modifica impianto';

  @override
  String get impiantiFormDialogTypeLabel => 'Tipologia*';

  @override
  String get impiantiFormDialogLocationTypeLabel => 'Tipo ubicazione';

  @override
  String get impiantiFormDialogUnspecifiedOption => 'Non specificata';

  @override
  String get impiantiFormDialogLocationWarehouse => 'Magazzino';

  @override
  String get impiantiFormDialogLocationOffice => 'Ufficio';

  @override
  String get impiantiFormDialogInstallationSectionTitle => 'Installazione';

  @override
  String get impiantiFormDialogInstallDateLabel => 'Data installazione';

  @override
  String get impiantiFormDialogInstallerCompanyLabel => 'Ditta installatrice';

  @override
  String get impiantiFormDialogAssessmentDateLabel => 'Data di Valutazione';

  @override
  String get impiantiFormDialogInternalMaintenanceSectionTitle =>
      'Manutenzione Interna';

  @override
  String get impiantiFormDialogInternalMaintDateLabel =>
      'Data di Manutenzione interna';

  @override
  String get impiantiFormDialogInternalMaintDeadlineLabel =>
      'Scadenza Manutenzione interna';

  @override
  String get impiantiFormDialogInternalCheckTypeLabel =>
      'Tipo di verifica interna';

  @override
  String get impiantiFormDialogExternalMaintenanceSectionTitle =>
      'Manutenzione Esterna';

  @override
  String get impiantiFormDialogExternalMaintDateLabel =>
      'Data di Manutenzione esterna';

  @override
  String get impiantiFormDialogExternalMaintDeadlineLabel =>
      'Scadenza Manutenzione esterna';

  @override
  String get impiantiFormDialogExternalCheckTypeLabel =>
      'Tipo di verifica esterna';

  @override
  String get impiantiFormDialogLightningSectionTitle => 'Scariche Atmosferiche';

  @override
  String get impiantiFormDialogLightningAssessmentDeadlineLabel =>
      'Scadenza Valutazione scariche atmosferiche';

  @override
  String get impiantiFormDialogRemoveLightningAssessmentTooltip =>
      'Rimuovi valutazione scariche atmosferiche';

  @override
  String get impiantiFormDialogAddLightningAssessmentLabel =>
      'Aggiungi scadenza valutazione scariche atmosferiche';

  @override
  String get impiantiFormDialogAdditionalNotesLabel => 'Note aggiuntive';

  @override
  String get documentFormDialogDeadlineRequiredError =>
      'Questa tipologia richiede una data di scadenza';

  @override
  String get documentFormDialogTitle => 'Nuova scadenza';

  @override
  String get documentFormDialogSectionTitle => 'Documento';

  @override
  String get documentFormDialogTypeLabel => 'Tipo documento';

  @override
  String get documentFormDialogTypeValidator => 'Seleziona un tipo';

  @override
  String get documentFormDialogDeadlineDateLabel => 'Data di scadenza';

  @override
  String get documentFormDialogDeadlineDateOptionalLabel =>
      'Data di scadenza (facoltativa)';

  @override
  String get documentFormDialogInfoText =>
      'Il documento va conservato in sede: qui si registra solo la scadenza, per ricevere i promemoria via mail.';

  @override
  String get cantiereFormDialogNewTitle => 'Nuovo cantiere';

  @override
  String get cantiereFormDialogEditTitle => 'Modifica cantiere';

  @override
  String get cantiereFormDialogInfoSectionTitle => 'Anagrafica del cantiere';

  @override
  String get cantiereFormDialogNameLabel => 'Nome*';

  @override
  String get cantiereFormDialogAddressLabel => 'Indirizzo*';

  @override
  String get cantiereFormDialogTownLabel => 'Comune';

  @override
  String get cantiereFormDialogPostalCodeLabel => 'CAP';

  @override
  String get cantiereFormDialogStatusSectionTitle => 'Stato del cantiere';

  @override
  String get cantiereFormDialogStatusLabel => 'Stato';

  @override
  String get cantiereFormDialogStatusInProgress => 'In corso';

  @override
  String get cantiereFormDialogStatusCompleted => 'Concluso';

  @override
  String get cantiereFormDialogStatusSuspended => 'Sospeso';

  @override
  String get cantiereFormDialogStartDateLabel => 'Data di Inizio';

  @override
  String get cantiereFormDialogSuspensionDateLabel => 'Data di Sospensione';

  @override
  String get cantiereFormDialogCompletionDateLabel => 'Data di Conclusione';

  @override
  String get scadenzaGeneraleFormDialogNewTitle => 'Nuova scadenza';

  @override
  String get scadenzaGeneraleFormDialogEditTitle => 'Modifica scadenza';

  @override
  String get scadenzaGeneraleFormDialogNameLabel => 'Nome';

  @override
  String get scadenzaGeneraleFormDialogDeadlineLabel => 'Scadenza';

  @override
  String get scadenzaGeneraleFormDialogNoticeDaysLabel => 'Giorni di preavviso';

  @override
  String get scadenzaGeneraleFormDialogAdditionalNotesLabel =>
      'Note aggiuntive';

  @override
  String get sospendiSollecitiDialogTitle => 'Sospendi solleciti';

  @override
  String get sospendiSollecitiDialogDescription1 =>
      'Durante la sospensione le voci già scadute non vengono più risollecitate ogni giorno, né a noi né ai subappaltatori e alle ditte di noleggio.';

  @override
  String get sospendiSollecitiDialogDescription2 =>
      'Le email di preavviso continuano invece ad arrivare normalmente: ciò che entra in scadenza durante la chiusura viene comunque segnalato, una volta sola.';

  @override
  String get sospendiSollecitiDialogUntilLabel => 'Sospendi fino al (compreso)';

  @override
  String get sospendiSollecitiDialogInvalidDateMessage =>
      'La data deve essere odierna o futura.';

  @override
  String sospendiSollecitiDialogSetByMessage(String impostataDa) {
    return 'Sospensione impostata da $impostataDa.';
  }

  @override
  String get sospendiSollecitiDialogReactivateNowLabel => 'Riattiva subito';

  @override
  String get sospendiSollecitiDialogUpdateLabel => 'Aggiorna';

  @override
  String get sospendiSollecitiDialogSuspendLabel => 'Sospendi';

  @override
  String notaImpiantoDialogTitle(String tipologia, String tipo) {
    return 'Nota — $tipologia — $tipo';
  }

  @override
  String notaScadenzaFasciaCatenaDialogTitle(String id) {
    return 'Nota — $id';
  }

  @override
  String showArticoliDialogTitle(String tipologia, String numero) {
    return 'Articoli — $tipologia #$numero';
  }

  @override
  String get showArticoliDialogEmptyMessage => 'Nessun prodotto inserito.';

  @override
  String showArticoliDialogQuantityLine(String quantita) {
    return 'Quantità: $quantita';
  }

  @override
  String showArticoliDialogDeadlineLine(String data) {
    return 'Scadenza: $data';
  }

  @override
  String showArticoliDialogNoteLine(String note) {
    return 'Note: $note';
  }

  @override
  String showArticoliDialogDeadlineNoteLine(String nota) {
    return 'Nota: $nota';
  }

  @override
  String get estintoriScreenTitle => 'Estintori';

  @override
  String get estintoriScreenNewButton => 'Nuovo estintore';

  @override
  String get estintoriScreenPrintAction => 'Stampa';

  @override
  String estintoriScreenPrintError(String details) {
    return 'Impossibile generare la stampa: $details';
  }

  @override
  String get estintoriScreenUpcomingDeadlines => 'Scadenze imminenti';

  @override
  String get estintoriScreenHideDeadlines => 'Nascondi scadenze';

  @override
  String get estintoriScreenShowDeadlines => 'Mostra scadenze';

  @override
  String get estintoriScreenSectionTitle => 'Estintori presenti';

  @override
  String get estintoriScreenCollapseAll => 'Chiudi tutti';

  @override
  String get estintoriScreenExpandAll => 'Espandi tutti';

  @override
  String get estintoriScreenSearchHint => 'Cerca per matricola o posizione';

  @override
  String get estintoriScreenEmptyNone => 'Nessun estintore caricato.';

  @override
  String estintoriScreenEmptySearch(String query) {
    return 'Nessun estintore trovato per \"$query\".';
  }

  @override
  String get estintoriScreenLabelMatricola => 'Matricola';

  @override
  String get estintoriScreenLabelUbicazione => 'Ubicazione';

  @override
  String get estintoriScreenLabelNotaScadenza => 'Nota scadenza';

  @override
  String get estintoriScreenEditNoteTooltip => 'Modifica nota';

  @override
  String get estintoriScreenEditTooltip => 'Modifica estintore';

  @override
  String get estintoriScreenDeleteTooltip => 'Elimina estintore';

  @override
  String get estintoriScreenDeleteConfirmTitle => 'Eliminare estintore?';

  @override
  String estintoriScreenDeleteConfirmMessage(String matricola) {
    return 'Eliminare \"$matricola\"? L\'operazione non è reversibile.';
  }

  @override
  String get estintoriScreenHideInfo => 'Nascondi info';

  @override
  String get estintoriScreenShowInfo => 'Mostra info';

  @override
  String get estintoriScreenSectionGeneralData => 'Dati generali';

  @override
  String get estintoriScreenLabelCapacita => 'Capacità';

  @override
  String get estintoriScreenLabelTipo => 'Tipo';

  @override
  String get estintoriScreenLabelDataProduzione => 'Data di Produzione';

  @override
  String get estintoriScreenLabelDataMessaInServizio =>
      'Data messa in servizio';

  @override
  String get estintoriScreenSectionVerificaEsterna => 'Verifica Esterna';

  @override
  String get estintoriScreenLabelDataVerificaEsterna => 'Data verifica esterna';

  @override
  String get estintoriScreenLabelScadenzaVerificaEsterna =>
      'Scadenza verifica esterna';

  @override
  String get estintoriScreenSectionRevisione => 'Revisione';

  @override
  String get estintoriScreenLabelDataUltimaRevisione => 'Data ultima revisione';

  @override
  String get estintoriScreenLabelScadenzaRevisione => 'Scadenza revisione';

  @override
  String get estintoriScreenSectionCollaudo => 'Collaudo';

  @override
  String get estintoriScreenLabelDataCollaudo => 'Data collaudo';

  @override
  String get estintoriScreenLabelScadenzaCollaudo => 'Scadenza collaudo';

  @override
  String get estintoriScreenTipoScadenzaCollaudo => 'Scadenza Collaudo';

  @override
  String get estintoriScreenTipoScadenzaRevisione => 'Scadenza Revisione';

  @override
  String get estintoriScreenTipoScadenzaVerificaEsterna =>
      'Scadenza Verifica Esterna';

  @override
  String get estintoriScreenTipoSostituzione => 'Sostituzione (18 anni)';

  @override
  String get estintoriScreenLocationWarehouse => 'In magazzino';

  @override
  String get estintoriScreenLocationOffice => 'In ufficio';

  @override
  String estintoriScreenLocationSite(String nome) {
    return 'In cantiere $nome';
  }

  @override
  String estintoriScreenLocationVehicle(String veicolo) {
    return 'Su automezzo $veicolo';
  }

  @override
  String get estintoriScreenLocationUnspecified => 'Non specificata';

  @override
  String estintoriScreenPdfCount(int count) {
    return '$count estintori';
  }

  @override
  String estintoriScreenPdfFilter(String filtro) {
    return 'filtro di ricerca: \"$filtro\"';
  }

  @override
  String get estintoriScreenPdfColMatricola => 'Num. Matricola';

  @override
  String get estintoriScreenPdfColDataProduzione => 'Data produzione';

  @override
  String get estintoriScreenPdfColScadVerificaEsterna =>
      'Scad. verifica esterna';

  @override
  String get estintoriScreenPdfColDataRevisione => 'Data revisione';

  @override
  String get estintoriScreenPdfColScadRevisione => 'Scad. revisione';

  @override
  String get estintoriScreenPdfColScadCollaudo => 'Scad. collaudo';

  @override
  String get cassettaPsFormDialogTipoCassetta => 'Cassetta';

  @override
  String get cassettaPsFormDialogTipoPacchettoMedicazione =>
      'Pacchetto di Medicazione';

  @override
  String get cassettaPsFormDialogNotSpecified => 'Non specificata';

  @override
  String get cassettaPsFormDialogAddProduct => 'Aggiungi prodotto';

  @override
  String get cassettaPsFormDialogNoProducts => 'Nessun prodotto inserito.';

  @override
  String cassettaPsFormDialogQuantityLabel(String quantita) {
    return 'Quantità: $quantita';
  }

  @override
  String cassettaPsFormDialogExpiryLabel(String data) {
    return 'Scadenza: $data';
  }

  @override
  String get cassettaPsFormDialogEditProductTooltip => 'Modifica prodotto';

  @override
  String get cassettaPsFormDialogRemoveProductTooltip => 'Rimuovi prodotto';

  @override
  String get cassettaPsFormDialogNewTitle => 'Nuovo elemento';

  @override
  String get cassettaPsFormDialogEditTitle => 'Modifica elemento';

  @override
  String get cassettaPsFormDialogNumberLabel => 'Numero*';

  @override
  String get cassettaPsFormDialogTypeLabel => 'Tipologia';

  @override
  String get cassettaPsFormDialogLocationSection => 'Ubicazione';

  @override
  String get cassettaPsFormDialogLocationTypeLabel => 'Tipo ubicazione';

  @override
  String get cassettaPsFormDialogLocationWarehouse => 'Magazzino';

  @override
  String get cassettaPsFormDialogLocationOffice => 'Ufficio';

  @override
  String get cassettaPsFormDialogLocationSite => 'Cantiere';

  @override
  String get cassettaPsFormDialogLocationVehicle => 'Automezzo';

  @override
  String get cassettaPsFormDialogSiteLabel => 'Cantiere';

  @override
  String get cassettaPsFormDialogSelectSiteValidator => 'Seleziona un cantiere';

  @override
  String get cassettaPsFormDialogVehicleLabel => 'Automezzo';

  @override
  String get cassettaPsFormDialogSelectVehicleValidator =>
      'Seleziona un automezzo';

  @override
  String get cassettaPsFormDialogLocationDetailsLabel =>
      'Dettagli aggiuntivi ubicazione';

  @override
  String get cassettaPsFormDialogChecksSection => 'Controlli';

  @override
  String get cassettaPsFormDialogLastCheckLabel => 'Ultima Verifica';

  @override
  String get cassettaPsFormDialogNextCheckLabel => 'Prossimo Controllo';

  @override
  String get cassettaPsFormDialogProductsSection => 'Prodotti';

  @override
  String get cassettaPsFormDialogNextProductExpiryTitle =>
      'Prossima Scadenza Prodotti';

  @override
  String get cassettaPsFormDialogNoProductExpiry => 'Nessuna scadenza prodotti';

  @override
  String get cassettaPsFormDialogNewProductTitle => 'Nuovo prodotto';

  @override
  String get cassettaPsFormDialogEditProductTitle => 'Modifica prodotto';

  @override
  String get cassettaPsFormDialogProductNameLabel => 'Nome prodotto*';

  @override
  String get cassettaPsFormDialogQuantityFieldLabel => 'Quantità';

  @override
  String get cassettaPsFormDialogExpiryFieldLabel => 'Scadenza';

  @override
  String get misureScreenTitle => 'Misure';

  @override
  String get misureScreenNewButton => 'Nuova misura';

  @override
  String get misureScreenSearchHint => 'Cerca per nome';

  @override
  String get misureScreenEmptyNone => 'Nessuno strumento di misura caricato.';

  @override
  String misureScreenEmptySearch(String query) {
    return 'Nessuno strumento di misura trovato per \"$query\".';
  }

  @override
  String get misureScreenUpcomingDeadlines => 'Scadenze imminenti';

  @override
  String get misureScreenHideDeadlines => 'Nascondi scadenze';

  @override
  String get misureScreenShowDeadlines => 'Mostra scadenze';

  @override
  String get misureScreenSectionTitle => 'Strumenti di Misura';

  @override
  String get misureScreenCollapseAll => 'Chiudi tutti';

  @override
  String get misureScreenExpandAll => 'Espandi tutti';

  @override
  String get misureScreenLabelModello => 'Modello';

  @override
  String get misureScreenLabelIncaricato => 'Incaricato';

  @override
  String get misureScreenLabelNotaScadenza => 'Nota scadenza';

  @override
  String get misureScreenEditNoteTooltip => 'Modifica nota';

  @override
  String get misureScreenLabelMatricola => 'Matricola';

  @override
  String get misureScreenEditTooltip => 'Modifica misura';

  @override
  String get misureScreenDeleteTooltip => 'Elimina misura';

  @override
  String get misureScreenDeleteConfirmTitle => 'Eliminare strumento di misura?';

  @override
  String misureScreenDeleteConfirmMessage(String nome) {
    return 'Eliminare \"$nome\"? L\'operazione non è reversibile.';
  }

  @override
  String get misureScreenHideInfo => 'Nascondi info';

  @override
  String get misureScreenShowInfo => 'Mostra info';

  @override
  String get misureScreenSectionGeneralData => 'Dati generali';

  @override
  String get misureScreenLabelRifAcq => 'Rif. Acq.';

  @override
  String get misureScreenSectionTaraturaInterna => 'Taratura Interna';

  @override
  String get misureScreenLabelDataUltimaTaratura => 'Data ultima taratura';

  @override
  String get misureScreenLabelDataProssimaTaratura => 'Data prossima taratura';

  @override
  String get misureScreenSectionTaraturaEsterna => 'Taratura Esterna';

  @override
  String get misureScreenTipoProssimaTaraturaInterna =>
      'Prossima taratura interna';

  @override
  String get misureScreenTipoProssimaTaraturaEsterna =>
      'Prossima taratura esterna';

  @override
  String get subappaltatoreDetailScreenBreadcrumbCantieri => 'Cantieri';

  @override
  String get subappaltatoreDetailScreenInfoSection => 'Informazioni:';

  @override
  String get subappaltatoreDetailScreenVatLabel => 'P. IVA';

  @override
  String get subappaltatoreDetailScreenGeneralDeadlinesTitle =>
      'Scadenze generali del subappaltatore';

  @override
  String get subappaltatoreDetailScreenSiteDeadlinesTitle =>
      'Scadenze subappaltatore nel cantiere';

  @override
  String get subappaltatoreDetailScreenAddDeadline => 'Aggiungi scadenza';

  @override
  String get subappaltatoreDetailScreenNoDeadlinesSubappaltatore =>
      'Nessuna scadenza registrata per questo subappaltatore.';

  @override
  String get subappaltatoreDetailScreenEmployeeDeadlinesTitle =>
      'Scadenze dipendenti presenti';

  @override
  String get subappaltatoreDetailScreenCollapseAll => 'Chiudi tutti';

  @override
  String get subappaltatoreDetailScreenExpandAll => 'Mostra tutti';

  @override
  String get subappaltatoreDetailScreenNoDeadlinesEmployees =>
      'Nessuna scadenza registrata per i dipendenti presenti in questo cantiere.';

  @override
  String get subappaltatoreDetailScreenDeadlineCountLabel =>
      'Numero scadenze caricate';

  @override
  String get subappaltatoreDetailScreenExpiredLabel => 'Scaduti';

  @override
  String get subappaltatoreDetailScreenUpcomingLabel => 'In scadenza';

  @override
  String get subappaltatoreDetailScreenAutonomousWorkerLabel =>
      'Lavoratore autonomo';

  @override
  String get subappaltatoreDetailScreenHideDeadlines => 'Nascondi scadenze';

  @override
  String get subappaltatoreDetailScreenShowDeadlines => 'Mostra scadenze';

  @override
  String get subappaltatoreDetailScreenOpenEmployeePage =>
      'Apri pagina dipendente';

  @override
  String get misureFormDialogNewTitle => 'Nuova misura';

  @override
  String get misureFormDialogEditTitle => 'Modifica misura';

  @override
  String get misureFormDialogNameLabel => 'Nome*';

  @override
  String get misureFormDialogReferenceLabel => 'Riferimento';

  @override
  String get misureFormDialogSerialLabel => 'Matricola';

  @override
  String get misureFormDialogInternalCalibrationSection => 'Taratura Interna';

  @override
  String get misureFormDialogAssignedToLabel => 'Incaricato';

  @override
  String get misureFormDialogNotSpecified => 'Non specificato';

  @override
  String get misureFormDialogLastCalibrationLabel => 'Data ultima taratura';

  @override
  String get misureFormDialogNextCalibrationLabel => 'Data prossima taratura';

  @override
  String get misureFormDialogExternalCalibrationSection => 'Taratura Esterna';

  @override
  String get misureFormDialogExternalAssignedToLabel =>
      'Incaricato taratura esterna';

  @override
  String get misureFormDialogAdditionalNotesLabel => 'Note aggiuntive';

  @override
  String get articoliStandardCassettePsScreenTipoCassetta => 'Cassetta';

  @override
  String get articoliStandardCassettePsScreenTipoPacchettoMedicazione =>
      'Pacchetto di Medicazione';

  @override
  String get articoliStandardCassettePsScreenBreadcrumbFirstAid =>
      'Primo Soccorso';

  @override
  String get articoliStandardCassettePsScreenBreadcrumbStandardProducts =>
      'Prodotti standard';

  @override
  String get articoliStandardCassettePsScreenDescription =>
      'Questi prodotti vengono inseriti automaticamente quando si sceglie la tipologia in una nuova cassetta o pacchetto di medicazione.\nQuantità e scadenza restano modificabili per ogni singolo elemento.';

  @override
  String get articoliStandardCassettePsScreenAddProduct => 'Aggiungi prodotto';

  @override
  String get articoliStandardCassettePsScreenEmpty =>
      'Nessun prodotto standard inserito.';

  @override
  String get articoliStandardCassettePsScreenContentSection => 'Contenuto';

  @override
  String get articoliStandardCassettePsScreenEditTooltip => 'Modifica prodotto';

  @override
  String get articoliStandardCassettePsScreenDeleteTooltip =>
      'Elimina prodotto';

  @override
  String get articoliStandardCassettePsScreenDeleteConfirmTitle =>
      'Eliminare prodotto?';

  @override
  String articoliStandardCassettePsScreenDeleteConfirmMessage(String nome) {
    return 'Eliminare \"$nome\" dai prodotti standard? L\'operazione non è reversibile.';
  }

  @override
  String get articoloStandardCassettaPsFormDialogTipoCassetta => 'Cassetta';

  @override
  String get articoloStandardCassettaPsFormDialogTipoPacchettoMedicazione =>
      'Pacchetto di Medicazione';

  @override
  String get articoloStandardCassettaPsFormDialogNewTitle =>
      'Nuovo prodotto standard';

  @override
  String get articoloStandardCassettaPsFormDialogEditTitle =>
      'Modifica prodotto standard';

  @override
  String get articoloStandardCassettaPsFormDialogTypeLabel => 'Tipologia*';

  @override
  String get articoloStandardCassettaPsFormDialogProductNameLabel =>
      'Nome prodotto*';

  @override
  String get articoloStandardCassettaPsFormDialogQuantityLabel => 'Quantità';

  @override
  String get documentoTileDeleteConfirmTitle => 'Eliminare la scadenza?';

  @override
  String documentoTileDeleteConfirmMessage(String documento) {
    return 'Eliminare $documento? L\'operazione non è reversibile.';
  }

  @override
  String get documentoTileDefaultDocumentName => 'questo documento';

  @override
  String get documentoTileSharedSuffix => ' (condiviso)';

  @override
  String get documentoTileLabelScadenza => 'Scadenza';

  @override
  String get documentoTileNotRequired => 'non richiesta';

  @override
  String get documentoTileLabelNota => 'Nota';

  @override
  String get documentoTileEditDeadline => 'Modifica scadenza';

  @override
  String get documentoTileDeleteDeadline => 'Elimina scadenza';

  @override
  String notaMacchinarioDialogTitle(String modello, String tipo) {
    return 'Nota — $modello — $tipo';
  }

  @override
  String notaDpiAssegnatoDialogTitle(String titolo) {
    return 'Nota — $titolo';
  }

  @override
  String notaScadenzaBennaDialogTitle(String idInterno) {
    return 'Nota — Benna $idInterno';
  }

  @override
  String get macchinariScreenTitle => 'Macchinari';

  @override
  String macchinariScreenLocationCantiere(String cantiere) {
    return 'In cantiere $cantiere';
  }

  @override
  String macchinariScreenLocationAutomezzo(String veicolo) {
    return 'In $veicolo';
  }

  @override
  String get macchinariScreenLocationMagazzino => 'In magazzino';

  @override
  String get macchinariScreenLocationUnspecified => 'Non specificata';

  @override
  String get macchinariScreenFieldModello => 'Modello';

  @override
  String get macchinariScreenFieldTipologia => 'Tipologia';

  @override
  String get macchinariScreenFieldMatricola => 'Nr. Matricola';

  @override
  String get macchinariScreenFieldFabbrica => 'Nr. Fabbrica';

  @override
  String get macchinariScreenFieldAnno => 'Anno';

  @override
  String get macchinariScreenFieldAnnoAcquisto => 'Anno di acquisto';

  @override
  String get macchinariScreenFieldProprieta => 'Proprietà';

  @override
  String get macchinariScreenFieldUbicazione => 'Ubicazione';

  @override
  String get macchinariScreenFieldCivaInail => 'CIVA/INAIL';

  @override
  String get macchinariScreenFieldPresenteCivaInail => 'Presente in CIVA/INAIL';

  @override
  String get macchinariScreenFieldScadAssicurazione => 'Scad. assicurazione';

  @override
  String get macchinariScreenFieldScadManutenzione => 'Scad. manutenzione';

  @override
  String get macchinariScreenFieldScadFuniCatene => 'Scad. funi/catene';

  @override
  String get macchinariScreenFieldVerificaAnnuale => 'Verifica annuale';

  @override
  String get macchinariScreenFieldVerificaVentennale => 'Verifica ventennale';

  @override
  String get macchinariScreenFieldNotaScadenza => 'Nota scadenza';

  @override
  String get macchinariScreenFieldLeasingCompany => 'Compagnia di Leasing';

  @override
  String get macchinariScreenFieldLeasingExpiry => 'Scadenza Leasing';

  @override
  String get macchinariScreenFieldRentalCompany => 'Azienda di Noleggio';

  @override
  String get macchinariScreenFieldEmail => 'Email';

  @override
  String get macchinariScreenFieldInsuranceCompany => 'Compagnia assicurativa';

  @override
  String get macchinariScreenFieldInsuranceExpiry => 'Scadenza assicurazione';

  @override
  String get macchinariScreenFieldInterventionDate => 'Data intervento';

  @override
  String get macchinariScreenFieldExpiry => 'Scadenza';

  @override
  String get macchinariScreenFieldLastControlDate => 'Data ultimo controllo';

  @override
  String get macchinariScreenFieldVerificationDate => 'Data verifica';

  @override
  String macchinariScreenPrintSubtitleCount(int count) {
    return '$count macchinari';
  }

  @override
  String macchinariScreenPrintSubtitleFilter(String filter) {
    return 'filtro di ricerca: \"$filter\"';
  }

  @override
  String macchinariScreenPrintError(String details) {
    return 'Impossibile generare la stampa: $details';
  }

  @override
  String get macchinariScreenNewButton => 'Nuovo macchinario';

  @override
  String get macchinariScreenPrintButton => 'Stampa';

  @override
  String get macchinariScreenUpcomingDeadlines => 'Scadenze imminenti';

  @override
  String get macchinariScreenHideDeadlinesTooltip => 'Nascondi scadenze';

  @override
  String get macchinariScreenShowDeadlinesTooltip => 'Mostra scadenze';

  @override
  String get macchinariScreenCollapseAllTooltip => 'Chiudi tutti';

  @override
  String get macchinariScreenExpandAllTooltip => 'Espandi tutti';

  @override
  String get macchinariScreenSearchHint => 'Cerca per nome';

  @override
  String get macchinariScreenEmptyLoaded => 'Nessun macchinario caricato.';

  @override
  String macchinariScreenEmptySearch(String query) {
    return 'Nessun macchinario trovato per \"$query\".';
  }

  @override
  String get macchinariScreenEditNoteTooltip => 'Modifica nota';

  @override
  String get macchinariScreenEditTooltip => 'Modifica macchinario';

  @override
  String get macchinariScreenDeleteTooltip => 'Elimina macchinario';

  @override
  String get macchinariScreenDeleteConfirmTitle => 'Eliminare macchinario?';

  @override
  String macchinariScreenDeleteConfirmMessage(String modello) {
    return 'Eliminare \"$modello\"? L\'operazione non è reversibile.';
  }

  @override
  String get macchinariScreenHideInfoTooltip => 'Nascondi info';

  @override
  String get macchinariScreenShowInfoTooltip => 'Mostra info';

  @override
  String get macchinariScreenSectionGeneralData => 'Dati generali';

  @override
  String get macchinariScreenSectionInsurance => 'Assicurazione';

  @override
  String get macchinariScreenSectionInternalMaintenance =>
      'Manutenzione Interna';

  @override
  String get macchinariScreenSectionRopesChainsControl =>
      'Controllo funi/catene';

  @override
  String get automezziScreenTitle => 'Automezzi';

  @override
  String get automezziScreenFieldNome => 'Nome';

  @override
  String get automezziScreenFieldTarga => 'Targa';

  @override
  String get automezziScreenFieldCategoria => 'Categoria';

  @override
  String get automezziScreenFieldTelepass => 'Nr. Telepass';

  @override
  String get automezziScreenFieldProprieta => 'Proprietà';

  @override
  String get automezziScreenFieldCompAssicurazione => 'Comp. assicurazione';

  @override
  String get automezziScreenFieldScadAssicurazione => 'Scad. assicurazione';

  @override
  String get automezziScreenFieldScadBollo => 'Scad. bollo';

  @override
  String get automezziScreenFieldScadRevisione => 'Scad. revisione';

  @override
  String get automezziScreenFieldScadTachigrafo => 'Scad. controllo tachigrafo';

  @override
  String get automezziScreenFieldVeicolo => 'Veicolo';

  @override
  String get automezziScreenFieldNotaScadenza => 'Nota scadenza';

  @override
  String get automezziScreenFieldCategoriaEuro => 'Categoria EURO';

  @override
  String automezziScreenFieldScadenzaProprieta(String proprieta) {
    return 'Scadenza $proprieta';
  }

  @override
  String automezziScreenPrintSubtitleCount(int count) {
    return '$count automezzi';
  }

  @override
  String automezziScreenPrintSubtitleFilter(String filter) {
    return 'filtro di ricerca: \"$filter\"';
  }

  @override
  String automezziScreenPrintError(String details) {
    return 'Impossibile generare la stampa: $details';
  }

  @override
  String get automezziScreenNewButton => 'Nuovo automezzo';

  @override
  String get automezziScreenPrintButton => 'Stampa';

  @override
  String get automezziScreenUpcomingDeadlines => 'Scadenze imminenti';

  @override
  String get automezziScreenHideDeadlinesTooltip => 'Nascondi scadenze';

  @override
  String get automezziScreenShowDeadlinesTooltip => 'Mostra scadenze';

  @override
  String get automezziScreenCollapseAllTooltip => 'Chiudi tutti';

  @override
  String get automezziScreenExpandAllTooltip => 'Espandi tutti';

  @override
  String get automezziScreenSearchHint => 'Cerca per nome o targa';

  @override
  String get automezziScreenEmptyLoaded => 'Nessun automezzo caricato.';

  @override
  String automezziScreenEmptySearch(String query) {
    return 'Nessun automezzo trovato per \"$query\".';
  }

  @override
  String get automezziScreenEditNoteTooltip => 'Modifica nota';

  @override
  String get automezziScreenEditTooltip => 'Modifica automezzo';

  @override
  String get automezziScreenDeleteTooltip => 'Elimina automezzo';

  @override
  String get automezziScreenDeleteConfirmTitle => 'Eliminare automezzo?';

  @override
  String automezziScreenDeleteConfirmMessage(String nome) {
    return 'Eliminare \"$nome\"? L\'operazione non è reversibile.';
  }

  @override
  String get automezziScreenHideInfoTooltip => 'Nascondi info';

  @override
  String get automezziScreenShowInfoTooltip => 'Mostra info';

  @override
  String get automezziScreenSectionGeneralData => 'Dati generali';

  @override
  String get automezziScreenSectionScadenze => 'Scadenze';

  @override
  String get dipendenteAziendaleFormDialogNewTitle =>
      'Nuovo dipendente aziendale';

  @override
  String get dipendenteAziendaleFormDialogEditTitle =>
      'Modifica dipendente aziendale';

  @override
  String get dipendenteAziendaleFormDialogNomeLabel => 'Nome*';

  @override
  String get dipendenteAziendaleFormDialogCognomeLabel => 'Cognome*';

  @override
  String get dipendenteAziendaleFormDialogMansioneLabel => 'Mansione';

  @override
  String get dipendenteAziendaleFormDialogMansioneNonSpecificata =>
      'Non specificata';

  @override
  String get dipendenteAziendaleFormDialogScadenzaRlst => 'Scadenza RLST';

  @override
  String get dipendenteAziendaleFormDialogScadenzaRspp => 'Scadenza RSPP';

  @override
  String get dipendenteAziendaleFormDialogCodiceFiscaleLabel =>
      'Codice Fiscale';

  @override
  String get dipendenteAziendaleFormDialogDataNascita => 'Data di Nascita';

  @override
  String get dipendenteAziendaleFormDialogLuogoNascita => 'Luogo di Nascita';

  @override
  String get dipendenteAziendaleFormDialogEtaLabel => 'Età';

  @override
  String get dipendenteAziendaleFormDialogEtaHelper =>
      'Calcolata dalla data di nascita';

  @override
  String get dipendenteAziendaleFormDialogSectionContratto => 'Contratto';

  @override
  String get dipendenteAziendaleFormDialogDataAssunzione =>
      'Data di Assunzione';

  @override
  String get dipendenteAziendaleFormDialogScadenzaContratto =>
      'Scadenza Contratto';

  @override
  String get dipendenteAziendaleFormDialogRemoveScadenzaContrattoTooltip =>
      'Rimuovi scadenza contratto';

  @override
  String get dipendenteAziendaleFormDialogAddScadenzaContratto =>
      'Aggiungi scadenza del contratto';

  @override
  String get dipendenteAziendaleFormDialogSectionPersonali => 'Personali';

  @override
  String get dipendenteAziendaleFormDialogScadenzaVisitaMedica =>
      'Scadenza Visita Medica';

  @override
  String get dipendenteAziendaleFormDialogScadenzaPatente => 'Scadenza Patente';

  @override
  String get dipendenteAziendaleFormDialogScadenzaCartaTachigraficaAzienda =>
      'Scadenza Carta Tachigrafica + Azienda';

  @override
  String get dipendenteAziendaleFormDialogScadenzaCartaTachigrafica =>
      'Scadenza Carta Tachigrafica';

  @override
  String get dipendenteAziendaleFormDialogScadenzaCartaIdentita =>
      'Scadenza Carta d\'identità';

  @override
  String get dipendenteAziendaleFormDialogScadenzaFirmaDigitale =>
      'Scadenza Firma Digitale';

  @override
  String get dipendenteAziendaleFormDialogScadenzaCodiceFiscale =>
      'Scadenza Codice Fiscale';

  @override
  String get dipendenteAziendaleFormDialogScadenzaPermessoSoggiorno =>
      'Scadenza Permesso di Soggiorno';

  @override
  String get dipendenteAziendaleFormDialogRemovePermessoSoggiornoTooltip =>
      'Rimuovi permesso di soggiorno';

  @override
  String get dipendenteAziendaleFormDialogAddPermessoSoggiorno =>
      'Aggiungi permesso di soggiorno';

  @override
  String get dipendenteAziendaleFormDialogScadenzaAntitetanica =>
      'Scadenza Antitetanica';

  @override
  String get dipendenteAziendaleFormDialogRemoveAntitetanicaTooltip =>
      'Rimuovi antitetanica';

  @override
  String get dipendenteAziendaleFormDialogAddAntitetanica =>
      'Aggiungi antitetanica';

  @override
  String get dipendenteAziendaleFormDialogSectionCorsi => 'Corsi';

  @override
  String get dipendenteAziendaleFormDialogScadenzaFormazioneGenerale =>
      'Scadenza corso di formazione generale';

  @override
  String get dipendenteAziendaleFormDialogNoteAggiuntive => 'Note aggiuntive';

  @override
  String get dipendenteAziendaleFormDialogRemoveCorsoTooltip => 'Rimuovi corso';

  @override
  String get dipendenteAziendaleFormDialogAddCorso => 'Aggiungi corso';

  @override
  String get dipendenteAziendaleFormDialogAllCoursesAdded =>
      'Hai già aggiunto tutti i corsi disponibili.';

  @override
  String get dipendenteAziendaleFormDialogSelectCoursesTitle =>
      'Seleziona i corsi da aggiungere';

  @override
  String dipendenteAziendaleFormDialogAddCoursesCount(int count) {
    return 'Aggiungi ($count)';
  }

  @override
  String get dipendenteAziendaleFormDialogCorsoPrimoSoccorsoNome =>
      'Corso di Primo Soccorso';

  @override
  String get dipendenteAziendaleFormDialogCorsoPrimoSoccorsoEtichetta =>
      'Scadenza Corso Primo Soccorso';

  @override
  String get dipendenteAziendaleFormDialogCorsoAntincendioNome =>
      'Corso Antincendio';

  @override
  String get dipendenteAziendaleFormDialogCorsoAntincendioEtichetta =>
      'Scadenza Corso Antincendio';

  @override
  String get dipendenteAziendaleFormDialogCorsoPrepostoNome => 'Corso Preposto';

  @override
  String get dipendenteAziendaleFormDialogCorsoPrepostoEtichetta =>
      'Scadenza Preposto';

  @override
  String get dipendenteAziendaleFormDialogCorsoPonteggiNome =>
      'Montaggio/Smontaggio ponteggi';

  @override
  String get dipendenteAziendaleFormDialogCorsoPonteggiEtichetta =>
      'Scadenza Ponteggi';

  @override
  String get dipendenteAziendaleFormDialogCorsoLavoriQuotaNome =>
      'Lavori in Quota';

  @override
  String get dipendenteAziendaleFormDialogCorsoLavoriQuotaEtichetta =>
      'Scadenza Lavori in Quota';

  @override
  String get dipendenteAziendaleFormDialogCorsoEscavatoriNome =>
      'Conduzione Escavatori';

  @override
  String get dipendenteAziendaleFormDialogCorsoEscavatoriEtichetta =>
      'Scadenza Conduzione Escavatori';

  @override
  String get dipendenteAziendaleFormDialogCorsoGruAutocarroNome =>
      'Gru Autocarro';

  @override
  String get dipendenteAziendaleFormDialogCorsoGruAutocarroEtichetta =>
      'Scadenza Gru Autocarro';

  @override
  String get dipendenteAziendaleFormDialogCorsoGruTorreNome => 'Gru a Torre';

  @override
  String get dipendenteAziendaleFormDialogCorsoGruTorreEtichetta =>
      'Scadenza Gru a Torre';

  @override
  String get dipendenteAziendaleFormDialogCorsoPiattaformeNome =>
      'Piattaforme Elevatrici';

  @override
  String get dipendenteAziendaleFormDialogCorsoPiattaformeEtichetta =>
      'Scadenza Piattaforme Elevatrici';

  @override
  String get dipendenteAziendaleFormDialogCorsoCarrelloElevatoreNome =>
      'Carrello Elevatore Semovente';

  @override
  String get dipendenteAziendaleFormDialogCorsoCarrelloElevatoreEtichetta =>
      'Scadenza Carrello Elevatore';

  @override
  String get dipendenteAziendaleFormDialogCorsoDisocianatiNome =>
      'Corso Diisocianati';

  @override
  String get dipendenteAziendaleFormDialogCorsoDisocianatiEtichetta =>
      'Scadenza Corso Diisocianati';

  @override
  String get dipendenteAziendaleFormDialogCorsoScaffalatureNome =>
      'Corso Scaffalature';

  @override
  String get dipendenteAziendaleFormDialogCorsoScaffalatureEtichetta =>
      'Scadenza Scaffalature';

  @override
  String get dipendenteAziendaleFormDialogCorsoFormazione231Nome =>
      'Corso di formazione Modello 231';

  @override
  String get dipendenteAziendaleFormDialogCorsoFormazione231Etichetta =>
      'Data Corso di formazione Modello 231';

  @override
  String get dipendenteAziendaleFormDialogCorsoAmbientaleNome =>
      'Corso di formazione di Sistema Gestione Ambientale';

  @override
  String get dipendenteAziendaleFormDialogCorsoAmbientaleEtichetta =>
      'Data Formazione Ambientale';

  @override
  String get dipendenteAziendaleFormDialogCorsoRentriNome =>
      'Corso di formazione Rentri';

  @override
  String get dipendenteAziendaleFormDialogCorsoRentriEtichetta =>
      'Data Corso di formazione Rentri';

  @override
  String get dipendenteAziendaleFormDialogCorsoCronotachigraficoNome =>
      'Corso Cronotachigrafico';

  @override
  String get dipendenteAziendaleFormDialogCorsoCronotachigraficoEtichetta =>
      'Scadenza Cronotachigrafico';

  @override
  String get estintoreFormDialogNewTitle => 'Nuovo estintore';

  @override
  String get estintoreFormDialogEditTitle => 'Modifica estintore';

  @override
  String get estintoreFormDialogMatricolaLabel => 'Numero di Matricola*';

  @override
  String get estintoreFormDialogTipoAgenteLabel => 'Tipo di agente';

  @override
  String get estintoreFormDialogTipoAgenteNonSpecificato => 'Non specificato';

  @override
  String get estintoreFormDialogCapacitaLabel => 'Capacità';

  @override
  String get estintoreFormDialogDataProduzione => 'Data di Produzione';

  @override
  String get estintoreFormDialogDataMessaInServizio =>
      'Data di messa in servizio';

  @override
  String get estintoreFormDialogSectionUbicazione => 'Ubicazione';

  @override
  String get estintoreFormDialogTipoUbicazioneLabel => 'Tipo ubicazione';

  @override
  String get estintoreFormDialogUbicazioneNonSpecificata => 'Non specificata';

  @override
  String get estintoreFormDialogUbicazioneMagazzino => 'Magazzino';

  @override
  String get estintoreFormDialogUbicazioneUfficio => 'Ufficio';

  @override
  String get estintoreFormDialogUbicazioneCantiere => 'Cantiere';

  @override
  String get estintoreFormDialogUbicazioneAutomezzo => 'Automezzo';

  @override
  String get estintoreFormDialogSelectCantiereValidator =>
      'Seleziona un cantiere';

  @override
  String get estintoreFormDialogSelectAutomezzoValidator =>
      'Seleziona un automezzo';

  @override
  String get estintoreFormDialogDettagliUbicazione =>
      'Dettagli aggiuntivi ubicazione';

  @override
  String get estintoreFormDialogSectionVerificaEsterna => 'Verifica esterna';

  @override
  String get estintoreFormDialogDataVerificaEsterna => 'Data verifica esterna';

  @override
  String get estintoreFormDialogScadenzaVerificaEsterna =>
      'Scadenza verifica esterna';

  @override
  String get estintoreFormDialogSectionRevisione => 'Revisione';

  @override
  String get estintoreFormDialogUltimaRevisione => 'Ultima revisione';

  @override
  String get estintoreFormDialogScadenzaRevisione => 'Scadenza revisione';

  @override
  String get estintoreFormDialogSectionCollaudo => 'Collaudo';

  @override
  String get estintoreFormDialogUltimoCollaudo => 'Ultimo collaudo';

  @override
  String get estintoreFormDialogScadenzaCollaudo => 'Scadenza collaudo';

  @override
  String get estintoreFormDialogNoteAggiuntive => 'Note aggiuntive';

  @override
  String get rifiutoFormDialogNewTitle => 'Nuova ditta rifiuti';

  @override
  String get rifiutoFormDialogEditTitle => 'Modifica ditta rifiuti';

  @override
  String get rifiutoFormDialogNomeDittaLabel => 'Nome ditta*';

  @override
  String get rifiutoFormDialogSectionTrasportatore => 'Trasportatore';

  @override
  String get rifiutoFormDialogIsTrasportatore => 'Trasportatore?';

  @override
  String get rifiutoFormDialogNrAutorizzazioneTrasportatore =>
      'Numero di Autorizzazione Trasportatore';

  @override
  String get rifiutoFormDialogScadNonPericolosiTrasportatore =>
      'Scadenza rifiuti non pericolosi trasportatore';

  @override
  String get rifiutoFormDialogAutorizzazionePericolosi =>
      'Autorizzazione a rifiuti pericolosi?';

  @override
  String get rifiutoFormDialogScadPericolosiTrasportatore =>
      'Scadenza rifiuti pericolosi trasportatore';

  @override
  String get rifiutoFormDialogNoteTrasportatore => 'Note trasportatore';

  @override
  String get rifiutoFormDialogSectionSmaltitore => 'Smaltitore';

  @override
  String get rifiutoFormDialogIsSmaltitore => 'Smaltitore?';

  @override
  String get rifiutoFormDialogNrAutorizzazioneSmaltitore =>
      'Numero di Autorizzazione Smaltitore';

  @override
  String get rifiutoFormDialogScadNonPericolosiSmaltitore =>
      'Scadenza rifiuti non pericolosi smaltitore';

  @override
  String get rifiutoFormDialogScadPericolosiSmaltitore =>
      'Scadenza rifiuti pericolosi smaltitore';

  @override
  String get rifiutoFormDialogNoteSmaltitore => 'Note smaltitore';

  @override
  String get automezzoFormDialogNewTitle => 'Nuovo automezzo';

  @override
  String get automezzoFormDialogEditTitle => 'Modifica automezzo';

  @override
  String get automezzoFormDialogNomeLabel => 'Nome';

  @override
  String get automezzoFormDialogTargaLabel => 'Targa*';

  @override
  String get automezzoFormDialogCategoriaLabel => 'Categoria';

  @override
  String get automezzoFormDialogNonSpecificata => 'Non specificata';

  @override
  String get automezzoFormDialogTelepassLabel => 'Numero Telepass';

  @override
  String get automezzoFormDialogProprietaLabel => 'Proprietà';

  @override
  String automezzoFormDialogScadenzaProprieta(String proprieta) {
    return 'Scadenza $proprieta';
  }

  @override
  String get automezzoFormDialogSectionAssicurazione => 'Assicurazione';

  @override
  String get automezzoFormDialogScadenzaAssicurazione =>
      'Scadenza assicurazione';

  @override
  String get automezzoFormDialogNomeAssicurazioneLabel => 'Nome assicurazione';

  @override
  String get automezzoFormDialogSectionBollo => 'Bollo';

  @override
  String get automezzoFormDialogScadenzaBollo => 'Scadenza bollo';

  @override
  String get automezzoFormDialogSectionRevisione => 'Revisione';

  @override
  String get automezzoFormDialogScadenzaRevisione => 'Scadenza revisione';

  @override
  String get automezzoFormDialogSectionTachigrafo => 'Tachigrafo';

  @override
  String get automezzoFormDialogScadenzaControlloTachigrafo =>
      'Scadenza controllo tachigrafo';

  @override
  String get automezzoFormDialogNoteAggiuntive => 'Note aggiuntive';

  @override
  String get scalaFormDialogNewTitle => 'Nuova scala';

  @override
  String get scalaFormDialogEditTitle => 'Modifica scala';

  @override
  String get scalaFormDialogSectionAnagrafica => 'Anagrafica';

  @override
  String get scalaFormDialogCodiceLabel => 'Codice*';

  @override
  String get scalaFormDialogMaterialeLabel => 'Materiale';

  @override
  String get scalaFormDialogDescrizioneLabel => 'Descrizione';

  @override
  String get scalaFormDialogSectionUbicazione => 'Ubicazione';

  @override
  String get scalaFormDialogTipoUbicazioneLabel => 'Tipo ubicazione';

  @override
  String get scalaFormDialogUbicazioneNonSpecificata => 'Non specificata';

  @override
  String get scalaFormDialogUbicazioneMagazzino => 'Magazzino';

  @override
  String get scalaFormDialogUbicazioneCantiere => 'Cantiere';

  @override
  String get scalaFormDialogSelectCantiereValidator => 'Seleziona un cantiere';

  @override
  String get scalaFormDialogSectionVerifiche => 'Verifiche';

  @override
  String get scalaFormDialogUltimaVerifica => 'Ultima verifica';

  @override
  String get scalaFormDialogProssimaVerifica => 'Prossima verifica';

  @override
  String get scalaFormDialogNoteAggiuntive => 'Note aggiuntive';

  @override
  String modificaScadenzaCantiereDialogTitle(String etichetta) {
    return 'Modifica $etichetta';
  }

  @override
  String get modificaScadenzaCantiereDialogDataScadenza => 'Data di scadenza';

  @override
  String get modificaScadenzaCantiereDialogMissingDate =>
      'Inserisci una data di scadenza';

  @override
  String get ritiroDpiQuotaDialogConfirmTitle => 'Ritirare il DPI?';

  @override
  String ritiroDpiQuotaDialogConfirmMessage(String tipo, String dipendente) {
    return 'Ritirare \"$tipo\" a $dipendente? Viene azzerata solo la data di consegna: il resto della scheda resta invariato e alla riconsegna basterà reinserire la data.';
  }

  @override
  String get ritiroDpiQuotaDialogConfirmButton => 'Ritira';

  @override
  String ritiroDpiQuotaDialogRiconsegnaTitle(String tipo) {
    return 'Riconsegna — $tipo';
  }

  @override
  String ritiroDpiQuotaDialogRiconsegnaMessage(String dipendente) {
    return 'Il DPI torna a $dipendente: indica la data in cui gli viene riconsegnato.';
  }

  @override
  String get ritiroDpiQuotaDialogDataConsegnaLabel => 'Data consegna*';

  @override
  String get ritiroDpiQuotaDialogRiconsegnaButton => 'Riconsegna';

  @override
  String get statoBadgeValido => 'Valido';

  @override
  String get statoBadgeInScadenza => 'In scadenza';

  @override
  String get statoBadgeScaduto => 'Scaduto';

  @override
  String get segnaleticaSicurezzaScreenZonaUfficio => 'Ufficio';

  @override
  String get segnaleticaSicurezzaScreenZonaMagazzino => 'Magazzino';

  @override
  String get segnaleticaSicurezzaScreenZonaNonSpecificata =>
      'Zona non specificata';

  @override
  String get segnaleticaSicurezzaScreenEsitoCartelloAssente =>
      'Cartello assente';

  @override
  String get segnaleticaSicurezzaScreenEsitoPresente => 'Presente';

  @override
  String get segnaleticaSicurezzaScreenEsitoPosizioneIdonea =>
      'Posizione idonea';

  @override
  String get segnaleticaSicurezzaScreenEsitoPosizioneNonIdonea =>
      'Posizione non idonea';

  @override
  String get segnaleticaSicurezzaScreenEsitoBuonoStato => 'Buono stato';

  @override
  String get segnaleticaSicurezzaScreenEsitoDaSostituire => 'Da sostituire';

  @override
  String get segnaleticaSicurezzaScreenTitle => 'Segnaletica di Sicurezza';

  @override
  String get segnaleticaSicurezzaScreenTitleShort => 'Segnaletica';

  @override
  String get segnaleticaSicurezzaScreenNuovoControllo => 'Nuovo controllo';

  @override
  String get segnaleticaSicurezzaScreenNuovoSegnale => 'Nuovo segnale';

  @override
  String get segnaleticaSicurezzaScreenInfoEmailScadenza =>
      'Info email di scadenza';

  @override
  String get segnaleticaSicurezzaScreenSegnaleticaPresente =>
      'Segnaletica presente';

  @override
  String get segnaleticaSicurezzaScreenChiudiTutti => 'Chiudi tutti';

  @override
  String get segnaleticaSicurezzaScreenEspandiTutti => 'Espandi tutti';

  @override
  String get segnaleticaSicurezzaScreenControllaTutti => 'Controlla tutti';

  @override
  String get segnaleticaSicurezzaScreenNessunCartelloZona =>
      'Nessun cartello in questa zona.';

  @override
  String get segnaleticaSicurezzaScreenModificaCartello => 'Modifica cartello';

  @override
  String get segnaleticaSicurezzaScreenEliminaCartello => 'Elimina cartello';

  @override
  String get segnaleticaSicurezzaScreenEliminareCartelloTitle =>
      'Eliminare cartello?';

  @override
  String segnaleticaSicurezzaScreenEliminareCartelloMessage(String nome) {
    return 'Eliminare \"$nome\" e i suoi controlli? L\'operazione non è reversibile.';
  }

  @override
  String get segnaleticaSicurezzaScreenNascondiInfo => 'Nascondi info';

  @override
  String get segnaleticaSicurezzaScreenMostraInfo => 'Mostra info';

  @override
  String get segnaleticaSicurezzaScreenCampoUbicazione => 'Ubicazione';

  @override
  String get segnaleticaSicurezzaScreenUltimoControllo => 'Ultimo controllo';

  @override
  String get segnaleticaSicurezzaScreenMaiControllato => 'mai controllato';

  @override
  String get segnaleticaSicurezzaScreenDatiCartello => 'Dati del cartello';

  @override
  String get segnaleticaSicurezzaScreenCampoZona => 'Zona';

  @override
  String get segnaleticaSicurezzaScreenControlliRegistrati =>
      'Controlli registrati';

  @override
  String get segnaleticaSicurezzaScreenControlliHeader => 'Controlli';

  @override
  String get segnaleticaSicurezzaScreenNessunControlloRegistrato =>
      'Nessun controllo registrato.';

  @override
  String get segnaleticaSicurezzaScreenIngrandisciCartello =>
      'Ingrandisci cartello';

  @override
  String get segnaleticaSicurezzaScreenImmagineNonDisponibile =>
      'Immagine non disponibile';

  @override
  String get segnaleticaSicurezzaScreenEsitiLabel => 'Esiti';

  @override
  String get segnaleticaSicurezzaScreenNoteControllo => 'Note controllo';

  @override
  String get segnaleticaSicurezzaScreenModificaControllo =>
      'Modifica controllo';

  @override
  String get segnaleticaSicurezzaScreenEliminaControllo => 'Elimina controllo';

  @override
  String get segnaleticaSicurezzaScreenEliminareControlloTitle =>
      'Eliminare controllo?';

  @override
  String segnaleticaSicurezzaScreenEliminareControlloMessage(
    String data,
    String nome,
  ) {
    return 'Eliminare il controllo del $data su \"$nome\"? L\'operazione non è reversibile.';
  }

  @override
  String get dpiScreenTitle => 'DPI';

  @override
  String get dpiScreenAssegnaDpi => 'Assegna DPI';

  @override
  String get dpiScreenTipiDpi => 'Tipi di DPI';

  @override
  String get dpiScreenScadenzeImminenti => 'Scadenze imminenti';

  @override
  String get dpiScreenNascondiScadenze => 'Nascondi scadenze';

  @override
  String get dpiScreenMostraScadenze => 'Mostra scadenze';

  @override
  String get dpiScreenDipendentiConDpiObbligatori =>
      'Dipendenti con DPI obbligatori';

  @override
  String get dpiScreenNascondiTutti => 'Nascondi tutti';

  @override
  String get dpiScreenMostraTutti => 'Mostra tutti';

  @override
  String get dpiScreenCercaPerNome => 'Cerca per nome';

  @override
  String get dpiScreenNessunDipendenteMansione =>
      'Nessun dipendente con mansione Datore, M02, M03 o M04.';

  @override
  String dpiScreenNessunDipendenteTrovato(String query) {
    return 'Nessun dipendente trovato per \"$query\".';
  }

  @override
  String get dpiScreenCampoDipendente => 'Dipendente';

  @override
  String get dpiScreenCampoMatricola => 'Matricola';

  @override
  String get dpiScreenNotaScadenza => 'Nota scadenza';

  @override
  String get dpiScreenModificaNota => 'Modifica nota';

  @override
  String get dpiScreenCampoMansione => 'Mansione';

  @override
  String get dpiScreenCampoAssegnati => 'Assegnati';

  @override
  String get dpiScreenCampoNota => 'Nota';

  @override
  String get dpiScreenAssegnaAltroDpi => 'Assegna un altro DPI';

  @override
  String get dpiScreenNascondiDpi => 'Nascondi DPI';

  @override
  String get dpiScreenMostraDpi => 'Mostra DPI';

  @override
  String get dpiScreenNessunaRegolaDpi =>
      'Nessuna regola DPI impostata per questa mansione.';

  @override
  String get dpiScreenAltriDpiAssegnati => 'Altri DPI assegnati';

  @override
  String get dpiScreenNonAssegnato => 'Non assegnato';

  @override
  String get dpiScreenCampoProduttore => 'Produttore';

  @override
  String get dpiScreenCampoTaglia => 'Taglia';

  @override
  String get dpiScreenCampoScadenza => 'Scadenza';

  @override
  String get dpiScreenNonImpostata => 'non impostata';

  @override
  String get dpiScreenDpiRitirato => 'DPI Ritirato';

  @override
  String get dpiScreenRiconsegnaDpiQuota =>
      'Riconsegna DPI per lavori in quota';

  @override
  String get dpiScreenRitiraDpiQuota => 'Ritira DPI per lavori in quota';

  @override
  String get dpiScreenModificaDpiAssegnato => 'Modifica DPI assegnato';

  @override
  String get dpiScreenEliminaDpiAssegnato => 'Elimina DPI assegnato';

  @override
  String get dpiScreenEliminareDpiAssegnatoTitle =>
      'Eliminare il DPI assegnato?';

  @override
  String dpiScreenEliminareDpiAssegnatoMessage(String tipo, String dipendente) {
    return 'Eliminare \"$tipo\" assegnato a $dipendente? L\'operazione non è reversibile.';
  }

  @override
  String get rifiutiScreenTipoNonPericolosiTrasportatore =>
      'Scadenza Rifiuti Non Pericolosi Trasportatore';

  @override
  String get rifiutiScreenTipoPericolosiTrasportatore =>
      'Scadenza Rifiuti Pericolosi Trasportatore';

  @override
  String get rifiutiScreenTipoNonPericolosiSmaltitore =>
      'Scadenza Rifiuti Non Pericolosi Smaltitore';

  @override
  String get rifiutiScreenTipoPericolosiSmaltitore =>
      'Scadenza Rifiuti Pericolosi Smaltitore';

  @override
  String get rifiutiScreenTitle => 'Rifiuti';

  @override
  String get rifiutiScreenScadenzeImminenti => 'Scadenze imminenti';

  @override
  String get rifiutiScreenNascondiScadenze => 'Nascondi scadenze';

  @override
  String get rifiutiScreenMostraScadenze => 'Mostra scadenze';

  @override
  String get rifiutiScreenAziendePerRaccolta => 'Aziende per raccolta rifiuti';

  @override
  String get rifiutiScreenNascondiTutti => 'Nascondi tutti';

  @override
  String get rifiutiScreenMostraTutti => 'Mostra tutti';

  @override
  String get rifiutiScreenCercaPerNomeDitta => 'Cerca per nome ditta';

  @override
  String get rifiutiScreenNessunElementoCaricato => 'Nessun elemento caricato.';

  @override
  String rifiutiScreenNessunElementoTrovato(String query) {
    return 'Nessun elemento trovato per \"$query\".';
  }

  @override
  String get rifiutiScreenCampoDitta => 'Ditta';

  @override
  String get rifiutiScreenNotaScadenza => 'Nota scadenza';

  @override
  String get rifiutiScreenModificaNota => 'Modifica nota';

  @override
  String get rifiutiScreenCampoTrasportatore => 'Trasportatore';

  @override
  String get rifiutiScreenNoteTrasportatore => 'Note trasportatore';

  @override
  String get rifiutiScreenCampoSmaltitore => 'Smaltitore';

  @override
  String get rifiutiScreenNoteSmaltitore => 'Note smaltitore';

  @override
  String get rifiutiScreenEliminaAzienda => 'Elimina azienda';

  @override
  String get rifiutiScreenEliminareAziendaTitle => 'Eliminare azienda?';

  @override
  String rifiutiScreenEliminareAziendaMessage(String nome) {
    return 'Eliminare \"$nome\"? L\'operazione non è reversibile.';
  }

  @override
  String get rifiutiScreenNascondiInfo => 'Nascondi info';

  @override
  String get rifiutiScreenMostraInfo => 'Mostra info';

  @override
  String get rifiutiScreenNrAutorizzazione => 'Nr. Autorizzazione';

  @override
  String get rifiutiScreenScadNonPericolosi => 'Scad. Rifiuti non pericolosi';

  @override
  String get rifiutiScreenScadPericolosi => 'Scad. Rifiuti pericolosi';

  @override
  String get controlloSegnaleFormDialogEditTitle => 'Modifica controllo';

  @override
  String get controlloSegnaleFormDialogNewTitle => 'Nuovo controllo';

  @override
  String get controlloSegnaleFormDialogCartelloLabel => 'Cartello*';

  @override
  String get controlloSegnaleFormDialogSelezionaCartello =>
      'Seleziona un cartello';

  @override
  String get controlloSegnaleFormDialogDataIspezione => 'Data ispezione';

  @override
  String get controlloSegnaleFormDialogEsitoControllo => 'Esito del controllo';

  @override
  String get controlloSegnaleFormDialogCartelloPresente =>
      'Il cartello è presente';

  @override
  String get controlloSegnaleFormDialogPosizioneIdonea => 'Posizione idonea';

  @override
  String get controlloSegnaleFormDialogInBuonoStato => 'In buono stato';

  @override
  String get controlloSegnaleFormDialogNoteHint =>
      'Es. cartello scolorito, da sostituire';

  @override
  String controlloSegnaleFormDialogControlloZonaTitle(String zona) {
    return 'Controllo di zona - $zona';
  }

  @override
  String controlloSegnaleFormDialogRegistrazioneBlocco(int count, String noun) {
    return 'Viene registrato un controllo con esito positivo (cartello presente, posizione idonea, buono stato) su tutti i $count $noun della zona. Se un cartello non era a posto, correggi il suo controllo dalla card del cartello.';
  }

  @override
  String get controlloSegnaleFormDialogSignSingular => 'cartello';

  @override
  String get controlloSegnaleFormDialogSignPlural => 'cartelli';

  @override
  String get controlloSegnaleFormDialogNoteAppliedLabel =>
      'Note (applicate a tutti)';

  @override
  String get controlloSegnaleFormDialogNoteAppliedHint =>
      'Es. giro di controllo mensile';

  @override
  String get controlloSegnaleFormDialogCartelliInteressati =>
      'Cartelli interessati';

  @override
  String get controlloSegnaleFormDialogRegistraSuTutti => 'Registra su tutti';

  @override
  String get tipoScadenzaFormDialogSelezionaAppartenenza =>
      'Seleziona almeno un\'appartenenza';

  @override
  String get tipoScadenzaFormDialogNewTitle => 'Nuovo tipo scadenza';

  @override
  String get tipoScadenzaFormDialogEditTitle => 'Modifica tipo scadenza';

  @override
  String get tipoScadenzaFormDialogTipologia => 'Tipologia';

  @override
  String get tipoScadenzaFormDialogNomeLabel => 'Nome*';

  @override
  String get tipoScadenzaFormDialogNomeHint => 'es. DURC, POS, Visura';

  @override
  String get tipoScadenzaFormDialogNotaPredefinitaLabel => 'Nota predefinita';

  @override
  String get tipoScadenzaFormDialogNotaPredefinitaHint =>
      'es. scade ogni 6 mesi';

  @override
  String get tipoScadenzaFormDialogNotaPredefinitaHelper =>
      'Viene precompilata nelle note della scadenza quando si sceglie questa tipologia';

  @override
  String get tipoScadenzaFormDialogAppartenenza => 'Appartenenza';

  @override
  String get tipoScadenzaFormDialogCantiere => 'Cantiere';

  @override
  String get tipoScadenzaFormDialogSubappaltatore => 'Subappaltatore';

  @override
  String get tipoScadenzaFormDialogDipendenteSubappaltatore =>
      'Dipendente del subappaltatore';

  @override
  String get tipoScadenzaFormDialogLavoratoreAutonomo => 'Lavoratore autonomo';

  @override
  String get tipoScadenzaFormDialogTipologieDipendentiInfo =>
      'Le tipologie dei dipendenti valgono anche per i lavoratori autonomi.';

  @override
  String get tipoScadenzaFormDialogScadenza => 'Scadenza';

  @override
  String get tipoScadenzaFormDialogRichiedeScadenza => 'Richiede scadenza';

  @override
  String get tipoScadenzaFormDialogAvvisaSoloScadutaTitle =>
      'Avvisa solo a scadenza superata';

  @override
  String get tipoScadenzaFormDialogAvvisaSoloScadutaSubtitle =>
      'Nessun preavviso: la prima email parte il giorno dopo la data di scadenza (es. DURC)';

  @override
  String get tipoScadenzaFormDialogGiorniPreavvisoLabel =>
      'Giorni di preavviso';

  @override
  String get tipoScadenzaFormDialogGiorniPreavvisoHint => 'es. 30, 15, 7, 1';

  @override
  String get subappaltatoreFormDialogNewTitle => 'Nuovo subappaltatore';

  @override
  String get subappaltatoreFormDialogEditTitle => 'Modifica subappaltatore';

  @override
  String get subappaltatoreFormDialogCercaEsistenti =>
      'Cerca tra i subappaltatori esistenti';

  @override
  String get subappaltatoreFormDialogSelezionaEsistenteInfo =>
      'Seleziona un subappaltatore esistente oppure compila i campi qui sotto per crearne uno nuovo.';

  @override
  String get subappaltatoreFormDialogAnagrafica => 'Anagrafica';

  @override
  String get subappaltatoreFormDialogRagioneSocialeLabel => 'Ragione sociale*';

  @override
  String get subappaltatoreFormDialogPartitaIvaLabel => 'Partita IVA*';

  @override
  String get subappaltatoreFormDialogTelefonoLabel => 'Telefono';

  @override
  String get subappaltatoreFormDialogEmailLabel => 'Email';

  @override
  String get subappaltatoreFormDialogEmailInvalida => 'Inserisci email valida';

  @override
  String get subappaltatoreFormDialogNoteHelper =>
      'Mostrate nel riquadro \"Informazioni\" della pagina del subappaltatore';

  @override
  String get subappaltatoreFormDialogCantieriAssociati => 'Cantieri associati';

  @override
  String get archivioCantieriScreenEliminareTuttiTitle =>
      'Vuoi eliminare tutti i cantieri archiviati?';

  @override
  String get archivioCantieriScreenEliminareTuttiMessage =>
      'Azione non ripristinabile, presta attenzione.';

  @override
  String get archivioCantieriScreenTitle => 'Archivio cantieri';

  @override
  String get archivioCantieriScreenEliminaCantieriArchiviatiTooltip =>
      'Elimina cantieri archiviati';

  @override
  String get archivioCantieriScreenEliminaCantieriLabel => 'Elimina cantieri';

  @override
  String get archivioCantieriScreenNessunCantiereArchiviato =>
      'Nessun cantiere archiviato.';

  @override
  String get archivioCantieriScreenCantieriConclusi => 'Cantieri conclusi';

  @override
  String get archivioCantieriScreenCercaHint =>
      'Cerca per nome, indirizzo o comune';

  @override
  String get archivioCantieriScreenNessunCantiereConcluso =>
      'Nessun cantiere concluso (tutti attivi).';

  @override
  String archivioCantieriScreenNessunCantiereTrovato(String query) {
    return 'Nessun cantiere concluso trovato per \"$query\".';
  }

  @override
  String get archivioCantieriScreenEliminareCantiereTitle =>
      'Eliminare cantiere?';

  @override
  String archivioCantieriScreenEliminareCantiereMessage(String nome) {
    return 'Eliminare definitivamente il cantiere \"$nome\"? L\'operazione non è reversibile.';
  }

  @override
  String get scaffalaturaFormDialogNewTitle => 'Nuova scaffalatura';

  @override
  String get scaffalaturaFormDialogEditTitle => 'Modifica scaffalatura';

  @override
  String get scaffalaturaFormDialogIdInternoLabel => 'ID interno*';

  @override
  String get scaffalaturaFormDialogInserireNumero => 'Inserire un numero';

  @override
  String get scaffalaturaFormDialogVerifiche => 'Verifiche';

  @override
  String get scaffalaturaFormDialogDataUltimaVerifica => 'Data ultima verifica';

  @override
  String get scaffalaturaFormDialogEsitoPositivo => 'Esito POSITIVO?';

  @override
  String get scaffalaturaFormDialogDataProssimaVerifica =>
      'Data prossima verifica';

  @override
  String get infoDialogNoteScadenzaTitle => 'Informazioni per le note scadenza';

  @override
  String get infoDialogNoteScadenzaIntro => 'Inserendo la parola ';

  @override
  String get infoDialogNoteScadenzaOr => ' oppure ';

  @override
  String get infoDialogNoteScadenzaOutro =>
      ' all\'interno della nota di scadenza,\nl\'auto invio dell\'email per tale scadenza verrà bloccato.';

  @override
  String get infoDialogEmailScadenzaTitle =>
      'Informazioni per l\'invio delle email scadenze';

  @override
  String get infoDialogEmailScadenzaIntro => 'Le email delle scadenze di ';

  @override
  String get infoDialogEmailScadenzaMiddle => ' vengono gestite dalla pagina ';

  @override
  String get infoDialogEmailScadenzaPageName =>
      'Amministrazione - Scadenze generali';

  @override
  String get infoDialogEmailScadenzaOutro =>
      '.\nModificare quindi da lì la scadenza quando viene effettuato il controllo.';

  @override
  String notaAutomezzoDialogTitle(String nome, String tipo) {
    return 'Nota — $nome — $tipo';
  }

  @override
  String get pagina404ScreenTitle => 'Errore 404';

  @override
  String get pagina404ScreenMessage =>
      'Ops! Sembra che tu ti sia perso.\nLa pagina che cerchi non esiste o è stata spostata.';

  @override
  String get pagina404ScreenTornaHome => 'Torna alla Home';
}
