import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

import '../../../appointments/presentation/pages/booked_appointments.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../favorites/presentation/pages/favorites_page.dart';
import '../../../profile/presentation/pages/profile_page.dart';
import 'home_page.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final authState = context.watch<AuthBloc>().state;
    final patientId = authState is AuthAuthenticated ? authState.user.id : '';

    final pages = [
      const HomePage(),
      const FavouriteClinicsPage(),
      BookedAppointmentsPage(patientId: patientId),
      const ProfilePage(),
    ];

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: pages),
      bottomNavigationBar: StylishBottomBar(
        option: BubbleBarOptions(
          bubbleFillStyle: BubbleFillStyle.fill,
          barStyle: BubbleBarStyle.vertical,
          opacity: 0.15,
        ),
        items: [
          BottomBarItem(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home_rounded),
            backgroundColor: primary,
            title: const Text('Home'),
          ),
          BottomBarItem(
            icon: const Icon(Icons.favorite_outline_rounded),
            selectedIcon: const Icon(Icons.favorite_rounded),
            backgroundColor: primary,
            title: const Text('Favourites'),
          ),
          BottomBarItem(
            icon: const Icon(Icons.calendar_month_outlined),
            selectedIcon: const Icon(Icons.calendar_month_rounded),
            backgroundColor: primary,
            title: const Text('Appointments'),
          ),
          BottomBarItem(
            icon: const Icon(Icons.person_outline_rounded),
            selectedIcon: const Icon(Icons.person_rounded),
            backgroundColor: primary,
            title: const Text('Profile'),
          ),
        ],
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}
