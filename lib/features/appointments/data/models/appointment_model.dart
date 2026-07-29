import '../../domain/entities/appointment_entity.dart';

class AppointmentModel extends AppointmentEntity {
  const AppointmentModel({
    required super.id,
    required super.patientId,
    required super.doctorId,
    required super.doctorName,
    required super.doctorSpecialty,
    required super.doctorImageUrl,
    required super.patientName,
    required super.contactNumber,
    required super.relationship,
    required super.date,
    required super.timeSlot,
    required super.reminderMinutesBefore,
    required super.status,
  });

  factory AppointmentModel.fromMap(
    Map<String, dynamic> map,
    String documentId,
  ) {
    return AppointmentModel(
      id: documentId,
      patientId: map['patientId'],
      doctorId: map['doctorId'],
      doctorName: map['doctorName'],
      doctorSpecialty: map['doctorSpecialty'],
      doctorImageUrl: map['doctorImageUrl'],
      patientName: map['patientName'],
      contactNumber: map['contactNumber'],
      relationship: map['map'],
      date: DateTime.parse(map['date']),
      timeSlot: map['timeSlot'],
      reminderMinutesBefore: map['reminderMinutesBefore'],
      status: map['status'],
    );
  }

  factory AppointmentModel.fromEntity(AppointmentEntity entity) {
    return AppointmentModel(
      id: entity.id,
      patientId: entity.patientId,
      doctorId: entity.doctorId,
      doctorName: entity.doctorName,
      doctorSpecialty: entity.doctorSpecialty,
      doctorImageUrl: entity.doctorImageUrl,
      patientName: entity.patientName,
      contactNumber: entity.contactNumber,
      relationship: entity.relationship,
      date: entity.date,
      timeSlot: entity.timeSlot,
      reminderMinutesBefore: entity.reminderMinutesBefore,
      status: entity.status,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'patientId': patientId,
      'doctorId': doctorId,
      'doctorName': doctorName,
      'doctorSpecialty': doctorSpecialty,
      'doctorImageUrl': doctorImageUrl,
      'date': date.toIso8601String(),
      'timeSlot': timeSlot,
      'reminderMinutesBefore': reminderMinutesBefore,
      'status': status,
    };
  }
}
