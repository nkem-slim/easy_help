import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> loginWithEmail({
    required String email,
    required String password,
  });

  Future<Either<Failure, UserEntity>> registerWithEmail({
    required String name,
    required String email,
    required String password,
    required String role,
  });

  Future<Either<Failure, UserEntity>> signInWithGoogle();

  Future<Either<Failure, void>> logout();

  Future<Either<Failure, UserEntity>> updateProfile({
    required String name,
    String? mobile,
    String? gender,
    DateTime? dateOfBirth,
    String? preferredLanguage,
  });

  Future<Either<Failure, void>> changePassword({
    required String currentPassword,
    required String newPassword,
  });

  Future<Either<Failure, UserEntity>> linkGoogleAccount();

  Stream<UserEntity?> get authStateChanges;
}
