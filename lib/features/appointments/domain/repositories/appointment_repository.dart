import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/appointment_entity.dart';

abstract class AppointmentRepository {
  Future<Either<Failure, List<AppointmentEntity>>> getBookedAppointments(
    String patientId,
  );
  Future<Either<Failure, AppointmentEntity>> bookAppointment(
    AppointmentEntity appointment,
  );
  Future<Either<Failure, void>> cancelAppointment(String appointmentId);
}
