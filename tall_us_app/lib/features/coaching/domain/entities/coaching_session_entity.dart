import 'package:equatable/equatable.dart';

class CoachingSessionEntity extends Equatable {
  final String id;
  final String userId;
  final String? coachName;
  final DateTime scheduledAt;
  final int durationMin;
  final String status; // requested | confirmed | completed | canceled
  final String? topic;
  final String? meetingLink;

  const CoachingSessionEntity({
    required this.id,
    required this.userId,
    this.coachName,
    required this.scheduledAt,
    this.durationMin = 30,
    this.status = 'requested',
    this.topic,
    this.meetingLink,
  });

  @override
  List<Object?> get props =>
      [id, userId, coachName, scheduledAt, durationMin, status, topic, meetingLink];
}
