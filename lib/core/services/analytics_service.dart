import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../main.dart'; // To access isFirebaseInitialized

// Provides a singleton of AnalyticsService
final analyticsServiceProvider = Provider<AnalyticsService>((ref) {
  return AnalyticsService();
});

class AnalyticsService {
  FirebaseAnalytics? _analytics;

  AnalyticsService() {
    if (isFirebaseInitialized) {
      try {
        _analytics = FirebaseAnalytics.instance;
      } catch (e) {
        if (kDebugMode) {
          print('📊 [ANALYTICS] Error getting FirebaseAnalytics instance: $e');
        }
      }
    } else {
      if (kDebugMode) {
        print('📊 [ANALYTICS] Firebase not initialized, Analytics will be disabled.');
      }
    }
  }

  FirebaseAnalytics? get analytics => _analytics;

  FirebaseAnalyticsObserver? getAnalyticsObserver() {
    if (_analytics != null) {
      return FirebaseAnalyticsObserver(analytics: _analytics!);
    }
    return null;
  }

  Future<void> logEvent(String name, {Map<String, Object>? parameters}) async {
    if (_analytics == null) return;
    
    try {
      if (kDebugMode) {
        print('📊 [ANALYTICS] Event: $name | Params: $parameters');
      }
      await _analytics!.logEvent(name: name, parameters: parameters);
    } catch (e) {
      if (kDebugMode) {
        print('📊 [ANALYTICS] Failed to log event: $e');
      }
    }
  }

  Future<void> logScreenView(String screenName) async {
    if (_analytics == null) return;

    try {
      if (kDebugMode) {
        print('📊 [ANALYTICS] Screen View: $screenName');
      }
      await _analytics!.logScreenView(screenName: screenName);
    } catch (e) {
      // Ignore gracefully
    }
  }

  Future<void> logLogin({required String method}) async {
    await _analytics?.logLogin(loginMethod: method);
  }

  Future<void> logSignUp({required String method}) async {
    await _analytics?.logSignUp(signUpMethod: method);
  }

  Future<void> setUserProperty(String name, String value) async {
    await _analytics?.setUserProperty(name: name, value: value);
  }
}
