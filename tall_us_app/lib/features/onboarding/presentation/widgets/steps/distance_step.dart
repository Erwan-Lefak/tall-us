import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tall_us/core/theme/app_theme.dart';
import 'package:tall_us/features/onboarding/presentation/providers/onboarding_provider.dart';
import 'package:tall_us/features/onboarding/presentation/widgets/onboarding_step_scaffold.dart';

/// Max distance + city step.
class DistanceStep extends ConsumerStatefulWidget {
  final String initialCity;
  const DistanceStep({super.key, required this.initialCity});

  @override
  ConsumerState<DistanceStep> createState() => _DistanceStepState();
}

class _DistanceStepState extends ConsumerState<DistanceStep> {
  late final TextEditingController _cityController;

  @override
  void initState() {
    super.initState();
    _cityController =
        TextEditingController(text: ref.read(onboardingProvider)?.city ?? widget.initialCity);
  }

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final data = ref.watch(onboardingProvider);
    final km = data?.maxDistanceKm ?? 50;

    return OnboardingStepScaffold(
      question: 'À quelle distance ?',
      hint: "Jusqu'où es-tu prêt·e à chercher le grand amour ?",
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: const TextStyle(
                  fontSize: 44,
                  fontWeight: FontWeight.w900,
                  color: AppTheme.bordeaux),
              children: [
                TextSpan(text: '$km'),
                TextSpan(
                    text: ' km',
                    style: TextStyle(
                        fontSize: 20,
                        color: AppTheme.navy.withValues(alpha: 0.5))),
              ],
            ),
          ),
          const SizedBox(height: 28),
          Slider(
            value: km.toDouble(),
            min: 1,
            max: 200,
            divisions: 199,
            activeColor: AppTheme.bordeaux,
            inactiveColor: Colors.grey.shade300,
            label: '$km km',
            onChanged: (v) =>
                ref.read(onboardingProvider.notifier).setDistance(v.round()),
          ),
          const SizedBox(height: 28),
          TextField(
            controller: _cityController,
            decoration: InputDecoration(
              labelText: 'Ta ville',
              prefixIcon: const Icon(Icons.location_on_outlined),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
              filled: true,
              fillColor: Colors.white,
            ),
            onChanged: (v) => ref.read(onboardingProvider.notifier).setCity(v),
          ),
        ],
      ),
    );
  }
}
