// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Demo Scheduler';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonSave => 'Save';

  @override
  String get commonDelete => 'Delete';

  @override
  String get commonConfirm => 'Confirm';

  @override
  String get commonEdit => 'Edit';

  @override
  String get commonClose => 'Close';

  @override
  String get commonYes => 'Yes';

  @override
  String get commonNo => 'No';

  @override
  String get commonSearch => 'Search';

  @override
  String get commonLoading => 'Loading...';

  @override
  String get commonError => 'Error';

  @override
  String get commonAdd => 'Add';

  @override
  String get commonBack => 'Back';

  @override
  String get commonNoteLabel => 'Notes';

  @override
  String get commonRequiredField => 'Required field';

  @override
  String commonErrorWithDetails(String details) {
    return 'Error: $details';
  }

  @override
  String get appBarGoHome => 'Go to home';

  @override
  String get appBarLogout => 'Log out';

  @override
  String get appBarLogoutConfirmTitle => 'Confirm logout';

  @override
  String get appBarLogoutConfirmMessage => 'Are you sure you want to log out?';

  @override
  String get appBarLogoutConfirmButton => 'Log out';

  @override
  String get appBarLanguageTooltip => 'Cambia in italiano';

  @override
  String get confirmDialogCancel => 'Cancel';

  @override
  String get confirmDialogDeleteDefault => 'Delete';

  @override
  String get loginWelcomeTitle => 'Welcome!';

  @override
  String get loginWelcomeSubtitle => 'Sign in to the construction site manager';

  @override
  String get loginEmailHint => 'Enter your email';

  @override
  String get loginEmailLabel => 'Email';

  @override
  String get loginEmailValidatorEmpty => 'Enter your email';

  @override
  String get loginPasswordHint => 'Enter your password';

  @override
  String get loginPasswordLabel => 'Password';

  @override
  String get loginPasswordValidatorEmpty => 'Enter your password';

  @override
  String get loginButton => 'Login';

  @override
  String get authInvalidCredentials => 'Invalid credentials';

  @override
  String get errorLoadingScale => 'Error loading ladders';

  @override
  String get errorLoadingTipiScadenza => 'Error loading deadline types';

  @override
  String get errorLoadingScadenzeGenerali => 'Error loading general deadlines';

  @override
  String get errorLoadingCantieri => 'Error loading construction sites';

  @override
  String get errorLoadingTipiDpi => 'Error loading PPE types';

  @override
  String get errorLoadingImpostazioni => 'Error loading settings';

  @override
  String get errorLoadingDocumenti => 'Error loading documents';

  @override
  String get errorLoadingMisure => 'Error loading measurements';

  @override
  String get errorLoadingRifiuti => 'Error loading waste records';

  @override
  String get errorLoadingEstintori => 'Error loading fire extinguishers';

  @override
  String get errorLoadingBenne => 'Error loading buckets';

  @override
  String get errorLoadingSegnaletica => 'Error loading signage';

  @override
  String get errorLoadingCassette => 'Error loading first aid kits';

  @override
  String get errorLoadingMacchinari => 'Error loading machinery';

  @override
  String get errorLoadingAutomezzi => 'Error loading vehicles';

  @override
  String get errorLoadingRegoleDpi => 'Error loading PPE rules';

  @override
  String get errorLoadingImpianti => 'Error loading systems';

  @override
  String get errorLoadingControlli => 'Error loading inspections';

  @override
  String get errorLoadingFasceCatene => 'Error loading straps and chains';

  @override
  String get errorLoadingSubappaltatori => 'Error loading subcontractors';

  @override
  String get errorLoadingDipendentiSubappaltatori => 'Error loading employees';

  @override
  String get errorLoadingArticoli => 'Error loading items';

  @override
  String get errorLoadingDpiAssegnati => 'Error loading assigned PPE';

  @override
  String get errorLoadingProdottiStandard => 'Error loading standard products';

  @override
  String get errorLoadingDipendentiAziendali =>
      'Error loading company employees';

  @override
  String get errorLoadingScaffalature => 'Error loading shelving';

  @override
  String get errorDeletingScadenzaGenerale => 'Unable to delete the deadline';

  @override
  String get errorDeletingTipoScadenzaInUse =>
      'Unable to delete the type: it is probably still used by one or more deadlines.';

  @override
  String get errorDeletingScaffalatura => 'Unable to delete the shelving';

  @override
  String get appDrawerAmministrazione => 'Administration';

  @override
  String get appDrawerArchivioCantieri => 'Site archive';

  @override
  String get appDrawerAutomezzi => 'Vehicles';

  @override
  String get appDrawerCantieri => 'Construction sites';

  @override
  String get appDrawerContenutoStandard => 'Standard contents';

  @override
  String get appDrawerDpi => 'PPE';

  @override
  String get appDrawerEstintori => 'Fire extinguishers';

  @override
  String get appDrawerFasceCatene => 'Slings/Chains';

  @override
  String get appDrawerHideSubsections => 'Hide subsections';

  @override
  String get appDrawerImpianti => 'Systems';

  @override
  String get appDrawerMacchinari => 'Machinery';

  @override
  String get appDrawerMisure => 'Gauges';

  @override
  String get appDrawerOtherSectionsTitle => 'Other sections';

  @override
  String get appDrawerPrimoSoccorso => 'First aid';

  @override
  String get appDrawerRemindersSuspended => 'Reminders suspended';

  @override
  String get appDrawerRifiuti => 'Waste';

  @override
  String get appDrawerScaffalature => 'Shelving';

  @override
  String get appDrawerScale => 'Ladders';

  @override
  String get appDrawerSegnaleticaSicurezza => 'Safety signals';

  @override
  String get appDrawerShowSubsections => 'Show subsections';

  @override
  String get appDrawerSubappaltatori => 'Subcontractors';

  @override
  String get appDrawerSuspendReminderSubtitle => 'For company closure periods';

  @override
  String get appDrawerSuspendReminders => 'Suspend reminders';

  @override
  String appDrawerSuspendedUntil(String date) {
    return 'Until $date';
  }

  @override
  String get appDrawerTipiDpi => 'PPE types';

  @override
  String get appDrawerTipiScadenze => 'Deadline types';

  @override
  String get appDrawerUpcomingDeadlinesTooltip => 'Upcoming deadlines';

  @override
  String cantiereCardClosedOn(String date) {
    return 'Closed on $date';
  }

  @override
  String get cantiereCardDeleteTooltip => 'Delete site';

  @override
  String get cantiereCardEditTooltip => 'Edit site';

  @override
  String cantiereCardExpiringCount(int count) {
    return '$count expiring soon';
  }

  @override
  String cantiereCardSubappaltatoriCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count subcontractors',
      one: '$count subcontractor',
    );
    return '$_temp0';
  }

  @override
  String get cantiereCardSuspendedLabel => 'SUSPENDED';

  @override
  String get dpiAssegnatoFormDialogAdditionalNotesLabel => 'Additional notes';

  @override
  String get dpiAssegnatoFormDialogAssignTitle => 'Assign PPE';

  @override
  String get dpiAssegnatoFormDialogDateInUseLabel => 'Date put into use';

  @override
  String get dpiAssegnatoFormDialogDeliveryDateLabel => 'Delivery date';

  @override
  String get dpiAssegnatoFormDialogDpiTypeLabel => 'PPE type*';

  @override
  String get dpiAssegnatoFormDialogEditTitle => 'Edit assigned PPE';

  @override
  String get dpiAssegnatoFormDialogEmployeeLabel => 'Employee';

  @override
  String get dpiAssegnatoFormDialogExpiryDateLabel => 'Expiry date';

  @override
  String get dpiAssegnatoFormDialogManufactureYearLabel =>
      'Year of manufacture';

  @override
  String get dpiAssegnatoFormDialogManufacturerLabel => 'Manufacturer';

  @override
  String get dpiAssegnatoFormDialogSelectDpiType => 'Select a PPE type';

  @override
  String get dpiAssegnatoFormDialogSelectEmployee => 'Select an employee';

  @override
  String get dpiAssegnatoFormDialogSerialNumberLabel => 'Serial number';

  @override
  String get dpiAssegnatoFormDialogSizeLabel => 'Size';

  @override
  String get fasciaCatenaFormDialogAdditionalNotesLabel => 'Additional notes';

  @override
  String get fasciaCatenaFormDialogBrowse => 'Browse';

  @override
  String get fasciaCatenaFormDialogCapacityLabel => 'Capacity (kg)';

  @override
  String get fasciaCatenaFormDialogChangePhoto => 'Change photo';

  @override
  String get fasciaCatenaFormDialogCharacteristicsSection => 'Characteristics';

  @override
  String get fasciaCatenaFormDialogCheckPassedLabel => 'Check passed';

  @override
  String get fasciaCatenaFormDialogColorLabel => 'Color';

  @override
  String get fasciaCatenaFormDialogDiameterLabel => 'Diameter (mm)';

  @override
  String get fasciaCatenaFormDialogDragPhotoHint =>
      'Drag the sling/chain photo here';

  @override
  String get fasciaCatenaFormDialogEditTitle => 'Edit sling/chain';

  @override
  String get fasciaCatenaFormDialogFileFormatsHint =>
      'JPG, PNG or WEBP - max 5 MB';

  @override
  String get fasciaCatenaFormDialogFitForUse => 'Fit for use';

  @override
  String get fasciaCatenaFormDialogImageTooLarge =>
      'Image too large (max 5 MB)';

  @override
  String get fasciaCatenaFormDialogImageUnavailable => 'Image unavailable';

  @override
  String get fasciaCatenaFormDialogInternalCheckSection => 'Internal check';

  @override
  String get fasciaCatenaFormDialogInternalIdLabel => 'Internal ID*';

  @override
  String fasciaCatenaFormDialogInvalidExtension(String extension) {
    return 'File type not allowed (.$extension)';
  }

  @override
  String get fasciaCatenaFormDialogLastInternalCheckLabel =>
      'Last internal check';

  @override
  String get fasciaCatenaFormDialogLengthLabel => 'Length (m)';

  @override
  String get fasciaCatenaFormDialogLocationNotSpecified => 'Not specified';

  @override
  String get fasciaCatenaFormDialogLocationSection => 'Location';

  @override
  String get fasciaCatenaFormDialogLocationTypeLabel => 'Location type';

  @override
  String get fasciaCatenaFormDialogNewTitle => 'New sling/chain';

  @override
  String get fasciaCatenaFormDialogNextCheckLabel => 'Next check';

  @override
  String get fasciaCatenaFormDialogNotFitForUse =>
      'Not fit for use: to be taken out of service';

  @override
  String get fasciaCatenaFormDialogPhotoSection => 'Photo';

  @override
  String get fasciaCatenaFormDialogPurchaseDateLabel => 'Purchase date';

  @override
  String get fasciaCatenaFormDialogPurchaseLocationLabel => 'Place of purchase';

  @override
  String get fasciaCatenaFormDialogPurchaseSection => 'Purchase';

  @override
  String get fasciaCatenaFormDialogRatchetLabel => 'Ratchet';

  @override
  String get fasciaCatenaFormDialogRegistrySection => 'Details';

  @override
  String get fasciaCatenaFormDialogRemove => 'Remove';

  @override
  String get fasciaCatenaFormDialogSelectSite => 'Select a construction site';

  @override
  String get fasciaCatenaFormDialogSelectVehicle => 'Select a vehicle';

  @override
  String get fasciaCatenaFormDialogSerialNumberLabel =>
      'Manufacturer serial number';

  @override
  String get fasciaCatenaFormDialogSiteOption => 'Construction site';

  @override
  String get fasciaCatenaFormDialogThicknessLabel => 'Thickness (mm)';

  @override
  String get fasciaCatenaFormDialogTypeLabel => 'Type';

  @override
  String get fasciaCatenaFormDialogTypeNotSpecified => 'Not specified';

  @override
  String get fasciaCatenaFormDialogVehicleOption => 'Vehicle';

  @override
  String get fasciaCatenaFormDialogWarehouseOption => 'Warehouse';

  @override
  String get fasciaCatenaFormDialogWidthLabel => 'Width (mm)';

  @override
  String notaDipendenteAziendaleDialogTitle(String nome, String cognome) {
    return 'Note — $nome $cognome';
  }

  @override
  String notaDipendenteAziendaleDialogTitleConTipo(
    String nome,
    String cognome,
    String tipo,
  ) {
    return 'Note — $nome $cognome — $tipo';
  }

  @override
  String notaEstintoreDialogTitle(String matricola, String tipo) {
    return 'Note — $matricola — $tipo';
  }

  @override
  String notaScaffalaturaDialogTitle(String id, String tipo) {
    return 'Note — Shelving unit #$id — $tipo';
  }

  @override
  String get scadenzeImminentiScreenAerialPlatformsDeadline =>
      'Aerial platforms certification deadline';

  @override
  String get scadenzeImminentiScreenAnnualCheck => 'Annual inspection';

  @override
  String get scadenzeImminentiScreenAnnualMaintenance => 'Annual maintenance';

  @override
  String get scadenzeImminentiScreenArticleLabel => 'Item';

  @override
  String get scadenzeImminentiScreenAssigneeLabel => 'Assignee';

  @override
  String get scadenzeImminentiScreenCollapseAll => 'Collapse all';

  @override
  String get scadenzeImminentiScreenCompanyEmployeesSection =>
      'Company employees';

  @override
  String get scadenzeImminentiScreenCompanyLabel => 'Company';

  @override
  String get scadenzeImminentiScreenContractDeadline => 'Contract deadline';

  @override
  String get scadenzeImminentiScreenDeadlineNoteLabel => 'Deadline note';

  @override
  String get scadenzeImminentiScreenDigitalSignatureDeadline =>
      'Digital signature deadline';

  @override
  String get scadenzeImminentiScreenDiisocyanatesCourseDeadline =>
      'Diisocyanates course deadline';

  @override
  String get scadenzeImminentiScreenDocumentFallback => 'Document';

  @override
  String get scadenzeImminentiScreenDrivingLicenseDeadline =>
      'Driving license deadline';

  @override
  String get scadenzeImminentiScreenEditNoteTooltip => 'Edit note';

  @override
  String get scadenzeImminentiScreenEmployeeLabel => 'Employee';

  @override
  String get scadenzeImminentiScreenExcavatorOperationDeadline =>
      'Excavator operation certification deadline';

  @override
  String get scadenzeImminentiScreenExpandAll => 'Expand all';

  @override
  String get scadenzeImminentiScreenExternalCheckDeadline =>
      'External check deadline';

  @override
  String get scadenzeImminentiScreenExternalMaintenanceDeadline =>
      'External maintenance deadline';

  @override
  String get scadenzeImminentiScreenFireSafetyDeadline =>
      'Fire safety certification deadline';

  @override
  String get scadenzeImminentiScreenFirstAidDeadline =>
      'First aid certification deadline';

  @override
  String get scadenzeImminentiScreenFirstAidSection => 'First aid';

  @override
  String get scadenzeImminentiScreenForkliftDeadline =>
      'Forklift certification deadline';

  @override
  String get scadenzeImminentiScreenGeneralDeadlinesSection =>
      'General deadlines';

  @override
  String get scadenzeImminentiScreenHazardousWasteCarrierDeadline =>
      'Hazardous waste carrier deadline';

  @override
  String get scadenzeImminentiScreenHazardousWasteDisposerDeadline =>
      'Hazardous waste disposer deadline';

  @override
  String get scadenzeImminentiScreenHeightWorkDeadline =>
      'Height work certification deadline';

  @override
  String get scadenzeImminentiScreenHideSectionTooltip => 'Hide deadlines';

  @override
  String get scadenzeImminentiScreenIdCardDeadline => 'ID card deadline';

  @override
  String get scadenzeImminentiScreenInspectionDeadline => 'Inspection deadline';

  @override
  String get scadenzeImminentiScreenInsuranceDeadline => 'Insurance deadline';

  @override
  String get scadenzeImminentiScreenInternalMaintenanceDeadline =>
      'Internal maintenance deadline';

  @override
  String get scadenzeImminentiScreenLadderCodeLabel => 'Ladder code';

  @override
  String get scadenzeImminentiScreenLastCheckLabel => 'Last check';

  @override
  String get scadenzeImminentiScreenLeaseRentalDeadline =>
      'Lease/rental deadline';

  @override
  String get scadenzeImminentiScreenLocationInOfficeLower => 'in Office';

  @override
  String get scadenzeImminentiScreenLocationInWarehouseLower => 'in Warehouse';

  @override
  String get scadenzeImminentiScreenLocationLabel => 'Location';

  @override
  String get scadenzeImminentiScreenLocationNotSpecified => 'Not specified';

  @override
  String get scadenzeImminentiScreenLocationNotSpecifiedLower =>
      'not specified';

  @override
  String get scadenzeImminentiScreenLocationOffice => 'In office';

  @override
  String scadenzeImminentiScreenLocationSite(String site) {
    return 'At site $site';
  }

  @override
  String scadenzeImminentiScreenLocationVehicle(String vehicle) {
    return 'On vehicle $vehicle';
  }

  @override
  String get scadenzeImminentiScreenLocationWarehouse => 'In warehouse';

  @override
  String get scadenzeImminentiScreenLorryCraneDeadline =>
      'Lorry-mounted crane certification deadline';

  @override
  String get scadenzeImminentiScreenMedicalExamDeadline =>
      'Medical exam deadline';

  @override
  String get scadenzeImminentiScreenModelLabel => 'Model';

  @override
  String get scadenzeImminentiScreenNextCheckLabel => 'Next check';

  @override
  String get scadenzeImminentiScreenNextExternalCalibration =>
      'Next external calibration';

  @override
  String get scadenzeImminentiScreenNextInternalCalibration =>
      'Next internal calibration';

  @override
  String get scadenzeImminentiScreenNextVerificationLabel => 'Next inspection';

  @override
  String get scadenzeImminentiScreenNonHazardousWasteCarrierDeadline =>
      'Non-hazardous waste carrier deadline';

  @override
  String get scadenzeImminentiScreenNonHazardousWasteDisposerDeadline =>
      'Non-hazardous waste disposer deadline';

  @override
  String scadenzeImminentiScreenNoteTitleGeneric(String titolo) {
    return 'Note — $titolo';
  }

  @override
  String scadenzeImminentiScreenNoteTitleSiteDeadline(
    String site,
    String label,
  ) {
    return 'Note — $site — $label';
  }

  @override
  String get scadenzeImminentiScreenPlateLabel => 'Plate';

  @override
  String scadenzeImminentiScreenProductDeadline(String product) {
    return '$product deadline';
  }

  @override
  String get scadenzeImminentiScreenReplacement18Years =>
      'Replacement (18 years)';

  @override
  String get scadenzeImminentiScreenResidencyPermitDeadline =>
      'Residency permit deadline';

  @override
  String get scadenzeImminentiScreenRlstDeadline =>
      'Workers\' safety representative (RLST) deadline';

  @override
  String get scadenzeImminentiScreenRoadTaxDeadline => 'Road tax deadline';

  @override
  String get scadenzeImminentiScreenRopesChainsCheck => 'Ropes/chains check';

  @override
  String get scadenzeImminentiScreenRsppDeadline =>
      'Safety officer (RSPP) deadline';

  @override
  String get scadenzeImminentiScreenSafetyTrainingDeadline =>
      'Safety training deadline';

  @override
  String get scadenzeImminentiScreenScaffoldingErectionDeadline =>
      'Scaffolding erection/dismantling deadline';

  @override
  String get scadenzeImminentiScreenSectionHeaderTitle => 'Deadlines to review';

  @override
  String get scadenzeImminentiScreenSerialNumberLabel => 'Serial number';

  @override
  String get scadenzeImminentiScreenShelvingCourseDeadline =>
      'Shelving course deadline';

  @override
  String get scadenzeImminentiScreenShelvingIdLabel => 'Shelving ID';

  @override
  String get scadenzeImminentiScreenShelvingNextCheckLabel =>
      'Next shelving check';

  @override
  String get scadenzeImminentiScreenShowSectionTooltip => 'Show deadlines';

  @override
  String get scadenzeImminentiScreenSiteLabel => 'Construction site';

  @override
  String get scadenzeImminentiScreenSitesPresentLabel => 'Sites where present';

  @override
  String get scadenzeImminentiScreenSubcontractorLabel => 'Subcontractor';

  @override
  String get scadenzeImminentiScreenSupervisorDeadline =>
      'Supervisor certification deadline';

  @override
  String get scadenzeImminentiScreenTachographCardCompanyDeadline =>
      'Tachograph card + company deadline';

  @override
  String get scadenzeImminentiScreenTachographCardDeadline =>
      'Tachograph card deadline';

  @override
  String get scadenzeImminentiScreenTachographCourseDeadline =>
      'Tachograph course deadline';

  @override
  String get scadenzeImminentiScreenTachographDeadline => 'Tachograph deadline';

  @override
  String get scadenzeImminentiScreenTaxCodeDeadline => 'Tax code deadline';

  @override
  String get scadenzeImminentiScreenTestingDeadline => 'Testing deadline';

  @override
  String get scadenzeImminentiScreenTetanusDeadline =>
      'Tetanus vaccination deadline';

  @override
  String get scadenzeImminentiScreenTitle => 'Upcoming deadlines';

  @override
  String get scadenzeImminentiScreenTowerCraneDeadline =>
      'Tower crane certification deadline';

  @override
  String get scadenzeImminentiScreenTwentyYearCheck => 'Twenty-year inspection';

  @override
  String get scadenzeImminentiScreenTypeLabel => 'Type';

  @override
  String get scadenzeImminentiScreenVehicleLabel => 'Vehicle';

  @override
  String get subappaltatoreDocumentiScreenAddEmployeeLabel => 'Add employee';

  @override
  String get subappaltatoreDocumentiScreenAddGeneralDeadlineLabel =>
      'Add general deadline';

  @override
  String get subappaltatoreDocumentiScreenAssociatedSitesLabel =>
      'Associated sites';

  @override
  String get subappaltatoreDocumentiScreenBreadcrumbCantieri =>
      'Construction sites';

  @override
  String get subappaltatoreDocumentiScreenBreadcrumbSubappaltatori =>
      'Subcontractors';

  @override
  String subappaltatoreDocumentiScreenDeleteEmployeeConfirm(String nome) {
    return 'Delete \"$nome\"?';
  }

  @override
  String get subappaltatoreDocumentiScreenDeleteEmployeeNoDocs =>
      'Their name will disappear from the sites where they are listed.';

  @override
  String get subappaltatoreDocumentiScreenDeleteEmployeeTitle =>
      'Delete employee?';

  @override
  String get subappaltatoreDocumentiScreenDeleteEmployeeTooltip =>
      'Delete employee';

  @override
  String subappaltatoreDocumentiScreenDeleteEmployeeWithDocs(int count) {
    return 'Their $count deadlines will also be deleted (including history), and their name will disappear from the sites where they are listed.';
  }

  @override
  String get subappaltatoreDocumentiScreenDocsInOrder => 'Documents in order';

  @override
  String get subappaltatoreDocumentiScreenEmailLabel => 'Email';

  @override
  String get subappaltatoreDocumentiScreenEmployeesLabel => 'Employees';

  @override
  String get subappaltatoreDocumentiScreenGeneralDeadlinesLabel =>
      'General deadlines';

  @override
  String get subappaltatoreDocumentiScreenInfoLabel => 'Information:';

  @override
  String get subappaltatoreDocumentiScreenIrreversible =>
      'This action cannot be undone.';

  @override
  String get subappaltatoreDocumentiScreenNewGeneralDeadlineTooltip =>
      'New general deadline';

  @override
  String get subappaltatoreDocumentiScreenNoDeadlinesForSite =>
      'No deadlines for this site.';

  @override
  String get subappaltatoreDocumentiScreenNoDeadlinesRegistered =>
      'No deadlines registered';

  @override
  String get subappaltatoreDocumentiScreenNoEmployees =>
      'No employees added for this subcontractor.';

  @override
  String get subappaltatoreDocumentiScreenNoGeneralDeadlines =>
      'No general deadlines added for this subcontractor.';

  @override
  String get subappaltatoreDocumentiScreenOpenSiteTooltip => 'Open site';

  @override
  String get subappaltatoreDocumentiScreenSelfEmployed => 'Self-employed';

  @override
  String subappaltatoreDocumentiScreenSiteIndexTitle(int index, String nome) {
    return '$index) $nome';
  }

  @override
  String get subappaltatoreDocumentiScreenTypeLabel => 'Type';

  @override
  String get subappaltatoreDocumentiScreenVatLabel => 'VAT number';

  @override
  String get tipiDpiScreenBreadcrumbDpi => 'PPE';

  @override
  String get tipiDpiScreenBreadcrumbTipiDpi => 'PPE types';

  @override
  String tipiDpiScreenDeleteConfirmMessage(String nome) {
    return 'Delete the PPE type $nome? This action cannot be undone.';
  }

  @override
  String get tipiDpiScreenDeleteConfirmTitle => 'Delete this type?';

  @override
  String get tipiDpiScreenDeleteTooltip => 'Delete type';

  @override
  String get tipiDpiScreenEditTooltip => 'Edit type';

  @override
  String get tipiDpiScreenEmptyState => 'No PPE added.';

  @override
  String get tipiDpiScreenForHeightWork => 'For height work';

  @override
  String get tipiDpiScreenNewDpiLabel => 'New PPE';

  @override
  String tipiDpiScreenNoteLabel(String note) {
    return 'Note: $note';
  }

  @override
  String get campoDataClearDateTooltip => 'Clear date';

  @override
  String get campoDataFormatHint => 'dd/mm/yyyy';

  @override
  String get campoDataInvalidDate => 'Invalid date';

  @override
  String get campoDataPickDateTooltip => 'Pick a date';

  @override
  String get campoDataRemoveFieldTooltip => 'Remove field';

  @override
  String campoDataYearRange(int min, int max) {
    return 'Year between $min and $max';
  }

  @override
  String get creaDpiFormDialogAdditionalNotesLabel => 'Additional notes';

  @override
  String get creaDpiFormDialogHeightWorkRequired =>
      'Required for working at height';

  @override
  String get creaDpiFormDialogHeightWorkSubtitle =>
      'Automatically required for workers (M04) with a working-at-height deadline set';

  @override
  String get creaDpiFormDialogNameLabel => 'Name*';

  @override
  String get creaDpiFormDialogNoticeDaysHint => '30, 7, 1';

  @override
  String get creaDpiFormDialogNoticeDaysLabel => 'Notice days';

  @override
  String get creaDpiFormDialogTitleEdit => 'Edit PPE';

  @override
  String get creaDpiFormDialogTitleNew => 'New PPE';

  @override
  String scadenzaCantiereTileConfirmDeleteMessage(
    String etichetta,
    String cantiere,
  ) {
    return 'Delete $etichetta from $cantiere? This action cannot be undone.';
  }

  @override
  String get scadenzaCantiereTileConfirmDeleteTitle => 'Delete this deadline?';

  @override
  String get scadenzaCantiereTileDeleteTooltip => 'Delete deadline';

  @override
  String scadenzaCantiereTileDueDate(String date) {
    return 'Due date: $date';
  }

  @override
  String get scadenzaCantiereTileEditTooltip => 'Edit deadline';

  @override
  String scadenzaCantiereTileNotesLine(String note) {
    return 'Notes: $note';
  }

  @override
  String notaRifiutoDialogTitle(String nomeDitta, String tipo) {
    return 'Note — $nomeDitta — $tipo';
  }

  @override
  String notaScadenzaScalaDialogTitle(String codice) {
    return 'Note — Ladder $codice';
  }

  @override
  String get notaScadenzaDocumentoDialogDefaultType => 'document';

  @override
  String notaScadenzaDocumentoDialogTitle(String tipo) {
    return 'Note — $tipo';
  }

  @override
  String get creaSegnaleFormDialogBrowse => 'Browse';

  @override
  String get creaSegnaleFormDialogChangeImage => 'Change image';

  @override
  String get creaSegnaleFormDialogDragDropText => 'Drag the sign image here';

  @override
  String creaSegnaleFormDialogExtensionNotAllowed(String estensione) {
    return 'File type not allowed (.$estensione)';
  }

  @override
  String get creaSegnaleFormDialogFileTooLarge => 'Image too large (max 5 MB)';

  @override
  String get creaSegnaleFormDialogFileTypesHint =>
      'JPG, PNG or WEBP - max 5 MB';

  @override
  String get creaSegnaleFormDialogImageSectionTitle => 'Sign image';

  @override
  String get creaSegnaleFormDialogImageUnavailable => 'Image unavailable';

  @override
  String get creaSegnaleFormDialogLocationHint =>
      'E.g. entrance hallway, north side';

  @override
  String get creaSegnaleFormDialogLocationLabel => 'Location';

  @override
  String get creaSegnaleFormDialogNameLabel => 'Name*';

  @override
  String get creaSegnaleFormDialogRemoveImage => 'Remove';

  @override
  String get creaSegnaleFormDialogTitleEdit => 'Edit sign';

  @override
  String get creaSegnaleFormDialogTitleNew => 'New sign';

  @override
  String get creaSegnaleFormDialogZoneLabel => 'Zone';

  @override
  String get creaSegnaleFormDialogZoneOffice => 'Office';

  @override
  String get creaSegnaleFormDialogZoneUnspecified => 'Unspecified';

  @override
  String get creaSegnaleFormDialogZoneWarehouse => 'Warehouse';

  @override
  String subappaltatoriScreenConfirmDeleteMessage(String nome) {
    return 'Delete \"$nome\"? This action cannot be undone.';
  }

  @override
  String get subappaltatoriScreenConfirmDeleteTitle => 'Delete subcontractor?';

  @override
  String get subappaltatoriScreenDeleteTooltip => 'Delete subcontractor';

  @override
  String get subappaltatoriScreenEditTooltip => 'Edit subcontractor';

  @override
  String get subappaltatoriScreenEmptyLoaded => 'No subcontractors loaded.';

  @override
  String subappaltatoriScreenEmptySearch(String query) {
    return 'No subcontractor found for \"$query\".';
  }

  @override
  String get subappaltatoriScreenNewTooltip => 'New subcontractor';

  @override
  String get subappaltatoriScreenNone => 'none';

  @override
  String get subappaltatoriScreenSearchHint => 'Search by company name';

  @override
  String get subappaltatoriScreenSitesCount => 'Associated sites';

  @override
  String get subappaltatoriNumDipendenti => 'Number of employees';

  @override
  String get subappaltatoriScreenTitle => 'Subcontractors';

  @override
  String get cantiereDetailScreenAddDeadlineLabel => 'Add deadline';

  @override
  String get cantiereDetailScreenAddSubcontractorLabel => 'Add subcontractor';

  @override
  String get cantiereDetailScreenAddressLabel => 'Address';

  @override
  String get cantiereDetailScreenBreadcrumbSites => 'Sites';

  @override
  String cantiereDetailScreenConfirmDeleteMessage(String nome) {
    return 'All deadlines for $nome and those of the subcontractors assigned to this site will be permanently deleted from the server.\nTHIS ACTION CANNOT BE UNDONE.';
  }

  @override
  String get cantiereDetailScreenConfirmDeleteTitle =>
      'Delete the site\'s deadlines?';

  @override
  String cantiereDetailScreenConfirmRemoveMessage(String nome) {
    return 'Remove \"$nome\" from this site? The subcontractor will not be deleted, but their deadlines and those of their employees will no longer be linked to this site.';
  }

  @override
  String get cantiereDetailScreenConfirmRemoveTitle =>
      'Remove subcontractor from this site?';

  @override
  String get cantiereDetailScreenDeadlinesTitle => 'Site deadlines';

  @override
  String get cantiereDetailScreenDeleteDataAction => 'Delete data';

  @override
  String get cantiereDetailScreenEmployeesPresentLabel => 'Employees present';

  @override
  String get cantiereDetailScreenEmployeesPresentTooltip =>
      'Employees present at this site';

  @override
  String get cantiereDetailScreenEndDateLabel => 'End date';

  @override
  String get cantiereDetailScreenGeneralDeadlinesTitle =>
      'General site deadlines';

  @override
  String get cantiereDetailScreenInfoSectionTitle => 'Information:';

  @override
  String get cantiereDetailScreenNoDeadlines =>
      'No deadlines recorded for this site.';

  @override
  String get cantiereDetailScreenNoGeneralDeadlines =>
      'No general deadlines set for this site.';

  @override
  String get cantiereDetailScreenNoSubcontractors =>
      'No subcontractors associated with this site.';

  @override
  String get cantiereDetailScreenNoneValue => 'none';

  @override
  String get cantiereDetailScreenNotSet => 'Not set';

  @override
  String get cantiereDetailScreenPostalCodeLabel => 'Postal code';

  @override
  String get cantiereDetailScreenRemoveFromSiteTooltip =>
      'Remove from this site';

  @override
  String get cantiereDetailScreenStartDateLabel => 'Start date';

  @override
  String get cantiereDetailScreenSubcontractorsTitle => 'Subcontractors';

  @override
  String get cantiereDetailScreenSuspensionDateLabel => 'Suspension date';

  @override
  String get cantieriScreenActiveSitesTitle => 'Active sites';

  @override
  String get cantieriScreenArchiveAction => 'Site archive';

  @override
  String cantieriScreenConfirmDeleteMessage(String nome) {
    return 'Delete the site $nome? This action cannot be undone.';
  }

  @override
  String get cantieriScreenConfirmDeleteTitle => 'Delete site?';

  @override
  String get cantieriScreenDeadlineNoteLabel => 'Deadline note';

  @override
  String get cantieriScreenDeadlineTypesAction => 'Deadline types';

  @override
  String get cantieriScreenDefaultDocumentType => 'Document';

  @override
  String get cantieriScreenEditNoteTooltip => 'Edit note';

  @override
  String get cantieriScreenEmployeeLabel => 'Employee';

  @override
  String get cantieriScreenEmptyAllConcluded =>
      'No active sites (all completed).';

  @override
  String get cantieriScreenEmptyLoaded => 'No sites loaded.';

  @override
  String cantieriScreenEmptySearch(String query) {
    return 'No site found for \"$query\".';
  }

  @override
  String get cantieriScreenHideDeadlinesTooltip => 'Hide deadlines';

  @override
  String get cantieriScreenNewSiteAction => 'New site';

  @override
  String cantieriScreenNoteDialogTitle(String nome, String etichetta) {
    return 'Note — $nome — $etichetta';
  }

  @override
  String get cantieriScreenSearchHint => 'Search by name or municipality';

  @override
  String get cantieriScreenShowDeadlinesTooltip => 'Show deadlines';

  @override
  String get cantieriScreenSiteDeadlinesGroup => 'Site deadlines';

  @override
  String get cantieriScreenSiteLabel => 'Site';

  @override
  String get cantieriScreenSitesPresentLabel => 'Sites where present';

  @override
  String get cantieriScreenSubcontractorsAction => 'Subcontractors';

  @override
  String get cantieriScreenTitle => 'Sites';

  @override
  String get cantieriScreenUpcomingDeadlinesTitle => 'Upcoming deadlines';

  @override
  String amministrazioneScreenConfirmDeleteDeadlineMessage(String nome) {
    return 'Delete \"$nome\"? This action cannot be undone.';
  }

  @override
  String get amministrazioneScreenConfirmDeleteDeadlineTitle =>
      'Delete deadline?';

  @override
  String amministrazioneScreenConfirmDeleteEmployeeMessage(String nome) {
    return 'Delete \"$nome\"? This action cannot be undone.';
  }

  @override
  String get amministrazioneScreenConfirmDeleteEmployeeTitle =>
      'Delete employee?';

  @override
  String get amministrazioneScreenDeadlineDateLabel => 'Due date';

  @override
  String get amministrazioneScreenDeadlineNoteLabel => 'Deadline note';

  @override
  String get amministrazioneScreenDeleteDeadlineTooltip => 'Delete deadline';

  @override
  String get amministrazioneScreenDeleteEmployeeTooltip => 'Delete employee';

  @override
  String get amministrazioneScreenDlAerialPlatform =>
      'Aerial platform license expiry';

  @override
  String get amministrazioneScreenDlContract => 'Contract expiry';

  @override
  String get amministrazioneScreenDlDigitalSignature =>
      'Digital signature expiry';

  @override
  String get amministrazioneScreenDlExcavator =>
      'Excavator operation license expiry';

  @override
  String get amministrazioneScreenDlFirefighting =>
      'Firefighting certification expiry';

  @override
  String get amministrazioneScreenDlFirstAid =>
      'First aid certification expiry';

  @override
  String get amministrazioneScreenDlForklift =>
      'Self-propelled forklift license expiry';

  @override
  String get amministrazioneScreenDlHeightWork =>
      'Working at height certification expiry';

  @override
  String get amministrazioneScreenDlIdCard => 'ID card expiry';

  @override
  String get amministrazioneScreenDlIsocyanates =>
      'Diisocyanates course expiry';

  @override
  String get amministrazioneScreenDlLicense => 'Driving license expiry';

  @override
  String get amministrazioneScreenDlMedicalCheckup => 'Medical checkup expiry';

  @override
  String get amministrazioneScreenDlResidencePermit =>
      'Residence permit expiry';

  @override
  String get amministrazioneScreenDlRlst => 'RLST certification expiry';

  @override
  String get amministrazioneScreenDlRspp => 'RSPP certification expiry';

  @override
  String get amministrazioneScreenDlSafetyTraining => 'Safety training expiry';

  @override
  String get amministrazioneScreenDlScaffolding =>
      'Scaffolding assembly/disassembly certification expiry';

  @override
  String get amministrazioneScreenDlShelving => 'Shelving course expiry';

  @override
  String get amministrazioneScreenDlSupervisor =>
      'Supervisor certification expiry';

  @override
  String get amministrazioneScreenDlTachograph => 'Tachograph card expiry';

  @override
  String get amministrazioneScreenDlTachographCompany =>
      'Tachograph card + company expiry';

  @override
  String get amministrazioneScreenDlTachographCourse =>
      'Tachograph course expiry';

  @override
  String get amministrazioneScreenDlTaxCode => 'Tax code expiry';

  @override
  String get amministrazioneScreenDlTetanus => 'Tetanus vaccination expiry';

  @override
  String get amministrazioneScreenDlTowerCrane => 'Tower crane license expiry';

  @override
  String get amministrazioneScreenDlTruckCrane =>
      'Truck-mounted crane license expiry';

  @override
  String get amministrazioneScreenEditDeadlineTooltip => 'Edit deadline';

  @override
  String get amministrazioneScreenEditEmployeeTooltip => 'Edit employee';

  @override
  String get amministrazioneScreenEditNoteTooltip => 'Edit note';

  @override
  String get amministrazioneScreenEmployeeDeadlinesTitle =>
      'Employee deadlines';

  @override
  String get amministrazioneScreenEmployeeLabel => 'Employee';

  @override
  String get amministrazioneScreenEmployeesTitle => 'Company employees';

  @override
  String get amministrazioneScreenEmptyDeadlinesLoaded =>
      'No deadlines loaded.';

  @override
  String amministrazioneScreenEmptyDeadlinesSearch(String query) {
    return 'No deadline found for \"$query\".';
  }

  @override
  String get amministrazioneScreenEmptyEmployeesLoaded =>
      'No employees loaded.';

  @override
  String amministrazioneScreenEmptyEmployeesSearch(String query) {
    return 'No employee found for \"$query\".';
  }

  @override
  String get amministrazioneScreenFieldAerialPlatform => 'Aerial platforms';

  @override
  String get amministrazioneScreenFieldAge => 'Age';

  @override
  String get amministrazioneScreenFieldBirthDate => 'Date of birth';

  @override
  String get amministrazioneScreenFieldBirthPlace => 'Place of birth';

  @override
  String get amministrazioneScreenFieldDigitalSignature => 'Digital signature';

  @override
  String get amministrazioneScreenFieldEnvironmentalManagement =>
      'Environmental management';

  @override
  String get amministrazioneScreenFieldExcavator => 'Excavator operation';

  @override
  String get amministrazioneScreenFieldFirefighting => 'Firefighting';

  @override
  String get amministrazioneScreenFieldFirstAid => 'First aid';

  @override
  String get amministrazioneScreenFieldForklift => 'Self-propelled forklift';

  @override
  String get amministrazioneScreenFieldGeneralSafetyTraining =>
      'General safety training';

  @override
  String get amministrazioneScreenFieldHealthCard => 'Health card';

  @override
  String get amministrazioneScreenFieldHeightWork => 'Working at height';

  @override
  String get amministrazioneScreenFieldIdCard => 'ID card';

  @override
  String get amministrazioneScreenFieldIsocyanates => 'Diisocyanates course';

  @override
  String get amministrazioneScreenFieldLicense => 'Driving license';

  @override
  String get amministrazioneScreenFieldMedicalCheckup => 'Medical checkup';

  @override
  String get amministrazioneScreenFieldModel231 => 'Model 231';

  @override
  String get amministrazioneScreenFieldName => 'Name';

  @override
  String get amministrazioneScreenFieldRentri => 'Rentri';

  @override
  String get amministrazioneScreenFieldResidencePermit => 'Residence permit';

  @override
  String get amministrazioneScreenFieldRlst => 'RLST';

  @override
  String get amministrazioneScreenFieldRole => 'Role';

  @override
  String get amministrazioneScreenFieldRspp => 'RSPP';

  @override
  String get amministrazioneScreenFieldScaffolding =>
      'Scaffolding assembly/disassembly';

  @override
  String get amministrazioneScreenFieldShelving => 'Shelving course';

  @override
  String get amministrazioneScreenFieldSupervisor => 'Supervisor';

  @override
  String get amministrazioneScreenFieldTachograph => 'Tachograph card';

  @override
  String get amministrazioneScreenFieldTachographCourse => 'Tachograph course';

  @override
  String get amministrazioneScreenFieldTaxCode => 'Tax code';

  @override
  String get amministrazioneScreenFieldTetanus => 'Tetanus';

  @override
  String get amministrazioneScreenFieldTowerCrane => 'Tower crane';

  @override
  String get amministrazioneScreenFieldTruckCrane => 'Truck-mounted crane';

  @override
  String get amministrazioneScreenGeneralDeadlinesTitle => 'General deadlines';

  @override
  String get amministrazioneScreenHideAllTooltip => 'Hide all';

  @override
  String get amministrazioneScreenHideDeadlinesTooltip => 'Hide deadlines';

  @override
  String get amministrazioneScreenHideDetailsTooltip => 'Hide details';

  @override
  String get amministrazioneScreenNoUpcomingDeadlines =>
      'No upcoming deadlines.';

  @override
  String get amministrazioneScreenSearchDeadlinesHint =>
      'Search by name or note';

  @override
  String get amministrazioneScreenSearchEmployeesHint =>
      'Search by first name, last name or role';

  @override
  String get amministrazioneScreenSectionCoursesCompleted =>
      'Completed course deadlines';

  @override
  String get amministrazioneScreenSectionPersonalDeadlines =>
      'Personal deadlines';

  @override
  String get amministrazioneScreenSectionPersonalInfo => 'Personal details';

  @override
  String get amministrazioneScreenSectionTrainingDates =>
      'Completed training course dates';

  @override
  String get amministrazioneScreenShowAllTooltip => 'Show all';

  @override
  String get amministrazioneScreenShowDeadlinesTooltip => 'Show deadlines';

  @override
  String get amministrazioneScreenShowDetailsTooltip => 'Show details';

  @override
  String get amministrazioneScreenTitle => 'Administration';

  @override
  String get amministrazioneScreenUpcomingDeadlinesTitle =>
      'Upcoming deadlines';

  @override
  String get fasceCateneScreenInMagazzino => 'In warehouse';

  @override
  String fasceCateneScreenInCantiere(String nome) {
    return 'At site $nome';
  }

  @override
  String fasceCateneScreenSuAutomezzo(String nome) {
    return 'On vehicle $nome';
  }

  @override
  String get fasceCateneScreenNonSpecificata => 'Not specified';

  @override
  String get fasceCateneScreenEsitoPositivo => 'Passed';

  @override
  String get fasceCateneScreenEsitoNegativo => 'Failed';

  @override
  String get fasceCateneScreenTitle => 'Slings, Chains & Buckets';

  @override
  String get fasceCateneScreenNuovaFasciaCatena => 'New sling/chain';

  @override
  String get fasceCateneScreenInserisciBenna => 'Add bucket';

  @override
  String get fasceCateneScreenPresenti =>
      'Slings, chains and buckets on record';

  @override
  String get fasceCateneScreenNascondiTutti => 'Collapse all';

  @override
  String get fasceCateneScreenMostraTutti => 'Expand all';

  @override
  String get fasceCateneScreenSearchHint =>
      'Search by ID, serial number, type or location';

  @override
  String get fasceCateneScreenNessunElementoCaricato => 'No items loaded.';

  @override
  String fasceCateneScreenNessunElementoTrovato(String query) {
    return 'No items found for \"$query\".';
  }

  @override
  String get fasceCateneScreenBenneAutoscaricanti => 'Self-dumping buckets';

  @override
  String get fasceCateneScreenAnagrafica => 'Details';

  @override
  String get fasceCateneScreenNumeroSerie => 'Serial no.';

  @override
  String get fasceCateneScreenUbicazione => 'Location';

  @override
  String get fasceCateneScreenVerificaConEsito => 'Inspection outcome';

  @override
  String get fasceCateneScreenEsitoNegativoLower => 'failed';

  @override
  String get fasceCateneScreenEsitoPositivoLower => 'passed';

  @override
  String get fasceCateneScreenTipo => 'Type';

  @override
  String get fasceCateneScreenCricchetto => 'Ratchet';

  @override
  String get fasceCateneScreenIdInterno => 'Internal ID';

  @override
  String get fasceCateneScreenNumeroSerieProduttore =>
      'Manufacturer serial no.';

  @override
  String get fasceCateneScreenColore => 'Color';

  @override
  String get fasceCateneScreenCaratteristiche => 'Specifications';

  @override
  String get fasceCateneScreenPortataKg => 'Capacity (kg)';

  @override
  String get fasceCateneScreenSpessoreMm => 'Thickness (mm)';

  @override
  String get fasceCateneScreenDiametroMm => 'Diameter (mm)';

  @override
  String get fasceCateneScreenLarghezzaMm => 'Width (mm)';

  @override
  String get fasceCateneScreenLunghezzaM => 'Length (m)';

  @override
  String get fasceCateneScreenUbicazioneEAcquisto => 'Location and purchase';

  @override
  String get fasceCateneScreenDataAcquisto => 'Purchase date';

  @override
  String get fasceCateneScreenLuogoAcquisto => 'Place of purchase';

  @override
  String get fasceCateneScreenVerificaInterna => 'Internal inspection';

  @override
  String get fasceCateneScreenUltimaVerifica => 'Last inspection';

  @override
  String get fasceCateneScreenEsito => 'Outcome';

  @override
  String get fasceCateneScreenProssimaVerifica => 'Next inspection';

  @override
  String get fasceCateneScreenEliminareFasciaCatenaTitle =>
      'Delete this sling/chain?';

  @override
  String get fasceCateneScreenEliminareBennaTitle => 'Delete this bucket?';

  @override
  String fasceCateneScreenConfirmDeleteMessage(String nome) {
    return 'Delete \"$nome\"? This action cannot be undone.';
  }

  @override
  String get fasceCateneScreenNascondiInfo => 'Hide details';

  @override
  String get fasceCateneScreenMostraInfo => 'Show details';

  @override
  String get fasceCateneScreenDescrizione => 'Description';

  @override
  String get fasceCateneScreenCapacitaCarico => 'Load capacity';

  @override
  String get fasceCateneScreenIngrandisciFoto => 'Enlarge photo';

  @override
  String get fasceCateneScreenImmagineNonDisponibile => 'Image not available';

  @override
  String fasceCateneScreenBennaTitolo(String idInterno) {
    return '$idInterno - Bucket';
  }

  @override
  String get scaleScreenCodice => 'Code';

  @override
  String get scaleScreenMateriale => 'Material';

  @override
  String get scaleScreenDescrizione => 'Description';

  @override
  String get scaleScreenUbicazione => 'Location';

  @override
  String get scaleScreenUltimaVerifica => 'Last inspection';

  @override
  String get scaleScreenProssimaVerifica => 'Next inspection';

  @override
  String get scaleScreenInMagazzino => 'In warehouse';

  @override
  String scaleScreenInCantiere(String nome) {
    return 'At site $nome';
  }

  @override
  String get scaleScreenNonSpecificata => 'Not specified';

  @override
  String get scaleScreenTitle => 'Ladders';

  @override
  String scaleScreenPdfCount(int count) {
    return '$count ladders';
  }

  @override
  String scaleScreenPdfFiltro(String filtro) {
    return 'search filter: \"$filtro\"';
  }

  @override
  String scaleScreenStampaErrore(String dettagli) {
    return 'Could not generate the printout: $dettagli';
  }

  @override
  String get scaleScreenNuovaScala => 'New ladder';

  @override
  String get scaleScreenStampa => 'Print';

  @override
  String get scaleScreenScadenzeImminenti => 'Upcoming deadlines';

  @override
  String get scaleScreenNascondiScadenze => 'Hide deadlines';

  @override
  String get scaleScreenMostraScadenze => 'Show deadlines';

  @override
  String get scaleScreenPresenti => 'Ladders on record';

  @override
  String get scaleScreenNascondiTutti => 'Collapse all';

  @override
  String get scaleScreenMostraTutti => 'Expand all';

  @override
  String get scaleScreenSearchHint => 'Search by code, material or location';

  @override
  String get scaleScreenNessunElementoCaricato => 'No items loaded.';

  @override
  String scaleScreenNessunElementoTrovato(String query) {
    return 'No items found for \"$query\".';
  }

  @override
  String get scaleScreenCodiceScala => 'Ladder code';

  @override
  String get scaleScreenNotaScadenza => 'Deadline note';

  @override
  String get scaleScreenModificaNota => 'Edit note';

  @override
  String get scaleScreenEliminaScala => 'Delete ladder';

  @override
  String get scaleScreenEliminareScalaTitle => 'Delete ladder?';

  @override
  String scaleScreenConfirmDeleteMessage(String codice) {
    return 'Delete \"$codice\"? This action cannot be undone.';
  }

  @override
  String get scaleScreenNascondiInfo => 'Hide details';

  @override
  String get scaleScreenMostraInfo => 'Show details';

  @override
  String get scaleScreenAnagrafica => 'Details';

  @override
  String get scaleScreenControlli => 'Inspections';

  @override
  String bennaFormDialogEstensioneNonAmmessa(String estensione) {
    return 'File type not allowed (.$estensione)';
  }

  @override
  String get bennaFormDialogImmagineTroppoGrande =>
      'Image too large (max 5 MB)';

  @override
  String get bennaFormDialogModificaTitle => 'Edit bucket';

  @override
  String get bennaFormDialogNuovaTitle => 'New bucket';

  @override
  String get bennaFormDialogAnagrafica => 'Details';

  @override
  String get bennaFormDialogIdInterno => 'Internal ID*';

  @override
  String get bennaFormDialogDescrizione => 'Description';

  @override
  String get bennaFormDialogNumeroSerieProduttore =>
      'Manufacturer serial number';

  @override
  String get bennaFormDialogCapacitaCaricoLt => 'Load capacity (L)';

  @override
  String get bennaFormDialogUbicazione => 'Location';

  @override
  String get bennaFormDialogTipoUbicazione => 'Location type';

  @override
  String get bennaFormDialogNonSpecificata => 'Not specified';

  @override
  String get bennaFormDialogMagazzino => 'Warehouse';

  @override
  String get bennaFormDialogCantiere => 'Construction site';

  @override
  String get bennaFormDialogSelezionaCantiere => 'Select a construction site';

  @override
  String get bennaFormDialogAcquisto => 'Purchase';

  @override
  String get bennaFormDialogDataAcquisto => 'Purchase date';

  @override
  String get bennaFormDialogVerificaInterna => 'Internal inspection';

  @override
  String get bennaFormDialogUltimaVerificaInterna => 'Last internal inspection';

  @override
  String get bennaFormDialogProssimaVerifica => 'Next inspection';

  @override
  String get bennaFormDialogEsitoVerificaPositivo => 'Inspection passed';

  @override
  String get bennaFormDialogIdoneaUso => 'Fit for use';

  @override
  String get bennaFormDialogNonIdonea =>
      'Not fit for use: must be taken out of service';

  @override
  String get bennaFormDialogFoto => 'Photo';

  @override
  String get bennaFormDialogCambiaFoto => 'Change photo';

  @override
  String get bennaFormDialogSfoglia => 'Browse';

  @override
  String get bennaFormDialogRimuovi => 'Remove';

  @override
  String get bennaFormDialogNoteAggiuntive => 'Additional notes';

  @override
  String get bennaFormDialogImmagineNonDisponibile => 'Image not available';

  @override
  String get bennaFormDialogTrascinaFoto => 'Drag the bucket\'s photo here';

  @override
  String get bennaFormDialogFormatiAmmessi => 'JPG, PNG or WEBP - max 5 MB';

  @override
  String get scadenzaCantiereFormDialogNomeScadenzaTitle => 'Deadline name';

  @override
  String get scadenzaCantiereFormDialogNomeScadenzaHint =>
      'E.g. Scaffolding, Crane, Fencing...';

  @override
  String get scadenzaCantiereFormDialogContinua => 'Continue';

  @override
  String get scadenzaCantiereFormDialogTitle =>
      'Construction site general deadlines';

  @override
  String get scadenzaCantiereFormDialogScadenzaMessaTerra =>
      'Grounding system deadline';

  @override
  String get scadenzaCantiereFormDialogRimuoviMessaTerra =>
      'Remove grounding system deadline';

  @override
  String get scadenzaCantiereFormDialogAggiungiMessaTerra =>
      'Add grounding system deadline';

  @override
  String scadenzaCantiereFormDialogScadenzaGenerica(int numero) {
    return 'Generic deadline $numero';
  }

  @override
  String get scadenzaCantiereFormDialogRimuoviQuesta => 'Remove this deadline';

  @override
  String get scadenzaCantiereFormDialogAggiungiGenerica =>
      'Add generic deadline';

  @override
  String get tipiScadenzeScreenTitle => 'Deadline Types';

  @override
  String get tipiScadenzeScreenNuovaTipologia => 'New type';

  @override
  String get tipiScadenzeScreenSearchHint => 'Search by type';

  @override
  String get tipiScadenzeScreenNessunaTipologiaCaricata => 'No types loaded.';

  @override
  String tipiScadenzeScreenNessunaTipologiaTrovata(String query) {
    return 'No types found for \"$query\".';
  }

  @override
  String get tipiScadenzeScreenRichiedeScadenza => 'Requires a deadline';

  @override
  String get tipiScadenzeScreenAvviso => 'Alert';

  @override
  String get tipiScadenzeScreenAvvisoDalGiorno =>
      'from the day after the deadline';

  @override
  String get tipiScadenzeScreenPreavviso => 'Advance notice';

  @override
  String tipiScadenzeScreenGiorniPreavviso(String giorni) {
    return '$giorni days';
  }

  @override
  String get tipiScadenzeScreenCollegatoA => 'Linked to';

  @override
  String get tipiScadenzeScreenModificaTipologia => 'Edit type';

  @override
  String get tipiScadenzeScreenEliminaTipologia => 'Delete type';

  @override
  String get tipiScadenzeScreenEliminareTitle => 'Delete this type?';

  @override
  String tipiScadenzeScreenEliminareMessage(String nome) {
    return 'Delete the deadline type $nome? This action cannot be undone.';
  }

  @override
  String get tipiScadenzeScreenCantiere => 'Construction site';

  @override
  String get tipiScadenzeScreenSubappaltatore => 'Subcontractor';

  @override
  String get tipiScadenzeScreenDipendenteSubappaltatore =>
      'Subcontractor employee';

  @override
  String get tipiScadenzeScreenDipendenteSubappaltatoreAutonomo =>
      'Subcontractor employee (and self-employed workers)';

  @override
  String get tipiScadenzeScreenLavoratoreAutonomo => 'Self-employed worker';

  @override
  String tipiScadenzeScreenElencoFinale(String a, String b) {
    return '$a and $b';
  }

  @override
  String get dipendenteSubappaltatoreDetailScreenCantieri =>
      'Construction Sites';

  @override
  String get dipendenteSubappaltatoreDetailScreenSubappaltatori =>
      'Subcontractors';

  @override
  String get dipendenteSubappaltatoreDetailScreenDipendentiAziendali =>
      'Company Employees';

  @override
  String get dipendenteSubappaltatoreDetailScreenInformazioni => 'Information:';

  @override
  String get dipendenteSubappaltatoreDetailScreenTipo => 'Type';

  @override
  String get dipendenteSubappaltatoreDetailScreenLavoratoreAutonomo =>
      'Self-employed worker';

  @override
  String get dipendenteSubappaltatoreDetailScreenNessunCantiere =>
      'The subcontractor is not assigned to any construction site.';

  @override
  String get dipendenteSubappaltatoreDetailScreenScadenzeDocumenti =>
      'Document and certification deadlines';

  @override
  String get dipendenteSubappaltatoreDetailScreenAggiungiScadenza =>
      'Add deadline';

  @override
  String get dipendenteSubappaltatoreDetailScreenNessunaScadenza =>
      'No deadlines recorded for this employee.';

  @override
  String get dipendenteSubappaltatoreFormDialogNuovo => 'New employee';

  @override
  String get dipendenteSubappaltatoreFormDialogModifica => 'Edit employee';

  @override
  String get dipendenteSubappaltatoreFormDialogNome => 'First name*';

  @override
  String get dipendenteSubappaltatoreFormDialogCognome => 'Last name*';

  @override
  String get dipendenteSubappaltatoreFormDialogNoteHelper =>
      'Shown in the \"Information\" box of the employee\'s page';

  @override
  String get dipendenteSubappaltatoreFormDialogLavoratoreAutonomo =>
      'Self-employed worker';

  @override
  String get dipendenteSubappaltatoreFormDialogLavoratoreAutonomoSubtitle =>
      'In addition to the employee\'s deadlines, can also record those reserved for self-employed workers';

  @override
  String modificaScadenzaDocumentoDialogModificaTipo(String tipo) {
    return 'Edit $tipo';
  }

  @override
  String get modificaScadenzaDocumentoDialogModificaScadenza => 'Edit deadline';

  @override
  String get modificaScadenzaDocumentoDialogDataScadenza => 'Deadline date';

  @override
  String notaMisuraDialogTitle(String nome, String tipo) {
    return 'Note — $nome — $tipo';
  }

  @override
  String notaScadenzaGeneraleDialogTitle(String nome) {
    return 'Note — $nome';
  }

  @override
  String dipendentiPresentiDialogTitle(String nome) {
    return 'Employees on site — $nome';
  }

  @override
  String get dipendentiPresentiDialogNessunDipendente =>
      'No employees registered for this subcontractor.';

  @override
  String dipendentiPresentiDialogNote(String note) {
    return 'Notes: $note';
  }

  @override
  String get primoSoccorsoScreenTitle => 'First Aid';

  @override
  String get primoSoccorsoScreenStandardProductsLabel => 'Standard products';

  @override
  String get primoSoccorsoScreenNewItemLabel => 'New item';

  @override
  String get primoSoccorsoScreenUpcomingDeadlines => 'Upcoming deadlines';

  @override
  String get primoSoccorsoScreenHideDeadlinesTooltip => 'Hide deadlines';

  @override
  String get primoSoccorsoScreenShowDeadlinesTooltip => 'Show deadlines';

  @override
  String get primoSoccorsoScreenSectionTitle => 'First aid kits and packs';

  @override
  String get primoSoccorsoScreenHideAllTooltip => 'Hide all';

  @override
  String get primoSoccorsoScreenShowAllTooltip => 'Show all';

  @override
  String get primoSoccorsoScreenSearchHint =>
      'Search by number, location, or type';

  @override
  String get primoSoccorsoScreenNoItemsLoaded => 'No items loaded.';

  @override
  String primoSoccorsoScreenNoItemsFound(String query) {
    return 'No items found for \"$query\".';
  }

  @override
  String get primoSoccorsoScreenArticleLabel => 'Item';

  @override
  String get primoSoccorsoScreenLocationLabel => 'Location';

  @override
  String get primoSoccorsoScreenDeadlineNoteLabel => 'Deadline note';

  @override
  String get primoSoccorsoScreenEditNoteTooltip => 'Edit note';

  @override
  String get primoSoccorsoScreenEditItemTooltip => 'Edit item';

  @override
  String get primoSoccorsoScreenDeleteItemTooltip => 'Delete item';

  @override
  String get primoSoccorsoScreenDeleteConfirmTitle => 'Delete item?';

  @override
  String primoSoccorsoScreenDeleteConfirmMessage(String numero) {
    return 'Delete \"$numero\"? This action cannot be undone.';
  }

  @override
  String get primoSoccorsoScreenHideInfoTooltip => 'Hide info';

  @override
  String get primoSoccorsoScreenShowInfoTooltip => 'Show info';

  @override
  String get primoSoccorsoScreenChecksSectionTitle => 'Checks and deadlines';

  @override
  String get primoSoccorsoScreenLastCheckLabel => 'Last check';

  @override
  String get primoSoccorsoScreenNextCheckLabel => 'Next check';

  @override
  String get primoSoccorsoScreenNextProductDeadlineLabel =>
      'Next product expiry';

  @override
  String primoSoccorsoScreenNotaDialogTitle(String titolo) {
    return 'Note — $titolo';
  }

  @override
  String get primoSoccorsoScreenNextCheckType => 'Next check';

  @override
  String primoSoccorsoScreenProductDeadlineType(String nomeProdotto) {
    return '$nomeProdotto expiry';
  }

  @override
  String get primoSoccorsoScreenLocationWarehouse => 'At the warehouse';

  @override
  String get primoSoccorsoScreenLocationOffice => 'At the office';

  @override
  String primoSoccorsoScreenLocationSite(String nome) {
    return 'At site $nome';
  }

  @override
  String primoSoccorsoScreenLocationVehicle(String nome) {
    return 'On vehicle $nome';
  }

  @override
  String get primoSoccorsoScreenLocationUnspecified => 'Not specified';

  @override
  String get impiantiScreenPdfOffice => 'Office';

  @override
  String get impiantiScreenPdfWarehouse => 'Warehouse';

  @override
  String get impiantiScreenPdfUnspecified => 'Not specified';

  @override
  String get impiantiScreenColType => 'Type';

  @override
  String get impiantiScreenColLocation => 'Location';

  @override
  String get impiantiScreenColInstallerCompany => 'Installer company';

  @override
  String get impiantiScreenColInstallDate => 'Installation date';

  @override
  String get impiantiScreenColAssessmentDate => 'Assessment date';

  @override
  String get impiantiScreenColInternalMaintDate => 'Internal maint. date';

  @override
  String get impiantiScreenColInternalMaintDeadline =>
      'Internal maint. deadline';

  @override
  String get impiantiScreenColInternalCheckType => 'Internal check type';

  @override
  String get impiantiScreenColExternalMaintDate => 'External maint. date';

  @override
  String get impiantiScreenColExternalMaintDeadline =>
      'External maint. deadline';

  @override
  String get impiantiScreenColExternalCheckType => 'External check type';

  @override
  String get impiantiScreenColLightningAssessmentDeadline =>
      'Lightning protection assessment deadline';

  @override
  String get impiantiScreenInternalMaintenanceDeadlineType =>
      'Internal maintenance deadline';

  @override
  String get impiantiScreenExternalMaintenanceDeadlineType =>
      'External maintenance deadline';

  @override
  String get impiantiScreenTitle => 'Systems';

  @override
  String impiantiScreenPdfSubtitleCount(int count) {
    return '$count systems';
  }

  @override
  String impiantiScreenPdfSubtitleFilter(String filtro) {
    return 'search filter: \"$filtro\"';
  }

  @override
  String impiantiScreenPrintErrorMessage(String details) {
    return 'Unable to generate the printout: $details';
  }

  @override
  String get impiantiScreenNewSystemLabel => 'New system';

  @override
  String get impiantiScreenPrintLabel => 'Print';

  @override
  String get impiantiScreenUpcomingDeadlines => 'Upcoming deadlines';

  @override
  String get impiantiScreenHideDeadlinesTooltip => 'Hide deadlines';

  @override
  String get impiantiScreenShowDeadlinesTooltip => 'Show deadlines';

  @override
  String get impiantiScreenActiveSystemsTitle => 'Active systems';

  @override
  String get impiantiScreenCollapseAllTooltip => 'Collapse all';

  @override
  String get impiantiScreenExpandAllTooltip => 'Expand all';

  @override
  String get impiantiScreenSearchHint => 'Search by name';

  @override
  String get impiantiScreenNoItemsLoaded => 'No systems loaded.';

  @override
  String impiantiScreenNoItemsFound(String query) {
    return 'No systems found for \"$query\".';
  }

  @override
  String get impiantiScreenLocationOfficeLower => 'at the office';

  @override
  String get impiantiScreenLocationWarehouseLower => 'at the warehouse';

  @override
  String get impiantiScreenLocationUnspecifiedLower => 'not specified';

  @override
  String get impiantiScreenDeadlineNoteLabel => 'Deadline note';

  @override
  String get impiantiScreenEditNoteTooltip => 'Edit note';

  @override
  String get impiantiScreenEditSystemTooltip => 'Edit system';

  @override
  String get impiantiScreenDeleteSystemTooltip => 'Delete system';

  @override
  String get impiantiScreenDeleteConfirmTitle => 'Delete system?';

  @override
  String impiantiScreenDeleteConfirmMessage(String tipologia) {
    return 'Delete \"$tipologia\"? This action cannot be undone.';
  }

  @override
  String get impiantiScreenHideInfoTooltip => 'Hide info';

  @override
  String get impiantiScreenShowInfoTooltip => 'Show info';

  @override
  String get impiantiScreenInstallationSectionTitle => 'Installation';

  @override
  String get impiantiScreenInstallerCompanyLabel => 'Installer company';

  @override
  String get impiantiScreenInstallDateLabel => 'Installation date';

  @override
  String get impiantiScreenAssessmentDateLabel => 'Assessment date';

  @override
  String get impiantiScreenInternalMaintenanceSectionTitle =>
      'Internal maintenance';

  @override
  String get impiantiScreenInternalMaintDateLabel =>
      'Internal maintenance date';

  @override
  String get impiantiScreenInternalMaintDeadlineLabel =>
      'Internal maintenance deadline';

  @override
  String get impiantiScreenCheckTypeLabel => 'Check type';

  @override
  String get impiantiScreenExternalMaintenanceSectionTitle =>
      'External maintenance';

  @override
  String get impiantiScreenExternalMaintDateLabel =>
      'External maintenance date';

  @override
  String get impiantiScreenExternalMaintDeadlineLabel =>
      'External maintenance deadline';

  @override
  String get impiantiScreenLightningSectionTitle => 'Lightning protection';

  @override
  String get impiantiScreenLightningAssessmentDeadlineLabel =>
      'Lightning protection assessment deadline';

  @override
  String get impiantiScreenAdditionalNotesSectionTitle => 'Additional notes';

  @override
  String get macchinarioFormDialogOwnershipOwned => 'Owned';

  @override
  String get macchinarioFormDialogOwnershipRented => 'Rented';

  @override
  String get macchinarioFormDialogOwnershipLeased => 'Leased';

  @override
  String get macchinarioFormDialogNewTitle => 'New machinery';

  @override
  String get macchinarioFormDialogEditTitle => 'Edit machinery';

  @override
  String get macchinarioFormDialogModelLabel => 'Model*';

  @override
  String get macchinarioFormDialogSerialNumberLabel => 'Serial number';

  @override
  String get macchinarioFormDialogFactoryNumberLabel => 'Factory number';

  @override
  String get macchinarioFormDialogPurchaseYearLabel => 'Purchase year';

  @override
  String get macchinarioFormDialogTypeLabel => 'Type';

  @override
  String get macchinarioFormDialogUnspecifiedOption => 'Not specified';

  @override
  String get macchinarioFormDialogOwnershipLabel => 'Ownership';

  @override
  String get macchinarioFormDialogLeasingCompanyLabel => 'Leasing company';

  @override
  String get macchinarioFormDialogLeasingDeadlineLabel => 'Leasing deadline';

  @override
  String get macchinarioFormDialogRentalCompanyLabel => 'Rental company';

  @override
  String get macchinarioFormDialogRentalEmailLabel => 'Rental company email';

  @override
  String get macchinarioFormDialogInvalidEmailValidator =>
      'Enter a valid email';

  @override
  String get macchinarioFormDialogCivaInailLabel => 'Listed in CIVA/INAIL';

  @override
  String get macchinarioFormDialogInUseLabel => 'In use?';

  @override
  String get macchinarioFormDialogLocationSectionTitle => 'Location';

  @override
  String get macchinarioFormDialogLocationTypeLabel => 'Location type';

  @override
  String get macchinarioFormDialogLocationWarehouse => 'Warehouse';

  @override
  String get macchinarioFormDialogLocationSite => 'Construction site';

  @override
  String get macchinarioFormDialogLocationVehicle => 'Vehicle';

  @override
  String get macchinarioFormDialogSiteValidator => 'Select a construction site';

  @override
  String get macchinarioFormDialogVehicleValidator => 'Select a vehicle';

  @override
  String get macchinarioFormDialogInsuranceCompanyLabel => 'Insurance company';

  @override
  String get macchinarioFormDialogInsuranceDeadlineLabel =>
      'Insurance deadline';

  @override
  String get macchinarioFormDialogRemoveInsuranceDeadlineTooltip =>
      'Remove insurance deadline';

  @override
  String get macchinarioFormDialogAddInsuranceDeadlineLabel =>
      'Add insurance deadline';

  @override
  String get macchinarioFormDialogInternalMaintenanceSectionTitle =>
      'Internal maintenance';

  @override
  String get macchinarioFormDialogInterventionDateLabel => 'Intervention date';

  @override
  String get macchinarioFormDialogDeadlineLabel => 'Deadline';

  @override
  String get macchinarioFormDialogRopeChainCheckSectionTitle =>
      'Rope/chain check';

  @override
  String get macchinarioFormDialogCheckDateLabel => 'Check date';

  @override
  String get macchinarioFormDialogAnnualCheckSectionTitle =>
      'Annual inspection';

  @override
  String get macchinarioFormDialogInspectionDateLabel => 'Inspection date';

  @override
  String get macchinarioFormDialogTwentyYearCheckSectionTitle =>
      'Twenty-year inspection';

  @override
  String get macchinarioFormDialogAdditionalNotesLabel => 'Additional notes';

  @override
  String get scaffalatureScreenNextCheckType => 'Next shelving check';

  @override
  String get scaffalatureScreenTitle => 'Shelving';

  @override
  String get scaffalatureScreenAddLabel => 'Add shelving unit';

  @override
  String get scaffalatureScreenUpcomingDeadlines => 'Upcoming deadlines';

  @override
  String get scaffalatureScreenHideDeadlinesTooltip => 'Hide deadlines';

  @override
  String get scaffalatureScreenShowDeadlinesTooltip => 'Show deadlines';

  @override
  String get scaffalatureScreenSectionTitle => 'Shelving units on record';

  @override
  String get scaffalatureScreenHideAllTooltip => 'Hide all';

  @override
  String get scaffalatureScreenShowAllTooltip => 'Show all';

  @override
  String get scaffalatureScreenNoItemsLoaded => 'No items loaded.';

  @override
  String get scaffalatureScreenIdLabel => 'Shelving ID';

  @override
  String get scaffalatureScreenLastCheckLabel => 'Last check';

  @override
  String get scaffalatureScreenDeadlineNoteLabel => 'Deadline note';

  @override
  String get scaffalatureScreenEditNoteTooltip => 'Edit note';

  @override
  String scaffalatureScreenCardTitle(String id) {
    return 'Shelving unit #$id';
  }

  @override
  String get scaffalatureScreenNextCheckLabel => 'Next check';

  @override
  String get scaffalatureScreenDeleteTooltip => 'Delete shelving unit';

  @override
  String get scaffalatureScreenDeleteConfirmTitle => 'Delete shelving unit?';

  @override
  String scaffalatureScreenDeleteConfirmMessage(String id) {
    return 'Delete shelving unit #$id? This action cannot be undone.';
  }

  @override
  String get scaffalatureScreenHideInfoTooltip => 'Hide info';

  @override
  String get scaffalatureScreenShowInfoTooltip => 'Show info';

  @override
  String get scaffalatureScreenChecksSectionTitle => 'Checks';

  @override
  String get scaffalatureScreenOutcomeLabel => 'Outcome';

  @override
  String get scaffalatureScreenOutcomePositive => 'Passed';

  @override
  String get scaffalatureScreenOutcomeNegative => 'Failed';

  @override
  String get impiantiFormDialogNewTitle => 'New system';

  @override
  String get impiantiFormDialogEditTitle => 'Edit system';

  @override
  String get impiantiFormDialogTypeLabel => 'Type*';

  @override
  String get impiantiFormDialogLocationTypeLabel => 'Location type';

  @override
  String get impiantiFormDialogUnspecifiedOption => 'Not specified';

  @override
  String get impiantiFormDialogLocationWarehouse => 'Warehouse';

  @override
  String get impiantiFormDialogLocationOffice => 'Office';

  @override
  String get impiantiFormDialogInstallationSectionTitle => 'Installation';

  @override
  String get impiantiFormDialogInstallDateLabel => 'Installation date';

  @override
  String get impiantiFormDialogInstallerCompanyLabel => 'Installer company';

  @override
  String get impiantiFormDialogAssessmentDateLabel => 'Assessment date';

  @override
  String get impiantiFormDialogInternalMaintenanceSectionTitle =>
      'Internal maintenance';

  @override
  String get impiantiFormDialogInternalMaintDateLabel =>
      'Internal maintenance date';

  @override
  String get impiantiFormDialogInternalMaintDeadlineLabel =>
      'Internal maintenance deadline';

  @override
  String get impiantiFormDialogInternalCheckTypeLabel => 'Internal check type';

  @override
  String get impiantiFormDialogExternalMaintenanceSectionTitle =>
      'External maintenance';

  @override
  String get impiantiFormDialogExternalMaintDateLabel =>
      'External maintenance date';

  @override
  String get impiantiFormDialogExternalMaintDeadlineLabel =>
      'External maintenance deadline';

  @override
  String get impiantiFormDialogExternalCheckTypeLabel => 'External check type';

  @override
  String get impiantiFormDialogLightningSectionTitle => 'Lightning protection';

  @override
  String get impiantiFormDialogLightningAssessmentDeadlineLabel =>
      'Lightning protection assessment deadline';

  @override
  String get impiantiFormDialogRemoveLightningAssessmentTooltip =>
      'Remove lightning protection assessment';

  @override
  String get impiantiFormDialogAddLightningAssessmentLabel =>
      'Add lightning protection assessment deadline';

  @override
  String get impiantiFormDialogAdditionalNotesLabel => 'Additional notes';

  @override
  String get documentFormDialogDeadlineRequiredError =>
      'This document type requires a deadline date';

  @override
  String get documentFormDialogTitle => 'New deadline';

  @override
  String get documentFormDialogSectionTitle => 'Document';

  @override
  String get documentFormDialogTypeLabel => 'Document type';

  @override
  String get documentFormDialogTypeValidator => 'Select a type';

  @override
  String get documentFormDialogDeadlineDateLabel => 'Deadline date';

  @override
  String get documentFormDialogDeadlineDateOptionalLabel =>
      'Deadline date (optional)';

  @override
  String get documentFormDialogInfoText =>
      'The document itself is kept on file: this only records the deadline, so reminders can be sent by email.';

  @override
  String get cantiereFormDialogNewTitle => 'New construction site';

  @override
  String get cantiereFormDialogEditTitle => 'Edit construction site';

  @override
  String get cantiereFormDialogInfoSectionTitle => 'Site details';

  @override
  String get cantiereFormDialogNameLabel => 'Name*';

  @override
  String get cantiereFormDialogAddressLabel => 'Address*';

  @override
  String get cantiereFormDialogTownLabel => 'Town';

  @override
  String get cantiereFormDialogPostalCodeLabel => 'Postal code';

  @override
  String get cantiereFormDialogStatusSectionTitle => 'Site status';

  @override
  String get cantiereFormDialogStatusLabel => 'Status';

  @override
  String get cantiereFormDialogStatusInProgress => 'In progress';

  @override
  String get cantiereFormDialogStatusCompleted => 'Completed';

  @override
  String get cantiereFormDialogStatusSuspended => 'Suspended';

  @override
  String get cantiereFormDialogStartDateLabel => 'Start date';

  @override
  String get cantiereFormDialogSuspensionDateLabel => 'Suspension date';

  @override
  String get cantiereFormDialogCompletionDateLabel => 'Completion date';

  @override
  String get scadenzaGeneraleFormDialogNewTitle => 'New deadline';

  @override
  String get scadenzaGeneraleFormDialogEditTitle => 'Edit deadline';

  @override
  String get scadenzaGeneraleFormDialogNameLabel => 'Name';

  @override
  String get scadenzaGeneraleFormDialogDeadlineLabel => 'Deadline';

  @override
  String get scadenzaGeneraleFormDialogNoticeDaysLabel => 'Notice days';

  @override
  String get scadenzaGeneraleFormDialogAdditionalNotesLabel =>
      'Additional notes';

  @override
  String get sospendiSollecitiDialogTitle => 'Suspend reminders';

  @override
  String get sospendiSollecitiDialogDescription1 =>
      'While suspended, items that are already overdue will no longer be re-flagged every day, either to us or to subcontractors and rental companies.';

  @override
  String get sospendiSollecitiDialogDescription2 =>
      'Advance-notice emails will keep arriving as usual: anything that comes due during the shutdown is still reported, just once.';

  @override
  String get sospendiSollecitiDialogUntilLabel => 'Suspend until (inclusive)';

  @override
  String get sospendiSollecitiDialogInvalidDateMessage =>
      'The date must be today or later.';

  @override
  String sospendiSollecitiDialogSetByMessage(String impostataDa) {
    return 'Suspension set by $impostataDa.';
  }

  @override
  String get sospendiSollecitiDialogReactivateNowLabel => 'Reactivate now';

  @override
  String get sospendiSollecitiDialogUpdateLabel => 'Update';

  @override
  String get sospendiSollecitiDialogSuspendLabel => 'Suspend';

  @override
  String notaImpiantoDialogTitle(String tipologia, String tipo) {
    return 'Note — $tipologia — $tipo';
  }

  @override
  String notaScadenzaFasciaCatenaDialogTitle(String id) {
    return 'Note — $id';
  }

  @override
  String showArticoliDialogTitle(String tipologia, String numero) {
    return 'Items — $tipologia #$numero';
  }

  @override
  String get showArticoliDialogEmptyMessage => 'No products added.';

  @override
  String showArticoliDialogQuantityLine(String quantita) {
    return 'Quantity: $quantita';
  }

  @override
  String showArticoliDialogDeadlineLine(String data) {
    return 'Expiry: $data';
  }

  @override
  String showArticoliDialogNoteLine(String note) {
    return 'Notes: $note';
  }

  @override
  String showArticoliDialogDeadlineNoteLine(String nota) {
    return 'Note: $nota';
  }

  @override
  String get estintoriScreenTitle => 'Fire Extinguishers';

  @override
  String get estintoriScreenNewButton => 'New fire extinguisher';

  @override
  String get estintoriScreenPrintAction => 'Print';

  @override
  String estintoriScreenPrintError(String details) {
    return 'Could not generate the printout: $details';
  }

  @override
  String get estintoriScreenUpcomingDeadlines => 'Upcoming deadlines';

  @override
  String get estintoriScreenHideDeadlines => 'Hide deadlines';

  @override
  String get estintoriScreenShowDeadlines => 'Show deadlines';

  @override
  String get estintoriScreenSectionTitle => 'Fire extinguishers on record';

  @override
  String get estintoriScreenCollapseAll => 'Collapse all';

  @override
  String get estintoriScreenExpandAll => 'Expand all';

  @override
  String get estintoriScreenSearchHint => 'Search by serial number or location';

  @override
  String get estintoriScreenEmptyNone => 'No fire extinguishers loaded.';

  @override
  String estintoriScreenEmptySearch(String query) {
    return 'No fire extinguisher found for \"$query\".';
  }

  @override
  String get estintoriScreenLabelMatricola => 'Serial number';

  @override
  String get estintoriScreenLabelUbicazione => 'Location';

  @override
  String get estintoriScreenLabelNotaScadenza => 'Deadline note';

  @override
  String get estintoriScreenEditNoteTooltip => 'Edit note';

  @override
  String get estintoriScreenEditTooltip => 'Edit fire extinguisher';

  @override
  String get estintoriScreenDeleteTooltip => 'Delete fire extinguisher';

  @override
  String get estintoriScreenDeleteConfirmTitle => 'Delete fire extinguisher?';

  @override
  String estintoriScreenDeleteConfirmMessage(String matricola) {
    return 'Delete \"$matricola\"? This action cannot be undone.';
  }

  @override
  String get estintoriScreenHideInfo => 'Hide details';

  @override
  String get estintoriScreenShowInfo => 'Show details';

  @override
  String get estintoriScreenSectionGeneralData => 'General data';

  @override
  String get estintoriScreenLabelCapacita => 'Capacity';

  @override
  String get estintoriScreenLabelTipo => 'Type';

  @override
  String get estintoriScreenLabelDataProduzione => 'Manufacture date';

  @override
  String get estintoriScreenLabelDataMessaInServizio => 'Commissioning date';

  @override
  String get estintoriScreenSectionVerificaEsterna => 'External Inspection';

  @override
  String get estintoriScreenLabelDataVerificaEsterna =>
      'External inspection date';

  @override
  String get estintoriScreenLabelScadenzaVerificaEsterna =>
      'External inspection due date';

  @override
  String get estintoriScreenSectionRevisione => 'Servicing';

  @override
  String get estintoriScreenLabelDataUltimaRevisione => 'Last servicing date';

  @override
  String get estintoriScreenLabelScadenzaRevisione => 'Servicing due date';

  @override
  String get estintoriScreenSectionCollaudo => 'Testing';

  @override
  String get estintoriScreenLabelDataCollaudo => 'Testing date';

  @override
  String get estintoriScreenLabelScadenzaCollaudo => 'Testing due date';

  @override
  String get estintoriScreenTipoScadenzaCollaudo => 'Testing Due Date';

  @override
  String get estintoriScreenTipoScadenzaRevisione => 'Servicing Due Date';

  @override
  String get estintoriScreenTipoScadenzaVerificaEsterna =>
      'External Inspection Due Date';

  @override
  String get estintoriScreenTipoSostituzione => 'Replacement (18 years)';

  @override
  String get estintoriScreenLocationWarehouse => 'In warehouse';

  @override
  String get estintoriScreenLocationOffice => 'In office';

  @override
  String estintoriScreenLocationSite(String nome) {
    return 'At site $nome';
  }

  @override
  String estintoriScreenLocationVehicle(String veicolo) {
    return 'On vehicle $veicolo';
  }

  @override
  String get estintoriScreenLocationUnspecified => 'Not specified';

  @override
  String estintoriScreenPdfCount(int count) {
    return '$count fire extinguishers';
  }

  @override
  String estintoriScreenPdfFilter(String filtro) {
    return 'search filter: \"$filtro\"';
  }

  @override
  String get estintoriScreenPdfColMatricola => 'Serial No.';

  @override
  String get estintoriScreenPdfColDataProduzione => 'Production date';

  @override
  String get estintoriScreenPdfColScadVerificaEsterna => 'Ext. inspection due';

  @override
  String get estintoriScreenPdfColDataRevisione => 'Servicing date';

  @override
  String get estintoriScreenPdfColScadRevisione => 'Servicing due';

  @override
  String get estintoriScreenPdfColScadCollaudo => 'Testing due';

  @override
  String get cassettaPsFormDialogTipoCassetta => 'First Aid Kit';

  @override
  String get cassettaPsFormDialogTipoPacchettoMedicazione => 'Dressing Pack';

  @override
  String get cassettaPsFormDialogNotSpecified => 'Not specified';

  @override
  String get cassettaPsFormDialogAddProduct => 'Add product';

  @override
  String get cassettaPsFormDialogNoProducts => 'No products added.';

  @override
  String cassettaPsFormDialogQuantityLabel(String quantita) {
    return 'Quantity: $quantita';
  }

  @override
  String cassettaPsFormDialogExpiryLabel(String data) {
    return 'Expiry: $data';
  }

  @override
  String get cassettaPsFormDialogEditProductTooltip => 'Edit product';

  @override
  String get cassettaPsFormDialogRemoveProductTooltip => 'Remove product';

  @override
  String get cassettaPsFormDialogNewTitle => 'New item';

  @override
  String get cassettaPsFormDialogEditTitle => 'Edit item';

  @override
  String get cassettaPsFormDialogNumberLabel => 'Number*';

  @override
  String get cassettaPsFormDialogTypeLabel => 'Type';

  @override
  String get cassettaPsFormDialogLocationSection => 'Location';

  @override
  String get cassettaPsFormDialogLocationTypeLabel => 'Location type';

  @override
  String get cassettaPsFormDialogLocationWarehouse => 'Warehouse';

  @override
  String get cassettaPsFormDialogLocationOffice => 'Office';

  @override
  String get cassettaPsFormDialogLocationSite => 'Site';

  @override
  String get cassettaPsFormDialogLocationVehicle => 'Vehicle';

  @override
  String get cassettaPsFormDialogSiteLabel => 'Site';

  @override
  String get cassettaPsFormDialogSelectSiteValidator => 'Select a site';

  @override
  String get cassettaPsFormDialogVehicleLabel => 'Vehicle';

  @override
  String get cassettaPsFormDialogSelectVehicleValidator => 'Select a vehicle';

  @override
  String get cassettaPsFormDialogLocationDetailsLabel =>
      'Additional location details';

  @override
  String get cassettaPsFormDialogChecksSection => 'Checks';

  @override
  String get cassettaPsFormDialogLastCheckLabel => 'Last Check';

  @override
  String get cassettaPsFormDialogNextCheckLabel => 'Next Check';

  @override
  String get cassettaPsFormDialogProductsSection => 'Products';

  @override
  String get cassettaPsFormDialogNextProductExpiryTitle =>
      'Next Product Expiry';

  @override
  String get cassettaPsFormDialogNoProductExpiry => 'No product expiry';

  @override
  String get cassettaPsFormDialogNewProductTitle => 'New product';

  @override
  String get cassettaPsFormDialogEditProductTitle => 'Edit product';

  @override
  String get cassettaPsFormDialogProductNameLabel => 'Product name*';

  @override
  String get cassettaPsFormDialogQuantityFieldLabel => 'Quantity';

  @override
  String get cassettaPsFormDialogExpiryFieldLabel => 'Expiry';

  @override
  String get misureScreenTitle => 'Gauges';

  @override
  String get misureScreenNewButton => 'New gauge';

  @override
  String get misureScreenSearchHint => 'Search by name';

  @override
  String get misureScreenEmptyNone => 'No measuring instruments loaded.';

  @override
  String misureScreenEmptySearch(String query) {
    return 'No measuring instrument found for \"$query\".';
  }

  @override
  String get misureScreenUpcomingDeadlines => 'Upcoming deadlines';

  @override
  String get misureScreenHideDeadlines => 'Hide deadlines';

  @override
  String get misureScreenShowDeadlines => 'Show deadlines';

  @override
  String get misureScreenSectionTitle => 'Measuring Instruments';

  @override
  String get misureScreenCollapseAll => 'Collapse all';

  @override
  String get misureScreenExpandAll => 'Expand all';

  @override
  String get misureScreenLabelModello => 'Model';

  @override
  String get misureScreenLabelIncaricato => 'Assigned to';

  @override
  String get misureScreenLabelNotaScadenza => 'Deadline note';

  @override
  String get misureScreenEditNoteTooltip => 'Edit note';

  @override
  String get misureScreenLabelMatricola => 'Serial number';

  @override
  String get misureScreenEditTooltip => 'Edit gauge';

  @override
  String get misureScreenDeleteTooltip => 'Delete gauge';

  @override
  String get misureScreenDeleteConfirmTitle => 'Delete measuring instrument?';

  @override
  String misureScreenDeleteConfirmMessage(String nome) {
    return 'Delete \"$nome\"? This action cannot be undone.';
  }

  @override
  String get misureScreenHideInfo => 'Hide details';

  @override
  String get misureScreenShowInfo => 'Show details';

  @override
  String get misureScreenSectionGeneralData => 'General data';

  @override
  String get misureScreenLabelRifAcq => 'Purchase ref.';

  @override
  String get misureScreenSectionTaraturaInterna => 'Internal Calibration';

  @override
  String get misureScreenLabelDataUltimaTaratura => 'Last calibration date';

  @override
  String get misureScreenLabelDataProssimaTaratura => 'Next calibration date';

  @override
  String get misureScreenSectionTaraturaEsterna => 'External Calibration';

  @override
  String get misureScreenTipoProssimaTaraturaInterna =>
      'Next Internal Calibration';

  @override
  String get misureScreenTipoProssimaTaraturaEsterna =>
      'Next External Calibration';

  @override
  String get subappaltatoreDetailScreenBreadcrumbCantieri =>
      'Construction Sites';

  @override
  String get subappaltatoreDetailScreenInfoSection => 'Information:';

  @override
  String get subappaltatoreDetailScreenVatLabel => 'VAT number';

  @override
  String get subappaltatoreDetailScreenGeneralDeadlinesTitle =>
      'Subcontractor\'s general deadlines';

  @override
  String get subappaltatoreDetailScreenSiteDeadlinesTitle =>
      'Subcontractor deadlines at this site';

  @override
  String get subappaltatoreDetailScreenAddDeadline => 'Add deadline';

  @override
  String get subappaltatoreDetailScreenNoDeadlinesSubappaltatore =>
      'No deadlines recorded for this subcontractor.';

  @override
  String get subappaltatoreDetailScreenEmployeeDeadlinesTitle =>
      'On-site employee deadlines';

  @override
  String get subappaltatoreDetailScreenCollapseAll => 'Collapse all';

  @override
  String get subappaltatoreDetailScreenExpandAll => 'Show all';

  @override
  String get subappaltatoreDetailScreenNoDeadlinesEmployees =>
      'No deadlines recorded for the employees on this site.';

  @override
  String get subappaltatoreDetailScreenDeadlineCountLabel => 'Deadlines loaded';

  @override
  String get subappaltatoreDetailScreenExpiredLabel => 'Overdue';

  @override
  String get subappaltatoreDetailScreenUpcomingLabel => 'Upcoming';

  @override
  String get subappaltatoreDetailScreenAutonomousWorkerLabel =>
      'Self-employed worker';

  @override
  String get subappaltatoreDetailScreenHideDeadlines => 'Hide deadlines';

  @override
  String get subappaltatoreDetailScreenShowDeadlines => 'Show deadlines';

  @override
  String get subappaltatoreDetailScreenOpenEmployeePage => 'Open employee page';

  @override
  String get misureFormDialogNewTitle => 'New gauge';

  @override
  String get misureFormDialogEditTitle => 'Edit gauge';

  @override
  String get misureFormDialogNameLabel => 'Name*';

  @override
  String get misureFormDialogReferenceLabel => 'Reference';

  @override
  String get misureFormDialogSerialLabel => 'Serial number';

  @override
  String get misureFormDialogInternalCalibrationSection =>
      'Internal Calibration';

  @override
  String get misureFormDialogAssignedToLabel => 'Assigned to';

  @override
  String get misureFormDialogNotSpecified => 'Not specified';

  @override
  String get misureFormDialogLastCalibrationLabel => 'Last calibration date';

  @override
  String get misureFormDialogNextCalibrationLabel => 'Next calibration date';

  @override
  String get misureFormDialogExternalCalibrationSection =>
      'External Calibration';

  @override
  String get misureFormDialogExternalAssignedToLabel =>
      'External calibration contact';

  @override
  String get misureFormDialogAdditionalNotesLabel => 'Additional notes';

  @override
  String get articoliStandardCassettePsScreenTipoCassetta => 'First Aid Kit';

  @override
  String get articoliStandardCassettePsScreenTipoPacchettoMedicazione =>
      'Dressing Pack';

  @override
  String get articoliStandardCassettePsScreenBreadcrumbFirstAid => 'First Aid';

  @override
  String get articoliStandardCassettePsScreenBreadcrumbStandardProducts =>
      'Standard Products';

  @override
  String get articoliStandardCassettePsScreenDescription =>
      'These products are added automatically when you choose the type for a new first aid kit or dressing pack.\nQuantity and expiry remain editable for each individual item.';

  @override
  String get articoliStandardCassettePsScreenAddProduct => 'Add product';

  @override
  String get articoliStandardCassettePsScreenEmpty =>
      'No standard products added.';

  @override
  String get articoliStandardCassettePsScreenContentSection => 'Contents';

  @override
  String get articoliStandardCassettePsScreenEditTooltip => 'Edit product';

  @override
  String get articoliStandardCassettePsScreenDeleteTooltip => 'Delete product';

  @override
  String get articoliStandardCassettePsScreenDeleteConfirmTitle =>
      'Delete product?';

  @override
  String articoliStandardCassettePsScreenDeleteConfirmMessage(String nome) {
    return 'Delete \"$nome\" from the standard products? This action cannot be undone.';
  }

  @override
  String get articoloStandardCassettaPsFormDialogTipoCassetta =>
      'First Aid Kit';

  @override
  String get articoloStandardCassettaPsFormDialogTipoPacchettoMedicazione =>
      'Dressing Pack';

  @override
  String get articoloStandardCassettaPsFormDialogNewTitle =>
      'New standard product';

  @override
  String get articoloStandardCassettaPsFormDialogEditTitle =>
      'Edit standard product';

  @override
  String get articoloStandardCassettaPsFormDialogTypeLabel => 'Type*';

  @override
  String get articoloStandardCassettaPsFormDialogProductNameLabel =>
      'Product name*';

  @override
  String get articoloStandardCassettaPsFormDialogQuantityLabel => 'Quantity';

  @override
  String get documentoTileDeleteConfirmTitle => 'Delete the deadline?';

  @override
  String documentoTileDeleteConfirmMessage(String documento) {
    return 'Delete $documento? This action cannot be undone.';
  }

  @override
  String get documentoTileDefaultDocumentName => 'this document';

  @override
  String get documentoTileSharedSuffix => ' (shared)';

  @override
  String get documentoTileLabelScadenza => 'Due date';

  @override
  String get documentoTileNotRequired => 'not required';

  @override
  String get documentoTileLabelNota => 'Note';

  @override
  String get documentoTileEditDeadline => 'Edit deadline';

  @override
  String get documentoTileDeleteDeadline => 'Delete deadline';

  @override
  String notaMacchinarioDialogTitle(String modello, String tipo) {
    return 'Note — $modello — $tipo';
  }

  @override
  String notaDpiAssegnatoDialogTitle(String titolo) {
    return 'Note — $titolo';
  }

  @override
  String notaScadenzaBennaDialogTitle(String idInterno) {
    return 'Note — Bucket $idInterno';
  }

  @override
  String get macchinariScreenTitle => 'Machinery';

  @override
  String macchinariScreenLocationCantiere(String cantiere) {
    return 'At site $cantiere';
  }

  @override
  String macchinariScreenLocationAutomezzo(String veicolo) {
    return 'On $veicolo';
  }

  @override
  String get macchinariScreenLocationMagazzino => 'In warehouse';

  @override
  String get macchinariScreenLocationUnspecified => 'Not specified';

  @override
  String get macchinariScreenFieldModello => 'Model';

  @override
  String get macchinariScreenFieldTipologia => 'Type';

  @override
  String get macchinariScreenFieldMatricola => 'Serial No.';

  @override
  String get macchinariScreenFieldFabbrica => 'Factory No.';

  @override
  String get macchinariScreenFieldAnno => 'Year';

  @override
  String get macchinariScreenFieldAnnoAcquisto => 'Purchase year';

  @override
  String get macchinariScreenFieldProprieta => 'Ownership';

  @override
  String get macchinariScreenFieldUbicazione => 'Location';

  @override
  String get macchinariScreenFieldCivaInail => 'CIVA/INAIL';

  @override
  String get macchinariScreenFieldPresenteCivaInail => 'Listed in CIVA/INAIL';

  @override
  String get macchinariScreenFieldScadAssicurazione => 'Insurance exp.';

  @override
  String get macchinariScreenFieldScadManutenzione => 'Maintenance exp.';

  @override
  String get macchinariScreenFieldScadFuniCatene => 'Ropes/chains exp.';

  @override
  String get macchinariScreenFieldVerificaAnnuale => 'Annual inspection';

  @override
  String get macchinariScreenFieldVerificaVentennale => '20-year inspection';

  @override
  String get macchinariScreenFieldNotaScadenza => 'Deadline note';

  @override
  String get macchinariScreenFieldLeasingCompany => 'Leasing company';

  @override
  String get macchinariScreenFieldLeasingExpiry => 'Leasing expiry';

  @override
  String get macchinariScreenFieldRentalCompany => 'Rental company';

  @override
  String get macchinariScreenFieldEmail => 'Email';

  @override
  String get macchinariScreenFieldInsuranceCompany => 'Insurance company';

  @override
  String get macchinariScreenFieldInsuranceExpiry => 'Insurance expiry';

  @override
  String get macchinariScreenFieldInterventionDate => 'Intervention date';

  @override
  String get macchinariScreenFieldExpiry => 'Expiry';

  @override
  String get macchinariScreenFieldLastControlDate => 'Last inspection date';

  @override
  String get macchinariScreenFieldVerificationDate => 'Verification date';

  @override
  String macchinariScreenPrintSubtitleCount(int count) {
    return '$count machinery items';
  }

  @override
  String macchinariScreenPrintSubtitleFilter(String filter) {
    return 'search filter: \"$filter\"';
  }

  @override
  String macchinariScreenPrintError(String details) {
    return 'Could not generate the printout: $details';
  }

  @override
  String get macchinariScreenNewButton => 'New machinery';

  @override
  String get macchinariScreenPrintButton => 'Print';

  @override
  String get macchinariScreenUpcomingDeadlines => 'Upcoming deadlines';

  @override
  String get macchinariScreenHideDeadlinesTooltip => 'Hide deadlines';

  @override
  String get macchinariScreenShowDeadlinesTooltip => 'Show deadlines';

  @override
  String get macchinariScreenCollapseAllTooltip => 'Collapse all';

  @override
  String get macchinariScreenExpandAllTooltip => 'Expand all';

  @override
  String get macchinariScreenSearchHint => 'Search by name';

  @override
  String get macchinariScreenEmptyLoaded => 'No machinery loaded.';

  @override
  String macchinariScreenEmptySearch(String query) {
    return 'No machinery found for \"$query\".';
  }

  @override
  String get macchinariScreenEditNoteTooltip => 'Edit note';

  @override
  String get macchinariScreenEditTooltip => 'Edit machinery';

  @override
  String get macchinariScreenDeleteTooltip => 'Delete machinery';

  @override
  String get macchinariScreenDeleteConfirmTitle => 'Delete machinery?';

  @override
  String macchinariScreenDeleteConfirmMessage(String modello) {
    return 'Delete \"$modello\"? This action cannot be undone.';
  }

  @override
  String get macchinariScreenHideInfoTooltip => 'Hide info';

  @override
  String get macchinariScreenShowInfoTooltip => 'Show info';

  @override
  String get macchinariScreenSectionGeneralData => 'General data';

  @override
  String get macchinariScreenSectionInsurance => 'Insurance';

  @override
  String get macchinariScreenSectionInternalMaintenance =>
      'Internal maintenance';

  @override
  String get macchinariScreenSectionRopesChainsControl =>
      'Ropes/chains inspection';

  @override
  String get automezziScreenTitle => 'Vehicles';

  @override
  String get automezziScreenFieldNome => 'Name';

  @override
  String get automezziScreenFieldTarga => 'Plate';

  @override
  String get automezziScreenFieldCategoria => 'Category';

  @override
  String get automezziScreenFieldTelepass => 'Telepass No.';

  @override
  String get automezziScreenFieldProprieta => 'Ownership';

  @override
  String get automezziScreenFieldCompAssicurazione => 'Insurance company';

  @override
  String get automezziScreenFieldScadAssicurazione => 'Insurance exp.';

  @override
  String get automezziScreenFieldScadBollo => 'Road tax exp.';

  @override
  String get automezziScreenFieldScadRevisione => 'Inspection exp.';

  @override
  String get automezziScreenFieldScadTachigrafo => 'Tachograph check exp.';

  @override
  String get automezziScreenFieldVeicolo => 'Vehicle';

  @override
  String get automezziScreenFieldNotaScadenza => 'Deadline note';

  @override
  String get automezziScreenFieldCategoriaEuro => 'EURO category';

  @override
  String automezziScreenFieldScadenzaProprieta(String proprieta) {
    return '$proprieta expiry';
  }

  @override
  String automezziScreenPrintSubtitleCount(int count) {
    return '$count vehicles';
  }

  @override
  String automezziScreenPrintSubtitleFilter(String filter) {
    return 'search filter: \"$filter\"';
  }

  @override
  String automezziScreenPrintError(String details) {
    return 'Could not generate the printout: $details';
  }

  @override
  String get automezziScreenNewButton => 'New vehicle';

  @override
  String get automezziScreenPrintButton => 'Print';

  @override
  String get automezziScreenUpcomingDeadlines => 'Upcoming deadlines';

  @override
  String get automezziScreenHideDeadlinesTooltip => 'Hide deadlines';

  @override
  String get automezziScreenShowDeadlinesTooltip => 'Show deadlines';

  @override
  String get automezziScreenCollapseAllTooltip => 'Collapse all';

  @override
  String get automezziScreenExpandAllTooltip => 'Expand all';

  @override
  String get automezziScreenSearchHint => 'Search by name or plate';

  @override
  String get automezziScreenEmptyLoaded => 'No vehicles loaded.';

  @override
  String automezziScreenEmptySearch(String query) {
    return 'No vehicles found for \"$query\".';
  }

  @override
  String get automezziScreenEditNoteTooltip => 'Edit note';

  @override
  String get automezziScreenEditTooltip => 'Edit vehicle';

  @override
  String get automezziScreenDeleteTooltip => 'Delete vehicle';

  @override
  String get automezziScreenDeleteConfirmTitle => 'Delete vehicle?';

  @override
  String automezziScreenDeleteConfirmMessage(String nome) {
    return 'Delete \"$nome\"? This action cannot be undone.';
  }

  @override
  String get automezziScreenHideInfoTooltip => 'Hide info';

  @override
  String get automezziScreenShowInfoTooltip => 'Show info';

  @override
  String get automezziScreenSectionGeneralData => 'General data';

  @override
  String get automezziScreenSectionScadenze => 'Deadlines';

  @override
  String get dipendenteAziendaleFormDialogNewTitle => 'New company employee';

  @override
  String get dipendenteAziendaleFormDialogEditTitle => 'Edit company employee';

  @override
  String get dipendenteAziendaleFormDialogNomeLabel => 'First name*';

  @override
  String get dipendenteAziendaleFormDialogCognomeLabel => 'Last name*';

  @override
  String get dipendenteAziendaleFormDialogMansioneLabel => 'Job role';

  @override
  String get dipendenteAziendaleFormDialogMansioneNonSpecificata =>
      'Not specified';

  @override
  String get dipendenteAziendaleFormDialogScadenzaRlst => 'RLST expiry';

  @override
  String get dipendenteAziendaleFormDialogScadenzaRspp => 'RSPP expiry';

  @override
  String get dipendenteAziendaleFormDialogCodiceFiscaleLabel => 'Tax code';

  @override
  String get dipendenteAziendaleFormDialogDataNascita => 'Date of birth';

  @override
  String get dipendenteAziendaleFormDialogLuogoNascita => 'Place of birth';

  @override
  String get dipendenteAziendaleFormDialogEtaLabel => 'Age';

  @override
  String get dipendenteAziendaleFormDialogEtaHelper =>
      'Calculated from date of birth';

  @override
  String get dipendenteAziendaleFormDialogSectionContratto => 'Contract';

  @override
  String get dipendenteAziendaleFormDialogDataAssunzione => 'Hire date';

  @override
  String get dipendenteAziendaleFormDialogScadenzaContratto =>
      'Contract expiry';

  @override
  String get dipendenteAziendaleFormDialogRemoveScadenzaContrattoTooltip =>
      'Remove contract expiry';

  @override
  String get dipendenteAziendaleFormDialogAddScadenzaContratto =>
      'Add contract expiry';

  @override
  String get dipendenteAziendaleFormDialogSectionPersonali => 'Personal';

  @override
  String get dipendenteAziendaleFormDialogScadenzaVisitaMedica =>
      'Medical check-up expiry';

  @override
  String get dipendenteAziendaleFormDialogScadenzaPatente =>
      'Driving licence expiry';

  @override
  String get dipendenteAziendaleFormDialogScadenzaCartaTachigraficaAzienda =>
      'Tachograph card + company expiry';

  @override
  String get dipendenteAziendaleFormDialogScadenzaCartaTachigrafica =>
      'Tachograph card expiry';

  @override
  String get dipendenteAziendaleFormDialogScadenzaCartaIdentita =>
      'ID card expiry';

  @override
  String get dipendenteAziendaleFormDialogScadenzaFirmaDigitale =>
      'Digital signature expiry';

  @override
  String get dipendenteAziendaleFormDialogScadenzaCodiceFiscale =>
      'Tax code expiry';

  @override
  String get dipendenteAziendaleFormDialogScadenzaPermessoSoggiorno =>
      'Residence permit expiry';

  @override
  String get dipendenteAziendaleFormDialogRemovePermessoSoggiornoTooltip =>
      'Remove residence permit';

  @override
  String get dipendenteAziendaleFormDialogAddPermessoSoggiorno =>
      'Add residence permit';

  @override
  String get dipendenteAziendaleFormDialogScadenzaAntitetanica =>
      'Tetanus vaccination expiry';

  @override
  String get dipendenteAziendaleFormDialogRemoveAntitetanicaTooltip =>
      'Remove tetanus vaccination';

  @override
  String get dipendenteAziendaleFormDialogAddAntitetanica =>
      'Add tetanus vaccination';

  @override
  String get dipendenteAziendaleFormDialogSectionCorsi => 'Courses';

  @override
  String get dipendenteAziendaleFormDialogScadenzaFormazioneGenerale =>
      'General safety training expiry';

  @override
  String get dipendenteAziendaleFormDialogNoteAggiuntive => 'Additional notes';

  @override
  String get dipendenteAziendaleFormDialogRemoveCorsoTooltip => 'Remove course';

  @override
  String get dipendenteAziendaleFormDialogAddCorso => 'Add course';

  @override
  String get dipendenteAziendaleFormDialogAllCoursesAdded =>
      'You have already added all available courses.';

  @override
  String get dipendenteAziendaleFormDialogSelectCoursesTitle =>
      'Select the courses to add';

  @override
  String dipendenteAziendaleFormDialogAddCoursesCount(int count) {
    return 'Add ($count)';
  }

  @override
  String get dipendenteAziendaleFormDialogCorsoPrimoSoccorsoNome =>
      'First Aid Course';

  @override
  String get dipendenteAziendaleFormDialogCorsoPrimoSoccorsoEtichetta =>
      'First Aid Course expiry';

  @override
  String get dipendenteAziendaleFormDialogCorsoAntincendioNome =>
      'Fire Safety Course';

  @override
  String get dipendenteAziendaleFormDialogCorsoAntincendioEtichetta =>
      'Fire Safety Course expiry';

  @override
  String get dipendenteAziendaleFormDialogCorsoPrepostoNome =>
      'Supervisor Course';

  @override
  String get dipendenteAziendaleFormDialogCorsoPrepostoEtichetta =>
      'Supervisor Course expiry';

  @override
  String get dipendenteAziendaleFormDialogCorsoPonteggiNome =>
      'Scaffolding Assembly/Disassembly';

  @override
  String get dipendenteAziendaleFormDialogCorsoPonteggiEtichetta =>
      'Scaffolding expiry';

  @override
  String get dipendenteAziendaleFormDialogCorsoLavoriQuotaNome =>
      'Working at Height';

  @override
  String get dipendenteAziendaleFormDialogCorsoLavoriQuotaEtichetta =>
      'Working at Height expiry';

  @override
  String get dipendenteAziendaleFormDialogCorsoEscavatoriNome =>
      'Excavator Operation';

  @override
  String get dipendenteAziendaleFormDialogCorsoEscavatoriEtichetta =>
      'Excavator Operation expiry';

  @override
  String get dipendenteAziendaleFormDialogCorsoGruAutocarroNome =>
      'Truck-Mounted Crane';

  @override
  String get dipendenteAziendaleFormDialogCorsoGruAutocarroEtichetta =>
      'Truck-Mounted Crane expiry';

  @override
  String get dipendenteAziendaleFormDialogCorsoGruTorreNome => 'Tower Crane';

  @override
  String get dipendenteAziendaleFormDialogCorsoGruTorreEtichetta =>
      'Tower Crane expiry';

  @override
  String get dipendenteAziendaleFormDialogCorsoPiattaformeNome =>
      'Elevating Platforms';

  @override
  String get dipendenteAziendaleFormDialogCorsoPiattaformeEtichetta =>
      'Elevating Platforms expiry';

  @override
  String get dipendenteAziendaleFormDialogCorsoCarrelloElevatoreNome =>
      'Self-Propelled Forklift';

  @override
  String get dipendenteAziendaleFormDialogCorsoCarrelloElevatoreEtichetta =>
      'Forklift expiry';

  @override
  String get dipendenteAziendaleFormDialogCorsoDisocianatiNome =>
      'Diisocyanates Course';

  @override
  String get dipendenteAziendaleFormDialogCorsoDisocianatiEtichetta =>
      'Diisocyanates Course expiry';

  @override
  String get dipendenteAziendaleFormDialogCorsoScaffalatureNome =>
      'Racking Course';

  @override
  String get dipendenteAziendaleFormDialogCorsoScaffalatureEtichetta =>
      'Racking expiry';

  @override
  String get dipendenteAziendaleFormDialogCorsoFormazione231Nome =>
      'Model 231 Training Course';

  @override
  String get dipendenteAziendaleFormDialogCorsoFormazione231Etichetta =>
      'Model 231 Training date';

  @override
  String get dipendenteAziendaleFormDialogCorsoAmbientaleNome =>
      'Environmental Management System Training';

  @override
  String get dipendenteAziendaleFormDialogCorsoAmbientaleEtichetta =>
      'Environmental Training date';

  @override
  String get dipendenteAziendaleFormDialogCorsoRentriNome =>
      'Rentri Training Course';

  @override
  String get dipendenteAziendaleFormDialogCorsoRentriEtichetta =>
      'Rentri Training date';

  @override
  String get dipendenteAziendaleFormDialogCorsoCronotachigraficoNome =>
      'Tachograph Course';

  @override
  String get dipendenteAziendaleFormDialogCorsoCronotachigraficoEtichetta =>
      'Tachograph Course expiry';

  @override
  String get estintoreFormDialogNewTitle => 'New fire extinguisher';

  @override
  String get estintoreFormDialogEditTitle => 'Edit fire extinguisher';

  @override
  String get estintoreFormDialogMatricolaLabel => 'Serial number*';

  @override
  String get estintoreFormDialogTipoAgenteLabel => 'Extinguishing agent';

  @override
  String get estintoreFormDialogTipoAgenteNonSpecificato => 'Not specified';

  @override
  String get estintoreFormDialogCapacitaLabel => 'Capacity';

  @override
  String get estintoreFormDialogDataProduzione => 'Production date';

  @override
  String get estintoreFormDialogDataMessaInServizio => 'Commissioning date';

  @override
  String get estintoreFormDialogSectionUbicazione => 'Location';

  @override
  String get estintoreFormDialogTipoUbicazioneLabel => 'Location type';

  @override
  String get estintoreFormDialogUbicazioneNonSpecificata => 'Not specified';

  @override
  String get estintoreFormDialogUbicazioneMagazzino => 'Warehouse';

  @override
  String get estintoreFormDialogUbicazioneUfficio => 'Office';

  @override
  String get estintoreFormDialogUbicazioneCantiere => 'Site';

  @override
  String get estintoreFormDialogUbicazioneAutomezzo => 'Vehicle';

  @override
  String get estintoreFormDialogSelectCantiereValidator => 'Select a site';

  @override
  String get estintoreFormDialogSelectAutomezzoValidator => 'Select a vehicle';

  @override
  String get estintoreFormDialogDettagliUbicazione =>
      'Additional location details';

  @override
  String get estintoreFormDialogSectionVerificaEsterna => 'External inspection';

  @override
  String get estintoreFormDialogDataVerificaEsterna =>
      'External inspection date';

  @override
  String get estintoreFormDialogScadenzaVerificaEsterna =>
      'External inspection expiry';

  @override
  String get estintoreFormDialogSectionRevisione => 'Servicing';

  @override
  String get estintoreFormDialogUltimaRevisione => 'Last servicing';

  @override
  String get estintoreFormDialogScadenzaRevisione => 'Servicing expiry';

  @override
  String get estintoreFormDialogSectionCollaudo => 'Testing';

  @override
  String get estintoreFormDialogUltimoCollaudo => 'Last test';

  @override
  String get estintoreFormDialogScadenzaCollaudo => 'Test expiry';

  @override
  String get estintoreFormDialogNoteAggiuntive => 'Additional notes';

  @override
  String get rifiutoFormDialogNewTitle => 'New waste company';

  @override
  String get rifiutoFormDialogEditTitle => 'Edit waste company';

  @override
  String get rifiutoFormDialogNomeDittaLabel => 'Company name*';

  @override
  String get rifiutoFormDialogSectionTrasportatore => 'Carrier';

  @override
  String get rifiutoFormDialogIsTrasportatore => 'Carrier?';

  @override
  String get rifiutoFormDialogNrAutorizzazioneTrasportatore =>
      'Carrier authorization number';

  @override
  String get rifiutoFormDialogScadNonPericolosiTrasportatore =>
      'Non-hazardous waste carrier authorization expiry';

  @override
  String get rifiutoFormDialogAutorizzazionePericolosi =>
      'Authorized for hazardous waste?';

  @override
  String get rifiutoFormDialogScadPericolosiTrasportatore =>
      'Hazardous waste carrier authorization expiry';

  @override
  String get rifiutoFormDialogNoteTrasportatore => 'Carrier notes';

  @override
  String get rifiutoFormDialogSectionSmaltitore => 'Disposal company';

  @override
  String get rifiutoFormDialogIsSmaltitore => 'Disposal company?';

  @override
  String get rifiutoFormDialogNrAutorizzazioneSmaltitore =>
      'Disposal authorization number';

  @override
  String get rifiutoFormDialogScadNonPericolosiSmaltitore =>
      'Non-hazardous waste disposal authorization expiry';

  @override
  String get rifiutoFormDialogScadPericolosiSmaltitore =>
      'Hazardous waste disposal authorization expiry';

  @override
  String get rifiutoFormDialogNoteSmaltitore => 'Disposal company notes';

  @override
  String get automezzoFormDialogNewTitle => 'New vehicle';

  @override
  String get automezzoFormDialogEditTitle => 'Edit vehicle';

  @override
  String get automezzoFormDialogNomeLabel => 'Name';

  @override
  String get automezzoFormDialogTargaLabel => 'Plate*';

  @override
  String get automezzoFormDialogCategoriaLabel => 'Category';

  @override
  String get automezzoFormDialogNonSpecificata => 'Not specified';

  @override
  String get automezzoFormDialogTelepassLabel => 'Telepass number';

  @override
  String get automezzoFormDialogProprietaLabel => 'Ownership';

  @override
  String automezzoFormDialogScadenzaProprieta(String proprieta) {
    return '$proprieta expiry';
  }

  @override
  String get automezzoFormDialogSectionAssicurazione => 'Insurance';

  @override
  String get automezzoFormDialogScadenzaAssicurazione => 'Insurance expiry';

  @override
  String get automezzoFormDialogNomeAssicurazioneLabel => 'Insurance company';

  @override
  String get automezzoFormDialogSectionBollo => 'Road tax';

  @override
  String get automezzoFormDialogScadenzaBollo => 'Road tax expiry';

  @override
  String get automezzoFormDialogSectionRevisione => 'Inspection';

  @override
  String get automezzoFormDialogScadenzaRevisione => 'Inspection expiry';

  @override
  String get automezzoFormDialogSectionTachigrafo => 'Tachograph';

  @override
  String get automezzoFormDialogScadenzaControlloTachigrafo =>
      'Tachograph check expiry';

  @override
  String get automezzoFormDialogNoteAggiuntive => 'Additional notes';

  @override
  String get scalaFormDialogNewTitle => 'New ladder';

  @override
  String get scalaFormDialogEditTitle => 'Edit ladder';

  @override
  String get scalaFormDialogSectionAnagrafica => 'Details';

  @override
  String get scalaFormDialogCodiceLabel => 'Code*';

  @override
  String get scalaFormDialogMaterialeLabel => 'Material';

  @override
  String get scalaFormDialogDescrizioneLabel => 'Description';

  @override
  String get scalaFormDialogSectionUbicazione => 'Location';

  @override
  String get scalaFormDialogTipoUbicazioneLabel => 'Location type';

  @override
  String get scalaFormDialogUbicazioneNonSpecificata => 'Not specified';

  @override
  String get scalaFormDialogUbicazioneMagazzino => 'Warehouse';

  @override
  String get scalaFormDialogUbicazioneCantiere => 'Site';

  @override
  String get scalaFormDialogSelectCantiereValidator => 'Select a site';

  @override
  String get scalaFormDialogSectionVerifiche => 'Inspections';

  @override
  String get scalaFormDialogUltimaVerifica => 'Last inspection';

  @override
  String get scalaFormDialogProssimaVerifica => 'Next inspection';

  @override
  String get scalaFormDialogNoteAggiuntive => 'Additional notes';

  @override
  String modificaScadenzaCantiereDialogTitle(String etichetta) {
    return 'Edit $etichetta';
  }

  @override
  String get modificaScadenzaCantiereDialogDataScadenza => 'Expiry date';

  @override
  String get modificaScadenzaCantiereDialogMissingDate =>
      'Enter an expiry date';

  @override
  String get ritiroDpiQuotaDialogConfirmTitle => 'Withdraw the PPE?';

  @override
  String ritiroDpiQuotaDialogConfirmMessage(String tipo, String dipendente) {
    return 'Withdraw \"$tipo\" from $dipendente? Only the delivery date is cleared: the rest of the record stays unchanged, and on return you\'ll just need to re-enter the date.';
  }

  @override
  String get ritiroDpiQuotaDialogConfirmButton => 'Withdraw';

  @override
  String ritiroDpiQuotaDialogRiconsegnaTitle(String tipo) {
    return 'Return — $tipo';
  }

  @override
  String ritiroDpiQuotaDialogRiconsegnaMessage(String dipendente) {
    return 'The PPE goes back to $dipendente: enter the date it is returned to them.';
  }

  @override
  String get ritiroDpiQuotaDialogDataConsegnaLabel => 'Delivery date*';

  @override
  String get ritiroDpiQuotaDialogRiconsegnaButton => 'Return';

  @override
  String get statoBadgeValido => 'Valid';

  @override
  String get statoBadgeInScadenza => 'Expiring soon';

  @override
  String get statoBadgeScaduto => 'Expired';

  @override
  String get segnaleticaSicurezzaScreenZonaUfficio => 'Office';

  @override
  String get segnaleticaSicurezzaScreenZonaMagazzino => 'Warehouse';

  @override
  String get segnaleticaSicurezzaScreenZonaNonSpecificata => 'Unspecified area';

  @override
  String get segnaleticaSicurezzaScreenEsitoCartelloAssente => 'Sign missing';

  @override
  String get segnaleticaSicurezzaScreenEsitoPresente => 'Present';

  @override
  String get segnaleticaSicurezzaScreenEsitoPosizioneIdonea =>
      'Suitable position';

  @override
  String get segnaleticaSicurezzaScreenEsitoPosizioneNonIdonea =>
      'Unsuitable position';

  @override
  String get segnaleticaSicurezzaScreenEsitoBuonoStato => 'Good condition';

  @override
  String get segnaleticaSicurezzaScreenEsitoDaSostituire => 'Needs replacement';

  @override
  String get segnaleticaSicurezzaScreenTitle => 'Safety Signals';

  @override
  String get segnaleticaSicurezzaScreenTitleShort => 'Signage';

  @override
  String get segnaleticaSicurezzaScreenNuovoControllo => 'New inspection';

  @override
  String get segnaleticaSicurezzaScreenNuovoSegnale => 'New sign';

  @override
  String get segnaleticaSicurezzaScreenInfoEmailScadenza =>
      'Deadline email info';

  @override
  String get segnaleticaSicurezzaScreenSegnaleticaPresente =>
      'Signage on record';

  @override
  String get segnaleticaSicurezzaScreenChiudiTutti => 'Collapse all';

  @override
  String get segnaleticaSicurezzaScreenEspandiTutti => 'Expand all';

  @override
  String get segnaleticaSicurezzaScreenControllaTutti => 'Inspect all';

  @override
  String get segnaleticaSicurezzaScreenNessunCartelloZona =>
      'No signs in this area.';

  @override
  String get segnaleticaSicurezzaScreenModificaCartello => 'Edit sign';

  @override
  String get segnaleticaSicurezzaScreenEliminaCartello => 'Delete sign';

  @override
  String get segnaleticaSicurezzaScreenEliminareCartelloTitle => 'Delete sign?';

  @override
  String segnaleticaSicurezzaScreenEliminareCartelloMessage(String nome) {
    return 'Delete \"$nome\" and its inspections? This action cannot be undone.';
  }

  @override
  String get segnaleticaSicurezzaScreenNascondiInfo => 'Hide info';

  @override
  String get segnaleticaSicurezzaScreenMostraInfo => 'Show info';

  @override
  String get segnaleticaSicurezzaScreenCampoUbicazione => 'Location';

  @override
  String get segnaleticaSicurezzaScreenUltimoControllo => 'Last inspection';

  @override
  String get segnaleticaSicurezzaScreenMaiControllato => 'never inspected';

  @override
  String get segnaleticaSicurezzaScreenDatiCartello => 'Sign details';

  @override
  String get segnaleticaSicurezzaScreenCampoZona => 'Area';

  @override
  String get segnaleticaSicurezzaScreenControlliRegistrati =>
      'Inspections on record';

  @override
  String get segnaleticaSicurezzaScreenControlliHeader => 'Inspections';

  @override
  String get segnaleticaSicurezzaScreenNessunControlloRegistrato =>
      'No inspections recorded.';

  @override
  String get segnaleticaSicurezzaScreenIngrandisciCartello => 'Enlarge sign';

  @override
  String get segnaleticaSicurezzaScreenImmagineNonDisponibile =>
      'Image unavailable';

  @override
  String get segnaleticaSicurezzaScreenEsitiLabel => 'Outcome';

  @override
  String get segnaleticaSicurezzaScreenNoteControllo => 'Inspection notes';

  @override
  String get segnaleticaSicurezzaScreenModificaControllo => 'Edit inspection';

  @override
  String get segnaleticaSicurezzaScreenEliminaControllo => 'Delete inspection';

  @override
  String get segnaleticaSicurezzaScreenEliminareControlloTitle =>
      'Delete inspection?';

  @override
  String segnaleticaSicurezzaScreenEliminareControlloMessage(
    String data,
    String nome,
  ) {
    return 'Delete the inspection from $data on \"$nome\"? This action cannot be undone.';
  }

  @override
  String get dpiScreenTitle => 'PPE';

  @override
  String get dpiScreenAssegnaDpi => 'Assign PPE';

  @override
  String get dpiScreenTipiDpi => 'PPE Types';

  @override
  String get dpiScreenScadenzeImminenti => 'Upcoming deadlines';

  @override
  String get dpiScreenNascondiScadenze => 'Hide deadlines';

  @override
  String get dpiScreenMostraScadenze => 'Show deadlines';

  @override
  String get dpiScreenDipendentiConDpiObbligatori =>
      'Employees with mandatory PPE';

  @override
  String get dpiScreenNascondiTutti => 'Hide all';

  @override
  String get dpiScreenMostraTutti => 'Show all';

  @override
  String get dpiScreenCercaPerNome => 'Search by name';

  @override
  String get dpiScreenNessunDipendenteMansione =>
      'No employees with role Datore, M02, M03 or M04.';

  @override
  String dpiScreenNessunDipendenteTrovato(String query) {
    return 'No employee found for \"$query\".';
  }

  @override
  String get dpiScreenCampoDipendente => 'Employee';

  @override
  String get dpiScreenCampoMatricola => 'ID number';

  @override
  String get dpiScreenNotaScadenza => 'Deadline note';

  @override
  String get dpiScreenModificaNota => 'Edit note';

  @override
  String get dpiScreenCampoMansione => 'Job role';

  @override
  String get dpiScreenCampoAssegnati => 'Assigned';

  @override
  String get dpiScreenCampoNota => 'Note';

  @override
  String get dpiScreenAssegnaAltroDpi => 'Assign another PPE item';

  @override
  String get dpiScreenNascondiDpi => 'Hide PPE';

  @override
  String get dpiScreenMostraDpi => 'Show PPE';

  @override
  String get dpiScreenNessunaRegolaDpi => 'No PPE rule set for this job role.';

  @override
  String get dpiScreenAltriDpiAssegnati => 'Other assigned PPE';

  @override
  String get dpiScreenNonAssegnato => 'Not assigned';

  @override
  String get dpiScreenCampoProduttore => 'Manufacturer';

  @override
  String get dpiScreenCampoTaglia => 'Size';

  @override
  String get dpiScreenCampoScadenza => 'Deadline';

  @override
  String get dpiScreenNonImpostata => 'not set';

  @override
  String get dpiScreenDpiRitirato => 'PPE Returned';

  @override
  String get dpiScreenRiconsegnaDpiQuota => 'Return PPE for work at height';

  @override
  String get dpiScreenRitiraDpiQuota => 'Issue PPE for work at height';

  @override
  String get dpiScreenModificaDpiAssegnato => 'Edit assigned PPE';

  @override
  String get dpiScreenEliminaDpiAssegnato => 'Delete assigned PPE';

  @override
  String get dpiScreenEliminareDpiAssegnatoTitle => 'Delete the assigned PPE?';

  @override
  String dpiScreenEliminareDpiAssegnatoMessage(String tipo, String dipendente) {
    return 'Delete \"$tipo\" assigned to $dipendente? This action cannot be undone.';
  }

  @override
  String get rifiutiScreenTipoNonPericolosiTrasportatore =>
      'Non-Hazardous Waste Carrier Deadline';

  @override
  String get rifiutiScreenTipoPericolosiTrasportatore =>
      'Hazardous Waste Carrier Deadline';

  @override
  String get rifiutiScreenTipoNonPericolosiSmaltitore =>
      'Non-Hazardous Waste Disposal Deadline';

  @override
  String get rifiutiScreenTipoPericolosiSmaltitore =>
      'Hazardous Waste Disposal Deadline';

  @override
  String get rifiutiScreenTitle => 'Waste';

  @override
  String get rifiutiScreenScadenzeImminenti => 'Upcoming deadlines';

  @override
  String get rifiutiScreenNascondiScadenze => 'Hide deadlines';

  @override
  String get rifiutiScreenMostraScadenze => 'Show deadlines';

  @override
  String get rifiutiScreenAziendePerRaccolta => 'Waste collection companies';

  @override
  String get rifiutiScreenNascondiTutti => 'Hide all';

  @override
  String get rifiutiScreenMostraTutti => 'Show all';

  @override
  String get rifiutiScreenCercaPerNomeDitta => 'Search by company name';

  @override
  String get rifiutiScreenNessunElementoCaricato => 'No items loaded.';

  @override
  String rifiutiScreenNessunElementoTrovato(String query) {
    return 'No item found for \"$query\".';
  }

  @override
  String get rifiutiScreenCampoDitta => 'Company';

  @override
  String get rifiutiScreenNotaScadenza => 'Deadline note';

  @override
  String get rifiutiScreenModificaNota => 'Edit note';

  @override
  String get rifiutiScreenCampoTrasportatore => 'Carrier';

  @override
  String get rifiutiScreenNoteTrasportatore => 'Carrier notes';

  @override
  String get rifiutiScreenCampoSmaltitore => 'Disposal company';

  @override
  String get rifiutiScreenNoteSmaltitore => 'Disposal company notes';

  @override
  String get rifiutiScreenEliminaAzienda => 'Delete company';

  @override
  String get rifiutiScreenEliminareAziendaTitle => 'Delete company?';

  @override
  String rifiutiScreenEliminareAziendaMessage(String nome) {
    return 'Delete \"$nome\"? This action cannot be undone.';
  }

  @override
  String get rifiutiScreenNascondiInfo => 'Hide info';

  @override
  String get rifiutiScreenMostraInfo => 'Show info';

  @override
  String get rifiutiScreenNrAutorizzazione => 'Authorization no.';

  @override
  String get rifiutiScreenScadNonPericolosi => 'Non-hazardous waste deadline';

  @override
  String get rifiutiScreenScadPericolosi => 'Hazardous waste deadline';

  @override
  String get controlloSegnaleFormDialogEditTitle => 'Edit inspection';

  @override
  String get controlloSegnaleFormDialogNewTitle => 'New inspection';

  @override
  String get controlloSegnaleFormDialogCartelloLabel => 'Sign*';

  @override
  String get controlloSegnaleFormDialogSelezionaCartello => 'Select a sign';

  @override
  String get controlloSegnaleFormDialogDataIspezione => 'Inspection date';

  @override
  String get controlloSegnaleFormDialogEsitoControllo => 'Inspection outcome';

  @override
  String get controlloSegnaleFormDialogCartelloPresente => 'Sign is present';

  @override
  String get controlloSegnaleFormDialogPosizioneIdonea => 'Suitable position';

  @override
  String get controlloSegnaleFormDialogInBuonoStato => 'Good condition';

  @override
  String get controlloSegnaleFormDialogNoteHint =>
      'E.g. faded sign, needs replacement';

  @override
  String controlloSegnaleFormDialogControlloZonaTitle(String zona) {
    return 'Area inspection - $zona';
  }

  @override
  String controlloSegnaleFormDialogRegistrazioneBlocco(int count, String noun) {
    return 'This records a positive inspection (sign present, suitable position, good condition) for all $count $noun in the area. If a sign wasn\'t in order, correct its inspection from the sign\'s card.';
  }

  @override
  String get controlloSegnaleFormDialogSignSingular => 'sign';

  @override
  String get controlloSegnaleFormDialogSignPlural => 'signs';

  @override
  String get controlloSegnaleFormDialogNoteAppliedLabel =>
      'Notes (applied to all)';

  @override
  String get controlloSegnaleFormDialogNoteAppliedHint =>
      'E.g. monthly inspection round';

  @override
  String get controlloSegnaleFormDialogCartelliInteressati => 'Signs involved';

  @override
  String get controlloSegnaleFormDialogRegistraSuTutti => 'Record for all';

  @override
  String get tipoScadenzaFormDialogSelezionaAppartenenza =>
      'Select at least one category';

  @override
  String get tipoScadenzaFormDialogNewTitle => 'New deadline type';

  @override
  String get tipoScadenzaFormDialogEditTitle => 'Edit deadline type';

  @override
  String get tipoScadenzaFormDialogTipologia => 'Category';

  @override
  String get tipoScadenzaFormDialogNomeLabel => 'Name*';

  @override
  String get tipoScadenzaFormDialogNomeHint => 'e.g. DURC, POS, Survey';

  @override
  String get tipoScadenzaFormDialogNotaPredefinitaLabel => 'Default note';

  @override
  String get tipoScadenzaFormDialogNotaPredefinitaHint =>
      'e.g. expires every 6 months';

  @override
  String get tipoScadenzaFormDialogNotaPredefinitaHelper =>
      'Pre-filled in the deadline notes when this category is selected';

  @override
  String get tipoScadenzaFormDialogAppartenenza => 'Applies to';

  @override
  String get tipoScadenzaFormDialogCantiere => 'Construction site';

  @override
  String get tipoScadenzaFormDialogSubappaltatore => 'Subcontractor';

  @override
  String get tipoScadenzaFormDialogDipendenteSubappaltatore =>
      'Subcontractor employee';

  @override
  String get tipoScadenzaFormDialogLavoratoreAutonomo => 'Self-employed worker';

  @override
  String get tipoScadenzaFormDialogTipologieDipendentiInfo =>
      'Employee categories also apply to self-employed workers.';

  @override
  String get tipoScadenzaFormDialogScadenza => 'Deadline';

  @override
  String get tipoScadenzaFormDialogRichiedeScadenza => 'Requires a deadline';

  @override
  String get tipoScadenzaFormDialogAvvisaSoloScadutaTitle =>
      'Notify only once overdue';

  @override
  String get tipoScadenzaFormDialogAvvisaSoloScadutaSubtitle =>
      'No advance notice: the first email goes out the day after the deadline (e.g. DURC)';

  @override
  String get tipoScadenzaFormDialogGiorniPreavvisoLabel => 'Notice days';

  @override
  String get tipoScadenzaFormDialogGiorniPreavvisoHint => 'e.g. 30, 15, 7, 1';

  @override
  String get subappaltatoreFormDialogNewTitle => 'New subcontractor';

  @override
  String get subappaltatoreFormDialogEditTitle => 'Edit subcontractor';

  @override
  String get subappaltatoreFormDialogCercaEsistenti =>
      'Search existing subcontractors';

  @override
  String get subappaltatoreFormDialogSelezionaEsistenteInfo =>
      'Select an existing subcontractor, or fill in the fields below to create a new one.';

  @override
  String get subappaltatoreFormDialogAnagrafica => 'Company details';

  @override
  String get subappaltatoreFormDialogRagioneSocialeLabel => 'Company name*';

  @override
  String get subappaltatoreFormDialogPartitaIvaLabel => 'VAT number*';

  @override
  String get subappaltatoreFormDialogTelefonoLabel => 'Phone';

  @override
  String get subappaltatoreFormDialogEmailLabel => 'Email';

  @override
  String get subappaltatoreFormDialogEmailInvalida => 'Enter a valid email';

  @override
  String get subappaltatoreFormDialogNoteHelper =>
      'Shown in the \"Information\" box on the subcontractor\'s page';

  @override
  String get subappaltatoreFormDialogCantieriAssociati =>
      'Associated construction sites';

  @override
  String get archivioCantieriScreenEliminareTuttiTitle =>
      'Delete all archived construction sites?';

  @override
  String get archivioCantieriScreenEliminareTuttiMessage =>
      'This action cannot be undone — please make sure.';

  @override
  String get archivioCantieriScreenTitle => 'Construction Site Archive';

  @override
  String get archivioCantieriScreenEliminaCantieriArchiviatiTooltip =>
      'Delete archived construction sites';

  @override
  String get archivioCantieriScreenEliminaCantieriLabel => 'Delete sites';

  @override
  String get archivioCantieriScreenNessunCantiereArchiviato =>
      'No archived construction sites.';

  @override
  String get archivioCantieriScreenCantieriConclusi =>
      'Completed construction sites';

  @override
  String get archivioCantieriScreenCercaHint =>
      'Search by name, address or town';

  @override
  String get archivioCantieriScreenNessunCantiereConcluso =>
      'No completed construction sites (all active).';

  @override
  String archivioCantieriScreenNessunCantiereTrovato(String query) {
    return 'No completed construction site found for \"$query\".';
  }

  @override
  String get archivioCantieriScreenEliminareCantiereTitle =>
      'Delete construction site?';

  @override
  String archivioCantieriScreenEliminareCantiereMessage(String nome) {
    return 'Permanently delete the construction site \"$nome\"? This action cannot be undone.';
  }

  @override
  String get scaffalaturaFormDialogNewTitle => 'New shelving unit';

  @override
  String get scaffalaturaFormDialogEditTitle => 'Edit shelving unit';

  @override
  String get scaffalaturaFormDialogIdInternoLabel => 'Internal ID*';

  @override
  String get scaffalaturaFormDialogInserireNumero => 'Enter a number';

  @override
  String get scaffalaturaFormDialogVerifiche => 'Inspections';

  @override
  String get scaffalaturaFormDialogDataUltimaVerifica => 'Last inspection date';

  @override
  String get scaffalaturaFormDialogEsitoPositivo => 'Positive outcome?';

  @override
  String get scaffalaturaFormDialogDataProssimaVerifica =>
      'Next inspection date';

  @override
  String get infoDialogNoteScadenzaTitle => 'Information about deadline notes';

  @override
  String get infoDialogNoteScadenzaIntro => 'By entering the word ';

  @override
  String get infoDialogNoteScadenzaOr => ' or ';

  @override
  String get infoDialogNoteScadenzaOutro =>
      ' in the deadline note,\nautomatic email sending for that deadline will be blocked.';

  @override
  String get infoDialogEmailScadenzaTitle =>
      'Information about deadline emails';

  @override
  String get infoDialogEmailScadenzaIntro => 'Emails for the deadlines of ';

  @override
  String get infoDialogEmailScadenzaMiddle => ' are managed from the ';

  @override
  String get infoDialogEmailScadenzaPageName =>
      'Administration - General deadlines';

  @override
  String get infoDialogEmailScadenzaOutro =>
      ' page.\nUpdate the deadline from there once the inspection has been carried out.';

  @override
  String notaAutomezzoDialogTitle(String nome, String tipo) {
    return 'Note — $nome — $tipo';
  }

  @override
  String get pagina404ScreenTitle => 'Error 404';

  @override
  String get pagina404ScreenMessage =>
      'Oops! Looks like you got lost.\nThe page you\'re looking for doesn\'t exist or has been moved.';

  @override
  String get pagina404ScreenTornaHome => 'Back to Home';
}
