import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';

import 'core/constants/app_strings.dart';
import 'core/di/injection_container.dart' as di;
import 'core/maps/maps_bootstrap.dart';
import 'core/routes/app_router.dart';
import 'core/theme/app_theme.dart';
import 'firebase_options.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/appointments/presentation/bloc/appointment_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');
  injectGoogleMapsScript(dotenv.env['GOOGLE_MAPS_API_KEY'] ?? '');
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await di.initDependencies();

  final authBloc = di.sl<AuthBloc>();

  runApp(EasyHelpApp(authBloc: authBloc));
}

class EasyHelpApp extends StatelessWidget {
  final AuthBloc authBloc;
  const EasyHelpApp({super.key, required this.authBloc});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>.value(value: authBloc),
        BlocProvider<AppointmentBloc>(create: (_) => di.sl<AppointmentBloc>()),
      ],
      child: MaterialApp(
        title: 'Easy Help',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        initialRoute: AppRoutes.splash,
        onGenerateRoute: AppRouter(authBloc: authBloc).onGenerateRoute,
      ),
    );
  }
}
