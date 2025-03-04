import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/auth.service.dart';

final authProvider = StateNotifierProvider<AuthNotifier, bool>((ref) {
  return AuthNotifier();
});

class AuthNotifier extends StateNotifier<bool> {
  AuthNotifier() : super(false) {
    checkLoginStatus();
  }

  // Uygulama açıldığında token var mı kontrol et
  Future<void> checkLoginStatus() async {
    state = await AuthService.isLoggedIn();
  }

  // Kullanıcı giriş yaparsa state'i güncelle
  Future<bool> login(String username, String password) async {
    final success = await AuthService.login(username, password);
    if (success) {
      state = true;
    }
    return success;
  }

  // Kullanıcı kayıt olursa state'i güncelle
  Future<bool> signup(String username, String password) async {
    final success = await AuthService.signup(username, password);
    if (success) {
      state = true;
    }
    return success;
  }

  // Kullanıcı çıkış yaparsa state'i güncelle
  Future<void> logout() async {
    await AuthService.logout();
    state = false;
  }

  // Token var mı kontrol et
  Future<String?> getToken() async {
    final loggedIn = await AuthService.getToken();
    return loggedIn;
  }
}
