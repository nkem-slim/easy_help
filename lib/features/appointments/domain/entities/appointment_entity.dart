import 'package:equatable/equatable.dart';

class AppointmentEntity extends Equatable {
  final String id;
  final String patientId;
  final String doctorId;
  final String doctorName;
  final String doctorSpecialty;
  final String doctorImageUrl;
  final DateTime date;
  final String timeSlot;
  final int reminderMinutesBefore;
  final String status;

  const AppointmentEntity({
    required this.id,
    required this.patientId,
    required this.doctorId,
    required this.doctorName,
    required this.doctorSpecialty,
    required this.doctorImageUrl,
    required this.date,
    required this.timeSlot,
    required this.reminderMinutesBefore,
    this.status = 'upcoming',
  });

  @override
  List<Object?> get props => [
    id,
    patientId,
    doctorId,
    doctorName,
    doctorSpecialty,
    doctorImageUrl,
    date,
    timeSlot,
    reminderMinutesBefore,
    status,
  ];
}
