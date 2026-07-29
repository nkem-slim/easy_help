import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

/// A single settings row on the profile screen.
///
/// Covers all three row variants in the design:
///  * icon badge + label + chevron  -> pass [leading]
///  * label + switch                -> pass [trailing]
///  * label + value + chevron       -> pass [trailingText]
///
/// When [trailing] is given it replaces the chevron entirely; otherwise the
/// chevron is drawn, optionally preceded by [trailingText].
class ProfileTile extends StatelessWidget {
  final String title;
  final Widget? leading;
  final Widget? trailing;
  final String? trailingText;
  final VoidCallback? onTap;

  const ProfileTile({
    super.key,
    required this.title,
    this.leading,
    this.trailing,
    this.trailingText,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          children: [
            if (leading != null) ...[
              leading!,
              const SizedBox(width: 16),
            ],
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            if (trailing != null)
              trailing!
            else ...[
              if (trailingText != null)
                Text(
                  trailingText!,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              const SizedBox(width: 4),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textSecondary,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
