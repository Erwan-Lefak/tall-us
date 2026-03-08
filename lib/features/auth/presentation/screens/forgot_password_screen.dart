import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tall_us/core/theme/app_theme.dart';
import 'package:tall_us/features/auth/presentation/providers/auth_providers.dart';

/// Forgot Password Screen
///
/// Screen to request password reset email
class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isSending = false;
  bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleSendResetEmail() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSending = true;
    });

    final success = await ref
        .read(authNotifierProvider.notifier)
        .sendPasswordResetEmail(_emailController.text.trim());

    if (mounted) {
      setState(() {
        _isSending = false;
        _emailSent = success;
      });
    }

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Email de réinitialisation envoyé !'),
          backgroundColor: AppTheme.success,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
    }
  }

  void _navigateBackToLogin() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      backgroundColor: AppTheme.offWhite,
      appBar: AppBar(
        backgroundColor: AppTheme.offWhite,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.navy),
          onPressed: _navigateBackToLogin,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 20,
            bottom: keyboardHeight > 0 ? 24 : 40,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Logo
                Center(
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.white,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        'assets/images/logo.jpg',
                        width: 120,
                        height: 120,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                Text(
                  'Mot de passe oublié ?',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: AppTheme.navy,
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),

                Text(
                  _emailSent
                      ? 'Nous avons envoyé un lien de réinitialisation à votre email. Vérifiez votre boîte de réception.'
                      : 'Entrez votre adresse email et nous vous enverrons un lien pour réinitialiser votre mot de passe.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.navy.withValues(alpha: 0.7),
                      ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 40),

                // Email field (hide if email sent)
                if (!_emailSent) ...[
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.done,
                    enabled: !_isSending,
                    onFieldSubmitted: (_) => _handleSendResetEmail(),
                    decoration: InputDecoration(
                      labelText: 'Email',
                      hintText: 'Entrez votre email',
                      prefixIcon: const Icon(Icons.email_outlined),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: AppTheme.bordeaux,
                          width: 2,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Colors.red,
                          width: 1,
                        ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Colors.red,
                          width: 2,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Veuillez entrer votre email';
                      }
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                          .hasMatch(value)) {
                        return 'Veuillez entrer un email valide';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 24),

                  // Send Reset Link button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _isSending ? null : _handleSendResetEmail,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.bordeaux,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor:
                            AppTheme.bordeaux.withValues(alpha: 0.6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: _isSending
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text(
                              'Envoyer le lien',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ],

                const SizedBox(height: 24),

                // Back to Login link
                if (!_emailSent)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Vous vous souvenez de votre mot de passe ? ',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppTheme.navy.withValues(alpha: 0.7),
                            ),
                      ),
                      TextButton(
                        onPressed: _isSending ? null : _navigateBackToLogin,
                        child: Text(
                          'Se connecter',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppTheme.bordeaux,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                    ],
                  ),

                // Done button (show if email sent)
                if (_emailSent) ...[
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _navigateBackToLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.bordeaux,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Retour à la connexion',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
