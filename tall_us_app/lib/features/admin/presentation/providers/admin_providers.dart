import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tall_us/core/appwrite/appwrite_client.dart';
import 'package:tall_us/core/errors/failures.dart';
import 'package:tall_us/core/utils/logger.dart';
import 'package:tall_us/features/admin/data/datasources/admin_remote_datasource.dart';
import 'package:tall_us/features/admin/domain/entities/admin_kpi_entity.dart';
import 'package:tall_us/features/admin/domain/entities/admin_user_entity.dart';
import 'package:tall_us/features/admin/domain/entities/newsletter_entity.dart';
import 'package:tall_us/features/admin/domain/entities/email_template_entity.dart';
import 'package:tall_us/features/auth/presentation/providers/auth_providers.dart';
import 'package:tall_us/features/verification/domain/entities/height_verification_entity.dart';

// ============================================================================
// Admin Repository (simplified - delegates to datasource)
// ============================================================================

class AdminRepository {
  final AdminRemoteDataSource _dataSource;

  AdminRepository(this._dataSource);

  Future<Either<Failure, AdminKpiEntity>> getDashboardKpis() async {
    try {
      final kpis = await _dataSource.getDashboardKpis();
      return Right(kpis);
    } catch (e) {
      AppLogger.e('Failed to get dashboard KPIs', error: e);
      return Left(ServerFailure(message: e.toString(), code: 'ADMIN_ERROR'));
    }
  }

  Future<Either<Failure, List<AdminUserEntity>>> listUsers({
    String? search,
    String? role,
    String? gender,
    bool? emailVerified,
    int? limit,
    int? offset,
  }) async {
    try {
      final users = await _dataSource.listUsers(
        search: search,
        role: role,
        gender: gender,
        emailVerified: emailVerified,
        limit: limit,
        offset: offset,
      );
      return Right(users);
    } catch (e) {
      AppLogger.e('Failed to list users', error: e);
      return Left(ServerFailure(message: e.toString(), code: 'ADMIN_ERROR'));
    }
  }

  Future<Either<Failure, int>> getTotalUserCount({
    String? search,
    String? role,
  }) async {
    try {
      final count = await _dataSource.getTotalUserCount(
        search: search,
        role: role,
      );
      return Right(count);
    } catch (e) {
      return Left(ServerFailure(message: e.toString(), code: 'ADMIN_ERROR'));
    }
  }

  Future<Either<Failure, void>> banUser(String userId, String reason) async {
    try {
      await _dataSource.banUser(userId, reason);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString(), code: 'ADMIN_ERROR'));
    }
  }

  Future<Either<Failure, void>> activateUser(String userId) async {
    try {
      await _dataSource.activateUser(userId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString(), code: 'ADMIN_ERROR'));
    }
  }

  Future<Either<Failure, void>> changeUserRole(
      String userId, String newRole) async {
    try {
      await _dataSource.changeUserRole(userId, newRole);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString(), code: 'ADMIN_ERROR'));
    }
  }

  Future<Either<Failure, void>> verifyEmailManually(String userId) async {
    try {
      await _dataSource.verifyEmailManually(userId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString(), code: 'ADMIN_ERROR'));
    }
  }

  Future<Either<Failure, List<NewsletterEntity>>> listNewsletters({
    String? status,
  }) async {
    try {
      final newsletters =
          await _dataSource.listNewsletters(status: status);
      return Right(newsletters);
    } catch (e) {
      return Left(ServerFailure(message: e.toString(), code: 'ADMIN_ERROR'));
    }
  }

  Future<Either<Failure, NewsletterEntity>> createNewsletter({
    required String title,
    required String content,
    String? segmentRules,
    required String createdBy,
  }) async {
    try {
      final newsletter = await _dataSource.createNewsletter(
        title: title,
        content: content,
        segmentRules: segmentRules,
        createdBy: createdBy,
      );
      return Right(newsletter);
    } catch (e) {
      return Left(ServerFailure(message: e.toString(), code: 'ADMIN_ERROR'));
    }
  }

  Future<Either<Failure, void>> updateNewsletter({
    required String id,
    String? title,
    String? content,
    String? status,
    String? segmentRules,
  }) async {
    try {
      await _dataSource.updateNewsletter(
        id: id,
        title: title,
        content: content,
        status: status,
        segmentRules: segmentRules,
      );
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString(), code: 'ADMIN_ERROR'));
    }
  }

  Future<Either<Failure, void>> sendNewsletter(
      String id, int recipientCount) async {
    try {
      await _dataSource.sendNewsletter(id, recipientCount);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString(), code: 'ADMIN_ERROR'));
    }
  }

  Future<Either<Failure, List<EmailTemplateEntity>>>
      listEmailTemplates() async {
    try {
      final templates = await _dataSource.listEmailTemplates();
      return Right(templates);
    } catch (e) {
      return Left(ServerFailure(message: e.toString(), code: 'ADMIN_ERROR'));
    }
  }

  Future<Either<Failure, void>> updateEmailTemplate({
    required String id,
    String? subject,
    String? bodyHtml,
    String? bodyText,
  }) async {
    try {
      await _dataSource.updateEmailTemplate(
        id: id,
        subject: subject,
        bodyHtml: bodyHtml,
        bodyText: bodyText,
      );
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString(), code: 'ADMIN_ERROR'));
    }
  }

  // ===========================================================================
  // HEIGHT VERIFICATION MANAGEMENT
  // ===========================================================================

  Future<Either<Failure, List<HeightVerificationEntity>>> listVerifications({
    HeightVerificationStatus? status,
    int? limit,
    int? offset,
  }) async {
    try {
      final list = await _dataSource.listVerifications(
        status: status,
        limit: limit,
        offset: offset,
      );
      return Right(list);
    } catch (e) {
      return Left(ServerFailure(message: e.toString(), code: 'ADMIN_ERROR'));
    }
  }

  Future<Either<Failure, int>> getVerificationCount({
    HeightVerificationStatus? status,
  }) async {
    try {
      final count = await _dataSource.getVerificationCount(status: status);
      return Right(count);
    } catch (e) {
      return Left(ServerFailure(message: e.toString(), code: 'ADMIN_ERROR'));
    }
  }

  Future<Either<Failure, void>> approveVerification({
    required String verificationId,
    required String userId,
    String? reviewNote,
  }) async {
    try {
      await _dataSource.approveVerification(
        verificationId: verificationId,
        userId: userId,
        reviewNote: reviewNote,
      );
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString(), code: 'ADMIN_ERROR'));
    }
  }

  Future<Either<Failure, void>> rejectVerification({
    required String verificationId,
    required String userId,
    required String rejectionReason,
  }) async {
    try {
      await _dataSource.rejectVerification(
        verificationId: verificationId,
        userId: userId,
        rejectionReason: rejectionReason,
      );
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString(), code: 'ADMIN_ERROR'));
    }
  }

  Future<Either<Failure, void>> markUnderReview(String verificationId) async {
    try {
      await _dataSource.markUnderReview(verificationId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString(), code: 'ADMIN_ERROR'));
    }
  }
}

// ============================================================================
// Providers
// ============================================================================

/// Admin datasource provider
final adminDataSourceProvider = Provider<AdminRemoteDataSource>((ref) {
  return AdminRemoteDataSource(
    databases: ref.watch(databasesProvider),
  );
});

/// Admin repository provider
final adminRepositoryProvider = Provider<AdminRepository>((ref) {
  return AdminRepository(ref.watch(adminDataSourceProvider));
});

/// Admin auth guard - checks if current user is admin on web
final isAdminProvider = Provider<bool>((ref) {
  if (!kIsWeb) return false;
  final user = ref.watch(authenticatedUserProvider);
  return user?.isAdmin ?? false;
});

// ============================================================================
// Admin State classes
// ============================================================================

/// Dashboard KPI state
class AdminDashboardState {
  final AdminKpiEntity? kpis;
  final bool isLoading;
  final String? error;

  const AdminDashboardState({
    this.kpis,
    this.isLoading = false,
    this.error,
  });

  AdminDashboardState copyWith({
    AdminKpiEntity? kpis,
    bool? isLoading,
    String? error,
  }) {
    return AdminDashboardState(
      kpis: kpis ?? this.kpis,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

/// Dashboard notifier
class AdminDashboardNotifier extends StateNotifier<AdminDashboardState> {
  final AdminRepository _repository;

  AdminDashboardNotifier(this._repository)
      : super(const AdminDashboardState());

  Future<void> loadKpis() async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await _repository.getDashboardKpis();

    result.fold(
      (failure) => state = state.copyWith(isLoading: false, error: failure.message),
      (kpis) => state = state.copyWith(isLoading: false, kpis: kpis),
    );
  }
}

/// Dashboard provider
final adminDashboardProvider =
    StateNotifierProvider<AdminDashboardNotifier, AdminDashboardState>((ref) {
  return AdminDashboardNotifier(ref.watch(adminRepositoryProvider));
});

// ============================================================================
// Users Management
// ============================================================================

/// Users list state
class AdminUsersState {
  final List<AdminUserEntity> users;
  final bool isLoading;
  final String? error;
  final String search;
  final String? roleFilter;
  final String? statusFilter;
  final bool? emailVerifiedFilter;
  final int currentPage;
  final int totalCount;
  final int pageSize;

  const AdminUsersState({
    this.users = const [],
    this.isLoading = false,
    this.error,
    this.search = '',
    this.roleFilter,
    this.statusFilter,
    this.emailVerifiedFilter,
    this.currentPage = 0,
    this.totalCount = 0,
    this.pageSize = 25,
  });

  int get totalPages => (totalCount / pageSize).ceil();
  bool get hasMore => (currentPage + 1) * pageSize < totalCount;

  AdminUsersState copyWith({
    List<AdminUserEntity>? users,
    bool? isLoading,
    String? error,
    String? search,
    String? roleFilter,
    String? statusFilter,
    bool? emailVerifiedFilter,
    int? currentPage,
    int? totalCount,
    int? pageSize,
  }) {
    return AdminUsersState(
      users: users ?? this.users,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      search: search ?? this.search,
      roleFilter: roleFilter,
      statusFilter: statusFilter,
      emailVerifiedFilter: emailVerifiedFilter,
      currentPage: currentPage ?? this.currentPage,
      totalCount: totalCount ?? this.totalCount,
      pageSize: pageSize ?? this.pageSize,
    );
  }
}

/// Users notifier
class AdminUsersNotifier extends StateNotifier<AdminUsersState> {
  final AdminRepository _repository;

  AdminUsersNotifier(this._repository) : super(const AdminUsersState());

  Future<void> loadUsers({bool resetPage = false}) async {
    if (resetPage) {
      state = state.copyWith(isLoading: true, error: null, currentPage: 0, users: []);
    } else {
      state = state.copyWith(isLoading: true, error: null);
    }

    // Get total count
    final countResult = await _repository.getTotalUserCount(
      search: state.search.isNotEmpty ? state.search : null,
      role: state.roleFilter,
    );

    final totalCount = countResult.fold(
      (failure) => state.totalCount,
      (count) => count,
    );

    final offset = state.currentPage * state.pageSize;

    final result = await _repository.listUsers(
      search: state.search.isNotEmpty ? state.search : null,
      role: state.roleFilter,
      emailVerified: state.emailVerifiedFilter,
      limit: state.pageSize,
      offset: offset,
    );

    result.fold(
      (failure) => state = state.copyWith(isLoading: false, error: failure.message),
      (users) => state = state.copyWith(
        isLoading: false,
        users: users,
        totalCount: totalCount,
      ),
    );
  }

  void setSearch(String search) {
    state = state.copyWith(search: search);
    loadUsers(resetPage: true);
  }

  void setRoleFilter(String? role) {
    state = state.copyWith(roleFilter: role);
    loadUsers(resetPage: true);
  }

  void setEmailVerifiedFilter(bool? verified) {
    state = state.copyWith(emailVerifiedFilter: verified);
    loadUsers(resetPage: true);
  }

  void nextPage() {
    if (state.hasMore) {
      state = state.copyWith(currentPage: state.currentPage + 1);
      loadUsers();
    }
  }

  void previousPage() {
    if (state.currentPage > 0) {
      state = state.copyWith(currentPage: state.currentPage - 1);
      loadUsers();
    }
  }

  Future<bool> banUser(String userId, String reason) async {
    final result = await _repository.banUser(userId, reason);
    return result.isRight();
  }

  Future<bool> activateUser(String userId) async {
    final result = await _repository.activateUser(userId);
    return result.isRight();
  }

  Future<bool> changeUserRole(String userId, String newRole) async {
    final result = await _repository.changeUserRole(userId, newRole);
    return result.isRight();
  }

  Future<bool> verifyEmailManually(String userId) async {
    final result = await _repository.verifyEmailManually(userId);
    return result.isRight();
  }
}

/// Users provider
final adminUsersProvider =
    StateNotifierProvider<AdminUsersNotifier, AdminUsersState>((ref) {
  return AdminUsersNotifier(ref.watch(adminRepositoryProvider));
});

// ============================================================================
// Verifications Management
// ============================================================================

/// Verifications list state
class AdminVerificationsState {
  final List<HeightVerificationEntity> verifications;
  final bool isLoading;
  final String? error;
  final HeightVerificationStatus? statusFilter;
  final int currentPage;
  final int totalCount;
  final int pageSize;

  const AdminVerificationsState({
    this.verifications = const [],
    this.isLoading = false,
    this.error,
    this.statusFilter,
    this.currentPage = 0,
    this.totalCount = 0,
    this.pageSize = 25,
  });

  int get totalPages => (totalCount / pageSize).ceil();
  bool get hasMore => (currentPage + 1) * pageSize < totalCount;

  AdminVerificationsState copyWith({
    List<HeightVerificationEntity>? verifications,
    bool? isLoading,
    String? error,
    HeightVerificationStatus? statusFilter,
    bool clearStatusFilter = false,
    int? currentPage,
    int? totalCount,
    int? pageSize,
  }) {
    return AdminVerificationsState(
      verifications: verifications ?? this.verifications,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      statusFilter: clearStatusFilter ? null : (statusFilter ?? this.statusFilter),
      currentPage: currentPage ?? this.currentPage,
      totalCount: totalCount ?? this.totalCount,
      pageSize: pageSize ?? this.pageSize,
    );
  }
}

/// Verifications notifier
class AdminVerificationsNotifier
    extends StateNotifier<AdminVerificationsState> {
  final AdminRepository _repository;

  AdminVerificationsNotifier(this._repository)
      : super(const AdminVerificationsState());

  Future<void> loadVerifications({bool resetPage = false}) async {
    if (resetPage) {
      state = state.copyWith(isLoading: true, error: null, currentPage: 0, verifications: []);
    } else {
      state = state.copyWith(isLoading: true, error: null);
    }

    final countResult = await _repository.getVerificationCount(
      status: state.statusFilter,
    );
    final totalCount = countResult.fold(
      (failure) => state.totalCount,
      (count) => count,
    );

    final offset = state.currentPage * state.pageSize;

    final result = await _repository.listVerifications(
      status: state.statusFilter,
      limit: state.pageSize,
      offset: offset,
    );

    result.fold(
      (failure) =>
          state = state.copyWith(isLoading: false, error: failure.message),
      (verifications) => state = state.copyWith(
        isLoading: false,
        verifications: verifications,
        totalCount: totalCount,
      ),
    );
  }

  void setStatusFilter(HeightVerificationStatus? status) {
    if (status == null) {
      state = state.copyWith(clearStatusFilter: true);
    } else {
      state = state.copyWith(statusFilter: status);
    }
    loadVerifications(resetPage: true);
  }

  void nextPage() {
    if (state.hasMore) {
      state = state.copyWith(currentPage: state.currentPage + 1);
      loadVerifications();
    }
  }

  void previousPage() {
    if (state.currentPage > 0) {
      state = state.copyWith(currentPage: state.currentPage - 1);
      loadVerifications();
    }
  }

  Future<bool> approve(String verificationId, String userId,
      {String? reviewNote}) async {
    final result = await _repository.approveVerification(
      verificationId: verificationId,
      userId: userId,
      reviewNote: reviewNote,
    );
    return result.isRight();
  }

  Future<bool> reject(String verificationId, String userId, String reason) async {
    final result = await _repository.rejectVerification(
      verificationId: verificationId,
      userId: userId,
      rejectionReason: reason,
    );
    return result.isRight();
  }

  Future<bool> markUnderReview(String verificationId) async {
    final result = await _repository.markUnderReview(verificationId);
    return result.isRight();
  }
}

/// Verifications provider
final adminVerificationsProvider = StateNotifierProvider<
    AdminVerificationsNotifier, AdminVerificationsState>((ref) {
  return AdminVerificationsNotifier(ref.watch(adminRepositoryProvider));
});

// ============================================================================
// Newsletter Management
// ============================================================================

/// Newsletters list state
class AdminNewslettersState {
  final List<NewsletterEntity> newsletters;
  final bool isLoading;
  final String? error;
  final String? statusFilter;
  final int currentPage;
  final int totalCount;
  final int pageSize;

  const AdminNewslettersState({
    this.newsletters = const [],
    this.isLoading = false,
    this.error,
    this.statusFilter,
    this.currentPage = 0,
    this.totalCount = 0,
    this.pageSize = 25,
  });

  int get totalPages => (totalCount / pageSize).ceil();
  bool get hasMore => (currentPage + 1) * pageSize < totalCount;

  AdminNewslettersState copyWith({
    List<NewsletterEntity>? newsletters,
    bool? isLoading,
    String? error,
    String? statusFilter,
    bool clearStatusFilter = false,
    int? currentPage,
    int? totalCount,
    int? pageSize,
  }) {
    return AdminNewslettersState(
      newsletters: newsletters ?? this.newsletters,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      statusFilter: clearStatusFilter ? null : (statusFilter ?? this.statusFilter),
      currentPage: currentPage ?? this.currentPage,
      totalCount: totalCount ?? this.totalCount,
      pageSize: pageSize ?? this.pageSize,
    );
  }
}

/// Newsletters notifier
class AdminNewslettersNotifier
    extends StateNotifier<AdminNewslettersState> {
  final AdminRepository _repository;

  AdminNewslettersNotifier(this._repository)
      : super(const AdminNewslettersState());

  Future<void> loadNewsletters({bool resetPage = false}) async {
    if (resetPage) {
      state = state.copyWith(isLoading: true, error: null, currentPage: 0, newsletters: []);
    } else {
      state = state.copyWith(isLoading: true, error: null);
    }

    final result = await _repository.listNewsletters(
      status: state.statusFilter,
    );

    result.fold(
      (failure) =>
          state = state.copyWith(isLoading: false, error: failure.message),
      (newsletters) => state = state.copyWith(
        isLoading: false,
        newsletters: newsletters,
        totalCount: newsletters.length,
      ),
    );
  }

  void setStatusFilter(String? status) {
    if (status == null) {
      state = state.copyWith(clearStatusFilter: true);
    } else {
      state = state.copyWith(statusFilter: status);
    }
    loadNewsletters(resetPage: true);
  }

  Future<bool> createNewsletter({
    required String title,
    required String content,
    String? segmentRules,
    required String createdBy,
  }) async {
    final result = await _repository.createNewsletter(
      title: title,
      content: content,
      segmentRules: segmentRules,
      createdBy: createdBy,
    );
    if (result.isRight()) {
      loadNewsletters();
      return true;
    }
    return false;
  }

  Future<bool> updateNewsletter({
    required String id,
    String? title,
    String? content,
    String? status,
    String? segmentRules,
  }) async {
    final result = await _repository.updateNewsletter(
      id: id,
      title: title,
      content: content,
      status: status,
      segmentRules: segmentRules,
    );
    if (result.isRight()) {
      loadNewsletters();
      return true;
    }
    return false;
  }

  Future<bool> sendNewsletter(String id, int recipientCount) async {
    final result = await _repository.sendNewsletter(id, recipientCount);
    if (result.isRight()) {
      loadNewsletters();
      return true;
    }
    return false;
  }
}

/// Newsletters provider
final adminNewslettersProvider = StateNotifierProvider<
    AdminNewslettersNotifier, AdminNewslettersState>((ref) {
  return AdminNewslettersNotifier(ref.watch(adminRepositoryProvider));
});

// ============================================================================
// Email Templates Management
// ============================================================================

/// Email templates state
class AdminTemplatesState {
  final List<EmailTemplateEntity> templates;
  final bool isLoading;
  final String? error;

  const AdminTemplatesState({
    this.templates = const [],
    this.isLoading = false,
    this.error,
  });

  AdminTemplatesState copyWith({
    List<EmailTemplateEntity>? templates,
    bool? isLoading,
    String? error,
  }) {
    return AdminTemplatesState(
      templates: templates ?? this.templates,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// Email templates notifier
class AdminTemplatesNotifier extends StateNotifier<AdminTemplatesState> {
  final AdminRepository _repository;

  AdminTemplatesNotifier(this._repository)
      : super(const AdminTemplatesState());

  Future<void> loadTemplates() async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await _repository.listEmailTemplates();

    result.fold(
      (failure) =>
          state = state.copyWith(isLoading: false, error: failure.message),
      (templates) => state = state.copyWith(
        isLoading: false,
        templates: templates,
      ),
    );
  }

  Future<bool> updateTemplate({
    required String id,
    String? subject,
    String? bodyHtml,
    String? bodyText,
  }) async {
    final result = await _repository.updateEmailTemplate(
      id: id,
      subject: subject,
      bodyHtml: bodyHtml,
      bodyText: bodyText,
    );
    if (result.isRight()) {
      loadTemplates();
      return true;
    }
    return false;
  }
}

/// Templates provider
final adminTemplatesProvider =
    StateNotifierProvider<AdminTemplatesNotifier, AdminTemplatesState>((ref) {
  return AdminTemplatesNotifier(ref.watch(adminRepositoryProvider));
});

// ============================================================================
// Analytics
// ============================================================================

/// Data point for time-series charts
class AnalyticsDataPoint {
  final DateTime date;
  final int value;
  const AnalyticsDataPoint({required this.date, required this.value});
}

/// Analytics state
class AdminAnalyticsState {
  final AdminKpiEntity? kpis;
  final List<AnalyticsDataPoint> userGrowthData;
  final List<AnalyticsDataPoint> matchTrendData;
  final List<AnalyticsDataPoint> messageTrendData;
  final Map<String, int> genderDistribution;
  final Map<String, int> roleDistribution;
  final bool isLoading;
  final String? error;

  const AdminAnalyticsState({
    this.kpis,
    this.userGrowthData = const [],
    this.matchTrendData = const [],
    this.messageTrendData = const [],
    this.genderDistribution = const {},
    this.roleDistribution = const {},
    this.isLoading = false,
    this.error,
  });

  AdminAnalyticsState copyWith({
    AdminKpiEntity? kpis,
    List<AnalyticsDataPoint>? userGrowthData,
    List<AnalyticsDataPoint>? matchTrendData,
    List<AnalyticsDataPoint>? messageTrendData,
    Map<String, int>? genderDistribution,
    Map<String, int>? roleDistribution,
    bool? isLoading,
    String? error,
  }) {
    return AdminAnalyticsState(
      kpis: kpis ?? this.kpis,
      userGrowthData: userGrowthData ?? this.userGrowthData,
      matchTrendData: matchTrendData ?? this.matchTrendData,
      messageTrendData: messageTrendData ?? this.messageTrendData,
      genderDistribution: genderDistribution ?? this.genderDistribution,
      roleDistribution: roleDistribution ?? this.roleDistribution,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// Analytics notifier
class AdminAnalyticsNotifier extends StateNotifier<AdminAnalyticsState> {
  final AdminRepository _repository;

  AdminAnalyticsNotifier(this._repository)
      : super(const AdminAnalyticsState());

  Future<void> loadAnalytics() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Load KPIs
      final kpiResult = await _repository.getDashboardKpis();
      kpiResult.fold(
        (failure) =>
            state = state.copyWith(isLoading: false, error: failure.message),
        (kpis) {
          state = state.copyWith(
            kpis: kpis,
            genderDistribution: kpis.genderDistribution,
          );
        },
      );

      // Load role distribution
      final roleData = <String, int>{};
      for (final role in ['free', 'premium', 'admin']) {
        final result = await _repository.getTotalUserCount(role: role);
        result.fold(
          (failure) {},
          (count) => roleData[role] = count,
        );
      }
      state = state.copyWith(roleDistribution: roleData);

      // Build growth data from KPIs
      final kpis = state.kpis;
      if (kpis != null) {
        final now = DateTime.now();
        final growthData = <AnalyticsDataPoint>[];
        final matchData = <AnalyticsDataPoint>[];
        final messageData = <AnalyticsDataPoint>[];

        for (int i = 29; i >= 0; i--) {
          final date = now.subtract(Duration(days: i));
          final dayFactor = (30 - i) / 30;
          growthData.add(AnalyticsDataPoint(
            date: date,
            value: (kpis.newUsersThisMonth * dayFactor).round(),
          ));
          matchData.add(AnalyticsDataPoint(
            date: date,
            value: (kpis.matchesCount * dayFactor / 30).round().clamp(0, kpis.matchesCount),
          ));
          messageData.add(AnalyticsDataPoint(
            date: date,
            value: (kpis.messagesCount * dayFactor / 30).round().clamp(0, kpis.messagesCount),
          ));
        }

        state = state.copyWith(
          userGrowthData: growthData,
          matchTrendData: matchData,
          messageTrendData: messageData,
        );
      }

      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

/// Analytics provider
final adminAnalyticsProvider =
    StateNotifierProvider<AdminAnalyticsNotifier, AdminAnalyticsState>((ref) {
  return AdminAnalyticsNotifier(
    ref.watch(adminRepositoryProvider),
  );
});
