import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tall_us/core/screens/home_screen_with_nav.dart';
import 'package:tall_us/core/theme/app_theme.dart';
import 'package:tall_us/features/admin/presentation/screens/admin_scaffold.dart';
import 'package:tall_us/features/admin/presentation/screens/admin_dashboard_screen.dart';
import 'package:tall_us/features/admin/presentation/screens/admin_users_screen.dart';
import 'package:tall_us/features/admin/presentation/screens/admin_user_detail_screen.dart';
import 'package:tall_us/features/admin/presentation/screens/admin_verifications_screen.dart';
import 'package:tall_us/features/admin/presentation/screens/admin_newsletters_screen.dart';
import 'package:tall_us/features/admin/presentation/screens/admin_newsletter_edit_screen.dart';
import 'package:tall_us/features/admin/presentation/screens/admin_templates_screen.dart';
import 'package:tall_us/features/admin/presentation/screens/admin_template_edit_screen.dart';
import 'package:tall_us/features/admin/presentation/screens/admin_analytics_screen.dart';
import 'package:tall_us/features/admin/presentation/providers/admin_providers.dart';
import 'package:tall_us/features/auth/presentation/providers/auth_providers.dart';
import 'package:tall_us/features/auth/presentation/providers/auth_state.dart';
import 'package:tall_us/features/auth/presentation/screens/email_verification_callback_screen.dart';
import 'package:tall_us/features/auth/presentation/screens/email_verification_screen.dart';
import 'package:tall_us/features/auth/presentation/screens/email_verification_success_screen.dart';
import 'package:tall_us/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:tall_us/features/auth/presentation/screens/login_screen.dart';
import 'package:tall_us/features/auth/presentation/screens/register_screen.dart';
import 'package:tall_us/features/auth/presentation/screens/splash_screen.dart';
import 'package:tall_us/features/coaching/presentation/screens/coaching_screen.dart';
import 'package:tall_us/features/deals/presentation/screens/tall_deals_screen.dart';
import 'package:tall_us/features/legal/presentation/screens/legal_screen.dart';
import 'package:tall_us/features/events/presentation/screens/event_detail_screen.dart';
import 'package:tall_us/features/events/presentation/screens/events_screen.dart';
import 'package:tall_us/features/notification/presentation/screens/notifications_screen.dart';
import 'package:tall_us/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:tall_us/features/profile/presentation/providers/profile_provider.dart';
import 'package:tall_us/features/subscription/presentation/screens/subscription_screen.dart';
import 'package:tall_us/features/swipe/presentation/screens/likes_received_screen.dart';
import 'package:tall_us/features/verification/presentation/screens/height_verification_screen.dart';
import 'package:tall_us/features/landing/presentation/pages/landing_page.dart';

/// App Router Configuration
///
/// Defines all routes and navigation logic using go_router
class AppRouter {
  static GoRouter createRouter(Ref ref) {
    // Notifier that triggers a router refresh whenever auth state changes,
    // so the redirect re-evaluates on login/logout/loading resolution.
    final refreshNotifier = _AuthRefreshNotifier();
    ref.listen<AuthState>(authStateProvider, (prev, next) {
      // When a user becomes authenticated, ensure their profile is loaded
      // so the onboarding gate can decide their destination.
      next.maybeWhen(
        authenticated: (user) {
          if (ref.read(profileProvider).profile == null) {
            ref.read(profileProvider.notifier).loadProfile(user.id);
          }
        },
        orElse: () {},
      );
      refreshNotifier.fire();
    });
    // Also refresh when the profile state changes (e.g. once it loads, or
    // after onboarding sets onboardingCompleted = true).
    ref.listen(profileProvider, (_, __) {
      refreshNotifier.fire();
    });
    ref.onDispose(refreshNotifier.dispose);

    return GoRouter(
      initialLocation: '/',
      debugLogDiagnostics: true,
      refreshListenable: refreshNotifier,
      redirect: (context, state) {
        final authState = ref.read(authStateProvider);
        final isAuthenticated = authState.maybeWhen(
          authenticated: (_) => true,
          orElse: () => false,
        );
        final needsVerification = authState.maybeWhen(
          needsVerification: (_, __) => true,
          orElse: () => false,
        );
        final isLoading = authState.maybeWhen(
          loading: () => true,
          initial: () => true,
          orElse: () => false,
        );

        // Get current path
        final currentPath = state.uri.path;

        // Public routes accessible without auth
        final isPublicRoute = currentPath == '/' ||
            currentPath == '/splash' ||
            currentPath == '/login' ||
            currentPath == '/register' ||
            currentPath == '/forgot-password' ||
            currentPath == '/verify-email' ||
            currentPath == '/verify-email/success' ||
            currentPath == '/auth/verify-email' ||
            currentPath == '/legal/terms' ||
            currentPath == '/legal/privacy';

        // While checking auth status, keep the user where they are so deep
        // links (e.g. /admin) are preserved once auth resolves. Only the root
        // shows the splash. The refreshListenable will re-run the redirect
        // once the auth state resolves.
        if (isLoading) {
          if (currentPath == '/') return '/splash';
          return null;
        }

        // If needs email verification, redirect to verify-email
        if (needsVerification) {
          if (currentPath == '/verify-email' ||
              currentPath == '/verify-email/success' ||
              currentPath == '/auth/verify-email' ||
              currentPath == '/login') {
            return null; // Allow access to these routes
          }
          return '/verify-email';
        }

        // If not authenticated and trying to access protected routes
        if (!isAuthenticated) {
          if (isPublicRoute) {
            return null;
          }
          // Redirect admin & other protected routes to login
          return '/login';
        }

        // Authenticated: decide between onboarding and home based on the
        // loaded profile.
        if (isAuthenticated) {
          final profileState = ref.read(profileProvider);
          final profile = profileState.profile;

          // Profile not loaded yet: hold on splash until it loads (the
          // listener above loads it on auth, then fires a refresh).
          if (profile == null) {
            if (currentPath == '/splash' || currentPath == '/onboarding') {
              return null;
            }
            return '/splash';
          }

          final needsOnboarding = !profile.onboardingCompleted;
          if (needsOnboarding) {
            // Allow the onboarding wizard and the height-verification flow
            // (reached from the wizard's "Verify now" button) while incomplete.
            if (currentPath == '/onboarding' ||
                currentPath == '/verify-height') {
              return null;
            }
            return '/onboarding';
          }

          // Already onboarded: bounce auth/splash/onboarding routes to home.
          if (currentPath == '/login' ||
              currentPath == '/register' ||
              currentPath == '/forgot-password' ||
              currentPath == '/splash' ||
              currentPath == '/verify-email' ||
              currentPath == '/onboarding') {
            return '/home';
          }
        }

        // Default: no redirect
        return null;
      },
      routes: [
        // Landing Page (Root)
        GoRoute(
          path: '/',
          name: 'landing',
          builder: (context, state) => const LandingPage(),
        ),

        // Splash Screen
        GoRoute(
          path: '/splash',
          name: 'splash',
          builder: (context, state) => const SplashScreen(),
        ),

        // Login Screen
        GoRoute(
          path: '/login',
          name: 'login',
          builder: (context, state) => const LoginScreen(),
        ),

        // Register Screen
        GoRoute(
          path: '/register',
          name: 'register',
          builder: (context, state) => const RegisterScreen(),
        ),

        // Forgot Password Screen
        GoRoute(
          path: '/forgot-password',
          name: 'forgot_password',
          builder: (context, state) => const ForgotPasswordScreen(),
        ),

        // Email Verification Screen (after registration)
        GoRoute(
          path: '/verify-email',
          name: 'verify_email',
          builder: (context, state) => const EmailVerificationScreen(),
        ),

        // Email Verification Success Screen
        GoRoute(
          path: '/verify-email/success',
          name: 'verify_email_success',
          builder: (context, state) => const EmailVerificationSuccessScreen(),
        ),

        // Email Verification Callback (Appwrite redirect URL)
        GoRoute(
          path: '/auth/verify-email',
          name: 'auth_verify_email',
          builder: (context, state) {
            final userId = state.uri.queryParameters['userId'];
            final secret = state.uri.queryParameters['secret'];
            return EmailVerificationCallbackScreen(
              userId: userId,
              secret: secret,
            );
          },
        ),

        // Notifications (full page)
        GoRoute(
          path: '/notifications',
          name: 'notifications',
          builder: (context, state) => const NotificationsScreen(),
        ),

        // Likes received (who liked me)
        GoRoute(
          path: '/likes',
          name: 'likes',
          builder: (context, state) => const LikesReceivedScreen(),
        ),

        // Onboarding wizard (first-time users)
        GoRoute(
          path: '/onboarding',
          name: 'onboarding',
          builder: (context, state) => const OnboardingScreen(),
        ),

        // Height verification flow
        GoRoute(
          path: '/verify-height',
          name: 'verify_height',
          builder: (context, state) => const HeightVerificationScreen(),
        ),

        // Profile enrichment sections
        GoRoute(
          path: '/events',
          name: 'events',
          builder: (context, state) => const EventsScreen(),
        ),
        GoRoute(
          path: '/events/:id',
          name: 'event_detail',
          builder: (context, state) => EventDetailScreen(
            eventId: state.pathParameters['id'] ?? '',
          ),
        ),
        GoRoute(
          path: '/coaching',
          name: 'coaching',
          builder: (context, state) => const CoachingScreen(),
        ),
        GoRoute(
          path: '/subscription',
          name: 'subscription',
          builder: (context, state) => const SubscriptionScreen(),
        ),
        GoRoute(
          path: '/tall-deals',
          name: 'tall_deals',
          builder: (context, state) => const TallDealsScreen(),
        ),

        // Legal pages (accessible pre-login)
        GoRoute(
          path: '/legal/terms',
          name: 'legal_terms',
          builder: (context, state) => LegalScreen.terms(),
        ),
        GoRoute(
          path: '/legal/privacy',
          name: 'legal_privacy',
          builder: (context, state) => LegalScreen.privacy(),
        ),

        // Home Screen with bottom navigation
        GoRoute(
          path: '/home',
          name: 'home',
          builder: (context, state) => const HomeScreenWithNav(),
        ),

        // Admin routes (web only, admin role required)
        ShellRoute(
          builder: (context, state, child) {
            return AdminGuard(child: child);
          },
          routes: [
            GoRoute(
              path: '/admin',
              name: 'admin_dashboard',
              builder: (context, state) => const AdminDashboardScreen(),
            ),
            GoRoute(
              path: '/admin/users',
              name: 'admin_users',
              builder: (context, state) => const AdminUsersScreen(),
            ),
            GoRoute(
              path: '/admin/users/:id',
              name: 'admin_user_detail',
              builder: (context, state) => AdminUserDetailScreen(
                userId: state.pathParameters['id'] ?? '',
              ),
            ),
            GoRoute(
              path: '/admin/verifications',
              name: 'admin_verifications',
              builder: (context, state) => const AdminVerificationsScreen(),
            ),
            GoRoute(
              path: '/admin/newsletters',
              name: 'admin_newsletters',
              builder: (context, state) => const AdminNewslettersScreen(),
            ),
            GoRoute(
              path: '/admin/newsletters/new',
              name: 'admin_newsletter_new',
              builder: (context, state) => const AdminNewsletterEditScreen(),
            ),
            GoRoute(
              path: '/admin/newsletters/:id/edit',
              name: 'admin_newsletter_edit',
              builder: (context, state) => AdminNewsletterEditScreen(
                newsletterId: state.pathParameters['id'],
              ),
            ),
            GoRoute(
              path: '/admin/templates',
              name: 'admin_templates',
              builder: (context, state) => const AdminTemplatesScreen(),
            ),
            GoRoute(
              path: '/admin/templates/:id',
              name: 'admin_template_edit',
              builder: (context, state) => AdminTemplateEditScreen(
                templateId: state.pathParameters['id'] ?? '',
              ),
            ),
            GoRoute(
              path: '/admin/analytics',
              name: 'admin_analytics',
              builder: (context, state) => const AdminAnalyticsScreen(),
            ),
          ],
        ),
      ],
      errorBuilder: (context, state) => const ErrorScreen(),
    );
  }
}

/// Error Screen
///
/// Shown when navigation fails
class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF8F5),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Color(0xFF722F37),
            ),
            const SizedBox(height: 16),
            const Text(
              'Oups ! Quelque chose s\'est mal passé',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A2332),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Page non trouvée',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF616161),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF722F37),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Aller à l\'accueil'),
            ),
          ],
        ),
      ),
    );
  }
}

/// AdminGuard
///
/// Wraps admin routes and shows `ErrorScreen` for non-web or non-admin users.
/// Watches auth state so it rebuilds correctly when loading resolves.
class AdminGuard extends ConsumerWidget {
  final Widget child;
  const AdminGuard({required this.child, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!kIsWeb) {
      return const ErrorScreen();
    }
    // Watch auth state so the guard rebuilds when loading resolves.
    final authState = ref.watch(authStateProvider);
    final isLoading = authState.maybeWhen(
      loading: () => true,
      initial: () => true,
      orElse: () => false,
    );
    if (isLoading) {
      return const ColoredBox(
        color: Color(0xFFF5F5F5),
        child: Center(
          child: CircularProgressIndicator(color: AppTheme.bordeaux),
        ),
      );
    }
    final isAdmin = ref.watch(isAdminProvider);
    if (!isAdmin) {
      return const ErrorScreen();
    }
    return AdminScaffold(child: child);
  }
}

/// ChangeNotifier used as GoRouter's `refreshListenable`.
///
/// Fires whenever the auth state changes so the router re-evaluates its
/// redirect (handles login -> home, logout -> login, and deep links).
class _AuthRefreshNotifier extends ChangeNotifier {
  void fire() {
    notifyListeners();
  }
}

