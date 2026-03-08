import 'package:equatable/equatable.dart';

/// Height verification status
enum HeightVerificationStatus {
  /// Verification has not been started
  pending,

  /// Verification photo has been submitted and is being reviewed
  submitted,

  /// Verification is under review
  underReview,

  /// Height has been verified
  verified,

  /// Verification was rejected
  rejected,
}

/// Height verification request entity
class HeightVerificationEntity extends Equatable {
  final String id;
  final String userId;
  final int claimedHeightCm;
  final String? photoUrl;
  final HeightVerificationStatus status;
  final DateTime? submittedAt;
  final DateTime? reviewedAt;
  final String? reviewNote;
  final String? rejectionReason;

  const HeightVerificationEntity({
    required this.id,
    required this.userId,
    required this.claimedHeightCm,
    this.photoUrl,
    this.status = HeightVerificationStatus.pending,
    this.submittedAt,
    this.reviewedAt,
    this.reviewNote,
    this.rejectionReason,
  });

  /// Check if verification is in progress
  bool isInProgress() {
    return status == HeightVerificationStatus.submitted ||
        status == HeightVerificationStatus.underReview;
  }

  /// Check if user is verified
  bool isVerified() {
    return status == HeightVerificationStatus.verified;
  }

  /// Get display text for height
  String get displayHeight {
    final totalInches = (claimedHeightCm / 2.54).round();
    final feet = totalInches ~/ 12;
    final inches = totalInches % 12;
    return "$feet'$inches\" ($claimedHeightCm cm)";
  }

  /// Get status text for display
  String get statusText {
    switch (status) {
      case HeightVerificationStatus.pending:
        return 'Non vérifié';
      case HeightVerificationStatus.submitted:
        return 'En attente de validation';
      case HeightVerificationStatus.underReview:
        return 'En cours de vérification';
      case HeightVerificationStatus.verified:
        return 'Vérifié ✓';
      case HeightVerificationStatus.rejected:
        return 'Rejeté';
    }
  }

  /// Get status color
  int get statusColor {
    switch (status) {
      case HeightVerificationStatus.pending:
        return 0xFF757575;
      case HeightVerificationStatus.submitted:
        return 0xFFF57C00;
      case HeightVerificationStatus.underReview:
        return 0xFF1976D2;
      case HeightVerificationStatus.verified:
        return 0xFF4CAF50;
      case HeightVerificationStatus.rejected:
        return 0xFFF44336;
    }
  }

  /// Get status icon
  String get statusIcon {
    switch (status) {
      case HeightVerificationStatus.pending:
        return '⏳';
      case HeightVerificationStatus.submitted:
        return '⏰';
      case HeightVerificationStatus.underReview:
        return '👀';
      case HeightVerificationStatus.verified:
        return '✅';
      case HeightVerificationStatus.rejected:
        return '❌';
    }
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        claimedHeightCm,
        photoUrl,
        status,
        submittedAt,
        reviewedAt,
        reviewNote,
        rejectionReason,
      ];

  HeightVerificationEntity copyWith({
    String? id,
    String? userId,
    int? claimedHeightCm,
    String? photoUrl,
    HeightVerificationStatus? status,
    DateTime? submittedAt,
    DateTime? reviewedAt,
    String? reviewNote,
    String? rejectionReason,
  }) {
    return HeightVerificationEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      claimedHeightCm: claimedHeightCm ?? this.claimedHeightCm,
      photoUrl: photoUrl ?? this.photoUrl,
      status: status ?? this.status,
      submittedAt: submittedAt ?? this.submittedAt,
      reviewedAt: reviewedAt ?? this.reviewedAt,
      reviewNote: reviewNote ?? this.reviewNote,
      rejectionReason: rejectionReason ?? this.rejectionReason,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'claimedHeightCm': claimedHeightCm,
      'photoUrl': photoUrl,
      'status': status.name,
      'submittedAt': submittedAt?.toIso8601String(),
      'reviewedAt': reviewedAt?.toIso8601String(),
      'reviewNote': reviewNote,
      'rejectionReason': rejectionReason,
    };
  }

  /// Create from JSON
  factory HeightVerificationEntity.fromJson(Map<String, dynamic> json) {
    return HeightVerificationEntity(
      id: json['id'] as String,
      userId: json['userId'] as String,
      claimedHeightCm: json['claimedHeightCm'] as int,
      photoUrl: json['photoUrl'] as String?,
      status: HeightVerificationStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => HeightVerificationStatus.pending,
      ),
      submittedAt: json['submittedAt'] != null
          ? DateTime.parse(json['submittedAt'] as String)
          : null,
      reviewedAt: json['reviewedAt'] != null
          ? DateTime.parse(json['reviewedAt'] as String)
          : null,
      reviewNote: json['reviewNote'] as String?,
      rejectionReason: json['rejectionReason'] as String?,
    );
  }
}
