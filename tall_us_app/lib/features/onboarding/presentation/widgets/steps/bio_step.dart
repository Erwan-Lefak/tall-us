import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tall_us/features/onboarding/presentation/providers/onboarding_provider.dart';
import 'package:tall_us/features/onboarding/presentation/widgets/onboarding_step_scaffold.dart';

/// Bio / personal description step.
class BioStep extends ConsumerStatefulWidget {
  const BioStep({super.key});

  @override
  ConsumerState<BioStep> createState() => _BioStepState();
}

class _BioStepState extends ConsumerState<BioStep> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: ref.read(onboardingProvider)?.bio ?? '');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OnboardingStepScaffold(
      question: 'Parle-nous de toi',
      hint: 'Une courte bio qui te ressemble (max. 300 caractères).',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _controller,
            maxLength: 300,
            maxLines: 6,
            minLines: 4,
            decoration: InputDecoration(
              hintText: 'Ex : Basketteur le weekend, gastronome la semaine...',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
              filled: true,
              fillColor: Colors.white,
            ),
            onChanged: (v) => ref.read(onboardingProvider.notifier).setBio(v),
          ),
        ],
      ),
    );
  }
}
