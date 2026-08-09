import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/models.dart';
import '../../../core/services/mock_data_service.dart';

final eventFilterProvider = StateProvider<String>((ref) => 'All');
final eventViewModeProvider = StateProvider<bool>((ref) => true); // true = list, false = calendar

final eventsListProvider =
    StateNotifierProvider<EventsNotifier, AsyncValue<List<Event>>>((ref) {
  return EventsNotifier();
});

class EventsNotifier extends StateNotifier<AsyncValue<List<Event>>> {
  EventsNotifier() : super(const AsyncValue.loading()) {
    _load();
  }

  Future<void> _load() async {
    await Future.delayed(const Duration(milliseconds: 600));
    state = AsyncValue.data(List.from(MockDataService.events));
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    await _load();
  }

  void toggleRegistration(String eventId) {
    state.whenData((events) {
      state = AsyncValue.data(
        events.map((e) {
          if (e.id == eventId) {
            return e.copyWith(isRegistered: !e.isRegistered);
          }
          return e;
        }).toList(),
      );
    });
  }
}

final filteredEventsListProvider = Provider<List<Event>>((ref) {
  final filter = ref.watch(eventFilterProvider);
  final eventsAsync = ref.watch(eventsListProvider);

  return eventsAsync.when(
    loading: () => [],
    error: (_, __) => [],
    data: (events) {
      switch (filter) {
        case 'Registered':
          return events.where((e) => e.isRegistered).toList();
        case 'Upcoming':
          return events.where((e) => e.isUpcoming).toList();
        case 'Past':
          return events.where((e) => e.isPast).toList();
        default:
          return events;
      }
    },
  );
});
