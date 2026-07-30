import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

class ScreeningNextStepBanner extends StatelessWidget {
  final String nextStep;

  const ScreeningNextStepBanner({super.key, required this.nextStep});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.tintGreen,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_rounded, color: AppColors.primary, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 12.5, color: AppColors.textPrimary),
                children: [
                  const TextSpan(
                    text: 'Next suggested step: ',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  TextSpan(text: nextStep),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
