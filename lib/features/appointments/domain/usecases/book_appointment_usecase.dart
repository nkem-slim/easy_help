import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/appointment_entity.dart';
import '../repositories/appointment_repository.dart';

class BookAppointmentUsecase
    implements UseCase<AppointmentEntity, AppointmentEntity> {
  final AppointmentRepository repository;

  BookAppointmentUsecase(this.repository);

  @override
  Future<Either<Failure, AppointmentEntity>> call(AppointmentEntity params) {
    return repository.bookAppointment(params);
  }
}
