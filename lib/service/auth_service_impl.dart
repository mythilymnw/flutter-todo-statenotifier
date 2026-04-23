import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/auth_service.dart';
import '../model/user_model.dart';
import '../model/serializers.dart';

class AuthServiceImpl implements AuthService {
  static const String usersKey = "users";
  static const String currentUserKey = "current_user";

  final StreamController<AppUser?> _controller =
      StreamController<AppUser?>.broadcast();

  AppUser? _currentUser;

  /// INIT (App start)
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(currentUserKey);

    if (data != null) {
      final decoded = jsonDecode(data);
      _currentUser = serializers.deserializeWith(AppUser.serializer, decoded);
      _controller.add(_currentUser);
    } else {
      _controller.add(null);
    }
  }

  /// REGISTER
  @override
  Future<AppUser?> register(String name, String email, String password) async {
    final prefs = await SharedPreferences.getInstance();

    final usersString = prefs.getString(usersKey);
    List users = usersString != null ? jsonDecode(usersString) : [];

    /// Check existing user
    final exists = users.any((u) => u['email'] == email);
    if (exists) {
      throw Exception("User already exists");
    }

    final user = AppUser(
      (b) => b
        ..uid = DateTime.now().millisecondsSinceEpoch.toString()
        ..name = name
        ..email = email
        ..createdAt = DateTime.now().toIso8601String()
        ..updatedAt = DateTime.now().toIso8601String(),
    );

    final userData = {
      ...serializers.serializeWith(AppUser.serializer, user)
          as Map<String, dynamic>,
      "password": password,
    };

    users.add(userData);

    await prefs.setString(usersKey, jsonEncode(users));

    /// Save current user (without password)
    await prefs.setString(
      currentUserKey,
      jsonEncode(serializers.serializeWith(AppUser.serializer, user)),
    );

    _currentUser = user;
    _controller.add(user);

    return user;
  }

  /// LOGIN
  @override
  Future<AppUser?> login(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final usersString = prefs.getString(usersKey);

    if (usersString == null) {
      throw Exception("No users found");
    }

    final List users = jsonDecode(usersString);

    final matchedUser = users.firstWhere(
      (u) => u['email'] == email && u['password'] == password,
      orElse: () => throw Exception("Invalid credentials"),
    );

    final user = serializers.deserializeWith(AppUser.serializer, matchedUser);

    await prefs.setString(
      currentUserKey,
      jsonEncode(serializers.serializeWith(AppUser.serializer, user)),
    );

    _currentUser = user;
    _controller.add(user);

    return user;
  }

  /// LOGOUT
  @override
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(currentUserKey);

    _currentUser = null;
    _controller.add(null);
  }

  /// AUTH STATE
  @override
  Stream<AppUser?> authState() => _controller.stream;

  /// DISPOSE
  void dispose() {
    _controller.close();
  }
}
