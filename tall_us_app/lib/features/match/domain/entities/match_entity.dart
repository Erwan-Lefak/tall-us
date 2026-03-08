import 'package:equatable/equatable.dart';

/// Entity representing a match between two users
class MatchEntity extends Equatable {
  final String id;
  final String user1Id;
  final String user2Id;
  final DateTime createdAt;
  final String? lastMessageId;
  final DateTime? lastMessageAt;
  final bool isRead; // Has the match been acknowledged

  const MatchEntity({
    required this.id,
    required this.user1Id,
    required this.user2Id,
    required this.createdAt,
    this.lastMessageId,
    this.lastMessageAt,
    this.isRead = false,
  });

  /// Get the ID of the other user in the match
  String getOtherUserId(String currentUserId) {
    return currentUserId == user1Id ? user2Id : user1Id;
  }

  @override
  List<Object?> get props => [
        id,
        user1Id,
        user2Id,
        createdAt,
        lastMessageId,
        lastMessageAt,
        isRead,
      ];
}
