import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/screening_answer.dart';
import '../entities/screening_domain.dart';
import '../entities/screening_result.dart';

abstract class ScreeningRepository {
  // TODO(multi-child): revisit if screenings ever need to attach to a
  // specific child rather than the authenticated parent's account.
  Future<Either<Failure, ScreeningResult>> submitScreening({
    required String userId,
    required List<ScreeningAnswer> answers,
    required int totalScore,
    required RiskLevel riskLevel,
    required List<ScreeningDomain> flaggedDomains,
  });
}
