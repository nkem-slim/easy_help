import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/navigation/main_tab_controller.dart';
import '../../../../core/widgets/clinic_card.dart';

class ScreeningClinicSection extends StatelessWidget {
  const ScreeningClinicSection({super.key});

  // TODO(screening-data-layer): replace with ClinicRepository.getNearby(...)
  // once a ClinicRepository backed by FirestoreCollections.clinics exists.
  List<ClinicCard> _stubNearbyClinics(BuildContext context) {
    void openFindClinic() =>
        Navigator.of(context).pushNamed(AppRoutes.findClinic);

    // TODO: this only switches to the Appointments tab — swap for a real
    // "book with this clinic" flow once clinics carry doctor/booking data.
    void goToAppointmentsTab() {
      MainTabController.index.value = MainTabController.appointments;
      Navigator.of(context).popUntil((route) => route.isFirst);
    }

    return [
      ClinicCard(
        name: 'King Faisal Hospital',
        subtitle: 'Specialized Pediatric Development Wing',
        imageAsset: '',
        rating: 4.9,
        distanceLabel: '1.2 km away',
        isVerified: true,
        isOpenNow: true,
        onTap: openFindClinic,
        onBookAppointment: goToAppointmentsTab,
      ),
      ClinicCard(
        name: 'CARAES Ndera',
        subtitle: 'Child & Adolescent Mental Health Unit',
        imageAsset: '',
        rating: 4.6,
        distanceLabel: '3.8 km away',
        isVerified: true,
        isOpenNow: false,
        onTap: openFindClinic,
        onBookAppointment: goToAppointmentsTab,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Visit a Recommended Clinic',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Schedule an assessment with our verified partners '
                'specializing in pediatric development.',
                style: TextStyle(color: Colors.white70, fontSize: 12.5),
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    // TODO: this navigates to the support feature's clinic
                    // list; swap for a dedicated "all partners" filter once
                    // that distinction exists.
                    Navigator.of(context).pushNamed(AppRoutes.findClinic);
                  },
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.primary,
                    side: BorderSide.none,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: const Text(
                    'View All Partners',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Nearby Clinics',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              for (final clinic in _stubNearbyClinics(context)) ...[
                clinic,
                const SizedBox(height: 12),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
