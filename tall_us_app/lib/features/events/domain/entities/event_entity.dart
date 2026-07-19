import 'package:equatable/equatable.dart';

class EventEntity extends Equatable {
  final String id;
  final String title;
  final String type; // soiree | speedDating | tallFrance
  final DateTime eventDate;
  final String city;
  final String venue;
  final String description;
  final String imageUrl;
  final int priceEur;
  final int spotsLeft;

  const EventEntity({
    required this.id,
    required this.title,
    required this.type,
    required this.eventDate,
    this.city = '',
    this.venue = '',
    this.description = '',
    this.imageUrl = '',
    this.priceEur = 0,
    this.spotsLeft = 0,
  });

  @override
  List<Object?> get props => [
        id, title, type, eventDate, city, venue, description, imageUrl,
        priceEur, spotsLeft,
      ];
}
