import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/models.dart';
import '../../../core/services/mock_data_service.dart';

final notificationsProvider = StateNotifierProvider<NotificationsNotifier,
    AsyncValue<List<AppNotification>>>((ref) {
  return NotificationsNotifier();
});

class NotificationsNotifier
    extends StateNotifier<AsyncValue<List<AppNotification>>> {
  NotificationsNotifier() : super(const AsyncValue.loading()) {
    _load();
  }

  Future<void> _load() async {
    await Future.delayed(const Duration(milliseconds: 500));
    state = AsyncValue.data(List.from(MockDataService.notifications));
  }

  void markAsRead(String id) {
    state.whenData((notifications) {
      state = AsyncValue.data(
        notifications.map((n) {
          if (n.id == id) return n.copyWith(isRead: true);
          return n;
        }).toList(),
      );
    });
  }

  void dismiss(String id) {
    state.whenData((notifications) {
      state = AsyncValue.data(
        notifications.where((n) => n.id != id).toList(),
      );
    });
  }

  void markAllRead() {
    state.whenData((notifications) {
      state = AsyncValue.data(
        notifications.map((n) => n.copyWith(isRead: true)).toList(),
      );
    });
  }
}
