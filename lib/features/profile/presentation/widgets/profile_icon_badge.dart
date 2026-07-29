import 'package:flutter/material.dart';

/// A circular, solid-colour badge holding a single white icon.
///
/// Used as the leading widget of the "Account settings" rows.
class ProfileIconBadge extends StatelessWidget {
  final IconData icon;
  final Color color;
  final double size;

  const ProfileIconBadge({
    super.key,
    required this.icon,
    required this.color,
    this.size = 40,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: Icon(icon, color: Colors.white, size: size * 0.55),
    );
  }
}
