import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../widgets/doctor_card.dart';
import '../widgets/find_clinic_header.dart';
import '../widgets/find_clinic_search_bar.dart';
import 'doctor_details_page.dart';

class FindClinicPage extends StatefulWidget {
  const FindClinicPage({super.key});

  @override
  State<FindClinicPage> createState() => _FindClinicPageState();
}

class _FindClinicPageState extends State<FindClinicPage> {
  final _searchController = TextEditingController(text: '');
  String _query = 'Kigali';

  static const _doctors = [
    DoctorItem(
      name: 'Dr. Nshunti',
      specialty: 'ADS Specialist',
      experience: '7 Years experience',
      ratingPercent: '87%',
      patientStories: '69 Patient Stories',
      clinicName: 'Legacy Clinic',
      availability: '24/7 Availability',
      location: 'Kigali',
      imageAsset: 'assets/images/clinic-0.png',
      isFavorite: true,
    ),
    DoctorItem(
      name: 'Dr. Nshunti',
      specialty: 'ADS Specialist',
      experience: '7 Years experience',
      ratingPercent: '87%',
      patientStories: '69 Patient Stories',
      clinicName: 'Legacy Clinic',
      availability: '24/7 Availability',
      location: 'Kigali',
      imageAsset: 'assets/images/clinic-0.png',
      isFavorite: true,
    ),
    DoctorItem(
      name: 'Dr. Nshunti',
      specialty: 'ADS Specialist',
      experience: '7 Years experience',
      ratingPercent: '87%',
      patientStories: '69 Patient Stories',
      clinicName: 'Legacy Clinic',
      availability: '24/7 Availability',
      location: 'Kigali',
      imageAsset: 'assets/images/clinic-0.png',
      isFavorite: true,
    ),
  ];

  List<DoctorItem> get _filteredDoctors {
    final query = _query.trim().toLowerCase();
    if (query.isEmpty) return _doctors;
    return _doctors.where((doctor) {
      return doctor.name.toLowerCase().contains(query) ||
          doctor.specialty.toLowerCase().contains(query) ||
          doctor.clinicName.toLowerCase().contains(query) ||
          doctor.location.toLowerCase().contains(query);
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const FindClinicHeader(),
            FindClinicSearchBar(
              controller: _searchController,
              onChanged: (value) => setState(() => _query = value),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                itemCount: _filteredDoctors.length,
                separatorBuilder: (_, __) => const SizedBox(height: 14),
                itemBuilder: (context, index) {
                  final doctor = _filteredDoctors[index];
                  void openDetails() {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => DoctorDetailsPage(doctor: doctor),
                      ),
                    );
                  }

                  return DoctorCard(
                    item: doctor,
                    onTap: openDetails,
                    onBookNow: openDetails,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
