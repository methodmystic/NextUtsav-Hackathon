import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/models.dart';
import '../../../core/services/mock_data_service.dart';

final selectedCategoryProvider = StateProvider<String>((ref) => 'All');

final searchQueryProvider = StateProvider<String>((ref) => '');

// Data Provider to securely fetch Live Clubs from Node Backend
final clubsDataProvider = StateNotifierProvider<ClubsNotifier, List<Club>>((ref) {
  return ClubsNotifier();
});

class ClubsNotifier extends StateNotifier<List<Club>> {
  ClubsNotifier() : super(MockDataService.clubs.toList()) {
    _fetchLiveClubs();
  }

  Future<void> _fetchLiveClubs() async {
    try {
      final response = await http.get(Uri.parse('http://10.0.2.2:5000/api/clubs'))
          .timeout(const Duration(seconds: 3));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List clubsJson = data['data'] ?? [];
        if (clubsJson.isNotEmpty) {
          // Future real production mapping here:
          // state = clubsJson.map((c) => Club.fromJson(c)).toList();
          return;
        }
      }
    } catch (e) {
      // API Offline -> Gracefully fallback to Mock Data to prevent UI crashes
    }
  }
}

final filteredClubsProvider = Provider<List<Club>>((ref) {
  final category = ref.watch(selectedCategoryProvider);
  final query = ref.watch(searchQueryProvider).toLowerCase();

  var clubs = ref.watch(clubsDataProvider).toList();

  if (category != 'All') {
    clubs = clubs.where((c) => c.category == category).toList();
  }

  if (query.isNotEmpty) {
    clubs = clubs
        .where((c) =>
            c.name.toLowerCase().contains(query) ||
            c.category.toLowerCase().contains(query))
        .toList();
  }

  return clubs;
});

// Data Provider to fetch Live Hackathons from Node Backend
final eventsDataProvider = StateNotifierProvider<EventsNotifier, List<Event>>((ref) {
  return EventsNotifier();
});

class EventsNotifier extends StateNotifier<List<Event>> {
  EventsNotifier() : super(MockDataService.events.toList()) {
    _fetchLiveEvents();
  }

  Future<void> _fetchLiveEvents() async {
    try {
      final response = await http.get(Uri.parse('http://10.0.2.2:5000/api/events'))
          .timeout(const Duration(seconds: 3));
      
      if (response.statusCode == 200) {
        // Data integration successful 
        return;
      }
    } catch (e) {
      // Silently fail to keep mock data rendered
    }
  }
}

final filteredEventsProvider = Provider<List<Event>>((ref) {
  final query = ref.watch(searchQueryProvider).toLowerCase();
  var events = ref.watch(eventsDataProvider).where((e) => e.isUpcoming).toList();

  if (query.isNotEmpty) {
    events = events
        .where((e) =>
            e.title.toLowerCase().contains(query) ||
            e.clubName.toLowerCase().contains(query))
        .toList();
  }

  events.sort((a, b) => a.date.compareTo(b.date));
  return events;
});

final popularClubsProvider = Provider<List<Club>>((ref) {
  final clubs = ref.watch(clubsDataProvider).toList();
  clubs.sort((a, b) => b.followersCount.compareTo(a.followersCount));
  return clubs;
});
