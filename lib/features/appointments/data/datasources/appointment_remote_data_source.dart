import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/appointment_model.dart';

abstract class AppointmentRemoteDataSource {
  Future<AppointmentModel> bookAppointment(AppointmentModel appointment);
  Future<List<AppointmentModel>> getBookedAppointments(String patientId);
  Future<void> cancelAppointment(String appointmentId);
}

class AppointmentRemoteDataSourceImpl implements AppointmentRemoteDataSource {
  final FirebaseFirestore firestore;

  AppointmentRemoteDataSourceImpl({required this.firestore});

  CollectionReference<Map<String, dynamic>> get _appointmentsRef =>
      firestore.collection(FirestoreCollections.appointments);

  @override
Future<AppointmentModel> bookAppointment(AppointmentModel appointment) async {
  try {
    debugPrint('Writing appointment...');
    debugPrint(appointment.toMap().toString());

    final docRef = await _appointmentsRef.add(appointment.toMap());

    debugPrint('Appointment created: ${docRef.id}');

    return AppointmentModel.fromMap(appointment.toMap(), docRef.id);
  } catch (e, stackTrace) {
    debugPrint('BOOK APPOINTMENT ERROR');
    debugPrint(e.toString());
    debugPrint(stackTrace.toString());

    throw ServerException(e.toString());
  }
}

  @override
  Future<List<AppointmentModel>> getBookedAppointments(String patientId) async {
    try {
      final snapshot = await _appointmentsRef
          .where('patientId', isEqualTo: patientId)
          .orderBy('date', descending: false)
          .get();
      return snapshot.docs
          .map((doc) => AppointmentModel.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> cancelAppointment(String appointmentId) async {
    try {
      await _appointmentsRef.doc(appointmentId).update({'status': 'cancelled'});
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
