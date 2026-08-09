import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/models/models.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_utils.dart';
import '../../../core/widgets/shared_widgets.dart';
import '../providers/notifications_provider.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsAsync = ref.watch(notificationsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          TextButton(
            onPressed: () =>
                ref.read(notificationsProvider.notifier).markAllRead(),
            child: const Text(
              'Mark all read',
              style: TextStyle(fontSize: 13),
            ),
          ),
        ],
      ),
      body: notificationsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => EmptyStateWidget(
          icon: Icons.error_outline,
          title: 'Error',
          message: e.toString(),
        ),
        data: (notifications) {
          if (notifications.isEmpty) {
            return const EmptyStateWidget(
              icon: Icons.notifications_off_outlined,
              title: 'No notifications',
              message: 'You\'re all caught up!',
            );
          }

          // Group notifications
          final today = <AppNotification>[];
          final thisWeek = <AppNotification>[];
          final earlier = <AppNotification>[];

          for (final n in notifications) {
            final diff = DateTime.now().difference(n.createdAt);
            if (diff.inHours < 24) {
              today.add(n);
            } else if (diff.inDays < 7) {
              thisWeek.add(n);
            } else {
              earlier.add(n);
            }
          }

          return ListView(
            padding: const EdgeInsets.symmetric(vertical: 8),
            children: [
              if (today.isNotEmpty) ...[
                _SectionLabel(label: 'Today'),
                ...today.map((n) => _NotificationTile(
                      notification: n,
                      onTap: () => _handleTap(context, ref, n),
                      onDismiss: () => ref
                          .read(notificationsProvider.notifier)
                          .dismiss(n.id),
                    )),
              ],
              if (thisWeek.isNotEmpty) ...[
                _SectionLabel(label: 'This Week'),
                ...thisWeek.map((n) => _NotificationTile(
                      notification: n,
                      onTap: () => _handleTap(context, ref, n),
                      onDismiss: () => ref
                          .read(notificationsProvider.notifier)
                          .dismiss(n.id),
                    )),
              ],
              if (earlier.isNotEmpty) ...[
                _SectionLabel(label: 'Earlier'),
                ...earlier.map((n) => _NotificationTile(
                      notification: n,
                      onTap: () => _handleTap(context, ref, n),
                      onDismiss: () => ref
                          .read(notificationsProvider.notifier)
                          .dismiss(n.id),
                    )),
              ],
            ],
          );
        },
      ),
    );
  }

  void _handleTap(BuildContext context, WidgetRef ref, AppNotification n) {
    ref.read(notificationsProvider.notifier).markAsRead(n.id);
    if (n.targetId != null) {
      if (n.type == 'event') {
        context.push('/event/${n.targetId}');
      } else if (n.type == 'club') {
        context.push('/club/${n.targetId}');
      } else if (n.type == 'recruitment') {
        context.push('/recruitment/status');
      }
    }
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: AppColors.textTertiary,
              fontWeight: FontWeight.w700,
            ),
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final AppNotification notification;
  final VoidCallback? onTap;
  final VoidCallback? onDismiss;

  const _NotificationTile({
    required this.notification,
    this.onTap,
    this.onDismiss,
  });

  Color get _iconColor {
    switch (notification.type) {
      case 'event':
        return AppColors.primary;
      case 'club':
        return AppColors.accent;
      case 'badge':
        return Colors.amber;
      case 'recruitment':
        return AppColors.info;
      default:
        return AppColors.textSecondary;
    }
  }

  IconData get _icon {
    switch (notification.type) {
      case 'event':
        return Icons.event;
      case 'club':
        return Icons.groups;
      case 'badge':
        return Icons.emoji_events;
      case 'recruitment':
        return Icons.work;
      default:
        return Icons.notifications;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDismiss?.call(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: AppColors.error.withValues(alpha: 0.1),
        child: const Icon(Icons.delete_outline, color: AppColors.error),
      ),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          color: notification.isRead
              ? Colors.transparent
              : AppColors.primary.withValues(alpha: 0.04),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: _iconColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(_icon, color: _iconColor, size: 20),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notification.title,
                      style: TextStyle(
                        fontWeight: notification.isRead
                            ? FontWeight.w500
                            : FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification.body,
                      style: Theme.of(context).textTheme.bodySmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      AppUtils.timeAgo(notification.createdAt),
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
              if (!notification.isRead)
                Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.only(top: 6),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
