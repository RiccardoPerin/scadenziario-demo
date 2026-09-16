import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_it.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('it'),
  ];

  /// Titolo dell'applicazione
  ///
  /// In it, this message translates to:
  /// **'Demo Scadenziario'**
  String get appTitle;

  /// No description provided for @commonCancel.
  ///
  /// In it, this message translates to:
  /// **'Annulla'**
  String get commonCancel;

  /// No description provided for @commonSave.
  ///
  /// In it, this message translates to:
  /// **'Salva'**
  String get commonSave;

  /// No description provided for @commonDelete.
  ///
  /// In it, this message translates to:
  /// **'Elimina'**
  String get commonDelete;

  /// No description provided for @commonConfirm.
  ///
  /// In it, this message translates to:
  /// **'Conferma'**
  String get commonConfirm;

  /// No description provided for @commonEdit.
  ///
  /// In it, this message translates to:
  /// **'Modifica'**
  String get commonEdit;

  /// No description provided for @commonClose.
  ///
  /// In it, this message translates to:
  /// **'Chiudi'**
  String get commonClose;

  /// No description provided for @commonYes.
  ///
  /// In it, this message translates to:
  /// **'Sì'**
  String get commonYes;

  /// No description provided for @commonNo.
  ///
  /// In it, this message translates to:
  /// **'No'**
  String get commonNo;

  /// No description provided for @commonSearch.
  ///
  /// In it, this message translates to:
  /// **'Cerca'**
  String get commonSearch;

  /// No description provided for @commonLoading.
  ///
  /// In it, this message translates to:
  /// **'Caricamento in corso...'**
  String get commonLoading;

  /// No description provided for @commonError.
  ///
  /// In it, this message translates to:
  /// **'Errore'**
  String get commonError;

  /// No description provided for @commonAdd.
  ///
  /// In it, this message translates to:
  /// **'Aggiungi'**
  String get commonAdd;

  /// No description provided for @commonBack.
  ///
  /// In it, this message translates to:
  /// **'Indietro'**
  String get commonBack;

  /// No description provided for @commonNoteLabel.
  ///
  /// In it, this message translates to:
  /// **'Note'**
  String get commonNoteLabel;

  /// No description provided for @commonRequiredField.
  ///
  /// In it, this message translates to:
  /// **'Campo obbligatorio'**
  String get commonRequiredField;

  /// No description provided for @commonErrorWithDetails.
  ///
  /// In it, this message translates to:
  /// **'Errore: {details}'**
  String commonErrorWithDetails(String details);

  /// No description provided for @appBarGoHome.
  ///
  /// In it, this message translates to:
  /// **'Vai alla home'**
  String get appBarGoHome;

  /// No description provided for @appBarLogout.
  ///
  /// In it, this message translates to:
  /// **'Esci'**
  String get appBarLogout;

  /// No description provided for @appBarLogoutConfirmTitle.
  ///
  /// In it, this message translates to:
  /// **'Conferma logout'**
  String get appBarLogoutConfirmTitle;

  /// No description provided for @appBarLogoutConfirmMessage.
  ///
  /// In it, this message translates to:
  /// **'Sei sicuro di voler uscire?'**
  String get appBarLogoutConfirmMessage;

  /// No description provided for @appBarLogoutConfirmButton.
  ///
  /// In it, this message translates to:
  /// **'Esci'**
  String get appBarLogoutConfirmButton;

  /// No description provided for @appBarLanguageTooltip.
  ///
  /// In it, this message translates to:
  /// **'Switch to English'**
  String get appBarLanguageTooltip;

  /// No description provided for @confirmDialogCancel.
  ///
  /// In it, this message translates to:
  /// **'Annulla'**
  String get confirmDialogCancel;

  /// No description provided for @confirmDialogDeleteDefault.
  ///
  /// In it, this message translates to:
  /// **'Elimina'**
  String get confirmDialogDeleteDefault;

  /// No description provided for @loginWelcomeTitle.
  ///
  /// In it, this message translates to:
  /// **'Benvenuto!'**
  String get loginWelcomeTitle;

  /// No description provided for @loginWelcomeSubtitle.
  ///
  /// In it, this message translates to:
  /// **'Accedi al gestionale cantieri'**
  String get loginWelcomeSubtitle;

  /// No description provided for @loginEmailHint.
  ///
  /// In it, this message translates to:
  /// **'Inserisci la tua email'**
  String get loginEmailHint;

  /// No description provided for @loginEmailLabel.
  ///
  /// In it, this message translates to:
  /// **'Email'**
  String get loginEmailLabel;

  /// No description provided for @loginEmailValidatorEmpty.
  ///
  /// In it, this message translates to:
  /// **'Inserisci l\'email'**
  String get loginEmailValidatorEmpty;

  /// No description provided for @loginPasswordHint.
  ///
  /// In it, this message translates to:
  /// **'Inserisci la tua password'**
  String get loginPasswordHint;

  /// No description provided for @loginPasswordLabel.
  ///
  /// In it, this message translates to:
  /// **'Password'**
  String get loginPasswordLabel;

  /// No description provided for @loginPasswordValidatorEmpty.
  ///
  /// In it, this message translates to:
  /// **'Inserisci la password'**
  String get loginPasswordValidatorEmpty;

  /// No description provided for @loginButton.
  ///
  /// In it, this message translates to:
  /// **'Login'**
  String get loginButton;

  /// No description provided for @authInvalidCredentials.
  ///
  /// In it, this message translates to:
  /// **'Credenziali non valide'**
  String get authInvalidCredentials;

  /// No description provided for @errorLoadingScale.
  ///
  /// In it, this message translates to:
  /// **'Errore nel caricamento delle scale'**
  String get errorLoadingScale;

  /// No description provided for @errorLoadingTipiScadenza.
  ///
  /// In it, this message translates to:
  /// **'Errore nel caricamento dei tipi scadenza'**
  String get errorLoadingTipiScadenza;

  /// No description provided for @errorLoadingScadenzeGenerali.
  ///
  /// In it, this message translates to:
  /// **'Errore nel caricamento delle scadenze generali'**
  String get errorLoadingScadenzeGenerali;

  /// No description provided for @errorLoadingCantieri.
  ///
  /// In it, this message translates to:
  /// **'Errore nel caricamento dei cantieri'**
  String get errorLoadingCantieri;

  /// No description provided for @errorLoadingTipiDpi.
  ///
  /// In it, this message translates to:
  /// **'Errore nel caricamento dei tipi di DPI'**
  String get errorLoadingTipiDpi;

  /// No description provided for @errorLoadingImpostazioni.
  ///
  /// In it, this message translates to:
  /// **'Errore nel caricamento delle impostazioni'**
  String get errorLoadingImpostazioni;

  /// No description provided for @errorLoadingDocumenti.
  ///
  /// In it, this message translates to:
  /// **'Errore nel caricamento dei documenti'**
  String get errorLoadingDocumenti;

  /// No description provided for @errorLoadingMisure.
  ///
  /// In it, this message translates to:
  /// **'Errore nel caricamento delle misure'**
  String get errorLoadingMisure;

  /// No description provided for @errorLoadingRifiuti.
  ///
  /// In it, this message translates to:
  /// **'Errore nel caricamento dei rifiuti'**
  String get errorLoadingRifiuti;

  /// No description provided for @errorLoadingEstintori.
  ///
  /// In it, this message translates to:
  /// **'Errore nel caricamento degli estintori'**
  String get errorLoadingEstintori;

  /// No description provided for @errorLoadingBenne.
  ///
  /// In it, this message translates to:
  /// **'Errore nel caricamento delle benne'**
  String get errorLoadingBenne;

  /// No description provided for @errorLoadingSegnaletica.
  ///
  /// In it, this message translates to:
  /// **'Errore nel caricamento della segnaletica'**
  String get errorLoadingSegnaletica;

  /// No description provided for @errorLoadingCassette.
  ///
  /// In it, this message translates to:
  /// **'Errore nel caricamento delle cassette'**
  String get errorLoadingCassette;

  /// No description provided for @errorLoadingMacchinari.
  ///
  /// In it, this message translates to:
  /// **'Errore nel caricamento dei macchinari'**
  String get errorLoadingMacchinari;

  /// No description provided for @errorLoadingAutomezzi.
  ///
  /// In it, this message translates to:
  /// **'Errore nel caricamento degli automezzi'**
  String get errorLoadingAutomezzi;

  /// No description provided for @errorLoadingRegoleDpi.
  ///
  /// In it, this message translates to:
  /// **'Errore nel caricamento delle regole DPI'**
  String get errorLoadingRegoleDpi;

  /// No description provided for @errorLoadingImpianti.
  ///
  /// In it, this message translates to:
  /// **'Errore nel caricamento degli impianti'**
  String get errorLoadingImpianti;

  /// No description provided for @errorLoadingControlli.
  ///
  /// In it, this message translates to:
  /// **'Errore nel caricamento dei controlli'**
  String get errorLoadingControlli;

  /// No description provided for @errorLoadingFasceCatene.
  ///
  /// In it, this message translates to:
  /// **'Errore nel caricamento di fasce e catene'**
  String get errorLoadingFasceCatene;

  /// No description provided for @errorLoadingSubappaltatori.
  ///
  /// In it, this message translates to:
  /// **'Errore nel caricamento dei subappaltatori'**
  String get errorLoadingSubappaltatori;

  /// No description provided for @errorLoadingDipendentiSubappaltatori.
  ///
  /// In it, this message translates to:
  /// **'Errore nel caricamento dei dipendenti'**
  String get errorLoadingDipendentiSubappaltatori;

  /// No description provided for @errorLoadingArticoli.
  ///
  /// In it, this message translates to:
  /// **'Errore nel caricamento degli articoli'**
  String get errorLoadingArticoli;

  /// No description provided for @errorLoadingDpiAssegnati.
  ///
  /// In it, this message translates to:
  /// **'Errore nel caricamento dei DPI assegnati'**
  String get errorLoadingDpiAssegnati;

  /// No description provided for @errorLoadingProdottiStandard.
  ///
  /// In it, this message translates to:
  /// **'Errore nel caricamento dei prodotti standard'**
  String get errorLoadingProdottiStandard;

  /// No description provided for @errorLoadingDipendentiAziendali.
  ///
  /// In it, this message translates to:
  /// **'Errore nel caricamento dei dipendenti aziendali'**
  String get errorLoadingDipendentiAziendali;

  /// No description provided for @errorLoadingScaffalature.
  ///
  /// In it, this message translates to:
  /// **'Errore nel caricamento delle scaffalature'**
  String get errorLoadingScaffalature;

  /// No description provided for @errorDeletingScadenzaGenerale.
  ///
  /// In it, this message translates to:
  /// **'Impossibile eliminare la scadenza'**
  String get errorDeletingScadenzaGenerale;

  /// No description provided for @errorDeletingTipoScadenzaInUse.
  ///
  /// In it, this message translates to:
  /// **'Impossibile eliminare la tipologia: probabilmente è ancora usata da una o più scadenze.'**
  String get errorDeletingTipoScadenzaInUse;

  /// No description provided for @errorDeletingScaffalatura.
  ///
  /// In it, this message translates to:
  /// **'Impossibile eliminare la scaffalatura'**
  String get errorDeletingScaffalatura;

  /// No description provided for @appDrawerAmministrazione.
  ///
  /// In it, this message translates to:
  /// **'Amministrazione'**
  String get appDrawerAmministrazione;

  /// No description provided for @appDrawerArchivioCantieri.
  ///
  /// In it, this message translates to:
  /// **'Archivio cantieri'**
  String get appDrawerArchivioCantieri;

  /// No description provided for @appDrawerAutomezzi.
  ///
  /// In it, this message translates to:
  /// **'Automezzi'**
  String get appDrawerAutomezzi;

  /// No description provided for @appDrawerCantieri.
  ///
  /// In it, this message translates to:
  /// **'Cantieri'**
  String get appDrawerCantieri;

  /// No description provided for @appDrawerContenutoStandard.
  ///
  /// In it, this message translates to:
  /// **'Contenuto Standard'**
  String get appDrawerContenutoStandard;

  /// No description provided for @appDrawerDpi.
  ///
  /// In it, this message translates to:
  /// **'DPI'**
  String get appDrawerDpi;

  /// No description provided for @appDrawerEstintori.
  ///
  /// In it, this message translates to:
  /// **'Estintori'**
  String get appDrawerEstintori;

  /// No description provided for @appDrawerFasceCatene.
  ///
  /// In it, this message translates to:
  /// **'Fasce/Catene'**
  String get appDrawerFasceCatene;

  /// No description provided for @appDrawerHideSubsections.
  ///
  /// In it, this message translates to:
  /// **'Nascondi sottosezioni'**
  String get appDrawerHideSubsections;

  /// No description provided for @appDrawerImpianti.
  ///
  /// In it, this message translates to:
  /// **'Impianti'**
  String get appDrawerImpianti;

  /// No description provided for @appDrawerMacchinari.
  ///
  /// In it, this message translates to:
  /// **'Macchinari'**
  String get appDrawerMacchinari;

  /// No description provided for @appDrawerMisure.
  ///
  /// In it, this message translates to:
  /// **'Misure'**
  String get appDrawerMisure;

  /// No description provided for @appDrawerOtherSectionsTitle.
  ///
  /// In it, this message translates to:
  /// **'Altre sezioni'**
  String get appDrawerOtherSectionsTitle;

  /// No description provided for @appDrawerPrimoSoccorso.
  ///
  /// In it, this message translates to:
  /// **'Primo Soccorso'**
  String get appDrawerPrimoSoccorso;

  /// No description provided for @appDrawerRemindersSuspended.
  ///
  /// In it, this message translates to:
  /// **'Solleciti sospesi'**
  String get appDrawerRemindersSuspended;

  /// No description provided for @appDrawerRifiuti.
  ///
  /// In it, this message translates to:
  /// **'Rifiuti'**
  String get appDrawerRifiuti;

  /// No description provided for @appDrawerScaffalature.
  ///
  /// In it, this message translates to:
  /// **'Scaffalature'**
  String get appDrawerScaffalature;

  /// No description provided for @appDrawerScale.
  ///
  /// In it, this message translates to:
  /// **'Scale'**
  String get appDrawerScale;

  /// No description provided for @appDrawerSegnaleticaSicurezza.
  ///
  /// In it, this message translates to:
  /// **'Segnaletica Sicurezza'**
  String get appDrawerSegnaleticaSicurezza;

  /// No description provided for @appDrawerShowSubsections.
  ///
  /// In it, this message translates to:
  /// **'Mostra sottosezioni'**
  String get appDrawerShowSubsections;

  /// No description provided for @appDrawerSubappaltatori.
  ///
  /// In it, this message translates to:
  /// **'Subappaltatori'**
  String get appDrawerSubappaltatori;

  /// No description provided for @appDrawerSuspendReminderSubtitle.
  ///
  /// In it, this message translates to:
  /// **'Per i periodi di chiusura aziendale'**
  String get appDrawerSuspendReminderSubtitle;

  /// No description provided for @appDrawerSuspendReminders.
  ///
  /// In it, this message translates to:
  /// **'Sospendi solleciti'**
  String get appDrawerSuspendReminders;

  /// No description provided for @appDrawerSuspendedUntil.
  ///
  /// In it, this message translates to:
  /// **'Fino al {date}'**
  String appDrawerSuspendedUntil(String date);

  /// No description provided for @appDrawerTipiDpi.
  ///
  /// In it, this message translates to:
  /// **'Tipi di DPI'**
  String get appDrawerTipiDpi;

  /// No description provided for @appDrawerTipiScadenze.
  ///
  /// In it, this message translates to:
  /// **'Tipi scadenze'**
  String get appDrawerTipiScadenze;

  /// No description provided for @appDrawerUpcomingDeadlinesTooltip.
  ///
  /// In it, this message translates to:
  /// **'Scadenze imminenti'**
  String get appDrawerUpcomingDeadlinesTooltip;

  /// No description provided for @cantiereCardClosedOn.
  ///
  /// In it, this message translates to:
  /// **'Concluso il {date}'**
  String cantiereCardClosedOn(String date);

  /// No description provided for @cantiereCardDeleteTooltip.
  ///
  /// In it, this message translates to:
  /// **'Elimina cantiere'**
  String get cantiereCardDeleteTooltip;

  /// No description provided for @cantiereCardEditTooltip.
  ///
  /// In it, this message translates to:
  /// **'Modifica cantiere'**
  String get cantiereCardEditTooltip;

  /// No description provided for @cantiereCardExpiringCount.
  ///
  /// In it, this message translates to:
  /// **'{count} in scadenza'**
  String cantiereCardExpiringCount(int count);

  /// No description provided for @cantiereCardSubappaltatoriCount.
  ///
  /// In it, this message translates to:
  /// **'{count, plural, one{{count} subappaltatore} other{{count} subappaltatori}}'**
  String cantiereCardSubappaltatoriCount(int count);

  /// No description provided for @cantiereCardSuspendedLabel.
  ///
  /// In it, this message translates to:
  /// **'SOSPESO'**
  String get cantiereCardSuspendedLabel;

  /// No description provided for @dpiAssegnatoFormDialogAdditionalNotesLabel.
  ///
  /// In it, this message translates to:
  /// **'Note aggiuntive'**
  String get dpiAssegnatoFormDialogAdditionalNotesLabel;

  /// No description provided for @dpiAssegnatoFormDialogAssignTitle.
  ///
  /// In it, this message translates to:
  /// **'Assegna DPI'**
  String get dpiAssegnatoFormDialogAssignTitle;

  /// No description provided for @dpiAssegnatoFormDialogDateInUseLabel.
  ///
  /// In it, this message translates to:
  /// **'Data messa in uso'**
  String get dpiAssegnatoFormDialogDateInUseLabel;

  /// No description provided for @dpiAssegnatoFormDialogDeliveryDateLabel.
  ///
  /// In it, this message translates to:
  /// **'Data consegna'**
  String get dpiAssegnatoFormDialogDeliveryDateLabel;

  /// No description provided for @dpiAssegnatoFormDialogDpiTypeLabel.
  ///
  /// In it, this message translates to:
  /// **'Tipo di DPI*'**
  String get dpiAssegnatoFormDialogDpiTypeLabel;

  /// No description provided for @dpiAssegnatoFormDialogEditTitle.
  ///
  /// In it, this message translates to:
  /// **'Modifica DPI assegnato'**
  String get dpiAssegnatoFormDialogEditTitle;

  /// No description provided for @dpiAssegnatoFormDialogEmployeeLabel.
  ///
  /// In it, this message translates to:
  /// **'Dipendente'**
  String get dpiAssegnatoFormDialogEmployeeLabel;

  /// No description provided for @dpiAssegnatoFormDialogExpiryDateLabel.
  ///
  /// In it, this message translates to:
  /// **'Data scadenza'**
  String get dpiAssegnatoFormDialogExpiryDateLabel;

  /// No description provided for @dpiAssegnatoFormDialogManufactureYearLabel.
  ///
  /// In it, this message translates to:
  /// **'Anno di fabbricazione'**
  String get dpiAssegnatoFormDialogManufactureYearLabel;

  /// No description provided for @dpiAssegnatoFormDialogManufacturerLabel.
  ///
  /// In it, this message translates to:
  /// **'Produttore'**
  String get dpiAssegnatoFormDialogManufacturerLabel;

  /// No description provided for @dpiAssegnatoFormDialogSelectDpiType.
  ///
  /// In it, this message translates to:
  /// **'Seleziona un tipo di DPI'**
  String get dpiAssegnatoFormDialogSelectDpiType;

  /// No description provided for @dpiAssegnatoFormDialogSelectEmployee.
  ///
  /// In it, this message translates to:
  /// **'Seleziona un dipendente'**
  String get dpiAssegnatoFormDialogSelectEmployee;

  /// No description provided for @dpiAssegnatoFormDialogSerialNumberLabel.
  ///
  /// In it, this message translates to:
  /// **'Matricola'**
  String get dpiAssegnatoFormDialogSerialNumberLabel;

  /// No description provided for @dpiAssegnatoFormDialogSizeLabel.
  ///
  /// In it, this message translates to:
  /// **'Taglia'**
  String get dpiAssegnatoFormDialogSizeLabel;

  /// No description provided for @fasciaCatenaFormDialogAdditionalNotesLabel.
  ///
  /// In it, this message translates to:
  /// **'Note aggiuntive'**
  String get fasciaCatenaFormDialogAdditionalNotesLabel;

  /// No description provided for @fasciaCatenaFormDialogBrowse.
  ///
  /// In it, this message translates to:
  /// **'Sfoglia'**
  String get fasciaCatenaFormDialogBrowse;

  /// No description provided for @fasciaCatenaFormDialogCapacityLabel.
  ///
  /// In it, this message translates to:
  /// **'Portata (Kg)'**
  String get fasciaCatenaFormDialogCapacityLabel;

  /// No description provided for @fasciaCatenaFormDialogChangePhoto.
  ///
  /// In it, this message translates to:
  /// **'Cambia foto'**
  String get fasciaCatenaFormDialogChangePhoto;

  /// No description provided for @fasciaCatenaFormDialogCharacteristicsSection.
  ///
  /// In it, this message translates to:
  /// **'Caratteristiche'**
  String get fasciaCatenaFormDialogCharacteristicsSection;

  /// No description provided for @fasciaCatenaFormDialogCheckPassedLabel.
  ///
  /// In it, this message translates to:
  /// **'Esito verifica positivo'**
  String get fasciaCatenaFormDialogCheckPassedLabel;

  /// No description provided for @fasciaCatenaFormDialogColorLabel.
  ///
  /// In it, this message translates to:
  /// **'Colore'**
  String get fasciaCatenaFormDialogColorLabel;

  /// No description provided for @fasciaCatenaFormDialogDiameterLabel.
  ///
  /// In it, this message translates to:
  /// **'Diametro (mm)'**
  String get fasciaCatenaFormDialogDiameterLabel;

  /// No description provided for @fasciaCatenaFormDialogDragPhotoHint.
  ///
  /// In it, this message translates to:
  /// **'Trascina qui la foto della fascia/catena'**
  String get fasciaCatenaFormDialogDragPhotoHint;

  /// No description provided for @fasciaCatenaFormDialogEditTitle.
  ///
  /// In it, this message translates to:
  /// **'Modifica fascia/catena'**
  String get fasciaCatenaFormDialogEditTitle;

  /// No description provided for @fasciaCatenaFormDialogFileFormatsHint.
  ///
  /// In it, this message translates to:
  /// **'JPG, PNG o WEBP - max 5 MB'**
  String get fasciaCatenaFormDialogFileFormatsHint;

  /// No description provided for @fasciaCatenaFormDialogFitForUse.
  ///
  /// In it, this message translates to:
  /// **'Idonea all\'uso'**
  String get fasciaCatenaFormDialogFitForUse;

  /// No description provided for @fasciaCatenaFormDialogImageTooLarge.
  ///
  /// In it, this message translates to:
  /// **'Immagine troppo grande (max 5 MB)'**
  String get fasciaCatenaFormDialogImageTooLarge;

  /// No description provided for @fasciaCatenaFormDialogImageUnavailable.
  ///
  /// In it, this message translates to:
  /// **'Immagine non disponibile'**
  String get fasciaCatenaFormDialogImageUnavailable;

  /// No description provided for @fasciaCatenaFormDialogInternalCheckSection.
  ///
  /// In it, this message translates to:
  /// **'Verifica interna'**
  String get fasciaCatenaFormDialogInternalCheckSection;

  /// No description provided for @fasciaCatenaFormDialogInternalIdLabel.
  ///
  /// In it, this message translates to:
  /// **'ID interno*'**
  String get fasciaCatenaFormDialogInternalIdLabel;

  /// No description provided for @fasciaCatenaFormDialogInvalidExtension.
  ///
  /// In it, this message translates to:
  /// **'Estensione non ammessa (.{extension})'**
  String fasciaCatenaFormDialogInvalidExtension(String extension);

  /// No description provided for @fasciaCatenaFormDialogLastInternalCheckLabel.
  ///
  /// In it, this message translates to:
  /// **'Ultima verifica interna'**
  String get fasciaCatenaFormDialogLastInternalCheckLabel;

  /// No description provided for @fasciaCatenaFormDialogLengthLabel.
  ///
  /// In it, this message translates to:
  /// **'Lunghezza (m)'**
  String get fasciaCatenaFormDialogLengthLabel;

  /// No description provided for @fasciaCatenaFormDialogLocationNotSpecified.
  ///
  /// In it, this message translates to:
  /// **'Non specificata'**
  String get fasciaCatenaFormDialogLocationNotSpecified;

  /// No description provided for @fasciaCatenaFormDialogLocationSection.
  ///
  /// In it, this message translates to:
  /// **'Ubicazione'**
  String get fasciaCatenaFormDialogLocationSection;

  /// No description provided for @fasciaCatenaFormDialogLocationTypeLabel.
  ///
  /// In it, this message translates to:
  /// **'Tipo ubicazione'**
  String get fasciaCatenaFormDialogLocationTypeLabel;

  /// No description provided for @fasciaCatenaFormDialogNewTitle.
  ///
  /// In it, this message translates to:
  /// **'Nuova fascia/catena'**
  String get fasciaCatenaFormDialogNewTitle;

  /// No description provided for @fasciaCatenaFormDialogNextCheckLabel.
  ///
  /// In it, this message translates to:
  /// **'Prossima verifica'**
  String get fasciaCatenaFormDialogNextCheckLabel;

  /// No description provided for @fasciaCatenaFormDialogNotFitForUse.
  ///
  /// In it, this message translates to:
  /// **'Non idonea: da mettere fuori servizio'**
  String get fasciaCatenaFormDialogNotFitForUse;

  /// No description provided for @fasciaCatenaFormDialogPhotoSection.
  ///
  /// In it, this message translates to:
  /// **'Foto'**
  String get fasciaCatenaFormDialogPhotoSection;

  /// No description provided for @fasciaCatenaFormDialogPurchaseDateLabel.
  ///
  /// In it, this message translates to:
  /// **'Data di acquisto'**
  String get fasciaCatenaFormDialogPurchaseDateLabel;

  /// No description provided for @fasciaCatenaFormDialogPurchaseLocationLabel.
  ///
  /// In it, this message translates to:
  /// **'Luogo di acquisto'**
  String get fasciaCatenaFormDialogPurchaseLocationLabel;

  /// No description provided for @fasciaCatenaFormDialogPurchaseSection.
  ///
  /// In it, this message translates to:
  /// **'Acquisto'**
  String get fasciaCatenaFormDialogPurchaseSection;

  /// No description provided for @fasciaCatenaFormDialogRatchetLabel.
  ///
  /// In it, this message translates to:
  /// **'Cricchetto'**
  String get fasciaCatenaFormDialogRatchetLabel;

  /// No description provided for @fasciaCatenaFormDialogRegistrySection.
  ///
  /// In it, this message translates to:
  /// **'Anagrafica'**
  String get fasciaCatenaFormDialogRegistrySection;

  /// No description provided for @fasciaCatenaFormDialogRemove.
  ///
  /// In it, this message translates to:
  /// **'Rimuovi'**
  String get fasciaCatenaFormDialogRemove;

  /// No description provided for @fasciaCatenaFormDialogSelectSite.
  ///
  /// In it, this message translates to:
  /// **'Seleziona un cantiere'**
  String get fasciaCatenaFormDialogSelectSite;

  /// No description provided for @fasciaCatenaFormDialogSelectVehicle.
  ///
  /// In it, this message translates to:
  /// **'Seleziona un automezzo'**
  String get fasciaCatenaFormDialogSelectVehicle;

  /// No description provided for @fasciaCatenaFormDialogSerialNumberLabel.
  ///
  /// In it, this message translates to:
  /// **'Numero di serie produttore'**
  String get fasciaCatenaFormDialogSerialNumberLabel;

  /// No description provided for @fasciaCatenaFormDialogSiteOption.
  ///
  /// In it, this message translates to:
  /// **'Cantiere'**
  String get fasciaCatenaFormDialogSiteOption;

  /// No description provided for @fasciaCatenaFormDialogThicknessLabel.
  ///
  /// In it, this message translates to:
  /// **'Spessore (mm)'**
  String get fasciaCatenaFormDialogThicknessLabel;

  /// No description provided for @fasciaCatenaFormDialogTypeLabel.
  ///
  /// In it, this message translates to:
  /// **'Tipo'**
  String get fasciaCatenaFormDialogTypeLabel;

  /// No description provided for @fasciaCatenaFormDialogTypeNotSpecified.
  ///
  /// In it, this message translates to:
  /// **'Non specificato'**
  String get fasciaCatenaFormDialogTypeNotSpecified;

  /// No description provided for @fasciaCatenaFormDialogVehicleOption.
  ///
  /// In it, this message translates to:
  /// **'Automezzo'**
  String get fasciaCatenaFormDialogVehicleOption;

  /// No description provided for @fasciaCatenaFormDialogWarehouseOption.
  ///
  /// In it, this message translates to:
  /// **'Magazzino'**
  String get fasciaCatenaFormDialogWarehouseOption;

  /// No description provided for @fasciaCatenaFormDialogWidthLabel.
  ///
  /// In it, this message translates to:
  /// **'Larghezza (mm)'**
  String get fasciaCatenaFormDialogWidthLabel;

  /// No description provided for @notaDipendenteAziendaleDialogTitle.
  ///
  /// In it, this message translates to:
  /// **'Nota — {nome} {cognome}'**
  String notaDipendenteAziendaleDialogTitle(String nome, String cognome);

  /// No description provided for @notaDipendenteAziendaleDialogTitleConTipo.
  ///
  /// In it, this message translates to:
  /// **'Nota — {nome} {cognome} — {tipo}'**
  String notaDipendenteAziendaleDialogTitleConTipo(
    String nome,
    String cognome,
    String tipo,
  );

  /// No description provided for @notaEstintoreDialogTitle.
  ///
  /// In it, this message translates to:
  /// **'Nota — {matricola} — {tipo}'**
  String notaEstintoreDialogTitle(String matricola, String tipo);

  /// No description provided for @notaScaffalaturaDialogTitle.
  ///
  /// In it, this message translates to:
  /// **'Nota — Scaffalatura #{id} — {tipo}'**
  String notaScaffalaturaDialogTitle(String id, String tipo);

  /// No description provided for @scadenzeImminentiScreenAerialPlatformsDeadline.
  ///
  /// In it, this message translates to:
  /// **'Scadenza Piattaforme elevatrici'**
  String get scadenzeImminentiScreenAerialPlatformsDeadline;

  /// No description provided for @scadenzeImminentiScreenAnnualCheck.
  ///
  /// In it, this message translates to:
  /// **'Verifica annuale'**
  String get scadenzeImminentiScreenAnnualCheck;

  /// No description provided for @scadenzeImminentiScreenAnnualMaintenance.
  ///
  /// In it, this message translates to:
  /// **'Manutenzione annuale'**
  String get scadenzeImminentiScreenAnnualMaintenance;

  /// No description provided for @scadenzeImminentiScreenArticleLabel.
  ///
  /// In it, this message translates to:
  /// **'Articolo'**
  String get scadenzeImminentiScreenArticleLabel;

  /// No description provided for @scadenzeImminentiScreenAssigneeLabel.
  ///
  /// In it, this message translates to:
  /// **'Incaricato'**
  String get scadenzeImminentiScreenAssigneeLabel;

  /// No description provided for @scadenzeImminentiScreenCollapseAll.
  ///
  /// In it, this message translates to:
  /// **'Nascondi tutte'**
  String get scadenzeImminentiScreenCollapseAll;

  /// No description provided for @scadenzeImminentiScreenCompanyEmployeesSection.
  ///
  /// In it, this message translates to:
  /// **'Dipendenti aziendali'**
  String get scadenzeImminentiScreenCompanyEmployeesSection;

  /// No description provided for @scadenzeImminentiScreenCompanyLabel.
  ///
  /// In it, this message translates to:
  /// **'Ditta'**
  String get scadenzeImminentiScreenCompanyLabel;

  /// No description provided for @scadenzeImminentiScreenContractDeadline.
  ///
  /// In it, this message translates to:
  /// **'Scadenza Contratto'**
  String get scadenzeImminentiScreenContractDeadline;

  /// No description provided for @scadenzeImminentiScreenDeadlineNoteLabel.
  ///
  /// In it, this message translates to:
  /// **'Nota scadenza'**
  String get scadenzeImminentiScreenDeadlineNoteLabel;

  /// No description provided for @scadenzeImminentiScreenDigitalSignatureDeadline.
  ///
  /// In it, this message translates to:
  /// **'Scadenza Firma Digitale'**
  String get scadenzeImminentiScreenDigitalSignatureDeadline;

  /// No description provided for @scadenzeImminentiScreenDiisocyanatesCourseDeadline.
  ///
  /// In it, this message translates to:
  /// **'Scadenza corso Diisocianati'**
  String get scadenzeImminentiScreenDiisocyanatesCourseDeadline;

  /// No description provided for @scadenzeImminentiScreenDocumentFallback.
  ///
  /// In it, this message translates to:
  /// **'Documento'**
  String get scadenzeImminentiScreenDocumentFallback;

  /// No description provided for @scadenzeImminentiScreenDrivingLicenseDeadline.
  ///
  /// In it, this message translates to:
  /// **'Scadenza Patente'**
  String get scadenzeImminentiScreenDrivingLicenseDeadline;

  /// No description provided for @scadenzeImminentiScreenEditNoteTooltip.
  ///
  /// In it, this message translates to:
  /// **'Modifica nota'**
  String get scadenzeImminentiScreenEditNoteTooltip;

  /// No description provided for @scadenzeImminentiScreenEmployeeLabel.
  ///
  /// In it, this message translates to:
  /// **'Dipendente'**
  String get scadenzeImminentiScreenEmployeeLabel;

  /// No description provided for @scadenzeImminentiScreenExcavatorOperationDeadline.
  ///
  /// In it, this message translates to:
  /// **'Scadenza Conduzione Escavatori'**
  String get scadenzeImminentiScreenExcavatorOperationDeadline;

  /// No description provided for @scadenzeImminentiScreenExpandAll.
  ///
  /// In it, this message translates to:
  /// **'Mostra tutte'**
  String get scadenzeImminentiScreenExpandAll;

  /// No description provided for @scadenzeImminentiScreenExternalCheckDeadline.
  ///
  /// In it, this message translates to:
  /// **'Scadenza Verifica Esterna'**
  String get scadenzeImminentiScreenExternalCheckDeadline;

  /// No description provided for @scadenzeImminentiScreenExternalMaintenanceDeadline.
  ///
  /// In it, this message translates to:
  /// **'Scadenza Manutenzione Esterna'**
  String get scadenzeImminentiScreenExternalMaintenanceDeadline;

  /// No description provided for @scadenzeImminentiScreenFireSafetyDeadline.
  ///
  /// In it, this message translates to:
  /// **'Scadenza Antincendio'**
  String get scadenzeImminentiScreenFireSafetyDeadline;

  /// No description provided for @scadenzeImminentiScreenFirstAidDeadline.
  ///
  /// In it, this message translates to:
  /// **'Scadenza Primo Soccorso'**
  String get scadenzeImminentiScreenFirstAidDeadline;

  /// No description provided for @scadenzeImminentiScreenFirstAidSection.
  ///
  /// In it, this message translates to:
  /// **'Primo soccorso'**
  String get scadenzeImminentiScreenFirstAidSection;

  /// No description provided for @scadenzeImminentiScreenForkliftDeadline.
  ///
  /// In it, this message translates to:
  /// **'Scadenza Carrello elevatore semovente'**
  String get scadenzeImminentiScreenForkliftDeadline;

  /// No description provided for @scadenzeImminentiScreenGeneralDeadlinesSection.
  ///
  /// In it, this message translates to:
  /// **'Scadenze generali'**
  String get scadenzeImminentiScreenGeneralDeadlinesSection;

  /// No description provided for @scadenzeImminentiScreenHazardousWasteCarrierDeadline.
  ///
  /// In it, this message translates to:
  /// **'Scadenza Rifiuti Pericolosi Trasportatore'**
  String get scadenzeImminentiScreenHazardousWasteCarrierDeadline;

  /// No description provided for @scadenzeImminentiScreenHazardousWasteDisposerDeadline.
  ///
  /// In it, this message translates to:
  /// **'Scadenza Rifiuti Pericolosi Smaltitore'**
  String get scadenzeImminentiScreenHazardousWasteDisposerDeadline;

  /// No description provided for @scadenzeImminentiScreenHeightWorkDeadline.
  ///
  /// In it, this message translates to:
  /// **'Scadenza Lavori in Quota'**
  String get scadenzeImminentiScreenHeightWorkDeadline;

  /// No description provided for @scadenzeImminentiScreenHideSectionTooltip.
  ///
  /// In it, this message translates to:
  /// **'Nascondi scadenze'**
  String get scadenzeImminentiScreenHideSectionTooltip;

  /// No description provided for @scadenzeImminentiScreenIdCardDeadline.
  ///
  /// In it, this message translates to:
  /// **'Scadenza Carta Identità'**
  String get scadenzeImminentiScreenIdCardDeadline;

  /// No description provided for @scadenzeImminentiScreenInspectionDeadline.
  ///
  /// In it, this message translates to:
  /// **'Scadenza Revisione'**
  String get scadenzeImminentiScreenInspectionDeadline;

  /// No description provided for @scadenzeImminentiScreenInsuranceDeadline.
  ///
  /// In it, this message translates to:
  /// **'Scadenza Assicurazione'**
  String get scadenzeImminentiScreenInsuranceDeadline;

  /// No description provided for @scadenzeImminentiScreenInternalMaintenanceDeadline.
  ///
  /// In it, this message translates to:
  /// **'Scadenza Manutenzione Interna'**
  String get scadenzeImminentiScreenInternalMaintenanceDeadline;

  /// No description provided for @scadenzeImminentiScreenLadderCodeLabel.
  ///
  /// In it, this message translates to:
  /// **'Codice scala'**
  String get scadenzeImminentiScreenLadderCodeLabel;

  /// No description provided for @scadenzeImminentiScreenLastCheckLabel.
  ///
  /// In it, this message translates to:
  /// **'Ultima verifica'**
  String get scadenzeImminentiScreenLastCheckLabel;

  /// No description provided for @scadenzeImminentiScreenLeaseRentalDeadline.
  ///
  /// In it, this message translates to:
  /// **'Scadenza Noleggio/Leasing'**
  String get scadenzeImminentiScreenLeaseRentalDeadline;

  /// No description provided for @scadenzeImminentiScreenLocationInOfficeLower.
  ///
  /// In it, this message translates to:
  /// **'in Ufficio'**
  String get scadenzeImminentiScreenLocationInOfficeLower;

  /// No description provided for @scadenzeImminentiScreenLocationInWarehouseLower.
  ///
  /// In it, this message translates to:
  /// **'in Magazzino'**
  String get scadenzeImminentiScreenLocationInWarehouseLower;

  /// No description provided for @scadenzeImminentiScreenLocationLabel.
  ///
  /// In it, this message translates to:
  /// **'Ubicazione'**
  String get scadenzeImminentiScreenLocationLabel;

  /// No description provided for @scadenzeImminentiScreenLocationNotSpecified.
  ///
  /// In it, this message translates to:
  /// **'Non specificata'**
  String get scadenzeImminentiScreenLocationNotSpecified;

  /// No description provided for @scadenzeImminentiScreenLocationNotSpecifiedLower.
  ///
  /// In it, this message translates to:
  /// **'non specificata'**
  String get scadenzeImminentiScreenLocationNotSpecifiedLower;

  /// No description provided for @scadenzeImminentiScreenLocationOffice.
  ///
  /// In it, this message translates to:
  /// **'In ufficio'**
  String get scadenzeImminentiScreenLocationOffice;

  /// No description provided for @scadenzeImminentiScreenLocationSite.
  ///
  /// In it, this message translates to:
  /// **'In cantiere {site}'**
  String scadenzeImminentiScreenLocationSite(String site);

  /// No description provided for @scadenzeImminentiScreenLocationVehicle.
  ///
  /// In it, this message translates to:
  /// **'Su automezzo {vehicle}'**
  String scadenzeImminentiScreenLocationVehicle(String vehicle);

  /// No description provided for @scadenzeImminentiScreenLocationWarehouse.
  ///
  /// In it, this message translates to:
  /// **'In magazzino'**
  String get scadenzeImminentiScreenLocationWarehouse;

  /// No description provided for @scadenzeImminentiScreenLorryCraneDeadline.
  ///
  /// In it, this message translates to:
  /// **'Scadenza Gru Autocarro'**
  String get scadenzeImminentiScreenLorryCraneDeadline;

  /// No description provided for @scadenzeImminentiScreenMedicalExamDeadline.
  ///
  /// In it, this message translates to:
  /// **'Scadenza Visita Medica'**
  String get scadenzeImminentiScreenMedicalExamDeadline;

  /// No description provided for @scadenzeImminentiScreenModelLabel.
  ///
  /// In it, this message translates to:
  /// **'Modello'**
  String get scadenzeImminentiScreenModelLabel;

  /// No description provided for @scadenzeImminentiScreenNextCheckLabel.
  ///
  /// In it, this message translates to:
  /// **'Prossimo Controllo'**
  String get scadenzeImminentiScreenNextCheckLabel;

  /// No description provided for @scadenzeImminentiScreenNextExternalCalibration.
  ///
  /// In it, this message translates to:
  /// **'Prossima taratura esterna'**
  String get scadenzeImminentiScreenNextExternalCalibration;

  /// No description provided for @scadenzeImminentiScreenNextInternalCalibration.
  ///
  /// In it, this message translates to:
  /// **'Prossima taratura interna'**
  String get scadenzeImminentiScreenNextInternalCalibration;

  /// No description provided for @scadenzeImminentiScreenNextVerificationLabel.
  ///
  /// In it, this message translates to:
  /// **'Prossima verifica'**
  String get scadenzeImminentiScreenNextVerificationLabel;

  /// No description provided for @scadenzeImminentiScreenNonHazardousWasteCarrierDeadline.
  ///
  /// In it, this message translates to:
  /// **'Scadenza Rifiuti Non Pericolosi Trasportatore'**
  String get scadenzeImminentiScreenNonHazardousWasteCarrierDeadline;

  /// No description provided for @scadenzeImminentiScreenNonHazardousWasteDisposerDeadline.
  ///
  /// In it, this message translates to:
  /// **'Scadenza Rifiuti Non Pericolosi Smaltitore'**
  String get scadenzeImminentiScreenNonHazardousWasteDisposerDeadline;

  /// No description provided for @scadenzeImminentiScreenNoteTitleGeneric.
  ///
  /// In it, this message translates to:
  /// **'Nota — {titolo}'**
  String scadenzeImminentiScreenNoteTitleGeneric(String titolo);

  /// No description provided for @scadenzeImminentiScreenNoteTitleSiteDeadline.
  ///
  /// In it, this message translates to:
  /// **'Nota — {site} — {label}'**
  String scadenzeImminentiScreenNoteTitleSiteDeadline(
    String site,
    String label,
  );

  /// No description provided for @scadenzeImminentiScreenPlateLabel.
  ///
  /// In it, this message translates to:
  /// **'Targa'**
  String get scadenzeImminentiScreenPlateLabel;

  /// No description provided for @scadenzeImminentiScreenProductDeadline.
  ///
  /// In it, this message translates to:
  /// **'Scadenza {product}'**
  String scadenzeImminentiScreenProductDeadline(String product);

  /// No description provided for @scadenzeImminentiScreenReplacement18Years.
  ///
  /// In it, this message translates to:
  /// **'Sostituzione (18 anni)'**
  String get scadenzeImminentiScreenReplacement18Years;

  /// No description provided for @scadenzeImminentiScreenResidencyPermitDeadline.
  ///
  /// In it, this message translates to:
  /// **'Scadenza Permesso di Soggiorno'**
  String get scadenzeImminentiScreenResidencyPermitDeadline;

  /// No description provided for @scadenzeImminentiScreenRlstDeadline.
  ///
  /// In it, this message translates to:
  /// **'Scadenza RLST'**
  String get scadenzeImminentiScreenRlstDeadline;

  /// No description provided for @scadenzeImminentiScreenRoadTaxDeadline.
  ///
  /// In it, this message translates to:
  /// **'Scadenza Bollo'**
  String get scadenzeImminentiScreenRoadTaxDeadline;

  /// No description provided for @scadenzeImminentiScreenRopesChainsCheck.
  ///
  /// In it, this message translates to:
  /// **'Controllo funi/catene'**
  String get scadenzeImminentiScreenRopesChainsCheck;

  /// No description provided for @scadenzeImminentiScreenRsppDeadline.
  ///
  /// In it, this message translates to:
  /// **'Scadenza RSPP'**
  String get scadenzeImminentiScreenRsppDeadline;

  /// No description provided for @scadenzeImminentiScreenSafetyTrainingDeadline.
  ///
  /// In it, this message translates to:
  /// **'Scadenza Formazione Sicurezza'**
  String get scadenzeImminentiScreenSafetyTrainingDeadline;

  /// No description provided for @scadenzeImminentiScreenScaffoldingErectionDeadline.
  ///
  /// In it, this message translates to:
  /// **'Scadenza Montaggio/Smontaggio ponteggi'**
  String get scadenzeImminentiScreenScaffoldingErectionDeadline;

  /// No description provided for @scadenzeImminentiScreenSectionHeaderTitle.
  ///
  /// In it, this message translates to:
  /// **'Scadenze da controllare'**
  String get scadenzeImminentiScreenSectionHeaderTitle;

  /// No description provided for @scadenzeImminentiScreenSerialNumberLabel.
  ///
  /// In it, this message translates to:
  /// **'Matricola'**
  String get scadenzeImminentiScreenSerialNumberLabel;

  /// No description provided for @scadenzeImminentiScreenShelvingCourseDeadline.
  ///
  /// In it, this message translates to:
  /// **'Scadenza corso Scaffalature'**
  String get scadenzeImminentiScreenShelvingCourseDeadline;

  /// No description provided for @scadenzeImminentiScreenShelvingIdLabel.
  ///
  /// In it, this message translates to:
  /// **'ID scaffalatura'**
  String get scadenzeImminentiScreenShelvingIdLabel;

  /// No description provided for @scadenzeImminentiScreenShelvingNextCheckLabel.
  ///
  /// In it, this message translates to:
  /// **'Prossimo controllo scaffalature'**
  String get scadenzeImminentiScreenShelvingNextCheckLabel;

  /// No description provided for @scadenzeImminentiScreenShowSectionTooltip.
  ///
  /// In it, this message translates to:
  /// **'Mostra scadenze'**
  String get scadenzeImminentiScreenShowSectionTooltip;

  /// No description provided for @scadenzeImminentiScreenSiteLabel.
  ///
  /// In it, this message translates to:
  /// **'Cantiere'**
  String get scadenzeImminentiScreenSiteLabel;

  /// No description provided for @scadenzeImminentiScreenSitesPresentLabel.
  ///
  /// In it, this message translates to:
  /// **'Cantieri in cui è presente'**
  String get scadenzeImminentiScreenSitesPresentLabel;

  /// No description provided for @scadenzeImminentiScreenSubcontractorLabel.
  ///
  /// In it, this message translates to:
  /// **'Subappaltatore'**
  String get scadenzeImminentiScreenSubcontractorLabel;

  /// No description provided for @scadenzeImminentiScreenSupervisorDeadline.
  ///
  /// In it, this message translates to:
  /// **'Scadenza Preposto'**
  String get scadenzeImminentiScreenSupervisorDeadline;

  /// No description provided for @scadenzeImminentiScreenTachographCardCompanyDeadline.
  ///
  /// In it, this message translates to:
  /// **'Scadenza Carta Tachigrafica + Azienda'**
  String get scadenzeImminentiScreenTachographCardCompanyDeadline;

  /// No description provided for @scadenzeImminentiScreenTachographCardDeadline.
  ///
  /// In it, this message translates to:
  /// **'Scadenza Carta Tachigrafica'**
  String get scadenzeImminentiScreenTachographCardDeadline;

  /// No description provided for @scadenzeImminentiScreenTachographCourseDeadline.
  ///
  /// In it, this message translates to:
  /// **'Scadenza corso Cronotachigrafico'**
  String get scadenzeImminentiScreenTachographCourseDeadline;

  /// No description provided for @scadenzeImminentiScreenTachographDeadline.
  ///
  /// In it, this message translates to:
  /// **'Scadenza Tachigrafo'**
  String get scadenzeImminentiScreenTachographDeadline;

  /// No description provided for @scadenzeImminentiScreenTaxCodeDeadline.
  ///
  /// In it, this message translates to:
  /// **'Scadenza Codice Fiscale'**
  String get scadenzeImminentiScreenTaxCodeDeadline;

  /// No description provided for @scadenzeImminentiScreenTestingDeadline.
  ///
  /// In it, this message translates to:
  /// **'Scadenza Collaudo'**
  String get scadenzeImminentiScreenTestingDeadline;

  /// No description provided for @scadenzeImminentiScreenTetanusDeadline.
  ///
  /// In it, this message translates to:
  /// **'Scadenza Antitetanica'**
  String get scadenzeImminentiScreenTetanusDeadline;

  /// No description provided for @scadenzeImminentiScreenTitle.
  ///
  /// In it, this message translates to:
  /// **'Scadenze imminenti'**
  String get scadenzeImminentiScreenTitle;

  /// No description provided for @scadenzeImminentiScreenTowerCraneDeadline.
  ///
  /// In it, this message translates to:
  /// **'Scadenza Gru a Torre'**
  String get scadenzeImminentiScreenTowerCraneDeadline;

  /// No description provided for @scadenzeImminentiScreenTwentyYearCheck.
  ///
  /// In it, this message translates to:
  /// **'Verifica ventennale'**
  String get scadenzeImminentiScreenTwentyYearCheck;

  /// No description provided for @scadenzeImminentiScreenTypeLabel.
  ///
  /// In it, this message translates to:
  /// **'Tipologia'**
  String get scadenzeImminentiScreenTypeLabel;

  /// No description provided for @scadenzeImminentiScreenVehicleLabel.
  ///
  /// In it, this message translates to:
  /// **'Veicolo'**
  String get scadenzeImminentiScreenVehicleLabel;

  /// No description provided for @subappaltatoreDocumentiScreenAddEmployeeLabel.
  ///
  /// In it, this message translates to:
  /// **'Inserisci dipendente'**
  String get subappaltatoreDocumentiScreenAddEmployeeLabel;

  /// No description provided for @subappaltatoreDocumentiScreenAddGeneralDeadlineLabel.
  ///
  /// In it, this message translates to:
  /// **'Inserisci scadenza generale'**
  String get subappaltatoreDocumentiScreenAddGeneralDeadlineLabel;

  /// No description provided for @subappaltatoreDocumentiScreenAssociatedSitesLabel.
  ///
  /// In it, this message translates to:
  /// **'Cantieri associati'**
  String get subappaltatoreDocumentiScreenAssociatedSitesLabel;

  /// No description provided for @subappaltatoreDocumentiScreenBreadcrumbCantieri.
  ///
  /// In it, this message translates to:
  /// **'Cantieri'**
  String get subappaltatoreDocumentiScreenBreadcrumbCantieri;

  /// No description provided for @subappaltatoreDocumentiScreenBreadcrumbSubappaltatori.
  ///
  /// In it, this message translates to:
  /// **'Subappaltatori'**
  String get subappaltatoreDocumentiScreenBreadcrumbSubappaltatori;

  /// No description provided for @subappaltatoreDocumentiScreenDeleteEmployeeConfirm.
  ///
  /// In it, this message translates to:
  /// **'Eliminare \"{nome}\"?'**
  String subappaltatoreDocumentiScreenDeleteEmployeeConfirm(String nome);

  /// No description provided for @subappaltatoreDocumentiScreenDeleteEmployeeNoDocs.
  ///
  /// In it, this message translates to:
  /// **'Il suo nome sparirà dai cantieri in cui risulta presente.'**
  String get subappaltatoreDocumentiScreenDeleteEmployeeNoDocs;

  /// No description provided for @subappaltatoreDocumentiScreenDeleteEmployeeTitle.
  ///
  /// In it, this message translates to:
  /// **'Eliminare il dipendente?'**
  String get subappaltatoreDocumentiScreenDeleteEmployeeTitle;

  /// No description provided for @subappaltatoreDocumentiScreenDeleteEmployeeTooltip.
  ///
  /// In it, this message translates to:
  /// **'Elimina dipendente'**
  String get subappaltatoreDocumentiScreenDeleteEmployeeTooltip;

  /// No description provided for @subappaltatoreDocumentiScreenDeleteEmployeeWithDocs.
  ///
  /// In it, this message translates to:
  /// **'Verranno eliminate anche le sue {count} scadenze (storico compreso) e il suo nome sparirà dai cantieri in cui risulta presente.'**
  String subappaltatoreDocumentiScreenDeleteEmployeeWithDocs(int count);

  /// No description provided for @subappaltatoreDocumentiScreenDocsInOrder.
  ///
  /// In it, this message translates to:
  /// **'Documenti in regola'**
  String get subappaltatoreDocumentiScreenDocsInOrder;

  /// No description provided for @subappaltatoreDocumentiScreenEmailLabel.
  ///
  /// In it, this message translates to:
  /// **'Email'**
  String get subappaltatoreDocumentiScreenEmailLabel;

  /// No description provided for @subappaltatoreDocumentiScreenEmployeesLabel.
  ///
  /// In it, this message translates to:
  /// **'Dipendenti'**
  String get subappaltatoreDocumentiScreenEmployeesLabel;

  /// No description provided for @subappaltatoreDocumentiScreenGeneralDeadlinesLabel.
  ///
  /// In it, this message translates to:
  /// **'Scadenze generali'**
  String get subappaltatoreDocumentiScreenGeneralDeadlinesLabel;

  /// No description provided for @subappaltatoreDocumentiScreenInfoLabel.
  ///
  /// In it, this message translates to:
  /// **'Informazioni:'**
  String get subappaltatoreDocumentiScreenInfoLabel;

  /// No description provided for @subappaltatoreDocumentiScreenIrreversible.
  ///
  /// In it, this message translates to:
  /// **'L\'operazione non è reversibile.'**
  String get subappaltatoreDocumentiScreenIrreversible;

  /// No description provided for @subappaltatoreDocumentiScreenNewGeneralDeadlineTooltip.
  ///
  /// In it, this message translates to:
  /// **'Nuova scadenza generale'**
  String get subappaltatoreDocumentiScreenNewGeneralDeadlineTooltip;

  /// No description provided for @subappaltatoreDocumentiScreenNoDeadlinesForSite.
  ///
  /// In it, this message translates to:
  /// **'Nessuna scadenza per questo cantiere.'**
  String get subappaltatoreDocumentiScreenNoDeadlinesForSite;

  /// No description provided for @subappaltatoreDocumentiScreenNoDeadlinesRegistered.
  ///
  /// In it, this message translates to:
  /// **'Nessuna scadenza registrata'**
  String get subappaltatoreDocumentiScreenNoDeadlinesRegistered;

  /// No description provided for @subappaltatoreDocumentiScreenNoEmployees.
  ///
  /// In it, this message translates to:
  /// **'Nessun dipendente inserito per questo subappaltatore.'**
  String get subappaltatoreDocumentiScreenNoEmployees;

  /// No description provided for @subappaltatoreDocumentiScreenNoGeneralDeadlines.
  ///
  /// In it, this message translates to:
  /// **'Nessuna scadenza generale inserita per questo subappaltatore.'**
  String get subappaltatoreDocumentiScreenNoGeneralDeadlines;

  /// No description provided for @subappaltatoreDocumentiScreenOpenSiteTooltip.
  ///
  /// In it, this message translates to:
  /// **'Apri cantiere'**
  String get subappaltatoreDocumentiScreenOpenSiteTooltip;

  /// No description provided for @subappaltatoreDocumentiScreenSelfEmployed.
  ///
  /// In it, this message translates to:
  /// **'Lavoratore autonomo'**
  String get subappaltatoreDocumentiScreenSelfEmployed;

  /// No description provided for @subappaltatoreDocumentiScreenSiteIndexTitle.
  ///
  /// In it, this message translates to:
  /// **'{index}) {nome}'**
  String subappaltatoreDocumentiScreenSiteIndexTitle(int index, String nome);

  /// No description provided for @subappaltatoreDocumentiScreenTypeLabel.
  ///
  /// In it, this message translates to:
  /// **'Tipo'**
  String get subappaltatoreDocumentiScreenTypeLabel;

  /// No description provided for @subappaltatoreDocumentiScreenVatLabel.
  ///
  /// In it, this message translates to:
  /// **'P. IVA'**
  String get subappaltatoreDocumentiScreenVatLabel;

  /// No description provided for @tipiDpiScreenBreadcrumbDpi.
  ///
  /// In it, this message translates to:
  /// **'DPI'**
  String get tipiDpiScreenBreadcrumbDpi;

  /// No description provided for @tipiDpiScreenBreadcrumbTipiDpi.
  ///
  /// In it, this message translates to:
  /// **'Tipi di DPI'**
  String get tipiDpiScreenBreadcrumbTipiDpi;

  /// No description provided for @tipiDpiScreenDeleteConfirmMessage.
  ///
  /// In it, this message translates to:
  /// **'Eliminare la tipologia di DPI {nome}? L\'operazione non è reversibile.'**
  String tipiDpiScreenDeleteConfirmMessage(String nome);

  /// No description provided for @tipiDpiScreenDeleteConfirmTitle.
  ///
  /// In it, this message translates to:
  /// **'Eliminare la tipologia?'**
  String get tipiDpiScreenDeleteConfirmTitle;

  /// No description provided for @tipiDpiScreenDeleteTooltip.
  ///
  /// In it, this message translates to:
  /// **'Elimina tipologia'**
  String get tipiDpiScreenDeleteTooltip;

  /// No description provided for @tipiDpiScreenEditTooltip.
  ///
  /// In it, this message translates to:
  /// **'Modifica tipologia'**
  String get tipiDpiScreenEditTooltip;

  /// No description provided for @tipiDpiScreenEmptyState.
  ///
  /// In it, this message translates to:
  /// **'Nessun DPI inserito.'**
  String get tipiDpiScreenEmptyState;

  /// No description provided for @tipiDpiScreenForHeightWork.
  ///
  /// In it, this message translates to:
  /// **'Per lavori in quota'**
  String get tipiDpiScreenForHeightWork;

  /// No description provided for @tipiDpiScreenNewDpiLabel.
  ///
  /// In it, this message translates to:
  /// **'Nuovo DPI'**
  String get tipiDpiScreenNewDpiLabel;

  /// No description provided for @tipiDpiScreenNoteLabel.
  ///
  /// In it, this message translates to:
  /// **'Nota: {note}'**
  String tipiDpiScreenNoteLabel(String note);

  /// No description provided for @campoDataClearDateTooltip.
  ///
  /// In it, this message translates to:
  /// **'Rimuovi data'**
  String get campoDataClearDateTooltip;

  /// No description provided for @campoDataFormatHint.
  ///
  /// In it, this message translates to:
  /// **'gg/mm/aaaa'**
  String get campoDataFormatHint;

  /// No description provided for @campoDataInvalidDate.
  ///
  /// In it, this message translates to:
  /// **'Data non valida'**
  String get campoDataInvalidDate;

  /// No description provided for @campoDataPickDateTooltip.
  ///
  /// In it, this message translates to:
  /// **'Seleziona data'**
  String get campoDataPickDateTooltip;

  /// No description provided for @campoDataRemoveFieldTooltip.
  ///
  /// In it, this message translates to:
  /// **'Rimuovi campo'**
  String get campoDataRemoveFieldTooltip;

  /// No description provided for @campoDataYearRange.
  ///
  /// In it, this message translates to:
  /// **'Anno tra {min} e {max}'**
  String campoDataYearRange(int min, int max);

  /// No description provided for @creaDpiFormDialogAdditionalNotesLabel.
  ///
  /// In it, this message translates to:
  /// **'Note aggiuntive'**
  String get creaDpiFormDialogAdditionalNotesLabel;

  /// No description provided for @creaDpiFormDialogHeightWorkRequired.
  ///
  /// In it, this message translates to:
  /// **'Necessario per lavori in quota'**
  String get creaDpiFormDialogHeightWorkRequired;

  /// No description provided for @creaDpiFormDialogHeightWorkSubtitle.
  ///
  /// In it, this message translates to:
  /// **'Richiesto automaticamente agli operai (M04) con scadenza lavori in quota impostata'**
  String get creaDpiFormDialogHeightWorkSubtitle;

  /// No description provided for @creaDpiFormDialogNameLabel.
  ///
  /// In it, this message translates to:
  /// **'Nome*'**
  String get creaDpiFormDialogNameLabel;

  /// No description provided for @creaDpiFormDialogNoticeDaysHint.
  ///
  /// In it, this message translates to:
  /// **'30, 7, 1'**
  String get creaDpiFormDialogNoticeDaysHint;

  /// No description provided for @creaDpiFormDialogNoticeDaysLabel.
  ///
  /// In it, this message translates to:
  /// **'Giorni di Preavviso'**
  String get creaDpiFormDialogNoticeDaysLabel;

  /// No description provided for @creaDpiFormDialogTitleEdit.
  ///
  /// In it, this message translates to:
  /// **'Modifica DPI'**
  String get creaDpiFormDialogTitleEdit;

  /// No description provided for @creaDpiFormDialogTitleNew.
  ///
  /// In it, this message translates to:
  /// **'Nuovo DPI'**
  String get creaDpiFormDialogTitleNew;

  /// No description provided for @scadenzaCantiereTileConfirmDeleteMessage.
  ///
  /// In it, this message translates to:
  /// **'Eliminare {etichetta} da {cantiere}? L\'operazione non è reversibile.'**
  String scadenzaCantiereTileConfirmDeleteMessage(
    String etichetta,
    String cantiere,
  );

  /// No description provided for @scadenzaCantiereTileConfirmDeleteTitle.
  ///
  /// In it, this message translates to:
  /// **'Eliminare la scadenza?'**
  String get scadenzaCantiereTileConfirmDeleteTitle;

  /// No description provided for @scadenzaCantiereTileDeleteTooltip.
  ///
  /// In it, this message translates to:
  /// **'Elimina scadenza'**
  String get scadenzaCantiereTileDeleteTooltip;

  /// No description provided for @scadenzaCantiereTileDueDate.
  ///
  /// In it, this message translates to:
  /// **'Scadenza: {date}'**
  String scadenzaCantiereTileDueDate(String date);

  /// No description provided for @scadenzaCantiereTileEditTooltip.
  ///
  /// In it, this message translates to:
  /// **'Modifica scadenza'**
  String get scadenzaCantiereTileEditTooltip;

  /// No description provided for @scadenzaCantiereTileNotesLine.
  ///
  /// In it, this message translates to:
  /// **'Note: {note}'**
  String scadenzaCantiereTileNotesLine(String note);

  /// No description provided for @notaRifiutoDialogTitle.
  ///
  /// In it, this message translates to:
  /// **'Nota — {nomeDitta} — {tipo}'**
  String notaRifiutoDialogTitle(String nomeDitta, String tipo);

  /// No description provided for @notaScadenzaScalaDialogTitle.
  ///
  /// In it, this message translates to:
  /// **'Nota — Scala {codice}'**
  String notaScadenzaScalaDialogTitle(String codice);

  /// No description provided for @notaScadenzaDocumentoDialogDefaultType.
  ///
  /// In it, this message translates to:
  /// **'documento'**
  String get notaScadenzaDocumentoDialogDefaultType;

  /// No description provided for @notaScadenzaDocumentoDialogTitle.
  ///
  /// In it, this message translates to:
  /// **'Nota — {tipo}'**
  String notaScadenzaDocumentoDialogTitle(String tipo);

  /// No description provided for @creaSegnaleFormDialogBrowse.
  ///
  /// In it, this message translates to:
  /// **'Sfoglia'**
  String get creaSegnaleFormDialogBrowse;

  /// No description provided for @creaSegnaleFormDialogChangeImage.
  ///
  /// In it, this message translates to:
  /// **'Cambia immagine'**
  String get creaSegnaleFormDialogChangeImage;

  /// No description provided for @creaSegnaleFormDialogDragDropText.
  ///
  /// In it, this message translates to:
  /// **'Trascina qui l\'immagine del cartello'**
  String get creaSegnaleFormDialogDragDropText;

  /// No description provided for @creaSegnaleFormDialogExtensionNotAllowed.
  ///
  /// In it, this message translates to:
  /// **'Estensione non ammessa (.{estensione})'**
  String creaSegnaleFormDialogExtensionNotAllowed(String estensione);

  /// No description provided for @creaSegnaleFormDialogFileTooLarge.
  ///
  /// In it, this message translates to:
  /// **'Immagine troppo grande (max 5 MB)'**
  String get creaSegnaleFormDialogFileTooLarge;

  /// No description provided for @creaSegnaleFormDialogFileTypesHint.
  ///
  /// In it, this message translates to:
  /// **'JPG, PNG o WEBP - max 5 MB'**
  String get creaSegnaleFormDialogFileTypesHint;

  /// No description provided for @creaSegnaleFormDialogImageSectionTitle.
  ///
  /// In it, this message translates to:
  /// **'Immagine del cartello'**
  String get creaSegnaleFormDialogImageSectionTitle;

  /// No description provided for @creaSegnaleFormDialogImageUnavailable.
  ///
  /// In it, this message translates to:
  /// **'Immagine non disponibile'**
  String get creaSegnaleFormDialogImageUnavailable;

  /// No description provided for @creaSegnaleFormDialogLocationHint.
  ///
  /// In it, this message translates to:
  /// **'Es. corridoio ingresso, lato nord'**
  String get creaSegnaleFormDialogLocationHint;

  /// No description provided for @creaSegnaleFormDialogLocationLabel.
  ///
  /// In it, this message translates to:
  /// **'Ubicazione'**
  String get creaSegnaleFormDialogLocationLabel;

  /// No description provided for @creaSegnaleFormDialogNameLabel.
  ///
  /// In it, this message translates to:
  /// **'Nome*'**
  String get creaSegnaleFormDialogNameLabel;

  /// No description provided for @creaSegnaleFormDialogRemoveImage.
  ///
  /// In it, this message translates to:
  /// **'Rimuovi'**
  String get creaSegnaleFormDialogRemoveImage;

  /// No description provided for @creaSegnaleFormDialogTitleEdit.
  ///
  /// In it, this message translates to:
  /// **'Modifica cartello'**
  String get creaSegnaleFormDialogTitleEdit;

  /// No description provided for @creaSegnaleFormDialogTitleNew.
  ///
  /// In it, this message translates to:
  /// **'Nuovo cartello'**
  String get creaSegnaleFormDialogTitleNew;

  /// No description provided for @creaSegnaleFormDialogZoneLabel.
  ///
  /// In it, this message translates to:
  /// **'Zona'**
  String get creaSegnaleFormDialogZoneLabel;

  /// No description provided for @creaSegnaleFormDialogZoneOffice.
  ///
  /// In it, this message translates to:
  /// **'Ufficio'**
  String get creaSegnaleFormDialogZoneOffice;

  /// No description provided for @creaSegnaleFormDialogZoneUnspecified.
  ///
  /// In it, this message translates to:
  /// **'Non specificata'**
  String get creaSegnaleFormDialogZoneUnspecified;

  /// No description provided for @creaSegnaleFormDialogZoneWarehouse.
  ///
  /// In it, this message translates to:
  /// **'Magazzino'**
  String get creaSegnaleFormDialogZoneWarehouse;

  /// No description provided for @subappaltatoriScreenConfirmDeleteMessage.
  ///
  /// In it, this message translates to:
  /// **'Eliminare \"{nome}\"? L\'operazione non è reversibile.'**
  String subappaltatoriScreenConfirmDeleteMessage(String nome);

  /// No description provided for @subappaltatoriScreenConfirmDeleteTitle.
  ///
  /// In it, this message translates to:
  /// **'Eliminare subappaltatore?'**
  String get subappaltatoriScreenConfirmDeleteTitle;

  /// No description provided for @subappaltatoriScreenDeleteTooltip.
  ///
  /// In it, this message translates to:
  /// **'Elimina subappaltatore'**
  String get subappaltatoriScreenDeleteTooltip;

  /// No description provided for @subappaltatoriScreenEditTooltip.
  ///
  /// In it, this message translates to:
  /// **'Modifica subappaltatore'**
  String get subappaltatoriScreenEditTooltip;

  /// No description provided for @subappaltatoriScreenEmptyLoaded.
  ///
  /// In it, this message translates to:
  /// **'Nessun subappaltatore caricato.'**
  String get subappaltatoriScreenEmptyLoaded;

  /// No description provided for @subappaltatoriScreenEmptySearch.
  ///
  /// In it, this message translates to:
  /// **'Nessun subappaltatore trovato per \"{query}\".'**
  String subappaltatoriScreenEmptySearch(String query);

  /// No description provided for @subappaltatoriScreenNewTooltip.
  ///
  /// In it, this message translates to:
  /// **'Nuovo subappaltatore'**
  String get subappaltatoriScreenNewTooltip;

  /// No description provided for @subappaltatoriScreenNone.
  ///
  /// In it, this message translates to:
  /// **'nessuno'**
  String get subappaltatoriScreenNone;

  /// No description provided for @subappaltatoriScreenSearchHint.
  ///
  /// In it, this message translates to:
  /// **'Cerca per ragione sociale'**
  String get subappaltatoriScreenSearchHint;

  /// No description provided for @subappaltatoriScreenSitesCount.
  ///
  /// In it, this message translates to:
  /// **'Cantieri associati'**
  String get subappaltatoriScreenSitesCount;

  /// No description provided for @subappaltatoriScreenTitle.
  ///
  /// In it, this message translates to:
  /// **'Subappaltatori'**
  String get subappaltatoriScreenTitle;

  /// No description provided for @cantiereDetailScreenAddDeadlineLabel.
  ///
  /// In it, this message translates to:
  /// **'Aggiungi scadenza'**
  String get cantiereDetailScreenAddDeadlineLabel;

  /// No description provided for @cantiereDetailScreenAddSubcontractorLabel.
  ///
  /// In it, this message translates to:
  /// **'Aggiungi subappaltatore'**
  String get cantiereDetailScreenAddSubcontractorLabel;

  /// No description provided for @cantiereDetailScreenAddressLabel.
  ///
  /// In it, this message translates to:
  /// **'Indirizzo'**
  String get cantiereDetailScreenAddressLabel;

  /// No description provided for @cantiereDetailScreenBreadcrumbSites.
  ///
  /// In it, this message translates to:
  /// **'Cantieri'**
  String get cantiereDetailScreenBreadcrumbSites;

  /// No description provided for @cantiereDetailScreenConfirmDeleteMessage.
  ///
  /// In it, this message translates to:
  /// **'Verranno eliminate definitivamente dal server tutte le scadenze di {nome} e quelle dei subappaltatori assegnati a questo cantiere.\nOPERAZIONE IRREVERSIBILE.'**
  String cantiereDetailScreenConfirmDeleteMessage(String nome);

  /// No description provided for @cantiereDetailScreenConfirmDeleteTitle.
  ///
  /// In it, this message translates to:
  /// **'Eliminare le scadenze del cantiere?'**
  String get cantiereDetailScreenConfirmDeleteTitle;

  /// No description provided for @cantiereDetailScreenConfirmRemoveMessage.
  ///
  /// In it, this message translates to:
  /// **'Rimuovere \"{nome}\" da questo cantiere? Il subappaltatore non verrà eliminato, ma le sue scadenze e quelle dei suoi dipendenti non saranno più associati a questo cantiere.'**
  String cantiereDetailScreenConfirmRemoveMessage(String nome);

  /// No description provided for @cantiereDetailScreenConfirmRemoveTitle.
  ///
  /// In it, this message translates to:
  /// **'Rimuovere subappaltatore dal cantiere?'**
  String get cantiereDetailScreenConfirmRemoveTitle;

  /// No description provided for @cantiereDetailScreenDeadlinesTitle.
  ///
  /// In it, this message translates to:
  /// **'Scadenze del cantiere'**
  String get cantiereDetailScreenDeadlinesTitle;

  /// No description provided for @cantiereDetailScreenDeleteDataAction.
  ///
  /// In it, this message translates to:
  /// **'Elimina dati'**
  String get cantiereDetailScreenDeleteDataAction;

  /// No description provided for @cantiereDetailScreenEmployeesPresentLabel.
  ///
  /// In it, this message translates to:
  /// **'Dipendenti presenti'**
  String get cantiereDetailScreenEmployeesPresentLabel;

  /// No description provided for @cantiereDetailScreenEmployeesPresentTooltip.
  ///
  /// In it, this message translates to:
  /// **'Dipendenti presenti in questo cantiere'**
  String get cantiereDetailScreenEmployeesPresentTooltip;

  /// No description provided for @cantiereDetailScreenEndDateLabel.
  ///
  /// In it, this message translates to:
  /// **'Data conclusione'**
  String get cantiereDetailScreenEndDateLabel;

  /// No description provided for @cantiereDetailScreenGeneralDeadlinesTitle.
  ///
  /// In it, this message translates to:
  /// **'Scadenze Generali del cantiere'**
  String get cantiereDetailScreenGeneralDeadlinesTitle;

  /// No description provided for @cantiereDetailScreenInfoSectionTitle.
  ///
  /// In it, this message translates to:
  /// **'Informazioni:'**
  String get cantiereDetailScreenInfoSectionTitle;

  /// No description provided for @cantiereDetailScreenNoDeadlines.
  ///
  /// In it, this message translates to:
  /// **'Nessuna scadenza registrata per questo cantiere.'**
  String get cantiereDetailScreenNoDeadlines;

  /// No description provided for @cantiereDetailScreenNoGeneralDeadlines.
  ///
  /// In it, this message translates to:
  /// **'Nessuna scadenza generica impostata per questo cantiere.'**
  String get cantiereDetailScreenNoGeneralDeadlines;

  /// No description provided for @cantiereDetailScreenNoSubcontractors.
  ///
  /// In it, this message translates to:
  /// **'Nessun subappaltatore associato a questo cantiere.'**
  String get cantiereDetailScreenNoSubcontractors;

  /// No description provided for @cantiereDetailScreenNoneValue.
  ///
  /// In it, this message translates to:
  /// **'nessuno'**
  String get cantiereDetailScreenNoneValue;

  /// No description provided for @cantiereDetailScreenNotSet.
  ///
  /// In it, this message translates to:
  /// **'Non impostata'**
  String get cantiereDetailScreenNotSet;

  /// No description provided for @cantiereDetailScreenPostalCodeLabel.
  ///
  /// In it, this message translates to:
  /// **'CAP'**
  String get cantiereDetailScreenPostalCodeLabel;

  /// No description provided for @cantiereDetailScreenRemoveFromSiteTooltip.
  ///
  /// In it, this message translates to:
  /// **'Rimuovi da questo cantiere'**
  String get cantiereDetailScreenRemoveFromSiteTooltip;

  /// No description provided for @cantiereDetailScreenStartDateLabel.
  ///
  /// In it, this message translates to:
  /// **'Data di inizio'**
  String get cantiereDetailScreenStartDateLabel;

  /// No description provided for @cantiereDetailScreenSubcontractorsTitle.
  ///
  /// In it, this message translates to:
  /// **'Subappaltatori'**
  String get cantiereDetailScreenSubcontractorsTitle;

  /// No description provided for @cantiereDetailScreenSuspensionDateLabel.
  ///
  /// In it, this message translates to:
  /// **'Data sospensione'**
  String get cantiereDetailScreenSuspensionDateLabel;

  /// No description provided for @cantieriScreenActiveSitesTitle.
  ///
  /// In it, this message translates to:
  /// **'Cantieri in corso'**
  String get cantieriScreenActiveSitesTitle;

  /// No description provided for @cantieriScreenArchiveAction.
  ///
  /// In it, this message translates to:
  /// **'Archivio cantieri'**
  String get cantieriScreenArchiveAction;

  /// No description provided for @cantieriScreenConfirmDeleteMessage.
  ///
  /// In it, this message translates to:
  /// **'Eliminare il cantiere {nome}? L\'operazione non è reversibile.'**
  String cantieriScreenConfirmDeleteMessage(String nome);

  /// No description provided for @cantieriScreenConfirmDeleteTitle.
  ///
  /// In it, this message translates to:
  /// **'Eliminare cantiere?'**
  String get cantieriScreenConfirmDeleteTitle;

  /// No description provided for @cantieriScreenDeadlineNoteLabel.
  ///
  /// In it, this message translates to:
  /// **'Nota scadenza'**
  String get cantieriScreenDeadlineNoteLabel;

  /// No description provided for @cantieriScreenDeadlineTypesAction.
  ///
  /// In it, this message translates to:
  /// **'Tipi scadenze'**
  String get cantieriScreenDeadlineTypesAction;

  /// No description provided for @cantieriScreenDefaultDocumentType.
  ///
  /// In it, this message translates to:
  /// **'Documento'**
  String get cantieriScreenDefaultDocumentType;

  /// No description provided for @cantieriScreenEditNoteTooltip.
  ///
  /// In it, this message translates to:
  /// **'Modifica nota'**
  String get cantieriScreenEditNoteTooltip;

  /// No description provided for @cantieriScreenEmployeeLabel.
  ///
  /// In it, this message translates to:
  /// **'Dipendente'**
  String get cantieriScreenEmployeeLabel;

  /// No description provided for @cantieriScreenEmptyAllConcluded.
  ///
  /// In it, this message translates to:
  /// **'Nessun cantiere attivo (tutti conclusi).'**
  String get cantieriScreenEmptyAllConcluded;

  /// No description provided for @cantieriScreenEmptyLoaded.
  ///
  /// In it, this message translates to:
  /// **'Nessun cantiere caricato.'**
  String get cantieriScreenEmptyLoaded;

  /// No description provided for @cantieriScreenEmptySearch.
  ///
  /// In it, this message translates to:
  /// **'Nessun cantiere trovato per \"{query}\".'**
  String cantieriScreenEmptySearch(String query);

  /// No description provided for @cantieriScreenHideDeadlinesTooltip.
  ///
  /// In it, this message translates to:
  /// **'Nascondi scadenze'**
  String get cantieriScreenHideDeadlinesTooltip;

  /// No description provided for @cantieriScreenNewSiteAction.
  ///
  /// In it, this message translates to:
  /// **'Nuovo cantiere'**
  String get cantieriScreenNewSiteAction;

  /// No description provided for @cantieriScreenNoteDialogTitle.
  ///
  /// In it, this message translates to:
  /// **'Nota — {nome} — {etichetta}'**
  String cantieriScreenNoteDialogTitle(String nome, String etichetta);

  /// No description provided for @cantieriScreenSearchHint.
  ///
  /// In it, this message translates to:
  /// **'Cerca per nome o comune'**
  String get cantieriScreenSearchHint;

  /// No description provided for @cantieriScreenShowDeadlinesTooltip.
  ///
  /// In it, this message translates to:
  /// **'Mostra scadenze'**
  String get cantieriScreenShowDeadlinesTooltip;

  /// No description provided for @cantieriScreenSiteDeadlinesGroup.
  ///
  /// In it, this message translates to:
  /// **'Scadenze dei cantieri'**
  String get cantieriScreenSiteDeadlinesGroup;

  /// No description provided for @cantieriScreenSiteLabel.
  ///
  /// In it, this message translates to:
  /// **'Cantiere'**
  String get cantieriScreenSiteLabel;

  /// No description provided for @cantieriScreenSitesPresentLabel.
  ///
  /// In it, this message translates to:
  /// **'Cantieri in cui è presente'**
  String get cantieriScreenSitesPresentLabel;

  /// No description provided for @cantieriScreenSubcontractorsAction.
  ///
  /// In it, this message translates to:
  /// **'Subappaltatori'**
  String get cantieriScreenSubcontractorsAction;

  /// No description provided for @cantieriScreenTitle.
  ///
  /// In it, this message translates to:
  /// **'Cantieri'**
  String get cantieriScreenTitle;

  /// No description provided for @cantieriScreenUpcomingDeadlinesTitle.
  ///
  /// In it, this message translates to:
  /// **'Scadenze imminenti'**
  String get cantieriScreenUpcomingDeadlinesTitle;

  /// No description provided for @amministrazioneScreenConfirmDeleteDeadlineMessage.
  ///
  /// In it, this message translates to:
  /// **'Eliminare \"{nome}\"? L\'operazione non è reversibile.'**
  String amministrazioneScreenConfirmDeleteDeadlineMessage(String nome);

  /// No description provided for @amministrazioneScreenConfirmDeleteDeadlineTitle.
  ///
  /// In it, this message translates to:
  /// **'Eliminare scadenza?'**
  String get amministrazioneScreenConfirmDeleteDeadlineTitle;

  /// No description provided for @amministrazioneScreenConfirmDeleteEmployeeMessage.
  ///
  /// In it, this message translates to:
  /// **'Eliminare \"{nome}\"? L\'operazione non è reversibile.'**
  String amministrazioneScreenConfirmDeleteEmployeeMessage(String nome);

  /// No description provided for @amministrazioneScreenConfirmDeleteEmployeeTitle.
  ///
  /// In it, this message translates to:
  /// **'Eliminare dipendente?'**
  String get amministrazioneScreenConfirmDeleteEmployeeTitle;

  /// No description provided for @amministrazioneScreenDeadlineDateLabel.
  ///
  /// In it, this message translates to:
  /// **'Scadenza'**
  String get amministrazioneScreenDeadlineDateLabel;

  /// No description provided for @amministrazioneScreenDeadlineNoteLabel.
  ///
  /// In it, this message translates to:
  /// **'Nota scadenza'**
  String get amministrazioneScreenDeadlineNoteLabel;

  /// No description provided for @amministrazioneScreenDeleteDeadlineTooltip.
  ///
  /// In it, this message translates to:
  /// **'Elimina scadenza'**
  String get amministrazioneScreenDeleteDeadlineTooltip;

  /// No description provided for @amministrazioneScreenDeleteEmployeeTooltip.
  ///
  /// In it, this message translates to:
  /// **'Elimina dipendente'**
  String get amministrazioneScreenDeleteEmployeeTooltip;

  /// No description provided for @amministrazioneScreenDlAerialPlatform.
  ///
  /// In it, this message translates to:
  /// **'Scadenza Piattaforme elevatrici'**
  String get amministrazioneScreenDlAerialPlatform;

  /// No description provided for @amministrazioneScreenDlContract.
  ///
  /// In it, this message translates to:
  /// **'Scadenza Contratto'**
  String get amministrazioneScreenDlContract;

  /// No description provided for @amministrazioneScreenDlDigitalSignature.
  ///
  /// In it, this message translates to:
  /// **'Scadenza Firma Digitale'**
  String get amministrazioneScreenDlDigitalSignature;

  /// No description provided for @amministrazioneScreenDlExcavator.
  ///
  /// In it, this message translates to:
  /// **'Scadenza Conduzione Escavatori'**
  String get amministrazioneScreenDlExcavator;

  /// No description provided for @amministrazioneScreenDlFirefighting.
  ///
  /// In it, this message translates to:
  /// **'Scadenza Antincendio'**
  String get amministrazioneScreenDlFirefighting;

  /// No description provided for @amministrazioneScreenDlFirstAid.
  ///
  /// In it, this message translates to:
  /// **'Scadenza Primo Soccorso'**
  String get amministrazioneScreenDlFirstAid;

  /// No description provided for @amministrazioneScreenDlForklift.
  ///
  /// In it, this message translates to:
  /// **'Scadenza Carrello elevatore semovente'**
  String get amministrazioneScreenDlForklift;

  /// No description provided for @amministrazioneScreenDlHeightWork.
  ///
  /// In it, this message translates to:
  /// **'Scadenza Lavori in Quota'**
  String get amministrazioneScreenDlHeightWork;

  /// No description provided for @amministrazioneScreenDlIdCard.
  ///
  /// In it, this message translates to:
  /// **'Scadenza Carta Identità'**
  String get amministrazioneScreenDlIdCard;

  /// No description provided for @amministrazioneScreenDlIsocyanates.
  ///
  /// In it, this message translates to:
  /// **'Scadenza corso Diisocianati'**
  String get amministrazioneScreenDlIsocyanates;

  /// No description provided for @amministrazioneScreenDlLicense.
  ///
  /// In it, this message translates to:
  /// **'Scadenza Patente'**
  String get amministrazioneScreenDlLicense;

  /// No description provided for @amministrazioneScreenDlMedicalCheckup.
  ///
  /// In it, this message translates to:
  /// **'Scadenza Visita Medica'**
  String get amministrazioneScreenDlMedicalCheckup;

  /// No description provided for @amministrazioneScreenDlResidencePermit.
  ///
  /// In it, this message translates to:
  /// **'Scadenza Permesso di Soggiorno'**
  String get amministrazioneScreenDlResidencePermit;

  /// No description provided for @amministrazioneScreenDlRlst.
  ///
  /// In it, this message translates to:
  /// **'Scadenza RLST'**
  String get amministrazioneScreenDlRlst;

  /// No description provided for @amministrazioneScreenDlRspp.
  ///
  /// In it, this message translates to:
  /// **'Scadenza RSPP'**
  String get amministrazioneScreenDlRspp;

  /// No description provided for @amministrazioneScreenDlSafetyTraining.
  ///
  /// In it, this message translates to:
  /// **'Scadenza Formazione Sicurezza'**
  String get amministrazioneScreenDlSafetyTraining;

  /// No description provided for @amministrazioneScreenDlScaffolding.
  ///
  /// In it, this message translates to:
  /// **'Scadenza Montaggio/Smontaggio ponteggi'**
  String get amministrazioneScreenDlScaffolding;

  /// No description provided for @amministrazioneScreenDlShelving.
  ///
  /// In it, this message translates to:
  /// **'Scadenza corso Scaffalature'**
  String get amministrazioneScreenDlShelving;

  /// No description provided for @amministrazioneScreenDlSupervisor.
  ///
  /// In it, this message translates to:
  /// **'Scadenza Preposto'**
  String get amministrazioneScreenDlSupervisor;

  /// No description provided for @amministrazioneScreenDlTachograph.
  ///
  /// In it, this message translates to:
  /// **'Scadenza Carta Tachigrafica'**
  String get amministrazioneScreenDlTachograph;

  /// No description provided for @amministrazioneScreenDlTachographCompany.
  ///
  /// In it, this message translates to:
  /// **'Scadenza Carta Tachigrafica + Azienda'**
  String get amministrazioneScreenDlTachographCompany;

  /// No description provided for @amministrazioneScreenDlTachographCourse.
  ///
  /// In it, this message translates to:
  /// **'Scadenza corso Cronotachigrafico'**
  String get amministrazioneScreenDlTachographCourse;

  /// No description provided for @amministrazioneScreenDlTaxCode.
  ///
  /// In it, this message translates to:
  /// **'Scadenza Codice Fiscale'**
  String get amministrazioneScreenDlTaxCode;

  /// No description provided for @amministrazioneScreenDlTetanus.
  ///
  /// In it, this message translates to:
  /// **'Scadenza Antitetanica'**
  String get amministrazioneScreenDlTetanus;

  /// No description provided for @amministrazioneScreenDlTowerCrane.
  ///
  /// In it, this message translates to:
  /// **'Scadenza Gru a Torre'**
  String get amministrazioneScreenDlTowerCrane;

  /// No description provided for @amministrazioneScreenDlTruckCrane.
  ///
  /// In it, this message translates to:
  /// **'Scadenza Gru Autocarro'**
  String get amministrazioneScreenDlTruckCrane;

  /// No description provided for @amministrazioneScreenEditDeadlineTooltip.
  ///
  /// In it, this message translates to:
  /// **'Modifica scadenza'**
  String get amministrazioneScreenEditDeadlineTooltip;

  /// No description provided for @amministrazioneScreenEditEmployeeTooltip.
  ///
  /// In it, this message translates to:
  /// **'Modifica dipendente'**
  String get amministrazioneScreenEditEmployeeTooltip;

  /// No description provided for @amministrazioneScreenEditNoteTooltip.
  ///
  /// In it, this message translates to:
  /// **'Modifica nota'**
  String get amministrazioneScreenEditNoteTooltip;

  /// No description provided for @amministrazioneScreenEmployeeDeadlinesTitle.
  ///
  /// In it, this message translates to:
  /// **'Scadenze dipendenti'**
  String get amministrazioneScreenEmployeeDeadlinesTitle;

  /// No description provided for @amministrazioneScreenEmployeeLabel.
  ///
  /// In it, this message translates to:
  /// **'Dipendente'**
  String get amministrazioneScreenEmployeeLabel;

  /// No description provided for @amministrazioneScreenEmployeesTitle.
  ///
  /// In it, this message translates to:
  /// **'Dipendenti Aziendali'**
  String get amministrazioneScreenEmployeesTitle;

  /// No description provided for @amministrazioneScreenEmptyDeadlinesLoaded.
  ///
  /// In it, this message translates to:
  /// **'Nessuna scadenza caricata.'**
  String get amministrazioneScreenEmptyDeadlinesLoaded;

  /// No description provided for @amministrazioneScreenEmptyDeadlinesSearch.
  ///
  /// In it, this message translates to:
  /// **'Nessuna scadenza trovata per \"{query}\".'**
  String amministrazioneScreenEmptyDeadlinesSearch(String query);

  /// No description provided for @amministrazioneScreenEmptyEmployeesLoaded.
  ///
  /// In it, this message translates to:
  /// **'Nessun dipendente caricato.'**
  String get amministrazioneScreenEmptyEmployeesLoaded;

  /// No description provided for @amministrazioneScreenEmptyEmployeesSearch.
  ///
  /// In it, this message translates to:
  /// **'Nessun dipendente trovato per \"{query}\".'**
  String amministrazioneScreenEmptyEmployeesSearch(String query);

  /// No description provided for @amministrazioneScreenFieldAerialPlatform.
  ///
  /// In it, this message translates to:
  /// **'Piattaforme Elevatrici'**
  String get amministrazioneScreenFieldAerialPlatform;

  /// No description provided for @amministrazioneScreenFieldAge.
  ///
  /// In it, this message translates to:
  /// **'Età'**
  String get amministrazioneScreenFieldAge;

  /// No description provided for @amministrazioneScreenFieldBirthDate.
  ///
  /// In it, this message translates to:
  /// **'Data di Nascita'**
  String get amministrazioneScreenFieldBirthDate;

  /// No description provided for @amministrazioneScreenFieldBirthPlace.
  ///
  /// In it, this message translates to:
  /// **'Luogo di Nascita'**
  String get amministrazioneScreenFieldBirthPlace;

  /// No description provided for @amministrazioneScreenFieldDigitalSignature.
  ///
  /// In it, this message translates to:
  /// **'Firma Digitale'**
  String get amministrazioneScreenFieldDigitalSignature;

  /// No description provided for @amministrazioneScreenFieldEnvironmentalManagement.
  ///
  /// In it, this message translates to:
  /// **'Gestione Ambientale'**
  String get amministrazioneScreenFieldEnvironmentalManagement;

  /// No description provided for @amministrazioneScreenFieldExcavator.
  ///
  /// In it, this message translates to:
  /// **'Conduzione Escavatori'**
  String get amministrazioneScreenFieldExcavator;

  /// No description provided for @amministrazioneScreenFieldFirefighting.
  ///
  /// In it, this message translates to:
  /// **'Antincendio'**
  String get amministrazioneScreenFieldFirefighting;

  /// No description provided for @amministrazioneScreenFieldFirstAid.
  ///
  /// In it, this message translates to:
  /// **'Primo Soccorso'**
  String get amministrazioneScreenFieldFirstAid;

  /// No description provided for @amministrazioneScreenFieldForklift.
  ///
  /// In it, this message translates to:
  /// **'Carrello Elevatore Semovente'**
  String get amministrazioneScreenFieldForklift;

  /// No description provided for @amministrazioneScreenFieldGeneralSafetyTraining.
  ///
  /// In it, this message translates to:
  /// **'Formazione Sicurezza generale'**
  String get amministrazioneScreenFieldGeneralSafetyTraining;

  /// No description provided for @amministrazioneScreenFieldHealthCard.
  ///
  /// In it, this message translates to:
  /// **'Tessera Sanitara'**
  String get amministrazioneScreenFieldHealthCard;

  /// No description provided for @amministrazioneScreenFieldHeightWork.
  ///
  /// In it, this message translates to:
  /// **'Lavori in Quota'**
  String get amministrazioneScreenFieldHeightWork;

  /// No description provided for @amministrazioneScreenFieldIdCard.
  ///
  /// In it, this message translates to:
  /// **'Carta d\'identità'**
  String get amministrazioneScreenFieldIdCard;

  /// No description provided for @amministrazioneScreenFieldIsocyanates.
  ///
  /// In it, this message translates to:
  /// **'Corso Diisocianati'**
  String get amministrazioneScreenFieldIsocyanates;

  /// No description provided for @amministrazioneScreenFieldLicense.
  ///
  /// In it, this message translates to:
  /// **'Patente'**
  String get amministrazioneScreenFieldLicense;

  /// No description provided for @amministrazioneScreenFieldMedicalCheckup.
  ///
  /// In it, this message translates to:
  /// **'Visita Medica'**
  String get amministrazioneScreenFieldMedicalCheckup;

  /// No description provided for @amministrazioneScreenFieldModel231.
  ///
  /// In it, this message translates to:
  /// **'Modello 231'**
  String get amministrazioneScreenFieldModel231;

  /// No description provided for @amministrazioneScreenFieldName.
  ///
  /// In it, this message translates to:
  /// **'Nome'**
  String get amministrazioneScreenFieldName;

  /// No description provided for @amministrazioneScreenFieldRentri.
  ///
  /// In it, this message translates to:
  /// **'Rentri'**
  String get amministrazioneScreenFieldRentri;

  /// No description provided for @amministrazioneScreenFieldResidencePermit.
  ///
  /// In it, this message translates to:
  /// **'Permesso di soggiorno'**
  String get amministrazioneScreenFieldResidencePermit;

  /// No description provided for @amministrazioneScreenFieldRlst.
  ///
  /// In it, this message translates to:
  /// **'RLST'**
  String get amministrazioneScreenFieldRlst;

  /// No description provided for @amministrazioneScreenFieldRole.
  ///
  /// In it, this message translates to:
  /// **'Mansione'**
  String get amministrazioneScreenFieldRole;

  /// No description provided for @amministrazioneScreenFieldRspp.
  ///
  /// In it, this message translates to:
  /// **'RSPP'**
  String get amministrazioneScreenFieldRspp;

  /// No description provided for @amministrazioneScreenFieldScaffolding.
  ///
  /// In it, this message translates to:
  /// **'Montaggio/Smontaggio Ponteggi'**
  String get amministrazioneScreenFieldScaffolding;

  /// No description provided for @amministrazioneScreenFieldShelving.
  ///
  /// In it, this message translates to:
  /// **'Corso Scaffalature'**
  String get amministrazioneScreenFieldShelving;

  /// No description provided for @amministrazioneScreenFieldSupervisor.
  ///
  /// In it, this message translates to:
  /// **'Preposto'**
  String get amministrazioneScreenFieldSupervisor;

  /// No description provided for @amministrazioneScreenFieldTachograph.
  ///
  /// In it, this message translates to:
  /// **'Carta Tachigrafica'**
  String get amministrazioneScreenFieldTachograph;

  /// No description provided for @amministrazioneScreenFieldTachographCourse.
  ///
  /// In it, this message translates to:
  /// **'Corso Cronotachigrafico'**
  String get amministrazioneScreenFieldTachographCourse;

  /// No description provided for @amministrazioneScreenFieldTaxCode.
  ///
  /// In it, this message translates to:
  /// **'Codice Fiscale'**
  String get amministrazioneScreenFieldTaxCode;

  /// No description provided for @amministrazioneScreenFieldTetanus.
  ///
  /// In it, this message translates to:
  /// **'Antitetanica'**
  String get amministrazioneScreenFieldTetanus;

  /// No description provided for @amministrazioneScreenFieldTowerCrane.
  ///
  /// In it, this message translates to:
  /// **'Gru a Torre'**
  String get amministrazioneScreenFieldTowerCrane;

  /// No description provided for @amministrazioneScreenFieldTruckCrane.
  ///
  /// In it, this message translates to:
  /// **'Gru Autocarro'**
  String get amministrazioneScreenFieldTruckCrane;

  /// No description provided for @amministrazioneScreenGeneralDeadlinesTitle.
  ///
  /// In it, this message translates to:
  /// **'Scadenze generali'**
  String get amministrazioneScreenGeneralDeadlinesTitle;

  /// No description provided for @amministrazioneScreenHideAllTooltip.
  ///
  /// In it, this message translates to:
  /// **'Nascondi tutti'**
  String get amministrazioneScreenHideAllTooltip;

  /// No description provided for @amministrazioneScreenHideDeadlinesTooltip.
  ///
  /// In it, this message translates to:
  /// **'Nascondi scadenze'**
  String get amministrazioneScreenHideDeadlinesTooltip;

  /// No description provided for @amministrazioneScreenHideDetailsTooltip.
  ///
  /// In it, this message translates to:
  /// **'Nascondi dettagli'**
  String get amministrazioneScreenHideDetailsTooltip;

  /// No description provided for @amministrazioneScreenNoUpcomingDeadlines.
  ///
  /// In it, this message translates to:
  /// **'Nessuna scadenza imminente.'**
  String get amministrazioneScreenNoUpcomingDeadlines;

  /// No description provided for @amministrazioneScreenSearchDeadlinesHint.
  ///
  /// In it, this message translates to:
  /// **'Cerca per nome o nota'**
  String get amministrazioneScreenSearchDeadlinesHint;

  /// No description provided for @amministrazioneScreenSearchEmployeesHint.
  ///
  /// In it, this message translates to:
  /// **'Cerca per nome, cognome o mansione'**
  String get amministrazioneScreenSearchEmployeesHint;

  /// No description provided for @amministrazioneScreenSectionCoursesCompleted.
  ///
  /// In it, this message translates to:
  /// **'Scadenza corsi effettuati'**
  String get amministrazioneScreenSectionCoursesCompleted;

  /// No description provided for @amministrazioneScreenSectionPersonalDeadlines.
  ///
  /// In it, this message translates to:
  /// **'Scadenze Personali'**
  String get amministrazioneScreenSectionPersonalDeadlines;

  /// No description provided for @amministrazioneScreenSectionPersonalInfo.
  ///
  /// In it, this message translates to:
  /// **'Anagrafica'**
  String get amministrazioneScreenSectionPersonalInfo;

  /// No description provided for @amministrazioneScreenSectionTrainingDates.
  ///
  /// In it, this message translates to:
  /// **'Data corsi formazione effettuati'**
  String get amministrazioneScreenSectionTrainingDates;

  /// No description provided for @amministrazioneScreenShowAllTooltip.
  ///
  /// In it, this message translates to:
  /// **'Mostra tutti'**
  String get amministrazioneScreenShowAllTooltip;

  /// No description provided for @amministrazioneScreenShowDeadlinesTooltip.
  ///
  /// In it, this message translates to:
  /// **'Mostra scadenze'**
  String get amministrazioneScreenShowDeadlinesTooltip;

  /// No description provided for @amministrazioneScreenShowDetailsTooltip.
  ///
  /// In it, this message translates to:
  /// **'Mostra dettagli'**
  String get amministrazioneScreenShowDetailsTooltip;

  /// No description provided for @amministrazioneScreenTitle.
  ///
  /// In it, this message translates to:
  /// **'Amministrazione'**
  String get amministrazioneScreenTitle;

  /// No description provided for @amministrazioneScreenUpcomingDeadlinesTitle.
  ///
  /// In it, this message translates to:
  /// **'Scadenze imminenti'**
  String get amministrazioneScreenUpcomingDeadlinesTitle;

  /// No description provided for @fasceCateneScreenInMagazzino.
  ///
  /// In it, this message translates to:
  /// **'In magazzino'**
  String get fasceCateneScreenInMagazzino;

  /// No description provided for @fasceCateneScreenInCantiere.
  ///
  /// In it, this message translates to:
  /// **'In cantiere {nome}'**
  String fasceCateneScreenInCantiere(String nome);

  /// No description provided for @fasceCateneScreenSuAutomezzo.
  ///
  /// In it, this message translates to:
  /// **'Su automezzo {nome}'**
  String fasceCateneScreenSuAutomezzo(String nome);

  /// No description provided for @fasceCateneScreenNonSpecificata.
  ///
  /// In it, this message translates to:
  /// **'Non specificata'**
  String get fasceCateneScreenNonSpecificata;

  /// No description provided for @fasceCateneScreenEsitoPositivo.
  ///
  /// In it, this message translates to:
  /// **'Positivo'**
  String get fasceCateneScreenEsitoPositivo;

  /// No description provided for @fasceCateneScreenEsitoNegativo.
  ///
  /// In it, this message translates to:
  /// **'Negativo'**
  String get fasceCateneScreenEsitoNegativo;

  /// No description provided for @fasceCateneScreenTitle.
  ///
  /// In it, this message translates to:
  /// **'Fasce, Catene e Benne'**
  String get fasceCateneScreenTitle;

  /// No description provided for @fasceCateneScreenNuovaFasciaCatena.
  ///
  /// In it, this message translates to:
  /// **'Nuova fascia/catena'**
  String get fasceCateneScreenNuovaFasciaCatena;

  /// No description provided for @fasceCateneScreenInserisciBenna.
  ///
  /// In it, this message translates to:
  /// **'Inserisci benna'**
  String get fasceCateneScreenInserisciBenna;

  /// No description provided for @fasceCateneScreenPresenti.
  ///
  /// In it, this message translates to:
  /// **'Fasce, catene e benne presenti'**
  String get fasceCateneScreenPresenti;

  /// No description provided for @fasceCateneScreenNascondiTutti.
  ///
  /// In it, this message translates to:
  /// **'Nascondi tutti'**
  String get fasceCateneScreenNascondiTutti;

  /// No description provided for @fasceCateneScreenMostraTutti.
  ///
  /// In it, this message translates to:
  /// **'Mostra tutti'**
  String get fasceCateneScreenMostraTutti;

  /// No description provided for @fasceCateneScreenSearchHint.
  ///
  /// In it, this message translates to:
  /// **'Cerca per ID, numero di serie, tipo o ubicazione'**
  String get fasceCateneScreenSearchHint;

  /// No description provided for @fasceCateneScreenNessunElementoCaricato.
  ///
  /// In it, this message translates to:
  /// **'Nessun elemento caricato.'**
  String get fasceCateneScreenNessunElementoCaricato;

  /// No description provided for @fasceCateneScreenNessunElementoTrovato.
  ///
  /// In it, this message translates to:
  /// **'Nessun elemento trovato per \"{query}\".'**
  String fasceCateneScreenNessunElementoTrovato(String query);

  /// No description provided for @fasceCateneScreenBenneAutoscaricanti.
  ///
  /// In it, this message translates to:
  /// **'Benne autoscaricanti'**
  String get fasceCateneScreenBenneAutoscaricanti;

  /// No description provided for @fasceCateneScreenAnagrafica.
  ///
  /// In it, this message translates to:
  /// **'Anagrafica'**
  String get fasceCateneScreenAnagrafica;

  /// No description provided for @fasceCateneScreenNumeroSerie.
  ///
  /// In it, this message translates to:
  /// **'N. serie'**
  String get fasceCateneScreenNumeroSerie;

  /// No description provided for @fasceCateneScreenUbicazione.
  ///
  /// In it, this message translates to:
  /// **'Ubicazione'**
  String get fasceCateneScreenUbicazione;

  /// No description provided for @fasceCateneScreenVerificaConEsito.
  ///
  /// In it, this message translates to:
  /// **'Verifica con esito'**
  String get fasceCateneScreenVerificaConEsito;

  /// No description provided for @fasceCateneScreenEsitoNegativoLower.
  ///
  /// In it, this message translates to:
  /// **'negativo'**
  String get fasceCateneScreenEsitoNegativoLower;

  /// No description provided for @fasceCateneScreenEsitoPositivoLower.
  ///
  /// In it, this message translates to:
  /// **'positivo'**
  String get fasceCateneScreenEsitoPositivoLower;

  /// No description provided for @fasceCateneScreenTipo.
  ///
  /// In it, this message translates to:
  /// **'Tipo'**
  String get fasceCateneScreenTipo;

  /// No description provided for @fasceCateneScreenCricchetto.
  ///
  /// In it, this message translates to:
  /// **'Cricchetto'**
  String get fasceCateneScreenCricchetto;

  /// No description provided for @fasceCateneScreenIdInterno.
  ///
  /// In it, this message translates to:
  /// **'ID interno'**
  String get fasceCateneScreenIdInterno;

  /// No description provided for @fasceCateneScreenNumeroSerieProduttore.
  ///
  /// In it, this message translates to:
  /// **'N. serie produttore'**
  String get fasceCateneScreenNumeroSerieProduttore;

  /// No description provided for @fasceCateneScreenColore.
  ///
  /// In it, this message translates to:
  /// **'Colore'**
  String get fasceCateneScreenColore;

  /// No description provided for @fasceCateneScreenCaratteristiche.
  ///
  /// In it, this message translates to:
  /// **'Caratteristiche'**
  String get fasceCateneScreenCaratteristiche;

  /// No description provided for @fasceCateneScreenPortataKg.
  ///
  /// In it, this message translates to:
  /// **'Portata (Kg)'**
  String get fasceCateneScreenPortataKg;

  /// No description provided for @fasceCateneScreenSpessoreMm.
  ///
  /// In it, this message translates to:
  /// **'Spessore (mm)'**
  String get fasceCateneScreenSpessoreMm;

  /// No description provided for @fasceCateneScreenDiametroMm.
  ///
  /// In it, this message translates to:
  /// **'Diametro (mm)'**
  String get fasceCateneScreenDiametroMm;

  /// No description provided for @fasceCateneScreenLarghezzaMm.
  ///
  /// In it, this message translates to:
  /// **'Larghezza (mm)'**
  String get fasceCateneScreenLarghezzaMm;

  /// No description provided for @fasceCateneScreenLunghezzaM.
  ///
  /// In it, this message translates to:
  /// **'Lunghezza (m)'**
  String get fasceCateneScreenLunghezzaM;

  /// No description provided for @fasceCateneScreenUbicazioneEAcquisto.
  ///
  /// In it, this message translates to:
  /// **'Ubicazione e acquisto'**
  String get fasceCateneScreenUbicazioneEAcquisto;

  /// No description provided for @fasceCateneScreenDataAcquisto.
  ///
  /// In it, this message translates to:
  /// **'Data acquisto'**
  String get fasceCateneScreenDataAcquisto;

  /// No description provided for @fasceCateneScreenLuogoAcquisto.
  ///
  /// In it, this message translates to:
  /// **'Luogo acquisto'**
  String get fasceCateneScreenLuogoAcquisto;

  /// No description provided for @fasceCateneScreenVerificaInterna.
  ///
  /// In it, this message translates to:
  /// **'Verifica interna'**
  String get fasceCateneScreenVerificaInterna;

  /// No description provided for @fasceCateneScreenUltimaVerifica.
  ///
  /// In it, this message translates to:
  /// **'Ultima verifica'**
  String get fasceCateneScreenUltimaVerifica;

  /// No description provided for @fasceCateneScreenEsito.
  ///
  /// In it, this message translates to:
  /// **'Esito'**
  String get fasceCateneScreenEsito;

  /// No description provided for @fasceCateneScreenProssimaVerifica.
  ///
  /// In it, this message translates to:
  /// **'Prossima verifica'**
  String get fasceCateneScreenProssimaVerifica;

  /// No description provided for @fasceCateneScreenEliminareFasciaCatenaTitle.
  ///
  /// In it, this message translates to:
  /// **'Eliminare la fascia/catena?'**
  String get fasceCateneScreenEliminareFasciaCatenaTitle;

  /// No description provided for @fasceCateneScreenEliminareBennaTitle.
  ///
  /// In it, this message translates to:
  /// **'Eliminare la benna?'**
  String get fasceCateneScreenEliminareBennaTitle;

  /// No description provided for @fasceCateneScreenConfirmDeleteMessage.
  ///
  /// In it, this message translates to:
  /// **'Eliminare \"{nome}\"? L\'operazione non è reversibile.'**
  String fasceCateneScreenConfirmDeleteMessage(String nome);

  /// No description provided for @fasceCateneScreenNascondiInfo.
  ///
  /// In it, this message translates to:
  /// **'Nascondi info'**
  String get fasceCateneScreenNascondiInfo;

  /// No description provided for @fasceCateneScreenMostraInfo.
  ///
  /// In it, this message translates to:
  /// **'Mostra info'**
  String get fasceCateneScreenMostraInfo;

  /// No description provided for @fasceCateneScreenDescrizione.
  ///
  /// In it, this message translates to:
  /// **'Descrizione'**
  String get fasceCateneScreenDescrizione;

  /// No description provided for @fasceCateneScreenCapacitaCarico.
  ///
  /// In it, this message translates to:
  /// **'Capacità di carico'**
  String get fasceCateneScreenCapacitaCarico;

  /// No description provided for @fasceCateneScreenIngrandisciFoto.
  ///
  /// In it, this message translates to:
  /// **'Ingrandisci foto'**
  String get fasceCateneScreenIngrandisciFoto;

  /// No description provided for @fasceCateneScreenImmagineNonDisponibile.
  ///
  /// In it, this message translates to:
  /// **'Immagine non disponibile'**
  String get fasceCateneScreenImmagineNonDisponibile;

  /// No description provided for @fasceCateneScreenBennaTitolo.
  ///
  /// In it, this message translates to:
  /// **'{idInterno} - Benna'**
  String fasceCateneScreenBennaTitolo(String idInterno);

  /// No description provided for @scaleScreenCodice.
  ///
  /// In it, this message translates to:
  /// **'Codice'**
  String get scaleScreenCodice;

  /// No description provided for @scaleScreenMateriale.
  ///
  /// In it, this message translates to:
  /// **'Materiale'**
  String get scaleScreenMateriale;

  /// No description provided for @scaleScreenDescrizione.
  ///
  /// In it, this message translates to:
  /// **'Descrizione'**
  String get scaleScreenDescrizione;

  /// No description provided for @scaleScreenUbicazione.
  ///
  /// In it, this message translates to:
  /// **'Ubicazione'**
  String get scaleScreenUbicazione;

  /// No description provided for @scaleScreenUltimaVerifica.
  ///
  /// In it, this message translates to:
  /// **'Ultima verifica'**
  String get scaleScreenUltimaVerifica;

  /// No description provided for @scaleScreenProssimaVerifica.
  ///
  /// In it, this message translates to:
  /// **'Prossima verifica'**
  String get scaleScreenProssimaVerifica;

  /// No description provided for @scaleScreenInMagazzino.
  ///
  /// In it, this message translates to:
  /// **'In magazzino'**
  String get scaleScreenInMagazzino;

  /// No description provided for @scaleScreenInCantiere.
  ///
  /// In it, this message translates to:
  /// **'In cantiere {nome}'**
  String scaleScreenInCantiere(String nome);

  /// No description provided for @scaleScreenNonSpecificata.
  ///
  /// In it, this message translates to:
  /// **'Non specificata'**
  String get scaleScreenNonSpecificata;

  /// No description provided for @scaleScreenTitle.
  ///
  /// In it, this message translates to:
  /// **'Scale'**
  String get scaleScreenTitle;

  /// No description provided for @scaleScreenPdfCount.
  ///
  /// In it, this message translates to:
  /// **'{count} scale'**
  String scaleScreenPdfCount(int count);

  /// No description provided for @scaleScreenPdfFiltro.
  ///
  /// In it, this message translates to:
  /// **'filtro di ricerca: \"{filtro}\"'**
  String scaleScreenPdfFiltro(String filtro);

  /// No description provided for @scaleScreenStampaErrore.
  ///
  /// In it, this message translates to:
  /// **'Impossibile generare la stampa: {dettagli}'**
  String scaleScreenStampaErrore(String dettagli);

  /// No description provided for @scaleScreenNuovaScala.
  ///
  /// In it, this message translates to:
  /// **'Nuova scala'**
  String get scaleScreenNuovaScala;

  /// No description provided for @scaleScreenStampa.
  ///
  /// In it, this message translates to:
  /// **'Stampa'**
  String get scaleScreenStampa;

  /// No description provided for @scaleScreenScadenzeImminenti.
  ///
  /// In it, this message translates to:
  /// **'Scadenze imminenti'**
  String get scaleScreenScadenzeImminenti;

  /// No description provided for @scaleScreenNascondiScadenze.
  ///
  /// In it, this message translates to:
  /// **'Nascondi scadenze'**
  String get scaleScreenNascondiScadenze;

  /// No description provided for @scaleScreenMostraScadenze.
  ///
  /// In it, this message translates to:
  /// **'Mostra scadenze'**
  String get scaleScreenMostraScadenze;

  /// No description provided for @scaleScreenPresenti.
  ///
  /// In it, this message translates to:
  /// **'Scale presenti'**
  String get scaleScreenPresenti;

  /// No description provided for @scaleScreenNascondiTutti.
  ///
  /// In it, this message translates to:
  /// **'Nascondi tutti'**
  String get scaleScreenNascondiTutti;

  /// No description provided for @scaleScreenMostraTutti.
  ///
  /// In it, this message translates to:
  /// **'Mostra tutti'**
  String get scaleScreenMostraTutti;

  /// No description provided for @scaleScreenSearchHint.
  ///
  /// In it, this message translates to:
  /// **'Cerca per codice, materiale o ubicazione'**
  String get scaleScreenSearchHint;

  /// No description provided for @scaleScreenNessunElementoCaricato.
  ///
  /// In it, this message translates to:
  /// **'Nessun elemento caricato.'**
  String get scaleScreenNessunElementoCaricato;

  /// No description provided for @scaleScreenNessunElementoTrovato.
  ///
  /// In it, this message translates to:
  /// **'Nessun elemento trovato per \"{query}\".'**
  String scaleScreenNessunElementoTrovato(String query);

  /// No description provided for @scaleScreenCodiceScala.
  ///
  /// In it, this message translates to:
  /// **'Codice scala'**
  String get scaleScreenCodiceScala;

  /// No description provided for @scaleScreenNotaScadenza.
  ///
  /// In it, this message translates to:
  /// **'Nota scadenza'**
  String get scaleScreenNotaScadenza;

  /// No description provided for @scaleScreenModificaNota.
  ///
  /// In it, this message translates to:
  /// **'Modifica nota'**
  String get scaleScreenModificaNota;

  /// No description provided for @scaleScreenEliminaScala.
  ///
  /// In it, this message translates to:
  /// **'Elimina scala'**
  String get scaleScreenEliminaScala;

  /// No description provided for @scaleScreenEliminareScalaTitle.
  ///
  /// In it, this message translates to:
  /// **'Eliminare scala?'**
  String get scaleScreenEliminareScalaTitle;

  /// No description provided for @scaleScreenConfirmDeleteMessage.
  ///
  /// In it, this message translates to:
  /// **'Eliminare \"{codice}\"? L\'operazione non è reversibile.'**
  String scaleScreenConfirmDeleteMessage(String codice);

  /// No description provided for @scaleScreenNascondiInfo.
  ///
  /// In it, this message translates to:
  /// **'Nascondi info'**
  String get scaleScreenNascondiInfo;

  /// No description provided for @scaleScreenMostraInfo.
  ///
  /// In it, this message translates to:
  /// **'Mostra info'**
  String get scaleScreenMostraInfo;

  /// No description provided for @scaleScreenAnagrafica.
  ///
  /// In it, this message translates to:
  /// **'Anagrafica'**
  String get scaleScreenAnagrafica;

  /// No description provided for @scaleScreenControlli.
  ///
  /// In it, this message translates to:
  /// **'Controlli'**
  String get scaleScreenControlli;

  /// No description provided for @bennaFormDialogEstensioneNonAmmessa.
  ///
  /// In it, this message translates to:
  /// **'Estensione non ammessa (.{estensione})'**
  String bennaFormDialogEstensioneNonAmmessa(String estensione);

  /// No description provided for @bennaFormDialogImmagineTroppoGrande.
  ///
  /// In it, this message translates to:
  /// **'Immagine troppo grande (max 5 MB)'**
  String get bennaFormDialogImmagineTroppoGrande;

  /// No description provided for @bennaFormDialogModificaTitle.
  ///
  /// In it, this message translates to:
  /// **'Modifica benna'**
  String get bennaFormDialogModificaTitle;

  /// No description provided for @bennaFormDialogNuovaTitle.
  ///
  /// In it, this message translates to:
  /// **'Nuova benna'**
  String get bennaFormDialogNuovaTitle;

  /// No description provided for @bennaFormDialogAnagrafica.
  ///
  /// In it, this message translates to:
  /// **'Anagrafica'**
  String get bennaFormDialogAnagrafica;

  /// No description provided for @bennaFormDialogIdInterno.
  ///
  /// In it, this message translates to:
  /// **'ID interno*'**
  String get bennaFormDialogIdInterno;

  /// No description provided for @bennaFormDialogDescrizione.
  ///
  /// In it, this message translates to:
  /// **'Descrizione'**
  String get bennaFormDialogDescrizione;

  /// No description provided for @bennaFormDialogNumeroSerieProduttore.
  ///
  /// In it, this message translates to:
  /// **'Numero di serie produttore'**
  String get bennaFormDialogNumeroSerieProduttore;

  /// No description provided for @bennaFormDialogCapacitaCaricoLt.
  ///
  /// In it, this message translates to:
  /// **'Capacità di carico (Lt)'**
  String get bennaFormDialogCapacitaCaricoLt;

  /// No description provided for @bennaFormDialogUbicazione.
  ///
  /// In it, this message translates to:
  /// **'Ubicazione'**
  String get bennaFormDialogUbicazione;

  /// No description provided for @bennaFormDialogTipoUbicazione.
  ///
  /// In it, this message translates to:
  /// **'Tipo ubicazione'**
  String get bennaFormDialogTipoUbicazione;

  /// No description provided for @bennaFormDialogNonSpecificata.
  ///
  /// In it, this message translates to:
  /// **'Non specificata'**
  String get bennaFormDialogNonSpecificata;

  /// No description provided for @bennaFormDialogMagazzino.
  ///
  /// In it, this message translates to:
  /// **'Magazzino'**
  String get bennaFormDialogMagazzino;

  /// No description provided for @bennaFormDialogCantiere.
  ///
  /// In it, this message translates to:
  /// **'Cantiere'**
  String get bennaFormDialogCantiere;

  /// No description provided for @bennaFormDialogSelezionaCantiere.
  ///
  /// In it, this message translates to:
  /// **'Seleziona un cantiere'**
  String get bennaFormDialogSelezionaCantiere;

  /// No description provided for @bennaFormDialogAcquisto.
  ///
  /// In it, this message translates to:
  /// **'Acquisto'**
  String get bennaFormDialogAcquisto;

  /// No description provided for @bennaFormDialogDataAcquisto.
  ///
  /// In it, this message translates to:
  /// **'Data di acquisto'**
  String get bennaFormDialogDataAcquisto;

  /// No description provided for @bennaFormDialogVerificaInterna.
  ///
  /// In it, this message translates to:
  /// **'Verifica interna'**
  String get bennaFormDialogVerificaInterna;

  /// No description provided for @bennaFormDialogUltimaVerificaInterna.
  ///
  /// In it, this message translates to:
  /// **'Ultima verifica interna'**
  String get bennaFormDialogUltimaVerificaInterna;

  /// No description provided for @bennaFormDialogProssimaVerifica.
  ///
  /// In it, this message translates to:
  /// **'Prossima verifica'**
  String get bennaFormDialogProssimaVerifica;

  /// No description provided for @bennaFormDialogEsitoVerificaPositivo.
  ///
  /// In it, this message translates to:
  /// **'Esito verifica positivo'**
  String get bennaFormDialogEsitoVerificaPositivo;

  /// No description provided for @bennaFormDialogIdoneaUso.
  ///
  /// In it, this message translates to:
  /// **'Idonea all\'uso'**
  String get bennaFormDialogIdoneaUso;

  /// No description provided for @bennaFormDialogNonIdonea.
  ///
  /// In it, this message translates to:
  /// **'Non idonea: da mettere fuori servizio'**
  String get bennaFormDialogNonIdonea;

  /// No description provided for @bennaFormDialogFoto.
  ///
  /// In it, this message translates to:
  /// **'Foto'**
  String get bennaFormDialogFoto;

  /// No description provided for @bennaFormDialogCambiaFoto.
  ///
  /// In it, this message translates to:
  /// **'Cambia foto'**
  String get bennaFormDialogCambiaFoto;

  /// No description provided for @bennaFormDialogSfoglia.
  ///
  /// In it, this message translates to:
  /// **'Sfoglia'**
  String get bennaFormDialogSfoglia;

  /// No description provided for @bennaFormDialogRimuovi.
  ///
  /// In it, this message translates to:
  /// **'Rimuovi'**
  String get bennaFormDialogRimuovi;

  /// No description provided for @bennaFormDialogNoteAggiuntive.
  ///
  /// In it, this message translates to:
  /// **'Note aggiuntive'**
  String get bennaFormDialogNoteAggiuntive;

  /// No description provided for @bennaFormDialogImmagineNonDisponibile.
  ///
  /// In it, this message translates to:
  /// **'Immagine non disponibile'**
  String get bennaFormDialogImmagineNonDisponibile;

  /// No description provided for @bennaFormDialogTrascinaFoto.
  ///
  /// In it, this message translates to:
  /// **'Trascina qui la foto della benna'**
  String get bennaFormDialogTrascinaFoto;

  /// No description provided for @bennaFormDialogFormatiAmmessi.
  ///
  /// In it, this message translates to:
  /// **'JPG, PNG o WEBP - max 5 MB'**
  String get bennaFormDialogFormatiAmmessi;

  /// No description provided for @scadenzaCantiereFormDialogNomeScadenzaTitle.
  ///
  /// In it, this message translates to:
  /// **'Nome scadenza'**
  String get scadenzaCantiereFormDialogNomeScadenzaTitle;

  /// No description provided for @scadenzaCantiereFormDialogNomeScadenzaHint.
  ///
  /// In it, this message translates to:
  /// **'Es. Ponteggio, Gru, Recinzione...'**
  String get scadenzaCantiereFormDialogNomeScadenzaHint;

  /// No description provided for @scadenzaCantiereFormDialogContinua.
  ///
  /// In it, this message translates to:
  /// **'Continua'**
  String get scadenzaCantiereFormDialogContinua;

  /// No description provided for @scadenzaCantiereFormDialogTitle.
  ///
  /// In it, this message translates to:
  /// **'Scadenze generali del cantiere'**
  String get scadenzaCantiereFormDialogTitle;

  /// No description provided for @scadenzaCantiereFormDialogScadenzaMessaTerra.
  ///
  /// In it, this message translates to:
  /// **'Scadenza Messa a Terra'**
  String get scadenzaCantiereFormDialogScadenzaMessaTerra;

  /// No description provided for @scadenzaCantiereFormDialogRimuoviMessaTerra.
  ///
  /// In it, this message translates to:
  /// **'Rimuovi scadenza messa a terra'**
  String get scadenzaCantiereFormDialogRimuoviMessaTerra;

  /// No description provided for @scadenzaCantiereFormDialogAggiungiMessaTerra.
  ///
  /// In it, this message translates to:
  /// **'Aggiungi scadenza messa a terra'**
  String get scadenzaCantiereFormDialogAggiungiMessaTerra;

  /// No description provided for @scadenzaCantiereFormDialogScadenzaGenerica.
  ///
  /// In it, this message translates to:
  /// **'Scadenza generica {numero}'**
  String scadenzaCantiereFormDialogScadenzaGenerica(int numero);

  /// No description provided for @scadenzaCantiereFormDialogRimuoviQuesta.
  ///
  /// In it, this message translates to:
  /// **'Rimuovi questa scadenza'**
  String get scadenzaCantiereFormDialogRimuoviQuesta;

  /// No description provided for @scadenzaCantiereFormDialogAggiungiGenerica.
  ///
  /// In it, this message translates to:
  /// **'Aggiungi scadenza generica'**
  String get scadenzaCantiereFormDialogAggiungiGenerica;

  /// No description provided for @tipiScadenzeScreenTitle.
  ///
  /// In it, this message translates to:
  /// **'Tipi di Scadenze'**
  String get tipiScadenzeScreenTitle;

  /// No description provided for @tipiScadenzeScreenNuovaTipologia.
  ///
  /// In it, this message translates to:
  /// **'Nuova tipologia'**
  String get tipiScadenzeScreenNuovaTipologia;

  /// No description provided for @tipiScadenzeScreenSearchHint.
  ///
  /// In it, this message translates to:
  /// **'Cerca per tipologia'**
  String get tipiScadenzeScreenSearchHint;

  /// No description provided for @tipiScadenzeScreenNessunaTipologiaCaricata.
  ///
  /// In it, this message translates to:
  /// **'Nessuna tipologia caricata.'**
  String get tipiScadenzeScreenNessunaTipologiaCaricata;

  /// No description provided for @tipiScadenzeScreenNessunaTipologiaTrovata.
  ///
  /// In it, this message translates to:
  /// **'Nessuna tipologia trovato per \"{query}\".'**
  String tipiScadenzeScreenNessunaTipologiaTrovata(String query);

  /// No description provided for @tipiScadenzeScreenRichiedeScadenza.
  ///
  /// In it, this message translates to:
  /// **'Richiede scadenza'**
  String get tipiScadenzeScreenRichiedeScadenza;

  /// No description provided for @tipiScadenzeScreenAvviso.
  ///
  /// In it, this message translates to:
  /// **'Avviso'**
  String get tipiScadenzeScreenAvviso;

  /// No description provided for @tipiScadenzeScreenAvvisoDalGiorno.
  ///
  /// In it, this message translates to:
  /// **'dal giorno dopo la scadenza'**
  String get tipiScadenzeScreenAvvisoDalGiorno;

  /// No description provided for @tipiScadenzeScreenPreavviso.
  ///
  /// In it, this message translates to:
  /// **'Preavviso'**
  String get tipiScadenzeScreenPreavviso;

  /// No description provided for @tipiScadenzeScreenGiorniPreavviso.
  ///
  /// In it, this message translates to:
  /// **'{giorni} giorni'**
  String tipiScadenzeScreenGiorniPreavviso(String giorni);

  /// No description provided for @tipiScadenzeScreenCollegatoA.
  ///
  /// In it, this message translates to:
  /// **'Collegato a'**
  String get tipiScadenzeScreenCollegatoA;

  /// No description provided for @tipiScadenzeScreenModificaTipologia.
  ///
  /// In it, this message translates to:
  /// **'Modifica tipologia'**
  String get tipiScadenzeScreenModificaTipologia;

  /// No description provided for @tipiScadenzeScreenEliminaTipologia.
  ///
  /// In it, this message translates to:
  /// **'Elimina tipologia'**
  String get tipiScadenzeScreenEliminaTipologia;

  /// No description provided for @tipiScadenzeScreenEliminareTitle.
  ///
  /// In it, this message translates to:
  /// **'Eliminare la tipologia?'**
  String get tipiScadenzeScreenEliminareTitle;

  /// No description provided for @tipiScadenzeScreenEliminareMessage.
  ///
  /// In it, this message translates to:
  /// **'Eliminare la tipologia di scadenza {nome}? L\'operazione non è reversibile.'**
  String tipiScadenzeScreenEliminareMessage(String nome);

  /// No description provided for @tipiScadenzeScreenCantiere.
  ///
  /// In it, this message translates to:
  /// **'Cantiere'**
  String get tipiScadenzeScreenCantiere;

  /// No description provided for @tipiScadenzeScreenSubappaltatore.
  ///
  /// In it, this message translates to:
  /// **'Subappaltatore'**
  String get tipiScadenzeScreenSubappaltatore;

  /// No description provided for @tipiScadenzeScreenDipendenteSubappaltatore.
  ///
  /// In it, this message translates to:
  /// **'Dipendente del subappaltatore'**
  String get tipiScadenzeScreenDipendenteSubappaltatore;

  /// No description provided for @tipiScadenzeScreenDipendenteSubappaltatoreAutonomo.
  ///
  /// In it, this message translates to:
  /// **'Dipendente del subappaltatore (e lavoratori autonomi)'**
  String get tipiScadenzeScreenDipendenteSubappaltatoreAutonomo;

  /// No description provided for @tipiScadenzeScreenLavoratoreAutonomo.
  ///
  /// In it, this message translates to:
  /// **'Lavoratore autonomo'**
  String get tipiScadenzeScreenLavoratoreAutonomo;

  /// No description provided for @tipiScadenzeScreenElencoFinale.
  ///
  /// In it, this message translates to:
  /// **'{a} e {b}'**
  String tipiScadenzeScreenElencoFinale(String a, String b);

  /// No description provided for @dipendenteSubappaltatoreDetailScreenCantieri.
  ///
  /// In it, this message translates to:
  /// **'Cantieri'**
  String get dipendenteSubappaltatoreDetailScreenCantieri;

  /// No description provided for @dipendenteSubappaltatoreDetailScreenSubappaltatori.
  ///
  /// In it, this message translates to:
  /// **'Subappaltatori'**
  String get dipendenteSubappaltatoreDetailScreenSubappaltatori;

  /// No description provided for @dipendenteSubappaltatoreDetailScreenDipendentiAziendali.
  ///
  /// In it, this message translates to:
  /// **'Dipendenti Aziendali'**
  String get dipendenteSubappaltatoreDetailScreenDipendentiAziendali;

  /// No description provided for @dipendenteSubappaltatoreDetailScreenInformazioni.
  ///
  /// In it, this message translates to:
  /// **'Informazioni:'**
  String get dipendenteSubappaltatoreDetailScreenInformazioni;

  /// No description provided for @dipendenteSubappaltatoreDetailScreenTipo.
  ///
  /// In it, this message translates to:
  /// **'Tipo'**
  String get dipendenteSubappaltatoreDetailScreenTipo;

  /// No description provided for @dipendenteSubappaltatoreDetailScreenLavoratoreAutonomo.
  ///
  /// In it, this message translates to:
  /// **'Lavoratore autonomo'**
  String get dipendenteSubappaltatoreDetailScreenLavoratoreAutonomo;

  /// No description provided for @dipendenteSubappaltatoreDetailScreenNessunCantiere.
  ///
  /// In it, this message translates to:
  /// **'Il subappaltatore non è associato a nessun cantiere.'**
  String get dipendenteSubappaltatoreDetailScreenNessunCantiere;

  /// No description provided for @dipendenteSubappaltatoreDetailScreenScadenzeDocumenti.
  ///
  /// In it, this message translates to:
  /// **'Scadenze documenti e certificazioni'**
  String get dipendenteSubappaltatoreDetailScreenScadenzeDocumenti;

  /// No description provided for @dipendenteSubappaltatoreDetailScreenAggiungiScadenza.
  ///
  /// In it, this message translates to:
  /// **'Aggiungi scadenza'**
  String get dipendenteSubappaltatoreDetailScreenAggiungiScadenza;

  /// No description provided for @dipendenteSubappaltatoreDetailScreenNessunaScadenza.
  ///
  /// In it, this message translates to:
  /// **'Nessuna scadenza registrata per questo dipendente.'**
  String get dipendenteSubappaltatoreDetailScreenNessunaScadenza;

  /// No description provided for @dipendenteSubappaltatoreFormDialogNuovo.
  ///
  /// In it, this message translates to:
  /// **'Nuovo dipendente'**
  String get dipendenteSubappaltatoreFormDialogNuovo;

  /// No description provided for @dipendenteSubappaltatoreFormDialogModifica.
  ///
  /// In it, this message translates to:
  /// **'Modifica dipendente'**
  String get dipendenteSubappaltatoreFormDialogModifica;

  /// No description provided for @dipendenteSubappaltatoreFormDialogNome.
  ///
  /// In it, this message translates to:
  /// **'Nome*'**
  String get dipendenteSubappaltatoreFormDialogNome;

  /// No description provided for @dipendenteSubappaltatoreFormDialogCognome.
  ///
  /// In it, this message translates to:
  /// **'Cognome*'**
  String get dipendenteSubappaltatoreFormDialogCognome;

  /// No description provided for @dipendenteSubappaltatoreFormDialogNoteHelper.
  ///
  /// In it, this message translates to:
  /// **'Mostrate nel riquadro \"Informazioni\" della pagina del dipendente'**
  String get dipendenteSubappaltatoreFormDialogNoteHelper;

  /// No description provided for @dipendenteSubappaltatoreFormDialogLavoratoreAutonomo.
  ///
  /// In it, this message translates to:
  /// **'Lavoratore autonomo'**
  String get dipendenteSubappaltatoreFormDialogLavoratoreAutonomo;

  /// No description provided for @dipendenteSubappaltatoreFormDialogLavoratoreAutonomoSubtitle.
  ///
  /// In it, this message translates to:
  /// **'Oltre alle scadenze del dipendente può registrare anche quelle riservate ai lavoratori autonomi'**
  String get dipendenteSubappaltatoreFormDialogLavoratoreAutonomoSubtitle;

  /// No description provided for @modificaScadenzaDocumentoDialogModificaTipo.
  ///
  /// In it, this message translates to:
  /// **'Modifica {tipo}'**
  String modificaScadenzaDocumentoDialogModificaTipo(String tipo);

  /// No description provided for @modificaScadenzaDocumentoDialogModificaScadenza.
  ///
  /// In it, this message translates to:
  /// **'Modifica scadenza'**
  String get modificaScadenzaDocumentoDialogModificaScadenza;

  /// No description provided for @modificaScadenzaDocumentoDialogDataScadenza.
  ///
  /// In it, this message translates to:
  /// **'Data di scadenza'**
  String get modificaScadenzaDocumentoDialogDataScadenza;

  /// No description provided for @notaMisuraDialogTitle.
  ///
  /// In it, this message translates to:
  /// **'Nota — {nome} — {tipo}'**
  String notaMisuraDialogTitle(String nome, String tipo);

  /// No description provided for @notaScadenzaGeneraleDialogTitle.
  ///
  /// In it, this message translates to:
  /// **'Nota — {nome}'**
  String notaScadenzaGeneraleDialogTitle(String nome);

  /// No description provided for @dipendentiPresentiDialogTitle.
  ///
  /// In it, this message translates to:
  /// **'Dipendenti presenti — {nome}'**
  String dipendentiPresentiDialogTitle(String nome);

  /// No description provided for @dipendentiPresentiDialogNessunDipendente.
  ///
  /// In it, this message translates to:
  /// **'Nessun dipendente registrato per questo subappaltatore.'**
  String get dipendentiPresentiDialogNessunDipendente;

  /// No description provided for @dipendentiPresentiDialogNote.
  ///
  /// In it, this message translates to:
  /// **'Note: {note}'**
  String dipendentiPresentiDialogNote(String note);

  /// No description provided for @primoSoccorsoScreenTitle.
  ///
  /// In it, this message translates to:
  /// **'Primo Soccorso'**
  String get primoSoccorsoScreenTitle;

  /// No description provided for @primoSoccorsoScreenStandardProductsLabel.
  ///
  /// In it, this message translates to:
  /// **'Prodotti standard'**
  String get primoSoccorsoScreenStandardProductsLabel;

  /// No description provided for @primoSoccorsoScreenNewItemLabel.
  ///
  /// In it, this message translates to:
  /// **'Nuovo elemento'**
  String get primoSoccorsoScreenNewItemLabel;

  /// No description provided for @primoSoccorsoScreenUpcomingDeadlines.
  ///
  /// In it, this message translates to:
  /// **'Scadenze imminenti'**
  String get primoSoccorsoScreenUpcomingDeadlines;

  /// No description provided for @primoSoccorsoScreenHideDeadlinesTooltip.
  ///
  /// In it, this message translates to:
  /// **'Nascondi scadenze'**
  String get primoSoccorsoScreenHideDeadlinesTooltip;

  /// No description provided for @primoSoccorsoScreenShowDeadlinesTooltip.
  ///
  /// In it, this message translates to:
  /// **'Mostra scadenze'**
  String get primoSoccorsoScreenShowDeadlinesTooltip;

  /// No description provided for @primoSoccorsoScreenSectionTitle.
  ///
  /// In it, this message translates to:
  /// **'Cassette e Pacchetti di primo soccorso'**
  String get primoSoccorsoScreenSectionTitle;

  /// No description provided for @primoSoccorsoScreenHideAllTooltip.
  ///
  /// In it, this message translates to:
  /// **'Nascondi tutte'**
  String get primoSoccorsoScreenHideAllTooltip;

  /// No description provided for @primoSoccorsoScreenShowAllTooltip.
  ///
  /// In it, this message translates to:
  /// **'Mostra tutte'**
  String get primoSoccorsoScreenShowAllTooltip;

  /// No description provided for @primoSoccorsoScreenSearchHint.
  ///
  /// In it, this message translates to:
  /// **'Cerca per numero, posizione o tipologia'**
  String get primoSoccorsoScreenSearchHint;

  /// No description provided for @primoSoccorsoScreenNoItemsLoaded.
  ///
  /// In it, this message translates to:
  /// **'Nessun elemento caricato.'**
  String get primoSoccorsoScreenNoItemsLoaded;

  /// No description provided for @primoSoccorsoScreenNoItemsFound.
  ///
  /// In it, this message translates to:
  /// **'Nessun elemento trovato per \"{query}\".'**
  String primoSoccorsoScreenNoItemsFound(String query);

  /// No description provided for @primoSoccorsoScreenArticleLabel.
  ///
  /// In it, this message translates to:
  /// **'Articolo'**
  String get primoSoccorsoScreenArticleLabel;

  /// No description provided for @primoSoccorsoScreenLocationLabel.
  ///
  /// In it, this message translates to:
  /// **'Ubicazione'**
  String get primoSoccorsoScreenLocationLabel;

  /// No description provided for @primoSoccorsoScreenDeadlineNoteLabel.
  ///
  /// In it, this message translates to:
  /// **'Nota scadenza'**
  String get primoSoccorsoScreenDeadlineNoteLabel;

  /// No description provided for @primoSoccorsoScreenEditNoteTooltip.
  ///
  /// In it, this message translates to:
  /// **'Modifica nota'**
  String get primoSoccorsoScreenEditNoteTooltip;

  /// No description provided for @primoSoccorsoScreenEditItemTooltip.
  ///
  /// In it, this message translates to:
  /// **'Modifica elemento'**
  String get primoSoccorsoScreenEditItemTooltip;

  /// No description provided for @primoSoccorsoScreenDeleteItemTooltip.
  ///
  /// In it, this message translates to:
  /// **'Elimina elemento'**
  String get primoSoccorsoScreenDeleteItemTooltip;

  /// No description provided for @primoSoccorsoScreenDeleteConfirmTitle.
  ///
  /// In it, this message translates to:
  /// **'Eliminare elemento?'**
  String get primoSoccorsoScreenDeleteConfirmTitle;

  /// No description provided for @primoSoccorsoScreenDeleteConfirmMessage.
  ///
  /// In it, this message translates to:
  /// **'Eliminare \"{numero}\"? L\'operazione non è reversibile.'**
  String primoSoccorsoScreenDeleteConfirmMessage(String numero);

  /// No description provided for @primoSoccorsoScreenHideInfoTooltip.
  ///
  /// In it, this message translates to:
  /// **'Nascondi info'**
  String get primoSoccorsoScreenHideInfoTooltip;

  /// No description provided for @primoSoccorsoScreenShowInfoTooltip.
  ///
  /// In it, this message translates to:
  /// **'Mostra info'**
  String get primoSoccorsoScreenShowInfoTooltip;

  /// No description provided for @primoSoccorsoScreenChecksSectionTitle.
  ///
  /// In it, this message translates to:
  /// **'Controlli e Scadenze'**
  String get primoSoccorsoScreenChecksSectionTitle;

  /// No description provided for @primoSoccorsoScreenLastCheckLabel.
  ///
  /// In it, this message translates to:
  /// **'Ultima verifica'**
  String get primoSoccorsoScreenLastCheckLabel;

  /// No description provided for @primoSoccorsoScreenNextCheckLabel.
  ///
  /// In it, this message translates to:
  /// **'Prossimo controllo'**
  String get primoSoccorsoScreenNextCheckLabel;

  /// No description provided for @primoSoccorsoScreenNextProductDeadlineLabel.
  ///
  /// In it, this message translates to:
  /// **'Prossima scadenza prodotti'**
  String get primoSoccorsoScreenNextProductDeadlineLabel;

  /// No description provided for @primoSoccorsoScreenNotaDialogTitle.
  ///
  /// In it, this message translates to:
  /// **'Nota — {titolo}'**
  String primoSoccorsoScreenNotaDialogTitle(String titolo);

  /// No description provided for @primoSoccorsoScreenNextCheckType.
  ///
  /// In it, this message translates to:
  /// **'Prossimo Controllo'**
  String get primoSoccorsoScreenNextCheckType;

  /// No description provided for @primoSoccorsoScreenProductDeadlineType.
  ///
  /// In it, this message translates to:
  /// **'Scadenza {nomeProdotto}'**
  String primoSoccorsoScreenProductDeadlineType(String nomeProdotto);

  /// No description provided for @primoSoccorsoScreenLocationWarehouse.
  ///
  /// In it, this message translates to:
  /// **'In magazzino'**
  String get primoSoccorsoScreenLocationWarehouse;

  /// No description provided for @primoSoccorsoScreenLocationOffice.
  ///
  /// In it, this message translates to:
  /// **'In ufficio'**
  String get primoSoccorsoScreenLocationOffice;

  /// No description provided for @primoSoccorsoScreenLocationSite.
  ///
  /// In it, this message translates to:
  /// **'In cantiere {nome}'**
  String primoSoccorsoScreenLocationSite(String nome);

  /// No description provided for @primoSoccorsoScreenLocationVehicle.
  ///
  /// In it, this message translates to:
  /// **'Su automezzo {nome}'**
  String primoSoccorsoScreenLocationVehicle(String nome);

  /// No description provided for @primoSoccorsoScreenLocationUnspecified.
  ///
  /// In it, this message translates to:
  /// **'Non specificata'**
  String get primoSoccorsoScreenLocationUnspecified;

  /// No description provided for @impiantiScreenPdfOffice.
  ///
  /// In it, this message translates to:
  /// **'Ufficio'**
  String get impiantiScreenPdfOffice;

  /// No description provided for @impiantiScreenPdfWarehouse.
  ///
  /// In it, this message translates to:
  /// **'Magazzino'**
  String get impiantiScreenPdfWarehouse;

  /// No description provided for @impiantiScreenPdfUnspecified.
  ///
  /// In it, this message translates to:
  /// **'Non specificato'**
  String get impiantiScreenPdfUnspecified;

  /// No description provided for @impiantiScreenColType.
  ///
  /// In it, this message translates to:
  /// **'Tipologia'**
  String get impiantiScreenColType;

  /// No description provided for @impiantiScreenColLocation.
  ///
  /// In it, this message translates to:
  /// **'Ubicazione'**
  String get impiantiScreenColLocation;

  /// No description provided for @impiantiScreenColInstallerCompany.
  ///
  /// In it, this message translates to:
  /// **'Ditta installazione'**
  String get impiantiScreenColInstallerCompany;

  /// No description provided for @impiantiScreenColInstallDate.
  ///
  /// In it, this message translates to:
  /// **'Data installazione'**
  String get impiantiScreenColInstallDate;

  /// No description provided for @impiantiScreenColAssessmentDate.
  ///
  /// In it, this message translates to:
  /// **'Data valutazione'**
  String get impiantiScreenColAssessmentDate;

  /// No description provided for @impiantiScreenColInternalMaintDate.
  ///
  /// In it, this message translates to:
  /// **'Data manut. interna'**
  String get impiantiScreenColInternalMaintDate;

  /// No description provided for @impiantiScreenColInternalMaintDeadline.
  ///
  /// In it, this message translates to:
  /// **'Scad. manut. interna'**
  String get impiantiScreenColInternalMaintDeadline;

  /// No description provided for @impiantiScreenColInternalCheckType.
  ///
  /// In it, this message translates to:
  /// **'Tipo verifica interna'**
  String get impiantiScreenColInternalCheckType;

  /// No description provided for @impiantiScreenColExternalMaintDate.
  ///
  /// In it, this message translates to:
  /// **'Data manut. esterna'**
  String get impiantiScreenColExternalMaintDate;

  /// No description provided for @impiantiScreenColExternalMaintDeadline.
  ///
  /// In it, this message translates to:
  /// **'Scad. manut. esterna'**
  String get impiantiScreenColExternalMaintDeadline;

  /// No description provided for @impiantiScreenColExternalCheckType.
  ///
  /// In it, this message translates to:
  /// **'Tipo verifica esterna'**
  String get impiantiScreenColExternalCheckType;

  /// No description provided for @impiantiScreenColLightningAssessmentDeadline.
  ///
  /// In it, this message translates to:
  /// **'Scad. val. scariche atmosferiche'**
  String get impiantiScreenColLightningAssessmentDeadline;

  /// No description provided for @impiantiScreenInternalMaintenanceDeadlineType.
  ///
  /// In it, this message translates to:
  /// **'Scadenza Manutenzione Interna'**
  String get impiantiScreenInternalMaintenanceDeadlineType;

  /// No description provided for @impiantiScreenExternalMaintenanceDeadlineType.
  ///
  /// In it, this message translates to:
  /// **'Scadenza Manutenzione Esterna'**
  String get impiantiScreenExternalMaintenanceDeadlineType;

  /// No description provided for @impiantiScreenTitle.
  ///
  /// In it, this message translates to:
  /// **'Impianti'**
  String get impiantiScreenTitle;

  /// No description provided for @impiantiScreenPdfSubtitleCount.
  ///
  /// In it, this message translates to:
  /// **'{count} impianti'**
  String impiantiScreenPdfSubtitleCount(int count);

  /// No description provided for @impiantiScreenPdfSubtitleFilter.
  ///
  /// In it, this message translates to:
  /// **'filtro di ricerca: \"{filtro}\"'**
  String impiantiScreenPdfSubtitleFilter(String filtro);

  /// No description provided for @impiantiScreenPrintErrorMessage.
  ///
  /// In it, this message translates to:
  /// **'Impossibile generare la stampa: {details}'**
  String impiantiScreenPrintErrorMessage(String details);

  /// No description provided for @impiantiScreenNewSystemLabel.
  ///
  /// In it, this message translates to:
  /// **'Nuovo impianto'**
  String get impiantiScreenNewSystemLabel;

  /// No description provided for @impiantiScreenPrintLabel.
  ///
  /// In it, this message translates to:
  /// **'Stampa'**
  String get impiantiScreenPrintLabel;

  /// No description provided for @impiantiScreenUpcomingDeadlines.
  ///
  /// In it, this message translates to:
  /// **'Scadenze imminenti'**
  String get impiantiScreenUpcomingDeadlines;

  /// No description provided for @impiantiScreenHideDeadlinesTooltip.
  ///
  /// In it, this message translates to:
  /// **'Nascondi scadenze'**
  String get impiantiScreenHideDeadlinesTooltip;

  /// No description provided for @impiantiScreenShowDeadlinesTooltip.
  ///
  /// In it, this message translates to:
  /// **'Mostra scadenze'**
  String get impiantiScreenShowDeadlinesTooltip;

  /// No description provided for @impiantiScreenActiveSystemsTitle.
  ///
  /// In it, this message translates to:
  /// **'Impianti attivi'**
  String get impiantiScreenActiveSystemsTitle;

  /// No description provided for @impiantiScreenCollapseAllTooltip.
  ///
  /// In it, this message translates to:
  /// **'Chiudi tutti'**
  String get impiantiScreenCollapseAllTooltip;

  /// No description provided for @impiantiScreenExpandAllTooltip.
  ///
  /// In it, this message translates to:
  /// **'Espandi tutti'**
  String get impiantiScreenExpandAllTooltip;

  /// No description provided for @impiantiScreenSearchHint.
  ///
  /// In it, this message translates to:
  /// **'Cerca per nome'**
  String get impiantiScreenSearchHint;

  /// No description provided for @impiantiScreenNoItemsLoaded.
  ///
  /// In it, this message translates to:
  /// **'Nessun impianto caricato.'**
  String get impiantiScreenNoItemsLoaded;

  /// No description provided for @impiantiScreenNoItemsFound.
  ///
  /// In it, this message translates to:
  /// **'Nessun impianto trovato per \"{query}\".'**
  String impiantiScreenNoItemsFound(String query);

  /// No description provided for @impiantiScreenLocationOfficeLower.
  ///
  /// In it, this message translates to:
  /// **'in Ufficio'**
  String get impiantiScreenLocationOfficeLower;

  /// No description provided for @impiantiScreenLocationWarehouseLower.
  ///
  /// In it, this message translates to:
  /// **'in Magazzino'**
  String get impiantiScreenLocationWarehouseLower;

  /// No description provided for @impiantiScreenLocationUnspecifiedLower.
  ///
  /// In it, this message translates to:
  /// **'non specificata'**
  String get impiantiScreenLocationUnspecifiedLower;

  /// No description provided for @impiantiScreenDeadlineNoteLabel.
  ///
  /// In it, this message translates to:
  /// **'Nota scadenza'**
  String get impiantiScreenDeadlineNoteLabel;

  /// No description provided for @impiantiScreenEditNoteTooltip.
  ///
  /// In it, this message translates to:
  /// **'Modifica nota'**
  String get impiantiScreenEditNoteTooltip;

  /// No description provided for @impiantiScreenEditSystemTooltip.
  ///
  /// In it, this message translates to:
  /// **'Modifica impianto'**
  String get impiantiScreenEditSystemTooltip;

  /// No description provided for @impiantiScreenDeleteSystemTooltip.
  ///
  /// In it, this message translates to:
  /// **'Elimina impianto'**
  String get impiantiScreenDeleteSystemTooltip;

  /// No description provided for @impiantiScreenDeleteConfirmTitle.
  ///
  /// In it, this message translates to:
  /// **'Eliminare impianto?'**
  String get impiantiScreenDeleteConfirmTitle;

  /// No description provided for @impiantiScreenDeleteConfirmMessage.
  ///
  /// In it, this message translates to:
  /// **'Eliminare \"{tipologia}\"? L\'operazione non è reversibile.'**
  String impiantiScreenDeleteConfirmMessage(String tipologia);

  /// No description provided for @impiantiScreenHideInfoTooltip.
  ///
  /// In it, this message translates to:
  /// **'Nascondi info'**
  String get impiantiScreenHideInfoTooltip;

  /// No description provided for @impiantiScreenShowInfoTooltip.
  ///
  /// In it, this message translates to:
  /// **'Mostra info'**
  String get impiantiScreenShowInfoTooltip;

  /// No description provided for @impiantiScreenInstallationSectionTitle.
  ///
  /// In it, this message translates to:
  /// **'Installazione'**
  String get impiantiScreenInstallationSectionTitle;

  /// No description provided for @impiantiScreenInstallerCompanyLabel.
  ///
  /// In it, this message translates to:
  /// **'Ditta installatrice'**
  String get impiantiScreenInstallerCompanyLabel;

  /// No description provided for @impiantiScreenInstallDateLabel.
  ///
  /// In it, this message translates to:
  /// **'Data di Installazione'**
  String get impiantiScreenInstallDateLabel;

  /// No description provided for @impiantiScreenAssessmentDateLabel.
  ///
  /// In it, this message translates to:
  /// **'Data di Valutazione'**
  String get impiantiScreenAssessmentDateLabel;

  /// No description provided for @impiantiScreenInternalMaintenanceSectionTitle.
  ///
  /// In it, this message translates to:
  /// **'Manutenzione Interna'**
  String get impiantiScreenInternalMaintenanceSectionTitle;

  /// No description provided for @impiantiScreenInternalMaintDateLabel.
  ///
  /// In it, this message translates to:
  /// **'Data manutenzione interna'**
  String get impiantiScreenInternalMaintDateLabel;

  /// No description provided for @impiantiScreenInternalMaintDeadlineLabel.
  ///
  /// In it, this message translates to:
  /// **'Scadenza manutenzione interna'**
  String get impiantiScreenInternalMaintDeadlineLabel;

  /// No description provided for @impiantiScreenCheckTypeLabel.
  ///
  /// In it, this message translates to:
  /// **'Tipo di Verifica'**
  String get impiantiScreenCheckTypeLabel;

  /// No description provided for @impiantiScreenExternalMaintenanceSectionTitle.
  ///
  /// In it, this message translates to:
  /// **'Manutenzione Esterna'**
  String get impiantiScreenExternalMaintenanceSectionTitle;

  /// No description provided for @impiantiScreenExternalMaintDateLabel.
  ///
  /// In it, this message translates to:
  /// **'Data manutenzione esterna'**
  String get impiantiScreenExternalMaintDateLabel;

  /// No description provided for @impiantiScreenExternalMaintDeadlineLabel.
  ///
  /// In it, this message translates to:
  /// **'Scadenza manutenzione esterna'**
  String get impiantiScreenExternalMaintDeadlineLabel;

  /// No description provided for @impiantiScreenLightningSectionTitle.
  ///
  /// In it, this message translates to:
  /// **'Scariche Atmosferiche'**
  String get impiantiScreenLightningSectionTitle;

  /// No description provided for @impiantiScreenLightningAssessmentDeadlineLabel.
  ///
  /// In it, this message translates to:
  /// **'Scadenza valutazione scariche atmosferiche'**
  String get impiantiScreenLightningAssessmentDeadlineLabel;

  /// No description provided for @impiantiScreenAdditionalNotesSectionTitle.
  ///
  /// In it, this message translates to:
  /// **'Note aggiuntive'**
  String get impiantiScreenAdditionalNotesSectionTitle;

  /// No description provided for @macchinarioFormDialogOwnershipOwned.
  ///
  /// In it, this message translates to:
  /// **'Di Proprietà'**
  String get macchinarioFormDialogOwnershipOwned;

  /// No description provided for @macchinarioFormDialogOwnershipRented.
  ///
  /// In it, this message translates to:
  /// **'Noleggio'**
  String get macchinarioFormDialogOwnershipRented;

  /// No description provided for @macchinarioFormDialogOwnershipLeased.
  ///
  /// In it, this message translates to:
  /// **'Leasing'**
  String get macchinarioFormDialogOwnershipLeased;

  /// No description provided for @macchinarioFormDialogNewTitle.
  ///
  /// In it, this message translates to:
  /// **'Nuovo macchinario'**
  String get macchinarioFormDialogNewTitle;

  /// No description provided for @macchinarioFormDialogEditTitle.
  ///
  /// In it, this message translates to:
  /// **'Modifica macchinario'**
  String get macchinarioFormDialogEditTitle;

  /// No description provided for @macchinarioFormDialogModelLabel.
  ///
  /// In it, this message translates to:
  /// **'Modello*'**
  String get macchinarioFormDialogModelLabel;

  /// No description provided for @macchinarioFormDialogSerialNumberLabel.
  ///
  /// In it, this message translates to:
  /// **'Numero matricola'**
  String get macchinarioFormDialogSerialNumberLabel;

  /// No description provided for @macchinarioFormDialogFactoryNumberLabel.
  ///
  /// In it, this message translates to:
  /// **'Numero di fabbrica'**
  String get macchinarioFormDialogFactoryNumberLabel;

  /// No description provided for @macchinarioFormDialogPurchaseYearLabel.
  ///
  /// In it, this message translates to:
  /// **'Anno di acquisto'**
  String get macchinarioFormDialogPurchaseYearLabel;

  /// No description provided for @macchinarioFormDialogTypeLabel.
  ///
  /// In it, this message translates to:
  /// **'Tipologia'**
  String get macchinarioFormDialogTypeLabel;

  /// No description provided for @macchinarioFormDialogUnspecifiedOption.
  ///
  /// In it, this message translates to:
  /// **'Non specificata'**
  String get macchinarioFormDialogUnspecifiedOption;

  /// No description provided for @macchinarioFormDialogOwnershipLabel.
  ///
  /// In it, this message translates to:
  /// **'Proprietà'**
  String get macchinarioFormDialogOwnershipLabel;

  /// No description provided for @macchinarioFormDialogLeasingCompanyLabel.
  ///
  /// In it, this message translates to:
  /// **'Compagnia di Leasing'**
  String get macchinarioFormDialogLeasingCompanyLabel;

  /// No description provided for @macchinarioFormDialogLeasingDeadlineLabel.
  ///
  /// In it, this message translates to:
  /// **'Scadenza Leasing'**
  String get macchinarioFormDialogLeasingDeadlineLabel;

  /// No description provided for @macchinarioFormDialogRentalCompanyLabel.
  ///
  /// In it, this message translates to:
  /// **'Azienda di Noleggio'**
  String get macchinarioFormDialogRentalCompanyLabel;

  /// No description provided for @macchinarioFormDialogRentalEmailLabel.
  ///
  /// In it, this message translates to:
  /// **'Email dell\'azienda di noleggio'**
  String get macchinarioFormDialogRentalEmailLabel;

  /// No description provided for @macchinarioFormDialogInvalidEmailValidator.
  ///
  /// In it, this message translates to:
  /// **'Inserisci email valida'**
  String get macchinarioFormDialogInvalidEmailValidator;

  /// No description provided for @macchinarioFormDialogCivaInailLabel.
  ///
  /// In it, this message translates to:
  /// **'Presente in CIVA/INAIL'**
  String get macchinarioFormDialogCivaInailLabel;

  /// No description provided for @macchinarioFormDialogInUseLabel.
  ///
  /// In it, this message translates to:
  /// **'In uso?'**
  String get macchinarioFormDialogInUseLabel;

  /// No description provided for @macchinarioFormDialogLocationSectionTitle.
  ///
  /// In it, this message translates to:
  /// **'Ubicazione'**
  String get macchinarioFormDialogLocationSectionTitle;

  /// No description provided for @macchinarioFormDialogLocationTypeLabel.
  ///
  /// In it, this message translates to:
  /// **'Tipo ubicazione'**
  String get macchinarioFormDialogLocationTypeLabel;

  /// No description provided for @macchinarioFormDialogLocationWarehouse.
  ///
  /// In it, this message translates to:
  /// **'Magazzino'**
  String get macchinarioFormDialogLocationWarehouse;

  /// No description provided for @macchinarioFormDialogLocationSite.
  ///
  /// In it, this message translates to:
  /// **'Cantiere'**
  String get macchinarioFormDialogLocationSite;

  /// No description provided for @macchinarioFormDialogLocationVehicle.
  ///
  /// In it, this message translates to:
  /// **'Automezzo'**
  String get macchinarioFormDialogLocationVehicle;

  /// No description provided for @macchinarioFormDialogSiteValidator.
  ///
  /// In it, this message translates to:
  /// **'Seleziona un cantiere'**
  String get macchinarioFormDialogSiteValidator;

  /// No description provided for @macchinarioFormDialogVehicleValidator.
  ///
  /// In it, this message translates to:
  /// **'Seleziona un automezzo'**
  String get macchinarioFormDialogVehicleValidator;

  /// No description provided for @macchinarioFormDialogInsuranceCompanyLabel.
  ///
  /// In it, this message translates to:
  /// **'Compagnia assicurativa'**
  String get macchinarioFormDialogInsuranceCompanyLabel;

  /// No description provided for @macchinarioFormDialogInsuranceDeadlineLabel.
  ///
  /// In it, this message translates to:
  /// **'Scadenza Assicurazione'**
  String get macchinarioFormDialogInsuranceDeadlineLabel;

  /// No description provided for @macchinarioFormDialogRemoveInsuranceDeadlineTooltip.
  ///
  /// In it, this message translates to:
  /// **'Rimuovi scadenza assicurazione'**
  String get macchinarioFormDialogRemoveInsuranceDeadlineTooltip;

  /// No description provided for @macchinarioFormDialogAddInsuranceDeadlineLabel.
  ///
  /// In it, this message translates to:
  /// **'Aggiungi scadenza assicurazione'**
  String get macchinarioFormDialogAddInsuranceDeadlineLabel;

  /// No description provided for @macchinarioFormDialogInternalMaintenanceSectionTitle.
  ///
  /// In it, this message translates to:
  /// **'Manutenzione interna'**
  String get macchinarioFormDialogInternalMaintenanceSectionTitle;

  /// No description provided for @macchinarioFormDialogInterventionDateLabel.
  ///
  /// In it, this message translates to:
  /// **'Data intervento'**
  String get macchinarioFormDialogInterventionDateLabel;

  /// No description provided for @macchinarioFormDialogDeadlineLabel.
  ///
  /// In it, this message translates to:
  /// **'Scadenza'**
  String get macchinarioFormDialogDeadlineLabel;

  /// No description provided for @macchinarioFormDialogRopeChainCheckSectionTitle.
  ///
  /// In it, this message translates to:
  /// **'Controllo funi/catene'**
  String get macchinarioFormDialogRopeChainCheckSectionTitle;

  /// No description provided for @macchinarioFormDialogCheckDateLabel.
  ///
  /// In it, this message translates to:
  /// **'Data controllo'**
  String get macchinarioFormDialogCheckDateLabel;

  /// No description provided for @macchinarioFormDialogAnnualCheckSectionTitle.
  ///
  /// In it, this message translates to:
  /// **'Verifica annuale'**
  String get macchinarioFormDialogAnnualCheckSectionTitle;

  /// No description provided for @macchinarioFormDialogInspectionDateLabel.
  ///
  /// In it, this message translates to:
  /// **'Data verifica'**
  String get macchinarioFormDialogInspectionDateLabel;

  /// No description provided for @macchinarioFormDialogTwentyYearCheckSectionTitle.
  ///
  /// In it, this message translates to:
  /// **'Verifica ventennale'**
  String get macchinarioFormDialogTwentyYearCheckSectionTitle;

  /// No description provided for @macchinarioFormDialogAdditionalNotesLabel.
  ///
  /// In it, this message translates to:
  /// **'Note aggiuntive'**
  String get macchinarioFormDialogAdditionalNotesLabel;

  /// No description provided for @scaffalatureScreenNextCheckType.
  ///
  /// In it, this message translates to:
  /// **'Prossimo controllo scaffalature'**
  String get scaffalatureScreenNextCheckType;

  /// No description provided for @scaffalatureScreenTitle.
  ///
  /// In it, this message translates to:
  /// **'Scaffalature'**
  String get scaffalatureScreenTitle;

  /// No description provided for @scaffalatureScreenAddLabel.
  ///
  /// In it, this message translates to:
  /// **'Aggiungi scaffalatura'**
  String get scaffalatureScreenAddLabel;

  /// No description provided for @scaffalatureScreenUpcomingDeadlines.
  ///
  /// In it, this message translates to:
  /// **'Scadenze imminenti'**
  String get scaffalatureScreenUpcomingDeadlines;

  /// No description provided for @scaffalatureScreenHideDeadlinesTooltip.
  ///
  /// In it, this message translates to:
  /// **'Nascondi scadenze'**
  String get scaffalatureScreenHideDeadlinesTooltip;

  /// No description provided for @scaffalatureScreenShowDeadlinesTooltip.
  ///
  /// In it, this message translates to:
  /// **'Mostra scadenze'**
  String get scaffalatureScreenShowDeadlinesTooltip;

  /// No description provided for @scaffalatureScreenSectionTitle.
  ///
  /// In it, this message translates to:
  /// **'Scaffalature presenti'**
  String get scaffalatureScreenSectionTitle;

  /// No description provided for @scaffalatureScreenHideAllTooltip.
  ///
  /// In it, this message translates to:
  /// **'Nascondi tutti'**
  String get scaffalatureScreenHideAllTooltip;

  /// No description provided for @scaffalatureScreenShowAllTooltip.
  ///
  /// In it, this message translates to:
  /// **'Mostra tutti'**
  String get scaffalatureScreenShowAllTooltip;

  /// No description provided for @scaffalatureScreenNoItemsLoaded.
  ///
  /// In it, this message translates to:
  /// **'Nessun elemento caricato.'**
  String get scaffalatureScreenNoItemsLoaded;

  /// No description provided for @scaffalatureScreenIdLabel.
  ///
  /// In it, this message translates to:
  /// **'ID scaffalatura'**
  String get scaffalatureScreenIdLabel;

  /// No description provided for @scaffalatureScreenLastCheckLabel.
  ///
  /// In it, this message translates to:
  /// **'Ultima verifica'**
  String get scaffalatureScreenLastCheckLabel;

  /// No description provided for @scaffalatureScreenDeadlineNoteLabel.
  ///
  /// In it, this message translates to:
  /// **'Nota scadenza'**
  String get scaffalatureScreenDeadlineNoteLabel;

  /// No description provided for @scaffalatureScreenEditNoteTooltip.
  ///
  /// In it, this message translates to:
  /// **'Modifica nota'**
  String get scaffalatureScreenEditNoteTooltip;

  /// No description provided for @scaffalatureScreenCardTitle.
  ///
  /// In it, this message translates to:
  /// **'Scaffalatura ID #{id}'**
  String scaffalatureScreenCardTitle(String id);

  /// No description provided for @scaffalatureScreenNextCheckLabel.
  ///
  /// In it, this message translates to:
  /// **'Prossima verifica'**
  String get scaffalatureScreenNextCheckLabel;

  /// No description provided for @scaffalatureScreenDeleteTooltip.
  ///
  /// In it, this message translates to:
  /// **'Elimina scaffale'**
  String get scaffalatureScreenDeleteTooltip;

  /// No description provided for @scaffalatureScreenDeleteConfirmTitle.
  ///
  /// In it, this message translates to:
  /// **'Eliminare scaffalatura?'**
  String get scaffalatureScreenDeleteConfirmTitle;

  /// No description provided for @scaffalatureScreenDeleteConfirmMessage.
  ///
  /// In it, this message translates to:
  /// **'Eliminare la scaffalatura #{id}? L\'operazione non è reversibile.'**
  String scaffalatureScreenDeleteConfirmMessage(String id);

  /// No description provided for @scaffalatureScreenHideInfoTooltip.
  ///
  /// In it, this message translates to:
  /// **'Nascondi info'**
  String get scaffalatureScreenHideInfoTooltip;

  /// No description provided for @scaffalatureScreenShowInfoTooltip.
  ///
  /// In it, this message translates to:
  /// **'Mostra info'**
  String get scaffalatureScreenShowInfoTooltip;

  /// No description provided for @scaffalatureScreenChecksSectionTitle.
  ///
  /// In it, this message translates to:
  /// **'Controlli'**
  String get scaffalatureScreenChecksSectionTitle;

  /// No description provided for @scaffalatureScreenOutcomeLabel.
  ///
  /// In it, this message translates to:
  /// **'Esito'**
  String get scaffalatureScreenOutcomeLabel;

  /// No description provided for @scaffalatureScreenOutcomePositive.
  ///
  /// In it, this message translates to:
  /// **'Positivo'**
  String get scaffalatureScreenOutcomePositive;

  /// No description provided for @scaffalatureScreenOutcomeNegative.
  ///
  /// In it, this message translates to:
  /// **'Negativo'**
  String get scaffalatureScreenOutcomeNegative;

  /// No description provided for @impiantiFormDialogNewTitle.
  ///
  /// In it, this message translates to:
  /// **'Nuovo impianto'**
  String get impiantiFormDialogNewTitle;

  /// No description provided for @impiantiFormDialogEditTitle.
  ///
  /// In it, this message translates to:
  /// **'Modifica impianto'**
  String get impiantiFormDialogEditTitle;

  /// No description provided for @impiantiFormDialogTypeLabel.
  ///
  /// In it, this message translates to:
  /// **'Tipologia*'**
  String get impiantiFormDialogTypeLabel;

  /// No description provided for @impiantiFormDialogLocationTypeLabel.
  ///
  /// In it, this message translates to:
  /// **'Tipo ubicazione'**
  String get impiantiFormDialogLocationTypeLabel;

  /// No description provided for @impiantiFormDialogUnspecifiedOption.
  ///
  /// In it, this message translates to:
  /// **'Non specificata'**
  String get impiantiFormDialogUnspecifiedOption;

  /// No description provided for @impiantiFormDialogLocationWarehouse.
  ///
  /// In it, this message translates to:
  /// **'Magazzino'**
  String get impiantiFormDialogLocationWarehouse;

  /// No description provided for @impiantiFormDialogLocationOffice.
  ///
  /// In it, this message translates to:
  /// **'Ufficio'**
  String get impiantiFormDialogLocationOffice;

  /// No description provided for @impiantiFormDialogInstallationSectionTitle.
  ///
  /// In it, this message translates to:
  /// **'Installazione'**
  String get impiantiFormDialogInstallationSectionTitle;

  /// No description provided for @impiantiFormDialogInstallDateLabel.
  ///
  /// In it, this message translates to:
  /// **'Data installazione'**
  String get impiantiFormDialogInstallDateLabel;

  /// No description provided for @impiantiFormDialogInstallerCompanyLabel.
  ///
  /// In it, this message translates to:
  /// **'Ditta installatrice'**
  String get impiantiFormDialogInstallerCompanyLabel;

  /// No description provided for @impiantiFormDialogAssessmentDateLabel.
  ///
  /// In it, this message translates to:
  /// **'Data di Valutazione'**
  String get impiantiFormDialogAssessmentDateLabel;

  /// No description provided for @impiantiFormDialogInternalMaintenanceSectionTitle.
  ///
  /// In it, this message translates to:
  /// **'Manutenzione Interna'**
  String get impiantiFormDialogInternalMaintenanceSectionTitle;

  /// No description provided for @impiantiFormDialogInternalMaintDateLabel.
  ///
  /// In it, this message translates to:
  /// **'Data di Manutenzione interna'**
  String get impiantiFormDialogInternalMaintDateLabel;

  /// No description provided for @impiantiFormDialogInternalMaintDeadlineLabel.
  ///
  /// In it, this message translates to:
  /// **'Scadenza Manutenzione interna'**
  String get impiantiFormDialogInternalMaintDeadlineLabel;

  /// No description provided for @impiantiFormDialogInternalCheckTypeLabel.
  ///
  /// In it, this message translates to:
  /// **'Tipo di verifica interna'**
  String get impiantiFormDialogInternalCheckTypeLabel;

  /// No description provided for @impiantiFormDialogExternalMaintenanceSectionTitle.
  ///
  /// In it, this message translates to:
  /// **'Manutenzione Esterna'**
  String get impiantiFormDialogExternalMaintenanceSectionTitle;

  /// No description provided for @impiantiFormDialogExternalMaintDateLabel.
  ///
  /// In it, this message translates to:
  /// **'Data di Manutenzione esterna'**
  String get impiantiFormDialogExternalMaintDateLabel;

  /// No description provided for @impiantiFormDialogExternalMaintDeadlineLabel.
  ///
  /// In it, this message translates to:
  /// **'Scadenza Manutenzione esterna'**
  String get impiantiFormDialogExternalMaintDeadlineLabel;

  /// No description provided for @impiantiFormDialogExternalCheckTypeLabel.
  ///
  /// In it, this message translates to:
  /// **'Tipo di verifica esterna'**
  String get impiantiFormDialogExternalCheckTypeLabel;

  /// No description provided for @impiantiFormDialogLightningSectionTitle.
  ///
  /// In it, this message translates to:
  /// **'Scariche Atmosferiche'**
  String get impiantiFormDialogLightningSectionTitle;

  /// No description provided for @impiantiFormDialogLightningAssessmentDeadlineLabel.
  ///
  /// In it, this message translates to:
  /// **'Scadenza Valutazione scariche atmosferiche'**
  String get impiantiFormDialogLightningAssessmentDeadlineLabel;

  /// No description provided for @impiantiFormDialogRemoveLightningAssessmentTooltip.
  ///
  /// In it, this message translates to:
  /// **'Rimuovi valutazione scariche atmosferiche'**
  String get impiantiFormDialogRemoveLightningAssessmentTooltip;

  /// No description provided for @impiantiFormDialogAddLightningAssessmentLabel.
  ///
  /// In it, this message translates to:
  /// **'Aggiungi scadenza valutazione scariche atmosferiche'**
  String get impiantiFormDialogAddLightningAssessmentLabel;

  /// No description provided for @impiantiFormDialogAdditionalNotesLabel.
  ///
  /// In it, this message translates to:
  /// **'Note aggiuntive'**
  String get impiantiFormDialogAdditionalNotesLabel;

  /// No description provided for @documentFormDialogDeadlineRequiredError.
  ///
  /// In it, this message translates to:
  /// **'Questa tipologia richiede una data di scadenza'**
  String get documentFormDialogDeadlineRequiredError;

  /// No description provided for @documentFormDialogTitle.
  ///
  /// In it, this message translates to:
  /// **'Nuova scadenza'**
  String get documentFormDialogTitle;

  /// No description provided for @documentFormDialogSectionTitle.
  ///
  /// In it, this message translates to:
  /// **'Documento'**
  String get documentFormDialogSectionTitle;

  /// No description provided for @documentFormDialogTypeLabel.
  ///
  /// In it, this message translates to:
  /// **'Tipo documento'**
  String get documentFormDialogTypeLabel;

  /// No description provided for @documentFormDialogTypeValidator.
  ///
  /// In it, this message translates to:
  /// **'Seleziona un tipo'**
  String get documentFormDialogTypeValidator;

  /// No description provided for @documentFormDialogDeadlineDateLabel.
  ///
  /// In it, this message translates to:
  /// **'Data di scadenza'**
  String get documentFormDialogDeadlineDateLabel;

  /// No description provided for @documentFormDialogDeadlineDateOptionalLabel.
  ///
  /// In it, this message translates to:
  /// **'Data di scadenza (facoltativa)'**
  String get documentFormDialogDeadlineDateOptionalLabel;

  /// No description provided for @documentFormDialogInfoText.
  ///
  /// In it, this message translates to:
  /// **'Il documento va conservato in sede: qui si registra solo la scadenza, per ricevere i promemoria via mail.'**
  String get documentFormDialogInfoText;

  /// No description provided for @cantiereFormDialogNewTitle.
  ///
  /// In it, this message translates to:
  /// **'Nuovo cantiere'**
  String get cantiereFormDialogNewTitle;

  /// No description provided for @cantiereFormDialogEditTitle.
  ///
  /// In it, this message translates to:
  /// **'Modifica cantiere'**
  String get cantiereFormDialogEditTitle;

  /// No description provided for @cantiereFormDialogInfoSectionTitle.
  ///
  /// In it, this message translates to:
  /// **'Anagrafica del cantiere'**
  String get cantiereFormDialogInfoSectionTitle;

  /// No description provided for @cantiereFormDialogNameLabel.
  ///
  /// In it, this message translates to:
  /// **'Nome*'**
  String get cantiereFormDialogNameLabel;

  /// No description provided for @cantiereFormDialogAddressLabel.
  ///
  /// In it, this message translates to:
  /// **'Indirizzo*'**
  String get cantiereFormDialogAddressLabel;

  /// No description provided for @cantiereFormDialogTownLabel.
  ///
  /// In it, this message translates to:
  /// **'Comune'**
  String get cantiereFormDialogTownLabel;

  /// No description provided for @cantiereFormDialogPostalCodeLabel.
  ///
  /// In it, this message translates to:
  /// **'CAP'**
  String get cantiereFormDialogPostalCodeLabel;

  /// No description provided for @cantiereFormDialogStatusSectionTitle.
  ///
  /// In it, this message translates to:
  /// **'Stato del cantiere'**
  String get cantiereFormDialogStatusSectionTitle;

  /// No description provided for @cantiereFormDialogStatusLabel.
  ///
  /// In it, this message translates to:
  /// **'Stato'**
  String get cantiereFormDialogStatusLabel;

  /// No description provided for @cantiereFormDialogStatusInProgress.
  ///
  /// In it, this message translates to:
  /// **'In corso'**
  String get cantiereFormDialogStatusInProgress;

  /// No description provided for @cantiereFormDialogStatusCompleted.
  ///
  /// In it, this message translates to:
  /// **'Concluso'**
  String get cantiereFormDialogStatusCompleted;

  /// No description provided for @cantiereFormDialogStatusSuspended.
  ///
  /// In it, this message translates to:
  /// **'Sospeso'**
  String get cantiereFormDialogStatusSuspended;

  /// No description provided for @cantiereFormDialogStartDateLabel.
  ///
  /// In it, this message translates to:
  /// **'Data di Inizio'**
  String get cantiereFormDialogStartDateLabel;

  /// No description provided for @cantiereFormDialogSuspensionDateLabel.
  ///
  /// In it, this message translates to:
  /// **'Data di Sospensione'**
  String get cantiereFormDialogSuspensionDateLabel;

  /// No description provided for @cantiereFormDialogCompletionDateLabel.
  ///
  /// In it, this message translates to:
  /// **'Data di Conclusione'**
  String get cantiereFormDialogCompletionDateLabel;

  /// No description provided for @scadenzaGeneraleFormDialogNewTitle.
  ///
  /// In it, this message translates to:
  /// **'Nuova scadenza'**
  String get scadenzaGeneraleFormDialogNewTitle;

  /// No description provided for @scadenzaGeneraleFormDialogEditTitle.
  ///
  /// In it, this message translates to:
  /// **'Modifica scadenza'**
  String get scadenzaGeneraleFormDialogEditTitle;

  /// No description provided for @scadenzaGeneraleFormDialogNameLabel.
  ///
  /// In it, this message translates to:
  /// **'Nome'**
  String get scadenzaGeneraleFormDialogNameLabel;

  /// No description provided for @scadenzaGeneraleFormDialogDeadlineLabel.
  ///
  /// In it, this message translates to:
  /// **'Scadenza'**
  String get scadenzaGeneraleFormDialogDeadlineLabel;

  /// No description provided for @scadenzaGeneraleFormDialogNoticeDaysLabel.
  ///
  /// In it, this message translates to:
  /// **'Giorni di preavviso'**
  String get scadenzaGeneraleFormDialogNoticeDaysLabel;

  /// No description provided for @scadenzaGeneraleFormDialogAdditionalNotesLabel.
  ///
  /// In it, this message translates to:
  /// **'Note aggiuntive'**
  String get scadenzaGeneraleFormDialogAdditionalNotesLabel;

  /// No description provided for @sospendiSollecitiDialogTitle.
  ///
  /// In it, this message translates to:
  /// **'Sospendi solleciti'**
  String get sospendiSollecitiDialogTitle;

  /// No description provided for @sospendiSollecitiDialogDescription1.
  ///
  /// In it, this message translates to:
  /// **'Durante la sospensione le voci già scadute non vengono più risollecitate ogni giorno, né a noi né ai subappaltatori e alle ditte di noleggio.'**
  String get sospendiSollecitiDialogDescription1;

  /// No description provided for @sospendiSollecitiDialogDescription2.
  ///
  /// In it, this message translates to:
  /// **'Le email di preavviso continuano invece ad arrivare normalmente: ciò che entra in scadenza durante la chiusura viene comunque segnalato, una volta sola.'**
  String get sospendiSollecitiDialogDescription2;

  /// No description provided for @sospendiSollecitiDialogUntilLabel.
  ///
  /// In it, this message translates to:
  /// **'Sospendi fino al (compreso)'**
  String get sospendiSollecitiDialogUntilLabel;

  /// No description provided for @sospendiSollecitiDialogInvalidDateMessage.
  ///
  /// In it, this message translates to:
  /// **'La data deve essere odierna o futura.'**
  String get sospendiSollecitiDialogInvalidDateMessage;

  /// No description provided for @sospendiSollecitiDialogSetByMessage.
  ///
  /// In it, this message translates to:
  /// **'Sospensione impostata da {impostataDa}.'**
  String sospendiSollecitiDialogSetByMessage(String impostataDa);

  /// No description provided for @sospendiSollecitiDialogReactivateNowLabel.
  ///
  /// In it, this message translates to:
  /// **'Riattiva subito'**
  String get sospendiSollecitiDialogReactivateNowLabel;

  /// No description provided for @sospendiSollecitiDialogUpdateLabel.
  ///
  /// In it, this message translates to:
  /// **'Aggiorna'**
  String get sospendiSollecitiDialogUpdateLabel;

  /// No description provided for @sospendiSollecitiDialogSuspendLabel.
  ///
  /// In it, this message translates to:
  /// **'Sospendi'**
  String get sospendiSollecitiDialogSuspendLabel;

  /// No description provided for @notaImpiantoDialogTitle.
  ///
  /// In it, this message translates to:
  /// **'Nota — {tipologia} — {tipo}'**
  String notaImpiantoDialogTitle(String tipologia, String tipo);

  /// No description provided for @notaScadenzaFasciaCatenaDialogTitle.
  ///
  /// In it, this message translates to:
  /// **'Nota — {id}'**
  String notaScadenzaFasciaCatenaDialogTitle(String id);

  /// No description provided for @showArticoliDialogTitle.
  ///
  /// In it, this message translates to:
  /// **'Articoli — {tipologia} #{numero}'**
  String showArticoliDialogTitle(String tipologia, String numero);

  /// No description provided for @showArticoliDialogEmptyMessage.
  ///
  /// In it, this message translates to:
  /// **'Nessun prodotto inserito.'**
  String get showArticoliDialogEmptyMessage;

  /// No description provided for @showArticoliDialogQuantityLine.
  ///
  /// In it, this message translates to:
  /// **'Quantità: {quantita}'**
  String showArticoliDialogQuantityLine(String quantita);

  /// No description provided for @showArticoliDialogDeadlineLine.
  ///
  /// In it, this message translates to:
  /// **'Scadenza: {data}'**
  String showArticoliDialogDeadlineLine(String data);

  /// No description provided for @showArticoliDialogNoteLine.
  ///
  /// In it, this message translates to:
  /// **'Note: {note}'**
  String showArticoliDialogNoteLine(String note);

  /// No description provided for @showArticoliDialogDeadlineNoteLine.
  ///
  /// In it, this message translates to:
  /// **'Nota: {nota}'**
  String showArticoliDialogDeadlineNoteLine(String nota);

  /// No description provided for @estintoriScreenTitle.
  ///
  /// In it, this message translates to:
  /// **'Estintori'**
  String get estintoriScreenTitle;

  /// No description provided for @estintoriScreenNewButton.
  ///
  /// In it, this message translates to:
  /// **'Nuovo estintore'**
  String get estintoriScreenNewButton;

  /// No description provided for @estintoriScreenPrintAction.
  ///
  /// In it, this message translates to:
  /// **'Stampa'**
  String get estintoriScreenPrintAction;

  /// No description provided for @estintoriScreenPrintError.
  ///
  /// In it, this message translates to:
  /// **'Impossibile generare la stampa: {details}'**
  String estintoriScreenPrintError(String details);

  /// No description provided for @estintoriScreenUpcomingDeadlines.
  ///
  /// In it, this message translates to:
  /// **'Scadenze imminenti'**
  String get estintoriScreenUpcomingDeadlines;

  /// No description provided for @estintoriScreenHideDeadlines.
  ///
  /// In it, this message translates to:
  /// **'Nascondi scadenze'**
  String get estintoriScreenHideDeadlines;

  /// No description provided for @estintoriScreenShowDeadlines.
  ///
  /// In it, this message translates to:
  /// **'Mostra scadenze'**
  String get estintoriScreenShowDeadlines;

  /// No description provided for @estintoriScreenSectionTitle.
  ///
  /// In it, this message translates to:
  /// **'Estintori presenti'**
  String get estintoriScreenSectionTitle;

  /// No description provided for @estintoriScreenCollapseAll.
  ///
  /// In it, this message translates to:
  /// **'Chiudi tutti'**
  String get estintoriScreenCollapseAll;

  /// No description provided for @estintoriScreenExpandAll.
  ///
  /// In it, this message translates to:
  /// **'Espandi tutti'**
  String get estintoriScreenExpandAll;

  /// No description provided for @estintoriScreenSearchHint.
  ///
  /// In it, this message translates to:
  /// **'Cerca per matricola o posizione'**
  String get estintoriScreenSearchHint;

  /// No description provided for @estintoriScreenEmptyNone.
  ///
  /// In it, this message translates to:
  /// **'Nessun estintore caricato.'**
  String get estintoriScreenEmptyNone;

  /// No description provided for @estintoriScreenEmptySearch.
  ///
  /// In it, this message translates to:
  /// **'Nessun estintore trovato per \"{query}\".'**
  String estintoriScreenEmptySearch(String query);

  /// No description provided for @estintoriScreenLabelMatricola.
  ///
  /// In it, this message translates to:
  /// **'Matricola'**
  String get estintoriScreenLabelMatricola;

  /// No description provided for @estintoriScreenLabelUbicazione.
  ///
  /// In it, this message translates to:
  /// **'Ubicazione'**
  String get estintoriScreenLabelUbicazione;

  /// No description provided for @estintoriScreenLabelNotaScadenza.
  ///
  /// In it, this message translates to:
  /// **'Nota scadenza'**
  String get estintoriScreenLabelNotaScadenza;

  /// No description provided for @estintoriScreenEditNoteTooltip.
  ///
  /// In it, this message translates to:
  /// **'Modifica nota'**
  String get estintoriScreenEditNoteTooltip;

  /// No description provided for @estintoriScreenEditTooltip.
  ///
  /// In it, this message translates to:
  /// **'Modifica estintore'**
  String get estintoriScreenEditTooltip;

  /// No description provided for @estintoriScreenDeleteTooltip.
  ///
  /// In it, this message translates to:
  /// **'Elimina estintore'**
  String get estintoriScreenDeleteTooltip;

  /// No description provided for @estintoriScreenDeleteConfirmTitle.
  ///
  /// In it, this message translates to:
  /// **'Eliminare estintore?'**
  String get estintoriScreenDeleteConfirmTitle;

  /// No description provided for @estintoriScreenDeleteConfirmMessage.
  ///
  /// In it, this message translates to:
  /// **'Eliminare \"{matricola}\"? L\'operazione non è reversibile.'**
  String estintoriScreenDeleteConfirmMessage(String matricola);

  /// No description provided for @estintoriScreenHideInfo.
  ///
  /// In it, this message translates to:
  /// **'Nascondi info'**
  String get estintoriScreenHideInfo;

  /// No description provided for @estintoriScreenShowInfo.
  ///
  /// In it, this message translates to:
  /// **'Mostra info'**
  String get estintoriScreenShowInfo;

  /// No description provided for @estintoriScreenSectionGeneralData.
  ///
  /// In it, this message translates to:
  /// **'Dati generali'**
  String get estintoriScreenSectionGeneralData;

  /// No description provided for @estintoriScreenLabelCapacita.
  ///
  /// In it, this message translates to:
  /// **'Capacità'**
  String get estintoriScreenLabelCapacita;

  /// No description provided for @estintoriScreenLabelTipo.
  ///
  /// In it, this message translates to:
  /// **'Tipo'**
  String get estintoriScreenLabelTipo;

  /// No description provided for @estintoriScreenLabelDataProduzione.
  ///
  /// In it, this message translates to:
  /// **'Data di Produzione'**
  String get estintoriScreenLabelDataProduzione;

  /// No description provided for @estintoriScreenLabelDataMessaInServizio.
  ///
  /// In it, this message translates to:
  /// **'Data messa in servizio'**
  String get estintoriScreenLabelDataMessaInServizio;

  /// No description provided for @estintoriScreenSectionVerificaEsterna.
  ///
  /// In it, this message translates to:
  /// **'Verifica Esterna'**
  String get estintoriScreenSectionVerificaEsterna;

  /// No description provided for @estintoriScreenLabelDataVerificaEsterna.
  ///
  /// In it, this message translates to:
  /// **'Data verifica esterna'**
  String get estintoriScreenLabelDataVerificaEsterna;

  /// No description provided for @estintoriScreenLabelScadenzaVerificaEsterna.
  ///
  /// In it, this message translates to:
  /// **'Scadenza verifica esterna'**
  String get estintoriScreenLabelScadenzaVerificaEsterna;

  /// No description provided for @estintoriScreenSectionRevisione.
  ///
  /// In it, this message translates to:
  /// **'Revisione'**
  String get estintoriScreenSectionRevisione;

  /// No description provided for @estintoriScreenLabelDataUltimaRevisione.
  ///
  /// In it, this message translates to:
  /// **'Data ultima revisione'**
  String get estintoriScreenLabelDataUltimaRevisione;

  /// No description provided for @estintoriScreenLabelScadenzaRevisione.
  ///
  /// In it, this message translates to:
  /// **'Scadenza revisione'**
  String get estintoriScreenLabelScadenzaRevisione;

  /// No description provided for @estintoriScreenSectionCollaudo.
  ///
  /// In it, this message translates to:
  /// **'Collaudo'**
  String get estintoriScreenSectionCollaudo;

  /// No description provided for @estintoriScreenLabelDataCollaudo.
  ///
  /// In it, this message translates to:
  /// **'Data collaudo'**
  String get estintoriScreenLabelDataCollaudo;

  /// No description provided for @estintoriScreenLabelScadenzaCollaudo.
  ///
  /// In it, this message translates to:
  /// **'Scadenza collaudo'**
  String get estintoriScreenLabelScadenzaCollaudo;

  /// No description provided for @estintoriScreenTipoScadenzaCollaudo.
  ///
  /// In it, this message translates to:
  /// **'Scadenza Collaudo'**
  String get estintoriScreenTipoScadenzaCollaudo;

  /// No description provided for @estintoriScreenTipoScadenzaRevisione.
  ///
  /// In it, this message translates to:
  /// **'Scadenza Revisione'**
  String get estintoriScreenTipoScadenzaRevisione;

  /// No description provided for @estintoriScreenTipoScadenzaVerificaEsterna.
  ///
  /// In it, this message translates to:
  /// **'Scadenza Verifica Esterna'**
  String get estintoriScreenTipoScadenzaVerificaEsterna;

  /// No description provided for @estintoriScreenTipoSostituzione.
  ///
  /// In it, this message translates to:
  /// **'Sostituzione (18 anni)'**
  String get estintoriScreenTipoSostituzione;

  /// No description provided for @estintoriScreenLocationWarehouse.
  ///
  /// In it, this message translates to:
  /// **'In magazzino'**
  String get estintoriScreenLocationWarehouse;

  /// No description provided for @estintoriScreenLocationOffice.
  ///
  /// In it, this message translates to:
  /// **'In ufficio'**
  String get estintoriScreenLocationOffice;

  /// No description provided for @estintoriScreenLocationSite.
  ///
  /// In it, this message translates to:
  /// **'In cantiere {nome}'**
  String estintoriScreenLocationSite(String nome);

  /// No description provided for @estintoriScreenLocationVehicle.
  ///
  /// In it, this message translates to:
  /// **'Su automezzo {veicolo}'**
  String estintoriScreenLocationVehicle(String veicolo);

  /// No description provided for @estintoriScreenLocationUnspecified.
  ///
  /// In it, this message translates to:
  /// **'Non specificata'**
  String get estintoriScreenLocationUnspecified;

  /// No description provided for @estintoriScreenPdfCount.
  ///
  /// In it, this message translates to:
  /// **'{count} estintori'**
  String estintoriScreenPdfCount(int count);

  /// No description provided for @estintoriScreenPdfFilter.
  ///
  /// In it, this message translates to:
  /// **'filtro di ricerca: \"{filtro}\"'**
  String estintoriScreenPdfFilter(String filtro);

  /// No description provided for @estintoriScreenPdfColMatricola.
  ///
  /// In it, this message translates to:
  /// **'Num. Matricola'**
  String get estintoriScreenPdfColMatricola;

  /// No description provided for @estintoriScreenPdfColDataProduzione.
  ///
  /// In it, this message translates to:
  /// **'Data produzione'**
  String get estintoriScreenPdfColDataProduzione;

  /// No description provided for @estintoriScreenPdfColScadVerificaEsterna.
  ///
  /// In it, this message translates to:
  /// **'Scad. verifica esterna'**
  String get estintoriScreenPdfColScadVerificaEsterna;

  /// No description provided for @estintoriScreenPdfColDataRevisione.
  ///
  /// In it, this message translates to:
  /// **'Data revisione'**
  String get estintoriScreenPdfColDataRevisione;

  /// No description provided for @estintoriScreenPdfColScadRevisione.
  ///
  /// In it, this message translates to:
  /// **'Scad. revisione'**
  String get estintoriScreenPdfColScadRevisione;

  /// No description provided for @estintoriScreenPdfColScadCollaudo.
  ///
  /// In it, this message translates to:
  /// **'Scad. collaudo'**
  String get estintoriScreenPdfColScadCollaudo;

  /// No description provided for @cassettaPsFormDialogTipoCassetta.
  ///
  /// In it, this message translates to:
  /// **'Cassetta'**
  String get cassettaPsFormDialogTipoCassetta;

  /// No description provided for @cassettaPsFormDialogTipoPacchettoMedicazione.
  ///
  /// In it, this message translates to:
  /// **'Pacchetto di Medicazione'**
  String get cassettaPsFormDialogTipoPacchettoMedicazione;

  /// No description provided for @cassettaPsFormDialogNotSpecified.
  ///
  /// In it, this message translates to:
  /// **'Non specificata'**
  String get cassettaPsFormDialogNotSpecified;

  /// No description provided for @cassettaPsFormDialogAddProduct.
  ///
  /// In it, this message translates to:
  /// **'Aggiungi prodotto'**
  String get cassettaPsFormDialogAddProduct;

  /// No description provided for @cassettaPsFormDialogNoProducts.
  ///
  /// In it, this message translates to:
  /// **'Nessun prodotto inserito.'**
  String get cassettaPsFormDialogNoProducts;

  /// No description provided for @cassettaPsFormDialogQuantityLabel.
  ///
  /// In it, this message translates to:
  /// **'Quantità: {quantita}'**
  String cassettaPsFormDialogQuantityLabel(String quantita);

  /// No description provided for @cassettaPsFormDialogExpiryLabel.
  ///
  /// In it, this message translates to:
  /// **'Scadenza: {data}'**
  String cassettaPsFormDialogExpiryLabel(String data);

  /// No description provided for @cassettaPsFormDialogEditProductTooltip.
  ///
  /// In it, this message translates to:
  /// **'Modifica prodotto'**
  String get cassettaPsFormDialogEditProductTooltip;

  /// No description provided for @cassettaPsFormDialogRemoveProductTooltip.
  ///
  /// In it, this message translates to:
  /// **'Rimuovi prodotto'**
  String get cassettaPsFormDialogRemoveProductTooltip;

  /// No description provided for @cassettaPsFormDialogNewTitle.
  ///
  /// In it, this message translates to:
  /// **'Nuovo elemento'**
  String get cassettaPsFormDialogNewTitle;

  /// No description provided for @cassettaPsFormDialogEditTitle.
  ///
  /// In it, this message translates to:
  /// **'Modifica elemento'**
  String get cassettaPsFormDialogEditTitle;

  /// No description provided for @cassettaPsFormDialogNumberLabel.
  ///
  /// In it, this message translates to:
  /// **'Numero*'**
  String get cassettaPsFormDialogNumberLabel;

  /// No description provided for @cassettaPsFormDialogTypeLabel.
  ///
  /// In it, this message translates to:
  /// **'Tipologia'**
  String get cassettaPsFormDialogTypeLabel;

  /// No description provided for @cassettaPsFormDialogLocationSection.
  ///
  /// In it, this message translates to:
  /// **'Ubicazione'**
  String get cassettaPsFormDialogLocationSection;

  /// No description provided for @cassettaPsFormDialogLocationTypeLabel.
  ///
  /// In it, this message translates to:
  /// **'Tipo ubicazione'**
  String get cassettaPsFormDialogLocationTypeLabel;

  /// No description provided for @cassettaPsFormDialogLocationWarehouse.
  ///
  /// In it, this message translates to:
  /// **'Magazzino'**
  String get cassettaPsFormDialogLocationWarehouse;

  /// No description provided for @cassettaPsFormDialogLocationOffice.
  ///
  /// In it, this message translates to:
  /// **'Ufficio'**
  String get cassettaPsFormDialogLocationOffice;

  /// No description provided for @cassettaPsFormDialogLocationSite.
  ///
  /// In it, this message translates to:
  /// **'Cantiere'**
  String get cassettaPsFormDialogLocationSite;

  /// No description provided for @cassettaPsFormDialogLocationVehicle.
  ///
  /// In it, this message translates to:
  /// **'Automezzo'**
  String get cassettaPsFormDialogLocationVehicle;

  /// No description provided for @cassettaPsFormDialogSiteLabel.
  ///
  /// In it, this message translates to:
  /// **'Cantiere'**
  String get cassettaPsFormDialogSiteLabel;

  /// No description provided for @cassettaPsFormDialogSelectSiteValidator.
  ///
  /// In it, this message translates to:
  /// **'Seleziona un cantiere'**
  String get cassettaPsFormDialogSelectSiteValidator;

  /// No description provided for @cassettaPsFormDialogVehicleLabel.
  ///
  /// In it, this message translates to:
  /// **'Automezzo'**
  String get cassettaPsFormDialogVehicleLabel;

  /// No description provided for @cassettaPsFormDialogSelectVehicleValidator.
  ///
  /// In it, this message translates to:
  /// **'Seleziona un automezzo'**
  String get cassettaPsFormDialogSelectVehicleValidator;

  /// No description provided for @cassettaPsFormDialogLocationDetailsLabel.
  ///
  /// In it, this message translates to:
  /// **'Dettagli aggiuntivi ubicazione'**
  String get cassettaPsFormDialogLocationDetailsLabel;

  /// No description provided for @cassettaPsFormDialogChecksSection.
  ///
  /// In it, this message translates to:
  /// **'Controlli'**
  String get cassettaPsFormDialogChecksSection;

  /// No description provided for @cassettaPsFormDialogLastCheckLabel.
  ///
  /// In it, this message translates to:
  /// **'Ultima Verifica'**
  String get cassettaPsFormDialogLastCheckLabel;

  /// No description provided for @cassettaPsFormDialogNextCheckLabel.
  ///
  /// In it, this message translates to:
  /// **'Prossimo Controllo'**
  String get cassettaPsFormDialogNextCheckLabel;

  /// No description provided for @cassettaPsFormDialogProductsSection.
  ///
  /// In it, this message translates to:
  /// **'Prodotti'**
  String get cassettaPsFormDialogProductsSection;

  /// No description provided for @cassettaPsFormDialogNextProductExpiryTitle.
  ///
  /// In it, this message translates to:
  /// **'Prossima Scadenza Prodotti'**
  String get cassettaPsFormDialogNextProductExpiryTitle;

  /// No description provided for @cassettaPsFormDialogNoProductExpiry.
  ///
  /// In it, this message translates to:
  /// **'Nessuna scadenza prodotti'**
  String get cassettaPsFormDialogNoProductExpiry;

  /// No description provided for @cassettaPsFormDialogNewProductTitle.
  ///
  /// In it, this message translates to:
  /// **'Nuovo prodotto'**
  String get cassettaPsFormDialogNewProductTitle;

  /// No description provided for @cassettaPsFormDialogEditProductTitle.
  ///
  /// In it, this message translates to:
  /// **'Modifica prodotto'**
  String get cassettaPsFormDialogEditProductTitle;

  /// No description provided for @cassettaPsFormDialogProductNameLabel.
  ///
  /// In it, this message translates to:
  /// **'Nome prodotto*'**
  String get cassettaPsFormDialogProductNameLabel;

  /// No description provided for @cassettaPsFormDialogQuantityFieldLabel.
  ///
  /// In it, this message translates to:
  /// **'Quantità'**
  String get cassettaPsFormDialogQuantityFieldLabel;

  /// No description provided for @cassettaPsFormDialogExpiryFieldLabel.
  ///
  /// In it, this message translates to:
  /// **'Scadenza'**
  String get cassettaPsFormDialogExpiryFieldLabel;

  /// No description provided for @misureScreenTitle.
  ///
  /// In it, this message translates to:
  /// **'Misure'**
  String get misureScreenTitle;

  /// No description provided for @misureScreenNewButton.
  ///
  /// In it, this message translates to:
  /// **'Nuova misura'**
  String get misureScreenNewButton;

  /// No description provided for @misureScreenSearchHint.
  ///
  /// In it, this message translates to:
  /// **'Cerca per nome'**
  String get misureScreenSearchHint;

  /// No description provided for @misureScreenEmptyNone.
  ///
  /// In it, this message translates to:
  /// **'Nessuno strumento di misura caricato.'**
  String get misureScreenEmptyNone;

  /// No description provided for @misureScreenEmptySearch.
  ///
  /// In it, this message translates to:
  /// **'Nessuno strumento di misura trovato per \"{query}\".'**
  String misureScreenEmptySearch(String query);

  /// No description provided for @misureScreenUpcomingDeadlines.
  ///
  /// In it, this message translates to:
  /// **'Scadenze imminenti'**
  String get misureScreenUpcomingDeadlines;

  /// No description provided for @misureScreenHideDeadlines.
  ///
  /// In it, this message translates to:
  /// **'Nascondi scadenze'**
  String get misureScreenHideDeadlines;

  /// No description provided for @misureScreenShowDeadlines.
  ///
  /// In it, this message translates to:
  /// **'Mostra scadenze'**
  String get misureScreenShowDeadlines;

  /// No description provided for @misureScreenSectionTitle.
  ///
  /// In it, this message translates to:
  /// **'Strumenti di Misura'**
  String get misureScreenSectionTitle;

  /// No description provided for @misureScreenCollapseAll.
  ///
  /// In it, this message translates to:
  /// **'Chiudi tutti'**
  String get misureScreenCollapseAll;

  /// No description provided for @misureScreenExpandAll.
  ///
  /// In it, this message translates to:
  /// **'Espandi tutti'**
  String get misureScreenExpandAll;

  /// No description provided for @misureScreenLabelModello.
  ///
  /// In it, this message translates to:
  /// **'Modello'**
  String get misureScreenLabelModello;

  /// No description provided for @misureScreenLabelIncaricato.
  ///
  /// In it, this message translates to:
  /// **'Incaricato'**
  String get misureScreenLabelIncaricato;

  /// No description provided for @misureScreenLabelNotaScadenza.
  ///
  /// In it, this message translates to:
  /// **'Nota scadenza'**
  String get misureScreenLabelNotaScadenza;

  /// No description provided for @misureScreenEditNoteTooltip.
  ///
  /// In it, this message translates to:
  /// **'Modifica nota'**
  String get misureScreenEditNoteTooltip;

  /// No description provided for @misureScreenLabelMatricola.
  ///
  /// In it, this message translates to:
  /// **'Matricola'**
  String get misureScreenLabelMatricola;

  /// No description provided for @misureScreenEditTooltip.
  ///
  /// In it, this message translates to:
  /// **'Modifica misura'**
  String get misureScreenEditTooltip;

  /// No description provided for @misureScreenDeleteTooltip.
  ///
  /// In it, this message translates to:
  /// **'Elimina misura'**
  String get misureScreenDeleteTooltip;

  /// No description provided for @misureScreenDeleteConfirmTitle.
  ///
  /// In it, this message translates to:
  /// **'Eliminare strumento di misura?'**
  String get misureScreenDeleteConfirmTitle;

  /// No description provided for @misureScreenDeleteConfirmMessage.
  ///
  /// In it, this message translates to:
  /// **'Eliminare \"{nome}\"? L\'operazione non è reversibile.'**
  String misureScreenDeleteConfirmMessage(String nome);

  /// No description provided for @misureScreenHideInfo.
  ///
  /// In it, this message translates to:
  /// **'Nascondi info'**
  String get misureScreenHideInfo;

  /// No description provided for @misureScreenShowInfo.
  ///
  /// In it, this message translates to:
  /// **'Mostra info'**
  String get misureScreenShowInfo;

  /// No description provided for @misureScreenSectionGeneralData.
  ///
  /// In it, this message translates to:
  /// **'Dati generali'**
  String get misureScreenSectionGeneralData;

  /// No description provided for @misureScreenLabelRifAcq.
  ///
  /// In it, this message translates to:
  /// **'Rif. Acq.'**
  String get misureScreenLabelRifAcq;

  /// No description provided for @misureScreenSectionTaraturaInterna.
  ///
  /// In it, this message translates to:
  /// **'Taratura Interna'**
  String get misureScreenSectionTaraturaInterna;

  /// No description provided for @misureScreenLabelDataUltimaTaratura.
  ///
  /// In it, this message translates to:
  /// **'Data ultima taratura'**
  String get misureScreenLabelDataUltimaTaratura;

  /// No description provided for @misureScreenLabelDataProssimaTaratura.
  ///
  /// In it, this message translates to:
  /// **'Data prossima taratura'**
  String get misureScreenLabelDataProssimaTaratura;

  /// No description provided for @misureScreenSectionTaraturaEsterna.
  ///
  /// In it, this message translates to:
  /// **'Taratura Esterna'**
  String get misureScreenSectionTaraturaEsterna;

  /// No description provided for @misureScreenTipoProssimaTaraturaInterna.
  ///
  /// In it, this message translates to:
  /// **'Prossima taratura interna'**
  String get misureScreenTipoProssimaTaraturaInterna;

  /// No description provided for @misureScreenTipoProssimaTaraturaEsterna.
  ///
  /// In it, this message translates to:
  /// **'Prossima taratura esterna'**
  String get misureScreenTipoProssimaTaraturaEsterna;

  /// No description provided for @subappaltatoreDetailScreenBreadcrumbCantieri.
  ///
  /// In it, this message translates to:
  /// **'Cantieri'**
  String get subappaltatoreDetailScreenBreadcrumbCantieri;

  /// No description provided for @subappaltatoreDetailScreenInfoSection.
  ///
  /// In it, this message translates to:
  /// **'Informazioni:'**
  String get subappaltatoreDetailScreenInfoSection;

  /// No description provided for @subappaltatoreDetailScreenVatLabel.
  ///
  /// In it, this message translates to:
  /// **'P. IVA'**
  String get subappaltatoreDetailScreenVatLabel;

  /// No description provided for @subappaltatoreDetailScreenGeneralDeadlinesTitle.
  ///
  /// In it, this message translates to:
  /// **'Scadenze generali del subappaltatore'**
  String get subappaltatoreDetailScreenGeneralDeadlinesTitle;

  /// No description provided for @subappaltatoreDetailScreenSiteDeadlinesTitle.
  ///
  /// In it, this message translates to:
  /// **'Scadenze subappaltatore nel cantiere'**
  String get subappaltatoreDetailScreenSiteDeadlinesTitle;

  /// No description provided for @subappaltatoreDetailScreenAddDeadline.
  ///
  /// In it, this message translates to:
  /// **'Aggiungi scadenza'**
  String get subappaltatoreDetailScreenAddDeadline;

  /// No description provided for @subappaltatoreDetailScreenNoDeadlinesSubappaltatore.
  ///
  /// In it, this message translates to:
  /// **'Nessuna scadenza registrata per questo subappaltatore.'**
  String get subappaltatoreDetailScreenNoDeadlinesSubappaltatore;

  /// No description provided for @subappaltatoreDetailScreenEmployeeDeadlinesTitle.
  ///
  /// In it, this message translates to:
  /// **'Scadenze dipendenti presenti'**
  String get subappaltatoreDetailScreenEmployeeDeadlinesTitle;

  /// No description provided for @subappaltatoreDetailScreenCollapseAll.
  ///
  /// In it, this message translates to:
  /// **'Chiudi tutti'**
  String get subappaltatoreDetailScreenCollapseAll;

  /// No description provided for @subappaltatoreDetailScreenExpandAll.
  ///
  /// In it, this message translates to:
  /// **'Mostra tutti'**
  String get subappaltatoreDetailScreenExpandAll;

  /// No description provided for @subappaltatoreDetailScreenNoDeadlinesEmployees.
  ///
  /// In it, this message translates to:
  /// **'Nessuna scadenza registrata per i dipendenti presenti in questo cantiere.'**
  String get subappaltatoreDetailScreenNoDeadlinesEmployees;

  /// No description provided for @subappaltatoreDetailScreenDeadlineCountSingular.
  ///
  /// In it, this message translates to:
  /// **'1 scadenza'**
  String get subappaltatoreDetailScreenDeadlineCountSingular;

  /// No description provided for @subappaltatoreDetailScreenDeadlineCountPlural.
  ///
  /// In it, this message translates to:
  /// **'{count} scadenze'**
  String subappaltatoreDetailScreenDeadlineCountPlural(int count);

  /// No description provided for @subappaltatoreDetailScreenExpiredCountSingular.
  ///
  /// In it, this message translates to:
  /// **', 1 scaduto'**
  String get subappaltatoreDetailScreenExpiredCountSingular;

  /// No description provided for @subappaltatoreDetailScreenExpiredCountPlural.
  ///
  /// In it, this message translates to:
  /// **', {count} scaduti'**
  String subappaltatoreDetailScreenExpiredCountPlural(int count);

  /// No description provided for @subappaltatoreDetailScreenUpcomingCount.
  ///
  /// In it, this message translates to:
  /// **', {count} in scadenza'**
  String subappaltatoreDetailScreenUpcomingCount(int count);

  /// No description provided for @subappaltatoreDetailScreenAutonomousWorker.
  ///
  /// In it, this message translates to:
  /// **' · Lavoratore autonomo'**
  String get subappaltatoreDetailScreenAutonomousWorker;

  /// No description provided for @subappaltatoreDetailScreenNoteSuffix.
  ///
  /// In it, this message translates to:
  /// **' · Note: {note}'**
  String subappaltatoreDetailScreenNoteSuffix(String note);

  /// No description provided for @subappaltatoreDetailScreenHideDeadlines.
  ///
  /// In it, this message translates to:
  /// **'Nascondi scadenze'**
  String get subappaltatoreDetailScreenHideDeadlines;

  /// No description provided for @subappaltatoreDetailScreenShowDeadlines.
  ///
  /// In it, this message translates to:
  /// **'Mostra scadenze'**
  String get subappaltatoreDetailScreenShowDeadlines;

  /// No description provided for @subappaltatoreDetailScreenOpenEmployeePage.
  ///
  /// In it, this message translates to:
  /// **'Apri pagina dipendente'**
  String get subappaltatoreDetailScreenOpenEmployeePage;

  /// No description provided for @misureFormDialogNewTitle.
  ///
  /// In it, this message translates to:
  /// **'Nuova misura'**
  String get misureFormDialogNewTitle;

  /// No description provided for @misureFormDialogEditTitle.
  ///
  /// In it, this message translates to:
  /// **'Modifica misura'**
  String get misureFormDialogEditTitle;

  /// No description provided for @misureFormDialogNameLabel.
  ///
  /// In it, this message translates to:
  /// **'Nome*'**
  String get misureFormDialogNameLabel;

  /// No description provided for @misureFormDialogReferenceLabel.
  ///
  /// In it, this message translates to:
  /// **'Riferimento'**
  String get misureFormDialogReferenceLabel;

  /// No description provided for @misureFormDialogSerialLabel.
  ///
  /// In it, this message translates to:
  /// **'Matricola'**
  String get misureFormDialogSerialLabel;

  /// No description provided for @misureFormDialogInternalCalibrationSection.
  ///
  /// In it, this message translates to:
  /// **'Taratura Interna'**
  String get misureFormDialogInternalCalibrationSection;

  /// No description provided for @misureFormDialogAssignedToLabel.
  ///
  /// In it, this message translates to:
  /// **'Incaricato'**
  String get misureFormDialogAssignedToLabel;

  /// No description provided for @misureFormDialogNotSpecified.
  ///
  /// In it, this message translates to:
  /// **'Non specificato'**
  String get misureFormDialogNotSpecified;

  /// No description provided for @misureFormDialogLastCalibrationLabel.
  ///
  /// In it, this message translates to:
  /// **'Data ultima taratura'**
  String get misureFormDialogLastCalibrationLabel;

  /// No description provided for @misureFormDialogNextCalibrationLabel.
  ///
  /// In it, this message translates to:
  /// **'Data prossima taratura'**
  String get misureFormDialogNextCalibrationLabel;

  /// No description provided for @misureFormDialogExternalCalibrationSection.
  ///
  /// In it, this message translates to:
  /// **'Taratura Esterna'**
  String get misureFormDialogExternalCalibrationSection;

  /// No description provided for @misureFormDialogExternalAssignedToLabel.
  ///
  /// In it, this message translates to:
  /// **'Incaricato taratura esterna'**
  String get misureFormDialogExternalAssignedToLabel;

  /// No description provided for @misureFormDialogAdditionalNotesLabel.
  ///
  /// In it, this message translates to:
  /// **'Note aggiuntive'**
  String get misureFormDialogAdditionalNotesLabel;

  /// No description provided for @articoliStandardCassettePsScreenTipoCassetta.
  ///
  /// In it, this message translates to:
  /// **'Cassetta'**
  String get articoliStandardCassettePsScreenTipoCassetta;

  /// No description provided for @articoliStandardCassettePsScreenTipoPacchettoMedicazione.
  ///
  /// In it, this message translates to:
  /// **'Pacchetto di Medicazione'**
  String get articoliStandardCassettePsScreenTipoPacchettoMedicazione;

  /// No description provided for @articoliStandardCassettePsScreenBreadcrumbFirstAid.
  ///
  /// In it, this message translates to:
  /// **'Primo Soccorso'**
  String get articoliStandardCassettePsScreenBreadcrumbFirstAid;

  /// No description provided for @articoliStandardCassettePsScreenBreadcrumbStandardProducts.
  ///
  /// In it, this message translates to:
  /// **'Prodotti standard'**
  String get articoliStandardCassettePsScreenBreadcrumbStandardProducts;

  /// No description provided for @articoliStandardCassettePsScreenDescription.
  ///
  /// In it, this message translates to:
  /// **'Questi prodotti vengono inseriti automaticamente quando si sceglie la tipologia in una nuova cassetta o pacchetto di medicazione.\nQuantità e scadenza restano modificabili per ogni singolo elemento.'**
  String get articoliStandardCassettePsScreenDescription;

  /// No description provided for @articoliStandardCassettePsScreenAddProduct.
  ///
  /// In it, this message translates to:
  /// **'Aggiungi prodotto'**
  String get articoliStandardCassettePsScreenAddProduct;

  /// No description provided for @articoliStandardCassettePsScreenEmpty.
  ///
  /// In it, this message translates to:
  /// **'Nessun prodotto standard inserito.'**
  String get articoliStandardCassettePsScreenEmpty;

  /// No description provided for @articoliStandardCassettePsScreenContentSection.
  ///
  /// In it, this message translates to:
  /// **'Contenuto'**
  String get articoliStandardCassettePsScreenContentSection;

  /// No description provided for @articoliStandardCassettePsScreenEditTooltip.
  ///
  /// In it, this message translates to:
  /// **'Modifica prodotto'**
  String get articoliStandardCassettePsScreenEditTooltip;

  /// No description provided for @articoliStandardCassettePsScreenDeleteTooltip.
  ///
  /// In it, this message translates to:
  /// **'Elimina prodotto'**
  String get articoliStandardCassettePsScreenDeleteTooltip;

  /// No description provided for @articoliStandardCassettePsScreenDeleteConfirmTitle.
  ///
  /// In it, this message translates to:
  /// **'Eliminare prodotto?'**
  String get articoliStandardCassettePsScreenDeleteConfirmTitle;

  /// No description provided for @articoliStandardCassettePsScreenDeleteConfirmMessage.
  ///
  /// In it, this message translates to:
  /// **'Eliminare \"{nome}\" dai prodotti standard? L\'operazione non è reversibile.'**
  String articoliStandardCassettePsScreenDeleteConfirmMessage(String nome);

  /// No description provided for @articoloStandardCassettaPsFormDialogTipoCassetta.
  ///
  /// In it, this message translates to:
  /// **'Cassetta'**
  String get articoloStandardCassettaPsFormDialogTipoCassetta;

  /// No description provided for @articoloStandardCassettaPsFormDialogTipoPacchettoMedicazione.
  ///
  /// In it, this message translates to:
  /// **'Pacchetto di Medicazione'**
  String get articoloStandardCassettaPsFormDialogTipoPacchettoMedicazione;

  /// No description provided for @articoloStandardCassettaPsFormDialogNewTitle.
  ///
  /// In it, this message translates to:
  /// **'Nuovo prodotto standard'**
  String get articoloStandardCassettaPsFormDialogNewTitle;

  /// No description provided for @articoloStandardCassettaPsFormDialogEditTitle.
  ///
  /// In it, this message translates to:
  /// **'Modifica prodotto standard'**
  String get articoloStandardCassettaPsFormDialogEditTitle;

  /// No description provided for @articoloStandardCassettaPsFormDialogTypeLabel.
  ///
  /// In it, this message translates to:
  /// **'Tipologia*'**
  String get articoloStandardCassettaPsFormDialogTypeLabel;

  /// No description provided for @articoloStandardCassettaPsFormDialogProductNameLabel.
  ///
  /// In it, this message translates to:
  /// **'Nome prodotto*'**
  String get articoloStandardCassettaPsFormDialogProductNameLabel;

  /// No description provided for @articoloStandardCassettaPsFormDialogQuantityLabel.
  ///
  /// In it, this message translates to:
  /// **'Quantità'**
  String get articoloStandardCassettaPsFormDialogQuantityLabel;

  /// No description provided for @documentoTileDeleteConfirmTitle.
  ///
  /// In it, this message translates to:
  /// **'Eliminare la scadenza?'**
  String get documentoTileDeleteConfirmTitle;

  /// No description provided for @documentoTileDeleteConfirmMessage.
  ///
  /// In it, this message translates to:
  /// **'Eliminare {documento}? L\'operazione non è reversibile.'**
  String documentoTileDeleteConfirmMessage(String documento);

  /// No description provided for @documentoTileDefaultDocumentName.
  ///
  /// In it, this message translates to:
  /// **'questo documento'**
  String get documentoTileDefaultDocumentName;

  /// No description provided for @documentoTileSharedSuffix.
  ///
  /// In it, this message translates to:
  /// **' (condiviso)'**
  String get documentoTileSharedSuffix;

  /// No description provided for @documentoTileLabelScadenza.
  ///
  /// In it, this message translates to:
  /// **'Scadenza'**
  String get documentoTileLabelScadenza;

  /// No description provided for @documentoTileNotRequired.
  ///
  /// In it, this message translates to:
  /// **'non richiesta'**
  String get documentoTileNotRequired;

  /// No description provided for @documentoTileLabelNota.
  ///
  /// In it, this message translates to:
  /// **'Nota'**
  String get documentoTileLabelNota;

  /// No description provided for @documentoTileEditDeadline.
  ///
  /// In it, this message translates to:
  /// **'Modifica scadenza'**
  String get documentoTileEditDeadline;

  /// No description provided for @documentoTileDeleteDeadline.
  ///
  /// In it, this message translates to:
  /// **'Elimina scadenza'**
  String get documentoTileDeleteDeadline;

  /// No description provided for @notaMacchinarioDialogTitle.
  ///
  /// In it, this message translates to:
  /// **'Nota — {modello} — {tipo}'**
  String notaMacchinarioDialogTitle(String modello, String tipo);

  /// No description provided for @notaDpiAssegnatoDialogTitle.
  ///
  /// In it, this message translates to:
  /// **'Nota — {titolo}'**
  String notaDpiAssegnatoDialogTitle(String titolo);

  /// No description provided for @notaScadenzaBennaDialogTitle.
  ///
  /// In it, this message translates to:
  /// **'Nota — Benna {idInterno}'**
  String notaScadenzaBennaDialogTitle(String idInterno);

  /// No description provided for @macchinariScreenTitle.
  ///
  /// In it, this message translates to:
  /// **'Macchinari'**
  String get macchinariScreenTitle;

  /// No description provided for @macchinariScreenLocationCantiere.
  ///
  /// In it, this message translates to:
  /// **'In cantiere {cantiere}'**
  String macchinariScreenLocationCantiere(String cantiere);

  /// No description provided for @macchinariScreenLocationAutomezzo.
  ///
  /// In it, this message translates to:
  /// **'In {veicolo}'**
  String macchinariScreenLocationAutomezzo(String veicolo);

  /// No description provided for @macchinariScreenLocationMagazzino.
  ///
  /// In it, this message translates to:
  /// **'In magazzino'**
  String get macchinariScreenLocationMagazzino;

  /// No description provided for @macchinariScreenLocationUnspecified.
  ///
  /// In it, this message translates to:
  /// **'Non specificata'**
  String get macchinariScreenLocationUnspecified;

  /// No description provided for @macchinariScreenFieldModello.
  ///
  /// In it, this message translates to:
  /// **'Modello'**
  String get macchinariScreenFieldModello;

  /// No description provided for @macchinariScreenFieldTipologia.
  ///
  /// In it, this message translates to:
  /// **'Tipologia'**
  String get macchinariScreenFieldTipologia;

  /// No description provided for @macchinariScreenFieldMatricola.
  ///
  /// In it, this message translates to:
  /// **'Nr. Matricola'**
  String get macchinariScreenFieldMatricola;

  /// No description provided for @macchinariScreenFieldFabbrica.
  ///
  /// In it, this message translates to:
  /// **'Nr. Fabbrica'**
  String get macchinariScreenFieldFabbrica;

  /// No description provided for @macchinariScreenFieldAnno.
  ///
  /// In it, this message translates to:
  /// **'Anno'**
  String get macchinariScreenFieldAnno;

  /// No description provided for @macchinariScreenFieldAnnoAcquisto.
  ///
  /// In it, this message translates to:
  /// **'Anno di acquisto'**
  String get macchinariScreenFieldAnnoAcquisto;

  /// No description provided for @macchinariScreenFieldProprieta.
  ///
  /// In it, this message translates to:
  /// **'Proprietà'**
  String get macchinariScreenFieldProprieta;

  /// No description provided for @macchinariScreenFieldUbicazione.
  ///
  /// In it, this message translates to:
  /// **'Ubicazione'**
  String get macchinariScreenFieldUbicazione;

  /// No description provided for @macchinariScreenFieldCivaInail.
  ///
  /// In it, this message translates to:
  /// **'CIVA/INAIL'**
  String get macchinariScreenFieldCivaInail;

  /// No description provided for @macchinariScreenFieldPresenteCivaInail.
  ///
  /// In it, this message translates to:
  /// **'Presente in CIVA/INAIL'**
  String get macchinariScreenFieldPresenteCivaInail;

  /// No description provided for @macchinariScreenFieldScadAssicurazione.
  ///
  /// In it, this message translates to:
  /// **'Scad. assicurazione'**
  String get macchinariScreenFieldScadAssicurazione;

  /// No description provided for @macchinariScreenFieldScadManutenzione.
  ///
  /// In it, this message translates to:
  /// **'Scad. manutenzione'**
  String get macchinariScreenFieldScadManutenzione;

  /// No description provided for @macchinariScreenFieldScadFuniCatene.
  ///
  /// In it, this message translates to:
  /// **'Scad. funi/catene'**
  String get macchinariScreenFieldScadFuniCatene;

  /// No description provided for @macchinariScreenFieldVerificaAnnuale.
  ///
  /// In it, this message translates to:
  /// **'Verifica annuale'**
  String get macchinariScreenFieldVerificaAnnuale;

  /// No description provided for @macchinariScreenFieldVerificaVentennale.
  ///
  /// In it, this message translates to:
  /// **'Verifica ventennale'**
  String get macchinariScreenFieldVerificaVentennale;

  /// No description provided for @macchinariScreenFieldNotaScadenza.
  ///
  /// In it, this message translates to:
  /// **'Nota scadenza'**
  String get macchinariScreenFieldNotaScadenza;

  /// No description provided for @macchinariScreenFieldLeasingCompany.
  ///
  /// In it, this message translates to:
  /// **'Compagnia di Leasing'**
  String get macchinariScreenFieldLeasingCompany;

  /// No description provided for @macchinariScreenFieldLeasingExpiry.
  ///
  /// In it, this message translates to:
  /// **'Scadenza Leasing'**
  String get macchinariScreenFieldLeasingExpiry;

  /// No description provided for @macchinariScreenFieldRentalCompany.
  ///
  /// In it, this message translates to:
  /// **'Azienda di Noleggio'**
  String get macchinariScreenFieldRentalCompany;

  /// No description provided for @macchinariScreenFieldEmail.
  ///
  /// In it, this message translates to:
  /// **'Email'**
  String get macchinariScreenFieldEmail;

  /// No description provided for @macchinariScreenFieldInsuranceCompany.
  ///
  /// In it, this message translates to:
  /// **'Compagnia assicurativa'**
  String get macchinariScreenFieldInsuranceCompany;

  /// No description provided for @macchinariScreenFieldInsuranceExpiry.
  ///
  /// In it, this message translates to:
  /// **'Scadenza assicurazione'**
  String get macchinariScreenFieldInsuranceExpiry;

  /// No description provided for @macchinariScreenFieldInterventionDate.
  ///
  /// In it, this message translates to:
  /// **'Data intervento'**
  String get macchinariScreenFieldInterventionDate;

  /// No description provided for @macchinariScreenFieldExpiry.
  ///
  /// In it, this message translates to:
  /// **'Scadenza'**
  String get macchinariScreenFieldExpiry;

  /// No description provided for @macchinariScreenFieldLastControlDate.
  ///
  /// In it, this message translates to:
  /// **'Data ultimo controllo'**
  String get macchinariScreenFieldLastControlDate;

  /// No description provided for @macchinariScreenFieldVerificationDate.
  ///
  /// In it, this message translates to:
  /// **'Data verifica'**
  String get macchinariScreenFieldVerificationDate;

  /// No description provided for @macchinariScreenPrintSubtitleCount.
  ///
  /// In it, this message translates to:
  /// **'{count} macchinari'**
  String macchinariScreenPrintSubtitleCount(int count);

  /// No description provided for @macchinariScreenPrintSubtitleFilter.
  ///
  /// In it, this message translates to:
  /// **'filtro di ricerca: \"{filter}\"'**
  String macchinariScreenPrintSubtitleFilter(String filter);

  /// No description provided for @macchinariScreenPrintError.
  ///
  /// In it, this message translates to:
  /// **'Impossibile generare la stampa: {details}'**
  String macchinariScreenPrintError(String details);

  /// No description provided for @macchinariScreenNewButton.
  ///
  /// In it, this message translates to:
  /// **'Nuovo macchinario'**
  String get macchinariScreenNewButton;

  /// No description provided for @macchinariScreenPrintButton.
  ///
  /// In it, this message translates to:
  /// **'Stampa'**
  String get macchinariScreenPrintButton;

  /// No description provided for @macchinariScreenUpcomingDeadlines.
  ///
  /// In it, this message translates to:
  /// **'Scadenze imminenti'**
  String get macchinariScreenUpcomingDeadlines;

  /// No description provided for @macchinariScreenHideDeadlinesTooltip.
  ///
  /// In it, this message translates to:
  /// **'Nascondi scadenze'**
  String get macchinariScreenHideDeadlinesTooltip;

  /// No description provided for @macchinariScreenShowDeadlinesTooltip.
  ///
  /// In it, this message translates to:
  /// **'Mostra scadenze'**
  String get macchinariScreenShowDeadlinesTooltip;

  /// No description provided for @macchinariScreenCollapseAllTooltip.
  ///
  /// In it, this message translates to:
  /// **'Chiudi tutti'**
  String get macchinariScreenCollapseAllTooltip;

  /// No description provided for @macchinariScreenExpandAllTooltip.
  ///
  /// In it, this message translates to:
  /// **'Espandi tutti'**
  String get macchinariScreenExpandAllTooltip;

  /// No description provided for @macchinariScreenSearchHint.
  ///
  /// In it, this message translates to:
  /// **'Cerca per nome'**
  String get macchinariScreenSearchHint;

  /// No description provided for @macchinariScreenEmptyLoaded.
  ///
  /// In it, this message translates to:
  /// **'Nessun macchinario caricato.'**
  String get macchinariScreenEmptyLoaded;

  /// No description provided for @macchinariScreenEmptySearch.
  ///
  /// In it, this message translates to:
  /// **'Nessun macchinario trovato per \"{query}\".'**
  String macchinariScreenEmptySearch(String query);

  /// No description provided for @macchinariScreenEditNoteTooltip.
  ///
  /// In it, this message translates to:
  /// **'Modifica nota'**
  String get macchinariScreenEditNoteTooltip;

  /// No description provided for @macchinariScreenEditTooltip.
  ///
  /// In it, this message translates to:
  /// **'Modifica macchinario'**
  String get macchinariScreenEditTooltip;

  /// No description provided for @macchinariScreenDeleteTooltip.
  ///
  /// In it, this message translates to:
  /// **'Elimina macchinario'**
  String get macchinariScreenDeleteTooltip;

  /// No description provided for @macchinariScreenDeleteConfirmTitle.
  ///
  /// In it, this message translates to:
  /// **'Eliminare macchinario?'**
  String get macchinariScreenDeleteConfirmTitle;

  /// No description provided for @macchinariScreenDeleteConfirmMessage.
  ///
  /// In it, this message translates to:
  /// **'Eliminare \"{modello}\"? L\'operazione non è reversibile.'**
  String macchinariScreenDeleteConfirmMessage(String modello);

  /// No description provided for @macchinariScreenHideInfoTooltip.
  ///
  /// In it, this message translates to:
  /// **'Nascondi info'**
  String get macchinariScreenHideInfoTooltip;

  /// No description provided for @macchinariScreenShowInfoTooltip.
  ///
  /// In it, this message translates to:
  /// **'Mostra info'**
  String get macchinariScreenShowInfoTooltip;

  /// No description provided for @macchinariScreenSectionGeneralData.
  ///
  /// In it, this message translates to:
  /// **'Dati generali'**
  String get macchinariScreenSectionGeneralData;

  /// No description provided for @macchinariScreenSectionInsurance.
  ///
  /// In it, this message translates to:
  /// **'Assicurazione'**
  String get macchinariScreenSectionInsurance;

  /// No description provided for @macchinariScreenSectionInternalMaintenance.
  ///
  /// In it, this message translates to:
  /// **'Manutenzione Interna'**
  String get macchinariScreenSectionInternalMaintenance;

  /// No description provided for @macchinariScreenSectionRopesChainsControl.
  ///
  /// In it, this message translates to:
  /// **'Controllo funi/catene'**
  String get macchinariScreenSectionRopesChainsControl;

  /// No description provided for @automezziScreenTitle.
  ///
  /// In it, this message translates to:
  /// **'Automezzi'**
  String get automezziScreenTitle;

  /// No description provided for @automezziScreenFieldNome.
  ///
  /// In it, this message translates to:
  /// **'Nome'**
  String get automezziScreenFieldNome;

  /// No description provided for @automezziScreenFieldTarga.
  ///
  /// In it, this message translates to:
  /// **'Targa'**
  String get automezziScreenFieldTarga;

  /// No description provided for @automezziScreenFieldCategoria.
  ///
  /// In it, this message translates to:
  /// **'Categoria'**
  String get automezziScreenFieldCategoria;

  /// No description provided for @automezziScreenFieldTelepass.
  ///
  /// In it, this message translates to:
  /// **'Nr. Telepass'**
  String get automezziScreenFieldTelepass;

  /// No description provided for @automezziScreenFieldProprieta.
  ///
  /// In it, this message translates to:
  /// **'Proprietà'**
  String get automezziScreenFieldProprieta;

  /// No description provided for @automezziScreenFieldCompAssicurazione.
  ///
  /// In it, this message translates to:
  /// **'Comp. assicurazione'**
  String get automezziScreenFieldCompAssicurazione;

  /// No description provided for @automezziScreenFieldScadAssicurazione.
  ///
  /// In it, this message translates to:
  /// **'Scad. assicurazione'**
  String get automezziScreenFieldScadAssicurazione;

  /// No description provided for @automezziScreenFieldScadBollo.
  ///
  /// In it, this message translates to:
  /// **'Scad. bollo'**
  String get automezziScreenFieldScadBollo;

  /// No description provided for @automezziScreenFieldScadRevisione.
  ///
  /// In it, this message translates to:
  /// **'Scad. revisione'**
  String get automezziScreenFieldScadRevisione;

  /// No description provided for @automezziScreenFieldScadTachigrafo.
  ///
  /// In it, this message translates to:
  /// **'Scad. controllo tachigrafo'**
  String get automezziScreenFieldScadTachigrafo;

  /// No description provided for @automezziScreenFieldVeicolo.
  ///
  /// In it, this message translates to:
  /// **'Veicolo'**
  String get automezziScreenFieldVeicolo;

  /// No description provided for @automezziScreenFieldNotaScadenza.
  ///
  /// In it, this message translates to:
  /// **'Nota scadenza'**
  String get automezziScreenFieldNotaScadenza;

  /// No description provided for @automezziScreenFieldCategoriaEuro.
  ///
  /// In it, this message translates to:
  /// **'Categoria EURO'**
  String get automezziScreenFieldCategoriaEuro;

  /// No description provided for @automezziScreenFieldScadenzaProprieta.
  ///
  /// In it, this message translates to:
  /// **'Scadenza {proprieta}'**
  String automezziScreenFieldScadenzaProprieta(String proprieta);

  /// No description provided for @automezziScreenPrintSubtitleCount.
  ///
  /// In it, this message translates to:
  /// **'{count} automezzi'**
  String automezziScreenPrintSubtitleCount(int count);

  /// No description provided for @automezziScreenPrintSubtitleFilter.
  ///
  /// In it, this message translates to:
  /// **'filtro di ricerca: \"{filter}\"'**
  String automezziScreenPrintSubtitleFilter(String filter);

  /// No description provided for @automezziScreenPrintError.
  ///
  /// In it, this message translates to:
  /// **'Impossibile generare la stampa: {details}'**
  String automezziScreenPrintError(String details);

  /// No description provided for @automezziScreenNewButton.
  ///
  /// In it, this message translates to:
  /// **'Nuovo automezzo'**
  String get automezziScreenNewButton;

  /// No description provided for @automezziScreenPrintButton.
  ///
  /// In it, this message translates to:
  /// **'Stampa'**
  String get automezziScreenPrintButton;

  /// No description provided for @automezziScreenUpcomingDeadlines.
  ///
  /// In it, this message translates to:
  /// **'Scadenze imminenti'**
  String get automezziScreenUpcomingDeadlines;

  /// No description provided for @automezziScreenHideDeadlinesTooltip.
  ///
  /// In it, this message translates to:
  /// **'Nascondi scadenze'**
  String get automezziScreenHideDeadlinesTooltip;

  /// No description provided for @automezziScreenShowDeadlinesTooltip.
  ///
  /// In it, this message translates to:
  /// **'Mostra scadenze'**
  String get automezziScreenShowDeadlinesTooltip;

  /// No description provided for @automezziScreenCollapseAllTooltip.
  ///
  /// In it, this message translates to:
  /// **'Chiudi tutti'**
  String get automezziScreenCollapseAllTooltip;

  /// No description provided for @automezziScreenExpandAllTooltip.
  ///
  /// In it, this message translates to:
  /// **'Espandi tutti'**
  String get automezziScreenExpandAllTooltip;

  /// No description provided for @automezziScreenSearchHint.
  ///
  /// In it, this message translates to:
  /// **'Cerca per nome o targa'**
  String get automezziScreenSearchHint;

  /// No description provided for @automezziScreenEmptyLoaded.
  ///
  /// In it, this message translates to:
  /// **'Nessun automezzo caricato.'**
  String get automezziScreenEmptyLoaded;

  /// No description provided for @automezziScreenEmptySearch.
  ///
  /// In it, this message translates to:
  /// **'Nessun automezzo trovato per \"{query}\".'**
  String automezziScreenEmptySearch(String query);

  /// No description provided for @automezziScreenEditNoteTooltip.
  ///
  /// In it, this message translates to:
  /// **'Modifica nota'**
  String get automezziScreenEditNoteTooltip;

  /// No description provided for @automezziScreenEditTooltip.
  ///
  /// In it, this message translates to:
  /// **'Modifica automezzo'**
  String get automezziScreenEditTooltip;

  /// No description provided for @automezziScreenDeleteTooltip.
  ///
  /// In it, this message translates to:
  /// **'Elimina automezzo'**
  String get automezziScreenDeleteTooltip;

  /// No description provided for @automezziScreenDeleteConfirmTitle.
  ///
  /// In it, this message translates to:
  /// **'Eliminare automezzo?'**
  String get automezziScreenDeleteConfirmTitle;

  /// No description provided for @automezziScreenDeleteConfirmMessage.
  ///
  /// In it, this message translates to:
  /// **'Eliminare \"{nome}\"? L\'operazione non è reversibile.'**
  String automezziScreenDeleteConfirmMessage(String nome);

  /// No description provided for @automezziScreenHideInfoTooltip.
  ///
  /// In it, this message translates to:
  /// **'Nascondi info'**
  String get automezziScreenHideInfoTooltip;

  /// No description provided for @automezziScreenShowInfoTooltip.
  ///
  /// In it, this message translates to:
  /// **'Mostra info'**
  String get automezziScreenShowInfoTooltip;

  /// No description provided for @automezziScreenSectionGeneralData.
  ///
  /// In it, this message translates to:
  /// **'Dati generali'**
  String get automezziScreenSectionGeneralData;

  /// No description provided for @automezziScreenSectionScadenze.
  ///
  /// In it, this message translates to:
  /// **'Scadenze'**
  String get automezziScreenSectionScadenze;

  /// No description provided for @dipendenteAziendaleFormDialogNewTitle.
  ///
  /// In it, this message translates to:
  /// **'Nuovo dipendente aziendale'**
  String get dipendenteAziendaleFormDialogNewTitle;

  /// No description provided for @dipendenteAziendaleFormDialogEditTitle.
  ///
  /// In it, this message translates to:
  /// **'Modifica dipendente aziendale'**
  String get dipendenteAziendaleFormDialogEditTitle;

  /// No description provided for @dipendenteAziendaleFormDialogNomeLabel.
  ///
  /// In it, this message translates to:
  /// **'Nome*'**
  String get dipendenteAziendaleFormDialogNomeLabel;

  /// No description provided for @dipendenteAziendaleFormDialogCognomeLabel.
  ///
  /// In it, this message translates to:
  /// **'Cognome*'**
  String get dipendenteAziendaleFormDialogCognomeLabel;

  /// No description provided for @dipendenteAziendaleFormDialogMansioneLabel.
  ///
  /// In it, this message translates to:
  /// **'Mansione'**
  String get dipendenteAziendaleFormDialogMansioneLabel;

  /// No description provided for @dipendenteAziendaleFormDialogMansioneNonSpecificata.
  ///
  /// In it, this message translates to:
  /// **'Non specificata'**
  String get dipendenteAziendaleFormDialogMansioneNonSpecificata;

  /// No description provided for @dipendenteAziendaleFormDialogScadenzaRlst.
  ///
  /// In it, this message translates to:
  /// **'Scadenza RLST'**
  String get dipendenteAziendaleFormDialogScadenzaRlst;

  /// No description provided for @dipendenteAziendaleFormDialogScadenzaRspp.
  ///
  /// In it, this message translates to:
  /// **'Scadenza RSPP'**
  String get dipendenteAziendaleFormDialogScadenzaRspp;

  /// No description provided for @dipendenteAziendaleFormDialogCodiceFiscaleLabel.
  ///
  /// In it, this message translates to:
  /// **'Codice Fiscale'**
  String get dipendenteAziendaleFormDialogCodiceFiscaleLabel;

  /// No description provided for @dipendenteAziendaleFormDialogDataNascita.
  ///
  /// In it, this message translates to:
  /// **'Data di Nascita'**
  String get dipendenteAziendaleFormDialogDataNascita;

  /// No description provided for @dipendenteAziendaleFormDialogLuogoNascita.
  ///
  /// In it, this message translates to:
  /// **'Luogo di Nascita'**
  String get dipendenteAziendaleFormDialogLuogoNascita;

  /// No description provided for @dipendenteAziendaleFormDialogEtaLabel.
  ///
  /// In it, this message translates to:
  /// **'Età'**
  String get dipendenteAziendaleFormDialogEtaLabel;

  /// No description provided for @dipendenteAziendaleFormDialogEtaHelper.
  ///
  /// In it, this message translates to:
  /// **'Calcolata dalla data di nascita'**
  String get dipendenteAziendaleFormDialogEtaHelper;

  /// No description provided for @dipendenteAziendaleFormDialogSectionContratto.
  ///
  /// In it, this message translates to:
  /// **'Contratto'**
  String get dipendenteAziendaleFormDialogSectionContratto;

  /// No description provided for @dipendenteAziendaleFormDialogDataAssunzione.
  ///
  /// In it, this message translates to:
  /// **'Data di Assunzione'**
  String get dipendenteAziendaleFormDialogDataAssunzione;

  /// No description provided for @dipendenteAziendaleFormDialogScadenzaContratto.
  ///
  /// In it, this message translates to:
  /// **'Scadenza Contratto'**
  String get dipendenteAziendaleFormDialogScadenzaContratto;

  /// No description provided for @dipendenteAziendaleFormDialogRemoveScadenzaContrattoTooltip.
  ///
  /// In it, this message translates to:
  /// **'Rimuovi scadenza contratto'**
  String get dipendenteAziendaleFormDialogRemoveScadenzaContrattoTooltip;

  /// No description provided for @dipendenteAziendaleFormDialogAddScadenzaContratto.
  ///
  /// In it, this message translates to:
  /// **'Aggiungi scadenza del contratto'**
  String get dipendenteAziendaleFormDialogAddScadenzaContratto;

  /// No description provided for @dipendenteAziendaleFormDialogSectionPersonali.
  ///
  /// In it, this message translates to:
  /// **'Personali'**
  String get dipendenteAziendaleFormDialogSectionPersonali;

  /// No description provided for @dipendenteAziendaleFormDialogScadenzaVisitaMedica.
  ///
  /// In it, this message translates to:
  /// **'Scadenza Visita Medica'**
  String get dipendenteAziendaleFormDialogScadenzaVisitaMedica;

  /// No description provided for @dipendenteAziendaleFormDialogScadenzaPatente.
  ///
  /// In it, this message translates to:
  /// **'Scadenza Patente'**
  String get dipendenteAziendaleFormDialogScadenzaPatente;

  /// No description provided for @dipendenteAziendaleFormDialogScadenzaCartaTachigraficaAzienda.
  ///
  /// In it, this message translates to:
  /// **'Scadenza Carta Tachigrafica + Azienda'**
  String get dipendenteAziendaleFormDialogScadenzaCartaTachigraficaAzienda;

  /// No description provided for @dipendenteAziendaleFormDialogScadenzaCartaTachigrafica.
  ///
  /// In it, this message translates to:
  /// **'Scadenza Carta Tachigrafica'**
  String get dipendenteAziendaleFormDialogScadenzaCartaTachigrafica;

  /// No description provided for @dipendenteAziendaleFormDialogScadenzaCartaIdentita.
  ///
  /// In it, this message translates to:
  /// **'Scadenza Carta d\'identità'**
  String get dipendenteAziendaleFormDialogScadenzaCartaIdentita;

  /// No description provided for @dipendenteAziendaleFormDialogScadenzaFirmaDigitale.
  ///
  /// In it, this message translates to:
  /// **'Scadenza Firma Digitale'**
  String get dipendenteAziendaleFormDialogScadenzaFirmaDigitale;

  /// No description provided for @dipendenteAziendaleFormDialogScadenzaCodiceFiscale.
  ///
  /// In it, this message translates to:
  /// **'Scadenza Codice Fiscale'**
  String get dipendenteAziendaleFormDialogScadenzaCodiceFiscale;

  /// No description provided for @dipendenteAziendaleFormDialogScadenzaPermessoSoggiorno.
  ///
  /// In it, this message translates to:
  /// **'Scadenza Permesso di Soggiorno'**
  String get dipendenteAziendaleFormDialogScadenzaPermessoSoggiorno;

  /// No description provided for @dipendenteAziendaleFormDialogRemovePermessoSoggiornoTooltip.
  ///
  /// In it, this message translates to:
  /// **'Rimuovi permesso di soggiorno'**
  String get dipendenteAziendaleFormDialogRemovePermessoSoggiornoTooltip;

  /// No description provided for @dipendenteAziendaleFormDialogAddPermessoSoggiorno.
  ///
  /// In it, this message translates to:
  /// **'Aggiungi permesso di soggiorno'**
  String get dipendenteAziendaleFormDialogAddPermessoSoggiorno;

  /// No description provided for @dipendenteAziendaleFormDialogScadenzaAntitetanica.
  ///
  /// In it, this message translates to:
  /// **'Scadenza Antitetanica'**
  String get dipendenteAziendaleFormDialogScadenzaAntitetanica;

  /// No description provided for @dipendenteAziendaleFormDialogRemoveAntitetanicaTooltip.
  ///
  /// In it, this message translates to:
  /// **'Rimuovi antitetanica'**
  String get dipendenteAziendaleFormDialogRemoveAntitetanicaTooltip;

  /// No description provided for @dipendenteAziendaleFormDialogAddAntitetanica.
  ///
  /// In it, this message translates to:
  /// **'Aggiungi antitetanica'**
  String get dipendenteAziendaleFormDialogAddAntitetanica;

  /// No description provided for @dipendenteAziendaleFormDialogSectionCorsi.
  ///
  /// In it, this message translates to:
  /// **'Corsi'**
  String get dipendenteAziendaleFormDialogSectionCorsi;

  /// No description provided for @dipendenteAziendaleFormDialogScadenzaFormazioneGenerale.
  ///
  /// In it, this message translates to:
  /// **'Scadenza corso di formazione generale'**
  String get dipendenteAziendaleFormDialogScadenzaFormazioneGenerale;

  /// No description provided for @dipendenteAziendaleFormDialogNoteAggiuntive.
  ///
  /// In it, this message translates to:
  /// **'Note aggiuntive'**
  String get dipendenteAziendaleFormDialogNoteAggiuntive;

  /// No description provided for @dipendenteAziendaleFormDialogRemoveCorsoTooltip.
  ///
  /// In it, this message translates to:
  /// **'Rimuovi corso'**
  String get dipendenteAziendaleFormDialogRemoveCorsoTooltip;

  /// No description provided for @dipendenteAziendaleFormDialogAddCorso.
  ///
  /// In it, this message translates to:
  /// **'Aggiungi corso'**
  String get dipendenteAziendaleFormDialogAddCorso;

  /// No description provided for @dipendenteAziendaleFormDialogAllCoursesAdded.
  ///
  /// In it, this message translates to:
  /// **'Hai già aggiunto tutti i corsi disponibili.'**
  String get dipendenteAziendaleFormDialogAllCoursesAdded;

  /// No description provided for @dipendenteAziendaleFormDialogSelectCoursesTitle.
  ///
  /// In it, this message translates to:
  /// **'Seleziona i corsi da aggiungere'**
  String get dipendenteAziendaleFormDialogSelectCoursesTitle;

  /// No description provided for @dipendenteAziendaleFormDialogAddCoursesCount.
  ///
  /// In it, this message translates to:
  /// **'Aggiungi ({count})'**
  String dipendenteAziendaleFormDialogAddCoursesCount(int count);

  /// No description provided for @dipendenteAziendaleFormDialogCorsoPrimoSoccorsoNome.
  ///
  /// In it, this message translates to:
  /// **'Corso di Primo Soccorso'**
  String get dipendenteAziendaleFormDialogCorsoPrimoSoccorsoNome;

  /// No description provided for @dipendenteAziendaleFormDialogCorsoPrimoSoccorsoEtichetta.
  ///
  /// In it, this message translates to:
  /// **'Scadenza Corso Primo Soccorso'**
  String get dipendenteAziendaleFormDialogCorsoPrimoSoccorsoEtichetta;

  /// No description provided for @dipendenteAziendaleFormDialogCorsoAntincendioNome.
  ///
  /// In it, this message translates to:
  /// **'Corso Antincendio'**
  String get dipendenteAziendaleFormDialogCorsoAntincendioNome;

  /// No description provided for @dipendenteAziendaleFormDialogCorsoAntincendioEtichetta.
  ///
  /// In it, this message translates to:
  /// **'Scadenza Corso Antincendio'**
  String get dipendenteAziendaleFormDialogCorsoAntincendioEtichetta;

  /// No description provided for @dipendenteAziendaleFormDialogCorsoPrepostoNome.
  ///
  /// In it, this message translates to:
  /// **'Corso Preposto'**
  String get dipendenteAziendaleFormDialogCorsoPrepostoNome;

  /// No description provided for @dipendenteAziendaleFormDialogCorsoPrepostoEtichetta.
  ///
  /// In it, this message translates to:
  /// **'Scadenza Preposto'**
  String get dipendenteAziendaleFormDialogCorsoPrepostoEtichetta;

  /// No description provided for @dipendenteAziendaleFormDialogCorsoPonteggiNome.
  ///
  /// In it, this message translates to:
  /// **'Montaggio/Smontaggio ponteggi'**
  String get dipendenteAziendaleFormDialogCorsoPonteggiNome;

  /// No description provided for @dipendenteAziendaleFormDialogCorsoPonteggiEtichetta.
  ///
  /// In it, this message translates to:
  /// **'Scadenza Ponteggi'**
  String get dipendenteAziendaleFormDialogCorsoPonteggiEtichetta;

  /// No description provided for @dipendenteAziendaleFormDialogCorsoLavoriQuotaNome.
  ///
  /// In it, this message translates to:
  /// **'Lavori in Quota'**
  String get dipendenteAziendaleFormDialogCorsoLavoriQuotaNome;

  /// No description provided for @dipendenteAziendaleFormDialogCorsoLavoriQuotaEtichetta.
  ///
  /// In it, this message translates to:
  /// **'Scadenza Lavori in Quota'**
  String get dipendenteAziendaleFormDialogCorsoLavoriQuotaEtichetta;

  /// No description provided for @dipendenteAziendaleFormDialogCorsoEscavatoriNome.
  ///
  /// In it, this message translates to:
  /// **'Conduzione Escavatori'**
  String get dipendenteAziendaleFormDialogCorsoEscavatoriNome;

  /// No description provided for @dipendenteAziendaleFormDialogCorsoEscavatoriEtichetta.
  ///
  /// In it, this message translates to:
  /// **'Scadenza Conduzione Escavatori'**
  String get dipendenteAziendaleFormDialogCorsoEscavatoriEtichetta;

  /// No description provided for @dipendenteAziendaleFormDialogCorsoGruAutocarroNome.
  ///
  /// In it, this message translates to:
  /// **'Gru Autocarro'**
  String get dipendenteAziendaleFormDialogCorsoGruAutocarroNome;

  /// No description provided for @dipendenteAziendaleFormDialogCorsoGruAutocarroEtichetta.
  ///
  /// In it, this message translates to:
  /// **'Scadenza Gru Autocarro'**
  String get dipendenteAziendaleFormDialogCorsoGruAutocarroEtichetta;

  /// No description provided for @dipendenteAziendaleFormDialogCorsoGruTorreNome.
  ///
  /// In it, this message translates to:
  /// **'Gru a Torre'**
  String get dipendenteAziendaleFormDialogCorsoGruTorreNome;

  /// No description provided for @dipendenteAziendaleFormDialogCorsoGruTorreEtichetta.
  ///
  /// In it, this message translates to:
  /// **'Scadenza Gru a Torre'**
  String get dipendenteAziendaleFormDialogCorsoGruTorreEtichetta;

  /// No description provided for @dipendenteAziendaleFormDialogCorsoPiattaformeNome.
  ///
  /// In it, this message translates to:
  /// **'Piattaforme Elevatrici'**
  String get dipendenteAziendaleFormDialogCorsoPiattaformeNome;

  /// No description provided for @dipendenteAziendaleFormDialogCorsoPiattaformeEtichetta.
  ///
  /// In it, this message translates to:
  /// **'Scadenza Piattaforme Elevatrici'**
  String get dipendenteAziendaleFormDialogCorsoPiattaformeEtichetta;

  /// No description provided for @dipendenteAziendaleFormDialogCorsoCarrelloElevatoreNome.
  ///
  /// In it, this message translates to:
  /// **'Carrello Elevatore Semovente'**
  String get dipendenteAziendaleFormDialogCorsoCarrelloElevatoreNome;

  /// No description provided for @dipendenteAziendaleFormDialogCorsoCarrelloElevatoreEtichetta.
  ///
  /// In it, this message translates to:
  /// **'Scadenza Carrello Elevatore'**
  String get dipendenteAziendaleFormDialogCorsoCarrelloElevatoreEtichetta;

  /// No description provided for @dipendenteAziendaleFormDialogCorsoDisocianatiNome.
  ///
  /// In it, this message translates to:
  /// **'Corso Diisocianati'**
  String get dipendenteAziendaleFormDialogCorsoDisocianatiNome;

  /// No description provided for @dipendenteAziendaleFormDialogCorsoDisocianatiEtichetta.
  ///
  /// In it, this message translates to:
  /// **'Scadenza Corso Diisocianati'**
  String get dipendenteAziendaleFormDialogCorsoDisocianatiEtichetta;

  /// No description provided for @dipendenteAziendaleFormDialogCorsoScaffalatureNome.
  ///
  /// In it, this message translates to:
  /// **'Corso Scaffalature'**
  String get dipendenteAziendaleFormDialogCorsoScaffalatureNome;

  /// No description provided for @dipendenteAziendaleFormDialogCorsoScaffalatureEtichetta.
  ///
  /// In it, this message translates to:
  /// **'Scadenza Scaffalature'**
  String get dipendenteAziendaleFormDialogCorsoScaffalatureEtichetta;

  /// No description provided for @dipendenteAziendaleFormDialogCorsoFormazione231Nome.
  ///
  /// In it, this message translates to:
  /// **'Corso di formazione Modello 231'**
  String get dipendenteAziendaleFormDialogCorsoFormazione231Nome;

  /// No description provided for @dipendenteAziendaleFormDialogCorsoFormazione231Etichetta.
  ///
  /// In it, this message translates to:
  /// **'Data Corso di formazione Modello 231'**
  String get dipendenteAziendaleFormDialogCorsoFormazione231Etichetta;

  /// No description provided for @dipendenteAziendaleFormDialogCorsoAmbientaleNome.
  ///
  /// In it, this message translates to:
  /// **'Corso di formazione di Sistema Gestione Ambientale'**
  String get dipendenteAziendaleFormDialogCorsoAmbientaleNome;

  /// No description provided for @dipendenteAziendaleFormDialogCorsoAmbientaleEtichetta.
  ///
  /// In it, this message translates to:
  /// **'Data Formazione Ambientale'**
  String get dipendenteAziendaleFormDialogCorsoAmbientaleEtichetta;

  /// No description provided for @dipendenteAziendaleFormDialogCorsoRentriNome.
  ///
  /// In it, this message translates to:
  /// **'Corso di formazione Rentri'**
  String get dipendenteAziendaleFormDialogCorsoRentriNome;

  /// No description provided for @dipendenteAziendaleFormDialogCorsoRentriEtichetta.
  ///
  /// In it, this message translates to:
  /// **'Data Corso di formazione Rentri'**
  String get dipendenteAziendaleFormDialogCorsoRentriEtichetta;

  /// No description provided for @dipendenteAziendaleFormDialogCorsoCronotachigraficoNome.
  ///
  /// In it, this message translates to:
  /// **'Corso Cronotachigrafico'**
  String get dipendenteAziendaleFormDialogCorsoCronotachigraficoNome;

  /// No description provided for @dipendenteAziendaleFormDialogCorsoCronotachigraficoEtichetta.
  ///
  /// In it, this message translates to:
  /// **'Scadenza Cronotachigrafico'**
  String get dipendenteAziendaleFormDialogCorsoCronotachigraficoEtichetta;

  /// No description provided for @estintoreFormDialogNewTitle.
  ///
  /// In it, this message translates to:
  /// **'Nuovo estintore'**
  String get estintoreFormDialogNewTitle;

  /// No description provided for @estintoreFormDialogEditTitle.
  ///
  /// In it, this message translates to:
  /// **'Modifica estintore'**
  String get estintoreFormDialogEditTitle;

  /// No description provided for @estintoreFormDialogMatricolaLabel.
  ///
  /// In it, this message translates to:
  /// **'Numero di Matricola*'**
  String get estintoreFormDialogMatricolaLabel;

  /// No description provided for @estintoreFormDialogTipoAgenteLabel.
  ///
  /// In it, this message translates to:
  /// **'Tipo di agente'**
  String get estintoreFormDialogTipoAgenteLabel;

  /// No description provided for @estintoreFormDialogTipoAgenteNonSpecificato.
  ///
  /// In it, this message translates to:
  /// **'Non specificato'**
  String get estintoreFormDialogTipoAgenteNonSpecificato;

  /// No description provided for @estintoreFormDialogCapacitaLabel.
  ///
  /// In it, this message translates to:
  /// **'Capacità'**
  String get estintoreFormDialogCapacitaLabel;

  /// No description provided for @estintoreFormDialogDataProduzione.
  ///
  /// In it, this message translates to:
  /// **'Data di Produzione'**
  String get estintoreFormDialogDataProduzione;

  /// No description provided for @estintoreFormDialogDataMessaInServizio.
  ///
  /// In it, this message translates to:
  /// **'Data di messa in servizio'**
  String get estintoreFormDialogDataMessaInServizio;

  /// No description provided for @estintoreFormDialogSectionUbicazione.
  ///
  /// In it, this message translates to:
  /// **'Ubicazione'**
  String get estintoreFormDialogSectionUbicazione;

  /// No description provided for @estintoreFormDialogTipoUbicazioneLabel.
  ///
  /// In it, this message translates to:
  /// **'Tipo ubicazione'**
  String get estintoreFormDialogTipoUbicazioneLabel;

  /// No description provided for @estintoreFormDialogUbicazioneNonSpecificata.
  ///
  /// In it, this message translates to:
  /// **'Non specificata'**
  String get estintoreFormDialogUbicazioneNonSpecificata;

  /// No description provided for @estintoreFormDialogUbicazioneMagazzino.
  ///
  /// In it, this message translates to:
  /// **'Magazzino'**
  String get estintoreFormDialogUbicazioneMagazzino;

  /// No description provided for @estintoreFormDialogUbicazioneUfficio.
  ///
  /// In it, this message translates to:
  /// **'Ufficio'**
  String get estintoreFormDialogUbicazioneUfficio;

  /// No description provided for @estintoreFormDialogUbicazioneCantiere.
  ///
  /// In it, this message translates to:
  /// **'Cantiere'**
  String get estintoreFormDialogUbicazioneCantiere;

  /// No description provided for @estintoreFormDialogUbicazioneAutomezzo.
  ///
  /// In it, this message translates to:
  /// **'Automezzo'**
  String get estintoreFormDialogUbicazioneAutomezzo;

  /// No description provided for @estintoreFormDialogSelectCantiereValidator.
  ///
  /// In it, this message translates to:
  /// **'Seleziona un cantiere'**
  String get estintoreFormDialogSelectCantiereValidator;

  /// No description provided for @estintoreFormDialogSelectAutomezzoValidator.
  ///
  /// In it, this message translates to:
  /// **'Seleziona un automezzo'**
  String get estintoreFormDialogSelectAutomezzoValidator;

  /// No description provided for @estintoreFormDialogDettagliUbicazione.
  ///
  /// In it, this message translates to:
  /// **'Dettagli aggiuntivi ubicazione'**
  String get estintoreFormDialogDettagliUbicazione;

  /// No description provided for @estintoreFormDialogSectionVerificaEsterna.
  ///
  /// In it, this message translates to:
  /// **'Verifica esterna'**
  String get estintoreFormDialogSectionVerificaEsterna;

  /// No description provided for @estintoreFormDialogDataVerificaEsterna.
  ///
  /// In it, this message translates to:
  /// **'Data verifica esterna'**
  String get estintoreFormDialogDataVerificaEsterna;

  /// No description provided for @estintoreFormDialogScadenzaVerificaEsterna.
  ///
  /// In it, this message translates to:
  /// **'Scadenza verifica esterna'**
  String get estintoreFormDialogScadenzaVerificaEsterna;

  /// No description provided for @estintoreFormDialogSectionRevisione.
  ///
  /// In it, this message translates to:
  /// **'Revisione'**
  String get estintoreFormDialogSectionRevisione;

  /// No description provided for @estintoreFormDialogUltimaRevisione.
  ///
  /// In it, this message translates to:
  /// **'Ultima revisione'**
  String get estintoreFormDialogUltimaRevisione;

  /// No description provided for @estintoreFormDialogScadenzaRevisione.
  ///
  /// In it, this message translates to:
  /// **'Scadenza revisione'**
  String get estintoreFormDialogScadenzaRevisione;

  /// No description provided for @estintoreFormDialogSectionCollaudo.
  ///
  /// In it, this message translates to:
  /// **'Collaudo'**
  String get estintoreFormDialogSectionCollaudo;

  /// No description provided for @estintoreFormDialogUltimoCollaudo.
  ///
  /// In it, this message translates to:
  /// **'Ultimo collaudo'**
  String get estintoreFormDialogUltimoCollaudo;

  /// No description provided for @estintoreFormDialogScadenzaCollaudo.
  ///
  /// In it, this message translates to:
  /// **'Scadenza collaudo'**
  String get estintoreFormDialogScadenzaCollaudo;

  /// No description provided for @estintoreFormDialogNoteAggiuntive.
  ///
  /// In it, this message translates to:
  /// **'Note aggiuntive'**
  String get estintoreFormDialogNoteAggiuntive;

  /// No description provided for @rifiutoFormDialogNewTitle.
  ///
  /// In it, this message translates to:
  /// **'Nuova ditta rifiuti'**
  String get rifiutoFormDialogNewTitle;

  /// No description provided for @rifiutoFormDialogEditTitle.
  ///
  /// In it, this message translates to:
  /// **'Modifica ditta rifiuti'**
  String get rifiutoFormDialogEditTitle;

  /// No description provided for @rifiutoFormDialogNomeDittaLabel.
  ///
  /// In it, this message translates to:
  /// **'Nome ditta*'**
  String get rifiutoFormDialogNomeDittaLabel;

  /// No description provided for @rifiutoFormDialogSectionTrasportatore.
  ///
  /// In it, this message translates to:
  /// **'Trasportatore'**
  String get rifiutoFormDialogSectionTrasportatore;

  /// No description provided for @rifiutoFormDialogIsTrasportatore.
  ///
  /// In it, this message translates to:
  /// **'Trasportatore?'**
  String get rifiutoFormDialogIsTrasportatore;

  /// No description provided for @rifiutoFormDialogNrAutorizzazioneTrasportatore.
  ///
  /// In it, this message translates to:
  /// **'Numero di Autorizzazione Trasportatore'**
  String get rifiutoFormDialogNrAutorizzazioneTrasportatore;

  /// No description provided for @rifiutoFormDialogScadNonPericolosiTrasportatore.
  ///
  /// In it, this message translates to:
  /// **'Scadenza rifiuti non pericolosi trasportatore'**
  String get rifiutoFormDialogScadNonPericolosiTrasportatore;

  /// No description provided for @rifiutoFormDialogAutorizzazionePericolosi.
  ///
  /// In it, this message translates to:
  /// **'Autorizzazione a rifiuti pericolosi?'**
  String get rifiutoFormDialogAutorizzazionePericolosi;

  /// No description provided for @rifiutoFormDialogScadPericolosiTrasportatore.
  ///
  /// In it, this message translates to:
  /// **'Scadenza rifiuti pericolosi trasportatore'**
  String get rifiutoFormDialogScadPericolosiTrasportatore;

  /// No description provided for @rifiutoFormDialogNoteTrasportatore.
  ///
  /// In it, this message translates to:
  /// **'Note trasportatore'**
  String get rifiutoFormDialogNoteTrasportatore;

  /// No description provided for @rifiutoFormDialogSectionSmaltitore.
  ///
  /// In it, this message translates to:
  /// **'Smaltitore'**
  String get rifiutoFormDialogSectionSmaltitore;

  /// No description provided for @rifiutoFormDialogIsSmaltitore.
  ///
  /// In it, this message translates to:
  /// **'Smaltitore?'**
  String get rifiutoFormDialogIsSmaltitore;

  /// No description provided for @rifiutoFormDialogNrAutorizzazioneSmaltitore.
  ///
  /// In it, this message translates to:
  /// **'Numero di Autorizzazione Smaltitore'**
  String get rifiutoFormDialogNrAutorizzazioneSmaltitore;

  /// No description provided for @rifiutoFormDialogScadNonPericolosiSmaltitore.
  ///
  /// In it, this message translates to:
  /// **'Scadenza rifiuti non pericolosi smaltitore'**
  String get rifiutoFormDialogScadNonPericolosiSmaltitore;

  /// No description provided for @rifiutoFormDialogScadPericolosiSmaltitore.
  ///
  /// In it, this message translates to:
  /// **'Scadenza rifiuti pericolosi smaltitore'**
  String get rifiutoFormDialogScadPericolosiSmaltitore;

  /// No description provided for @rifiutoFormDialogNoteSmaltitore.
  ///
  /// In it, this message translates to:
  /// **'Note smaltitore'**
  String get rifiutoFormDialogNoteSmaltitore;

  /// No description provided for @automezzoFormDialogNewTitle.
  ///
  /// In it, this message translates to:
  /// **'Nuovo automezzo'**
  String get automezzoFormDialogNewTitle;

  /// No description provided for @automezzoFormDialogEditTitle.
  ///
  /// In it, this message translates to:
  /// **'Modifica automezzo'**
  String get automezzoFormDialogEditTitle;

  /// No description provided for @automezzoFormDialogNomeLabel.
  ///
  /// In it, this message translates to:
  /// **'Nome'**
  String get automezzoFormDialogNomeLabel;

  /// No description provided for @automezzoFormDialogTargaLabel.
  ///
  /// In it, this message translates to:
  /// **'Targa*'**
  String get automezzoFormDialogTargaLabel;

  /// No description provided for @automezzoFormDialogCategoriaLabel.
  ///
  /// In it, this message translates to:
  /// **'Categoria'**
  String get automezzoFormDialogCategoriaLabel;

  /// No description provided for @automezzoFormDialogNonSpecificata.
  ///
  /// In it, this message translates to:
  /// **'Non specificata'**
  String get automezzoFormDialogNonSpecificata;

  /// No description provided for @automezzoFormDialogTelepassLabel.
  ///
  /// In it, this message translates to:
  /// **'Numero Telepass'**
  String get automezzoFormDialogTelepassLabel;

  /// No description provided for @automezzoFormDialogProprietaLabel.
  ///
  /// In it, this message translates to:
  /// **'Proprietà'**
  String get automezzoFormDialogProprietaLabel;

  /// No description provided for @automezzoFormDialogScadenzaProprieta.
  ///
  /// In it, this message translates to:
  /// **'Scadenza {proprieta}'**
  String automezzoFormDialogScadenzaProprieta(String proprieta);

  /// No description provided for @automezzoFormDialogSectionAssicurazione.
  ///
  /// In it, this message translates to:
  /// **'Assicurazione'**
  String get automezzoFormDialogSectionAssicurazione;

  /// No description provided for @automezzoFormDialogScadenzaAssicurazione.
  ///
  /// In it, this message translates to:
  /// **'Scadenza assicurazione'**
  String get automezzoFormDialogScadenzaAssicurazione;

  /// No description provided for @automezzoFormDialogNomeAssicurazioneLabel.
  ///
  /// In it, this message translates to:
  /// **'Nome assicurazione'**
  String get automezzoFormDialogNomeAssicurazioneLabel;

  /// No description provided for @automezzoFormDialogSectionBollo.
  ///
  /// In it, this message translates to:
  /// **'Bollo'**
  String get automezzoFormDialogSectionBollo;

  /// No description provided for @automezzoFormDialogScadenzaBollo.
  ///
  /// In it, this message translates to:
  /// **'Scadenza bollo'**
  String get automezzoFormDialogScadenzaBollo;

  /// No description provided for @automezzoFormDialogSectionRevisione.
  ///
  /// In it, this message translates to:
  /// **'Revisione'**
  String get automezzoFormDialogSectionRevisione;

  /// No description provided for @automezzoFormDialogScadenzaRevisione.
  ///
  /// In it, this message translates to:
  /// **'Scadenza revisione'**
  String get automezzoFormDialogScadenzaRevisione;

  /// No description provided for @automezzoFormDialogSectionTachigrafo.
  ///
  /// In it, this message translates to:
  /// **'Tachigrafo'**
  String get automezzoFormDialogSectionTachigrafo;

  /// No description provided for @automezzoFormDialogScadenzaControlloTachigrafo.
  ///
  /// In it, this message translates to:
  /// **'Scadenza controllo tachigrafo'**
  String get automezzoFormDialogScadenzaControlloTachigrafo;

  /// No description provided for @automezzoFormDialogNoteAggiuntive.
  ///
  /// In it, this message translates to:
  /// **'Note aggiuntive'**
  String get automezzoFormDialogNoteAggiuntive;

  /// No description provided for @scalaFormDialogNewTitle.
  ///
  /// In it, this message translates to:
  /// **'Nuova scala'**
  String get scalaFormDialogNewTitle;

  /// No description provided for @scalaFormDialogEditTitle.
  ///
  /// In it, this message translates to:
  /// **'Modifica scala'**
  String get scalaFormDialogEditTitle;

  /// No description provided for @scalaFormDialogSectionAnagrafica.
  ///
  /// In it, this message translates to:
  /// **'Anagrafica'**
  String get scalaFormDialogSectionAnagrafica;

  /// No description provided for @scalaFormDialogCodiceLabel.
  ///
  /// In it, this message translates to:
  /// **'Codice*'**
  String get scalaFormDialogCodiceLabel;

  /// No description provided for @scalaFormDialogMaterialeLabel.
  ///
  /// In it, this message translates to:
  /// **'Materiale'**
  String get scalaFormDialogMaterialeLabel;

  /// No description provided for @scalaFormDialogDescrizioneLabel.
  ///
  /// In it, this message translates to:
  /// **'Descrizione'**
  String get scalaFormDialogDescrizioneLabel;

  /// No description provided for @scalaFormDialogSectionUbicazione.
  ///
  /// In it, this message translates to:
  /// **'Ubicazione'**
  String get scalaFormDialogSectionUbicazione;

  /// No description provided for @scalaFormDialogTipoUbicazioneLabel.
  ///
  /// In it, this message translates to:
  /// **'Tipo ubicazione'**
  String get scalaFormDialogTipoUbicazioneLabel;

  /// No description provided for @scalaFormDialogUbicazioneNonSpecificata.
  ///
  /// In it, this message translates to:
  /// **'Non specificata'**
  String get scalaFormDialogUbicazioneNonSpecificata;

  /// No description provided for @scalaFormDialogUbicazioneMagazzino.
  ///
  /// In it, this message translates to:
  /// **'Magazzino'**
  String get scalaFormDialogUbicazioneMagazzino;

  /// No description provided for @scalaFormDialogUbicazioneCantiere.
  ///
  /// In it, this message translates to:
  /// **'Cantiere'**
  String get scalaFormDialogUbicazioneCantiere;

  /// No description provided for @scalaFormDialogSelectCantiereValidator.
  ///
  /// In it, this message translates to:
  /// **'Seleziona un cantiere'**
  String get scalaFormDialogSelectCantiereValidator;

  /// No description provided for @scalaFormDialogSectionVerifiche.
  ///
  /// In it, this message translates to:
  /// **'Verifiche'**
  String get scalaFormDialogSectionVerifiche;

  /// No description provided for @scalaFormDialogUltimaVerifica.
  ///
  /// In it, this message translates to:
  /// **'Ultima verifica'**
  String get scalaFormDialogUltimaVerifica;

  /// No description provided for @scalaFormDialogProssimaVerifica.
  ///
  /// In it, this message translates to:
  /// **'Prossima verifica'**
  String get scalaFormDialogProssimaVerifica;

  /// No description provided for @scalaFormDialogNoteAggiuntive.
  ///
  /// In it, this message translates to:
  /// **'Note aggiuntive'**
  String get scalaFormDialogNoteAggiuntive;

  /// No description provided for @modificaScadenzaCantiereDialogTitle.
  ///
  /// In it, this message translates to:
  /// **'Modifica {etichetta}'**
  String modificaScadenzaCantiereDialogTitle(String etichetta);

  /// No description provided for @modificaScadenzaCantiereDialogDataScadenza.
  ///
  /// In it, this message translates to:
  /// **'Data di scadenza'**
  String get modificaScadenzaCantiereDialogDataScadenza;

  /// No description provided for @modificaScadenzaCantiereDialogMissingDate.
  ///
  /// In it, this message translates to:
  /// **'Inserisci una data di scadenza'**
  String get modificaScadenzaCantiereDialogMissingDate;

  /// No description provided for @ritiroDpiQuotaDialogConfirmTitle.
  ///
  /// In it, this message translates to:
  /// **'Ritirare il DPI?'**
  String get ritiroDpiQuotaDialogConfirmTitle;

  /// No description provided for @ritiroDpiQuotaDialogConfirmMessage.
  ///
  /// In it, this message translates to:
  /// **'Ritirare \"{tipo}\" a {dipendente}? Viene azzerata solo la data di consegna: il resto della scheda resta invariato e alla riconsegna basterà reinserire la data.'**
  String ritiroDpiQuotaDialogConfirmMessage(String tipo, String dipendente);

  /// No description provided for @ritiroDpiQuotaDialogConfirmButton.
  ///
  /// In it, this message translates to:
  /// **'Ritira'**
  String get ritiroDpiQuotaDialogConfirmButton;

  /// No description provided for @ritiroDpiQuotaDialogRiconsegnaTitle.
  ///
  /// In it, this message translates to:
  /// **'Riconsegna — {tipo}'**
  String ritiroDpiQuotaDialogRiconsegnaTitle(String tipo);

  /// No description provided for @ritiroDpiQuotaDialogRiconsegnaMessage.
  ///
  /// In it, this message translates to:
  /// **'Il DPI torna a {dipendente}: indica la data in cui gli viene riconsegnato.'**
  String ritiroDpiQuotaDialogRiconsegnaMessage(String dipendente);

  /// No description provided for @ritiroDpiQuotaDialogDataConsegnaLabel.
  ///
  /// In it, this message translates to:
  /// **'Data consegna*'**
  String get ritiroDpiQuotaDialogDataConsegnaLabel;

  /// No description provided for @ritiroDpiQuotaDialogRiconsegnaButton.
  ///
  /// In it, this message translates to:
  /// **'Riconsegna'**
  String get ritiroDpiQuotaDialogRiconsegnaButton;

  /// No description provided for @statoBadgeValido.
  ///
  /// In it, this message translates to:
  /// **'Valido'**
  String get statoBadgeValido;

  /// No description provided for @statoBadgeInScadenza.
  ///
  /// In it, this message translates to:
  /// **'In scadenza'**
  String get statoBadgeInScadenza;

  /// No description provided for @statoBadgeScaduto.
  ///
  /// In it, this message translates to:
  /// **'Scaduto'**
  String get statoBadgeScaduto;

  /// No description provided for @segnaleticaSicurezzaScreenZonaUfficio.
  ///
  /// In it, this message translates to:
  /// **'Ufficio'**
  String get segnaleticaSicurezzaScreenZonaUfficio;

  /// No description provided for @segnaleticaSicurezzaScreenZonaMagazzino.
  ///
  /// In it, this message translates to:
  /// **'Magazzino'**
  String get segnaleticaSicurezzaScreenZonaMagazzino;

  /// No description provided for @segnaleticaSicurezzaScreenZonaNonSpecificata.
  ///
  /// In it, this message translates to:
  /// **'Zona non specificata'**
  String get segnaleticaSicurezzaScreenZonaNonSpecificata;

  /// No description provided for @segnaleticaSicurezzaScreenEsitoCartelloAssente.
  ///
  /// In it, this message translates to:
  /// **'Cartello assente'**
  String get segnaleticaSicurezzaScreenEsitoCartelloAssente;

  /// No description provided for @segnaleticaSicurezzaScreenEsitoPresente.
  ///
  /// In it, this message translates to:
  /// **'Presente'**
  String get segnaleticaSicurezzaScreenEsitoPresente;

  /// No description provided for @segnaleticaSicurezzaScreenEsitoPosizioneIdonea.
  ///
  /// In it, this message translates to:
  /// **'Posizione idonea'**
  String get segnaleticaSicurezzaScreenEsitoPosizioneIdonea;

  /// No description provided for @segnaleticaSicurezzaScreenEsitoPosizioneNonIdonea.
  ///
  /// In it, this message translates to:
  /// **'Posizione non idonea'**
  String get segnaleticaSicurezzaScreenEsitoPosizioneNonIdonea;

  /// No description provided for @segnaleticaSicurezzaScreenEsitoBuonoStato.
  ///
  /// In it, this message translates to:
  /// **'Buono stato'**
  String get segnaleticaSicurezzaScreenEsitoBuonoStato;

  /// No description provided for @segnaleticaSicurezzaScreenEsitoDaSostituire.
  ///
  /// In it, this message translates to:
  /// **'Da sostituire'**
  String get segnaleticaSicurezzaScreenEsitoDaSostituire;

  /// No description provided for @segnaleticaSicurezzaScreenTitle.
  ///
  /// In it, this message translates to:
  /// **'Segnaletica di Sicurezza'**
  String get segnaleticaSicurezzaScreenTitle;

  /// No description provided for @segnaleticaSicurezzaScreenTitleShort.
  ///
  /// In it, this message translates to:
  /// **'Segnaletica'**
  String get segnaleticaSicurezzaScreenTitleShort;

  /// No description provided for @segnaleticaSicurezzaScreenNuovoControllo.
  ///
  /// In it, this message translates to:
  /// **'Nuovo controllo'**
  String get segnaleticaSicurezzaScreenNuovoControllo;

  /// No description provided for @segnaleticaSicurezzaScreenNuovoSegnale.
  ///
  /// In it, this message translates to:
  /// **'Nuovo segnale'**
  String get segnaleticaSicurezzaScreenNuovoSegnale;

  /// No description provided for @segnaleticaSicurezzaScreenInfoEmailScadenza.
  ///
  /// In it, this message translates to:
  /// **'Info email di scadenza'**
  String get segnaleticaSicurezzaScreenInfoEmailScadenza;

  /// No description provided for @segnaleticaSicurezzaScreenSegnaleticaPresente.
  ///
  /// In it, this message translates to:
  /// **'Segnaletica presente'**
  String get segnaleticaSicurezzaScreenSegnaleticaPresente;

  /// No description provided for @segnaleticaSicurezzaScreenChiudiTutti.
  ///
  /// In it, this message translates to:
  /// **'Chiudi tutti'**
  String get segnaleticaSicurezzaScreenChiudiTutti;

  /// No description provided for @segnaleticaSicurezzaScreenEspandiTutti.
  ///
  /// In it, this message translates to:
  /// **'Espandi tutti'**
  String get segnaleticaSicurezzaScreenEspandiTutti;

  /// No description provided for @segnaleticaSicurezzaScreenControllaTutti.
  ///
  /// In it, this message translates to:
  /// **'Controlla tutti'**
  String get segnaleticaSicurezzaScreenControllaTutti;

  /// No description provided for @segnaleticaSicurezzaScreenNessunCartelloZona.
  ///
  /// In it, this message translates to:
  /// **'Nessun cartello in questa zona.'**
  String get segnaleticaSicurezzaScreenNessunCartelloZona;

  /// No description provided for @segnaleticaSicurezzaScreenModificaCartello.
  ///
  /// In it, this message translates to:
  /// **'Modifica cartello'**
  String get segnaleticaSicurezzaScreenModificaCartello;

  /// No description provided for @segnaleticaSicurezzaScreenEliminaCartello.
  ///
  /// In it, this message translates to:
  /// **'Elimina cartello'**
  String get segnaleticaSicurezzaScreenEliminaCartello;

  /// No description provided for @segnaleticaSicurezzaScreenEliminareCartelloTitle.
  ///
  /// In it, this message translates to:
  /// **'Eliminare cartello?'**
  String get segnaleticaSicurezzaScreenEliminareCartelloTitle;

  /// No description provided for @segnaleticaSicurezzaScreenEliminareCartelloMessage.
  ///
  /// In it, this message translates to:
  /// **'Eliminare \"{nome}\" e i suoi controlli? L\'operazione non è reversibile.'**
  String segnaleticaSicurezzaScreenEliminareCartelloMessage(String nome);

  /// No description provided for @segnaleticaSicurezzaScreenNascondiInfo.
  ///
  /// In it, this message translates to:
  /// **'Nascondi info'**
  String get segnaleticaSicurezzaScreenNascondiInfo;

  /// No description provided for @segnaleticaSicurezzaScreenMostraInfo.
  ///
  /// In it, this message translates to:
  /// **'Mostra info'**
  String get segnaleticaSicurezzaScreenMostraInfo;

  /// No description provided for @segnaleticaSicurezzaScreenCampoUbicazione.
  ///
  /// In it, this message translates to:
  /// **'Ubicazione'**
  String get segnaleticaSicurezzaScreenCampoUbicazione;

  /// No description provided for @segnaleticaSicurezzaScreenUltimoControllo.
  ///
  /// In it, this message translates to:
  /// **'Ultimo controllo'**
  String get segnaleticaSicurezzaScreenUltimoControllo;

  /// No description provided for @segnaleticaSicurezzaScreenMaiControllato.
  ///
  /// In it, this message translates to:
  /// **'mai controllato'**
  String get segnaleticaSicurezzaScreenMaiControllato;

  /// No description provided for @segnaleticaSicurezzaScreenDatiCartello.
  ///
  /// In it, this message translates to:
  /// **'Dati del cartello'**
  String get segnaleticaSicurezzaScreenDatiCartello;

  /// No description provided for @segnaleticaSicurezzaScreenCampoZona.
  ///
  /// In it, this message translates to:
  /// **'Zona'**
  String get segnaleticaSicurezzaScreenCampoZona;

  /// No description provided for @segnaleticaSicurezzaScreenControlliRegistrati.
  ///
  /// In it, this message translates to:
  /// **'Controlli registrati'**
  String get segnaleticaSicurezzaScreenControlliRegistrati;

  /// No description provided for @segnaleticaSicurezzaScreenControlliHeader.
  ///
  /// In it, this message translates to:
  /// **'Controlli'**
  String get segnaleticaSicurezzaScreenControlliHeader;

  /// No description provided for @segnaleticaSicurezzaScreenNessunControlloRegistrato.
  ///
  /// In it, this message translates to:
  /// **'Nessun controllo registrato.'**
  String get segnaleticaSicurezzaScreenNessunControlloRegistrato;

  /// No description provided for @segnaleticaSicurezzaScreenIngrandisciCartello.
  ///
  /// In it, this message translates to:
  /// **'Ingrandisci cartello'**
  String get segnaleticaSicurezzaScreenIngrandisciCartello;

  /// No description provided for @segnaleticaSicurezzaScreenImmagineNonDisponibile.
  ///
  /// In it, this message translates to:
  /// **'Immagine non disponibile'**
  String get segnaleticaSicurezzaScreenImmagineNonDisponibile;

  /// No description provided for @segnaleticaSicurezzaScreenEsitiLabel.
  ///
  /// In it, this message translates to:
  /// **'Esiti'**
  String get segnaleticaSicurezzaScreenEsitiLabel;

  /// No description provided for @segnaleticaSicurezzaScreenNoteControllo.
  ///
  /// In it, this message translates to:
  /// **'Note controllo'**
  String get segnaleticaSicurezzaScreenNoteControllo;

  /// No description provided for @segnaleticaSicurezzaScreenModificaControllo.
  ///
  /// In it, this message translates to:
  /// **'Modifica controllo'**
  String get segnaleticaSicurezzaScreenModificaControllo;

  /// No description provided for @segnaleticaSicurezzaScreenEliminaControllo.
  ///
  /// In it, this message translates to:
  /// **'Elimina controllo'**
  String get segnaleticaSicurezzaScreenEliminaControllo;

  /// No description provided for @segnaleticaSicurezzaScreenEliminareControlloTitle.
  ///
  /// In it, this message translates to:
  /// **'Eliminare controllo?'**
  String get segnaleticaSicurezzaScreenEliminareControlloTitle;

  /// No description provided for @segnaleticaSicurezzaScreenEliminareControlloMessage.
  ///
  /// In it, this message translates to:
  /// **'Eliminare il controllo del {data} su \"{nome}\"? L\'operazione non è reversibile.'**
  String segnaleticaSicurezzaScreenEliminareControlloMessage(
    String data,
    String nome,
  );

  /// No description provided for @dpiScreenTitle.
  ///
  /// In it, this message translates to:
  /// **'DPI'**
  String get dpiScreenTitle;

  /// No description provided for @dpiScreenAssegnaDpi.
  ///
  /// In it, this message translates to:
  /// **'Assegna DPI'**
  String get dpiScreenAssegnaDpi;

  /// No description provided for @dpiScreenTipiDpi.
  ///
  /// In it, this message translates to:
  /// **'Tipi di DPI'**
  String get dpiScreenTipiDpi;

  /// No description provided for @dpiScreenScadenzeImminenti.
  ///
  /// In it, this message translates to:
  /// **'Scadenze imminenti'**
  String get dpiScreenScadenzeImminenti;

  /// No description provided for @dpiScreenNascondiScadenze.
  ///
  /// In it, this message translates to:
  /// **'Nascondi scadenze'**
  String get dpiScreenNascondiScadenze;

  /// No description provided for @dpiScreenMostraScadenze.
  ///
  /// In it, this message translates to:
  /// **'Mostra scadenze'**
  String get dpiScreenMostraScadenze;

  /// No description provided for @dpiScreenDipendentiConDpiObbligatori.
  ///
  /// In it, this message translates to:
  /// **'Dipendenti con DPI obbligatori'**
  String get dpiScreenDipendentiConDpiObbligatori;

  /// No description provided for @dpiScreenNascondiTutti.
  ///
  /// In it, this message translates to:
  /// **'Nascondi tutti'**
  String get dpiScreenNascondiTutti;

  /// No description provided for @dpiScreenMostraTutti.
  ///
  /// In it, this message translates to:
  /// **'Mostra tutti'**
  String get dpiScreenMostraTutti;

  /// No description provided for @dpiScreenCercaPerNome.
  ///
  /// In it, this message translates to:
  /// **'Cerca per nome'**
  String get dpiScreenCercaPerNome;

  /// No description provided for @dpiScreenNessunDipendenteMansione.
  ///
  /// In it, this message translates to:
  /// **'Nessun dipendente con mansione Datore, M02, M03 o M04.'**
  String get dpiScreenNessunDipendenteMansione;

  /// No description provided for @dpiScreenNessunDipendenteTrovato.
  ///
  /// In it, this message translates to:
  /// **'Nessun dipendente trovato per \"{query}\".'**
  String dpiScreenNessunDipendenteTrovato(String query);

  /// No description provided for @dpiScreenCampoDipendente.
  ///
  /// In it, this message translates to:
  /// **'Dipendente'**
  String get dpiScreenCampoDipendente;

  /// No description provided for @dpiScreenCampoMatricola.
  ///
  /// In it, this message translates to:
  /// **'Matricola'**
  String get dpiScreenCampoMatricola;

  /// No description provided for @dpiScreenNotaScadenza.
  ///
  /// In it, this message translates to:
  /// **'Nota scadenza'**
  String get dpiScreenNotaScadenza;

  /// No description provided for @dpiScreenModificaNota.
  ///
  /// In it, this message translates to:
  /// **'Modifica nota'**
  String get dpiScreenModificaNota;

  /// No description provided for @dpiScreenCampoMansione.
  ///
  /// In it, this message translates to:
  /// **'Mansione'**
  String get dpiScreenCampoMansione;

  /// No description provided for @dpiScreenCampoAssegnati.
  ///
  /// In it, this message translates to:
  /// **'Assegnati'**
  String get dpiScreenCampoAssegnati;

  /// No description provided for @dpiScreenCampoNota.
  ///
  /// In it, this message translates to:
  /// **'Nota'**
  String get dpiScreenCampoNota;

  /// No description provided for @dpiScreenAssegnaAltroDpi.
  ///
  /// In it, this message translates to:
  /// **'Assegna un altro DPI'**
  String get dpiScreenAssegnaAltroDpi;

  /// No description provided for @dpiScreenNascondiDpi.
  ///
  /// In it, this message translates to:
  /// **'Nascondi DPI'**
  String get dpiScreenNascondiDpi;

  /// No description provided for @dpiScreenMostraDpi.
  ///
  /// In it, this message translates to:
  /// **'Mostra DPI'**
  String get dpiScreenMostraDpi;

  /// No description provided for @dpiScreenNessunaRegolaDpi.
  ///
  /// In it, this message translates to:
  /// **'Nessuna regola DPI impostata per questa mansione.'**
  String get dpiScreenNessunaRegolaDpi;

  /// No description provided for @dpiScreenAltriDpiAssegnati.
  ///
  /// In it, this message translates to:
  /// **'Altri DPI assegnati'**
  String get dpiScreenAltriDpiAssegnati;

  /// No description provided for @dpiScreenNonAssegnato.
  ///
  /// In it, this message translates to:
  /// **'Non assegnato'**
  String get dpiScreenNonAssegnato;

  /// No description provided for @dpiScreenCampoProduttore.
  ///
  /// In it, this message translates to:
  /// **'Produttore'**
  String get dpiScreenCampoProduttore;

  /// No description provided for @dpiScreenCampoTaglia.
  ///
  /// In it, this message translates to:
  /// **'Taglia'**
  String get dpiScreenCampoTaglia;

  /// No description provided for @dpiScreenCampoScadenza.
  ///
  /// In it, this message translates to:
  /// **'Scadenza'**
  String get dpiScreenCampoScadenza;

  /// No description provided for @dpiScreenNonImpostata.
  ///
  /// In it, this message translates to:
  /// **'non impostata'**
  String get dpiScreenNonImpostata;

  /// No description provided for @dpiScreenDpiRitirato.
  ///
  /// In it, this message translates to:
  /// **'DPI Ritirato'**
  String get dpiScreenDpiRitirato;

  /// No description provided for @dpiScreenRiconsegnaDpiQuota.
  ///
  /// In it, this message translates to:
  /// **'Riconsegna DPI per lavori in quota'**
  String get dpiScreenRiconsegnaDpiQuota;

  /// No description provided for @dpiScreenRitiraDpiQuota.
  ///
  /// In it, this message translates to:
  /// **'Ritira DPI per lavori in quota'**
  String get dpiScreenRitiraDpiQuota;

  /// No description provided for @dpiScreenModificaDpiAssegnato.
  ///
  /// In it, this message translates to:
  /// **'Modifica DPI assegnato'**
  String get dpiScreenModificaDpiAssegnato;

  /// No description provided for @dpiScreenEliminaDpiAssegnato.
  ///
  /// In it, this message translates to:
  /// **'Elimina DPI assegnato'**
  String get dpiScreenEliminaDpiAssegnato;

  /// No description provided for @dpiScreenEliminareDpiAssegnatoTitle.
  ///
  /// In it, this message translates to:
  /// **'Eliminare il DPI assegnato?'**
  String get dpiScreenEliminareDpiAssegnatoTitle;

  /// No description provided for @dpiScreenEliminareDpiAssegnatoMessage.
  ///
  /// In it, this message translates to:
  /// **'Eliminare \"{tipo}\" assegnato a {dipendente}? L\'operazione non è reversibile.'**
  String dpiScreenEliminareDpiAssegnatoMessage(String tipo, String dipendente);

  /// No description provided for @rifiutiScreenTipoNonPericolosiTrasportatore.
  ///
  /// In it, this message translates to:
  /// **'Scadenza Rifiuti Non Pericolosi Trasportatore'**
  String get rifiutiScreenTipoNonPericolosiTrasportatore;

  /// No description provided for @rifiutiScreenTipoPericolosiTrasportatore.
  ///
  /// In it, this message translates to:
  /// **'Scadenza Rifiuti Pericolosi Trasportatore'**
  String get rifiutiScreenTipoPericolosiTrasportatore;

  /// No description provided for @rifiutiScreenTipoNonPericolosiSmaltitore.
  ///
  /// In it, this message translates to:
  /// **'Scadenza Rifiuti Non Pericolosi Smaltitore'**
  String get rifiutiScreenTipoNonPericolosiSmaltitore;

  /// No description provided for @rifiutiScreenTipoPericolosiSmaltitore.
  ///
  /// In it, this message translates to:
  /// **'Scadenza Rifiuti Pericolosi Smaltitore'**
  String get rifiutiScreenTipoPericolosiSmaltitore;

  /// No description provided for @rifiutiScreenTitle.
  ///
  /// In it, this message translates to:
  /// **'Rifiuti'**
  String get rifiutiScreenTitle;

  /// No description provided for @rifiutiScreenScadenzeImminenti.
  ///
  /// In it, this message translates to:
  /// **'Scadenze imminenti'**
  String get rifiutiScreenScadenzeImminenti;

  /// No description provided for @rifiutiScreenNascondiScadenze.
  ///
  /// In it, this message translates to:
  /// **'Nascondi scadenze'**
  String get rifiutiScreenNascondiScadenze;

  /// No description provided for @rifiutiScreenMostraScadenze.
  ///
  /// In it, this message translates to:
  /// **'Mostra scadenze'**
  String get rifiutiScreenMostraScadenze;

  /// No description provided for @rifiutiScreenAziendePerRaccolta.
  ///
  /// In it, this message translates to:
  /// **'Aziende per raccolta rifiuti'**
  String get rifiutiScreenAziendePerRaccolta;

  /// No description provided for @rifiutiScreenNascondiTutti.
  ///
  /// In it, this message translates to:
  /// **'Nascondi tutti'**
  String get rifiutiScreenNascondiTutti;

  /// No description provided for @rifiutiScreenMostraTutti.
  ///
  /// In it, this message translates to:
  /// **'Mostra tutti'**
  String get rifiutiScreenMostraTutti;

  /// No description provided for @rifiutiScreenCercaPerNomeDitta.
  ///
  /// In it, this message translates to:
  /// **'Cerca per nome ditta'**
  String get rifiutiScreenCercaPerNomeDitta;

  /// No description provided for @rifiutiScreenNessunElementoCaricato.
  ///
  /// In it, this message translates to:
  /// **'Nessun elemento caricato.'**
  String get rifiutiScreenNessunElementoCaricato;

  /// No description provided for @rifiutiScreenNessunElementoTrovato.
  ///
  /// In it, this message translates to:
  /// **'Nessun elemento trovato per \"{query}\".'**
  String rifiutiScreenNessunElementoTrovato(String query);

  /// No description provided for @rifiutiScreenCampoDitta.
  ///
  /// In it, this message translates to:
  /// **'Ditta'**
  String get rifiutiScreenCampoDitta;

  /// No description provided for @rifiutiScreenNotaScadenza.
  ///
  /// In it, this message translates to:
  /// **'Nota scadenza'**
  String get rifiutiScreenNotaScadenza;

  /// No description provided for @rifiutiScreenModificaNota.
  ///
  /// In it, this message translates to:
  /// **'Modifica nota'**
  String get rifiutiScreenModificaNota;

  /// No description provided for @rifiutiScreenCampoTrasportatore.
  ///
  /// In it, this message translates to:
  /// **'Trasportatore'**
  String get rifiutiScreenCampoTrasportatore;

  /// No description provided for @rifiutiScreenNoteTrasportatore.
  ///
  /// In it, this message translates to:
  /// **'Note trasportatore'**
  String get rifiutiScreenNoteTrasportatore;

  /// No description provided for @rifiutiScreenCampoSmaltitore.
  ///
  /// In it, this message translates to:
  /// **'Smaltitore'**
  String get rifiutiScreenCampoSmaltitore;

  /// No description provided for @rifiutiScreenNoteSmaltitore.
  ///
  /// In it, this message translates to:
  /// **'Note smaltitore'**
  String get rifiutiScreenNoteSmaltitore;

  /// No description provided for @rifiutiScreenEliminaAzienda.
  ///
  /// In it, this message translates to:
  /// **'Elimina azienda'**
  String get rifiutiScreenEliminaAzienda;

  /// No description provided for @rifiutiScreenEliminareAziendaTitle.
  ///
  /// In it, this message translates to:
  /// **'Eliminare azienda?'**
  String get rifiutiScreenEliminareAziendaTitle;

  /// No description provided for @rifiutiScreenEliminareAziendaMessage.
  ///
  /// In it, this message translates to:
  /// **'Eliminare \"{nome}\"? L\'operazione non è reversibile.'**
  String rifiutiScreenEliminareAziendaMessage(String nome);

  /// No description provided for @rifiutiScreenNascondiInfo.
  ///
  /// In it, this message translates to:
  /// **'Nascondi info'**
  String get rifiutiScreenNascondiInfo;

  /// No description provided for @rifiutiScreenMostraInfo.
  ///
  /// In it, this message translates to:
  /// **'Mostra info'**
  String get rifiutiScreenMostraInfo;

  /// No description provided for @rifiutiScreenNrAutorizzazione.
  ///
  /// In it, this message translates to:
  /// **'Nr. Autorizzazione'**
  String get rifiutiScreenNrAutorizzazione;

  /// No description provided for @rifiutiScreenScadNonPericolosi.
  ///
  /// In it, this message translates to:
  /// **'Scad. Rifiuti non pericolosi'**
  String get rifiutiScreenScadNonPericolosi;

  /// No description provided for @rifiutiScreenScadPericolosi.
  ///
  /// In it, this message translates to:
  /// **'Scad. Rifiuti pericolosi'**
  String get rifiutiScreenScadPericolosi;

  /// No description provided for @controlloSegnaleFormDialogEditTitle.
  ///
  /// In it, this message translates to:
  /// **'Modifica controllo'**
  String get controlloSegnaleFormDialogEditTitle;

  /// No description provided for @controlloSegnaleFormDialogNewTitle.
  ///
  /// In it, this message translates to:
  /// **'Nuovo controllo'**
  String get controlloSegnaleFormDialogNewTitle;

  /// No description provided for @controlloSegnaleFormDialogCartelloLabel.
  ///
  /// In it, this message translates to:
  /// **'Cartello*'**
  String get controlloSegnaleFormDialogCartelloLabel;

  /// No description provided for @controlloSegnaleFormDialogSelezionaCartello.
  ///
  /// In it, this message translates to:
  /// **'Seleziona un cartello'**
  String get controlloSegnaleFormDialogSelezionaCartello;

  /// No description provided for @controlloSegnaleFormDialogDataIspezione.
  ///
  /// In it, this message translates to:
  /// **'Data ispezione'**
  String get controlloSegnaleFormDialogDataIspezione;

  /// No description provided for @controlloSegnaleFormDialogEsitoControllo.
  ///
  /// In it, this message translates to:
  /// **'Esito del controllo'**
  String get controlloSegnaleFormDialogEsitoControllo;

  /// No description provided for @controlloSegnaleFormDialogCartelloPresente.
  ///
  /// In it, this message translates to:
  /// **'Il cartello è presente'**
  String get controlloSegnaleFormDialogCartelloPresente;

  /// No description provided for @controlloSegnaleFormDialogPosizioneIdonea.
  ///
  /// In it, this message translates to:
  /// **'Posizione idonea'**
  String get controlloSegnaleFormDialogPosizioneIdonea;

  /// No description provided for @controlloSegnaleFormDialogInBuonoStato.
  ///
  /// In it, this message translates to:
  /// **'In buono stato'**
  String get controlloSegnaleFormDialogInBuonoStato;

  /// No description provided for @controlloSegnaleFormDialogNoteHint.
  ///
  /// In it, this message translates to:
  /// **'Es. cartello scolorito, da sostituire'**
  String get controlloSegnaleFormDialogNoteHint;

  /// No description provided for @controlloSegnaleFormDialogControlloZonaTitle.
  ///
  /// In it, this message translates to:
  /// **'Controllo di zona - {zona}'**
  String controlloSegnaleFormDialogControlloZonaTitle(String zona);

  /// No description provided for @controlloSegnaleFormDialogRegistrazioneBlocco.
  ///
  /// In it, this message translates to:
  /// **'Viene registrato un controllo con esito positivo (cartello presente, posizione idonea, buono stato) su tutti i {count} {noun} della zona. Se un cartello non era a posto, correggi il suo controllo dalla card del cartello.'**
  String controlloSegnaleFormDialogRegistrazioneBlocco(int count, String noun);

  /// No description provided for @controlloSegnaleFormDialogSignSingular.
  ///
  /// In it, this message translates to:
  /// **'cartello'**
  String get controlloSegnaleFormDialogSignSingular;

  /// No description provided for @controlloSegnaleFormDialogSignPlural.
  ///
  /// In it, this message translates to:
  /// **'cartelli'**
  String get controlloSegnaleFormDialogSignPlural;

  /// No description provided for @controlloSegnaleFormDialogNoteAppliedLabel.
  ///
  /// In it, this message translates to:
  /// **'Note (applicate a tutti)'**
  String get controlloSegnaleFormDialogNoteAppliedLabel;

  /// No description provided for @controlloSegnaleFormDialogNoteAppliedHint.
  ///
  /// In it, this message translates to:
  /// **'Es. giro di controllo mensile'**
  String get controlloSegnaleFormDialogNoteAppliedHint;

  /// No description provided for @controlloSegnaleFormDialogCartelliInteressati.
  ///
  /// In it, this message translates to:
  /// **'Cartelli interessati'**
  String get controlloSegnaleFormDialogCartelliInteressati;

  /// No description provided for @controlloSegnaleFormDialogRegistraSuTutti.
  ///
  /// In it, this message translates to:
  /// **'Registra su tutti'**
  String get controlloSegnaleFormDialogRegistraSuTutti;

  /// No description provided for @tipoScadenzaFormDialogSelezionaAppartenenza.
  ///
  /// In it, this message translates to:
  /// **'Seleziona almeno un\'appartenenza'**
  String get tipoScadenzaFormDialogSelezionaAppartenenza;

  /// No description provided for @tipoScadenzaFormDialogNewTitle.
  ///
  /// In it, this message translates to:
  /// **'Nuovo tipo scadenza'**
  String get tipoScadenzaFormDialogNewTitle;

  /// No description provided for @tipoScadenzaFormDialogEditTitle.
  ///
  /// In it, this message translates to:
  /// **'Modifica tipo scadenza'**
  String get tipoScadenzaFormDialogEditTitle;

  /// No description provided for @tipoScadenzaFormDialogTipologia.
  ///
  /// In it, this message translates to:
  /// **'Tipologia'**
  String get tipoScadenzaFormDialogTipologia;

  /// No description provided for @tipoScadenzaFormDialogNomeLabel.
  ///
  /// In it, this message translates to:
  /// **'Nome*'**
  String get tipoScadenzaFormDialogNomeLabel;

  /// No description provided for @tipoScadenzaFormDialogNomeHint.
  ///
  /// In it, this message translates to:
  /// **'es. DURC, POS, Visura'**
  String get tipoScadenzaFormDialogNomeHint;

  /// No description provided for @tipoScadenzaFormDialogNotaPredefinitaLabel.
  ///
  /// In it, this message translates to:
  /// **'Nota predefinita'**
  String get tipoScadenzaFormDialogNotaPredefinitaLabel;

  /// No description provided for @tipoScadenzaFormDialogNotaPredefinitaHint.
  ///
  /// In it, this message translates to:
  /// **'es. scade ogni 6 mesi'**
  String get tipoScadenzaFormDialogNotaPredefinitaHint;

  /// No description provided for @tipoScadenzaFormDialogNotaPredefinitaHelper.
  ///
  /// In it, this message translates to:
  /// **'Viene precompilata nelle note della scadenza quando si sceglie questa tipologia'**
  String get tipoScadenzaFormDialogNotaPredefinitaHelper;

  /// No description provided for @tipoScadenzaFormDialogAppartenenza.
  ///
  /// In it, this message translates to:
  /// **'Appartenenza'**
  String get tipoScadenzaFormDialogAppartenenza;

  /// No description provided for @tipoScadenzaFormDialogCantiere.
  ///
  /// In it, this message translates to:
  /// **'Cantiere'**
  String get tipoScadenzaFormDialogCantiere;

  /// No description provided for @tipoScadenzaFormDialogSubappaltatore.
  ///
  /// In it, this message translates to:
  /// **'Subappaltatore'**
  String get tipoScadenzaFormDialogSubappaltatore;

  /// No description provided for @tipoScadenzaFormDialogDipendenteSubappaltatore.
  ///
  /// In it, this message translates to:
  /// **'Dipendente del subappaltatore'**
  String get tipoScadenzaFormDialogDipendenteSubappaltatore;

  /// No description provided for @tipoScadenzaFormDialogLavoratoreAutonomo.
  ///
  /// In it, this message translates to:
  /// **'Lavoratore autonomo'**
  String get tipoScadenzaFormDialogLavoratoreAutonomo;

  /// No description provided for @tipoScadenzaFormDialogTipologieDipendentiInfo.
  ///
  /// In it, this message translates to:
  /// **'Le tipologie dei dipendenti valgono anche per i lavoratori autonomi.'**
  String get tipoScadenzaFormDialogTipologieDipendentiInfo;

  /// No description provided for @tipoScadenzaFormDialogScadenza.
  ///
  /// In it, this message translates to:
  /// **'Scadenza'**
  String get tipoScadenzaFormDialogScadenza;

  /// No description provided for @tipoScadenzaFormDialogRichiedeScadenza.
  ///
  /// In it, this message translates to:
  /// **'Richiede scadenza'**
  String get tipoScadenzaFormDialogRichiedeScadenza;

  /// No description provided for @tipoScadenzaFormDialogAvvisaSoloScadutaTitle.
  ///
  /// In it, this message translates to:
  /// **'Avvisa solo a scadenza superata'**
  String get tipoScadenzaFormDialogAvvisaSoloScadutaTitle;

  /// No description provided for @tipoScadenzaFormDialogAvvisaSoloScadutaSubtitle.
  ///
  /// In it, this message translates to:
  /// **'Nessun preavviso: la prima email parte il giorno dopo la data di scadenza (es. DURC)'**
  String get tipoScadenzaFormDialogAvvisaSoloScadutaSubtitle;

  /// No description provided for @tipoScadenzaFormDialogGiorniPreavvisoLabel.
  ///
  /// In it, this message translates to:
  /// **'Giorni di preavviso'**
  String get tipoScadenzaFormDialogGiorniPreavvisoLabel;

  /// No description provided for @tipoScadenzaFormDialogGiorniPreavvisoHint.
  ///
  /// In it, this message translates to:
  /// **'es. 30, 15, 7, 1'**
  String get tipoScadenzaFormDialogGiorniPreavvisoHint;

  /// No description provided for @subappaltatoreFormDialogNewTitle.
  ///
  /// In it, this message translates to:
  /// **'Nuovo subappaltatore'**
  String get subappaltatoreFormDialogNewTitle;

  /// No description provided for @subappaltatoreFormDialogEditTitle.
  ///
  /// In it, this message translates to:
  /// **'Modifica subappaltatore'**
  String get subappaltatoreFormDialogEditTitle;

  /// No description provided for @subappaltatoreFormDialogCercaEsistenti.
  ///
  /// In it, this message translates to:
  /// **'Cerca tra i subappaltatori esistenti'**
  String get subappaltatoreFormDialogCercaEsistenti;

  /// No description provided for @subappaltatoreFormDialogSelezionaEsistenteInfo.
  ///
  /// In it, this message translates to:
  /// **'Seleziona un subappaltatore esistente oppure compila i campi qui sotto per crearne uno nuovo.'**
  String get subappaltatoreFormDialogSelezionaEsistenteInfo;

  /// No description provided for @subappaltatoreFormDialogAnagrafica.
  ///
  /// In it, this message translates to:
  /// **'Anagrafica'**
  String get subappaltatoreFormDialogAnagrafica;

  /// No description provided for @subappaltatoreFormDialogRagioneSocialeLabel.
  ///
  /// In it, this message translates to:
  /// **'Ragione sociale*'**
  String get subappaltatoreFormDialogRagioneSocialeLabel;

  /// No description provided for @subappaltatoreFormDialogPartitaIvaLabel.
  ///
  /// In it, this message translates to:
  /// **'Partita IVA*'**
  String get subappaltatoreFormDialogPartitaIvaLabel;

  /// No description provided for @subappaltatoreFormDialogTelefonoLabel.
  ///
  /// In it, this message translates to:
  /// **'Telefono'**
  String get subappaltatoreFormDialogTelefonoLabel;

  /// No description provided for @subappaltatoreFormDialogEmailLabel.
  ///
  /// In it, this message translates to:
  /// **'Email'**
  String get subappaltatoreFormDialogEmailLabel;

  /// No description provided for @subappaltatoreFormDialogEmailInvalida.
  ///
  /// In it, this message translates to:
  /// **'Inserisci email valida'**
  String get subappaltatoreFormDialogEmailInvalida;

  /// No description provided for @subappaltatoreFormDialogNoteHelper.
  ///
  /// In it, this message translates to:
  /// **'Mostrate nel riquadro \"Informazioni\" della pagina del subappaltatore'**
  String get subappaltatoreFormDialogNoteHelper;

  /// No description provided for @subappaltatoreFormDialogCantieriAssociati.
  ///
  /// In it, this message translates to:
  /// **'Cantieri associati'**
  String get subappaltatoreFormDialogCantieriAssociati;

  /// No description provided for @archivioCantieriScreenEliminareTuttiTitle.
  ///
  /// In it, this message translates to:
  /// **'Vuoi eliminare tutti i cantieri archiviati?'**
  String get archivioCantieriScreenEliminareTuttiTitle;

  /// No description provided for @archivioCantieriScreenEliminareTuttiMessage.
  ///
  /// In it, this message translates to:
  /// **'Azione non ripristinabile, presta attenzione.'**
  String get archivioCantieriScreenEliminareTuttiMessage;

  /// No description provided for @archivioCantieriScreenTitle.
  ///
  /// In it, this message translates to:
  /// **'Archivio cantieri'**
  String get archivioCantieriScreenTitle;

  /// No description provided for @archivioCantieriScreenEliminaCantieriArchiviatiTooltip.
  ///
  /// In it, this message translates to:
  /// **'Elimina cantieri archiviati'**
  String get archivioCantieriScreenEliminaCantieriArchiviatiTooltip;

  /// No description provided for @archivioCantieriScreenEliminaCantieriLabel.
  ///
  /// In it, this message translates to:
  /// **'Elimina cantieri'**
  String get archivioCantieriScreenEliminaCantieriLabel;

  /// No description provided for @archivioCantieriScreenNessunCantiereArchiviato.
  ///
  /// In it, this message translates to:
  /// **'Nessun cantiere archiviato.'**
  String get archivioCantieriScreenNessunCantiereArchiviato;

  /// No description provided for @archivioCantieriScreenCantieriConclusi.
  ///
  /// In it, this message translates to:
  /// **'Cantieri conclusi'**
  String get archivioCantieriScreenCantieriConclusi;

  /// No description provided for @archivioCantieriScreenCercaHint.
  ///
  /// In it, this message translates to:
  /// **'Cerca per nome, indirizzo o comune'**
  String get archivioCantieriScreenCercaHint;

  /// No description provided for @archivioCantieriScreenNessunCantiereConcluso.
  ///
  /// In it, this message translates to:
  /// **'Nessun cantiere concluso (tutti attivi).'**
  String get archivioCantieriScreenNessunCantiereConcluso;

  /// No description provided for @archivioCantieriScreenNessunCantiereTrovato.
  ///
  /// In it, this message translates to:
  /// **'Nessun cantiere concluso trovato per \"{query}\".'**
  String archivioCantieriScreenNessunCantiereTrovato(String query);

  /// No description provided for @archivioCantieriScreenEliminareCantiereTitle.
  ///
  /// In it, this message translates to:
  /// **'Eliminare cantiere?'**
  String get archivioCantieriScreenEliminareCantiereTitle;

  /// No description provided for @archivioCantieriScreenEliminareCantiereMessage.
  ///
  /// In it, this message translates to:
  /// **'Eliminare definitivamente il cantiere \"{nome}\"? L\'operazione non è reversibile.'**
  String archivioCantieriScreenEliminareCantiereMessage(String nome);

  /// No description provided for @scaffalaturaFormDialogNewTitle.
  ///
  /// In it, this message translates to:
  /// **'Nuova scaffalatura'**
  String get scaffalaturaFormDialogNewTitle;

  /// No description provided for @scaffalaturaFormDialogEditTitle.
  ///
  /// In it, this message translates to:
  /// **'Modifica scaffalatura'**
  String get scaffalaturaFormDialogEditTitle;

  /// No description provided for @scaffalaturaFormDialogIdInternoLabel.
  ///
  /// In it, this message translates to:
  /// **'ID interno*'**
  String get scaffalaturaFormDialogIdInternoLabel;

  /// No description provided for @scaffalaturaFormDialogInserireNumero.
  ///
  /// In it, this message translates to:
  /// **'Inserire un numero'**
  String get scaffalaturaFormDialogInserireNumero;

  /// No description provided for @scaffalaturaFormDialogVerifiche.
  ///
  /// In it, this message translates to:
  /// **'Verifiche'**
  String get scaffalaturaFormDialogVerifiche;

  /// No description provided for @scaffalaturaFormDialogDataUltimaVerifica.
  ///
  /// In it, this message translates to:
  /// **'Data ultima verifica'**
  String get scaffalaturaFormDialogDataUltimaVerifica;

  /// No description provided for @scaffalaturaFormDialogEsitoPositivo.
  ///
  /// In it, this message translates to:
  /// **'Esito POSITIVO?'**
  String get scaffalaturaFormDialogEsitoPositivo;

  /// No description provided for @scaffalaturaFormDialogDataProssimaVerifica.
  ///
  /// In it, this message translates to:
  /// **'Data prossima verifica'**
  String get scaffalaturaFormDialogDataProssimaVerifica;

  /// No description provided for @infoDialogNoteScadenzaTitle.
  ///
  /// In it, this message translates to:
  /// **'Informazioni per le note scadenza'**
  String get infoDialogNoteScadenzaTitle;

  /// No description provided for @infoDialogNoteScadenzaIntro.
  ///
  /// In it, this message translates to:
  /// **'Inserendo la parola '**
  String get infoDialogNoteScadenzaIntro;

  /// No description provided for @infoDialogNoteScadenzaOr.
  ///
  /// In it, this message translates to:
  /// **' oppure '**
  String get infoDialogNoteScadenzaOr;

  /// No description provided for @infoDialogNoteScadenzaOutro.
  ///
  /// In it, this message translates to:
  /// **' all\'interno della nota di scadenza,\nl\'auto invio dell\'email per tale scadenza verrà bloccato.'**
  String get infoDialogNoteScadenzaOutro;

  /// No description provided for @infoDialogEmailScadenzaTitle.
  ///
  /// In it, this message translates to:
  /// **'Informazioni per l\'invio delle email scadenze'**
  String get infoDialogEmailScadenzaTitle;

  /// No description provided for @infoDialogEmailScadenzaIntro.
  ///
  /// In it, this message translates to:
  /// **'Le email delle scadenze di '**
  String get infoDialogEmailScadenzaIntro;

  /// No description provided for @infoDialogEmailScadenzaMiddle.
  ///
  /// In it, this message translates to:
  /// **' vengono gestite dalla pagina '**
  String get infoDialogEmailScadenzaMiddle;

  /// No description provided for @infoDialogEmailScadenzaPageName.
  ///
  /// In it, this message translates to:
  /// **'Amministrazione - Scadenze generali'**
  String get infoDialogEmailScadenzaPageName;

  /// No description provided for @infoDialogEmailScadenzaOutro.
  ///
  /// In it, this message translates to:
  /// **'.\nModificare quindi da lì la scadenza quando viene effettuato il controllo.'**
  String get infoDialogEmailScadenzaOutro;

  /// No description provided for @notaAutomezzoDialogTitle.
  ///
  /// In it, this message translates to:
  /// **'Nota — {nome} — {tipo}'**
  String notaAutomezzoDialogTitle(String nome, String tipo);

  /// No description provided for @pagina404ScreenTitle.
  ///
  /// In it, this message translates to:
  /// **'Errore 404'**
  String get pagina404ScreenTitle;

  /// No description provided for @pagina404ScreenMessage.
  ///
  /// In it, this message translates to:
  /// **'Ops! Sembra che tu ti sia perso.\nLa pagina che cerchi non esiste o è stata spostata.'**
  String get pagina404ScreenMessage;

  /// No description provided for @pagina404ScreenTornaHome.
  ///
  /// In it, this message translates to:
  /// **'Torna alla Home'**
  String get pagina404ScreenTornaHome;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'it'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'it':
      return AppLocalizationsIt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
