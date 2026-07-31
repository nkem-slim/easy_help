import 'package:flutter/material.dart';
import '../constants/app_strings.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/onboarding_page.dart';
import '../../features/auth/presentation/pages/signup_page.dart';
import '../../features/auth/presentation/pages/splash_page.dart';
import '../../features/home/presentation/pages/main_shell.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/profile/presentation/pages/user_details_page.dart';
import '../../features/profile/presentation/pages/about_us_page.dart';
import '../../features/profile/presentation/pages/privacy_policy_page.dart';
import '../../features/profile/presentation/pages/change_password_page.dart';
import '../../features/appointments/presentation/pages/appointment_confirmation.dart';
import '../../features/appointments/presentation/pages/appointment_details_page.dart';
import '../../features/appointments/presentation/pages/book_appointment.dart';
import '../../features/appointments/domain/entities/appointment_entity.dart';
import '../../features/appointments/presentation/pages/appointment_for.dart';
import '../../features/support/presentation/pages/doctor_details_page.dart';
import '../../features/support/presentation/pages/find_clinic_page.dart';
import '../../features/support/presentation/widgets/doctor_card.dart';
import '../../features/journal/presentation/pages/journal_page.dart';
import '../../features/screening/domain/entities/screening_result.dart';
import '../../features/screening/presentation/pages/screening_result_page.dart';
import '../../features/screening/presentation/pages/take_test_page.dart';

class AppRouter {
  final AuthBloc authBloc;
  AppRouter({required this.authBloc});

  Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(builder: (_) => const SplashPage());
      case AppRoutes.onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingPage());
      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case AppRoutes.signup:
        return MaterialPageRoute(builder: (_) => const SignupPage());
      case AppRoutes.home:
        final isAuthenticated = authBloc.state is AuthAuthenticated;
        if (!isAuthenticated) {
          return MaterialPageRoute(builder: (_) => const LoginPage());
        }
        return MaterialPageRoute(builder: (_) => const MainShell());
      case AppRoutes.profile:
        return MaterialPageRoute(builder: (_) => const ProfilePage());
      case AppRoutes.privacyPolicy:
        return MaterialPageRoute(builder: (_) => const PrivacyPolicyPage());
      case AppRoutes.userDetails:
        return MaterialPageRoute(builder: (_) => const UserDetailsPage());

      case AppRoutes.doctorDetails:
        final args = settings.arguments as Map<String, String>;
        return MaterialPageRoute(
          builder: (routeContext) => DoctorDetailsPage(
            // Same mock doctor as FindClinicPage, so this route and the push
            // from the doctor list show identical details.
            doctor: mockDrNshunti,
            onBookNow: () => Navigator.of(
              routeContext,
            ).pushNamed(AppRoutes.appointmentFor, arguments: args),
          ),
        );

      case AppRoutes.appointmentFor:
        final args = settings.arguments as Map<String, String>;
        return MaterialPageRoute(
          builder: (_) => AppointmentForPage(
            doctorId: args['doctorId']!,
            doctorName: args['doctorName']!,
            doctorSpecialty: args['doctorSpecialty']!,
            doctorImageUrl: args['doctorImageUrl']!,
            patientId: args['patientId']!,
          ),
        );

      case AppRoutes.bookAppointment:
        final args = settings.arguments as Map<String, String>;
        return MaterialPageRoute(
          builder: (_) => BookAppointmentPage(
            doctorId: args['doctorId']!,
            doctorName: args['doctorName']!,
            doctorSpecialty: args['doctorSpecialty']!,
            doctorImageUrl: args['doctorImageUrl']!,
            patientId: args['patientId']!,
            patientName: args['patientName']!,
            contactNumber: args['contactNumber']!,
            relationship: args['relationship']!,
          ),
        );

      case AppRoutes.appointmentConfirmation:
        final appointment = settings.arguments as AppointmentEntity;
        return MaterialPageRoute(
          builder: (_) => AppointmentConfirmationPage(appointment: appointment),
        );
      case AppRoutes.appointmentDetails:
        final appointment = settings.arguments as AppointmentEntity;
        return MaterialPageRoute(
          builder: (_) => AppointmentDetailsPage(appointment: appointment),
        );
      case AppRoutes.findClinic:
        return MaterialPageRoute(builder: (_) => const FindClinicPage());
      case AppRoutes.journal:
        return MaterialPageRoute(builder: (_) => const JournalPage());
      case AppRoutes.screeningTakeTest:
        return MaterialPageRoute(builder: (_) => const TakeTestPage());
      case AppRoutes.screeningResult:
        final result = settings.arguments as ScreeningResult;
        return MaterialPageRoute(
          builder: (_) => ScreeningResultPage(result: result),
        );
      case AppRoutes.changePassword:
        return MaterialPageRoute(builder: (_) => const ChangePasswordPage());
      case AppRoutes.aboutUs:
        return MaterialPageRoute(builder: (_) => const AboutUsPage());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
