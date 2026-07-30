import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:easy_help/features/screening/domain/entities/screening_domain.dart';
import 'package:easy_help/features/screening/domain/entities/screening_result.dart';
import 'package:easy_help/features/screening/presentation/pages/screening_result_page.dart';

void main() {
  testWidgets('low risk result renders Low Risk badge, no Areas to watch', (
    tester,
  ) async {
    final result = ScreeningResult(
      id: 'x',
      riskLevel: RiskLevel.low,
      screenedOn: DateTime(2026, 1, 1),
      flaggedDomains: const [],
    );

    await tester.pumpWidget(
      MaterialApp(home: ScreeningResultPage(result: result)),
    );

    expect(find.text('Low Risk'), findsOneWidget);
    expect(find.textContaining('Medium/High Risk'), findsNothing);
    expect(find.text('Areas to watch:'), findsNothing);
  });

  testWidgets(
    'high risk result renders Medium/High Risk badge and all flagged areas',
    (tester) async {
      final result = ScreeningResult(
        id: 'x',
        riskLevel: RiskLevel.high,
        screenedOn: DateTime(2026, 1, 1),
        flaggedDomains: const [
          ScreeningDomain.jointAttention,
          ScreeningDomain.pretendPlay,
          ScreeningDomain.socialInterest,
          ScreeningDomain.repetitiveBehavior,
        ],
      );

      await tester.pumpWidget(
        MaterialApp(home: ScreeningResultPage(result: result)),
      );

      expect(find.textContaining('Medium/High Risk'), findsWidgets);
      expect(find.text('Low Risk'), findsNothing);
      expect(find.text('Areas to watch:'), findsOneWidget);
      expect(find.text('Joint attention'), findsOneWidget);
      expect(find.text('Pretend play'), findsOneWidget);
      expect(find.text('Social interest'), findsOneWidget);
      expect(find.text('Repetitive behavior'), findsOneWidget);
    },
  );
}
