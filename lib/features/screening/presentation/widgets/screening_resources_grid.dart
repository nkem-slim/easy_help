import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';

class ScreeningResourcesGrid extends StatelessWidget {
  const ScreeningResourcesGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Resources',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.6,
            children: [
              // TODO(screening-data-layer): generate/download the PDF report
              // once report generation exists — remove isComingSoon then.
              const _ResourceTile(
                icon: Icons.description_rounded,
                label: 'Full Report',
                isComingSoon: true,
              ),
              _ResourceTile(
                icon: Icons.event_available_rounded,
                label: 'Next Checkup',
                onTap: () {
                  // TODO: navigate into the journal feature to schedule the
                  // next checkup reminder once that flow exists.
                  Navigator.of(context).pushNamed(AppRoutes.journal);
                },
              ),
              _ResourceTile(
                icon: Icons.support_agent_rounded,
                label: 'Ask Expert',
                onTap: () {
                  // TODO: navigate into the support feature's ask-an-expert
                  // flow once that flow exists — routing to find-clinic for
                  // now as the closest available destination.
                  Navigator.of(context).pushNamed(AppRoutes.findClinic);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ResourceTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final bool isComingSoon;

  const _ResourceTile({
    required this.icon,
    required this.label,
    this.onTap,
    this.isComingSoon = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.05),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, color: AppColors.primary, size: 22),
                  const SizedBox(height: 8),
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            if (isComingSoon)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.textSecondary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Soon',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
