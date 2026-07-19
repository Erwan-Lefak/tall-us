import 'package:equatable/equatable.dart';

/// Newsletter entity for admin management
class NewsletterEntity extends Equatable {
  final String id;
  final String title;
  final String content;
  final String status; // draft, scheduled, sent
  final String? segmentRules;
  final DateTime? scheduledAt;
  final DateTime? sentAt;
  final int recipientCount;
  final String createdBy;
  final DateTime createdAt;

  const NewsletterEntity({
    required this.id,
    required this.title,
    required this.content,
    this.status = 'draft',
    this.segmentRules,
    this.scheduledAt,
    this.sentAt,
    this.recipientCount = 0,
    required this.createdBy,
    required this.createdAt,
  });

  NewsletterEntity copyWith({
    String? title,
    String? content,
    String? status,
    String? segmentRules,
    DateTime? scheduledAt,
    DateTime? sentAt,
    int? recipientCount,
  }) {
    return NewsletterEntity(
      id: id,
      title: title ?? this.title,
      content: content ?? this.content,
      status: status ?? this.status,
      segmentRules: segmentRules ?? this.segmentRules,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      sentAt: sentAt ?? this.sentAt,
      recipientCount: recipientCount ?? this.recipientCount,
      createdBy: createdBy,
      createdAt: createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id, title, content, status, segmentRules, scheduledAt, sentAt,
        recipientCount, createdBy, createdAt,
      ];
}
