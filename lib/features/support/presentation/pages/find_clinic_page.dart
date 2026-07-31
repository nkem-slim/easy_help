import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../clinics/data/mock_clinics.dart';
import '../../../clinics/presentation/pages/clinic_details_page.dart';
import '../widgets/doctor_card.dart';
import '../widgets/find_clinic_header.dart';
import '../widgets/find_clinic_search_bar.dart';

/// Maps a clinic onto the doctor card's fields, so the Find a Clinic page
/// keeps its existing card design without duplicating that layout.
DoctorItem _asCardItem(ClinicItem clinic) {
  return DoctorItem(
    name: clinic.name,
    specialty: clinic.subtitle,
    experience: clinic.distanceLabel,
    ratingPercent: '${(clinic.rating * 20).round()}%',
    patientStories: clinic.isOpenNow ? 'Open now' : 'Closed now',
    clinicName: clinic.location,
    availability: clinic.isVerified ? 'Verified partner' : 'Community clinic',
    location: clinic.location,
    imageAsset: clinic.imageAsset,
  );
}

class FindClinicPage extends StatefulWidget {
  const FindClinicPage({super.key});

  @override
  State<FindClinicPage> createState() => _FindClinicPageState();
}

class _FindClinicPageState extends State<FindClinicPage> {
  final _searchController = TextEditingController(text: '');
  String _query = 'Kigali';

  static const _maxClinics = 6;
  static const _clinics = mockClinics;

  List<ClinicItem> get _filteredClinics {
    final query = _query.trim().toLowerCase();
    final source = _clinics.take(_maxClinics);
    if (query.isEmpty) return source.toList();
    return source.where((clinic) {
      return clinic.name.toLowerCase().contains(query) ||
          clinic.subtitle.toLowerCase().contains(query) ||
          clinic.location.toLowerCase().contains(query);
    }).toList();
  }

  void _bookAppointment(BuildContext context, ClinicItem clinic) {
    final authState = context.read<AuthBloc>().state;
    final patientId = authState is AuthAuthenticated ? authState.user.id : '';
    Navigator.of(context).pushNamed(
      AppRoutes.appointmentFor,
      arguments: {
        'doctorId': clinic.id,
        'doctorName': clinic.name,
        'doctorSpecialty': clinic.location,
        'doctorImageUrl': clinic.imageAsset,
        'patientId': patientId,
      },
    );
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
                itemCount: _filteredClinics.length,
                separatorBuilder: (_, __) => const SizedBox(height: 14),
                itemBuilder: (context, index) {
                  final clinic = _filteredClinics[index];
                  void openDetails() => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) =>
                          ClinicDetailsPage(clinic: clinic.toEntity()),
                    ),
                  );

                  return DoctorCard(
                    item: _asCardItem(clinic),
                    onTap: openDetails,
                    onBookNow: () => _bookAppointment(context, clinic),
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
