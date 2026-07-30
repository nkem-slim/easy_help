import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/screening_model.dart';

abstract class ScreeningRemoteDataSource {
  Future<ScreeningModel> submitScreening(ScreeningModel screening);
}

class ScreeningRemoteDataSourceImpl implements ScreeningRemoteDataSource {
  final FirebaseFirestore firestore;

  ScreeningRemoteDataSourceImpl({required this.firestore});

  CollectionReference<Map<String, dynamic>> get _screeningsRef =>
      firestore.collection(FirestoreCollections.screenings);

  @override
  Future<ScreeningModel> submitScreening(ScreeningModel screening) async {
    try {
      final docRef = await _screeningsRef.add(screening.toMap());
      return ScreeningModel.fromMap(screening.toMap(), docRef.id);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
