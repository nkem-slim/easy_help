import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

class DoctorServicesSection extends StatelessWidget {
  final List<String> services;

  const DoctorServicesSection({super.key, required this.services});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Services',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        for (var i = 0; i < services.length; i++) ...[
          _ServiceItem(number: i + 1, text: services[i]),
          if (i != services.length - 1) const SizedBox(height: 10),
        ],
      ],
    );
  }
}

class _ServiceItem extends StatelessWidget {
  final int number;
  final String text;

  const _ServiceItem({required this.number, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$number.',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.primary,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}
