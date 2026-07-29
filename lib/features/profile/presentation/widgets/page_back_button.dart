import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

/// White rounded square holding a back chevron, used in place of an [AppBar]
/// on the pages that draw their own header over a gradient.
///
/// Defaults to popping the current route; pass [onTap] to override.
class PageBackButton extends StatelessWidget {
  final VoidCallback? onTap;

  const PageBackButton({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () => Navigator.pop(context),
      child: Container(
        width: 40,
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Color(0x14000000),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: const Icon(
          Icons.chevron_left_rounded,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}
