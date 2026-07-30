import 'package:flutter_test/flutter_test.dart';

import 'package:easy_help/features/screening/domain/entities/screening_answer.dart';
import 'package:easy_help/features/screening/domain/entities/screening_domain.dart';
import 'package:easy_help/features/screening/domain/entities/screening_result.dart';
import 'package:easy_help/features/screening/domain/usecases/score_screening_answers.dart';

void main() {
  group('score_screening_answers', () {
    test('all-healthy answers score 0, Low, no flagged domains', () {
      final answers = [
        const ScreeningAnswer(questionId: 'q1', response: AnswerResponse.yes),
        const ScreeningAnswer(questionId: 'q2', response: AnswerResponse.yes),
        const ScreeningAnswer(questionId: 'q3', response: AnswerResponse.yes),
        const ScreeningAnswer(questionId: 'q4', response: AnswerResponse.no),
      ];

      expect(totalScoreForAnswers(answers), 0);
      expect(riskLevelForAnswers(answers), RiskLevel.low);
      expect(flaggedDomainsForAnswers(answers), isEmpty);
    });

    test('all-concerning answers score 4, High, every domain flagged', () {
      final answers = [
        const ScreeningAnswer(questionId: 'q1', response: AnswerResponse.no),
        const ScreeningAnswer(questionId: 'q2', response: AnswerResponse.no),
        const ScreeningAnswer(questionId: 'q3', response: AnswerResponse.no),
        const ScreeningAnswer(questionId: 'q4', response: AnswerResponse.yes),
      ];

      expect(totalScoreForAnswers(answers), 4);
      expect(riskLevelForAnswers(answers), RiskLevel.high);
      expect(flaggedDomainsForAnswers(answers), [
        ScreeningDomain.jointAttention,
        ScreeningDomain.pretendPlay,
        ScreeningDomain.socialInterest,
        ScreeningDomain.repetitiveBehavior,
      ]);
    });

    test(
      'mixed answers score 2, Medium, flags joint attention + repetitive behavior',
      () {
        final answers = [
          const ScreeningAnswer(questionId: 'q1', response: AnswerResponse.no),
          const ScreeningAnswer(
            questionId: 'q2',
            response: AnswerResponse.yes,
          ),
          const ScreeningAnswer(
            questionId: 'q3',
            response: AnswerResponse.yes,
          ),
          const ScreeningAnswer(
            questionId: 'q4',
            response: AnswerResponse.yes,
          ),
        ];

        expect(totalScoreForAnswers(answers), 2);
        expect(riskLevelForAnswers(answers), RiskLevel.medium);
        expect(flaggedDomainsForAnswers(answers), [
          ScreeningDomain.jointAttention,
          ScreeningDomain.repetitiveBehavior,
        ]);
      },
    );
  });
}
