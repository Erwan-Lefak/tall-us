import 'package:flutter/material.dart';
import 'package:tall_us/core/theme/app_theme.dart';

/// Shared layout for a single onboarding step: big question + optional hint +
/// the step's interactive content.
class OnboardingStepScaffold extends StatelessWidget {
  final String question;
  final String? hint;
  final Widget child;
  final CrossAxisAlignment align;

  const OnboardingStepScaffold({
    super.key,
    required this.question,
    this.hint,
    required this.child,
    this.align = CrossAxisAlignment.stretch,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: align,
        children: [
          const SizedBox(height: 8),
          Text(
            question,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: AppTheme.navy,
              height: 1.2,
            ),
          ),
          if (hint != null) ...[
            const SizedBox(height: 10),
            Text(
              hint!,
              style: TextStyle(
                fontSize: 15,
                color: AppTheme.navy.withValues(alpha: 0.55),
                height: 1.4,
              ),
            ),
          ],
          const SizedBox(height: 28),
          Expanded(child: child),
        ],
      ),
    );
  }
}
