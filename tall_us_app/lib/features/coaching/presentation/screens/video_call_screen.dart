import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tall_us/core/theme/app_theme.dart';
import 'package:tall_us/features/coaching/domain/entities/coaching_session_entity.dart';

/// Simulated video-call screen (MVP). Replace the mock remote/self tiles with
/// a real WebRTC / Jitsi integration later. It enforces that the call is only
/// reachable within the 10-minute pre-session window (enforced by the entry
/// card), and runs a live call timer.
class VideoCallScreen extends StatefulWidget {
  final CoachingSessionEntity session;
  const VideoCallScreen({required this.session, super.key});

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  Timer? _timer;
  int _seconds = 0;
  bool _muted = false;
  bool _cameraOff = false;
  bool _ended = false;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!_ended && mounted) setState(() => _seconds++);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _endCall() {
    setState(() => _ended = true);
    _timer?.cancel();
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) context.pop();
    });
  }

  String get _timerLabel {
    final m = (_seconds ~/ 60).toString().padLeft(2, '0');
    final s = (_seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final coachName = widget.session.coachName ?? 'Coach Tall Us';
    final initials =
        coachName.split(' ').map((w) => w.isEmpty ? '' : w[0]).take(2).join();

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: _ended
            ? _buildEndedView(coachName)
            : Stack(
                children: [
                  // Remote "video" (mock)
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [AppTheme.navy, Colors.black87],
                      ),
                    ),
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: AppTheme.bordeaux,
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: Colors.white.withValues(alpha: 0.3),
                                width: 3),
                          ),
                          child: Center(
                            child: Text(initials.isEmpty ? 'T' : initials,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 40,
                                    fontWeight: FontWeight.w800)),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(coachName,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w700)),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.green.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                    color: Colors.green, shape: BoxShape.circle),
                              ),
                              const SizedBox(width: 6),
                              Text('En direct · $_timerLabel',
                                  style: const TextStyle(
                                      color: Colors.green,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                            'Coaching ${widget.session.durationMin} min',
                            style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.6),
                                fontSize: 13)),
                      ],
                    ),
                  ),

                  // Top bar
                  Positioned(
                    top: 12,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text('Tall Us · Visio coaching',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ),

                  // Self-preview tile (mock)
                  Positioned(
                    top: 56,
                    right: 12,
                    child: Container(
                      width: 100,
                      height: 140,
                      decoration: BoxDecoration(
                        color: AppTheme.bordeaux.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                            color: Colors.white.withValues(alpha: 0.2)),
                      ),
                      child: _cameraOff
                          ? const Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.videocam_off,
                                      color: Colors.white70, size: 24),
                                  SizedBox(height: 4),
                                  Text('Toi',
                                      style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 12)),
                                ],
                              ),
                            )
                          : const Center(
                              child: Text('Toi',
                                  style: TextStyle(
                                      color: Colors.white70, fontSize: 12)),
                            ),
                    ),
                  ),

                  // Controls
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 24,
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _controlButton(
                              icon: _muted ? Icons.mic_off : Icons.mic,
                              label: _muted ? 'Muet' : 'Micro',
                              onTap: () => setState(() => _muted = !_muted),
                            ),
                            const SizedBox(width: 12),
                            _controlButton(
                              icon: _cameraOff
                                  ? Icons.videocam_off
                                  : Icons.videocam,
                              label: _cameraOff ? 'Cam off' : 'Caméra',
                              onTap: () =>
                                  setState(() => _cameraOff = !_cameraOff),
                            ),
                            const SizedBox(width: 12),
                            _endCallButton(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildEndedView(String coachName) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.call_end, color: Colors.red, size: 56),
            const SizedBox(height: 16),
            const Text('Appel terminé',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Text(
                'Durée : $_timerLabel avec $coachName',
                style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 14)),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.bordeaux,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
              ),
              child: const Text('Retour'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _controlButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 22),
          ),
          const SizedBox(height: 4),
          Text(label,
              style:
                  TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 11)),
        ],
      ),
    );
  }

  Widget _endCallButton() {
    return GestureDetector(
      onTap: _endCall,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.call_end, color: Colors.white, size: 24),
          ),
          const SizedBox(height: 4),
          Text('Raccrocher',
              style:
                  TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 11)),
        ],
      ),
    );
  }
}
