import '../entities/screening_answer.dart';
import '../entities/screening_domain.dart';
import '../entities/screening_question.dart';
import '../entities/screening_result.dart';

const Map<int, ScreeningDomain> _domainByQuestionOrder = {
  1: ScreeningDomain.jointAttention,
  2: ScreeningDomain.pretendPlay,
  3: ScreeningDomain.socialInterest,
  4: ScreeningDomain.repetitiveBehavior,
};

/// Pure scoring rule, no side effects:
/// - Questions 1-3: "yes" = 0 points, "no"/"notSure" = 1 point each.
/// - Question 4 (reversed, it's a red-flag behavior): "no" = 0 points,
///   "yes"/"notSure" = 1 point each.
bool _isConcerning(AnswerResponse response, int questionOrder, int lastOrder) {
  final isReversedQuestion = questionOrder == lastOrder;
  final zeroPointResponse =
      isReversedQuestion ? AnswerResponse.no : AnswerResponse.yes;
  return response != zeroPointResponse;
}

int totalScoreForAnswers(List<ScreeningAnswer> answers) {
  final questionsById = {
    for (final question in screeningQuestionBank) question.id: question,
  };
  final lastOrder = screeningQuestionBank.length;

  var score = 0;
  for (final answer in answers) {
    final order = questionsById[answer.questionId]?.order;
    if (order == null) continue;
    if (_isConcerning(answer.response, order, lastOrder)) score += 1;
  }
  return score;
}

/// Which domains had a concerning answer, in question order (Q1..Q4).
List<ScreeningDomain> flaggedDomainsForAnswers(List<ScreeningAnswer> answers) {
  final answersByQuestionId = {
    for (final answer in answers) answer.questionId: answer,
  };
  final lastOrder = screeningQuestionBank.length;

  final flagged = <ScreeningDomain>[];
  for (final question in screeningQuestionBank) {
    final answer = answersByQuestionId[question.id];
    if (answer == null) continue;
    if (_isConcerning(answer.response, question.order, lastOrder)) {
      final domain = _domainByQuestionOrder[question.order];
      if (domain != null) flagged.add(domain);
    }
  }
  return flagged;
}

RiskLevel riskLevelForScore(int totalScore) {
  if (totalScore == 0) return RiskLevel.low;
  if (totalScore <= 2) return RiskLevel.medium;
  return RiskLevel.high;
}

RiskLevel riskLevelForAnswers(List<ScreeningAnswer> answers) =>
    riskLevelForScore(totalScoreForAnswers(answers));
