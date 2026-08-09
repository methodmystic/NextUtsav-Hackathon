import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/shared_widgets.dart';
import '../providers/feed_provider.dart';

class StoryBar extends ConsumerWidget {
  const StoryBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storiesAsync = ref.watch(storiesProvider);

    return SizedBox(
      height: 100,
      child: storiesAsync.when(
        loading: () => ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          itemCount: 6,
          itemBuilder: (_, __) => const Padding(
            padding: EdgeInsets.symmetric(horizontal: 6),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SkeletonLoader(width: 60, height: 60, borderRadius: 30),
                SizedBox(height: 6),
                SkeletonLoader(width: 50, height: 10),
              ],
            ),
          ),
        ),
        error: (_, __) => const SizedBox.shrink(),
        data: (groups) => ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          itemCount: groups.length,
          itemBuilder: (context, index) {
            final group = groups[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: FadeSlideTransition(
                delay: Duration(milliseconds: 100 * index),
                offset: const Offset(20, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: index % 2 == 0
                            ? AppColors.primaryGradient
                            : AppColors.accentGradient,
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).scaffoldBackgroundColor,
                        ),
                        child: CircleAvatar(
                          radius: 26,
                          backgroundImage: NetworkImage(group['avatarUrl'] ?? 'https://via.placeholder.com/150'),
                        ),
                      ),
                    ).animate(onPlay: (controller) => controller.repeat(reverse: true))
                     .shimmer(duration: 2000.ms, color: Colors.white.withOpacity(0.2))
                     .scale(begin: const Offset(1, 1), end: const Offset(1.03, 1.03), duration: 1500.ms, curve: Curves.easeInOut),

                    const SizedBox(height: 6),
                    SizedBox(
                      width: 64,
                      child: Text(
                        (group['name'] as String).split(' ').first,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

