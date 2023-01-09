import 'package:flutter/material.dart';
import 'package:sumarte/src/routes/routes.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'src/bloc/auth/auth_bloc.dart';
import 'src/bloc/map/map_bloc.dart';
import 'src/bloc/register/register_bloc.dart';
import 'src/bloc/search/search_bloc.dart';
import 'src/helpers/helpers.dart';
import 'src/pages/login_page.dart';
import 'src/services/auth_service.dart';
import 'src/share_prefs/preferences_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await initializeDateFormatting('es_PR', null);
  await dotenv.load(fileName: "config.conf");
  final prefs = new PreferenceStorage();
  await prefs.initPrefs();

  runApp(
    RepositoryProvider<AuthenticationService>(
      create: (context) {
        return AuthenticationService();
      },
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (_) => AuthBloc(
                initialState: AuthState(uninitialized: true),
                authService: AuthenticationService())
              ..add(AppStarted())),
        BlocProvider(
            create: (_) => RegisterBloc(
                initialState: RegisterState(registrado: false),
                authService: AuthenticationService())),
        BlocProvider(
            create: (_) => MapBloc(
                initialState: MapState(
                    existeUbicacion: false, scrollGesturesEnabled: true))),
        BlocProvider(create: (_) => SearchBloc(initialState: SearchState()))
      ],
      child: MaterialApp(
        theme: Constants.lighTheme(context),
        debugShowCheckedModeBanner: false,
        title: Constants.appName,
        initialRoute: LoginPage.routeName,
        routes: getApplicationsRoutes(),
      ),
    );
  }
}
