import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tall_us/core/theme/app_theme.dart';
import 'package:tall_us/features/auth/presentation/providers/auth_providers.dart';
import 'package:tall_us/features/auth/presentation/providers/email_verification_provider.dart';

/// Screen shown after registration to prompt email verification
class EmailVerificationScreen extends ConsumerStatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  ConsumerState<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState
    extends ConsumerState<EmailVerificationScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);
    final email = authState.maybeWhen(
      needsVerification: (email, _) => email,
      orElse: () => '',
    );

    ref.listen<EmailVerificationState>(emailVerificationProvider, (prev, next) {
      if (next.error != null && next.error != prev?.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error!),
            backgroundColor: AppTheme.error,
          ),
        );
      }
    });

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.bordeaux.withValues(alpha: 0.1),
              AppTheme.navy.withValues(alpha: 0.05),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Animated mail icon
                  FadeTransition(
                    opacity: _controller,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: AppTheme.bordeaux.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.mark_email_unread_outlined,
                        size: 60,
                        color: AppTheme.bordeaux,
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Title
                  const Text(
                    'Vérifiez votre email',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.navy,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 16),

                  // Description
                  Text(
                    email.isNotEmpty
                        ? 'Un email de vérification a été envoyé à :\n$email'
                        : 'Un email de vérification a été envoyé à votre adresse email.',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppTheme.navy.withValues(alpha: 0.7),
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 12),

                  Text(
                    'Vérifiez votre boîte de réception et cliquez sur le lien pour activer votre compte.',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.navy.withValues(alpha: 0.5),
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 40),

                  // Resend button
                  Consumer(
                    builder: (context, ref, _) {
                      final verificationState =
                          ref.watch(emailVerificationProvider);
                      final cooldown = verificationState.cooldownSeconds;
                      final isSending = verificationState.isSending;

                      return SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton.icon(
                          onPressed: (cooldown > 0 || isSending)
                              ? null
                              : () {
                                  ref
                                      .read(emailVerificationProvider.notifier)
                                      .sendVerificationEmail();
                                },
                          icon: isSending
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Icon(Icons.refresh),
                          label: Text(
                            cooldown > 0
                                ? 'Renvoyer dans ${cooldown}s'
                                : 'Renvoyer l\'email',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.bordeaux,
                            foregroundColor: Colors.white,
                            disabledBackgroundColor:
                                AppTheme.bordeaux.withValues(alpha: 0.5),
                            disabledForegroundColor: Colors.white70,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 16),

                  // Back to login
                  TextButton(
                    onPressed: () {
                      ref.read(authNotifierProvider.notifier).clearError();
                      context.go('/login');
                    },
                    child: Text(
                      'Retour à la connexion',
                      style: TextStyle(
                        color: AppTheme.navy.withValues(alpha: 0.7),
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
