import '../../domain/entities/screening_answer.dart';
import '../../domain/entities/screening_domain.dart';
import '../../domain/entities/screening_result.dart';

class ScreeningModel extends ScreeningResult {
  // TODO(multi-child): this ties a screening to the authenticated parent's
  // account; revisit as a real child reference if multi-child support is
  // ever added.
  final String userId;
  final Map<String, String> answers;
  final int totalScore;

  const ScreeningModel({
    required super.id,
    required super.riskLevel,
    required super.screenedOn,
    required this.userId,
    required this.answers,
    required this.totalScore,
    super.flaggedDomains,
    super.socialSkillsStatus,
    super.motorSkillsStatus,
  });

  factory ScreeningModel.fromAnswers({
    required String id,
    required String userId,
    required List<ScreeningAnswer> answers,
    required int totalScore,
    required RiskLevel riskLevel,
    required List<ScreeningDomain> flaggedDomains,
    required DateTime completedAt,
  }) {
    return ScreeningModel(
      id: id,
      userId: userId,
      answers: {
        for (final answer in answers) answer.questionId: answer.response.name,
      },
      totalScore: totalScore,
      riskLevel: riskLevel,
      flaggedDomains: flaggedDomains,
      screenedOn: completedAt,
    );
  }

  factory ScreeningModel.fromMap(Map<String, dynamic> map, String documentId) {
    return ScreeningModel(
      id: documentId,
      userId: map['userId'] as String,
      answers: Map<String, String>.from(map['answers'] as Map),
      totalScore: map['totalScore'] as int,
      riskLevel: RiskLevel.values.byName(map['riskLevel'] as String),
      flaggedDomains: (map['flaggedDomains'] as List)
          .map((name) => ScreeningDomain.values.byName(name as String))
          .toList(),
      screenedOn: DateTime.parse(map['completedAt'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'answers': answers,
      'totalScore': totalScore,
      'riskLevel': riskLevel.name,
      'flaggedDomains': flaggedDomains.map((domain) => domain.name).toList(),
      'completedAt': screenedOn.toIso8601String(),
    };
  }
}
