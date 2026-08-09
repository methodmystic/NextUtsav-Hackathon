import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/models/models.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_utils.dart';
import '../../../core/widgets/shared_widgets.dart';
import 'like_button.dart';

import 'comments_sheet.dart';

class PostCard extends StatelessWidget {
  final Post post;
  final VoidCallback? onLike;
  final VoidCallback? onSave;
  final VoidCallback? onTap;
  final VoidCallback? onClubTap;

  const PostCard({
    super.key,
    required this.post,
    this.onLike,
    this.onSave,
    this.onTap,
    this.onClubTap,
  });

  void _showComments(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CommentsBottomSheet(postId: post.id),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBackground : Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Club header - Premium Alignment
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                GestureDetector(
                  onTap: onClubTap,
                  child: Container(
                    padding: const EdgeInsets.all(1.5),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: AppColors.primaryGradient,
                    ),
                    child: CircleAvatar(
                      radius: 17,
                      backgroundColor: Colors.white,
                      child: ClubAvatar(
                        name: post.clubName,
                        imageUrl: post.clubLogoUrl,
                        size: 32,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            post.clubName,
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 14,
                              letterSpacing: -0.3,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.verified, size: 14, color: AppColors.primary),
                        ],
                      ),
                      Text(
                        post.isEvent ? '📍 DYPCOE • Major Event' : '📍 DYPCOE Akurdi',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  icon: const Icon(Icons.more_horiz_rounded, size: 22),
                  onPressed: () {},
                ),
              ],
            ),
          ),

          // Post image - Cached & Animated
          GestureDetector(
            onTap: onTap,
            onDoubleTap: onLike,
            child: AspectRatio(
              aspectRatio: 1,
              child: CachedNetworkImage(
                imageUrl: post.imageUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => const SkeletonLoader(height: 400),
                errorWidget: (context, url, error) => Container(
                  color: AppColors.surfaceVariant,
                  child: const Center(
                    child: Icon(Icons.broken_image_outlined, size: 40, color: AppColors.textTertiary),
                  ),
                ),
              ).animate().fade(duration: 400.ms),
            ),
          ),

          // Actions row - High Contrast
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            child: Row(
              children: [
                AnimatedLikeButton(
                  isLiked: post.isLiked,
                  likeCount: post.likeCount,
                  onTap: onLike,
                ),
                _ActionButton(
                  icon: Icons.chat_bubble_outline_rounded,
                  onTap: () => _showComments(context),
                ),
                _ActionButton(
                  icon: Icons.near_me_outlined,
                  onTap: () {},
                ),
                const Spacer(),
                IconButton(
                  padding: EdgeInsets.zero,
                  icon: Icon(
                    post.isSaved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                    size: 26,
                    color: post.isSaved 
                        ? (isDark ? Colors.white : Colors.black) 
                        : (isDark ? Colors.white70 : Colors.black87),
                  ),
                  onPressed: onSave,
                ),
              ],
            ),
          ),

          // Social Details - Clean Hierarchy
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${AppUtils.formatNumber(post.likeCount)} likes',
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
                ),
                const SizedBox(height: 6),
                _ExpandableCaption(
                  clubName: post.clubName,
                  caption: post.caption,
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () => _showComments(context),
                  child: Text(
                    post.commentCount > 0 ? 'View all ${post.commentCount} comments' : 'Add a comment...',
                    style: TextStyle(
                      color: AppColors.textTertiary,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                const SizedBox(height: 6),
                Text(
                  AppUtils.timeAgo(post.createdAt).toUpperCase(),
                  style: TextStyle(
                    fontSize: 10,
                    color: AppColors.textTertiary,
                    letterSpacing: 0.8,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _ActionButton({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return IconButton(
      visualDensity: VisualDensity.compact,
      icon: Icon(icon, size: 26, color: isDark ? Colors.white : Colors.black),
      onPressed: onTap,
    );
  }
}

class _ExpandableCaption extends StatefulWidget {
  final String clubName;
  final String caption;

  const _ExpandableCaption({
    required this.clubName,
    required this.caption,
  });

  @override
  State<_ExpandableCaption> createState() => _ExpandableCaptionState();
}

class _ExpandableCaptionState extends State<_ExpandableCaption> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _expanded = !_expanded),
      child: RichText(
        maxLines: _expanded ? null : 2,
        overflow: _expanded ? TextOverflow.visible : TextOverflow.ellipsis,
        text: TextSpan(
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 14,
                height: 1.4,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
          children: [
            TextSpan(
              text: '${widget.clubName} ',
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
            TextSpan(text: widget.caption),
          ],
        ),
      ),
    );
  }
}

