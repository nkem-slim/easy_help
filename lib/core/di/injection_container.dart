import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../network/network_info.dart';
import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/logout_usecase.dart';
import '../../features/auth/domain/usecases/register_usecase.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';

import '../../features/appointments/data/datasources/appointment_remote_data_source.dart';
import '../../features/appointments/data/models/appointment_model.dart';
import '../../features/appointments/data/repositories/appointment_repository_impl.dart';
import '../../features/appointments/domain/repositories/appointment_repository.dart';
import '../../features/appointments/domain/usecases/book_appointment_usecase.dart';
import '../../features/appointments/domain/usecases/cancel_appointment_usecase.dart';
import '../../features/appointments/domain/usecases/get_booked_appointments_usecase.dart';
import '../../features/appointments/presentation/bloc/appointment_bloc.dart';

import '../../features/screening/data/datasources/screening_remote_data_source.dart';
import '../../features/screening/data/models/screening_model.dart';
import '../../features/screening/data/repositories/screening_repository_impl.dart';
import '../../features/screening/domain/repositories/screening_repository.dart';
import '../../features/screening/domain/usecases/submit_screening_usecase.dart';
import '../../features/screening/presentation/bloc/screening_bloc.dart';

final GetIt sl = GetIt.instance;

// TODO: remove stub and uncomment Firebase registrations when Firebase is configured
class _AppointmentRemoteDataSourceStub implements AppointmentRemoteDataSource {
  final List<AppointmentModel> _fakeAppointments = [
    AppointmentModel(
      id: '1',
      patientId: 'test-patient',
      doctorId: 'doc-1',
      doctorName: 'Dr. Nshuti',
      doctorSpecialty: 'Pediatrician',
      doctorImageUrl: 'https://i.pravatar.cc/150?img=12',
      patientName: 'Uwineza',
      contactNumber: '0788000000',
      relationship: 'Mother',
      date: DateTime.now().add(const Duration(days: 3)),
      timeSlot: '10:00 AM',
      reminderMinutesBefore: 30,
      status: 'upcoming',
    ),
  ];

  @override
  Future<AppointmentModel> bookAppointment(AppointmentModel appointment) async {
    _fakeAppointments.add(appointment);
    return appointment;
  }

  @override
  Future<List<AppointmentModel>> getBookedAppointments(String patientId) async {
    return _fakeAppointments;
  }

  @override
  Future<void> cancelAppointment(String appointmentId) async {
    _fakeAppointments.removeWhere((a) => a.id == appointmentId);
  }
}

// TODO: remove stub and uncomment Firebase registrations when Firebase is configured
class _ScreeningRemoteDataSourceStub implements ScreeningRemoteDataSource {
  @override
  Future<ScreeningModel> submitScreening(ScreeningModel screening) async {
    return ScreeningModel.fromMap(screening.toMap(), 'stub-screening-id');
  }
}

Future<void> initDependencies() async {
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
  sl.registerLazySingleton(
    () => GoogleSignIn(
      // Web (unlike Android/iOS) has no google-services.json/plist to read
      // the OAuth client id from, so it must be passed explicitly here.
      clientId: kIsWeb
          ? '673918271872-vpn9gscug1bgfqj90hgqjg1d84kk3ll7.apps.googleusercontent.com'
          : null,
    ),
  );
  sl.registerLazySingleton(() => Connectivity());

  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  _initAuth();
  _initAppointments();
  _initScreening();
}

void _initAuth() {
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      firebaseAuth: sl(),
      firestore: sl(),
      googleSignIn: sl(),
    ),
  );

  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );

  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));

  sl.registerFactory(
    () => AuthBloc(
      loginUseCase: sl(),
      registerUseCase: sl(),
      logoutUseCase: sl(),
      authRepository: sl(),
    ),
  );
}

void _initAppointments() {
  sl.registerLazySingleton<AppointmentRemoteDataSource>(
    // TODO: swap stub for real impl when Firebase is configured
    () => _AppointmentRemoteDataSourceStub(),
    // () => AppointmentRemoteDataSourceImpl(firestore: sl()),
  );

  sl.registerLazySingleton<AppointmentRepository>(
    () => AppointmentRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );

  sl.registerLazySingleton(() => BookAppointmentUsecase(sl()));
  sl.registerLazySingleton(() => GetBookedAppointmentsUsecase(sl()));
  sl.registerLazySingleton(() => CancelAppointmentUseCase(sl()));

  sl.registerFactory(
    () => AppointmentBloc(
      bookAppointmentUsecase: sl(),
      getBookedAppointmentsUsecase: sl(),
      cancelAppointmentUseCase: sl(),
    ),
  );
}

void _initScreening() {
  sl.registerLazySingleton<ScreeningRemoteDataSource>(
    // TODO: swap stub for real impl when Firebase is configured
    () => _ScreeningRemoteDataSourceStub(),
    // () => ScreeningRemoteDataSourceImpl(firestore: sl()),
  );

  sl.registerLazySingleton<ScreeningRepository>(
    () => ScreeningRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );

  sl.registerLazySingleton(() => SubmitScreeningUseCase(sl()));

  sl.registerFactory(
    () => ScreeningBloc(submitScreeningUseCase: sl()),
  );
}
