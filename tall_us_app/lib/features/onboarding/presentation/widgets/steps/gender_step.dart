import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tall_us/core/theme/app_theme.dart';
import 'package:tall_us/features/onboarding/presentation/providers/onboarding_provider.dart';
import 'package:tall_us/features/onboarding/presentation/widgets/onboarding_step_scaffold.dart';

/// Preferred genders step (multi-select).
class GenderStep extends ConsumerWidget {
  const GenderStep({super.key});

  static const _options = <(String, String, String)>[
    ('male', 'Hommes', '♂'),
    ('female', 'Femmes', '♀'),
    ('other', 'Autres', '✦'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(onboardingProvider)?.preferredGenders ??
        const <String>[];

    return OnboardingStepScaffold(
      question: 'Qui veux-tu rencontrer ?',
      hint: 'Tu peux en sélectionner plusieurs.',
      child: Column(
        children: _options.map((o) {
          final (key, label, symbol) = o;
          final isSelected = selected.contains(key);
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: GestureDetector(
              onTap: () => ref
                  .read(onboardingProvider.notifier)
                  .togglePreferredGender(key),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppTheme.bordeaux.withValues(alpha: 0.08)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected
                        ? AppTheme.bordeaux
                        : Colors.grey.shade300,
                    width: isSelected ? 2.5 : 1.5,
                  ),
                ),
                child: Row(
                  children: [
                    Text(symbol, style: const TextStyle(fontSize: 24)),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(label,
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.navy)),
                    ),
                    Icon(
                      isSelected
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                      color: isSelected
                          ? AppTheme.bordeaux
                          : Colors.grey.shade400,
                      size: 26,
                    ),
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
