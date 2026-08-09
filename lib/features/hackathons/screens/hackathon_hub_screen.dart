import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/shared_widgets.dart';

class HackathonHubScreen extends ConsumerStatefulWidget {
  const HackathonHubScreen({super.key});

  @override
  ConsumerState<HackathonHubScreen> createState() => _HackathonHubScreenState();
}

class _HackathonHubScreenState extends ConsumerState<HackathonHubScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.darkBackground : Colors.white,
        elevation: 0,
        leading: BackButton(
          color: isDark ? Colors.white : AppColors.textPrimary,
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Hackathon Hub',
          style: TextStyle(
            fontWeight: FontWeight.w900, 
            color: isDark ? Colors.white : AppColors.textPrimary,
            letterSpacing: -0.5,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: isDark ? AppColors.textTertiary : AppColors.textSecondary,
          indicatorColor: AppColors.primary,
          indicatorWeight: 3,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          tabs: const [
            Tab(text: 'Discovery'),
            Tab(text: 'Matchmaking'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _ExternalHackathonsTab(),
          _CollegeTeamsTab(),
        ],
      ),
      floatingActionButton: ValueListenableBuilder(
        valueListenable: _tabController.animation!,
        builder: (context, anim, child) {
          if (anim > 0.5) {
            return FloatingActionButton.extended(
              onPressed: () => _showCreateTeamSheet(context),
              backgroundColor: AppColors.primary,
              elevation: 4,
              icon: const Icon(Icons.add_rounded, color: Colors.white),
              label: const Text('New Team', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  void _showCreateTeamSheet(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.fromLTRB(24, 12, 24, 24 + MediaQuery.of(context).viewInsets.bottom),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Recruit Your Team', 
              style: TextStyle(
                fontSize: 24, 
                fontWeight: FontWeight.w900,
                color: isDark ? Colors.white : AppColors.textPrimary,
              ),
            ),
            Text(
              'Find the perfect squad for your next win',
              style: TextStyle(
                fontSize: 14,
                color: isDark ? AppColors.textTertiary : AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            _SheetTextField(label: 'Team Name', hintText: 'e.g. Dream Team 2026', isDark: isDark),
            const SizedBox(height: 16),
            _SheetTextField(label: 'Target Hackathon', hintText: 'e.g. SIH, Google Solution Challenge', isDark: isDark),
            const SizedBox(height: 16),
            _SheetTextField(label: 'Skills Needed', hintText: 'e.g. Flutter, Rust, AR/VR', isDark: isDark),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: FilledButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Team request published to your campus! 🚀'),
                      backgroundColor: AppColors.success,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text('Publish Request', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SheetTextField extends StatelessWidget {
  final String label;
  final String hintText;
  final bool isDark;

  const _SheetTextField({required this.label, required this.hintText, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.textTertiary : AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          style: TextStyle(color: isDark ? Colors.white : AppColors.textPrimary),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: isDark ? AppColors.textTertiary.withValues(alpha: 0.5) : AppColors.textTertiary),
            filled: true,
            fillColor: isDark ? AppColors.darkCard : Colors.grey.withValues(alpha: 0.05),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }
}

// Data Provider fetching live hackathons from the Node Backend
final hackathonsProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  try {
    final response = await http.get(Uri.parse('http://10.0.2.2:5000/api/hackathons')).timeout(const Duration(seconds: 3));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List list = data['data'] ?? [];
      if (list.isNotEmpty) return List<Map<String, dynamic>>.from(list);
    }
  } catch (e) {
    // Backend offline -> Fallback gracefully
  }
  
  return [
    {
      'title': 'Mirage Hackathon',
      'organizer': 'Thapar University',
      'date': 'Apr 18, 2026',
      'url': 'https://namespace.world/',
    },
    {
      'title': 'CodeForge 2.0',
      'organizer': 'DYPCOE Akurdi',
      'date': 'Apr 18, 2026',
      'url': 'https://namespace.world/',
    },
    {
      'title': 'Innovators Hackathon',
      'organizer': 'Shetty Institute of Technology',
      'date': 'Apr 21 - 22, 2026',
      'url': 'https://yutori.com/',
    },
  ];
});

class _ExternalHackathonsTab extends ConsumerWidget {

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hackathonsAsync = ref.watch(hackathonsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return hackathonsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
      data: (hackathons) => ListView.builder(
        padding: const EdgeInsets.all(16),
        physics: const BouncingScrollPhysics(),
        itemCount: hackathons.length,
        itemBuilder: (context, index) {
          final hack = hackathons[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.rocket_launch_rounded, color: AppColors.primary),
            ),
            title: Text(
              hack['title'],
              style: TextStyle(
                fontWeight: FontWeight.bold, 
                fontSize: 16,
                color: isDark ? Colors.white : AppColors.textPrimary,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(
                  hack['organizer'], 
                  style: TextStyle(color: isDark ? AppColors.textTertiary : AppColors.textSecondary, fontSize: 13),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.calendar_today_rounded, size: 14, color: AppColors.primary.withValues(alpha: 0.7)),
                    const SizedBox(width: 8),
                    Text(
                      hack['date'], 
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: isDark ? AppColors.textTertiary : AppColors.textSecondary),
                    ),
                  ],
                ),
              ],
            ),
            trailing: IconButton(
               onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Reminders set for this hackathon! 🔔'),
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: AppColors.primary,
                  ),
                );
              },
              icon: Icon(Icons.notifications_none_rounded, color: isDark ? AppColors.textTertiary : AppColors.textSecondary),
            ),
            onTap: () async {
              final uri = Uri.parse(hack['url']);
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              }
            },
          ),
        );
      },
    ),
   );
  }
}

class _CollegeTeamsTab extends StatelessWidget {
  final List<Map<String, dynamic>> teams = [
    {
      'name': 'Team Alpha',
      'hackathon': 'SIH 2026',
      'filledCount': '2/4 filled',
      'skills': ['React', 'Firebase', 'Python'],
    },
    {
      'name': 'Byte Busters',
      'hackathon': 'Google Solution Challenge',
      'filledCount': '3/4 filled',
      'skills': ['Flutter', 'Node.js', 'ML'],
    },
    {
      'name': 'Code Crafters',
      'hackathon': 'Unstoppable Devs',
      'filledCount': '1/3 filled',
      'skills': ['Java', 'SQL', 'Cloud'],
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      physics: const BouncingScrollPhysics(),
      itemCount: teams.length,
      itemBuilder: (context, index) {
        final team = teams[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        team['name'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold, 
                          fontSize: 18,
                          color: isDark ? Colors.white : AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        team['hackathon'],
                        style: TextStyle(color: isDark ? AppColors.textTertiary : AppColors.textSecondary, fontSize: 13),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.orange.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      team['filledCount'],
                      style: const TextStyle(color: Colors.orange, fontSize: 11, fontWeight: FontWeight.w900),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Seeking Skills:', 
                style: TextStyle(
                  fontSize: 12, 
                  fontWeight: FontWeight.bold, 
                  color: isDark ? AppColors.textTertiary : AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: (team['skills'] as List<String>)
                    .map((skill) => Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.darkCard : Colors.grey.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            skill, 
                            style: TextStyle(
                              fontSize: 11, 
                              fontWeight: FontWeight.w600,
                              color: isDark ? Colors.white : AppColors.textPrimary,
                            ),
                          ),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Join request sent to ${team['name']}! 📨'),
                        backgroundColor: AppColors.primary,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.primary, width: 2),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Request to Join', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w900)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
