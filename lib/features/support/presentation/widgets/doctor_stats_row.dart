import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

class DoctorStatsRow extends StatelessWidget {
  final int runningCount;
  final int ongoingCount;
  final int patientCount;

  const DoctorStatsRow({
    super.key,
    required this.runningCount,
    required this.ongoingCount,
    required this.patientCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatTile(value: runningCount, label: 'Running'),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatTile(value: ongoingCount, label: 'Ongoing'),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatTile(value: patientCount, label: 'Patient'),
        ),
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  final int value;
  final String label;

  const _StatTile({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            '$value',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
