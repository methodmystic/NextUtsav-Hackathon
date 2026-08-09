import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/local_storage_service.dart';
import '../../../core/services/analytics_service.dart';
import '../../../core/services/api_service.dart';

class AuthNotifier extends StateNotifier<bool> {
  final LocalStorageService _storage;
  final AnalyticsService _analytics;
  final ApiService _api;

  AuthNotifier(this._storage, this._analytics, this._api) : super(_storage.isLoggedIn());

  Future<bool> login(String email, String password) async {
    try {
      final response = await _api.post('/auth/login', {
        'email': email,
        'password': password,
      });

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final token = data['token'];
        if (token != null) {
          await _storage.setToken(token);
          await _storage.setLoggedIn(true);
          state = true;
          return true;
        }
      }
    } catch (e) {
      // Backend unreachable -> Fallback for demo
      print('ℹ️ [AUTH] Backend unreachable, using demo mode: $e');
      await _storage.setLoggedIn(true);
      state = true;
      return true;
    }
    return false;
  }

  Future<bool> signup(String email, String password, String name) async {
    try {
      final response = await _api.post('/auth/register', {
        'name': name,
        'email': email,
        'password': password,
        'role': 'STUDENT',
      });

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        final token = data['token'];
        if (token != null) {
          await _storage.setToken(token);
          await _storage.setLoggedIn(true);
          state = true;
          await _analytics.logSignUp(method: 'email_auth');
          return true;
        }
      }
    } catch (e) {
      print('ℹ️ [AUTH] Backend unreachable, using demo mode: $e');
      await _storage.setLoggedIn(true);
      state = true;
      await _analytics.logSignUp(method: 'mock_demo_auth');
      return true;
    }
    return false;
  }

  Future<void> logout() async {
    await _storage.clearAll();
    state = false;
  }
}


