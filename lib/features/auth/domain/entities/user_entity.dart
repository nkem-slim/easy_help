import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String name;
  final String email;
  final String role;
  final String? preferredLanguage;
  final String? mobile;
  final String? gender;
  final DateTime? dateOfBirth;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.preferredLanguage,
    this.mobile,
    this.gender,
    this.dateOfBirth,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    email,
    role,
    preferredLanguage,
    mobile,
    gender,
    dateOfBirth,
  ];
}
