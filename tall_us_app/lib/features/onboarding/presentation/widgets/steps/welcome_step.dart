import 'package:flutter/material.dart';
import 'package:tall_us/core/theme/app_theme.dart';

/// Welcome / value-prop step.
class WelcomeStep extends StatelessWidget {
  final String displayName;
  const WelcomeStep({super.key, required this.displayName});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              color: AppTheme.bordeaux.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.favorite, color: AppTheme.bordeaux, size: 48),
          ),
          const SizedBox(height: 28),
          Text(
            'Bienvenue${displayName.isNotEmpty ? ', $displayName' : ''} !',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w900,
              color: AppTheme.navy,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            "L'amour vu d'en haut. Quelques questions pour te présenter aux bonnes personnes de grande taille.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: AppTheme.navy.withValues(alpha: 0.6),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
