import 'package:equatable/equatable.dart';

/// KPI data for the admin dashboard
class AdminKpiEntity extends Equatable {
  final int totalUsers;
  final int newUsersToday;
  final int newUsersThisWeek;
  final int newUsersThisMonth;
  final int premiumCount;
  final int matchesCount;
  final int messagesCount;
  final int verificationPendingCount;
  final Map<String, int> genderDistribution;

  const AdminKpiEntity({
    this.totalUsers = 0,
    this.newUsersToday = 0,
    this.newUsersThisWeek = 0,
    this.newUsersThisMonth = 0,
    this.premiumCount = 0,
    this.matchesCount = 0,
    this.messagesCount = 0,
    this.verificationPendingCount = 0,
    this.genderDistribution = const {},
  });

  @override
  List<Object?> get props => [
        totalUsers, newUsersToday, newUsersThisWeek, newUsersThisMonth,
        premiumCount, matchesCount, messagesCount, verificationPendingCount,
        genderDistribution,
      ];
}
