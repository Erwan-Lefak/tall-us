import 'package:equatable/equatable.dart';

/// Swipe action type
enum SwipeAction {
  like,
  pass,
  superLike,
}

/// Entity representing a swipe action on a profile
class SwipeEntity extends Equatable {
  final String id;
  final String swiperId; // User who performed the swipe
  final String targetId; // User being swiped on
  final SwipeAction action;
  final DateTime createdAt;

  const SwipeEntity({
    required this.id,
    required this.swiperId,
    required this.targetId,
    required this.action,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, swiperId, targetId, action, createdAt];
}
