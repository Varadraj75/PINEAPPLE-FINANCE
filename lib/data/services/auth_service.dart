import 'package:shared_preferences/shared_preferences.dart';
import '../database/database_helper.dart';
import '../models/user_model.dart';

class AuthService {
  static final AuthService instance = AuthService._init();
  AuthService._init();

  Future<bool> register(String name, String email, String password) async {
    try {
      final existingUser = await DatabaseHelper.instance.getUserByEmail(email);
      if (existingUser != null) {
        return false;
      }

      final user = UserModel(
        name: name,
        email: email,
        password: password,
      );

      await DatabaseHelper.instance.createUser(user);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<UserModel?> login(String email, String password) async {
    try {
      final user = await DatabaseHelper.instance.getUserByEmail(email);
      if (user != null && user.password == password) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt('userId', user.id!);
        await prefs.setString('userName', user.name);
        await prefs.setString('userEmail', user.email);
        return user;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('userId');
  }

  Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userName');
  }

  Future<String?> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userEmail');
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
