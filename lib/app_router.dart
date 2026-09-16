import 'package:gestionale_edile/screens/macchinari_screen.dart';
import 'package:gestionale_edile/screens/scadenze_imminenti_screen.dart';
import 'package:gestionale_edile/screens/tipi_dpi_screen.dart';
import 'package:go_router/go_router.dart';

import 'providers/auth_provider.dart';
import 'screens/amministrazione_screen.dart';
import 'screens/archivio_cantieri_screen.dart';
import 'screens/articoli_standard_cassette_ps_screen.dart';
import 'screens/automezzi_screen.dart';
import 'screens/cantiere_detail_screen.dart';
import 'screens/cantieri_screen.dart';
import 'screens/dipendente_subappaltatore_detail_screen.dart';
import 'screens/estintori_screen.dart';
import 'screens/login_screen.dart';
import 'screens/primo_soccorso_screen.dart';
import 'screens/subappaltatore_detail_screen.dart';
import 'screens/subappaltatore_documenti_screen.dart';
import 'screens/subappaltatori_screen.dart';
import 'screens/tipi_scadenze_screen.dart';
import 'screens/dpi_screen.dart';
import 'screens/misure_screen.dart';
import 'screens/impianti_screen.dart';
import 'screens/scaffalature_screen.dart';
import 'screens/scale_screen.dart';
import 'screens/fasce_catene_screen.dart';
import 'screens/rifiuti_screen.dart';
import 'screens/pagina404_screen.dart';
import 'screens/segnaletica_sicurezza_screen.dart';
import 'widgets/dati_cantieri_caricati.dart';

GoRouter buildRouter(AuthProvider authProvider) {
  return GoRouter(
    initialLocation: '/',
    errorBuilder: ((context, state) => const Pagina404()),
    refreshListenable: authProvider,
    redirect: (context, state) {
      final isLoggingIn = state.matchedLocation == '/login';
      if (!authProvider.isAuthenticated) {
        return isLoggingIn ? null : '/login';
      }
      if (isLoggingIn) return '/';
      return null;
    },
    routes: [
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(path: '/', builder: (context, state) => const ScadenzeImminentiScreen()),
      GoRoute(path: '/cantieri', builder: (context, state) => const CantieriScreen()),
      GoRoute(
        path: '/tipi-scadenze',
        builder: (context, state) => const TipiScadenzeScreen(),
      ),
      GoRoute(
        path: '/archivio-cantieri',
        builder: (context, state) => const ArchivioCantieriScreen(),
      ),
      GoRoute(
        path: '/subappaltatori',
        builder: (context, state) => const SubappaltatoriScreen(),
        routes: [
          GoRoute(
            path: ':subappaltatoreId',
            builder: (context, state) => DatiCantieriCaricati(
              child: SubappaltatoreDocumentiScreen(
                subappaltatoreId: state.pathParameters['subappaltatoreId']!,
              ),
            ),
            routes: [
              GoRoute(
                path: 'dipendenti/:dipendenteId',
                builder: (context, state) => DatiCantieriCaricati(
                  child: DipendenteSubappaltatoreDetailScreen(
                    subappaltatoreId: state.pathParameters['subappaltatoreId']!,
                    dipendenteId: state.pathParameters['dipendenteId']!,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/cantieri/:cantiereId',
        builder: (context, state) => DatiCantieriCaricati(
          child: CantiereDetailScreen(
            cantiereId: state.pathParameters['cantiereId']!,
          ),
        ),
        routes: [
          GoRoute(
            path: 'subappaltatori/:subappaltatoreId',
            builder: (context, state) => DatiCantieriCaricati(
              child: SubappaltatoreDetailScreen(
                cantiereId: state.pathParameters['cantiereId']!,
                subappaltatoreId: state.pathParameters['subappaltatoreId']!,
              ),
            ),
          ),
        ],
      ),
      GoRoute(
        path: '/macchinari',
        builder: (context, state) => const MacchinariScreen(),
      ),
      GoRoute(
        path: '/automezzi',
        builder: (context, state) => const AutomezziScreen(),
      ),
      GoRoute(
        path: '/estintori',
        builder: (context, state) => const EstintoriScreen(),
      ),
      GoRoute(
        path: '/amministrazione',
        builder: (context, state) => const AmministrazioneScreen(),
      ),
      GoRoute(
        path: '/primo-soccorso',
        builder: (context, state) => const PrimoSoccorsoScreen(),
        routes: [
          GoRoute(
            path: '/prodotti-standard',
            builder: (context, state) => const ArticoliStandardCassettePsScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/dpi',
        builder: (context, state) => const DpiScreen(),
        routes: [
          GoRoute(
            path: '/tipi-dpi',
            builder: (context, state) => const TipiDpiScreen(),
          )
        ]
      ),
      GoRoute(
        path: '/impianti',
        builder: (context, state) => const ImpiantiScreen(),
      ),
      GoRoute(
        path: '/misure',
        builder: (context, state) => const MisureScreen(),
      ),
      GoRoute(
        path: '/segnaletica-sicurezza',
        builder: (context, state) => const SegnaleticaSicurezzaScreen(),
      ),
      GoRoute(
        path: '/rifiuti',
        builder: (context, state) => const RifiutiScreen(),
      ),
      GoRoute(
        path: '/scale',
        builder: (context, state) => const ScaleScreen(),
      ),
      GoRoute(
        path: '/fasce-catene',
        builder: (context, state) => const FasceCateneScreen(),
      ),
      GoRoute(
        path: '/scaffalature',
        builder: (context, state) => const ScaffalatureScreen(),
      ),
    ],
  );
}
