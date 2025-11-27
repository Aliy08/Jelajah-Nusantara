import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

import '../screens/auth/login_screen.dart';
import '../services/auth_services.dart';
import '../widgets/bottom_navbar.dart';
import '../models/user_model.dart';
import 'package:http/http.dart' as http;


class AuthController {
  static Future<String> register(
    BuildContext context,
    String name,
    String username,
    String password,
  ) async {
    final result = await AuthServices.register(name, username, password);
    final responseData = jsonDecode(result.body);

    if (result.statusCode == 200) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
      return responseData ['message'] ?? "Registrasi berhasil";
    } else {
      if (result.statusCode == 400) {
        final firstError = responseData['errors'][0];
        return (firstError['message'] ?? "Terjadi Kesalahan");
      } else {
        return (responseData['message'] ?? "Terjadi Kesalahan");
      }
    }
  }

  static Future<String> login(
    BuildContext context,
    String username,
    String password,
  ) async {
    final result = await AuthServices.login(username, password);
    final responseData = jsonDecode(result.body);

    if (result.statusCode == 200) {

      // ambil token dari response
      final token = responseData['token'];

      // simpan ke shared_preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);

      Navigator.pushReplacement(
        context, 
        MaterialPageRoute(builder: (context) => const BottomNavbar()),
      );

      return responseData['message'] ?? "Login Berhasil";
    } else {
      if(result.statusCode == 400) {
        final firstError = responseData['errors'][0];
        return (firstError['message'] ?? "Terjadi kesalahan"); 
      }
      return (responseData['message'] ?? 'Login gagal');
    }
  }

  static Future<User> getProfile() async {
    final result = await AuthServices.getProfile();
    final responseData = jsonDecode(result.body);

    if (result.statusCode == 200) {
      final data = responseData['data'];
      return User.fromJson(data);
    } else {
      throw (responseData['message'] ?? "Gagal memuat data user");
    }
  }

  static Future<String> logout(BuildContext context) async {
    final result = await AuthServices.Logout();
    final responseData = jsonDecode(result.body);

    if (result.statusCode == 200) {
      Navigator.pushReplacement(
        context, 
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
      return responseData['message'] ?? "Logout berhasil";
    } else {
      return (responseData['message'] ?? "Terjadi kesalahan");
    }
  }

// UPDATE PROFILE SECARA LOCAL
static Future<String> updateProfileLocal({
  required String name,
  required String username,
}) async {
  return await AuthServices.saveLocalProfile(name, username);
}

// GET PROFILE DARI LOCAL
static Future<User> getLocalProfile() async {
  final data = await AuthServices.getLocalProfile();

  return User(
    id: "0", // harus string, karena model kamu butuh String id
    name: data['name']!,
    username: data['username']!,
  );
}


}