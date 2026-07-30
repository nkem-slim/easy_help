import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/clinic_entity.dart';

class ClinicDetailsPage extends StatelessWidget {
  final ClinicEntity clinic;

  const ClinicDetailsPage({super.key, required this.clinic});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Clinic Details')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: clinic.logoBackgroundColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(clinic.logoIcon, color: Colors.white, size: 44),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                clinic.name,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            const SizedBox(height: 6),
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.location_on, size: 16, color: AppColors.primary),
                  const SizedBox(width: 4),
                  Text(
                    clinic.location,
                    style: const TextStyle(color: AppColors.primary, fontSize: 15),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            const Text(
              'About',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 8),
            Text(
              '${clinic.name} provides post-diagnosis autism support services, '
              'including screening, therapy, and caregiver guidance.',
              style: const TextStyle(color: AppColors.textSecondary, height: 1.5),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('Book Appointment'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
