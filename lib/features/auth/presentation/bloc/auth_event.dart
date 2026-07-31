part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;

  const AuthLoginRequested({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class AuthRegisterRequested extends AuthEvent {
  final String name;
  final String email;
  final String password;
  final String role;

  const AuthRegisterRequested({
    required this.name,
    required this.email,
    required this.password,
    required this.role,
  });

  @override
  List<Object?> get props => [name, email, password, role];
}

class AuthGoogleSignInRequested extends AuthEvent {
  const AuthGoogleSignInRequested();
}

class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}

class AuthUserChanged extends AuthEvent {
  final UserEntity? user;

  const AuthUserChanged(this.user);

  @override
  List<Object?> get props => [user];
}

class AuthProfileUpdateRequested extends AuthEvent {
  final String name;
  final String? mobile;
  final String? gender;
  final DateTime? dateOfBirth;
  final String? preferredLanguage;

  const AuthProfileUpdateRequested({
    required this.name,
    this.mobile,
    this.gender,
    this.dateOfBirth,
    this.preferredLanguage,
  });

  @override
  List<Object?> get props => [name, mobile, gender, dateOfBirth, preferredLanguage];
}

class AuthLinkGoogleRequested extends AuthEvent {
  const AuthLinkGoogleRequested();
}