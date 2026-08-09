import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'local_storage_service.dart';

/// Central API Service to handle all backend communication with automatic auth headers.
class ApiService {
  final LocalStorageService _storage;
  // Use http://10.0.2.2 for Android Emulator, localhost for others
  // In production, this would be your real domain
  static const String baseUrl = 'http://10.0.2.2:5000/api';

  ApiService(this._storage);

  Map<String, String> get _headers {
    final token = _storage.getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<http.Response> get(String endpoint) async {
    return http.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: _headers,
    ).timeout(const Duration(seconds: 5));
  }

  Future<http.Response> post(String endpoint, Map<String, dynamic> body) async {
    return http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: _headers,
      body: json.encode(body),
    ).timeout(const Duration(seconds: 5));
  }

  Future<http.Response> patch(String endpoint, [Map<String, dynamic>? body]) async {
    return http.patch(
      Uri.parse('$baseUrl$endpoint'),
      headers: _headers,
      body: body != null ? json.encode(body) : null,
    ).timeout(const Duration(seconds: 5));
  }

  Future<http.Response> delete(String endpoint) async {
    return http.delete(
      Uri.parse('$baseUrl$endpoint'),
      headers: _headers,
    ).timeout(const Duration(seconds: 5));
  }
}

final apiServiceProvider = Provider<ApiService>((ref) {
  final storage = ref.watch(localStorageProvider);
  return ApiService(storage);
});
