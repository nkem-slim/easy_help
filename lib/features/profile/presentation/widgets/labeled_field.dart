import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

/// A bold label sitting above a form input.
///
/// Takes an arbitrary [child] so the same label styling wraps text fields,
/// dropdown rows, and radio groups alike. Spacing between consecutive fields is
/// left to the parent, which owns the layout rhythm of the form.
class LabeledField extends StatelessWidget {
  final String label;
  final Widget child;

  const LabeledField({
    super.key,
    required this.label,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}
