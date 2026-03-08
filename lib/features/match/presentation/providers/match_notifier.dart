import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tall_us/core/utils/logger.dart';
import 'package:tall_us/features/match/data/datasources/match_remote_datasource.dart';
import 'package:tall_us/features/match/presentation/providers/match_state.dart';

/// Notifier for matches state
class MatchesNotifier extends StateNotifier<MatchState> {
  final MatchRemoteDataSource dataSource;

  MatchesNotifier(this.dataSource) : super(const MatchState.initial());

  Future<void> loadMatches() async {
    state = const MatchState.loading();

    try {
      AppLogger.i('Loading matches...');

      // TODO: Get current user ID
      // For now, use a dummy ID
      final userId = 'current_user_id';

      final matches = await dataSource.getMatches(userId);

      AppLogger.i('Loaded ${matches.length} matches');

      if (matches.isEmpty) {
        state = const MatchState.loaded([]);
      } else {
        state = MatchState.loaded(matches);
      }
    } catch (e) {
      AppLogger.e('Failed to load matches', error: e);
      state = MatchState.error(e.toString());
    }
  }
}
