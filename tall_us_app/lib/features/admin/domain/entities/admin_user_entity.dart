import 'package:equatable/equatable.dart';

/// Extended user entity for admin views with profile + stats
class AdminUserEntity extends Equatable {
  final String id;
  final String email;
  final String displayName;
  final String gender;
  final String role;
  final String countryCode;
  final String city;
  final bool emailVerified;
  final String status;
  final DateTime createdAt;
  final String? photoUrl;
  final int matchesCount;
  final int messagesCount;

  const AdminUserEntity({
    required this.id,
    required this.email,
    required this.displayName,
    required this.gender,
    required this.role,
    required this.countryCode,
    required this.city,
    required this.emailVerified,
    this.status = 'active',
    required this.createdAt,
    this.photoUrl,
    this.matchesCount = 0,
    this.messagesCount = 0,
  });

  @override
  List<Object?> get props => [
        id, email, displayName, gender, role, countryCode, city,
        emailVerified, status, createdAt, photoUrl, matchesCount, messagesCount,
      ];
}
