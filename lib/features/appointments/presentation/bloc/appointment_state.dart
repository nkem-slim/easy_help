part of 'appointment_bloc.dart';

abstract class AppointmentState extends Equatable {
  const AppointmentState();

  @override
  List<Object?> get props => [];
}

class AppointmentInitial extends AppointmentState {
  const AppointmentInitial();
}

class AppointmentLoading extends AppointmentState {
  const AppointmentLoading();
}

class AppointmentBooked extends AppointmentState {
  final AppointmentEntity appointment;
  const AppointmentBooked(this.appointment);

  @override
  List<Object?> get props => [appointment];
}

class AppointmentLoaded extends AppointmentState {
  final List<AppointmentEntity> appointments;
  const AppointmentLoaded(this.appointments);

  @override
  List<Object?> get props => [appointments];
}

class AppointmentFailure extends AppointmentState {
  final String message;
  const AppointmentFailure(this.message);

  @override
  List<Object?> get props => [message];
}
