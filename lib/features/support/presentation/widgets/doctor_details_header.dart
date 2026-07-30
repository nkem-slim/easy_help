import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

class DoctorDetailsHeader extends StatelessWidget {
  final VoidCallback? onSearchTap;

  const DoctorDetailsHeader({super.key, this.onSearchTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        MediaQuery.of(context).padding.top + 16,
        20,
        16,
      ),
      child: Row(
        children: [
          Material(
            color: AppColors.background,
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: () => Navigator.of(context).maybePop(),
              child: const SizedBox(
                width: 36,
                height: 36,
                child: Center(
                  child: Icon(
                    Icons.chevron_left_rounded,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Doctor Details',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          // Material(
          //   color: Colors.transparent,
          //   child: InkWell(
          //     customBorder: const CircleBorder(),
          //     onTap: onSearchTap,
          //     child: const SizedBox(
          //       width: 36,
          //       height: 36,
          //       child: Center(
          //         child: Icon(
          //           Icons.search_rounded,
          //           color: AppColors.textPrimary,
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
