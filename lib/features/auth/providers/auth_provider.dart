import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/auth_notifier.dart';
import '../../../core/services/local_storage_service.dart';
import '../../../core/services/analytics_service.dart';

/// Whether user is logged in (persistent).
final isLoggedInProvider = StateNotifierProvider<AuthNotifier, bool>((ref) {
  final storage = ref.watch(localStorageProvider);
  final analytics = ref.watch(analyticsServiceProvider);
  final api = ref.watch(apiServiceProvider);
  return AuthNotifier(storage, analytics, api);
});

/// Selected college during onboarding (persistent).
final selectedCollegeProvider = StateProvider<String?>((ref) {
  final storage = ref.watch(localStorageProvider);
  return storage.getSelectedCollege();
});

/// Selected interest tags during onboarding (persistent).
final selectedInterestsProvider = StateProvider<List<String>>((ref) {
  final storage = ref.watch(localStorageProvider);
  return storage.getUserInterests();
});

/// Clubs followed during onboarding flow.
final onboardingFollowedClubsProvider = StateProvider<List<String>>((ref) => []);

