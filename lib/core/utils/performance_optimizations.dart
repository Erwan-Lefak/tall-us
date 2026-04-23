import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// Performance Optimization Utilities for 120fps Target
///
/// Provides utilities and widgets for optimal performance
class PerformanceUtils {
  /// Check if device is high-end (can handle 120fps)
  static bool isHighEndDevice() {
    // Simple heuristic - assume most modern devices can handle 60fps+
    return true;
  }

  /// Get target FPS based on device capabilities
  static int getTargetFPS() {
    return isHighEndDevice() ? 120 : 60;
  }
}

/// Navigation Service for preloading
class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
}

/// RepaintBoundary helper for isolating repaints
///
/// Use this widget to isolate expensive animations from static content
class OptimizedRepaintBoundary extends StatelessWidget {
  final Widget child;
  final bool enabled;

  const OptimizedRepaintBoundary({
    super.key,
    required this.child,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!enabled) return child;
    return RepaintBoundary(child: child);
  }
}

/// Automatic RepaintBoundary for animated widgets
///
/// Wraps child in RepaintBoundary only when animation is running
class AutoRepaintBoundary extends StatefulWidget {
  final Widget child;
  final bool isAnimating;

  const AutoRepaintBoundary({
    super.key,
    required this.child,
    required this.isAnimating,
  });

  @override
  State<AutoRepaintBoundary> createState() => _AutoRepaintBoundaryState();
}

class _AutoRepaintBoundaryState extends State<AutoRepaintBoundary> {
  @override
  Widget build(BuildContext context) {
    if (widget.isAnimating) {
      return RepaintBoundary(child: widget.child);
    }
    return widget.child;
  }
}

/// Performance monitoring widget
class PerformanceMonitor extends StatefulWidget {
  final Widget child;
  final bool showStats;

  const PerformanceMonitor({
    super.key,
    required this.child,
    this.showStats = false, // Set to true to see FPS counter
  });

  @override
  State<PerformanceMonitor> createState() => _PerformanceMonitorState();
}

class _PerformanceMonitorState extends State<PerformanceMonitor>
    with SingleTickerProviderStateMixin {
  int _frameCount = 0;
  double _currentFPS = 0.0;
  late Ticker _ticker;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick);
    _ticker.start();

    // Update FPS every second
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _currentFPS = _frameCount.toDouble();
          _frameCount = 0;
        });
      }
    });
  }

  void _onTick(Duration elapsed) {
    _frameCount++;
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (widget.showStats)
          Positioned(
            top: 50,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'FPS: ${_currentFPS.toStringAsFixed(1)}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// Optimized ListView Builder with cacheExtent
class OptimizedListView extends StatelessWidget {
  final int itemCount;
  final NullableIndexedWidgetBuilder itemBuilder;
  final double? cacheExtent;
  final ScrollController? controller;

  const OptimizedListView({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.cacheExtent = 500,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: controller,
      cacheExtent: cacheExtent,
      itemCount: itemCount,
      itemBuilder: itemBuilder,
      addAutomaticKeepAlives: true,
      addRepaintBoundaries: true,
    );
  }
}

/// Image loading optimization
class OptimizedNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;

  const OptimizedNetworkImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    return Image.network(
      imageUrl,
      width: width,
      height: height,
      fit: fit,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          width: width,
          height: height,
          color: Colors.grey[200],
          child: Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
              strokeWidth: 2,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(Color(0xFF722F37)),
            ),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: width,
          height: height,
          color: Colors.grey[200],
          child: const Icon(Icons.error_outline),
        );
      },
      gaplessPlayback: true,
      cacheWidth: width?.toInt(),
      cacheHeight: height?.toInt(),
    );
  }
}

/// Performance tips for 120fps:
///
/// 1. USE RepaintBoundary:
///    - Wrap expensive animations in RepaintBoundary
///    - Isolate static content from animated content
///
/// 2. OPTIMIZE images:
///    - Use cacheWidth and cacheHeight for network images
///    - Preload images before displaying
///    - Use optimized image formats (WebP > JPEG > PNG)
///
/// 3. REDUCE rebuilds:
///    - Use const widgets wherever possible
///    - Split widgets into smaller, focused components
///    - Use AnimatedBuilder instead of setState for animations
///
/// 4. USE ListView.builder:
///    - Never use ListView() for large lists
///    - Set appropriate cacheExtent
///    - Use AutomaticKeepAliveClientMixin for complex items
///
/// 5. LAZY LOADING:
///    - Load data on-demand
///    - Use pagination for large datasets
///    - Show skeleton screens while loading
///
/// 6. REDUCE OVERDRAW:
///    - Avoid unnecessary transparent layers
///    - Use Opacity sparingly
///    - Clip content only when necessary
///
/// 7. AVOID expensive operations:
///    - Don't do heavy computation in build()
///    - Use Isolate for CPU-intensive tasks
///    - Debounce expensive operations
///
/// 8. PROFILE REGULARLY:
///    - Use Flutter DevTools Performance overlay
///    - Monitor frame times
///    - Check for jank (>16ms for 60fps, >8ms for 120fps)
