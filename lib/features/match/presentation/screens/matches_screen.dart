import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tall_us/core/theme/app_theme.dart';
import 'package:tall_us/core/widgets/skeleton/skeleton_loading.dart';
import 'package:tall_us/features/message/presentation/screens/chat_screen.dart';

/// Matches list screen
class MatchesScreen extends ConsumerStatefulWidget {
  const MatchesScreen({super.key});

  @override
  ConsumerState<MatchesScreen> createState() => _MatchesScreenState();
}

class _MatchesScreenState extends ConsumerState<MatchesScreen> {
  final List<Map<String, dynamic>> _matches = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadMatches();
  }

  Future<void> _loadMatches() async {
    setState(() {
      _isLoading = true;
    });

    // TODO: Load matches from repository
    await Future.delayed(const Duration(seconds: 1));

    // Dummy data
    setState(() {
      _matches.addAll([
        {
          'id': '1',
          'name': 'Sophie',
          'age': 26,
          'photo': 'https://via.placeholder.com/150',
          'lastMessage': 'Salut ! Ça va ?',
          'lastMessageTime':
              DateTime.now().subtract(const Duration(minutes: 5)),
          'unreadCount': 2,
        },
        {
          'id': '2',
          'name': 'Marie',
          'age': 28,
          'photo': 'https://via.placeholder.com/150',
          'lastMessage': 'Tu veux qu\'on se voit ce weekend ?',
          'lastMessageTime': DateTime.now().subtract(const Duration(hours: 2)),
          'unreadCount': 0,
        },
        {
          'id': '3',
          'name': 'Isabelle',
          'age': 25,
          'photo': 'https://via.placeholder.com/150',
          'lastMessage': null,
          'lastMessageTime': DateTime.now().subtract(const Duration(days: 1)),
          'unreadCount': 0,
        },
      ]);
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mes Matches',
          style: TextStyle(
            color: AppTheme.navy,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.bordeaux.withValues(alpha: 0.05),
              AppTheme.navy.withValues(alpha: 0.02),
            ],
          ),
        ),
        child: _isLoading
            ? const Center(
                child: MessageLineSkeleton(),
              )
            : _matches.isEmpty
                ? _buildEmptyState()
                : _buildMatchesList(),
      ),
    );
  }

  Widget _buildMatchesList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: _matches.length,
      itemBuilder: (context, index) {
        final match = _matches[index];

        return GestureDetector(
          onTap: () => _openChat(match),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  // Photo
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 32,
                        backgroundImage: NetworkImage(match['photo']),
                      ),
                      if (match['unreadCount'] > 0)
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: AppTheme.bordeaux,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              '${match['unreadCount']}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(width: 16),

                  // Name and message
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${match['name']}, ${match['age']}',
                          style: const TextStyle(
                            color: AppTheme.navy,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          match['lastMessage'] ?? 'Pas encore de messages',
                          style: TextStyle(
                            color: match['lastMessage'] != null
                                ? AppTheme.navy.withValues(alpha: 0.7)
                                : AppTheme.navy.withValues(alpha: 0.4),
                            fontSize: 14,
                            fontStyle: match['lastMessage'] != null
                                ? FontStyle.normal
                                : FontStyle.italic,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),

                  // Time
                  Text(
                    _formatTime(match['lastMessageTime']),
                    style: TextStyle(
                      color: AppTheme.navy.withValues(alpha: 0.5),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            size: 80,
            color: AppTheme.navy.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 24),
          Text(
            'Aucun match pour le moment',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppTheme.navy,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Continuez à swiper pour trouver des personnes',
            style: TextStyle(
              fontSize: 16,
              color: AppTheme.navy.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'qui vous correspondent vraiment !',
            style: TextStyle(
              fontSize: 16,
              color: AppTheme.navy.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('/discovery');
            },
            icon: const Icon(Icons.explore),
            label: const Text('Découvrir des profils'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.bordeaux,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 16,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime? time) {
    if (time == null) return '';

    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 1) {
      return 'À l\'instant';
    } else if (difference.inMinutes < 60) {
      return 'Il y a ${difference.inMinutes} min';
    } else if (difference.inHours < 24) {
      return 'Il y a ${difference.inHours} h';
    } else if (difference.inDays < 7) {
      return 'Il y a ${difference.inDays} j';
    } else {
      return '${time.day}/${time.month}';
    }
  }

  void _openChat(Map<String, dynamic> match) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ChatScreen(
          matchId: match['id'],
          otherUserId: match['id'],
          otherUserName: match['name'],
        ),
      ),
    );
  }
}
