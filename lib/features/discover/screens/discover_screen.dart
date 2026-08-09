import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/services/mock_data_service.dart';
import '../../../core/router/app_router.dart';
import '../../../core/utils/app_utils.dart';
import '../../../core/widgets/shared_widgets.dart';
import '../providers/discover_provider.dart';
import '../widgets/club_card.dart';

class DiscoverScreen extends ConsumerStatefulWidget {
  const DiscoverScreen({super.key});

  @override
  ConsumerState<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends ConsumerState<DiscoverScreen> {
  final _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final popularClubs = ref.watch(popularClubsProvider);
    final filteredEvents = ref.watch(filteredEventsProvider); // Club Events

    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark ? AppColors.darkBackground : Colors.grey.shade50,
      body: CustomScrollView(
        slivers: [
          // Modern Hub Header
          SliverAppBar(
            expandedHeight: 120,
            floating: true,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text('Clubs Hub', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 22)),
              titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
              background: Container(color: Theme.of(context).scaffoldBackgroundColor),
            ),
            actions: [
              IconButton(onPressed: () {}, icon: const Icon(Icons.tune_rounded)),
            ],
          ),

          // Search Radar
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
              child: Hero(
                tag: 'search-bar',
                child: Material(
                  color: Colors.transparent,
                  child: TextField(
                    controller: _searchController,
                    onChanged: (v) => setState(() => _isSearching = v.isNotEmpty),
                    decoration: InputDecoration(
                      hintText: 'Search clubs, recruitments...',
                      prefixIcon: const Icon(Icons.search_rounded, color: AppColors.primary),
                      filled: true,
                      fillColor: Theme.of(context).brightness == Brightness.dark ? AppColors.darkCard : Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Recruitment Radar Banner (Attractive)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TapBounce(
                onTap: () => context.push(AppRoutes.recruitmentList),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.orange.shade400, Colors.deepOrange.shade600],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(color: Colors.orange.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8)),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Recruitment Radar',
                              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '5 Clubs are hunting for new members!',
                              style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.radar_rounded, color: Colors.white, size: 60),
                    ],
                  ),
                ),
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 16)),


          const SliverToBoxAdapter(child: SizedBox(height: 28)),

          // Browse by Category
          const SliverToBoxAdapter(child: SectionHeader(title: 'Browse Clusters')),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 45,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: MockDataService.categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  final cat = MockDataService.categories[index];
                  final isSelected = selectedCategory == cat;
                  return ChoiceChip(
                    label: Text(cat),
                    selected: isSelected,
                    onSelected: (_) => ref.read(selectedCategoryProvider.notifier).state = cat,
                    selectedColor: AppColors.primary.withOpacity(0.1),
                    labelStyle: TextStyle(
                      color: isSelected ? AppColors.primary : AppColors.textSecondary,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    side: BorderSide(color: isSelected ? AppColors.primary : Colors.grey.shade300),
                  );
                },
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 20)),

          // Popular Clubs
          const SliverToBoxAdapter(child: SectionHeader(title: 'Top Clubs')),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 220,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: popularClubs.length,
                itemBuilder: (context, index) {
                  final club = popularClubs[index];
                  return Container(
                    width: 160,
                    margin: const EdgeInsets.only(right: 16),
                    child: DiscoverClubCard(
                      club: club,
                      onTap: () => context.push('/club/${club.id}'),
                    ),
                  );
                },
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 20)),

          // Upcoming Club Events (The "Active" part)
          const SliverToBoxAdapter(child: SectionHeader(title: 'Active Club Events')),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final event = filteredEvents[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: FadeSlideTransition(
                      delay: Duration(milliseconds: 100 * index),
                      child: Card(
                        elevation: 0,
                        color: Theme.of(context).brightness == Brightness.dark ? AppColors.darkCard : Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide(color: Colors.grey.withOpacity(0.1))),
                        child: InkWell(
                          onTap: () => context.push('/event/${event.id}'),
                          borderRadius: BorderRadius.circular(20),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                ClubAvatar(name: event.clubName, imageUrl: event.clubLogoUrl, size: 45),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(event.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                                      Text('${event.clubName} • ${AppUtils.formatDate(event.date)}', style: TextStyle(color: AppColors.textTertiary, fontSize: 12)),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                                  child: const Text('View', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 11)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
                childCount: filteredEvents.length > 5 ? 5 : filteredEvents.length,
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }
}
