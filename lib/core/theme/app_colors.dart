import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Vibrant Hyper-Colors
  static const Color primary = Color(0xFF6366F1); // Electric Indigo
  static const Color secondary = Color(0xFF06B6D4); // Cyan Surge
  static const Color accent = Color(0xFFF43F5E); // Rose Fire
  static const Color success = Color(0xFF10B981); // Emerald Green
  static const Color error = Color(0xFFEF4444); // Red Danger
  static const Color info = Color(0xFF3B82F6); // Blue Sky
  static const Color warning = Color(0xFFF59E0B); // Amber Warning

  // Surface Colors
  static const Color surface = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFF8FAFC);
  static const Color surfaceVariant = Color(0xFFF1F5F9);

  // Dark Mode - Deep Space
  static const Color darkBackground = Color(0xFF0F172A);
  static const Color darkSurface = Color(0xFF1E293B);
  static const Color darkCard = Color(0xFF334155);

  // Text Hierarchy
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF475569);
  static const Color textTertiary = Color(0xFF94A3B8);
  static const Color darkTextPrimary = Colors.white;
  static const Color darkTextSecondary = Color(0xFF94A3B8);
  static const Color cardBackground = Colors.white;

  // Glassmorphism support
  static Color glass(Color color, [double opacity = 0.1]) => color.withValues(alpha: opacity);

  // Ultra Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF6366F1), Color(0xFFA855F7)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cosmicGradient = LinearGradient(
    colors: [Color(0xFF06B6D4), Color(0xFF3B82F6), Color(0xFF6366F1)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient fireGradient = LinearGradient(
    colors: [Color(0xFFF43F5E), Color(0xFFFB923C)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient glassGradient = LinearGradient(
    colors: [Colors.white24, Colors.white12],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = fireGradient;
  static const LinearGradient heroGradient = primaryGradient;

  // Category Highlighters
  static const Map<String, Color> categoryColors = {
    'Technical': Color(0xFF6366F1),
    'Cultural': Color(0xFFEC4899),
    'Sports': Color(0xFFF59E0B),
    'Music': Color(0xFF8B5CF6),
    'Hackathon': Color(0xFF10B981),
    'Workshop': Color(0xFF3B82F6),
  };
}
