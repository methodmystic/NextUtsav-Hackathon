import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_utils.dart';
import '../../../core/widgets/shared_widgets.dart';
import '../../../core/models/models.dart';
import '../../feed/widgets/post_card.dart';
import '../../feed/providers/feed_provider.dart';
import '../../events/widgets/event_card.dart';
import '../../events/providers/events_provider.dart';
import '../providers/clubs_provider.dart';

class ClubDetailScreen extends ConsumerStatefulWidget {
  final String clubId;
  const ClubDetailScreen({super.key, required this.clubId});

  @override
  ConsumerState<ClubDetailScreen> createState() => _ClubDetailScreenState();
}

class _ClubDetailScreenState extends ConsumerState<ClubDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final club = ref.watch(clubDetailProvider(widget.clubId));
    final isFollowed = ref.watch(clubFollowProvider(widget.clubId));

    if (club == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const EmptyStateWidget(
          icon: Icons.group_off_outlined,
          title: 'Club not found',
          message: 'This club may have been removed',
        ),
      );
    }

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 220,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      club.coverUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        decoration: const BoxDecoration(
                          gradient: AppColors.heroGradient,
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.7),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      left: 20,
                      bottom: 16,
                      right: 20,
                      child: Row(
                        children: [
                          Hero(
                            tag: 'club_avatar_${club.id}',
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 3),
                              ),
                              child: ClubAvatar(
                                name: club.name,
                                imageUrl: club.logoUrl,
                                size: 60,
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  club.name,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 18,
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(top: 4),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                    color: (AppColors.categoryColors[club.category] ??
                                            AppColors.primary)
                                        .withValues(alpha: 0.85),
                                  ),
                                  child: Text(
                                    club.category,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Stats + Follow
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: Row(
                  children: [
                    _StatItem(
                      value: AppUtils.formatNumber(club.memberCount),
                      label: 'Members',
                    ),
                    const SizedBox(width: 24),
                    _StatItem(
                      value: AppUtils.formatNumber(club.followersCount),
                      label: 'Followers',
                    ),
                    const Spacer(),
                    FilledButton.icon(
                      onPressed: () {
                        ref.read(clubFollowProvider(widget.clubId).notifier).toggleFollow();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              isFollowed
                                  ? 'Unfollowed ${club.name}'
                                  : 'Following ${club.name} ✨',
                            ),
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: isFollowed ? Colors.redAccent : AppColors.success,
                          ),
                        );
                      },
                      icon: Icon(
                        isFollowed
                            ? Icons.check_circle
                            : Icons.add_circle_outline,
                        size: 18,
                      ),
                      label: Text(isFollowed ? 'Following' : 'Follow'),
                      style: FilledButton.styleFrom(
                        backgroundColor:
                            isFollowed ? AppColors.textTertiary : AppColors.primary,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Tab bar
            SliverPersistentHeader(
              pinned: true,
              delegate: _TabBarDelegate(
                TabBar(
                  controller: _tabController,
                  labelColor: AppColors.primary,
                  unselectedLabelColor: AppColors.textTertiary,
                  indicatorColor: AppColors.primary,
                  indicatorWeight: 3,
                  tabs: const [
                    Tab(text: 'Posts'),
                    Tab(text: 'Events'),
                    Tab(text: 'About'),
                  ],
                ),
                Theme.of(context).scaffoldBackgroundColor,
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            _PostsTab(clubId: widget.clubId),
            _EventsTab(clubId: widget.clubId),
            _AboutTab(club: club),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;

  const _StatItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: AppColors.primary,
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: AppColors.textTertiary),
        ),
      ],
    );
  }
}

class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;
  final Color backgroundColor;

  _TabBarDelegate(this.tabBar, this.backgroundColor);

  @override
  Widget build(context, double shrinkOffset, bool overlapsContent) {
    return Container(color: backgroundColor, child: tabBar);
  }

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  bool shouldRebuild(covariant _TabBarDelegate oldDelegate) => false;
}

class _PostsTab extends ConsumerWidget {
  final String clubId;
  const _PostsTab({required this.clubId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final posts = ref.watch(clubPostsProvider(clubId));

    if (posts.isEmpty) {
      return const EmptyStateWidget(
        icon: Icons.photo_library_outlined,
        title: 'No posts yet',
        message: 'This club hasn\'t posted anything yet',
      );
    }

    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts[index];
        return PostCard(
          post: post,
          onLike: () =>
              ref.read(feedPostsProvider.notifier).toggleLike(post.id),
          onSave: () =>
              ref.read(feedPostsProvider.notifier).toggleSave(post.id),
          onTap: () => context.push('/post/${post.id}'),
          onClubTap: null,
        );
      },
    );
  }
}

class _EventsTab extends ConsumerWidget {
  final String clubId;
  const _EventsTab({required this.clubId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final events = ref.watch(clubEventsProvider(clubId));

    if (events.isEmpty) {
      return const EmptyStateWidget(
        icon: Icons.event_busy_outlined,
        title: 'No events yet',
        message: 'Check back later for upcoming events',
      );
    }

    final upcoming = events.where((e) => e.isUpcoming).toList();
    final past = events.where((e) => e.isPast).toList();

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      children: [
        if (upcoming.isNotEmpty) ...[
          const SectionHeader(title: 'Upcoming'),
          ...upcoming.map((event) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: EventCard(
                  event: event,
                  onTap: () => context.push('/event/${event.id}'),
                  onRegister: () => ref
                      .read(eventsListProvider.notifier)
                      .toggleRegistration(event.id),
                ),
              )),
        ],
        if (past.isNotEmpty) ...[
          const SectionHeader(title: 'Past Events'),
          ...past.map((event) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: EventCard(event: event, onTap: () => context.push('/event/${event.id}')),
              )),
        ],
      ],
    );
  }
}

class _AboutTab extends StatelessWidget {
  final Club club;
  const _AboutTab({required this.club});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text('About', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Text(club.description, style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 24),
        if (club.achievements.isNotEmpty) ...[
          Text('Achievements', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          ...club.achievements.map((achievement) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.accent.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.emoji_events,
                        color: AppColors.accent,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        achievement,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
          const SizedBox(height: 24),
        ],
        if (club.coreTeam.isNotEmpty) ...[
          const SizedBox(height: 12),
          Text('Meet the Organizers', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900)),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 2.2,
            ),
            itemCount: club.coreTeam.length,
            itemBuilder: (context, index) {
              final member = club.coreTeam[index];
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark ? AppColors.darkCard : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.withOpacity(0.1)),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(member.avatarUrl),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(member.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11), maxLines: 1, overflow: TextOverflow.ellipsis),
                          Text(member.role, style: const TextStyle(fontSize: 9, color: AppColors.textTertiary), maxLines: 2, overflow: TextOverflow.ellipsis),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 24),
        ],
      ],
    );
  }
}
