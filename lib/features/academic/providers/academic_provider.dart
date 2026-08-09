import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/models.dart';
import '../../../core/services/mock_data_service.dart';

final collegeCalendarProvider = Provider<List<CollegeCalendarItem>>((ref) {
  return MockDataService.calendarItems;
});

final userCreditsProvider = Provider<UserCredits>((ref) {
  return const UserCredits(
    uid: 'u1',
    technicalCredits: 12,
    culturalCredits: 4,
    sportsCredits: 2,
  );
});

final facultyClubsProvider = Provider<List<Club>>((ref) {
  // Mocking assuming current user is Faculty for testing
  return MockDataService.clubs.where((c) => c.id == 'gdgc-dypcoe').toList();
});
