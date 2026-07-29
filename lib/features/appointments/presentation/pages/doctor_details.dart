import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../widgets/doctor_summary_card.dart';

class DoctorDetailsPage extends StatelessWidget {
  final String doctorId;
  final String doctorName;
  final String doctorSpecialty;
  final String doctorImageUrl;
  final String patientId;
  final List<String> services;

  const DoctorDetailsPage({
    super.key,
    required this.doctorId,
    required this.doctorName,
    required this.doctorSpecialty,
    required this.doctorImageUrl,
    required this.patientId,
    this.services = const [
      'Patient care should be the number one priority.',
      'Focused mainly on children with early signs of ASD',
      'That\'s why you matter to us',
    ],
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Doctor Details')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DoctorSummaryCard(
              name: doctorName,
              specialty: doctorSpecialty,
              imageUrl: doctorImageUrl,
              showBookButton: true,
              onBookNow: () {
                Navigator.of(context).pushNamed(
                  AppRoutes.appointmentFor,
                  arguments: {
                    'doctorId': doctorId,
                    'doctorName': doctorName,
                    'doctorSpecialty': doctorSpecialty,
                    'doctorImageUrl': doctorImageUrl,
                    'patientId': patientId,
                  },
                );
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: const [
                Expanded(
                  child: _StatPill(value: '100', label: 'Running'),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: _StatPill(value: '500', label: 'Ongoing'),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: _StatPill(value: '700', label: 'Patient'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'Services',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            ...services.asMap().entries.map(
              (entry) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${entry.key + 1}.  ',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Expanded(child: Text(entry.value)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            // TODO: swap for a real map once a maps package and clinic location data exist
            Container(
              height: 160,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(20),
              ),
              alignment: Alignment.center,
              child: const Icon(
                Icons.map_outlined,
                color: AppColors.primary,
                size: 40,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  final String value;
  final String label;
  const _StatPill({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE3E6E5)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
