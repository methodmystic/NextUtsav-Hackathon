import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/shared_widgets.dart';
import '../../feed/providers/feed_provider.dart';
import '../../feed/widgets/post_card.dart';

class SavedPostsScreen extends ConsumerWidget {
  const SavedPostsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postsAsync = ref.watch(feedPostsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      appBar: AppBar(
        title: const Text('Saved Content', style: TextStyle(fontWeight: FontWeight.w900)),
      ),
      body: postsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (posts) {
          final savedPosts = posts.where((p) => p.isSaved).toList();

          if (savedPosts.isEmpty) {
            return const EmptyStateWidget(
              icon: Icons.bookmark_outline_rounded,
              title: 'Nothing saved yet',
              message: 'Save interesting posts to see them here',
            );
          }

          return ListView.builder(
            itemCount: savedPosts.length,
            itemBuilder: (context, index) {
              return PostCard(
                post: savedPosts[index],
                onLike: () => ref.read(feedPostsProvider.notifier).toggleLike(savedPosts[index].id),
                onSave: () => ref.read(feedPostsProvider.notifier).toggleSave(savedPosts[index].id),
              );
            },
          );
        },
      ),
    );
  }
}
