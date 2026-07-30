import 'package:flutter/material.dart';

class ClinicEntity {
  final String id;
  final String name;
  final String location;
  final Color logoBackgroundColor;
  final IconData logoIcon;

  const ClinicEntity({
    required this.id,
    required this.name,
    required this.location,
    required this.logoBackgroundColor,
    required this.logoIcon,
  });
}
