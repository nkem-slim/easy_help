import 'package:equatable/equatable.dart';

import 'screening_domain.dart';

enum RiskLevel { low, medium, high }

extension RiskLevelX on RiskLevel {
  bool get isLow => this == RiskLevel.low;

  String get badgeLabel => isLow ? 'Low Risk' : 'Medium/High Risk';

  String get description {
    switch (this) {
      case RiskLevel.low:
        return "Your child's development appears on track";
      case RiskLevel.medium:
        return 'The screening indicates specific development areas that may '
            'benefit from a professional check-in. This doesn\'t mean a '
            'diagnosis, but proactive care is recommended.';
      case RiskLevel.high:
        return 'The screening indicates specific development areas that '
            'require professional clinical evaluation. This doesn\'t mean a '
            'diagnosis, but proactive care is recommended.';
    }
  }

  String get nextStep {
    switch (this) {
      case RiskLevel.low:
        return 'Keep up regular check-ins and continue tracking milestones '
            'in your journal.';
      case RiskLevel.medium:
        return 'Clinical consultation for a detailed developmental '
            'assessment.';
      case RiskLevel.high:
        return 'Clinical consultation for a detailed physical and '
            'developmental assessment.';
    }
  }
}

class ScreeningResult extends Equatable {
  final String id;
  final RiskLevel riskLevel;
  final DateTime screenedOn;
  final List<ScreeningDomain> flaggedDomains;

  // Not assessed yet by the current screening flow — leave null until a
  // real source exists rather than hardcoding a status.
  final String? socialSkillsStatus;
  final String? motorSkillsStatus;

  const ScreeningResult({
    required this.id,
    required this.riskLevel,
    required this.screenedOn,
    this.flaggedDomains = const [],
    this.socialSkillsStatus,
    this.motorSkillsStatus,
  });

  @override
  List<Object?> get props => [
    id,
    riskLevel,
    screenedOn,
    flaggedDomains,
    socialSkillsStatus,
    motorSkillsStatus,
  ];
}