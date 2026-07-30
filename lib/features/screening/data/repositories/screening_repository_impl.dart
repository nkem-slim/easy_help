import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/screening_answer.dart';
import '../../domain/entities/screening_domain.dart';
import '../../domain/entities/screening_result.dart';
import '../../domain/repositories/screening_repository.dart';
import '../datasources/screening_remote_data_source.dart';
import '../models/screening_model.dart';

class ScreeningRepositoryImpl implements ScreeningRepository {
  final ScreeningRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  ScreeningRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, ScreeningResult>> submitScreening({
    required String userId,
    required List<ScreeningAnswer> answers,
    required int totalScore,
    required RiskLevel riskLevel,
    required List<ScreeningDomain> flaggedDomains,
  }) async {
    if (!await networkInfo.isConnected) return const Left(NetworkFailure());
    try {
      final model = ScreeningModel.fromAnswers(
        id: '',
        userId: userId,
        answers: answers,
        totalScore: totalScore,
        riskLevel: riskLevel,
        flaggedDomains: flaggedDomains,
        completedAt: DateTime.now(),
      );
      final saved = await remoteDataSource.submitScreening(model);
      return Right(saved);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (_) {
      return const Left(ServerFailure());
    }
  }
}
