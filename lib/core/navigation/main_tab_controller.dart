import 'package:flutter/foundation.dart';

/// Shared source of truth for which bottom-nav tab [MainShell] shows.
///
/// Screens pushed on top of [MainShell] (e.g. the screening result page)
/// need to land on a specific tab — like Appointments, after popping back,
/// not just whatever tab was active when they were opened. Setting this
/// value before popping lets them do that without MainShell needing to know
/// about its callers.
class MainTabController {
  MainTabController._();

  static const int home = 0;
  static const int favourites = 1;
  static const int appointments = 2;
  static const int profile = 3;

  static final ValueNotifier<int> index = ValueNotifier<int>(home);
}