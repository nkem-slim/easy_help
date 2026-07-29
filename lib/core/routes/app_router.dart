import 'package:flutter/material.dart';
import '../constants/app_strings.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/onboarding_page.dart';
import '../../features/auth/presentation/pages/signup_page.dart';
import '../../features/auth/presentation/pages/splash_page.dart';
import '../../features/home/presentation/pages/main_shell.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/profile/presentation/pages/privacy_policy_page.dart';
import '../../features/appointments/presentation/pages/appointment_confirmation.dart';
import '../../features/appointments/presentation/pages/book_appointment.dart';
import '../../features/appointments/domain/entities/appointment_entity.dart';
import '../../features/appointments/presentation/pages/appointment_for.dart';
import '../../features/support/presentation/pages/doctor_details_page.dart';
import '../../features/support/presentation/pages/find_clinic_page.dart';
import '../../features/support/presentation/widgets/doctor_card.dart';

class AppRouter {
  AppRouter._();

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
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
        return MaterialPageRoute(builder: (_) => const MainShell());
      case AppRoutes.profile:
        return MaterialPageRoute(builder: (_) => const ProfilePage());
      case AppRoutes.privacyPolicy:
        return MaterialPageRoute(builder: (_) => const PrivacyPolicyPage());

      case AppRoutes.doctorDetails:
        final args = settings.arguments as Map<String, String>;
        return MaterialPageRoute(
          builder: (routeContext) => DoctorDetailsPage(
            doctor: DoctorItem(
              name: args['doctorName']!,
              specialty: args['doctorSpecialty']!,
              experience: '5+ Years experience',
              ratingPercent: '90%',
              patientStories: '50 Patient Stories',
              clinicName: 'Easy Help Clinic',
              availability: 'By Appointment',
              location: 'Kigali',
              imageAsset: 'assets/images/clinic-1.jpg',
            ),
            onBookNow: () => Navigator.of(routeContext).pushNamed(
              AppRoutes.appointmentFor,
              arguments: args,
            ),
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
      case AppRoutes.findClinic:
        return MaterialPageRoute(builder: (_) => const FindClinicPage());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
