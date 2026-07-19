import 'package:flutter/material.dart';
import 'package:tall_us/core/theme/app_theme.dart';
import 'package:tall_us/features/onboarding/presentation/widgets/onboarding_step_scaffold.dart';

/// Final onboarding step offering height verification now vs. skip.
class HeightVerificationOfferStep extends StatelessWidget {
  final VoidCallback onVerifyNow;
  final VoidCallback onSkip;
  const HeightVerificationOfferStep({
    super.key,
    required this.onVerifyNow,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    return OnboardingStepScaffold(
      question: 'Vérifie ta taille',
      hint: 'Débloque les likes en prouvant ta taille. Tu peux passer pour l\'instant.',
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.bordeaux.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: AppTheme.bordeaux.withValues(alpha: 0.25),
                width: 1.5,
              ),
            ),
            child: Column(
              children: [
                Icon(Icons.verified_user,
                    color: AppTheme.bordeaux, size: 44),
                const SizedBox(height: 10),
                Text(
                  'Badge « Vérifié Tall »',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.navy,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Une photo pleine longueur à côté d\'un cadre de porte, '
                  'validée par notre équipe. Tu pourras ensuite liker et '
                  'super-liker en toute confiance.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: AppTheme.navy.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onVerifyNow,
              icon: const Icon(Icons.camera_alt, size: 20),
              label: const Text('Vérifier maintenant'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.bordeaux,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
            ),
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: onSkip,
            child: Text(
              'Passer pour l\'instant',
              style: TextStyle(
                color: AppTheme.navy.withValues(alpha: 0.6),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
