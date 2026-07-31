class AppRoutes {
  AppRoutes._();

  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String signup = '/signup';

  static const String home = '/home';
  static const String profile = '/profile';
  static const String aboutUs = '/about-us';
  static const String changePassword = '/change-password';

  static const String bookAppointment = '/book-appointment';
  static const String appointmentConfirmation = '/appointment-confirmation';
  static const String doctorDetails = '/doctor-details';
  static const String appointmentFor = '/appointment-for';

  static const String learn = '/learn';
  static const String communicate = '/communicate';
  static const String journal = '/journal';
  static const String screening = '/screening';
  static const String screeningTakeTest = '/screening/take-test';
  static const String screeningResult = '/screening-result';
  static const String support = '/support';
  static const String findClinic = '/find-clinic';
  static const String settings = '/settings';
  static const String privacyPolicy = '/privacy-policy';
  static const String userDetails = '/user-details';
}

class FirestoreCollections {
  FirestoreCollections._();

  static const String users = 'users';
  static const String children = 'children';
  static const String screenings = 'screenings';
  static const String journalEntries = 'journal_entries';
  static const String appointments = 'appointments';
  static const String clinics = 'clinics';
  static const String resources = 'resources';
}
