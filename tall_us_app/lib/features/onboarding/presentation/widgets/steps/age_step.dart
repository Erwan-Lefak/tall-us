import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tall_us/core/theme/app_theme.dart';
import 'package:tall_us/features/onboarding/presentation/providers/onboarding_provider.dart';
import 'package:tall_us/features/onboarding/presentation/widgets/onboarding_step_scaffold.dart';

/// Preferred age range step.
class AgeStep extends ConsumerWidget {
  const AgeStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(onboardingProvider);
    final min = data?.minAge ?? 21;
    final max = data?.maxAge ?? 45;

    return OnboardingStepScaffold(
      question: 'Quelle tranche d\'âge ?',
      hint: 'Fais glisser pour choisir l\'âge minimum et maximum.',
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w900,
                  color: AppTheme.bordeaux),
              children: [
                TextSpan(text: '$min'),
                TextSpan(
                    text: ' - ',
                    style: TextStyle(
                        color: AppTheme.navy.withValues(alpha: 0.4))),
                TextSpan(text: '$max'),
                TextSpan(
                    text: ' ans',
                    style: TextStyle(
                        fontSize: 20,
                        color: AppTheme.navy.withValues(alpha: 0.5))),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: RangeSlider(
              values: RangeValues(min.toDouble(), max.toDouble()),
              min: 18,
              max: 80,
              divisions: 62,
              activeColor: AppTheme.bordeaux,
              inactiveColor: Colors.grey.shade300,
              labels: RangeLabels('$min', '$max'),
              onChanged: (v) => ref
                  .read(onboardingProvider.notifier)
                  .setAgeRange(v.start.round(), v.end.round()),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [Text('18 ans'), Text('80 ans')],
          ),
        ],
      ),
    );
  }
}
