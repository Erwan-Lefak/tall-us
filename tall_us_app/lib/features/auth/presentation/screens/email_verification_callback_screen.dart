import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tall_us/core/theme/app_theme.dart';
import 'package:tall_us/features/auth/presentation/providers/email_verification_provider.dart';

/// Screen that handles the Appwrite verification callback
/// Extracts userId and secret from URL query parameters
class EmailVerificationCallbackScreen extends ConsumerStatefulWidget {
  final String? userId;
  final String? secret;

  const EmailVerificationCallbackScreen({
    super.key,
    this.userId,
    this.secret,
  });

  @override
  ConsumerState<EmailVerificationCallbackScreen> createState() =>
      _EmailVerificationCallbackScreenState();
}

class _EmailVerificationCallbackScreenState
    extends ConsumerState<EmailVerificationCallbackScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _verifyEmail();
    });
  }

  Future<void> _verifyEmail() async {
    if (widget.userId == null || widget.secret == null) {
      if (mounted) {
        context.go('/login');
      }
      return;
    }

    await ref.read(emailVerificationProvider.notifier).verifyEmail(
          userId: widget.userId!,
          secret: widget.secret!,
        );
  }

  @override
  Widget build(BuildContext context) {
    final verificationState = ref.watch(emailVerificationProvider);

    // Navigate on success
    if (verificationState.isVerified) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          context.go('/verify-email/success');
        }
      });
    }

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (verificationState.isVerifying) ...[
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppTheme.bordeaux),
              ),
              const SizedBox(height: 24),
              Text(
                'Vérification en cours...',
                style: TextStyle(
                  fontSize: 18,
                  color: AppTheme.navy.withValues(alpha: 0.7),
                ),
              ),
            ],
            if (verificationState.error != null) ...[
              Icon(Icons.error_outline, size: 60, color: AppTheme.error),
              const SizedBox(height: 16),
              Text(
                verificationState.error!,
                style: const TextStyle(
                  fontSize: 16,
                  color: AppTheme.navy,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => context.go('/login'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.bordeaux,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Retour à la connexion'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
