import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_utils.dart';
import '../../events/providers/events_provider.dart';
import '../providers/academic_provider.dart';
import 'attendance_scanner_screen.dart';

class FacultyDashboardScreen extends ConsumerWidget {
  const FacultyDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myClubs = ref.watch(facultyClubsProvider);
    final events = ref.watch(eventsListProvider).value ?? [];
    final pendingEvents = events.where((e) => e.approvalStatus == 'Pending').toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Faculty Dashboard', style: TextStyle(fontWeight: FontWeight.w900)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage('https://api.dicebear.com/7.x/avataaars/png?seed=Sanjay'),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Welcome back,', style: TextStyle(color: Colors.white70, fontSize: 13)),
                        Text('Dr. Sanjay Agarwal', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                        Text('HOD, Computer Engineering', style: TextStyle(color: Colors.white70, fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Quick Actions
            const Text('Controls', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _ControlCard(
                    icon: Icons.qr_code_scanner_rounded,
                    label: 'Scan Attendance',
                    color: Colors.blue,
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AttendanceScannerScreen())),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _ControlCard(
                    icon: Icons.calendar_month_rounded,
                    label: 'Manage Calendar',
                    color: Colors.purple,
                    onTap: () {},
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Pending Approvals
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Pending Approvals (${pendingEvents.length})', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                TextButton(onPressed: () {}, child: const Text('View All')),
              ],
            ),
            if (pendingEvents.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 30),
                  child: Text('All caught up!', style: TextStyle(color: AppColors.textTertiary)),
                ),
              )
            else
              ...pendingEvents.map((event) => _EventApprovalCard(event: event)),

            const SizedBox(height: 24),
            // My Clubs Stats
            const Text('Assigned Clubs', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ...myClubs.map((club) => Card(
              child: ListTile(
                leading: CircleAvatar(backgroundImage: NetworkImage(club.logoUrl)),
                title: Text(club.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('${club.memberCount} Members • ${club.followersCount} Followers'),
                trailing: const Icon(Icons.chevron_right_rounded),
              ),
            )),
          ],
        ),
      ),
    );
  }
}

class _ControlCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ControlCard({required this.icon, required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 12),
            Text(label, textAlign: TextAlign.center, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 13)),
          ],
        ),
      ),
    );
  }
}

class _EventApprovalCard extends StatelessWidget {
  final dynamic event;
  const _EventApprovalCard({required this.event});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(event.posterUrl, width: 60, height: 60, fit: BoxFit.cover),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(event.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text('By ${event.clubName}', style: const TextStyle(fontSize: 12, color: AppColors.textTertiary)),
                      Text(AppUtils.formatDate(event.date), style: const TextStyle(fontSize: 12, color: AppColors.primary)),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(onPressed: () {}, child: const Text('Review Details')),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: () {},
                  style: FilledButton.styleFrom(backgroundColor: AppColors.success),
                  child: const Text('Approve'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
