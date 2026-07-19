import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tall_us/core/theme/app_theme.dart';
import 'package:tall_us/features/onboarding/presentation/providers/onboarding_provider.dart';
import 'package:tall_us/features/onboarding/presentation/widgets/onboarding_step_scaffold.dart';

/// Preferred height range step (Tall Us signature filter).
class HeightStep extends ConsumerWidget {
  final String userGender;
  const HeightStep({super.key, required this.userGender});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(onboardingProvider);
    final min = data?.minHeightCm ?? 160;
    final max = data?.maxHeightCm ?? 210;

    final criteriaHint = userGender == 'female'
        ? 'Sur Tall Us, les femmes mesurent au moins 1m78 et les hommes 1m80.'
        : 'Sur Tall Us, les hommes mesurent au moins 1m80 et les femmes 1m78.';

    return OnboardingStepScaffold(
      question: 'Quelle taille recherches-tu ?',
      hint: criteriaHint,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w900,
                  color: AppTheme.bordeaux),
              children: [
                TextSpan(text: '${(min / 100).toStringAsFixed(2)}m'),
                TextSpan(
                    text: ' - ',
                    style: TextStyle(
                        color: AppTheme.navy.withValues(alpha: 0.4))),
                TextSpan(text: '${(max / 100).toStringAsFixed(2)}m'),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text('$min - $max cm',
              style: TextStyle(
                  fontSize: 15,
                  color: AppTheme.navy.withValues(alpha: 0.5))),
          const SizedBox(height: 28),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: RangeSlider(
              values: RangeValues(min.toDouble(), max.toDouble()),
              min: 140,
              max: 220,
              divisions: 80,
              activeColor: AppTheme.bordeaux,
              inactiveColor: Colors.grey.shade300,
              labels: RangeLabels('$min cm', '$max cm'),
              onChanged: (v) => ref
                  .read(onboardingProvider.notifier)
                  .setHeightRange(v.start.round(), v.end.round()),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [Text('1m40'), Text('2m20')],
          ),
        ],
      ),
    );
  }
}
