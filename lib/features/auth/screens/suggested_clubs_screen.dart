import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/router/app_router.dart';
import '../../../core/services/mock_data_service.dart';
import '../../../core/widgets/shared_widgets.dart';
import '../../../core/utils/app_utils.dart';
import '../providers/auth_provider.dart';

class SuggestedClubsScreen extends ConsumerStatefulWidget {
  const SuggestedClubsScreen({super.key});

  @override
  ConsumerState<SuggestedClubsScreen> createState() => _SuggestedClubsScreenState();
}

class _SuggestedClubsScreenState extends ConsumerState<SuggestedClubsScreen> {
  bool _isLoading = false;

  Future<void> _onFinalize() async {
    final followedClubs = ref.read(onboardingFollowedClubsProvider);
    setState(() => _isLoading = true);
    
    try {
      final api = ref.read(apiServiceProvider);
      // Persist followed clubs
      await api.patch('/students/me', {'followedClubs': followedClubs});
      
      if (!mounted) return;
      context.go(AppRoutes.home);
    } catch (e) {
      if (!mounted) return;
      context.go(AppRoutes.home);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedInterests = ref.watch(selectedInterestsProvider);
    final followedClubs = ref.watch(onboardingFollowedClubsProvider);

    // Filter clubs by user interests
    final suggestedClubs = MockDataService.clubs.where((club) {
      return selectedInterests.contains(club.category);
    }).toList();

    // If no exact match, show all
    final displayClubs = suggestedClubs.isEmpty ? MockDataService.clubs : suggestedClubs;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Text(
                'Clubs for You',
                style: GoogleFonts.urbanist(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Based on your interests, here are some clubs you might love',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              Expanded(
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  itemCount: displayClubs.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final club = displayClubs[index];
                    final isFollowed = followedClubs.contains(club.id);

                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isFollowed
                              ? AppColors.primary.withValues(alpha: 0.3)
                              : Colors.grey.withOpacity(0.15),
                        ),
                        color: isFollowed ? AppColors.primary.withValues(alpha: 0.05) : Colors.white.withOpacity(0.01),
                      ),
                      child: Row(
                        children: [
                          ClubAvatar(
                            name: club.name,
                            imageUrl: club.logoUrl,
                            size: 52,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  club.name,
                                  style: GoogleFonts.urbanist(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: (AppColors.categoryColors[club.category] ?? AppColors.primary).withValues(alpha: 0.12),
                                      ),
                                      child: Text(
                                        club.category,
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w800,
                                          color: AppColors.categoryColors[club.category] ?? AppColors.primary,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      '${AppUtils.formatNumber(club.memberCount)} members',
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          _FollowToggle(
                            isFollowed: isFollowed,
                            onTap: () {
                              final notifier = ref.read(onboardingFollowedClubsProvider.notifier);
                              if (isFollowed) {
                                notifier.state = followedClubs.where((id) => id != club.id).toList();
                              } else {
                                notifier.state = [...followedClubs, club.id];
                              }
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: AppButton(
                  label: 'Get Started 🎉',
                  isLoading: _isLoading,
                  onPressed: _onFinalize,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class _FollowToggle extends StatelessWidget {
  final bool isFollowed;
  final VoidCallback onTap;

  const _FollowToggle({required this.isFollowed, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: isFollowed ? AppColors.primary : Colors.transparent,
          border: Border.all(
            color: isFollowed ? AppColors.primary : AppColors.textTertiary,
          ),
        ),
        child: Text(
          isFollowed ? 'Following' : 'Follow',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isFollowed ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
