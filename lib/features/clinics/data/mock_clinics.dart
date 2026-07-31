import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../domain/entities/clinic_entity.dart';

/// Single source of clinic data shared by the Home screen's "Helpful Clinics"
/// section and the Find a Clinic page, until a ClinicRepository backed by
/// Firestore replaces it.
class ClinicItem {
  final String id;
  final String name;
  final String phone;
  final String location;
  final Color accentColor;
  final String imageAsset;
  final String subtitle;
  final double rating;
  final String distanceLabel;
  final bool isVerified;
  final bool isOpenNow;

  const ClinicItem({
    required this.id,
    required this.name,
    required this.phone,
    required this.location,
    required this.accentColor,
    required this.imageAsset,
    required this.subtitle,
    required this.rating,
    required this.distanceLabel,
    required this.isVerified,
    required this.isOpenNow,
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

// TODO(clinics-data-layer): replace with ClinicRepository.getAll() once one
// exists, backed by FirestoreCollections.clinics.
const List<ClinicItem> mockClinics = [
  ClinicItem(
    id: 'legacy-call-center',
    name: 'Legacy Call Center',
    phone: '+250 788 000 000',
    location: 'Kigali, Rwa',
    accentColor: AppColors.primary,
    imageAsset: 'assets/images/clinic-0.jpg',
    subtitle: '24/7 Autism Support Hotline',
    rating: 4.7,
    distanceLabel: '0.8 km away',
    isVerified: true,
    isOpenNow: true,
  ),
  ClinicItem(
    id: 'king-faisal-hospital',
    name: 'King Faisal Hospital Rwanda',
    phone: '+250 252 582 421',
    location: 'Kigali, Rwa',
    accentColor: Color(0xFF3B6FD4),
    imageAsset: 'assets/images/clinic-1.jpg',
    subtitle: 'Specialized Pediatric Development Wing',
    rating: 4.9,
    distanceLabel: '1.2 km away',
    isVerified: true,
    isOpenNow: true,
  ),
  ClinicItem(
    id: 'caraes-ndera',
    name: 'CARAES Ndera',
    phone: '+250 252 580 494',
    location: 'Kigali, Rwa',
    accentColor: Color(0xFF5BA4CF),
    imageAsset: 'assets/images/clinic-2.jpg',
    subtitle: 'Child & Adolescent Mental Health Unit',
    rating: 4.6,
    distanceLabel: '3.8 km away',
    isVerified: true,
    isOpenNow: false,
  ),
  ClinicItem(
    id: 'kibagabaga-district-hospital',
    name: 'Kibagabaga District Hospital',
    phone: '+250 788 123 456',
    location: 'Kigali, Rwa',
    accentColor: Color(0xFF4CAF93),
    imageAsset: 'assets/images/clinic-0.jpg',
    subtitle: 'General Pediatric & Developmental Care',
    rating: 4.3,
    distanceLabel: '5.1 km away',
    isVerified: false,
    isOpenNow: true,
  ),
  ClinicItem(
    id: 'rwanda-autism-support-center',
    name: 'Rwanda Autism Support Center',
    phone: '+250 788 234 567',
    location: 'Kigali, Rwa',
    accentColor: Color(0xFFDB8A3B),
    imageAsset: 'assets/images/clinic-1.jpg',
    subtitle: 'Autism Screening & Therapy Center',
    rating: 4.8,
    distanceLabel: '2.4 km away',
    isVerified: true,
    isOpenNow: true,
  ),
  ClinicItem(
    id: 'kanombe-military-hospital',
    name: 'Kanombe Military Hospital',
    phone: '+250 788 345 678',
    location: 'Kigali, Rwa',
    accentColor: Color(0xFF8B5CF6),
    imageAsset: 'assets/images/clinic-2.jpg',
    subtitle: 'Neurodevelopmental Assessment Clinic',
    rating: 4.2,
    distanceLabel: '6.7 km away',
    isVerified: false,
    isOpenNow: false,
  ),
];
