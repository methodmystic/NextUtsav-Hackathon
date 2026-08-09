import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/router/app_router.dart';
import '../../../core/widgets/shared_widgets.dart';
import '../providers/feed_provider.dart';
import '../widgets/story_bar.dart';
import '../widgets/post_card.dart';
import '../widgets/featured_event_card.dart';

class FeedScreen extends ConsumerWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postsAsync = ref.watch(feedPostsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      body: postsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
        data: (posts) => RefreshIndicator(
          onRefresh: () => ref.read(feedPostsProvider.notifier).refresh(),
          edgeOffset: 100,
          color: AppColors.primary,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // High-Fidelity Custom Header
              SliverAppBar(
                floating: true,
                pinned: false,
                backgroundColor: (isDark ? AppColors.darkBackground : AppColors.background).withOpacity(0.8),
                surfaceTintColor: Colors.transparent,
                expandedHeight: 70,
                elevation: 0,
                centerTitle: false,
                title: ShaderMask(
                  shaderCallback: (bounds) => AppColors.primaryGradient.createShader(bounds),
                  child: Text(
                    'NextUtsav',
                    style: GoogleFonts.urbanist(
                      fontWeight: FontWeight.w900,
                      fontSize: 30,
                      letterSpacing: -1.5,
                      color: Colors.white,
                    ),
                  ),
                ),
                actions: [
                  _HeaderAction(
                    icon: Icons.add_box_outlined,
                    onTap: () {}, // Add Post
                  ),
                  _HeaderAction(
                    icon: Icons.favorite_border_rounded,
                    onTap: () => context.push(AppRoutes.notifications),
                  ),
                  _HeaderAction(
                    icon: Icons.near_me_outlined,
                    onTap: () {}, // Messages
                  ),
                  const SizedBox(width: 8),
                ],
              ),

              // Immersive Content
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    const StoryBar(),
                    const SizedBox(height: 20),
                    
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4),
                      child: SectionHeader(title: '🔥 Campus Highlights'),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: FeaturedEventCard(),
                    ),
                    
                    const SizedBox(height: 24),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4),
                      child: SectionHeader(title: '📢 What\'s Buzzing'),
                    ),
                  ],
                ),
              ),

              posts.isEmpty
                  ? const SliverFillRemaining(
                      hasScrollBody: false,
                      child: EmptyStateWidget(
                        icon: Icons.dynamic_feed_outlined,
                        title: 'All quiet on the campus...',
                        message: 'Follow clubs to see what\'s happening!',
                      ),
                    )
                  : SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return FadeSlideTransition(
                            delay: Duration(milliseconds: 100 * (index < 4 ? index : 4)),
                            child: PostCard(
                              post: posts[index],
                              onLike: () => ref.read(feedPostsProvider.notifier).toggleLike(posts[index].id),
                              onSave: () => ref.read(feedPostsProvider.notifier).toggleSave(posts[index].id),
                              onTap: () => context.push(AppRoutes.postDetail.replaceAll(':id', posts[index].id)),
                              onClubTap: () => context.push(AppRoutes.clubDetail.replaceAll(':id', posts[index].clubId)),
                            ),
                          );
                        },
                        childCount: posts.length,
                      ),
                    ),
              const SliverToBoxAdapter(child: SizedBox(height: 80)),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeaderAction extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _HeaderAction({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: IconButton(
        icon: Icon(icon, color: isDark ? Colors.white : Colors.black, size: 26),
        onPressed: onTap,
        visualDensity: VisualDensity.compact,
      ),
    );
  }
}

