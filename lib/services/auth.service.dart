import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../service.dart';

class AuthService {
  static const String _baseUrl = 'https://fakestoreapi.com/auth';
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  // Kullanıcı Girişi (Login)
  static Future<bool> login(String username, String password) async {
    try {
      final response = await Service.request(
        'POST',
        '$_baseUrl/login',
        data: {'username': username, 'password': password},
      );

      if (response.statusCode == 200 && response.data['token'] != null) {
        await _storage.write(key: 'auth_token', value: response.data['token']);
        return true;
      }
      return false;
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }

  // Kullanıcı Kaydı (Signup)
  static Future<bool> signup(String username, String password) async {
    try {
      final response = await Service.request(
        'POST',
        'https://fakestoreapi.com/users',
        data: {'username': username, 'password': password},
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Signup error: $e');
      return false;
    }
  }

  // Kullanıcı Çıkışı (Logout)
  static Future<void> logout() async {
    await _storage.delete(key: 'auth_token');
  }

  // Token Kontrolü
  static Future<bool> isLoggedIn() async {
    String? token = await _storage.read(key: 'auth_token');
    return token != null;
  }

  // Token Okuma
  static Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }
}
