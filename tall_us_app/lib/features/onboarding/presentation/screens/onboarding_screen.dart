import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tall_us/core/theme/app_theme.dart';
import 'package:tall_us/features/onboarding/presentation/providers/onboarding_provider.dart';
import 'package:tall_us/features/onboarding/presentation/widgets/steps/age_step.dart';
import 'package:tall_us/features/onboarding/presentation/widgets/steps/bio_step.dart';
import 'package:tall_us/features/onboarding/presentation/widgets/steps/distance_step.dart';
import 'package:tall_us/features/onboarding/presentation/widgets/steps/gender_step.dart';
import 'package:tall_us/features/onboarding/presentation/widgets/steps/height_step.dart';
import 'package:tall_us/features/onboarding/presentation/widgets/steps/height_verification_offer_step.dart';
import 'package:tall_us/features/onboarding/presentation/widgets/steps/hobbies_step.dart';
import 'package:tall_us/features/onboarding/presentation/widgets/steps/photos_step.dart';
import 'package:tall_us/features/onboarding/presentation/widgets/steps/relationship_step.dart';
import 'package:tall_us/features/onboarding/presentation/widgets/steps/welcome_step.dart';
import 'package:tall_us/features/profile/presentation/providers/profile_provider.dart';

/// Onboarding wizard: runs once for first-time users.
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;

  // Step indices. Welcome is 0, the final "Terminer" step is the last index.
  static const _totalSteps = 11;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final profile = ref.read(profileProvider).profile;
      if (profile != null) {
        ref.read(onboardingProvider.notifier).init(profile);
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  bool _isStepValid(int step, OnboardingData? data) {
    if (data == null) return false;
    switch (step) {
      case 2: // photos
        return data.photoUrls.isNotEmpty;
      case 3: // bio
        return data.bio.trim().isNotEmpty;
      case 4: // relationship
        return data.lookingFor.isNotEmpty;
      case 5: // gender
        return data.preferredGenders.isNotEmpty;
      default:
        return true;
    }
  }

  void _next() {
    if (_currentStep < _totalSteps - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previous() {
    if (_currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _finish() async {
    final ok = await ref.read(onboardingProvider.notifier).submit();
    if (ok && mounted) {
      // submit() already updated profileProvider state with onboardingCompleted
      // = true, so the gate will let us through. Don't invalidate (that would
      // wipe the profile and leave the gate waiting forever on /splash).
      context.go('/home');
    }
  }

  /// Go to the height-verification flow, then persist onboarding in the
  /// background. We navigate FIRST because marking onboarding complete would
  /// otherwise trigger the redirect to bounce /onboarding → /home and unmount
  /// this screen before the navigation runs.
  Future<void> _verifyNowFromOnboarding() async {
    context.go('/verify-height');
    await ref.read(onboardingProvider.notifier).submit();
  }

  @override
  Widget build(BuildContext context) {
    final data = ref.watch(onboardingProvider);
    final isLast = _currentStep == _totalSteps - 1;
    final canAdvance = _isStepValid(_currentStep, data);

    return Scaffold(
      backgroundColor: const Color(0xFFFAF8F5),
      body: SafeArea(
        child: Column(
          children: [
            // Progress header
            Padding(
              padding:
                  const EdgeInsets.only(top: 16, left: 20, right: 20),
              child: Column(
                children: [
                  Row(
                    children: [
                      if (_currentStep > 0)
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new,
                              size: 20, color: AppTheme.navy),
                          onPressed: _previous,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        )
                      else
                        const SizedBox(width: 28),
                      const Spacer(),
                      Text(
                        'Étape ${_currentStep.clamp(1, _totalSteps - 1)}/${_totalSteps - 1}',
                        style: TextStyle(
                          color: AppTheme.navy.withValues(alpha: 0.6),
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      const Spacer(),
                      const SizedBox(width: 28),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: (_currentStep) / (_totalSteps - 1),
                      minHeight: 6,
                      backgroundColor: Colors.grey.shade200,
                      valueColor:
                          const AlwaysStoppedAnimation(AppTheme.bordeaux),
                    ),
                  ),
                ],
              ),
            ),

            // Error banner
            if (data?.error != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                child: Text(
                  'Erreur: ${data!.error}',
                  style: const TextStyle(color: Colors.red, fontSize: 13),
                ),
              ),

            // Steps
            Expanded(
              child: data == null
                  ? const Center(
                      child: CircularProgressIndicator(
                          color: AppTheme.bordeaux),
                    )
                  : PageView(
                      controller: _pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      onPageChanged: (i) =>
                          setState(() => _currentStep = i),
                      children: [
                        WelcomeStep(displayName: data.displayName),
                        const PhotosStep(),
                        const BioStep(),
                        const HobbiesStep(),
                        const RelationshipStep(),
                        const GenderStep(),
                        const AgeStep(),
                        HeightStep(userGender: data.gender),
                        DistanceStep(initialCity: data.city),
                        HeightVerificationOfferStep(
                          onVerifyNow: _verifyNowFromOnboarding,
                          onSkip: _next,
                        ),
                        _SummaryStep(data: data),
                      ],
                    ),
            ),

            // Footer button (hidden on the verification-offer step, which has
            // its own inline Verify / Skip buttons).
            if (_currentStep != 9)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                child: SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: (!canAdvance || data?.isSubmitting == true)
                        ? null
                        : (isLast ? _finish : _next),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.bordeaux,
                      disabledBackgroundColor:
                          AppTheme.bordeaux.withValues(alpha: 0.3),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                    ),
                    child: data?.isSubmitting == true
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white),
                          )
                        : Text(
                            isLast
                                ? 'Terminer'
                                : (_currentStep == 0
                                    ? 'Commencer'
                                    : 'Continuer'),
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w700),
                          ),
                  ),
                ),
              )
            else
              const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

/// Final summary step before saving.
class _SummaryStep extends StatelessWidget {
  final OnboardingData data;
  const _SummaryStep({required this.data});

  @override
  Widget build(BuildContext context) {
    final relLabel = {
          'shoot': '🏀 Shoot (sérieuse)',
          'poster': '🎯 Poster (décontractée)',
          'dunk': '🤝 Dunk (amitié)',
        }[data.lookingFor] ??
        data.lookingFor;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Text('Tout est prêt ?',
              style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.navy)),
          const SizedBox(height: 20),
          _row('Photos', '${data.photoUrls.length}'),
          _row('Bio',
              data.bio.isEmpty ? '—' : '${data.bio.length} caractères'),
          _row('Loisirs', data.hobbies.isEmpty ? '—' : data.hobbies.join(', ')),
          _row('Intention', relLabel),
          _row('Rencontrer',
              data.preferredGenders.isEmpty ? '—' : data.preferredGenders.join(', ')),
          _row('Âge', '${data.minAge} - ${data.maxAge} ans'),
          _row('Taille',
              '${data.minHeightCm} - ${data.maxHeightCm} cm'),
          _row('Distance', '${data.maxDistanceKm} km'),
          const SizedBox(height: 12),
          Text(
            'Tu pourras tout modifier plus tard dans ton profil.',
            style: TextStyle(
                fontSize: 13, color: AppTheme.navy.withValues(alpha: 0.5)),
          ),
        ],
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(label,
                style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.navy.withValues(alpha: 0.5))),
          ),
          Expanded(
            child: Text(value,
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.navy)),
          ),
        ],
      ),
    );
  }
}
