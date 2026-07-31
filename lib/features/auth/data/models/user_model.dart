import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.role,
    super.preferredLanguage,
    super.mobile,
    super.gender,
    super.dateOfBirth,
  });

  factory UserModel.fromMap(Map<String, dynamic> map, String documentId) {
    final dobTimestamp = map['dateOfBirth'];
    return UserModel(
      id: documentId,
      name: map['name'] as String? ?? '',
      email: map['email'] as String? ?? '',
      role: map['role'] as String? ?? 'parent',
      preferredLanguage: map['preferredLanguage'] as String?,
      mobile: map['mobile'] as String?,
      gender: map['gender'] as String?,
      dateOfBirth: dobTimestamp is Timestamp ? dobTimestamp.toDate() : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'role': role,
      'preferredLanguage': preferredLanguage,
      'mobile': mobile,
      'gender': gender,
      'dateOfBirth': dateOfBirth != null
          ? Timestamp.fromDate(dateOfBirth!)
          : null,
    };
  }
}
