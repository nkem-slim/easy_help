import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

/// The gender options offered on the user details form.
///
/// Each value carries its own display text so the label can never drift out of
/// sync with the value it represents.
enum Gender {
  male('Male'),
  female('Female'),
  other('Others');

  const Gender(this.label);

  final String label;
}

/// Horizontal row of gender radio options.
///
/// Holds no state: [value] is the current selection and every tap is reported
/// through [onChanged], leaving the page that owns the form in charge.
class GenderSelector extends StatelessWidget {
  final Gender value;
  final ValueChanged<Gender> onChanged;

  const GenderSelector({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return RadioGroup<Gender>(
      groupValue: value,
      onChanged: (selected) {
        if (selected != null) onChanged(selected);
      },
      child: Row(
        children: [
          for (final gender in Gender.values)
            Expanded(
              child: _Option(
                gender: gender,
                onTap: () => onChanged(gender),
              ),
            ),
        ],
      ),
    );
  }
}

/// A single radio plus its label, tappable across both.
class _Option extends StatelessWidget {
  final Gender gender;
  final VoidCallback onTap;

  const _Option({required this.gender, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      // Without an opaque behaviour the padding around the label would not
      // register taps, leaving only the dot itself tappable.
      behavior: HitTestBehavior.opaque,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Radio<Gender>(
            value: gender,
            activeColor: AppColors.secondary,
            visualDensity: VisualDensity.compact,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          const SizedBox(width: 4),
          Text(
            gender.label,
            style: const TextStyle(
              fontSize: 15,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
