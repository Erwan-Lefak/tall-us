import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Premium Page Transitions for Tall Us
///
/// Provides smooth, professional page transitions using Material Design 3 principles
enum PremiumTransitionType {
  sharedAxis,
  fadeThrough,
  fadeScale,
  slideUp,
  none,
}

/// Premium Page Route with Custom Transitions
class PremiumPageRoute<T> extends PageRoute<T> {
  final Widget child;
  final PremiumTransitionType transitionType;
  final Duration duration;

  PremiumPageRoute({
    required this.child,
    this.transitionType = PremiumTransitionType.sharedAxis,
    this.duration = const Duration(milliseconds: 400),
  });

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  bool get opaque => true;

  @override
  Duration get transitionDuration => duration;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return child;
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    switch (transitionType) {
      case PremiumTransitionType.sharedAxis:
        return _buildSharedAxisTransition(animation, secondaryAnimation, child);
      case PremiumTransitionType.fadeThrough:
        return _buildFadeThroughTransition(
            animation, secondaryAnimation, child);
      case PremiumTransitionType.fadeScale:
        return _buildFadeScaleTransition(animation, secondaryAnimation, child);
      case PremiumTransitionType.slideUp:
        return _buildSlideUpTransition(animation, secondaryAnimation, child);
      case PremiumTransitionType.none:
        return child;
    }
  }

  Widget _buildSharedAxisTransition(
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    // Z-axis rotation transition (3D effect)
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(1.0, 0.0),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: animation,
        curve: Curves.easeInOut,
      )),
      child: FadeTransition(
        opacity: Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: Curves.easeInOut,
        )),
        child: child,
      ),
    );
  }

  Widget _buildFadeThroughTransition(
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    // Fade through transition (for navigation tabs)
    return FadeTransition(
      opacity: Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: animation,
        curve: Curves.easeInOut,
      )),
      child: ScaleTransition(
        scale: Tween<double>(
          begin: 0.95,
          end: 1.0,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: Curves.easeOut,
        )),
        child: child,
      ),
    );
  }

  Widget _buildFadeScaleTransition(
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    // Fade + Scale transition (for dialogs and modals)
    return FadeTransition(
      opacity: Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: animation,
        curve: Curves.easeOut,
      )),
      child: ScaleTransition(
        scale: Tween<double>(
          begin: 0.8,
          end: 1.0,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: Curves.elasticOut,
        )),
        child: child,
      ),
    );
  }

  Widget _buildSlideUpTransition(
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    // Slide up from bottom (for bottom sheets and modals)
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0.0, 1.0),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
      )),
      child: FadeTransition(
        opacity: Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: Curves.easeOut,
        )),
        child: child,
      ),
    );
  }
}

/// Extension for easy navigation with premium transitions
extension PremiumNavigation on BuildContext {
  Future<T?> pushPremium<T>(
    Widget route, {
    PremiumTransitionType transitionType = PremiumTransitionType.sharedAxis,
  }) {
    return Navigator.push<T>(
      this,
      PremiumPageRoute<T>(
        child: route,
        transitionType: transitionType,
      ),
    );
  }

  Future<T?> pushPremiumReplacement<T>(
    Widget route, {
    PremiumTransitionType transitionType = PremiumTransitionType.fadeThrough,
  }) {
    return Navigator.pushReplacement<T, Object?>(
      this,
      PremiumPageRoute<T>(
        child: route,
        transitionType: transitionType,
      ),
    );
  }
}
