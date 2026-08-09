import 'models.dart';

class ClassLecture {
  final String id;
  final String branch;
  final String division;
  final String subject;
  final int dayOfWeek; // 1 = Monday, 7 = Sunday
  final DateTime startTime;
  final DateTime endTime;

  const ClassLecture({
    required this.id,
    required this.branch,
    required this.division,
    required this.subject,
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
  });
}

class CollegeCalendarItem {
  final String id;
  final String title;
  final String type; // 'Exam', 'Holiday', 'Event'
  final DateTime date;
  final String description;

  const CollegeCalendarItem({
    required this.id,
    required this.title,
    required this.type,
    required this.date,
    required this.description,
  });
}

class UserCredits {
  final String uid;
  final int technicalCredits;
  final int culturalCredits;
  final int sportsCredits;

  const UserCredits({
    required this.uid,
    this.technicalCredits = 0,
    this.culturalCredits = 0,
    this.sportsCredits = 0,
  });
}

class EventAttendance {
  final String eventId;
  final String studentUid;
  final DateTime checkInTime;
  final String? certificateUrl;

  const EventAttendance({
    required this.eventId,
    required this.studentUid,
    required this.checkInTime,
    this.certificateUrl,
  });
}

enum AttendanceStatus { present, absent, late }

class AttendanceRecord {
  final String id;
  final String subject;
  final DateTime date;
  final AttendanceStatus status;
  final String? remarks;

  const AttendanceRecord({
    required this.id,
    required this.subject,
    required this.date,
    required this.status,
    this.remarks,
  });

  factory AttendanceRecord.fromJson(Map<String, dynamic> json) {
    return AttendanceRecord(
      id: json['_id'] ?? '',
      subject: json['subject'] ?? '',
      date: DateTime.parse(json['date']),
      status: _parseStatus(json['status']),
      remarks: json['remarks'],
    );
  }

  static AttendanceStatus _parseStatus(String status) {
    switch (status.toLowerCase()) {
      case 'present': return AttendanceStatus.present;
      case 'late': return AttendanceStatus.late;
      default: return AttendanceStatus.absent;
    }
  }
}
