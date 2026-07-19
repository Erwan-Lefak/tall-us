import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tall_us/core/theme/app_theme.dart';
import 'package:tall_us/features/onboarding/presentation/providers/onboarding_provider.dart';
import 'package:tall_us/features/onboarding/presentation/widgets/onboarding_step_scaffold.dart';

/// Hobbies / interests multi-select.
class HobbiesStep extends ConsumerWidget {
  const HobbiesStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(onboardingProvider);
    final selected = data?.hobbies ?? const <String>[];

    return OnboardingStepScaffold(
      question: 'Tes centres d\'intérêt',
      hint: 'Sélectionne tout ce qui te ressemble (3 minimum conseillé).',
      child: SingleChildScrollView(
        child: Wrap(
          spacing: 10,
          runSpacing: 10,
          children: onboardingHobbies.map((hobby) {
            final isSelected = selected.contains(hobby);
            return GestureDetector(
              onTap: () =>
                  ref.read(onboardingProvider.notifier).toggleHobby(hobby),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? AppTheme.bordeaux : Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: isSelected
                        ? AppTheme.bordeaux
                        : Colors.grey.shade300,
                    width: 1.5,
                  ),
                ),
                child: Text(
                  hobby,
                  style: TextStyle(
                    color: isSelected ? Colors.white : AppTheme.navy,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
