import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tall_us/core/theme/app_theme.dart';
import 'package:tall_us/features/coaching/domain/entities/coaching_session_entity.dart';
import 'package:tall_us/features/coaching/presentation/providers/coaching_provider.dart';
import 'package:tall_us/features/coaching/presentation/screens/video_call_screen.dart';

/// Full-width card shown at the bottom of the coaching page. It finds the
/// user's next upcoming session and only enables the "Start visio" button
/// within the 10-minute window before the session start.
class VideoCallEntryCard extends ConsumerStatefulWidget {
  const VideoCallEntryCard({super.key});

  @override
  ConsumerState<VideoCallEntryCard> createState() => _VideoCallEntryCardState();
}

class _VideoCallEntryCardState extends ConsumerState<VideoCallEntryCard> {
  DateTime _now = DateTime.now();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Re-evaluate availability every 15s so the button activates on time.
    _timer = Timer.periodic(const Duration(seconds: 15), (_) {
      if (mounted) setState(() => _now = DateTime.now());
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final asyncSessions = ref.watch(coachingProvider);
    return asyncSessions.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (sessions) {
        // Next upcoming, non-canceled session.
        final upcoming = sessions
            .where((s) =>
                s.status != 'canceled' &&
                s.status != 'completed' &&
                !s.scheduledAt.isBefore(_now.subtract(const Duration(minutes: 30))))
            .toList()
          ..sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));

        if (upcoming.isEmpty) {
          return _card(
            enabled: false,
            title: 'Aucune visio planifiée',
            subtitle: 'Réserve un créneau ci-dessus pour démarrer une session.',
            onTap: null,
          );
        }

        final session = upcoming.first;
        final openAt = session.scheduledAt.subtract(const Duration(minutes: 10));
        final closeAt =
            session.scheduledAt.add(Duration(minutes: session.durationMin));

        if (_now.isBefore(openAt)) {
          return _card(
            enabled: false,
            title: 'Démarrer la visio',
            subtitle:
                'Disponible ${_formatDateTime(openAt)} (10 min avant le RDV).',
            onTap: null,
          );
        }
        if (_now.isAfter(closeAt)) {
          return _card(
            enabled: false,
            title: 'Session expirée',
            subtitle: 'Le créneau est dépassé. Réserve une nouvelle session.',
            onTap: null,
          );
        }
        return _card(
          enabled: true,
          title: 'Démarrer la visio',
          subtitle:
              'RDV ${_formatDateTime(session.scheduledAt)} · ${session.coachName ?? 'Coach Tall Us'}',
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => VideoCallScreen(session: session),
              ),
            );
          },
        );
      },
    );
  }

  Widget _card({
    required bool enabled,
    required String title,
    required String subtitle,
    required VoidCallback? onTap,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: enabled
            ? const LinearGradient(colors: [AppTheme.bordeaux, Color(0xFFB23A48)])
            : null,
        color: enabled ? null : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: enabled ? 0.15 : 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Row(children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: enabled
                      ? Colors.white.withValues(alpha: 0.2)
                      : AppTheme.bordeaux.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.videocam,
                    color: enabled ? Colors.white : AppTheme.bordeaux,
                    size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: enabled ? Colors.white : AppTheme.navy)),
                    const SizedBox(height: 3),
                    Text(subtitle,
                        style: TextStyle(
                            fontSize: 12,
                            color: enabled
                                ? Colors.white.withValues(alpha: 0.85)
                                : AppTheme.navy.withValues(alpha: 0.6))),
                  ],
                ),
              ),
              if (enabled)
                const Icon(Icons.play_circle_fill,
                    color: Colors.white, size: 30),
            ]),
          ),
        ),
      ),
    );
  }

  String _formatDateTime(DateTime d) {
    const days = ['dim', 'lun', 'mar', 'mer', 'jeu', 'ven', 'sam'];
    return '${days[d.weekday % 7]} ${d.hour.toString().padLeft(2, '0')}h${d.minute.toString().padLeft(2, '0')}';
  }
}
