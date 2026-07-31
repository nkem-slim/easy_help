import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/appointment_entity.dart';
import '../repositories/appointment_repository.dart';

class UpdateAppointmentUseCase
    implements UseCase<AppointmentEntity, UpdateAppointmentParams> {
  final AppointmentRepository repository;

  UpdateAppointmentUseCase(this.repository);

  @override
  Future<Either<Failure, AppointmentEntity>> call(
    UpdateAppointmentParams params,
  ) {
    return repository.updateAppointment(params.appointment);
  }
}

class UpdateAppointmentParams extends Equatable {
  final AppointmentEntity appointment;
  const UpdateAppointmentParams({required this.appointment});

  @override
  List<Object?> get props => [appointment];
}
