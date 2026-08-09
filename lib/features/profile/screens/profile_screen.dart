import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_utils.dart';
import '../../../core/widgets/shared_widgets.dart';
import '../../../core/models/models.dart';
import '../providers/profile_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      body: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (data) => CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // Premium Animated Header
            SliverAppBar(
              expandedHeight: 220,
              pinned: true,
              stretch: true,
              backgroundColor: isDark ? AppColors.darkBackground : AppColors.primary,
              flexibleSpace: FlexibleSpaceBar(
                stretchModes: const [StretchMode.zoomBackground],
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        gradient: AppColors.primaryGradient,
                      ),
                    ),
                    // Decorative shapes
                    Positioned(
                      top: -20,
                      right: -20,
                      child: CircleAvatar(
                        radius: 80,
                        backgroundColor: Colors.white.withValues(alpha: 0.1),
                      ),
                    ),
                    Positioned(
                      bottom: 40,
                      left: -10,
                      child: CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.white.withValues(alpha: 0.05),
                      ),
                    ),
                    // Profile Info in header
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Hero(
                          tag: 'profile-avatar',
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 4),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.2),
                                  blurRadius: 20,
                                ),
                              ],
                            ),
                            child: CircleAvatar(
                              radius: 45,
                              backgroundImage: NetworkImage(data.user.avatarUrl),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          data.user.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.5,
                          ),
                        ),
                        Text(
                          '${data.user.branch} • Semester ${data.user.semester}',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.settings_outlined, color: Colors.white),
                  onPressed: () {},
                ),
              ],
            ),

            SliverToBoxAdapter(
              child: Transform.translate(
                offset: const Offset(0, -20),
                child: Container(
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkBackground : AppColors.background,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 24),

                      // Tech Portfolio Links (Tech Resume Aesthetic)
                      const SectionHeader(title: 'Tech Portfolio'),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.darkCard : Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.03),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  _TechLinkItem(
                                    icon: FontAwesomeIcons.github,
                                    label: 'GitHub',
                                    color: isDark ? Colors.white : Colors.black,
                                    url: data.user.githubUrl,
                                  ),
                                  _TechLinkItem(
                                    icon: FontAwesomeIcons.linkedin,
                                    label: 'LinkedIn',
                                    color: const Color(0xFF0077B5),
                                    url: data.user.linkedinUrl,
                                  ),
                                  _TechLinkItem(
                                    icon: FontAwesomeIcons.code,
                                    label: 'LeetCode',
                                    color: const Color(0xFFFAAD14),
                                    url: data.user.leetcodeUrl,
                                  ),
                                  _TechLinkItem(
                                    icon: FontAwesomeIcons.hackerrank,
                                    label: 'HackerRank',
                                    color: const Color(0xFF2EC866),
                                    url: data.user.hackerrankUrl,
                                  ),
                                ],
                              ),
                              const Divider(height: 32),
                              SizedBox(
                                width: double.infinity,
                                child: OutlinedButton.icon(
                                  onPressed: () => _showEditProfile(context, ref, data.user),
                                  icon: const Icon(Icons.edit_note_rounded),
                                  label: const Text('Update Links & Bio'),
                                  style: OutlinedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // LinkedIn-style Professional Dashboard
                      const SectionHeader(title: 'Professional Dashboard'),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.darkCard : Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: Colors.blue.withOpacity(0.1), width: 1),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Text('Analytics', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                  const Spacer(),
                                  InkWell(
                                    onTap: () {}, // Add navigation to detailed analytics
                                    child: Text('View All', style: TextStyle(color: AppColors.primary, fontSize: 13, fontWeight: FontWeight.bold)),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  _AnalyticsItem(label: 'Profile views', value: '1.2k', trend: '+12%'),
                                  _AnalyticsItem(label: 'Post impressions', value: '8.4k', trend: '+24%'),
                                  _AnalyticsItem(label: 'Search appearances', value: '86', trend: '+5%'),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Achievement Stats
                      const SectionHeader(title: 'Campus Standing'),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            Expanded(
                              child: _StatCard(
                                title: 'Skills Score',
                                value: 'Expert ⚡',
                                subtitle: 'Top 5%',
                                color: Colors.blueAccent,
                                icon: Icons.bolt_rounded,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _StatCard(
                                title: 'Events Won',
                                value: '4 Trophies',
                                subtitle: 'Last:SIH 2026',
                                color: Colors.amber.shade700,
                                icon: Icons.emoji_events_rounded,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Quick Actions Section
                      const SectionHeader(title: 'Quick Access'),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: [
                            _ActionTile(
                              icon: Icons.bookmark_rounded,
                              label: 'Saved Posts',
                              color: AppColors.secondary,
                              onTap: () => context.push(AppRoutes.savedPosts),
                            ),
                            _ActionTile(
                              icon: Icons.workspace_premium_rounded,
                              label: 'My Certificates',
                              color: Colors.amber,
                              onTap: () => context.push(AppRoutes.rankings), // ActivityScreen
                            ),
                            _ActionTile(
                              icon: Icons.calendar_month_rounded,
                              label: 'Academic Calendar',
                              color: Colors.purple,
                              onTap: () => context.push(AppRoutes.collegeCalendar),
                            ),
                            if (data.user.role == 'Faculty')
                              _ActionTile(
                                icon: Icons.dashboard_customize_rounded,
                                label: 'Faculty Dashboard',
                                color: Colors.blue,
                                onTap: () => context.push(AppRoutes.facultyDashboard),
                              ),
                            _ActionTile(
                              icon: Icons.checklist_rtl_rounded,
                              label: 'My Attendance',
                              color: Colors.blueGrey,
                              onTap: () => context.push(AppRoutes.attendanceHistory),
                            ),
                            _ActionTile(
                              icon: Icons.history_edu_rounded,
                              label: 'Applications',
                              color: AppColors.primary,
                              onTap: () => context.push(AppRoutes.applicationStatus),
                            ),
                            _ActionTile(
                              icon: Icons.bug_report_rounded,
                              label: 'Report a Bug',
                              color: Colors.redAccent,
                              onTap: () => context.push(AppRoutes.bugReport),
                            ),
                            _ActionTile(
                              icon: Icons.description_rounded,
                              label: 'Terms of Service',
                              color: Colors.teal,
                              onTap: () => context.push(AppRoutes.termsOfService),
                            ),
                            _ActionTile(
                              icon: Icons.privacy_tip_rounded,
                              label: 'Privacy Policy',
                              color: Colors.indigo,
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Privacy Policy details linked!')),
                                );
                              },
                            ),
                            _ActionTile(
                              icon: Icons.cookie_rounded,
                              label: 'Cookie Preferences',
                              color: Colors.brown,
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Cookie consent options opened!')),
                                );
                              },
                            ),
                            _ActionTile(
                              icon: Icons.support_agent_rounded,
                              label: 'Contact Support',
                              color: Colors.lightGreen,
                              onTap: () async {
                                final Uri emailLaunchUri = Uri(
                                  scheme: 'mailto',
                                  path: 'support@nextutsav.edu',
                                  query: 'subject=Support Request - NextUtsav App',
                                );
                                try {
                                  if (await canLaunchUrl(emailLaunchUri)) {
                                    await launchUrl(emailLaunchUri);
                                  } else {
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Could not open email client. Please email support@nextutsav.edu directly.')),
                                      );
                                    }
                                  }
                                } catch (e) {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Could not open email client. Please email support@nextutsav.edu directly.')),
                                    );
                                  }
                                }
                              },
                            ),
                            _ActionTile(
                              icon: Icons.logout_rounded,
                              label: 'Log Out',
                              color: AppColors.accent,
                              onTap: () {
                                ref.read(isLoggedInProvider.notifier).logout();
                                context.go(AppRoutes.login);
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditProfile(BuildContext context, WidgetRef ref, AppUser user) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _EditProfileSheet(user: user),
    );
  }
}

class _TechLinkItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final String? url;

  const _TechLinkItem({
    required this.icon,
    required this.label,
    required this.color,
    this.url,
  });

  @override
  Widget build(BuildContext context) {
    final hasUrl = url != null && url!.isNotEmpty;
    return Column(
      children: [
        Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            color: hasUrl ? color.withValues(alpha: 0.1) : Colors.grey.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: hasUrl ? color : Colors.grey,
            size: 22,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: hasUrl ? AppColors.textPrimary : AppColors.textTertiary,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final Color color;
  final IconData icon;

  const _StatCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: color.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 11,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionTile({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCard : Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 16),
              Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const Spacer(),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textTertiary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EditProfileSheet extends StatefulWidget {
  final AppUser user;
  const _EditProfileSheet({required this.user});

  @override
  State<_EditProfileSheet> createState() => _EditProfileSheetState();
}

class _EditProfileSheetState extends State<_EditProfileSheet> {
  late TextEditingController _bioController;
  late TextEditingController _githubController;
  late TextEditingController _linkedinController;
  late TextEditingController _leetcodeController;
  late TextEditingController _hackerrankController;

  @override
  void initState() {
    super.initState();
    _bioController = TextEditingController(text: widget.user.bio);
    _githubController = TextEditingController(text: widget.user.githubUrl);
    _linkedinController = TextEditingController(text: widget.user.linkedinUrl);
    _leetcodeController = TextEditingController(text: widget.user.leetcodeUrl);
    _hackerrankController = TextEditingController(text: widget.user.hackerrankUrl);
  }

  @override
  void dispose() {
    _bioController.dispose();
    _githubController.dispose();
    _linkedinController.dispose();
    _leetcodeController.dispose();
    _hackerrankController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
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
              const SizedBox(height: 20),
              Text(
                'Update Portfolio',
                style: TextStyle(
                  fontSize: 24, 
                  fontWeight: FontWeight.w900,
                  color: isDark ? Colors.white : AppColors.textPrimary,
                ),
              ),
              Text(
                'Showcase your technical prowess to the campus',
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? AppColors.textTertiary : AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 24),
              
              _EditorField(
                controller: _bioController,
                label: 'Bio',
                icon: Icons.auto_awesome_rounded,
                maxLines: 3,
                isDark: isDark,
              ),
              const SizedBox(height: 16),
              
              _EditorField(
                controller: _githubController,
                label: 'GitHub URL',
                icon: FontAwesomeIcons.github,
                isDark: isDark,
              ),
              const SizedBox(height: 16),
              
              _EditorField(
                controller: _linkedinController,
                label: 'LinkedIn URL',
                icon: FontAwesomeIcons.linkedin,
                isDark: isDark,
              ),
              const SizedBox(height: 16),
              
              _EditorField(
                controller: _leetcodeController,
                label: 'LeetCode URL',
                icon: FontAwesomeIcons.code,
                isDark: isDark,
              ),
              const SizedBox(height: 16),
              
              _EditorField(
                controller: _hackerrankController,
                label: 'HackerRank URL',
                icon: FontAwesomeIcons.hackerrank,
                isDark: isDark,
              ),
              
              const SizedBox(height: 32),
              
              Consumer(
                builder: (context, ref, child) {
                  final profileState = ref.watch(profileProvider);
                  final isLoading = profileState is AsyncLoading;

                  return SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: FilledButton(
                      onPressed: isLoading ? null : () async {
                        final updatedUser = widget.user.copyWith(
                          bio: _bioController.text,
                          githubUrl: _githubController.text,
                          linkedinUrl: _linkedinController.text,
                          leetcodeUrl: _leetcodeController.text,
                          hackerrankUrl: _hackerrankController.text,
                        );
                        
                        await ref.read(profileProvider.notifier).updateUser(updatedUser);
                        
                        if (context.mounted) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Profile updated successfully!'),
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: AppColors.success,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                          );
                        }
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: isLoading 
                        ? const SizedBox(
                            height: 20, 
                            width: 20, 
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)
                          ) 
                        : const Text('Save Changes', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}

class _EditorField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final int maxLines;
  final bool isDark;

  const _EditorField({
    required this.controller,
    required this.label,
    required this.icon,
    this.maxLines = 1,
    required this.isDark,
  });

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
          controller: controller,
          maxLines: maxLines,
          style: TextStyle(color: isDark ? Colors.white : AppColors.textPrimary),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, size: 18, color: AppColors.primary),
            filled: true,
            fillColor: isDark ? AppColors.darkCard : Colors.grey.withValues(alpha: 0.05),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }
}

class _AnalyticsItem extends StatelessWidget {
  final String label;
  final String value;
  final String trend;

  const _AnalyticsItem({required this.label, required this.value, required this.trend});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: AppColors.textTertiary, fontSize: 10)),
        const SizedBox(height: 4),
        Text(trend, style: const TextStyle(color: Colors.green, fontSize: 10, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
