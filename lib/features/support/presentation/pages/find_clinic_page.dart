import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
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

  // TODO(support-data-layer): replace with a real doctor list once a
  // DoctorRepository exists — all 3 currently point at the same mock doctor.
  static const _doctors = [mockDrNshunti, mockDrNshunti, mockDrNshunti];

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
                        builder: (detailsContext) => DoctorDetailsPage(
                          doctor: doctor,
                          onBookNow: () {
                            final authState = detailsContext
                                .read<AuthBloc>()
                                .state;
                            final patientId = authState is AuthAuthenticated
                                ? authState.user.id
                                : '';
                            Navigator.of(detailsContext).pushNamed(
                              AppRoutes.appointmentFor,
                              arguments: {
                                'doctorId': mockDoctorId,
                                'doctorName': doctor.name,
                                'doctorSpecialty': doctor.specialty,
                                'doctorImageUrl': mockDoctorNetworkImageUrl,
                                'patientId': patientId,
                              },
                            );
                          },
                        ),
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
