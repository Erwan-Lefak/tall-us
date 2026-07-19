import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tall_us/core/theme/app_theme.dart';
import 'package:tall_us/features/coaching/domain/entities/coaching_session_entity.dart';
import 'package:tall_us/features/coaching/presentation/providers/coaching_provider.dart';
import 'package:tall_us/features/coaching/presentation/widgets/video_call_entry_card.dart';

class CoachingScreen extends ConsumerWidget {
  const CoachingScreen({super.key});

  /// Generate 6 upcoming bookable slots (next 6 days, 18:00).
  List<DateTime> _slots() {
    final now = DateTime.now();
    return List.generate(6, (i) {
      final d = now.add(Duration(days: i + 1));
      return DateTime(d.year, d.month, d.day, 18, 0);
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncSessions = ref.watch(coachingProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFFAF8F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.navy),
          onPressed: () => context.pop(),
        ),
        title: const Text('Coaching',
            style: TextStyle(
                color: AppTheme.navy,
                fontSize: 18,
                fontWeight: FontWeight.bold)),
      ),
      body: asyncSessions.when(
        loading: () => const Center(
            child: CircularProgressIndicator(color: AppTheme.bordeaux)),
        error: (e, _) => Center(child: Text('Erreur: $e')),
        data: (sessions) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Header card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [
                  AppTheme.bordeaux,
                  Color(0xFFB23A48),
                ]),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(children: [
                const Icon(Icons.psychology, color: Colors.white, size: 36),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Coaching personnalisé',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.w800)),
                      SizedBox(height: 4),
                      Text(
                          '30 min avec un pro incluses dans le forfait Légende. '
                          'Conseils rencontres, style, confiance en soi.',
                          style: TextStyle(color: Colors.white70, fontSize: 13),
                          textAlign: TextAlign.start),
                    ],
                  ),
                ),
              ]),
            ),
            const SizedBox(height: 24),

            // My sessions
            const Text('Mes rendez-vous',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.navy)),
            const SizedBox(height: 10),
            if (sessions.where((s) => s.status != 'canceled').isEmpty)
              _empty('Aucun rendez-vous pour l\'instant.')
            else
              ...sessions
                  .where((s) => s.status != 'canceled')
                  .map((s) => _SessionTile(
                        session: s,
                        onCancel: () => ref
                            .read(coachingProvider.notifier)
                            .cancelSession(s.id),
                      )),

            const SizedBox(height: 28),

            // Book a session
            const Text('Réserver un créneau',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.navy)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _slots()
                  .map((slot) => ActionChip(
                        label: Text(_formatSlot(slot)),
                        backgroundColor: Colors.white,
                        side: BorderSide(
                            color: AppTheme.bordeaux.withValues(alpha: 0.3)),
                        labelStyle: const TextStyle(
                            color: AppTheme.navy, fontWeight: FontWeight.w600),
                        onPressed: () => _confirmBooking(context, ref, slot),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 16),
            Text(
              'Tu recevras une confirmation et un lien de visio. Annulable à tout moment.',
              style: TextStyle(
                  fontSize: 12, color: AppTheme.navy.withValues(alpha: 0.5)),
            ),

            const SizedBox(height: 28),
            // Start-visio entry card (active 10 min before the next session).
            const VideoCallEntryCard(),
          ],
        ),
      ),
    );
  }

  Widget _empty(String text) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Text(text,
            style: TextStyle(color: AppTheme.navy.withValues(alpha: 0.5))),
      );

  Future<void> _confirmBooking(
      BuildContext context, WidgetRef ref, DateTime slot) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(children: [
          Icon(Icons.psychology, color: AppTheme.bordeaux),
          SizedBox(width: 10),
          Expanded(child: Text('Confirmer le rendez-vous',
              style:
                  TextStyle(fontSize: 19, fontWeight: FontWeight.w800))),
        ]),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Tu vas réserver une session de coaching :',
                style: TextStyle(fontSize: 14)),
            const SizedBox(height: 14),
            _confirmRow(Icons.event, _formatSlot(slot)),
            const SizedBox(height: 8),
            _confirmRow(Icons.schedule, '30 minutes'),
            const SizedBox(height: 8),
            _confirmRow(Icons.videocam, 'En visio (lien envoyé après confirmation)'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text('Annuler',
                style: TextStyle(
                    color: AppTheme.navy.withValues(alpha: 0.6))),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.bordeaux,
              foregroundColor: Colors.white,
            ),
            child: const Text('Confirmer'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    final ok = await ref.read(coachingProvider.notifier).bookSession(slot);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(ok
              ? 'Rendez-vous demandé ✓'
              : 'Erreur lors de la réservation'),
          backgroundColor: ok ? Colors.green : Colors.red,
        ),
      );
    }
  }

  Widget _confirmRow(IconData icon, String text) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppTheme.navy.withValues(alpha: 0.6)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text,
                style: TextStyle(
                    fontSize: 13, color: AppTheme.navy.withValues(alpha: 0.8))),
          ),
        ],
      );

  String _formatSlot(DateTime d) {
    const days = ['lun', 'mar', 'mer', 'jeu', 'ven', 'sam', 'dim'];
    return '${days[(d.weekday - 1) % 7]} ${d.day}/${d.month.toString().padLeft(2, '0')} · 18h00';
  }
}

class _SessionTile extends StatelessWidget {
  final CoachingSessionEntity session;
  final VoidCallback onCancel;
  const _SessionTile({required this.session, required this.onCancel});

  @override
  Widget build(BuildContext context) {
    final (color, label) = _statusStyle(session.status);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.event, color: color, size: 22),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(session.coachName ?? 'Coach Tall Us',
                  style: const TextStyle(
                      fontWeight: FontWeight.w700, color: AppTheme.navy)),
              const SizedBox(height: 2),
              Text(
                  '${session.scheduledAt.day}/${session.scheduledAt.month}/${session.scheduledAt.year} · ${session.scheduledAt.hour}h00 · ${session.durationMin} min',
                  style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.navy.withValues(alpha: 0.6))),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(label,
                  style: TextStyle(
                      color: color,
                      fontSize: 11,
                      fontWeight: FontWeight.w700)),
            ),
            if (session.status == 'requested' ||
                session.status == 'confirmed')
              TextButton(
                onPressed: onCancel,
                style: TextButton.styleFrom(
                    padding: const EdgeInsets.only(top: 2),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                child: Text('Annuler',
                    style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.navy.withValues(alpha: 0.5))),
              ),
          ],
        ),
      ]),
    );
  }

  (Color, String) _statusStyle(String s) {
    switch (s) {
      case 'confirmed':
        return (Colors.green, 'Confirmé');
      case 'completed':
        return (AppTheme.gold, 'Terminé');
      case 'canceled':
        return (Colors.grey, 'Annulé');
      default:
        return (Colors.orange, 'Demandé');
    }
  }
}
