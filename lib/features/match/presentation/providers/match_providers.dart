import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appwrite/appwrite.dart';
import 'package:tall_us/core/appwrite/appwrite_client.dart';
import 'package:tall_us/features/match/data/datasources/match_remote_datasource.dart';
import 'package:tall_us/features/match/presentation/providers/match_notifier.dart';
import 'package:tall_us/features/match/presentation/providers/match_state.dart';

/// Provider for MatchesNotifier
final matchesNotifierProvider =
    StateNotifierProvider<MatchesNotifier, MatchState>((ref) {
  final databases = Databases(ref.read(appwriteClientProvider));
  final dataSource = MatchRemoteDataSource(databases: databases);
  return MatchesNotifier(dataSource);
});
