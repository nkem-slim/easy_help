import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/fallback_image.dart';

const List<String> _defaultDoctorServices = [
  'Patient care should be the number one priority.',
  'Focused mainly on children with early signs of ASD.',
  "That's why you matter to us.",
];

class DoctorItem {
  final String name;
  final String specialty;
  final String experience;
  final String ratingPercent;
  final String patientStories;
  final String clinicName;
  final String availability;
  final String location;
  final String imageAsset;
  final bool isFavorite;
  final double starRating;
  final bool hasInsurance;
  final int runningCount;
  final int ongoingCount;
  final int patientCount;
  final List<String> services;
  final double clinicLat;
  final double clinicLng;

  const DoctorItem({
    required this.name,
    required this.specialty,
    required this.experience,
    required this.ratingPercent,
    required this.patientStories,
    required this.clinicName,
    required this.availability,
    required this.location,
    required this.imageAsset,
    this.isFavorite = false,
    this.starRating = 4.0,
    this.hasInsurance = true,
    this.runningCount = 100,
    this.ongoingCount = 500,
    this.patientCount = 700,
    this.services = _defaultDoctorServices,
    this.clinicLat = -1.9441,
    this.clinicLng = 30.0619,
  });
}

// TODO(support-data-layer): replace with a real DoctorRepository lookup by
// doctorId once one exists. Kept as one shared constant so every entry point
// into the doctor details / booking flow shows the same mock doctor instead
// of each screen inventing its own placeholder.
const String mockDoctorId = '2206489';
const String mockDoctorNetworkImageUrl = 'https://i.pravatar.cc/150?img=12';
const DoctorItem mockDrNshunti = DoctorItem(
  name: 'Dr. Nshunti',
  specialty: 'ADS Specialist',
  experience: '7 Years experience',
  ratingPercent: '87%',
  patientStories: '69 Patient Stories',
  clinicName: 'Legacy Clinic',
  availability: '24/7 Availability',
  location: 'Kigali',
  imageAsset: '',
  isFavorite: true,
);

class DoctorCard extends StatelessWidget {
  final DoctorItem item;
  final VoidCallback? onTap;
  final VoidCallback? onBookNow;
  final VoidCallback? onFavoriteToggle;

  const DoctorCard({
    super.key,
    required this.item,
    this.onTap,
    this.onBookNow,
    this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: onTap, child: _buildCard());
  }

  Widget _buildCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.06),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: FallbackImage(
                  imagePath: item.imageAsset,
                  width: 72,
                  height: 82,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.name,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        GestureDetector(
                          onTap: onFavoriteToggle,
                          child: Icon(
                            item.isFavorite
                                ? Icons.favorite_rounded
                                : Icons.favorite_border_rounded,
                            color: AppColors.error,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.specialty,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.experience,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        _StatDot(label: item.ratingPercent),
                        const SizedBox(width: 10),
                        _StatDot(label: item.patientStories),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.clinicName,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.availability,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              IntrinsicWidth(
                child: SizedBox(
                  height: 36,
                  child: ElevatedButton(
                    onPressed: onBookNow,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: const Text(
                      'Book Now',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatDot extends StatelessWidget {
  final String label;

  const _StatDot({required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: const BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
        ),
      ],
    );
  }
}
