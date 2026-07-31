import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/appointment_repository.dart';

class DeleteAppointmentUseCase
    implements UseCase<void, DeleteAppointmentParams> {
  final AppointmentRepository repository;

  DeleteAppointmentUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(DeleteAppointmentParams params) {
    return repository.deleteAppointment(params.appointmentId);
  }
}

class DeleteAppointmentParams extends Equatable {
  final String appointmentId;
  const DeleteAppointmentParams({required this.appointmentId});

  @override
  List<Object?> get props => [appointmentId];
}
