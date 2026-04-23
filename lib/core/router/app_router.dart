import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tall_us/core/screens/home_screen_with_nav.dart';
import 'package:tall_us/features/auth/presentation/providers/auth_providers.dart';
import 'package:tall_us/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:tall_us/features/auth/presentation/screens/login_screen.dart';
import 'package:tall_us/features/auth/presentation/screens/register_screen.dart';
import 'package:tall_us/features/auth/presentation/screens/splash_screen.dart';
import 'package:tall_us/features/landing/presentation/pages/landing_page.dart';

/// App Router Configuration
///
/// Defines all routes and navigation logic using go_router
class AppRouter {
  static GoRouter createRouter(Ref ref) {
    return GoRouter(
      initialLocation: '/',
      debugLogDiagnostics: true,
      redirect: (context, state) {
        final authState = ref.read(authStateProvider);
        final isAuthenticated = authState.maybeWhen(
          authenticated: (_) => true,
          orElse: () => false,
        );

        // Get current path
        final currentPath = state.uri.path;

        // While checking auth status, show splash
        if (authState.maybeWhen(
          loading: () => true,
          initial: () => true,
          orElse: () => false,
        )) {
          return '/splash';
        }

        // If not authenticated and trying to access protected routes
        if (!isAuthenticated) {
          // Allow access to landing, login, register, and forgot-password
          if (currentPath == '/' ||
              currentPath == '/splash' ||
              currentPath == '/login' ||
              currentPath == '/register' ||
              currentPath == '/forgot-password') {
            return null;
          }
          // Redirect to landing
          return '/';
        }

        // If authenticated and trying to access auth routes or landing
        if (isAuthenticated &&
            (currentPath == '/login' ||
                currentPath == '/register' ||
                currentPath == '/forgot-password' ||
                currentPath == '/' ||
                currentPath == '/splash')) {
          // Redirect to home
          return '/home';
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

        // Home Screen with bottom navigation
        GoRoute(
          path: '/home',
          name: 'home',
          builder: (context, state) => const HomeScreenWithNav(),
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
