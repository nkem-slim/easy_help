part of 'appointment_bloc.dart';

abstract class AppointmentEvent extends Equatable {
  const AppointmentEvent();

  @override
  List<Object?> get props => [];
}

class AppointmentBookRequested extends AppointmentEvent {
  final AppointmentEntity appointment;
  const AppointmentBookRequested(this.appointment);

  @override
  List<Object?> get props => [appointment];
}

class AppointmentLoadRequested extends AppointmentEvent {
  final String patientId;
  const AppointmentLoadRequested(this.patientId);

  @override
  List<Object?> get props => [patientId];
}

class AppointmentCancelRequested extends AppointmentEvent {
  final String appointmentId;
  final String patientIdAfterCancel;
  const AppointmentCancelRequested({
    required this.appointmentId,
    required this.patientIdAfterCancel,
  });

  @override
  List<Object?> get props => [appointmentId, patientIdAfterCancel];
}

class AppointmentUpdateRequested extends AppointmentEvent {
  final AppointmentEntity appointment;
  const AppointmentUpdateRequested(this.appointment);

  @override
  List<Object?> get props => [appointment];
}

class AppointmentDeleteRequested extends AppointmentEvent {
  final String appointmentId;
  final String patientIdAfterDelete;
  const AppointmentDeleteRequested({
    required this.appointmentId,
    required this.patientIdAfterDelete,
  });

  @override
  List<Object?> get props => [appointmentId, patientIdAfterDelete];
}
