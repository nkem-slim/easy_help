import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/screening_answer.dart';
import '../entities/screening_result.dart';
import '../repositories/screening_repository.dart';
import 'score_screening_answers.dart';

class SubmitScreeningParams extends Equatable {
  final String userId;
  final List<ScreeningAnswer> answers;

  const SubmitScreeningParams({required this.userId, required this.answers});

  @override
  List<Object?> get props => [userId, answers];
}

class SubmitScreeningUseCase
    implements UseCase<ScreeningResult, SubmitScreeningParams> {
  final ScreeningRepository repository;

  SubmitScreeningUseCase(this.repository);

  @override
  Future<Either<Failure, ScreeningResult>> call(
    SubmitScreeningParams params,
  ) {
    final totalScore = totalScoreForAnswers(params.answers);
    final riskLevel = riskLevelForScore(totalScore);
    final flaggedDomains = flaggedDomainsForAnswers(params.answers);
    return repository.submitScreening(
      userId: params.userId,
      answers: params.answers,
      totalScore: totalScore,
      riskLevel: riskLevel,
      flaggedDomains: flaggedDomains,
    );
  }
}
