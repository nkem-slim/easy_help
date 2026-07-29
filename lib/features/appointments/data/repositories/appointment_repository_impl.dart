import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/appointment_entity.dart';
import '../../domain/repositories/appointment_repository.dart';
import '../datasources/appointment_remote_data_source.dart';
import '../models/appointment_model.dart';

class AppointmentRepositoryImpl implements AppointmentRepository {
  final AppointmentRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  AppointmentRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, AppointmentEntity>> bookAppointment(
    AppointmentEntity appointment,
  ) async {
    if (!await networkInfo.isConnected) return const Left(NetworkFailure());
    try {
      final model = AppointmentModel.fromEntity(appointment);
      final saved = await remoteDataSource.bookAppointment(model);
      return Right(saved);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (_) {
      return const Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<AppointmentEntity>>> getBookedAppointments(
    String patientId,
  ) async {
    if (!await networkInfo.isConnected) return const Left(NetworkFailure());
    try {
      final result = await remoteDataSource.getBookedAppointments(patientId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (_) {
      return const Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> cancelAppointment(AppointmentEntity appointment) async {
    if (!await networkInfo.isConnected) return const Left(NetworkFailure());
    try {
      await remoteDataSource.cancelAppointment(appointment);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (_) {
      return const Left(ServerFailure());
    }
  }
}