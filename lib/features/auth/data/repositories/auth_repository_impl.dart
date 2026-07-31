import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({required this.remoteDataSource, required this.networkInfo});

  Future<Either<Failure, UserEntity>> _guard(
    Future<UserEntity> Function() action,
  ) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }
    try {
      final result = await action();
      return Right(result);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (_) {
      return const Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, UserEntity>> loginWithEmail({
    required String email,
    required String password,
  }) {
    return _guard(() => remoteDataSource.loginWithEmail(email: email, password: password));
  }

  @override
  Future<Either<Failure, UserEntity>> registerWithEmail({
    required String name,
    required String email,
    required String password,
    required String role,
  }) {
    return _guard(() => remoteDataSource.registerWithEmail(
          name: name,
          email: email,
          password: password,
          role: role,
        ));
  }

  @override
  Future<Either<Failure, UserEntity>> signInWithGoogle() {
    return _guard(() => remoteDataSource.signInWithGoogle());
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await remoteDataSource.logout();
      return const Right(null);
    } catch (_) {
      return const Left(ServerFailure('Failed to log out.'));
    }
  }

  @override
  Stream<UserEntity?> get authStateChanges => remoteDataSource.authStateChanges;
}
