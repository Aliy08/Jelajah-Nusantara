import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

class AuthServices {
  static String baseUrl = 'https://api-pariwisata.rakryan.id/auth';

  static Future<http.Response> register(
    String name,
    String username,
    String password,
  ) async {
    final url = Uri.parse("$baseUrl/register");

    return await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "name": name,
        "username": username,
        "password": password,
      }),
    );
  }

  static Future<http.Response> login(String username, String password) async {
    final url = Uri.parse('$baseUrl/login');

    return await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );
  }

  static Future<http.Response> getProfile() async {
    final url = Uri.parse("$baseUrl/profile");

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    return await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });
  }

  static Future<http.Response> Logout() async {
    final url = Uri.parse("$baseUrl/logout");

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    return await http.post(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });
  }

  // SIMPAN PROFILE KE LOCAL
static Future<String> saveLocalProfile(String name, String username) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('local_name', name);
  await prefs.setString('local_username', username);
  return "Profil berhasil disimpan";
}

// AMBIL PROFILE DARI LOCAL
static Future<Map<String, String>> getLocalProfile() async {
  final prefs = await SharedPreferences.getInstance();
  return {
    'name': prefs.getString('local_name') ?? "",
    'username': prefs.getString('local_username') ?? "",
  };
}



}
