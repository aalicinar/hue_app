import 'package:go_router/go_router.dart';
import '../features/shell/shell_screen.dart';
import '../features/splash/splash_screen.dart';
import '../features/onboarding/onboarding_a_screen.dart';
import '../features/onboarding/onboarding_b_screen.dart';
import '../features/onboarding/onboarding_c_screen.dart';
import '../features/home/presence_board_screen.dart';
import '../features/conversation/conversation_screen.dart';
import '../features/settings/settings_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    // ── No-shell routes ─────────────────────────────────────────────
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/onboarding-a',
      builder: (context, state) => const OnboardingAScreen(),
    ),
    GoRoute(
      path: '/onboarding-b',
      builder: (context, state) => const OnboardingBScreen(),
    ),
    GoRoute(
      path: '/onboarding-c',
      builder: (context, state) => const OnboardingCScreen(),
    ),

    // ── Shell routes (with bottom nav) ──────────────────────────────
    ShellRoute(
      builder: (context, state, child) => ShellScreen(child: child),
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, state) => const PresenceBoardScreen(),
        ),
        GoRoute(
          path: '/conversation/:contactId',
          builder: (context, state) {
            final contactId = state.pathParameters['contactId']!;
            return ConversationScreen(contactId: contactId);
          },
        ),
        GoRoute(
          path: '/settings',
          builder: (context, state) => const SettingsScreen(),
        ),
      ],
    ),
  ],
);
