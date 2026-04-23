import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/glowing_logo.dart';
import '../../../../core/widgets/particles/particle_system.dart';
import '../../../../core/widgets/animated_tagline.dart';

/// Premium Splash Screen with Particle Effects
///
/// First screen shown when app launches
/// Features animated particles, glowing logo, and smooth transitions
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to onboarding/auth after delay
    _navigateToNext();
  }

  Future<void> _navigateToNext() async {
    // Wait for animations to complete
    await Future.delayed(const Duration(seconds: 4));

    if (!mounted) return;

    // Navigate to login screen
    // The router will handle redirection based on auth state
    context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.bordeaux,
              AppTheme.navy,
            ],
          ),
        ),
        child: Stack(
          children: [
            // Particle effects background
            Positioned.fill(
              child: ParticleSystemWidget(
                colors: [
                  AppTheme.gold,
                  AppTheme.bordeaux.withValues(alpha: 0.6),
                  Colors.white.withValues(alpha: 0.4),
                ],
                particleCount: 40,
                particleSize: 2.5,
                speed: 0.8,
                circular: true,
                duration: const Duration(seconds: 4),
              ),
            ),

            // Main content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),

                  // Glowing Logo
                  GlowingLogoWidget(
                    size: 180,
                    imagePath: 'assets/images/logo.jpg',
                    glowColor: AppTheme.gold,
                    pulseDuration: const Duration(milliseconds: 1200),
                  )
                      .animate()
                      .fadeIn(duration: 800.ms, curve: Curves.easeOut)
                      .scale(
                          begin: const Offset(0.5, 0.5),
                          duration: 800.ms,
                          curve: Curves.elasticOut),

                  const SizedBox(height: 40),

                  // App Name
                  Text(
                    'Tall Us',
                    style: TextStyle(
                      fontSize: 56,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.white,
                      letterSpacing: 2,
                      shadows: [
                        Shadow(
                          blurRadius: 20,
                          color: AppTheme.gold.withValues(alpha: 0.5),
                          offset: const Offset(0, 0),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: 400.ms, duration: 600.ms).slideY(
                      begin: 0.3,
                      end: 0,
                      duration: 600.ms,
                      curve: Curves.easeOut),

                  const SizedBox(height: 16),

                  // Animated Tagline
                  AnimatedTaglineWidget(
                    tagline: "L'amour vu d'en haut",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w300,
                      color: AppTheme.offWhite,
                      letterSpacing: 1.2,
                    ),
                    delay: const Duration(milliseconds: 800),
                  ),

                  const Spacer(flex: 2),

                  // Premium loading indicator
                  SizedBox(
                    width: 32,
                    height: 32,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(AppTheme.gold),
                      backgroundColor: AppTheme.white.withValues(alpha: 0.2),
                    ),
                  )
                      .animate()
                      .fadeIn(delay: 1200.ms, duration: 400.ms)
                      .then(delay: 200.ms)
                      .shimmer(
                          duration: 1200.ms,
                          color: AppTheme.gold.withValues(alpha: 0.5)),

                  const SizedBox(height: 60),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
