import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'app_router.dart';
import 'l10n/app_localizations.dart';
import 'providers/auth_provider.dart';
import 'providers/locale_provider.dart';
import 'providers/articoli_cassette_ps_provider.dart';
import 'providers/articoli_standard_cassette_ps_provider.dart';
import 'providers/automezzi_provider.dart';
import 'providers/cantieri_provider.dart';
import 'providers/cassette_ps_provider.dart';
import 'providers/dipendenti_aziendali_provider.dart';
import 'providers/dipendenti_subappaltatori_provider.dart';
import 'providers/documenti_provider.dart';
import 'providers/dpi_assegnati_provider.dart';
import 'providers/estintori_provider.dart';
import 'providers/impostazioni_provider.dart';
import 'providers/macchinari_provider.dart';
import 'providers/regole_dpi_mansione_provider.dart';
import 'providers/subappaltatori_provider.dart';
import 'providers/tipi_scadenze_provider.dart';
import 'providers/tipi_dpi_provider.dart';
import 'providers/scadenze_generali_provider.dart';
import 'providers/impianti_provider.dart';
import 'providers/rifiuti_provider.dart';
import 'providers/misure_provider.dart';
import 'providers/segnali_provider.dart';
import 'providers/scale_provider.dart';
import 'providers/scaffalature_provider.dart';
import 'providers/fasce_catene_provider.dart';
import 'providers/benne_provider.dart';
import 'providers/controlli_segnali_provider.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final _authProvider = AuthProvider();
  final _localeProvider = LocaleProvider();
  late final _router = buildRouter(_authProvider);

  bool _sessionRestored = false;

  @override
  void initState() {
    super.initState();
    _authProvider.restoreSession().then((_) {
      if (mounted) setState(() => _sessionRestored = true);
    });
    _localeProvider.loadSaved();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: _authProvider),
        ChangeNotifierProvider.value(value: _localeProvider),
        ChangeNotifierProvider(create: (_) => CantieriProvider()),
        ChangeNotifierProvider(create: (_) => SubappaltatoriProvider()),
        ChangeNotifierProvider(create: (_) => TipiScadenzeProvider()),
        ChangeNotifierProvider(create: (_) => DocumentiProvider()),
        ChangeNotifierProvider(create: (_) => DipendentiSubappaltatoriProvider()),
        ChangeNotifierProvider(create: (_) => DipendentiAziendaliProvider()),
        ChangeNotifierProvider(create: (_) => AutomezziProvider()),
        ChangeNotifierProvider(create: (_) => MacchinariProvider()),
        ChangeNotifierProvider(create: (_) => EstintoriProvider()),
        ChangeNotifierProvider(create: (_) => CassettePsProvider()),
        ChangeNotifierProvider(create: (_) => ArticoliCassettePsProvider()),
        ChangeNotifierProvider(create: (_) => ArticoliStandardCassettePsProvider()),
        ChangeNotifierProvider(create: (_) => ScadenzeGeneraliProvider()),
        ChangeNotifierProvider(create: (_) => ImpiantiProvider()),
        ChangeNotifierProvider(create: (_) => TipiDpiProvider()),
        ChangeNotifierProvider(create: (_) => DpiAssegnatiProvider()),
        ChangeNotifierProvider(create: (_) => RegoleDpiMansioneProvider()),
        ChangeNotifierProvider(create: (_) => RifiutiProvider()),
        ChangeNotifierProvider(create: (_) => MisureProvider()),
        ChangeNotifierProvider(create: (_) => SegnaliProvider()),
        ChangeNotifierProvider(create: (_) => ControlliSegnaliProvider()),
        ChangeNotifierProvider(create: (_) => ImpostazioniProvider()),
        ChangeNotifierProvider(create: (_) => ScaleProvider()),
        ChangeNotifierProvider(create: (_) => ScaffalatureProvider()),
        ChangeNotifierProvider(create: (_) => FasceCateneProvider()),
        ChangeNotifierProvider(create: (_) => BenneProvider()),
      ],
      child: Consumer<LocaleProvider>(
        builder: (context, localeProvider, _) => MaterialApp.router(
          title: 'Demo Scadenziario',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF0164B1),
              primary: const Color(0xFF0164B1),
              surface: Colors.white,
            ),
            scaffoldBackgroundColor: Colors.white,
            textTheme: GoogleFonts.dmSansTextTheme(),
            useMaterial3: true,
          ),
          routerConfig: _router,
          debugShowCheckedModeBanner: false,
          locale: localeProvider.locale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          // Un MaterialApp separato qui (senza routerConfig) creerebbe un
          // secondo Navigator che sovrascrive l'hash dell'URL al primo frame,
          // perdendo eventuali deep link (es. /accesso/:qrToken) prima ancora
          // che go_router li legga. Si mostra invece lo spinner sopra lo
          // stesso router, senza mai sostituire l'intera app.
          builder: (context, child) {
            if (!_sessionRestored) {
              return const Scaffold(
                backgroundColor: Colors.white,
                body: Center(child: CircularProgressIndicator()),
              );
            }
            return child!;
          },
        ),
      ),
    );
  }
}
