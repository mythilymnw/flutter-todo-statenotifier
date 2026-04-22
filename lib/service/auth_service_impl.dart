import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/auth_service.dart';
import '../model/user_model.dart';

class AuthServiceImpl implements AuthService {
  static const String userKey = "user";
  static const String currentUserKey = "current_user";

  final StreamController<AppUser?> _controller =
      StreamController<AppUser?>.broadcast();

  AppUser? _currentUser;

 
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(currentUserKey);

    if (data != null) {
      _currentUser = AppUser.fromJson(jsonDecode(data));
      _controller.add(_currentUser);
    } else {
      _controller.add(null);
    }
  }

  
  @override
  Future<AppUser?> register(
      String name, String email, String password) async {
    final prefs = await SharedPreferences.getInstance();

   
    final existing = prefs.getString(userKey);
    if (existing != null) {
      final decoded = jsonDecode(existing);
      if (decoded['email'] == email) {
        throw Exception("User already exists");
      }
    }

    final user = AppUser((b) => b
      ..uid = DateTime.now().millisecondsSinceEpoch.toString()
      ..name = name
      ..email = email
      ..createdAt = DateTime.now().toIso8601String()
      ..updatedAt = DateTime.now().toIso8601String(),
    );

    
    final data = {
      ...user.toJson(),
      "password": password,
    };

    await prefs.setString(userKey, jsonEncode(data));

    /
    await prefs.setString(currentUserKey, jsonEncode(user.toJson()));

    _currentUser = user;
    _controller.add(user);

    return user;
  }

  
  @override
  Future<AppUser?> login(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(userKey);

    if (data == null) {
      throw Exception("No user found");
    }

    final decoded = jsonDecode(data);

    if (decoded['email'] == email &&
        decoded['password'] == password) {
      final user = AppUser.fromJson(decoded);

      await prefs.setString(currentUserKey, jsonEncode(user.toJson()));

      _currentUser = user;
      _controller.add(user);

      return user;
    }

    throw Exception("Invalid credentials");
  }

  
  @override
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(currentUserKey);

    _currentUser = null;
    _controller.add(null);
  }

  
  @override
  Stream<AppUser?> authState() => _controller.stream;
}