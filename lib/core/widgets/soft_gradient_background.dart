import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

/// Full-page background: pale blue in the top-left corner, white through the
/// middle, pale green in the bottom-right.
///
/// Meant to sit at the bottom of a [Stack] under the page content.
class SoftGradientBackground extends StatelessWidget {
  const SoftGradientBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.tintBlue,
            Colors.white,
            Colors.white,
            AppColors.tintGreen,
          ],
          stops: [0.0, 0.3, 0.65, 1.0],
        ),
      ),
      child: SizedBox.expand(),
    );
  }
}
