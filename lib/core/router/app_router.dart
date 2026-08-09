import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../services/analytics_service.dart';
import '../../features/auth/screens/splash_screen.dart';
import '../../features/auth/screens/college_picker_screen.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/interest_tags_screen.dart';
import '../../features/auth/screens/suggested_clubs_screen.dart';
import '../../features/feed/screens/feed_screen.dart';
import '../../features/feed/screens/post_detail_screen.dart';
import '../../features/discover/screens/discover_screen.dart';
import '../../features/events/screens/events_screen.dart';
import '../../features/events/screens/event_detail_screen.dart';
import '../../features/activity/screens/activity_screen.dart';
import '../../features/profile/screens/profile_screen.dart';
import '../../features/profile/screens/saved_posts_screen.dart';
import '../../features/clubs/screens/club_detail_screen.dart';
import '../../features/notifications/screens/notifications_screen.dart';
import '../../features/recruitment/screens/recruitment_list_screen.dart';
import '../../features/recruitment/screens/apply_screen.dart';
import '../../features/recruitment/screens/application_status_screen.dart';
import '../../features/hackathons/screens/hackathon_hub_screen.dart';
import '../../features/academic/screens/faculty_dashboard_screen.dart';
import '../../features/academic/screens/college_calendar_screen.dart';
import '../../features/auth/screens/forgot_password_screen.dart';
import '../../features/auth/screens/signup_screen.dart';
import '../../features/auth/screens/email_verification_screen.dart';
import '../../features/settings/screens/bug_report_screen.dart';
import '../../features/settings/screens/terms_of_service_screen.dart';
import '../../features/academic/screens/attendance_history_screen.dart';
import '../widgets/main_shell.dart';

class AppRoutes {
  static const splash = '/';
  static const collegePicker = '/college-picker';
  static const login = '/login';
  static const signup = '/signup';
  static const interestTags = '/interest-tags';
  static const suggestedClubs = '/suggested-clubs';
  static const home = '/home';
  static const clubs = '/clubs';
  static const hackathons = '/hackathons';
  static const rankings = '/rankings';
  static const profile = '/profile';
  static const clubDetail = '/club/:id';
  static const eventDetail = '/event/:id';
  static const postDetail = '/post/:id';
  static const notifications = '/notifications';
  static const recruitmentList = '/recruitment';
  static const apply = '/recruitment/apply/:roleId';
  static const applicationStatus = '/recruitment/status';
  static const savedPosts = '/profile/saved';
  static const facultyDashboard = '/faculty-dashboard';
  static const collegeCalendar = '/college-calendar';
  static const forgotPassword = '/forgot-password';
  static const emailVerification = '/email-verification';
  static const bugReport = '/bug-report';
  static const termsOfService = '/terms';
  static const attendanceHistory = '/attendance-history';
}

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final appRouterProvider = Provider<GoRouter>((ref) {
  final analyticsObserver = ref.watch(analyticsServiceProvider).getAnalyticsObserver();

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.splash,
    observers: [
      if (analyticsObserver != null) analyticsObserver,
    ],
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.collegePicker,
        builder: (context, state) => const CollegePickerScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.signup,
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: AppRoutes.interestTags,
        builder: (context, state) => const InterestTagsScreen(),
      ),
      GoRoute(
        path: AppRoutes.suggestedClubs,
        builder: (context, state) => const SuggestedClubsScreen(),
      ),
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          GoRoute(
            path: AppRoutes.home,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: FeedScreen(),
            ),
          ),
          GoRoute(
            path: AppRoutes.clubs,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: DiscoverScreen(), // Will rename content to Clubs
            ),
          ),
          GoRoute(
            path: AppRoutes.hackathons,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: HackathonHubScreen(),
            ),
          ),
          GoRoute(
            path: AppRoutes.rankings,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: ActivityScreen(), // Will rename content to Rankings
            ),
          ),
          GoRoute(
            path: AppRoutes.profile,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: ProfileScreen(),
            ),
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.clubDetail,
        builder: (context, state) {
          final clubId = state.pathParameters['id']!;
          return ClubDetailScreen(clubId: clubId);
        },
      ),
      GoRoute(
        path: AppRoutes.eventDetail,
        builder: (context, state) {
          final eventId = state.pathParameters['id']!;
          return EventDetailScreen(eventId: eventId);
        },
      ),
      GoRoute(
        path: AppRoutes.postDetail,
        builder: (context, state) {
          final postId = state.pathParameters['id']!;
          return PostDetailScreen(postId: postId);
        },
      ),
      GoRoute(
        path: AppRoutes.notifications,
        builder: (context, state) => const NotificationsScreen(),
      ),
      GoRoute(
        path: AppRoutes.recruitmentList,
        builder: (context, state) => const RecruitmentListScreen(),
      ),
      GoRoute(
        path: AppRoutes.apply,
        builder: (context, state) {
          final roleId = state.pathParameters['roleId']!;
          return ApplyScreen(roleId: roleId);
        },
      ),
      GoRoute(
        path: AppRoutes.applicationStatus,
        builder: (context, state) => const ApplicationStatusScreen(),
      ),
      GoRoute(
        path: AppRoutes.facultyDashboard,
        builder: (context, state) => const FacultyDashboardScreen(),
      ),
      GoRoute(
        path: AppRoutes.collegeCalendar,
        builder: (context, state) => const CollegeCalendarScreen(),
      ),
      GoRoute(
        path: AppRoutes.savedPosts,
        builder: (context, state) => const SavedPostsScreen(),
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: AppRoutes.emailVerification,
        builder: (context, state) => const EmailVerificationScreen(),
      ),
      GoRoute(
        path: AppRoutes.bugReport,
        builder: (context, state) => const BugReportScreen(),
      ),
      GoRoute(
        path: AppRoutes.termsOfService,
        builder: (context, state) => const TermsOfServiceScreen(),
      ),
      GoRoute(
        path: AppRoutes.attendanceHistory,
        builder: (context, state) => const AttendanceHistoryScreen(),
      ),
    ],
  );
});
