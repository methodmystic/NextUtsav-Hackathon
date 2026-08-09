import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LocalStorageService {
  static const _isLoggedInKey = 'is_logged_in';
  static const _tokenKey = 'auth_token';
  static const _collegeKey = 'selected_college_id';
  static const _userInterestsKey = 'user_interests';

  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> setLoggedIn(bool value) async {
    await _prefs.setBool(_isLoggedInKey, value);
  }

  bool isLoggedIn() {
    return _prefs.getBool(_isLoggedInKey) ?? false;
  }

  Future<void> setToken(String token) async {
    await _prefs.setString(_tokenKey, token);
  }

  String? getToken() {
    return _prefs.getString(_tokenKey);
  }

  Future<void> setSelectedCollege(String collegeId) async {
    await _prefs.setString(_collegeKey, collegeId);
  }

  String? getSelectedCollege() {
    return _prefs.getString(_collegeKey);
  }

  Future<void> setUserInterests(List<String> interests) async {
    await _prefs.setStringList(_userInterestsKey, interests);
  }

  List<String> getUserInterests() {
    return _prefs.getStringList(_userInterestsKey) ?? [];
  }

  Future<void> clearAll() async {
    await _prefs.clear();
  }
}

// This provider now handles the initialization future
final localStorageInitProvider = FutureProvider<LocalStorageService>((ref) async {
  final service = LocalStorageService();
  await service.init();
  return service;
});

// A convenient way to access the service once initialized
final localStorageProvider = Provider<LocalStorageService>((ref) {
  return ref.watch(localStorageInitProvider).requireValue;
});
