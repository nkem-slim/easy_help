import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';



class UpdateProfileParams extends Equatable {
  final String name;
  final String? mobile;
  final String? gender;
  final DateTime? dateOfBirth;
  final String? preferredLanguage;

  const UpdateProfileParams({
    required this.name,
    this.mobile,
    this.gender,
    this.dateOfBirth,
    this.preferredLanguage,
  });

  @override
  List<Object?> get props => [name, mobile, gender, dateOfBirth, preferredLanguage];
}

class UpdateProfileUseCase implements UseCase<UserEntity, UpdateProfileParams> {
  final AuthRepository repository;
  UpdateProfileUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(UpdateProfileParams params) {
    return repository.updateProfile(
      name: params.name,
      mobile: params.mobile,
      gender: params.gender,
      dateOfBirth: params.dateOfBirth,
      preferredLanguage: params.preferredLanguage,
    );
  }
}