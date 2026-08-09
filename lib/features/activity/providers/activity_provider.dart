import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/models.dart';
import '../../../core/services/mock_data_service.dart';

final activityProvider = FutureProvider<ActivityData>((ref) async {
  await Future.delayed(const Duration(milliseconds: 600));
  final user = MockDataService.users.first;
  final badges = MockDataService.badges;
  final earnedBadges = badges.where((b) => user.badges.contains(b.id)).toList();
  final certs = MockDataService.certificates;
  final pastEvents = MockDataService.events.where((e) => e.isPast && e.isRegistered).toList();

  return ActivityData(
    xpPoints: user.xpPoints,
    level: (user.xpPoints / 500).floor() + 1,
    xpToNextLevel: 500 - (user.xpPoints % 500),
    earnedBadges: earnedBadges,
    allBadges: badges,
    certificates: certs,
    eventHistory: pastEvents,
  );
});

class ActivityData {
  final int xpPoints;
  final int level;
  final int xpToNextLevel;
  final List<Badge> earnedBadges;
  final List<Badge> allBadges;
  final List<Certificate> certificates;
  final List<Event> eventHistory;

  const ActivityData({
    required this.xpPoints,
    required this.level,
    required this.xpToNextLevel,
    required this.earnedBadges,
    required this.allBadges,
    required this.certificates,
    required this.eventHistory,
  });
}
