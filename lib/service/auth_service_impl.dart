import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../core/auth_service.dart';
import '../model/user_model.dart';
import '../model/serializers.dart';

class AuthServiceImpl implements AuthService {
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  @override
  Future<AppUser?> register(String name, String email, String password) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = AppUser((b) => b
      ..uid = cred.user!.uid
      ..name = name
      ..email = email
      ..createdAt = DateTime.now().toIso8601String()
      ..updatedAt = DateTime.now().toIso8601String());

    final json = serializers.serializeWith(
      AppUser.serializer,
      user,
    );

    await _db.collection('users').doc(user.uid).set(json as Map<String, dynamic>);

    return user;
  }

  @override
  Future<AppUser?> login(String email, String password) async {
    final cred = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final doc = await _db.collection('users').doc(cred.user!.uid).get();

    final data = {
      ...doc.data()!,
      'uid': doc.id,
    };

    return serializers.deserializeWith(
      AppUser.serializer,
      data,
    );
  }

  @override
  Future<void> logout() => _auth.signOut();

  @override
  Stream<AppUser?> authState() {
    return _auth.authStateChanges().asyncMap((user) async {
      if (user == null) return null;

      final doc = await _db.collection('users').doc(user.uid).get();

      final data = {
        ...doc.data()!,
        'uid': doc.id,
      };

      return serializers.deserializeWith(
        AppUser.serializer,
        data,
      );
    });
  }
}