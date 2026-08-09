import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/models.dart';
import '../../../core/services/mock_data_service.dart';
import '../../../core/services/api_service.dart';

final profileProvider =
    StateNotifierProvider<ProfileNotifier, AsyncValue<ProfileData>>((ref) {
  final api = ref.watch(apiServiceProvider);
  return ProfileNotifier(api);
});

class ProfileNotifier extends StateNotifier<AsyncValue<ProfileData>> {
  final ApiService _api;

  ProfileNotifier(this._api) : super(const AsyncValue.loading()) {
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final response = await _api.get('/students/me');
      // In real implementation we would parse: final user = User.fromJson(json.decode(response.body));
    } catch (_) {}
    
    await Future.delayed(const Duration(milliseconds: 400));
    final user = MockDataService.users.first;
    final college =
        MockDataService.colleges.firstWhere((c) => c.id == user.collegeId);
    final followedClubs = MockDataService.clubs
        .where((c) => user.followedClubs.contains(c.id))
        .toList();
    final eventsAttended =
        MockDataService.events.where((e) => e.isRegistered && e.isPast).length;

    state = AsyncValue.data(ProfileData(
      user: user,
      college: college,
      followedClubs: followedClubs,
      eventsAttended: eventsAttended,
      applications: MockDataService.applications,
    ));
  }

  Future<void> updateUser(AppUser newUser) async {
    final oldData = state.valueOrNull;
    if (oldData == null) return;

    state = const AsyncValue.loading();
    
    try {
      // Real API Update
      await _api.patch('/students/me', {
        'bio': newUser.bio,
        'githubUrl': newUser.githubUrl,
        'linkedinUrl': newUser.linkedinUrl,
        'leetcodeUrl': newUser.leetcodeUrl,
        'hackerrankUrl': newUser.hackerrankUrl,
      });

      state = AsyncValue.data(oldData.copyWith(user: newUser));
    } catch (e, stack) {
      // Fallback for demo
      state = AsyncValue.data(oldData.copyWith(user: newUser));
    }
  }
}


class ProfileData {
  final AppUser user;
  final College college;
  final List<Club> followedClubs;
  final int eventsAttended;
  final List<Application> applications;

  const ProfileData({
    required this.user,
    required this.college,
    required this.followedClubs,
    required this.eventsAttended,
    required this.applications,
  });
  ProfileData copyWith({
    AppUser? user,
    College? college,
    List<Club>? followedClubs,
    int? eventsAttended,
    List<Application>? applications,
  }) {
    return ProfileData(
      user: user ?? this.user,
      college: college ?? this.college,
      followedClubs: followedClubs ?? this.followedClubs,
      eventsAttended: eventsAttended ?? this.eventsAttended,
      applications: applications ?? this.applications,
    );
  }
}
