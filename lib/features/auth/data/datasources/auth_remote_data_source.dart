import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:google_sign_in/google_sign_in.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> loginWithEmail({
    required String email,
    required String password,
  });

  Future<UserModel> registerWithEmail({
    required String name,
    required String email,
    required String password,
    required String role,
  });

  Future<UserModel> signInWithGoogle();

  Future<void> logout();

  Future<UserModel> updateProfile({
    required String name,
    String? mobile,
    String? gender,
    DateTime? dateOfBirth,
    String? preferredLanguage,
  });

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  });

  Future<UserModel> linkGoogleAccount();

  Stream<UserModel?> get authStateChanges;
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final fb_auth.FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;
  final GoogleSignIn googleSignIn;

  AuthRemoteDataSourceImpl({
    required this.firebaseAuth,
    required this.firestore,
    required this.googleSignIn,
  });

  CollectionReference<Map<String, dynamic>> get _usersRef =>
      firestore.collection(FirestoreCollections.users);

  @override
  Future<UserModel> loginWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final doc = await _usersRef.doc(credential.user!.uid).get();
      if (!doc.exists) throw const AuthException('User profile not found.');
      return UserModel.fromMap(doc.data()!, doc.id);
    } on fb_auth.FirebaseAuthException catch (e) {
      throw AuthException(e.message ?? 'Login failed.');
    }
  }

  @override
  Future<UserModel> registerWithEmail({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    try {
      final credential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final model = UserModel(
        id: credential.user!.uid,
        name: name,
        email: email,
        role: role,
      );
      await _usersRef.doc(model.id).set(model.toMap());
      return model;
    } on fb_auth.FirebaseAuthException catch (e) {
      throw AuthException(e.message ?? 'Registration failed.');
    }
  }

  @override
  Future<UserModel> signInWithGoogle() async {
    try {
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null)
        throw const AuthException('Google sign-in cancelled.');

      final googleAuth = await googleUser.authentication;
      final credential = fb_auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final userCredential = await firebaseAuth.signInWithCredential(
        credential,
      );
      final uid = userCredential.user!.uid;

      final doc = await _usersRef.doc(uid).get();
      if (doc.exists) {
        return UserModel.fromMap(doc.data()!, doc.id);
      }

      final model = UserModel(
        id: uid,
        name: userCredential.user?.displayName ?? '',
        email: userCredential.user?.email ?? '',
        role: 'parent',
      );
      await _usersRef.doc(uid).set(model.toMap());
      return model;
    } on fb_auth.FirebaseAuthException catch (e) {
      throw AuthException(e.message ?? 'Google sign-in failed.');
    }
  }

  @override
  Future<void> logout() async {
    await googleSignIn.signOut();
    await firebaseAuth.signOut();
  }

  @override
  Future<UserModel> updateProfile({
    required String name,
    String? mobile,
    String? gender,
    DateTime? dateOfBirth,
    String? preferredLanguage,
  }) async {
    final user = firebaseAuth.currentUser;
    if (user == null) throw const AuthException('No signed-in user.');

    final data = <String, dynamic>{'name': name};
    if (mobile != null) data['mobile'] = mobile;
    if (gender != null) data['gender'] = gender;
    if (dateOfBirth != null)
      data['dateOfBirth'] = Timestamp.fromDate(dateOfBirth);
    if (preferredLanguage != null) data['preferredLanguage'] = preferredLanguage;

    try {
      await _usersRef.doc(user.uid).update(data);
      final doc = await _usersRef.doc(user.uid).get();
      return UserModel.fromMap(doc.data()!, doc.id);
    } catch (_) {
      throw const AuthException('Failed to update profile.');
    }
  }

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final user = firebaseAuth.currentUser;
    if (user == null || user.email == null) {
      throw const AuthException('No signed-in user.');
    }

    try {
      final credential = fb_auth.EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );
      // Firebase requires a recent login before allowing a password change.
      // Reauthenticating here is what satisfies that check.
      await user.reauthenticateWithCredential(credential);
      await user.updatePassword(newPassword);
    } on fb_auth.FirebaseAuthException catch (e) {
      throw AuthException(e.message ?? 'Failed to change password.');
    }
  }

  @override
  Stream<UserModel?> get authStateChanges {
    return firebaseAuth.authStateChanges().asyncMap((user) async {
      if (user == null) return null;
      final doc = await _usersRef.doc(user.uid).get();
      if (!doc.exists) return null;
      return UserModel.fromMap(doc.data()!, doc.id);
    });
  }
  
  @override
  Future<UserModel> linkGoogleAccount() async {
    final user = firebaseAuth.currentUser;
    if (user == null) throw const AuthException('No signed-in user.');

    try {
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        throw const AuthException('Google sign-in cancelled.');
      }

      final googleAuth = await googleUser.authentication;
      final credential = fb_auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await user.linkWithCredential(credential);

      final doc = await _usersRef.doc(user.uid).get();
      return UserModel.fromMap(doc.data()!, doc.id);
    } on fb_auth.FirebaseAuthException catch (e) {
      if (e.code == 'credential-already-in-use') {
        throw const AuthException(
          'This Google account is already linked to another user.',
        );
      }
      throw AuthException(e.message ?? 'Failed to link Google account.');
    }
  }
}
