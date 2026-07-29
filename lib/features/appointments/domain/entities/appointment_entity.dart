import 'package:equatable/equatable.dart';

class AppointmentEntity extends Equatable {
  final String id;
  final String patientId;
  final String doctorId;
  final String doctorName;
  final String doctorSpecialty;
  final String doctorImageUrl;
  final String patientName;
  final String contactNumber;
  final String relationship;
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
    required this.patientName,
    required this.contactNumber,
    required this.relationship,
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
    patientName,
    contactNumber,
    relationship,
    date,
    timeSlot,
    reminderMinutesBefore,
    status,
  ];
}
