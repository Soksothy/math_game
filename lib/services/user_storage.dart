import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:math_game/models/user_model.dart';

class UserStorage {
  static const String _userKey = 'user_data';

  static Future<void> saveUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    final userData = jsonEncode(user.toJson());
    await prefs.setString(_userKey, userData);
  }

  static Future<UserModel?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString(_userKey);
    if (userData != null) {
      final Map<String, dynamic> userMap = jsonDecode(userData);
      return UserModel.fromJson(userMap);
    } else {
      return null;
    }
  }
}
