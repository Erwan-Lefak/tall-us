import 'package:flutter/material.dart';
import 'package:tall_us/core/theme/app_theme.dart';
import 'package:video_player/video_player.dart';

/// Widget that plays a looping, muted video as a full-screen background
/// with a bordeaux-tinted overlay for text readability.
class BackgroundVideoPlayer extends StatefulWidget {
  final String assetPath;
  final double overlayOpacity;

  const BackgroundVideoPlayer({
    super.key,
    required this.assetPath,
    this.overlayOpacity = 0.7,
  });

  @override
  State<BackgroundVideoPlayer> createState() => _BackgroundVideoPlayerState();
}

class _BackgroundVideoPlayerState extends State<BackgroundVideoPlayer> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(widget.assetPath)
      ..setLooping(true)
      ..setVolume(0.0)
      ..initialize().then((_) {
        if (mounted) {
          setState(() => _isInitialized = true);
          _controller.play();
        }
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: _isInitialized
          ? FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: _controller.value.size.width,
                height: _controller.value.size.height,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    VideoPlayer(_controller),
                    // Bordeaux-tinted overlay for text readability
                    Container(
                      color: AppTheme.bordeaux.withOpacity(widget.overlayOpacity),
                    ),
                  ],
                ),
              ),
            )
          : Container(
              color: Colors.black,
              child: const Center(
                child: CircularProgressIndicator(
                  color: Colors.white54,
                  strokeWidth: 2,
                ),
              ),
            ),
    );
  }
}
