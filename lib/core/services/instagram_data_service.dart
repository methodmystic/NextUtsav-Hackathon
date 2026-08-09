import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';
import 'mock_data_service.dart';

class InstagramDataService {
  /// Loads club data from the generated JSON file
  static Future<List<Club>> loadClubs() async {
    try {
      final jsonString = await rootBundle.loadString('assets/data/clubs_data.json');
      final List<dynamic> jsonList = json.decode(jsonString);
      
      return jsonList.map((json) {
        return Club(
          id: json['id'],
          name: json['name'],
          category: json['category'],
          description: json['description'] ?? json['bio'],
          followersCount: json['followersCount'] ?? 0,
          memberCount: json['memberCount'] ?? 0,
          logoUrl: json['logoUrl'] != null && json['logoUrl'].toString().isNotEmpty 
              ? json['logoUrl'] 
              : 'https://images.unsplash.com/photo-1522071820081-009f0129c71c?w=400&q=80',
          coverUrl: json['coverUrl'] != null && json['coverUrl'].toString().isNotEmpty 
              ? json['coverUrl']
              : 'https://images.unsplash.com/photo-1542831371-29b0f74f9713?w=800&q=80',
          collegeId: json['collegeId'],
          achievements: List<String>.from(json['achievements'] ?? []),
        );
      }).toList();
    } catch (e) {
      print('Error loading Instagram club data: $e');
      // Fallback to purely mock data
      return MockDataService.clubs.toList();
    }
  }
}

final realClubsProvider = FutureProvider<List<Club>>((ref) async {
  return InstagramDataService.loadClubs();
});
