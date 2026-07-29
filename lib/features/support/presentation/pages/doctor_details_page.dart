import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../widgets/doctor_card.dart';
import '../widgets/doctor_details_card.dart';
import '../widgets/doctor_details_header.dart';
import '../widgets/doctor_location_map.dart';
import '../widgets/doctor_services_section.dart';
import '../widgets/doctor_stats_row.dart';

class DoctorDetailsPage extends StatelessWidget {
  final DoctorItem doctor;

  const DoctorDetailsPage({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            DoctorDetailsHeader(onSearchTap: () {}),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                children: [
                  DoctorDetailsCard(doctor: doctor),
                  const SizedBox(height: 16),
                  DoctorStatsRow(
                    runningCount: doctor.runningCount,
                    ongoingCount: doctor.ongoingCount,
                    patientCount: doctor.patientCount,
                  ),
                  const SizedBox(height: 20),
                  DoctorServicesSection(services: doctor.services),
                  const SizedBox(height: 20),
                  DoctorLocationMap(
                    clinicLat: doctor.clinicLat,
                    clinicLng: doctor.clinicLng,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
