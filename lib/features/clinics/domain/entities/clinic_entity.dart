import 'package:flutter/material.dart';

class ClinicEntity {
  final String id;
  final String name;
  final String location;
  final String imageAsset;
  final Color logoBackgroundColor;
  final IconData logoIcon;

  const ClinicEntity({
    required this.id,
    required this.name,
    required this.location,
    required this.imageAsset,
    required this.logoBackgroundColor,
    required this.logoIcon,
  });
}
