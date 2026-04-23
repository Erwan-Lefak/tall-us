import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:go_router/go_router.dart';
import 'package:tall_us/core/router/app_router.dart';
import 'package:tall_us/core/theme/app_theme.dart';
import 'package:tall_us/core/utils/logger.dart';
import 'package:tall_us/features/notification/presentation/widgets/notification_widget.dart';

/// Global Error Handler
///
/// Catches all errors that occur during runtime
void _handleError(dynamic error, dynamic stack) {
  AppLogger.e(
    'Unhandled error',
    error: error,
    stackTrace: stack as StackTrace?,
  );
}

/// Set global error handler
void _setupErrorHandlers() {
  FlutterError.onError = (details) {
    _handleError(details.exception, details.stack);
  };
}

/// Initialize Firebase
Future<void> _initializeFirebase() async {
  try {
    await Firebase.initializeApp();
    AppLogger.i('Firebase initialized successfully');
  } catch (e, stack) {
    AppLogger.e('Failed to initialize Firebase', error: e, stackTrace: stack);
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Setup error handlers
  _setupErrorHandlers();

  // Initialize logger
  AppLogger.init(verbose: true);

  // Initialize Firebase (commented until Firebase is configured)
  // await _initializeFirebase();

  runApp(const ProviderScope(child: TallUsApp()));
}

/// Tall Us App
///
/// Root widget with Riverpod ProviderScope and go_router
class TallUsApp extends ConsumerWidget {
  const TallUsApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'Tall Us',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      routerConfig: router,
      builder: (context, child) {
        // Stack with proper pointer handling for web
        // Notification permission banner overlay (disabled for now)
        // Uncomment below to re-enable notifications with proper pointer handling
        // return Stack(
        //   children: [
        //     child!,
        //     // Positioned widget with proper sizing to prevent blocking
        //     const Positioned(top: 0, left: 0, right: 0, child: NotificationWidget()),
        //   ],
        // );

        // Direct child return for now (fixes web pointer events)
        return child!;
      },
    );
  }
}

/// Provider for go_router
///
/// Creates and provides the router configuration
final routerProvider = Provider<GoRouter>((ref) {
  return AppRouter.createRouter(ref);
});
