import '../../../core/services/api_service.dart';

final clubDetailProvider = Provider.family<Club?, String>((ref, clubId) {
  return MockDataService.clubs.where((c) => c.id == clubId).firstOrNull;
});

final clubPostsProvider = Provider.family<List<Post>, String>((ref, clubId) {
  return MockDataService.posts.where((p) => p.clubId == clubId).toList();
});

final clubEventsProvider = Provider.family<List<Event>, String>((ref, clubId) {
  return MockDataService.events.where((e) => e.clubId == clubId).toList();
});

final clubFollowProvider = StateNotifierProvider.family<ClubFollowNotifier, bool, String>((ref, clubId) {
  final api = ref.watch(apiServiceProvider);
  final isInitialFollowed = MockDataService.users.first.followedClubs.contains(clubId);
  return ClubFollowNotifier(api, clubId, isInitialFollowed);
});

class ClubFollowNotifier extends StateNotifier<bool> {
  final ApiService _api;
  final String _clubId;

  ClubFollowNotifier(this._api, this._clubId, bool initialState) : super(initialState);

  Future<void> toggleFollow() async {
    final newState = !state;
    state = newState;

    try {
      // In a real app we would get current followed clubs and add/remove this one
      await _api.patch('/students/me', {
        'followedClubsAction': newState ? 'FOLLOW' : 'UNFOLLOW',
        'targetClubId': _clubId,
      });
    } catch (e) {
      // Fallback
    }
  }
}

