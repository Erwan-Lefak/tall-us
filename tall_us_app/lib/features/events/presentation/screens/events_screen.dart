import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tall_us/core/theme/app_theme.dart';
import 'package:tall_us/features/events/domain/entities/event_entity.dart';
import 'package:tall_us/features/events/presentation/providers/events_provider.dart';

class EventsScreen extends ConsumerWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncEvents = ref.watch(eventsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFFAF8F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.navy),
          onPressed: () => context.pop(),
        ),
        title: const Text('Événements',
            style: TextStyle(
                color: AppTheme.navy,
                fontSize: 18,
                fontWeight: FontWeight.bold)),
      ),
      body: asyncEvents.when(
        loading: () => const Center(
            child: CircularProgressIndicator(color: AppTheme.bordeaux)),
        error: (e, _) => Center(
            child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text('Impossible de charger les événements: $e',
              textAlign: TextAlign.center),
        )),
        data: (events) {
          if (events.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.event_busy,
                      size: 64,
                      color: AppTheme.navy.withValues(alpha: 0.2)),
                  const SizedBox(height: 12),
                  Text('Aucun événement à venir',
                      style: TextStyle(
                          fontSize: 16,
                          color: AppTheme.navy.withValues(alpha: 0.5))),
                ],
              ),
            );
          }
          return RefreshIndicator(
            color: AppTheme.bordeaux,
            onRefresh: () => ref.read(eventsProvider.notifier).refresh(),
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: events.length,
              separatorBuilder: (_, __) => const SizedBox(height: 14),
              itemBuilder: (context, i) => _EventCard(event: events[i]),
            ),
          );
        },
      ),
    );
  }
}

class _EventCard extends StatelessWidget {
  final EventEntity event;
  const _EventCard({required this.event});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => context.push('/events/${event.id}'),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image with type badge
                Stack(
                  children: [
                    AspectRatio(
                      aspectRatio: 16 / 8,
                      child: event.imageUrl.isNotEmpty
                          ? Image.network(event.imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                  color: AppTheme.bordeaux.withValues(alpha: 0.1),
                                  child: const Icon(Icons.event, size: 40)))
                          : Container(
                              color: AppTheme.bordeaux.withValues(alpha: 0.1),
                              child: const Icon(Icons.event, size: 40)),
                    ),
                    Positioned(
                      top: 10,
                      left: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppTheme.bordeaux,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(_typeLabel(event.type),
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w700)),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(event.title,
                          style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                              color: AppTheme.navy)),
                      const SizedBox(height: 6),
                      Row(children: [
                        Icon(Icons.calendar_today,
                            size: 15,
                            color: AppTheme.navy.withValues(alpha: 0.6)),
                        const SizedBox(width: 6),
                        Text(_formatDate(event.eventDate),
                            style: TextStyle(
                                fontSize: 13,
                                color: AppTheme.navy.withValues(alpha: 0.7))),
                      ]),
                      const SizedBox(height: 4),
                      Row(children: [
                        Icon(Icons.location_on,
                            size: 15,
                            color: AppTheme.navy.withValues(alpha: 0.6)),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                              event.city.isNotEmpty
                                  ? '${event.city} · ${event.venue}'
                                  : event.venue,
                              style: TextStyle(
                                  fontSize: 13,
                                  color: AppTheme.navy.withValues(alpha: 0.7)),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis),
                        ),
                        const Icon(Icons.chevron_right, color: AppTheme.bordeaux),
                      ]),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _typeLabel(String t) {
    switch (t) {
      case 'speedDating':
        return 'Speed Dating';
      case 'tallFrance':
        return 'Tall France';
      default:
        return 'Soirée';
    }
  }

  String _formatDate(DateTime d) {
    const months = [
      '', 'jan', 'fév', 'mar', 'avr', 'mai', 'juin', 'juil', 'août', 'sep', 'oct', 'nov', 'déc'
    ];
    return '${d.day} ${months[d.month]} · ${d.hour.toString().padLeft(2, '0')}h${d.minute.toString().padLeft(2, '0')}';
  }
}
