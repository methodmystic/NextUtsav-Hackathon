import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_utils.dart';
import '../../../core/widgets/shared_widgets.dart';
import '../providers/recruitment_provider.dart';

class RecruitmentListScreen extends ConsumerWidget {
  const RecruitmentListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rolesAsync = ref.watch(recruitmentRolesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Open Roles'),
        actions: [
          TextButton.icon(
            onPressed: () => context.push('/recruitment/status'),
            icon: const Icon(Icons.assignment_outlined, size: 18),
            label: const Text('My Apps'),
          ),
        ],
      ),
      body: rolesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => EmptyStateWidget(
          icon: Icons.error_outline,
          title: 'Error',
          message: e.toString(),
        ),
        data: (roles) {
          if (roles.isEmpty) {
            return const EmptyStateWidget(
              icon: Icons.work_off_outlined,
              title: 'No open roles',
              message: 'Check back later for new opportunities',
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: roles.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final role = roles[index];
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          ClubAvatar(
                            name: role.clubName,
                            imageUrl: role.clubLogoUrl,
                            size: 48,
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  role.roleTitle,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  role.clubName,
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        role.description,
                        style: Theme.of(context).textTheme.bodyMedium,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Icon(Icons.calendar_today,
                              size: 14, color: AppColors.textTertiary),
                          const SizedBox(width: 4),
                          Text(
                            'Deadline: ${AppUtils.formatDate(role.deadline)}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '${role.applicantsCount} applicants',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textTertiary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: AppButton(
                          label: role.isOpen ? 'Apply Now' : 'Closed',
                          onPressed: role.isOpen
                              ? () =>
                                  context.push('/recruitment/apply/${role.id}')
                              : null,
                          variant: AppButtonVariant.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
