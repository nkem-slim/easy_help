import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

class ScreeningTipCard extends StatelessWidget {
  const ScreeningTipCard({super.key});

  static const _tip =
      'Consistent daily routines help children feel secure and can make it '
      'easier to notice changes in their development over time.';

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.tintGreen,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.lightbulb_rounded, color: AppColors.primary, size: 18),
              SizedBox(width: 8),
              Text(
                'Did you know?',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            _tip,
            style: TextStyle(fontSize: 12.5, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () {
              // TODO: wire up a local notification reminder once the
              // reminders/notifications feature exists.
            },
            child: const Text(
              'Set a reminder',
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
