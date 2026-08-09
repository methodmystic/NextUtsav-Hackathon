import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_utils.dart';
import '../../../core/widgets/shared_widgets.dart';
import '../providers/recruitment_provider.dart';

class ApplicationStatusScreen extends ConsumerWidget {
  const ApplicationStatusScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appsAsync = ref.watch(applicationsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('My Applications')),
      body: appsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => EmptyStateWidget(
          icon: Icons.error_outline,
          title: 'Error',
          message: e.toString(),
        ),
        data: (applications) {
          if (applications.isEmpty) {
            return const EmptyStateWidget(
              icon: Icons.assignment_outlined,
              title: 'No applications yet',
              message: 'Browse open roles and apply to get started',
              actionLabel: 'Browse Roles',
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: applications.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final app = applications[index];
              return _ApplicationCard(application: app);
            },
          );
        },
      ),
    );
  }
}

class _ApplicationCard extends StatelessWidget {
  final dynamic application;

  const _ApplicationCard({required this.application});

  Color _statusColor(String status) {
    switch (status) {
      case 'applied':
        return AppColors.info;
      case 'shortlisted':
        return Colors.amber.shade700;
      case 'selected':
        return AppColors.success;
      case 'rejected':
        return AppColors.error;
      default:
        return AppColors.textTertiary;
    }
  }

  IconData _statusIcon(String status) {
    switch (status) {
      case 'applied':
        return Icons.pending;
      case 'shortlisted':
        return Icons.star_outline;
      case 'selected':
        return Icons.check_circle;
      case 'rejected':
        return Icons.cancel;
      default:
        return Icons.help_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClubAvatar(
                  name: application.clubName,
                  imageUrl: application.clubLogoUrl,
                  size: 44,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        application.roleTitle,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        application.clubName,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Status tracker
            Row(
              children: [
                _StatusDot(
                  label: 'Applied',
                  isActive: true,
                  isCompleted: true,
                  color: AppColors.info,
                ),
                _StatusLine(
                  isActive: application.status == 'shortlisted' ||
                      application.status == 'selected',
                ),
                _StatusDot(
                  label: 'Shortlisted',
                  isActive: application.status == 'shortlisted' ||
                      application.status == 'selected',
                  isCompleted: application.status == 'shortlisted' ||
                      application.status == 'selected',
                  color: Colors.amber.shade700,
                ),
                _StatusLine(
                  isActive: application.status == 'selected',
                ),
                _StatusDot(
                  label: 'Selected',
                  isActive: application.status == 'selected',
                  isCompleted: application.status == 'selected',
                  color: AppColors.success,
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Status pill
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: _statusColor(application.status)
                        .withValues(alpha: 0.12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _statusIcon(application.status),
                        size: 16,
                        color: _statusColor(application.status),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        application.status[0].toUpperCase() +
                            application.status.substring(1),
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: _statusColor(application.status),
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Text(
                  'Applied ${AppUtils.timeAgo(application.appliedAt)}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusDot extends StatelessWidget {
  final String label;
  final bool isActive;
  final bool isCompleted;
  final Color color;

  const _StatusDot({
    required this.label,
    required this.isActive,
    required this.isCompleted,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? color : Colors.grey.shade200,
          ),
          child: isCompleted
              ? const Icon(Icons.check, size: 16, color: Colors.white)
              : null,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: isActive ? color : AppColors.textTertiary,
          ),
        ),
      ],
    );
  }
}

class _StatusLine extends StatelessWidget {
  final bool isActive;

  const _StatusLine({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 3,
        margin: const EdgeInsets.only(bottom: 18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2),
          color: isActive ? AppColors.primary : Colors.grey.shade200,
        ),
      ),
    );
  }
}
