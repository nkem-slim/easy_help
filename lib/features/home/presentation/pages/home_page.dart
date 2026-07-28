import 'package:flutter/material.dart';

import '../widgets/home_action_cards.dart';
import '../widgets/home_clinics_section.dart';
import '../widgets/home_header.dart';
import '../widgets/home_search_bar.dart';
import '../widgets/home_videos_section.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: _HomeBody(),
    );
  }
}

class _HomeBody extends StatelessWidget {
  const _HomeBody();

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HomeHeader(userName: 'Uwineza'),
          HomeSearchBar(),
          HomeVideosSection(),
          HomeActionCards(),
          HomeClinicsSection(),
          SizedBox(height: 24),
        ],
      ),
    );
  }
}
