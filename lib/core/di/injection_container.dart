// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
// import 'package:google_sign_in/google_sign_in.dart';

import '../network/network_info.dart';
import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/logout_usecase.dart';
import '../../features/auth/domain/usecases/register_usecase.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/data/models/user_model.dart';

final GetIt sl = GetIt.instance;

// TODO: remove stub and uncomment Firebase registrations when Firebase is configured
class _AuthRemoteDataSourceStub implements AuthRemoteDataSource {
  @override
  Future<UserModel> loginWithEmail({required String email, required String password}) =>
      throw UnimplementedError('Firebase not yet initialized');

  @override
  Future<UserModel> registerWithEmail({
    required String name,
    required String email,
    required String password,
    required String role,
  }) => throw UnimplementedError('Firebase not yet initialized');

  @override
  Future<UserModel> signInWithGoogle() =>
      throw UnimplementedError('Firebase not yet initialized');

  @override
  Future<void> logout() =>
      throw UnimplementedError('Firebase not yet initialized');

  @override
  Stream<UserModel?> get authStateChanges => const Stream.empty();
}

Future<void> initDependencies() async {
  // sl.registerLazySingleton(() => FirebaseAuth.instance);
  // sl.registerLazySingleton(() => FirebaseFirestore.instance);
  // sl.registerLazySingleton(() => GoogleSignIn());
  sl.registerLazySingleton(() => Connectivity());

  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  _initAuth();
}

void _initAuth() {
  sl.registerLazySingleton<AuthRemoteDataSource>(
    // TODO: swap stub for real impl when Firebase is configured
    () => _AuthRemoteDataSourceStub(),
    // () => AuthRemoteDataSourceImpl(
    //   firebaseAuth: sl(),
    //   firestore: sl(),
    //   googleSignIn: sl(),
    // ),
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
