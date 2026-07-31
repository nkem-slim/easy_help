import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/appointment_entity.dart';
import '../../domain/usecases/book_appointment_usecase.dart';
import '../../domain/usecases/cancel_appointment_usecase.dart';
import '../../domain/usecases/delete_appointment_usecase.dart';
import '../../domain/usecases/get_booked_appointments_usecase.dart';
import '../../domain/usecases/update_appointment_usecase.dart';

part 'appointment_event.dart';
part 'appointment_state.dart';

class AppointmentBloc extends Bloc<AppointmentEvent, AppointmentState> {
  final BookAppointmentUsecase bookAppointmentUsecase;
  final GetBookedAppointmentsUsecase getBookedAppointmentsUsecase;
  final CancelAppointmentUseCase cancelAppointmentUseCase;
  final UpdateAppointmentUseCase updateAppointmentUseCase;
  final DeleteAppointmentUseCase deleteAppointmentUseCase;

  AppointmentBloc({
    required this.bookAppointmentUsecase,
    required this.cancelAppointmentUseCase,
    required this.getBookedAppointmentsUsecase,
    required this.updateAppointmentUseCase,
    required this.deleteAppointmentUseCase,
  }) : super(const AppointmentInitial()) {
    on<AppointmentBookRequested>(_onBookRequested);
    on<AppointmentLoadRequested>(_onLoadRequested);
    on<AppointmentCancelRequested>(_onCancelRequested);
    on<AppointmentUpdateRequested>(_onUpdateRequested);
    on<AppointmentDeleteRequested>(_onDeleteRequested);
  }

  Future<void> _onBookRequested(
    AppointmentBookRequested event,
    Emitter<AppointmentState> emit,
  ) async {
    emit(const AppointmentLoading());
    final result = await bookAppointmentUsecase(event.appointment);
    result.fold(
      (failure) => emit(AppointmentFailure(failure.message)),
      (appointment) {
        emit(AppointmentBooked(appointment));
        add(AppointmentLoadRequested(appointment.patientId));
      },
    );
  }

  Future<void> _onLoadRequested(
    AppointmentLoadRequested event,
    Emitter<AppointmentState> emit,
  ) async {
    emit(const AppointmentLoading());
    final result = await getBookedAppointmentsUsecase(
      GetBookedAppointmentsParams(patientId: event.patientId),
    );
    result.fold(
      (failure) => emit(AppointmentFailure(failure.message)),
      (appointments) => emit(AppointmentLoaded(appointments)),
    );
  }

  Future<void> _onCancelRequested(
    AppointmentCancelRequested event,
    Emitter<AppointmentState> emit,
  ) async {
    final result = await cancelAppointmentUseCase(
      CancelAppointmentParams(appointmentId: event.appointmentId),
    );
    result.fold(
      (failure) => emit(AppointmentFailure(failure.message)),
      (_) => add(AppointmentLoadRequested(event.patientIdAfterCancel)),
    );
  }

  Future<void> _onUpdateRequested(
    AppointmentUpdateRequested event,
    Emitter<AppointmentState> emit,
  ) async {
    final result = await updateAppointmentUseCase(
      UpdateAppointmentParams(appointment: event.appointment),
    );
    result.fold(
      (failure) => emit(AppointmentFailure(failure.message)),
      (appointment) {
        emit(AppointmentUpdated(appointment));
        add(AppointmentLoadRequested(appointment.patientId));
      },
    );
  }

  Future<void> _onDeleteRequested(
    AppointmentDeleteRequested event,
    Emitter<AppointmentState> emit,
  ) async {
    final result = await deleteAppointmentUseCase(
      DeleteAppointmentParams(appointmentId: event.appointmentId),
    );
    result.fold(
      (failure) => emit(AppointmentFailure(failure.message)),
      (_) {
        emit(const AppointmentDeleted());
        add(AppointmentLoadRequested(event.patientIdAfterDelete));
      },
    );
  }
}
