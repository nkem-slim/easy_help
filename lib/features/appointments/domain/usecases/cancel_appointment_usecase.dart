// domain/usecases/cancel_appointment_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/appointment_repository.dart';

class CancelAppointmentUseCase
    implements UseCase<void, CancelAppointmentParams> {
  final AppointmentRepository repository;

  CancelAppointmentUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(CancelAppointmentParams params) {
    return repository.cancelAppointment(params.appointmentId);
  }
}

class CancelAppointmentParams extends Equatable {
  final String appointmentId;
  const CancelAppointmentParams({required this.appointmentId});

  @override
  List<Object?> get props => [appointmentId];
}
