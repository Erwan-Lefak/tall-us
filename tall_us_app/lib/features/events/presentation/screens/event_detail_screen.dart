import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tall_us/core/appwrite/appwrite_client.dart';
import 'package:tall_us/core/appwrite/appwrite_config.dart';
import 'package:tall_us/core/theme/app_theme.dart';
import 'package:tall_us/core/utils/logger.dart';
import 'package:tall_us/features/events/domain/entities/event_entity.dart';
import 'package:tall_us/features/events/presentation/providers/events_provider.dart';

class EventDetailScreen extends ConsumerStatefulWidget {
  final String eventId;
  const EventDetailScreen({required this.eventId, super.key});

  @override
  ConsumerState<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends ConsumerState<EventDetailScreen> {
  EventEntity? _event;
  bool _loading = true;
  bool _toggling = false;

  @override
  void initState() {
    super.initState();
    _loadEvent();
  }

  Future<void> _loadEvent() async {
    try {
      final doc = await ref.read(databasesProvider).getDocument(
            databaseId: AppwriteConfig.databaseId,
            collectionId: AppwriteConfig.eventsCollection,
            documentId: widget.eventId,
          );
      _event = EventEntity(
        id: doc.$id,
        title: doc.data['title'] ?? '',
        type: doc.data['type'] ?? 'soiree',
        eventDate:
            DateTime.tryParse(doc.data['eventDate'] ?? '') ?? DateTime.now(),
        city: doc.data['city'] ?? '',
        venue: doc.data['venue'] ?? '',
        description: doc.data['description'] ?? '',
        imageUrl: doc.data['imageUrl'] ?? '',
        priceEur: doc.data['priceEur'] ?? 0,
        spotsLeft: doc.data['spotsLeft'] ?? 0,
      );
    } catch (e) {
      AppLogger.w('Failed to load event: $e');
    }
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _toggleRsvp() async {
    if (_event == null) return;
    setState(() => _toggling = true);
    final going = await toggleRsvp(ref, _event!.id);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(going ? 'Tu es inscrit ✓' : 'Désinscription enregistrée'),
          backgroundColor: going ? Colors.green : Colors.grey,
        ),
      );
      setState(() => _toggling = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final rsvpAsync = ref.watch(isRsvpedProvider(widget.eventId));

    return Scaffold(
      backgroundColor: const Color(0xFFFAF8F5),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(color: AppTheme.bordeaux))
          : _event == null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Événement introuvable'),
                      const SizedBox(height: 12),
                      TextButton(
                          onPressed: () => context.pop(),
                          child: const Text('Retour')),
                    ],
                  ),
                )
              : CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      expandedHeight: 240,
                      pinned: true,
                      backgroundColor: AppTheme.bordeaux,
                      leading: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => context.pop(),
                      ),
                      flexibleSpace: FlexibleSpaceBar(
                        background: _event!.imageUrl.isNotEmpty
                            ? Image.network(_event!.imageUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                    color: AppTheme.bordeaux,
                                    child: const Icon(Icons.event,
                                        size: 60, color: Colors.white)))
                            : Container(
                                color: AppTheme.bordeaux,
                                child: const Icon(Icons.event,
                                    size: 60, color: Colors.white)),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Type badge
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: AppTheme.bordeaux.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(_typeLabel(_event!.type),
                                  style: const TextStyle(
                                      color: AppTheme.bordeaux,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700)),
                            ),
                            const SizedBox(height: 12),
                            Text(_event!.title,
                                style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w800,
                                    color: AppTheme.navy)),
                            const SizedBox(height: 14),
                            _infoRow(Icons.calendar_today,
                                _formatDate(_event!.eventDate)),
                            const SizedBox(height: 8),
                            _infoRow(Icons.location_on,
                                '${_event!.city}${_event!.venue.isNotEmpty ? ' · ${_event!.venue}' : ''}'),
                            const SizedBox(height: 8),
                            _infoRow(Icons.group,
                                '${_event!.spotsLeft} places restantes'),
                            const SizedBox(height: 8),
                            _infoRow(Icons.euro,
                                _event!.priceEur == 0 ? 'Gratuit' : '${_event!.priceEur} €'),
                            const SizedBox(height: 20),
                            const Text('À propos',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: AppTheme.navy)),
                            const SizedBox(height: 8),
                            Text(_event!.description,
                                style: TextStyle(
                                    fontSize: 14,
                                    height: 1.5,
                                    color: AppTheme.navy.withValues(alpha: 0.8))),
                            const SizedBox(height: 32),
                            // RSVP button
                            SizedBox(
                              width: double.infinity,
                              height: 54,
                              child: rsvpAsync.when(
                                loading: () => const OutlinedButton(
                                  onPressed: null,
                                  child: Text('Chargement...'),
                                ),
                                data: (going) => ElevatedButton.icon(
                                  onPressed: _toggling ? null : _toggleRsvp,
                                  icon: Icon(going ? Icons.check_circle : Icons.event_available),
                                  label: Text(
                                    going ? 'Inscrit ✓ — Se désinscrire'
                                        : 'Je participe',
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: going
                                        ? Colors.green
                                        : AppTheme.bordeaux,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16)),
                                  ),
                                ),
                                error: (_, __) => const Text('Erreur'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }

  Widget _infoRow(IconData icon, String text) => Row(children: [
        Icon(icon, size: 18, color: AppTheme.navy.withValues(alpha: 0.6)),
        const SizedBox(width: 8),
        Expanded(
            child: Text(text,
                style: TextStyle(
                    fontSize: 14, color: AppTheme.navy.withValues(alpha: 0.8)))),
      ]);

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
      '', 'janvier', 'février', 'mars', 'avril', 'mai', 'juin', 'juillet', 'août', 'septembre', 'octobre', 'novembre', 'décembre'
    ];
    return '${d.day} ${months[d.month]} ${d.year} · ${d.hour.toString().padLeft(2, '0')}h${d.minute.toString().padLeft(2, '0')}';
  }
}
