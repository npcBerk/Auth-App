import 'package:auth_app/service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:auth_app/providers/auth.provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthService {
  final FlutterSecureStorage _storage = FlutterSecureStorage();
  final ProviderReference ref;

  AuthService(this.ref);

  Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: 'token');
    return token != null;
  }

  Future<void> logout() async {
    await _storage.delete(key: 'token');
    ref.read(authProvider.notifier).logout();
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
        ref.read(authProvider.notifier).login(response.data['token']);
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

  Future<String?> getTokenDetails() async {
    return await _storage.read(key: 'token');
  }
}
