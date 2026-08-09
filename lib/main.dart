import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app.dart';
import 'core/services/local_storage_service.dart';

// Global flag to track Firebase initialization status
bool isFirebaseInitialized = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  print('🚀 [DIAGNOSTIC] App Starting (Sync Mode)...');
  
  // 1. Initialize Firebase (Real Backend Core)
  try {
    // Note: In a production environment, you'd use DefaultFirebaseOptions
    await Firebase.initializeApp();
    isFirebaseInitialized = true;
    print('🔥 [FIREBASE] Successfully Initialized Core Services');
  } catch (e) {
    print('⚠️ [FIREBASE] Initialization failed or skipped: $e');
    isFirebaseInitialized = false;
  }

  // 2. Initialize Local Storage (Critical for "Stay Logged In")
  final prefs = await SharedPreferences.getInstance();
  
  // We launch the app with an initial state
  runApp(
    ProviderScope(
      overrides: [
        // We can optionally override the provider here if we didn't use the FutureProvider pattern correctly
        // but for now we'll let the provider handle it via the static instance if needed.
      ],
      child: const NextUtsavApp(),
    ),
  );
  
  print('✅ [DIAGNOSTIC] App Launched');
}

