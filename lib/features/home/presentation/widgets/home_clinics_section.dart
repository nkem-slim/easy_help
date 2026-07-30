import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../clinics/domain/entities/clinic_entity.dart';
import '../../../clinics/presentation/pages/clinic_details_page.dart';

class _ClinicItem {
  final String id;
  final String name;
  final String phone;
  final String location;
  final Color accentColor;
  final String imageAsset;

  const _ClinicItem({
    required this.id,
    required this.name,
    required this.phone,
    required this.location,
    required this.accentColor,
    required this.imageAsset,
  });

  ClinicEntity toEntity() {
    return ClinicEntity(
      id: id,
      name: name,
      location: location,
      imageAsset: imageAsset,
      logoBackgroundColor: accentColor,
      logoIcon: Icons.local_hospital,
    );
  }
}

class HomeClinicsSection extends StatelessWidget {
  const HomeClinicsSection({super.key});

  static const _clinics = [
    _ClinicItem(
      id: 'legacy-call-center',
      name: 'Legacy Call Center',
      phone: '+250 788 000 000',
      location: 'Kigali, Rwa',
      accentColor: AppColors.primary,
      imageAsset: 'assets/images/clinic-0.jpg',
    ),
    _ClinicItem(
      id: 'king-faisal-hospital',
      name: 'King Faisal Hospital Rwanda',
      phone: '+250 252 582 421',
      location: 'Kigali, Rwa',
      accentColor: Color(0xFF3B6FD4),
      imageAsset: 'assets/images/clinic-1.jpg',
    ),
    _ClinicItem(
      id: 'caraes-ndera',
      name: 'CARAES Ndera',
      phone: '+250 252 580 494',
      location: 'Kigali, Rwa',
      accentColor: Color(0xFF5BA4CF),
      imageAsset: 'assets/images/clinic-2.jpg',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'HELPFUL CLINICS',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),
              GestureDetector(
                onTap: () =>
                    Navigator.of(context).pushNamed(AppRoutes.findClinic),
                child: const Text(
                  'See all >',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 170,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: _clinics.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) => _ClinicCard(item: _clinics[index]),
          ),
        ),
      ],
    );
  }
}

class _ClinicCard extends StatelessWidget {
  final _ClinicItem item;

  const _ClinicCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ClinicDetailsPage(clinic: item.toEntity()),
        ),
      ),
      child: Container(
        width: 180,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.06),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(14),
                topRight: Radius.circular(14),
              ),
              child: Image.asset(
                item.imageAsset,
                height: 70,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Container(height: 4, color: item.accentColor),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(
                        Icons.phone_rounded,
                        size: 12,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          item.phone,
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
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
