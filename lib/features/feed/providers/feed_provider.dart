import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/models.dart';
import '../../../core/services/mock_data_service.dart';
import '../../../core/services/api_service.dart';

/// Feed posts provider with like toggle support.
final feedPostsProvider =
    StateNotifierProvider<FeedPostsNotifier, AsyncValue<List<Post>>>((ref) {
  final api = ref.watch(apiServiceProvider);
  return FeedPostsNotifier(api);
});

class FeedPostsNotifier extends StateNotifier<AsyncValue<List<Post>>> {
  final ApiService _api;

  FeedPostsNotifier(this._api) : super(const AsyncValue.loading()) {
    _loadPosts();
  }

  Future<void> _loadPosts() async {
    try {
      final response = await _api.get('/posts');
          
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List postsJson = data['data'] ?? [];
        
        if (postsJson.isNotEmpty) {
          final parsedPosts = postsJson.map((json) => Post.fromJson(json)).toList();
          state = AsyncValue.data(parsedPosts);
          return;
        }
      }
    } catch (e) {
      print('ℹ️ [FEED] Backend unreachable, using demo data: $e');
    }
    
    // Fallback to beautiful mock data
    state = AsyncValue.data(List.from(MockDataService.posts));
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    await _loadPosts();
  }

  Future<void> toggleLike(String postId) async {
    final currentPosts = state.value;
    if (currentPosts == null) return;

    // Optimistic Update
    state = AsyncValue.data(
      currentPosts.map((p) {
        if (p.id == postId) {
          return p.copyWith(
            isLiked: !p.isLiked,
            likeCount: p.isLiked ? p.likeCount - 1 : p.likeCount + 1,
          );
        }
        return p;
      }).toList(),
    );

    try {
      await _api.patch('/posts/$postId/like');
    } catch (e) {
      // Revert if failed
      state = AsyncValue.data(currentPosts);
    }
  }

  Future<void> toggleSave(String postId) async {
    final currentPosts = state.value;
    if (currentPosts == null) return;

    // Optimistic Update
    state = AsyncValue.data(
      currentPosts.map((p) {
        if (p.id == postId) {
          return p.copyWith(isSaved: !p.isSaved);
        }
        return p;
      }).toList(),
    );

    try {
      await _api.patch('/posts/$postId/save');
    } catch (e) {
      // Revert if failed
      state = AsyncValue.data(currentPosts);
    }
  }
}

/// 24h Backend Stories Provider.
final storiesProvider = FutureProvider<List<dynamic>>((ref) async {
  try {
    final api = ref.watch(apiServiceProvider);
    final response = await api.get('/stories');
    return response['data'] ?? [];
  } catch (e) {
    // Fallback to mock data structure for demo
    return MockDataService.clubs.map((c) => {
      'id': c.id,
      'name': c.name,
      'avatarUrl': c.logoUrl,
      'stories': [{'imageUrl': 'https://images.unsplash.com/photo-1540317580384-e5d43616b9aa'}]
    }).toList();
  }
});


