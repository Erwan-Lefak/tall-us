import 'package:equatable/equatable.dart';
import 'package:tall_us/features/swipe/domain/entities/swipe_entity.dart';

/// Entity for tracking swipe history (for Rewind feature)
class SwipeHistoryEntity extends Equatable {
  final String id;
  final String userId;
  final String targetProfileId;
  final SwipeAction action;
  final DateTime timestamp;
  final bool isRewound; // If this swipe has been rewound

  const SwipeHistoryEntity({
    required this.id,
    required this.userId,
    required this.targetProfileId,
    required this.action,
    required this.timestamp,
    this.isRewound = false,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        targetProfileId,
        action,
        timestamp,
        isRewound,
      ];

  SwipeHistoryEntity copyWith({
    String? id,
    String? userId,
    String? targetProfileId,
    SwipeAction? action,
    DateTime? timestamp,
    bool? isRewound,
  }) {
    return SwipeHistoryEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      targetProfileId: targetProfileId ?? this.targetProfileId,
      action: action ?? this.action,
      timestamp: timestamp ?? this.timestamp,
      isRewound: isRewound ?? this.isRewound,
    );
  }

  /// Check if rewind is still available (within 24 hours)
  bool get canRewind {
    if (isRewound) return false;
    final hoursSinceSwipe = DateTime.now().difference(timestamp).inHours;
    return hoursSinceSwipe < 24;
  }

  /// Get time remaining for rewind
  int get hoursRemainingForRewind {
    final hoursSinceSwipe = DateTime.now().difference(timestamp).inHours;
    return 24 - hoursSinceSwipe;
  }
}
