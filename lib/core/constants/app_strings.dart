class AppRoutes {
  AppRoutes._();

  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String signup = '/signup';

  static const String home = '/home';

  static const String learn = '/learn';
  static const String communicate = '/communicate';
  static const String journal = '/journal';
  static const String screening = '/screening';
  static const String support = '/support';
  static const String settings = '/settings';
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
