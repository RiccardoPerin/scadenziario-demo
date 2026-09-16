import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _prefsKey = 'app_locale';

/// Lingua corrente dell'app (italiano di default), persistita tra le sessioni.
///
/// Espone [current] in modo statico così che codice senza [BuildContext]
/// (es. i provider dei dati, per i messaggi d'errore) possa comunque
/// localizzare tramite `lookupAppLocalizations(LocaleProvider.current)`.
class LocaleProvider extends ChangeNotifier {
  static Locale current = const Locale('it');

  Locale _locale = const Locale('it');
  Locale get locale => _locale;

  Future<void> loadSaved() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_prefsKey);
    if (saved == 'en' || saved == 'it') {
      _locale = Locale(saved!);
      current = _locale;
      notifyListeners();
    }
  }

  Future<void> setLocale(Locale locale) async {
    if (_locale == locale) return;
    _locale = locale;
    current = locale;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, locale.languageCode);
  }

  Future<void> toggle() =>
      setLocale(_locale.languageCode == 'it' ? const Locale('en') : const Locale('it'));
}
