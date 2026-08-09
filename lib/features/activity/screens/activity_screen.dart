import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_utils.dart';
import '../../../core/widgets/shared_widgets.dart';
import '../providers/activity_provider.dart';
import '../../../core/services/pdf_service.dart';

class ActivityScreen extends ConsumerWidget {
  const ActivityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activityAsync = ref.watch(activityProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('My Achievements', style: TextStyle(fontWeight: FontWeight.w900)),
        centerTitle: true,
      ),
      body: activityAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (data) => CustomScrollView(
          slivers: [
            // Personal Growth Hero
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10)),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('CURRENT STATUS', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 1.5)),
                              const SizedBox(height: 4),
                              const Text('Elite Member', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w900)),
                              const SizedBox(height: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(10)),
                                child: const Text('🏆 Top 10% on Campus', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                              ),
                            ],
                          ),
                          const Spacer(),
                          const Icon(Icons.stars_rounded, color: Colors.amber, size: 70),
                        ],
                      ),
                      const SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _StatItem(label: 'Tech Credits', value: '12'),
                          Container(width: 1, height: 30, color: Colors.white24),
                          _StatItem(label: 'Cult. Credits', value: '04'),
                          Container(width: 1, height: 30, color: Colors.white24),
                          _StatItem(label: 'Sports Credits', value: '02'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Progress Bar Section
            const SliverToBoxAdapter(child: SectionHeader(title: 'Level Progression')),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Level ${data.level}', style: const TextStyle(fontWeight: FontWeight.bold)),
                            Text('Level ${data.level + 1}', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textTertiary)),
                          ],
                        ),
                        const SizedBox(height: 12),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: (1 - (data.xpToNextLevel / 500)).toDouble(),
                            minHeight: 12,
                            backgroundColor: AppColors.surfaceVariant,
                            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text('${data.xpToNextLevel} XP remaining until next level up!', style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic)),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),

            // Achievement Gallery
            const SliverToBoxAdapter(child: SectionHeader(title: 'Collected Badges')),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.85,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final badge = data.allBadges[index];
                    final isEarned = data.earnedBadges.any((b) => b.id == badge.id);
                    return Container(
                      decoration: BoxDecoration(
                        color: isEarned ? AppColors.surface : Colors.black.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(20),
                        border: isEarned ? Border.all(color: Colors.amber.withOpacity(0.2)) : null,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            isEarned ? Icons.workspace_premium : Icons.lock_outline_rounded,
                            color: isEarned ? Colors.amber : AppColors.textTertiary.withOpacity(0.2),
                            size: 36,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            badge.name,
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: isEarned ? AppColors.textPrimary : AppColors.textTertiary),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                          ),
                        ],
                      ),
                    );
                  },
                  childCount: data.allBadges.length,
                ),
              ),
            ),

            // Certificates section
            const SliverToBoxAdapter(child: SectionHeader(title: 'Earned Certificates')),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final cert = data.certificates[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.dark ? AppColors.darkCard : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.primary.withOpacity(0.1)),
                      ),
                      child: ListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.verified_user_rounded, color: AppColors.primary),
                        ),
                        title: Text(cert.eventName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        subtitle: Text('Issued: ${AppUtils.formatDate(cert.issuedAt)}', style: const TextStyle(fontSize: 12)),
                        trailing: IconButton(
                          icon: const Icon(Icons.download_rounded, color: AppColors.primary),
                          onPressed: () => AttendancePdfService.generateCertificate(
                            studentName: 'Aditya Kalra', // In real app, get from user profile provider
                            eventName: cert.eventName,
                            eventDate: cert.issuedAt,
                            clubName: 'NextUtsav Partner Club',
                          ),
                        ),
                      ),
                    );
                  },
                  childCount: data.certificates.length,
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),

            // Recent Growth Timeline
            const SliverToBoxAdapter(child: SectionHeader(title: 'Recent Activity')),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const _TimelineItem(title: 'Technical Workshop', xp: '+120 XP', date: 'Yesterday', icon: Icons.code_rounded),
                  const _TimelineItem(title: 'Event Registration', xp: '+50 XP', date: '2 days ago', icon: Icons.local_activity_rounded),
                  const _TimelineItem(title: 'Badge Unlocked: Early Bird', xp: 'New Trophy', date: '3 days ago', icon: Icons.emoji_events_rounded, isSpecial: true),
                ]),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 40)),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900)),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold)),
      ],
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final String title;
  final String xp;
  final String date;
  final IconData icon;
  final bool isSpecial;

  const _TimelineItem({required this.title, required this.xp, required this.date, required this.icon, this.isSpecial = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: (isSpecial ? Colors.amber : AppColors.primary).withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: isSpecial ? Colors.amber.shade700 : AppColors.primary, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                Text(date, style: const TextStyle(fontSize: 11, color: AppColors.textTertiary)),
              ],
            ),
          ),
          Text(xp, style: TextStyle(fontWeight: FontWeight.w900, color: isSpecial ? Colors.amber.shade800 : AppColors.success, fontSize: 13)),
        ],
      ),
    );
  }
}
