import 'package:appwrite/appwrite.dart';
import 'package:tall_us/core/appwrite/appwrite_config.dart';
import 'package:tall_us/core/utils/logger.dart';
import 'package:tall_us/features/admin/domain/entities/admin_kpi_entity.dart';
import 'package:tall_us/features/admin/domain/entities/admin_user_entity.dart';
import 'package:tall_us/features/admin/domain/entities/newsletter_entity.dart';
import 'package:tall_us/features/admin/domain/entities/email_template_entity.dart';
import 'package:tall_us/features/verification/domain/entities/height_verification_entity.dart';

/// Remote data source for admin operations
class AdminRemoteDataSource {
  final Databases _databases;

  AdminRemoteDataSource({required Databases databases}) : _databases = databases;

  // ============================================================================
  // DASHBOARD KPIs
  // ============================================================================

  /// Get dashboard KPIs
  ///
  /// Each sub-query is isolated so a single failing collection (e.g. a missing
  /// attribute) degrades gracefully to 0 instead of failing the whole dashboard.
  Future<AdminKpiEntity> getDashboardKpis() async {
    AppLogger.i('Fetching admin dashboard KPIs');

    final totalUsers = await _safe(_getTotalDocuments(AppwriteConfig.usersCollection));
    final newToday = await _safe(_getNewUsersCount('today'));
    final newWeek = await _safe(_getNewUsersCount('week'));
    final newMonth = await _safe(_getNewUsersCount('month'));
    final premium = await _safe(
        _getCountByField(AppwriteConfig.usersCollection, 'role', 'premium'));
    final matches = await _safe(_getTotalDocuments(AppwriteConfig.matchesCollection));
    final messages = await _safe(_getTotalDocuments(AppwriteConfig.messagesCollection));
    final verifPending = await _safe(_getCountByField(
        AppwriteConfig.verificationsCollection, 'status', 'pending'));
    final gender = await _safeGender(_getGenderDistribution());

    return AdminKpiEntity(
      totalUsers: totalUsers,
      newUsersToday: newToday,
      newUsersThisWeek: newWeek,
      newUsersThisMonth: newMonth,
      premiumCount: premium,
      matchesCount: matches,
      messagesCount: messages,
      verificationPendingCount: verifPending,
      genderDistribution: gender,
    );
  }

  /// Runs an int query, returning 0 on any error.
  Future<int> _safe(Future<int> future) async {
    try {
      return await future;
    } catch (e) {
      AppLogger.w('KPI query failed (defaulting to 0): $e');
      return 0;
    }
  }

  /// Runs the gender distribution query, returning empty map on error.
  Future<Map<String, int>> _safeGender(Future<Map<String, int>> future) async {
    try {
      return await future;
    } catch (e) {
      AppLogger.w('Gender distribution query failed: $e');
      return {};
    }
  }

  Future<int> _getTotalDocuments(String collectionId) async {
    final result = await _databases.listDocuments(
      databaseId: AppwriteConfig.databaseId,
      collectionId: collectionId,
      queries: [Query.limit(1)],
    );
    return result.total;
  }

  Future<int> _getNewUsersCount(String period) async {
    final now = DateTime.now();
    DateTime since;
    switch (period) {
      case 'today':
        since = DateTime(now.year, now.month, now.day);
        break;
      case 'week':
        since = now.subtract(const Duration(days: 7));
        break;
      case 'month':
        since = DateTime(now.year, now.month);
        break;
      default:
        since = now.subtract(const Duration(days: 30));
    }

    // The users collection has no custom created_at field; use the Appwrite
    // system field $createdAt instead.
    final result = await _databases.listDocuments(
      databaseId: AppwriteConfig.databaseId,
      collectionId: AppwriteConfig.usersCollection,
      queries: [
        Query.greaterThanEqual('\$createdAt', since.toIso8601String()),
        Query.limit(1),
      ],
    );
    return result.total;
  }

  Future<int> _getCountByField(
      String collectionId, String field, String value) async {
    final result = await _databases.listDocuments(
      databaseId: AppwriteConfig.databaseId,
      collectionId: collectionId,
      queries: [
        Query.equal(field, [value]),
        Query.limit(1),
      ],
    );
    return result.total;
  }

  Future<Map<String, int>> _getGenderDistribution() async {
    final result = await _databases.listDocuments(
      databaseId: AppwriteConfig.databaseId,
      collectionId: AppwriteConfig.profilesCollection,
      queries: [Query.limit(100)],
    );

    final distribution = <String, int>{};
    for (final doc in result.documents) {
      final gender = doc.data['gender'] ?? 'other';
      distribution[gender] = (distribution[gender] ?? 0) + 1;
    }
    return distribution;
  }

  // ============================================================================
  // USER MANAGEMENT
  // ============================================================================

  /// List users with filters
  Future<List<AdminUserEntity>> listUsers({
    String? search,
    String? role,
    String? gender,
    bool? emailVerified,
    int? limit,
    int? offset,
  }) async {
    try {
      final queries = <String>[];

      if (search != null && search.isNotEmpty) {
        queries.add(Query.search('email', search));
      }
      if (role != null) queries.add(Query.equal('role', [role]));
      if (emailVerified != null) {
        queries.add(Query.equal('emailVerified', [emailVerified]));
      }

      queries.add(Query.limit(limit ?? 25));
      queries.add(Query.offset(offset ?? 0));
      queries.add(Query.orderDesc('\$createdAt'));

      final usersResult = await _databases.listDocuments(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.usersCollection,
        queries: queries,
      );

      final users = <AdminUserEntity>[];
      for (final doc in usersResult.documents) {
        // Try to get profile data for this user. In this app the profile
        // document ID matches the user ID, so load it directly.
        String displayName = '';
        String userGender = '';
        String countryCode = '';
        String city = '';
        String? photoUrl;

        try {
          final profileDoc = await _databases.getDocument(
            databaseId: AppwriteConfig.databaseId,
            collectionId: AppwriteConfig.profilesCollection,
            documentId: doc.$id,
          );
          displayName = profileDoc.data['displayName'] ??
              profileDoc.data['display_name'] ??
              '';
          userGender = profileDoc.data['gender'] ?? '';
          countryCode = profileDoc.data['countryCode'] ??
              profileDoc.data['country_code'] ??
              '';
          city = profileDoc.data['city'] ?? '';
          final avatarUrl = profileDoc.data['avatarUrl'];
          if (avatarUrl is String && avatarUrl.isNotEmpty) {
            photoUrl = avatarUrl;
          }
          if (photoUrl == null) {
            final photos = profileDoc.data['photos'];
            if (photos is List && photos.isNotEmpty) {
              photoUrl = photos.first;
            }
          }
        } catch (_) {}

        users.add(AdminUserEntity(
          id: doc.$id,
          email: doc.data['email'] ?? '',
          displayName: displayName,
          gender: userGender,
          role: doc.data['role'] ?? 'free',
          countryCode: countryCode,
          city: city,
          emailVerified: doc.data['emailVerified'] ?? false,
          status: doc.data['status'] ?? 'active',
          createdAt: DateTime.tryParse(doc.$createdAt) ?? DateTime.now(),
          photoUrl: photoUrl,
        ));
      }

      return users;
    } on AppwriteException catch (e) {
      AppLogger.e('Failed to list users', error: e);
      rethrow;
    }
  }

  /// Get total user count
  Future<int> getTotalUserCount({String? search, String? role}) async {
    final queries = <String>[];
    if (search != null && search.isNotEmpty) {
      queries.add(Query.search('email', search));
    }
    if (role != null) queries.add(Query.equal('role', [role]));
    queries.add(Query.limit(1));

    final result = await _databases.listDocuments(
      databaseId: AppwriteConfig.databaseId,
      collectionId: AppwriteConfig.usersCollection,
      queries: queries,
    );
    return result.total;
  }

  /// Ban a user
  Future<void> banUser(String userId, String reason) async {
    try {
      await _databases.updateDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.usersCollection,
        documentId: userId,
        data: {
          'status': 'banned',
          'banReason': reason,
          'bannedAt': DateTime.now().toIso8601String(),
        },
      );
    } on AppwriteException catch (e) {
      AppLogger.e('Failed to ban user', error: e);
      rethrow;
    }
  }

  /// Change user role
  Future<void> changeUserRole(String userId, String newRole) async {
    try {
      await _databases.updateDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.usersCollection,
        documentId: userId,
        data: {'role': newRole},
      );
    } on AppwriteException catch (e) {
      AppLogger.e('Failed to change user role', error: e);
      rethrow;
    }
  }

  /// Verify email manually
  Future<void> verifyEmailManually(String userId) async {
    try {
      await _databases.updateDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.usersCollection,
        documentId: userId,
        data: {'emailVerified': true},
      );
    } on AppwriteException catch (e) {
      AppLogger.e('Failed to verify email manually', error: e);
      rethrow;
    }
  }

  /// Activate a banned user
  Future<void> activateUser(String userId) async {
    try {
      await _databases.updateDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.usersCollection,
        documentId: userId,
        data: {
          'status': 'active',
          'banReason': null,
          'bannedAt': null,
        },
      );
    } on AppwriteException catch (e) {
      AppLogger.e('Failed to activate user', error: e);
      rethrow;
    }
  }

  // ============================================================================
  // NEWSLETTER MANAGEMENT
  // ============================================================================

  /// List newsletters
  Future<List<NewsletterEntity>> listNewsletters({
    String? status,
    int? limit,
    int? offset,
  }) async {
    try {
      final queries = <String>[];
      if (status != null) queries.add(Query.equal('status', [status]));
      queries.add(Query.limit(limit ?? 25));
      queries.add(Query.offset(offset ?? 0));
      queries.add(Query.orderDesc('\$createdAt'));

      final result = await _databases.listDocuments(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.newslettersCollection,
        queries: queries,
      );

      return result.documents.map((doc) => NewsletterEntity(
        id: doc.$id,
        title: doc.data['title'] ?? '',
        content: doc.data['content'] ?? '',
        status: doc.data['status'] ?? 'draft',
        segmentRules: doc.data['segmentRules'],
        scheduledAt: doc.data['scheduledAt'] != null
            ? DateTime.tryParse(doc.data['scheduledAt'])
            : null,
        sentAt: doc.data['sentAt'] != null
            ? DateTime.tryParse(doc.data['sentAt'])
            : null,
        recipientCount: doc.data['recipientCount'] ?? 0,
        createdBy: doc.data['createdBy'] ?? '',
        createdAt: DateTime.tryParse(doc.$createdAt) ?? DateTime.now(),
      )).toList();
    } on AppwriteException catch (e) {
      AppLogger.e('Failed to list newsletters', error: e);
      rethrow;
    }
  }

  /// Create newsletter
  Future<NewsletterEntity> createNewsletter({
    required String title,
    required String content,
    String? segmentRules,
    required String createdBy,
  }) async {
    try {
      final doc = await _databases.createDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.newslettersCollection,
        documentId: ID.unique(),
        data: {
          'title': title,
          'content': content,
          'status': 'draft',
          'segmentRules': segmentRules,
          'recipientCount': 0,
          'createdBy': createdBy,
        },
      );

      return NewsletterEntity(
        id: doc.$id,
        title: title,
        content: content,
        status: 'draft',
        segmentRules: segmentRules,
        createdBy: createdBy,
        createdAt: DateTime.now(),
      );
    } on AppwriteException catch (e) {
      AppLogger.e('Failed to create newsletter', error: e);
      rethrow;
    }
  }

  /// Update newsletter
  Future<void> updateNewsletter({
    required String id,
    String? title,
    String? content,
    String? status,
    String? segmentRules,
  }) async {
    try {
      final data = <String, dynamic>{};
      if (title != null) data['title'] = title;
      if (content != null) data['content'] = content;
      if (status != null) data['status'] = status;
      if (segmentRules != null) data['segmentRules'] = segmentRules;

      await _databases.updateDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.newslettersCollection,
        documentId: id,
        data: data,
      );
    } on AppwriteException catch (e) {
      AppLogger.e('Failed to update newsletter', error: e);
      rethrow;
    }
  }

  /// Send newsletter (mark as sent)
  Future<void> sendNewsletter(String id, int recipientCount) async {
    try {
      await _databases.updateDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.newslettersCollection,
        documentId: id,
        data: {
          'status': 'sent',
          'sentAt': DateTime.now().toIso8601String(),
          'recipientCount': recipientCount,
        },
      );
    } on AppwriteException catch (e) {
      AppLogger.e('Failed to send newsletter', error: e);
      rethrow;
    }
  }

  /// Get users matching segment rules for newsletter
  Future<List<String>> getNewsletterRecipients(String? segmentRules) async {
    try {
      final queries = <String>[Query.limit(1000)];
      queries.add(Query.equal('emailVerified', [true]));

      // Parse segment rules (simple JSON with gender, role, country filters)
      // TODO: Parse JSON segment rules for advanced filtering

      final result = await _databases.listDocuments(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.usersCollection,
        queries: queries,
      );

      return result.documents
          .map((doc) => doc.data['email'] as String?)
          .where((email) => email != null)
          .cast<String>()
          .toList();
    } on AppwriteException catch (e) {
      AppLogger.e('Failed to get newsletter recipients', error: e);
      rethrow;
    }
  }

  // ============================================================================
  // EMAIL TEMPLATES
  // ============================================================================

  /// List email templates
  Future<List<EmailTemplateEntity>> listEmailTemplates() async {
    try {
      final result = await _databases.listDocuments(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.emailTemplatesCollection,
        queries: [Query.limit(100)],
      );

      return result.documents.map((doc) => EmailTemplateEntity(
        id: doc.$id,
        name: doc.data['name'] ?? '',
        slug: doc.data['slug'] ?? '',
        subject: doc.data['subject'] ?? '',
        bodyHtml: doc.data['bodyHtml'] ?? '',
        bodyText: doc.data['bodyText'],
        variables: doc.data['variables'] != null
            ? List<String>.from(doc.data['variables'])
            : [],
        isSystem: doc.data['isSystem'] ?? false,
        createdAt: DateTime.tryParse(doc.$createdAt) ??
            DateTime.now(),
        updatedAt: doc.data['updatedAt'] != null
            ? DateTime.tryParse(doc.data['updatedAt'])
            : null,
      )).toList();
    } on AppwriteException catch (e) {
      AppLogger.e('Failed to list email templates', error: e);
      rethrow;
    }
  }

  /// Update email template
  Future<void> updateEmailTemplate({
    required String id,
    String? subject,
    String? bodyHtml,
    String? bodyText,
  }) async {
    try {
      final data = <String, dynamic>{};
      if (subject != null) data['subject'] = subject;
      if (bodyHtml != null) data['bodyHtml'] = bodyHtml;
      if (bodyText != null) data['bodyText'] = bodyText;

      await _databases.updateDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.emailTemplatesCollection,
        documentId: id,
        data: data,
      );
    } on AppwriteException catch (e) {
      AppLogger.e('Failed to update email template', error: e);
      rethrow;
    }
  }

  // ============================================================================
  // HEIGHT VERIFICATION MANAGEMENT
  // ============================================================================

  /// List verifications with optional status filter
  Future<List<HeightVerificationEntity>> listVerifications({
    HeightVerificationStatus? status,
    int? limit,
    int? offset,
  }) async {
    try {
      final queries = <String>[];
      if (status != null) {
        queries.add(Query.equal('status', [status.name]));
      }
      queries.add(Query.limit(limit ?? 25));
      queries.add(Query.offset(offset ?? 0));
      queries.add(Query.orderDesc('submittedAt'));

      final result = await _databases.listDocuments(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.verificationsCollection,
        queries: queries,
      );

      return result.documents.map((doc) => HeightVerificationEntity(
        id: doc.$id,
        userId: doc.data['userId'] ?? '',
        claimedHeightCm: doc.data['claimedHeightCm'] ?? 0,
        photoUrl: doc.data['photoUrl'] as String?,
        status: HeightVerificationStatus.values.firstWhere(
          (e) => e.name == doc.data['status'],
          orElse: () => HeightVerificationStatus.pending,
        ),
        submittedAt: doc.data['submittedAt'] != null
            ? DateTime.tryParse(doc.data['submittedAt'])
            : null,
        reviewedAt: doc.data['reviewedAt'] != null
            ? DateTime.tryParse(doc.data['reviewedAt'])
            : null,
        reviewNote: doc.data['reviewNote'] as String?,
        rejectionReason: doc.data['rejectionReason'] as String?,
      )).toList();
    } on AppwriteException catch (e) {
      AppLogger.e('Failed to list verifications', error: e);
      rethrow;
    }
  }

  /// Get total verification count
  Future<int> getVerificationCount({HeightVerificationStatus? status}) async {
    final queries = <String>[];
    if (status != null) {
      queries.add(Query.equal('status', [status.name]));
    }
    queries.add(Query.limit(1));

    final result = await _databases.listDocuments(
      databaseId: AppwriteConfig.databaseId,
      collectionId: AppwriteConfig.verificationsCollection,
      queries: queries,
    );
    return result.total;
  }

  /// Approve a verification (also flips heightVerified=true on the profile).
  Future<void> approveVerification({
    required String verificationId,
    required String userId,
    String? reviewNote,
  }) async {
    try {
      final data = <String, dynamic>{
        'status': HeightVerificationStatus.verified.name,
        'reviewedAt': DateTime.now().toIso8601String(),
      };
      if (reviewNote != null) data['reviewNote'] = reviewNote;

      await _databases.updateDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.verificationsCollection,
        documentId: verificationId,
        data: data,
      );

      // Flip the profile's verified flag so the badge shows everywhere.
      if (userId.isNotEmpty) {
        await _databases.updateDocument(
          databaseId: AppwriteConfig.databaseId,
          collectionId: AppwriteConfig.profilesCollection,
          documentId: userId,
          data: {'heightVerified': true},
        );
      }
    } on AppwriteException catch (e) {
      AppLogger.e('Failed to approve verification', error: e);
      rethrow;
    }
  }

  /// Reject a verification (also clears heightVerified on the profile).
  Future<void> rejectVerification({
    required String verificationId,
    required String userId,
    required String rejectionReason,
  }) async {
    try {
      await _databases.updateDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.verificationsCollection,
        documentId: verificationId,
        data: {
          'status': HeightVerificationStatus.rejected.name,
          'rejectionReason': rejectionReason,
          'reviewedAt': DateTime.now().toIso8601String(),
        },
      );
      if (userId.isNotEmpty) {
        await _databases.updateDocument(
          databaseId: AppwriteConfig.databaseId,
          collectionId: AppwriteConfig.profilesCollection,
          documentId: userId,
          data: {'heightVerified': false},
        );
      }
    } on AppwriteException catch (e) {
      AppLogger.e('Failed to reject verification', error: e);
      rethrow;
    }
  }

  /// Mark verification as under review
  Future<void> markUnderReview(String verificationId) async {
    try {
      await _databases.updateDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.verificationsCollection,
        documentId: verificationId,
        data: {
          'status': HeightVerificationStatus.underReview.name,
        },
      );
    } on AppwriteException catch (e) {
      AppLogger.e('Failed to mark verification under review', error: e);
      rethrow;
    }
  }
}
