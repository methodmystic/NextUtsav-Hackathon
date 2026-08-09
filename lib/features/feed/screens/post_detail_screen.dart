import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_utils.dart';
import '../../../core/widgets/shared_widgets.dart';
import '../widgets/like_button.dart';
import '../providers/feed_provider.dart';

class PostDetailScreen extends ConsumerWidget {
  final String postId;
  const PostDetailScreen({super.key, required this.postId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postsAsync = ref.watch(feedPostsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Post')),
      body: postsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (posts) {
          final post = posts.where((p) => p.id == postId).firstOrNull;
          if (post == null) {
            return const EmptyStateWidget(
              icon: Icons.article_outlined,
              title: 'Post not found',
              message: 'This post may have been removed',
            );
          }

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Club header
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            ClubAvatar(
                              name: post.clubName,
                              imageUrl: post.clubLogoUrl,
                              size: 44,
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  post.clubName,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600, fontSize: 15),
                                ),
                                Text(
                                  AppUtils.timeAgo(post.createdAt),
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
      
                      // Image
                      AspectRatio(
                        aspectRatio: 4 / 3,
                        child: Image.network(
                          post.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: AppColors.surfaceVariant,
                            child: const Icon(Icons.image_outlined, size: 48),
                          ),
                        ),
                      ),
      
                      // Actions
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        child: Row(
                          children: [
                            AnimatedLikeButton(
                              isLiked: post.isLiked,
                              likeCount: post.likeCount,
                              onTap: () => ref
                                  .read(feedPostsProvider.notifier)
                                  .toggleLike(post.id),
                            ),
                            const Spacer(),
                            IconButton(
                              icon: Icon(
                                post.isSaved ? Icons.bookmark_rounded : Icons.bookmark_outline,
                                color: post.isSaved ? AppColors.primary : null,
                              ),
                              onPressed: () => ref
                                  .read(feedPostsProvider.notifier)
                                  .toggleSave(post.id),
                            ),
                            IconButton(
                              icon: const Icon(Icons.share_outlined),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ),
      
                      // Caption
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
                        child: Text(
                          '${AppUtils.formatNumber(post.likeCount)} likes',
                          style: const TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 14),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        child: RichText(
                          text: TextSpan(
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontSize: 14,
                                  color: Theme.of(context).textTheme.bodyLarge?.color,
                                ),
                            children: [
                              TextSpan(
                                text: '${post.clubName} ',
                                style: const TextStyle(fontWeight: FontWeight.w700),
                              ),
                              TextSpan(text: post.caption),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                        child: Text(
                          'View all ${post.commentCount} comments',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppColors.textTertiary,
                              ),
                        ),
                      ),
                      // Mock Comments
                      _CommentTile(
                        user: 'Siddharth M.',
                        comment: 'This event looks amazing! Will definitely attend. 🔥',
                        time: '2h',
                      ),
                      _CommentTile(
                        user: 'Riya G.',
                        comment: 'Can we bring non-DYPCOE friends?',
                        time: '1h',
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                        child: Text(
                          AppUtils.formatDateTime(post.createdAt),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                fontSize: 11,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Comment Input
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  border: Border(top: BorderSide(color: Colors.grey.shade200)),
                ),
                child: SafeArea(
                  child: Row(
                    children: [
                      const CircleAvatar(radius: 18, child: Icon(Icons.person, size: 20)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Add a comment...',
                            border: InputBorder.none,
                            hintStyle: TextStyle(color: AppColors.textTertiary, fontSize: 14),
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text('Post', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _CommentTile extends StatelessWidget {
  final String user;
  final String comment;
  final String time;

  const _CommentTile({
    required this.user,
    required this.comment,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: AppColors.primary.withOpacity(0.1),
            child: Text(user[0], style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primary)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 13),
                    children: [
                      TextSpan(text: '$user ', style: const TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text: comment),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Text(time, style: TextStyle(color: AppColors.textTertiary, fontSize: 11)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
