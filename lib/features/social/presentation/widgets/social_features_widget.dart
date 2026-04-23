import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:tall_us/core/theme/app_theme.dart';

/// Event entity
class SocialEvent {
  final String id;
  final String title;
  final String description;
  final String location;
  final DateTime dateTime;
  final List<String> attendees;
  final int maxAttendees;
  final String hostId;
  final String imageUrl;

  const SocialEvent({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.dateTime,
    required this.attendees,
    required this.maxAttendees,
    required this.hostId,
    required this.imageUrl,
  });

  int get availableSpots => maxAttendees - attendees.length;
  bool get isFull => availableSpots <= 0;
}

/// Group entity
class SocialGroup {
  final String id;
  final String name;
  final String description;
  final String category;
  final List<String> members;
  final int maxMembers;
  final String hostId;
  final String imageUrl;

  const SocialGroup({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.members,
    required this.maxMembers,
    required this.hostId,
    required this.imageUrl,
  });

  int get availableSpots => maxMembers - members.length;
  bool get isFull => availableSpots <= 0;
}

/// Groups and Events Widget
class SocialGroupsWidget extends StatefulWidget {
  final List<SocialGroup> groups;
  final List<SocialEvent> events;
  final Function(SocialGroup) onJoinGroup;
  final Function(SocialEvent) onJoinEvent;

  const SocialGroupsWidget({
    super.key,
    required this.groups,
    required this.events,
    required this.onJoinGroup,
    required this.onJoinEvent,
  });

  @override
  State<SocialGroupsWidget> createState() => _SocialGroupsWidgetState();
}

class _SocialGroupsWidgetState extends State<SocialGroupsWidget> {
  int _selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          const Text(
            'Social',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppTheme.navy,
            ),
          ).animate().fadeIn(duration: 300.ms),

          const SizedBox(height: 8),

          Text(
            'Rejoignez des groupes et participez à des événements',
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.gray600,
            ),
          ).animate().fadeIn(duration: 300.ms),

          const SizedBox(height: 20),

          // Tab selector
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppTheme.gray100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedTabIndex = 0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: _selectedTabIndex == 0
                            ? Colors.white
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: _selectedTabIndex == 0
                            ? [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 4,
                                ),
                              ]
                            : null,
                      ),
                      child: Text(
                        'Groupes',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: _selectedTabIndex == 0
                              ? AppTheme.bordeaux
                              : AppTheme.gray600,
                          fontWeight: _selectedTabIndex == 0
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedTabIndex = 1),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: _selectedTabIndex == 1
                            ? Colors.white
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: _selectedTabIndex == 1
                            ? [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 4,
                                ),
                              ]
                            : null,
                      ),
                      child: Text(
                        'Événements',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: _selectedTabIndex == 1
                              ? AppTheme.bordeaux
                              : AppTheme.gray600,
                          fontWeight: _selectedTabIndex == 1
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(duration: 300.ms),

          const SizedBox(height: 20),

          // Content
          _selectedTabIndex == 0 ? _buildGroupsList() : _buildEventsList(),
        ],
      ),
    );
  }

  Widget _buildGroupsList() {
    if (widget.groups.isEmpty) {
      return _buildEmptyState(
        icon: Icons.groups,
        message: 'Aucun groupe disponible',
        subtext: 'Soyez le premier à créer un groupe!',
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.groups.length,
      itemBuilder: (context, index) {
        final group = widget.groups[index];
        return _GroupCard(
          group: group,
          onJoin: () => widget.onJoinGroup(group),
        );
      },
    );
  }

  Widget _buildEventsList() {
    if (widget.events.isEmpty) {
      return _buildEmptyState(
        icon: Icons.event,
        message: 'Aucun événement à venir',
        subtext: 'Créez votre premier événement!',
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.events.length,
      itemBuilder: (context, index) {
        final event = widget.events[index];
        return _EventCard(
          event: event,
          onJoin: () => widget.onJoinEvent(event),
        );
      },
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String message,
    required String subtext,
  }) {
    return Center(
      child: Column(
        children: [
          Icon(
            icon,
            size: 64,
            color: AppTheme.gray300,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.gray600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtext,
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.gray500,
            ),
          ),
        ],
      ),
    );
  }
}

/// Group Card
class _GroupCard extends StatelessWidget {
  final SocialGroup group;
  final VoidCallback onJoin;

  const _GroupCard({
    required this.group,
    required this.onJoin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.gray200,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Group image
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  group.imageUrl,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 80,
                      height: 80,
                      color: AppTheme.gray200,
                      child: Icon(
                        Icons.groups,
                        color: AppTheme.gray400,
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(width: 16),

              // Group info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          group.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.navy,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.bordeaux.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            group.category,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.bordeaux,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      group.description,
                      style: TextStyle(
                        fontSize: 13,
                        color: AppTheme.gray700,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.people,
                          size: 16,
                          color: AppTheme.gray600,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${group.members.length}/${group.maxMembers} membres',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppTheme.gray600,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Icon(
                          group.isFull ? Icons.block : Icons.check_circle,
                          size: 16,
                          color: group.isFull
                              ? AppTheme.bordeaux
                              : AppTheme.success,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          group.isFull
                              ? 'Complet'
                              : '${group.availableSpots} places',
                          style: TextStyle(
                            fontSize: 12,
                            color: group.isFull
                                ? AppTheme.bordeaux
                                : AppTheme.success,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Join button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: group.isFull ? null : onJoin,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    group.isFull ? AppTheme.gray400 : AppTheme.bordeaux,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                group.isFull ? 'Groupe complet' : 'Rejoindre',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).slideX();
  }
}

/// Event Card
class _EventCard extends StatelessWidget {
  final SocialEvent event;
  final VoidCallback onJoin;

  const _EventCard({
    required this.event,
    required this.onJoin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.gray200,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Event image
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              event.imageUrl,
              width: double.infinity,
              height: 150,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: double.infinity,
                  height: 150,
                  color: AppTheme.gray200,
                  child: Icon(
                    Icons.event,
                    color: AppTheme.gray400,
                    size: 48,
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 12),

          // Event title and date
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  event.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.navy,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.bordeaux,
                      AppTheme.bordeaux.withValues(alpha: 0.8),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text(
                      '${event.dateTime.day}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      _getMonthAbbreviation(event.dateTime.month),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Description
          Text(
            event.description,
            style: TextStyle(
              fontSize: 13,
              color: AppTheme.gray700,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 8),

          // Location and attendees
          Row(
            children: [
              Icon(
                Icons.location_on,
                size: 16,
                color: AppTheme.gray600,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  event.location,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.gray700,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Row(
            children: [
              Icon(
                Icons.people,
                size: 16,
                color: AppTheme.gray600,
              ),
              const SizedBox(width: 4),
              Text(
                '${event.attendees.length}/${event.maxAttendees} participants',
                style: TextStyle(
                  fontSize: 12,
                  color: AppTheme.gray600,
                ),
              ),
              const SizedBox(width: 16),
              Icon(
                event.isFull ? Icons.block : Icons.check_circle,
                size: 16,
                color: event.isFull ? AppTheme.bordeaux : AppTheme.success,
              ),
              const SizedBox(width: 4),
              Text(
                event.isFull ? 'Complet' : '${event.availableSpots} places',
                style: TextStyle(
                  fontSize: 12,
                  color: event.isFull ? AppTheme.bordeaux : AppTheme.success,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Join button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: event.isFull ? null : onJoin,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    event.isFull ? AppTheme.gray400 : AppTheme.bordeaux,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                event.isFull ? 'Événement complet' : 'Participer',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).slideX();
  }

  String _getMonthAbbreviation(int month) {
    const months = [
      'Jan',
      'Fév',
      'Mar',
      'Avr',
      'Mai',
      'Jun',
      'Jul',
      'Aoû',
      'Sep',
      'Oct',
      'Nov',
      'Déc'
    ];
    return months[month - 1];
  }
}

/// Friends of Friends Matching Widget
class FriendsOfFriendsWidget extends StatelessWidget {
  final List<Map<String, dynamic>> potentialMatches;
  final Function(String) onConnect;

  const FriendsOfFriendsWidget({
    super.key,
    required this.potentialMatches,
    required this.onConnect,
  });

  @override
  Widget build(BuildContext context) {
    if (potentialMatches.isEmpty) {
      return Center(
        child: Column(
          children: [
            Icon(
              Icons.people_outline,
              size: 64,
              color: AppTheme.gray300,
            ),
            const SizedBox(height: 16),
            Text(
              'Aucun ami d\'ami disponible',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.gray600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Invitez vos amis pour élargir votre cercle!',
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.gray500,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Amis d\'amis',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppTheme.navy,
          ),
        ).animate().fadeIn(duration: 300.ms),
        const SizedBox(height: 8),
        Text(
          'Connectez-vous avec des amis de vos amis',
          style: TextStyle(
            fontSize: 14,
            color: AppTheme.gray600,
          ),
        ).animate().fadeIn(duration: 300.ms),
        const SizedBox(height: 20),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: potentialMatches.length,
          itemBuilder: (context, index) {
            final match = potentialMatches[index];
            return _FriendMatchCard(
              match: match,
              onConnect: () => onConnect(match['id']),
            );
          },
        ),
      ],
    );
  }
}

/// Friend Match Card
class _FriendMatchCard extends StatelessWidget {
  final Map<String, dynamic> match;
  final VoidCallback onConnect;

  const _FriendMatchCard({
    required this.match,
    required this.onConnect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.gray200,
        ),
      ),
      child: Row(
        children: [
          // Avatar
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: match['photoUrl'] != null
                ? Image.network(
                    match['photoUrl'],
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  )
                : Container(
                    width: 60,
                    height: 60,
                    color: AppTheme.gray200,
                    child: Icon(Icons.person, color: AppTheme.gray400),
                  ),
          ),

          const SizedBox(width: 16),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  match['name'] ?? 'Utilisateur',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.navy,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.group,
                      size: 14,
                      color: AppTheme.gray600,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        'Ami${match['mutualFriends'] > 1 ? 's' : ''} commun${match['mutualFriends'] > 1 ? 's' : ''}: ${match['mutualFriends']}',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.gray700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: (match['mutualFriendNames'] as List<String>?)
                          ?.take(2)
                          .map((name) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.bordeaux.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            name,
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppTheme.bordeaux,
                            ),
                          ),
                        );
                      }).toList() ??
                      [],
                ),
              ],
            ),
          ),

          // Connect button
          IconButton(
            onPressed: onConnect,
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.bordeaux,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person_add,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).slideX();
  }
}

/// Double Date Mode Widget
class DoubleDateWidget extends StatefulWidget {
  final Function(List<String>) onCreateDoubleDate;

  const DoubleDateWidget({
    super.key,
    required this.onCreateDoubleDate,
  });

  @override
  State<DoubleDateWidget> createState() => _DoubleDateWidgetState();
}

class _DoubleDateWidgetState extends State<DoubleDateWidget> {
  final List<String> _selectedFriends = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.gold.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.people,
                  color: AppTheme.gold,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Double Date',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.navy,
                    ),
                  ),
                  Text(
                    'Sélectionnez 2 amis pour un double date',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppTheme.gray600,
                    ),
                  ),
                ],
              ),
            ],
          ).animate().fadeIn(duration: 300.ms),

          const SizedBox(height: 20),

          // Friend selector (placeholder)
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppTheme.gray200,
              ),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.group_add,
                  size: 48,
                  color: AppTheme.gold.withValues(alpha: 0.5),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Sélectionnez vos amis',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.navy,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${_selectedFriends.length}/2 sélectionnés',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.gray600,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _selectedFriends.length == 2
                      ? () => widget.onCreateDoubleDate(_selectedFriends)
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.gold,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'Créer un Double Date',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(duration: 300.ms),
        ],
      ),
    );
  }
}
