import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/academic_models.dart';
import '../services/api_service.dart';

class AttendanceService {
  final ApiService _api;

  AttendanceService(this._api);

  Future<List<AttendanceRecord>> getMyAttendance(String studentId) async {
    try {
      final response = await _api.get('/attendance/student/$studentId');
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> records = data['data'];
        return records.map((json) => AttendanceRecord.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<bool> markAttendance({
    required String studentId,
    required String subject,
    required AttendanceStatus status,
    String? remarks,
  }) async {
    try {
      final response = await _api.post('/attendance', {
        'studentId': studentId,
        'subject': subject,
        'status': status.name.capitalize(),
        'remarks': remarks,
      });
      return response.statusCode == 201;
    } catch (e) {
      return false;
    }
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}

final attendanceServiceProvider = Provider<AttendanceService>((ref) {
  final api = ref.watch(apiServiceProvider);
  return AttendanceService(api);
});

final attendanceRecordsProvider = FutureProvider.family<List<AttendanceRecord>, String>((ref, studentId) async {
  final service = ref.watch(attendanceServiceProvider);
  return service.getMyAttendance(studentId);
});
