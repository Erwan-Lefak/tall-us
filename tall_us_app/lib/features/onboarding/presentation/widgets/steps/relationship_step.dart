import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tall_us/core/theme/app_theme.dart';
import 'package:tall_us/features/onboarding/presentation/providers/onboarding_provider.dart';
import 'package:tall_us/features/onboarding/presentation/widgets/onboarding_step_scaffold.dart';

/// Relationship intent — basketball metaphor (Shoot / Poster / Dunk).
class RelationshipStep extends ConsumerWidget {
  const RelationshipStep({super.key});

  static const _options = <_RelOption>[
    _RelOption(
        key: 'shoot', emoji: '🏀', title: 'Shoot',
        subtitle: 'Une relation sérieuse', color: AppTheme.bordeaux),
    _RelOption(
        key: 'poster', emoji: '🎯', title: 'Poster',
        subtitle: 'Une relation décontractée', color: Colors.orange),
    _RelOption(
        key: 'dunk', emoji: '🤝', title: 'Dunk',
        subtitle: 'Faire des rencontres amicales', color: Colors.blue),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(onboardingProvider)?.lookingFor;

    return OnboardingStepScaffold(
      question: 'Quelle est ton intention ?',
      hint: 'Sois honnête, ça aide à matcher avec les bonnes personnes.',
      child: Column(
        children: _options.map((o) {
          final isSelected = selected == o.key;
          return Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: GestureDetector(
              onTap: () =>
                  ref.read(onboardingProvider.notifier).setLookingFor(o.key),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: isSelected ? o.color.withValues(alpha: 0.08) : Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: isSelected ? o.color : Colors.grey.shade300,
                    width: isSelected ? 2.5 : 1.5,
                  ),
                ),
                child: Row(
                  children: [
                    Text(o.emoji, style: const TextStyle(fontSize: 34)),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(o.title,
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                  color: AppTheme.navy)),
                          const SizedBox(height: 2),
                          Text(o.subtitle,
                              style: TextStyle(
                                  fontSize: 14,
                                  color: AppTheme.navy.withValues(alpha: 0.6))),
                        ],
                      ),
                    ),
                    if (isSelected)
                      Icon(Icons.check_circle, color: o.color, size: 28),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _RelOption {
  final String key;
  final String emoji;
  final String title;
  final String subtitle;
  final Color color;
  const _RelOption({
    required this.key,
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.color,
  });
}
