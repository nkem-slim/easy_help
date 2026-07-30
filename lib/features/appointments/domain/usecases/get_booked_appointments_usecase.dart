import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/appointment_entity.dart';
import '../repositories/appointment_repository.dart';

class GetBookedAppointmentsUsecase
    implements UseCase<List<AppointmentEntity>, GetBookedAppointmentsParams> {
  final AppointmentRepository repository;

  GetBookedAppointmentsUsecase(this.repository);

  @override
  Future<Either<Failure, List<AppointmentEntity>>> call(
    GetBookedAppointmentsParams params,
  ) {
    return repository.getBookedAppointments(params.patientId);
  }
}

class GetBookedAppointmentsParams extends Equatable {
  final String patientId;
  const GetBookedAppointmentsParams({required this.patientId});

  @override
  List<Object?> get props => [patientId];
}
