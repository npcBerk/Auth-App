import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:auth_app/service.dart';

final authProvider = StateNotifierProvider<AuthNotifier, String?>((ref) {
  return AuthNotifier();
});

class AuthNotifier extends StateNotifier<String?> {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  AuthNotifier() : super(null) {
    _loadToken();
  }

  Future<void> _loadToken() async {
    String? token = await _storage.read(key: 'token');
    state = token;
  }

  Future<bool> login(String username, String password) async {
    try {
      final response = await Service.request(
        'POST',
        'https://fakestoreapi.com/auth/login',
        data: {'username': username, 'password': password},
      );

      if (response.statusCode == 200) {
        await _storage.write(key: 'token', value: response.data['token']);
        state = response.data['token'];
        return true;
      } else {
        print('Login failed: ${response.statusMessage}');
        return false;
      }
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }

  Future<void> logout() async {
    await _storage.delete(key: 'token');
    state = null;
  }

  bool isLoggedIn() {
    return state != null;
  }

  Future<String?> getTokenDetails() async {
    return await _storage.read(key: 'token');
  }
}
