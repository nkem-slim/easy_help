import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/screening_result.dart';
import '../widgets/screening_clinic_section.dart';
import '../widgets/screening_flagged_domains_list.dart';
import '../widgets/screening_next_step_banner.dart';
import '../widgets/screening_resources_grid.dart';
import '../widgets/screening_stat_card.dart';
import '../widgets/screening_status_header.dart';
import '../widgets/screening_tip_card.dart';
import '../widgets/screening_videos_section.dart';

class ScreeningResultPage extends StatelessWidget {
  final ScreeningResult result;

  const ScreeningResultPage({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Screening'),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline_rounded),
            onPressed: () {}, // TODO: link to screening FAQ/help content
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ScreeningStatusHeader(
                  riskLevel: result.riskLevel,
                  screenedOn: result.screenedOn,
                ),
              ),
              const SizedBox(height: 20),
              if (result.riskLevel.isLow)
                ..._lowRiskSections()
              else
                ..._elevatedRiskSections(),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _lowRiskSections() {
    final hasSkillStats =
        result.socialSkillsStatus != null || result.motorSkillsStatus != null;

    return [
      if (hasSkillStats)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              if (result.socialSkillsStatus != null)
                ScreeningStatCard(
                  label: 'Social Skills',
                  status: result.socialSkillsStatus!,
                ),
              if (result.socialSkillsStatus != null &&
                  result.motorSkillsStatus != null)
                const SizedBox(width: 12),
              if (result.motorSkillsStatus != null)
                ScreeningStatCard(
                  label: 'Motor Skills',
                  status: result.motorSkillsStatus!,
                ),
            ],
          ),
        ),
      if (hasSkillStats) const SizedBox(height: 20),
      const ScreeningVideosSection(),
      const SizedBox(height: 20),
      const ScreeningResourcesGrid(),
      const SizedBox(height: 20),
      const ScreeningTipCard(),
    ];
  }

  List<Widget> _elevatedRiskSections() {
    return [
      ScreeningNextStepBanner(nextStep: result.riskLevel.nextStep),
      if (result.flaggedDomains.isNotEmpty) ...[
        const SizedBox(height: 12),
        ScreeningFlaggedDomainsList(domains: result.flaggedDomains),
      ],
      const SizedBox(height: 20),
      const ScreeningClinicSection(),
    ];
  }
}
