import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appwrite/appwrite.dart';
import 'package:tall_us/core/appwrite/appwrite_client.dart';
import 'package:tall_us/features/match/data/datasources/match_remote_datasource.dart';
import 'package:tall_us/features/match/domain/entities/match_entity.dart';
import 'package:tall_us/features/swipe/data/datasources/swipe_remote_datasource.dart';
import 'package:tall_us/features/swipe/data/repositories/swipe_repository_impl.dart';
import 'package:tall_us/features/swipe/domain/entities/swipe_entity.dart';
import 'package:tall_us/features/swipe/domain/repositories/swipe_repository.dart';
import 'package:tall_us/core/errors/failures.dart';

/// Provider for SwipeRemoteDataSource
final swipeRemoteDataSourceProvider = Provider<SwipeRemoteDataSource>((ref) {
  final databases = Databases(ref.read(appwriteClientProvider));
  return SwipeRemoteDataSource(databases: databases);
});

/// Provider for MatchRemoteDataSource
final matchRemoteDataSourceProvider = Provider<MatchRemoteDataSource>((ref) {
  final databases = Databases(ref.read(appwriteClientProvider));
  return MatchRemoteDataSource(databases: databases);
});

/// Provider for SwipeRepository
final swipeRepositoryProvider = Provider<SwipeRepository>((ref) {
  final remoteDataSource = ref.read(swipeRemoteDataSourceProvider);
  final databases = Databases(ref.read(appwriteClientProvider));
  final matchDataSource = ref.read(matchRemoteDataSourceProvider);
  return SwipeRepositoryImpl(
    remoteDataSource: remoteDataSource,
    databases: databases,
    matchDataSource: matchDataSource,
  );
});

/// Notifier for swipe state
class SwipeNotifier extends StateNotifier<SwipeState> {
  final SwipeRepository repository;

  SwipeNotifier(this.repository) : super(const SwipeState.initial());

  /// Perform a swipe action
  Future<void> performSwipe({
    required String swiperId,
    required String targetId,
    required SwipeAction action,
  }) async {
    state = const SwipeState.loading();

    final result = await repository.swipe(
      swiperId: swiperId,
      targetId: targetId,
      action: action,
    );

    result.fold(
      (failure) {
        state = SwipeState.error(failure.message);
      },
      (match) {
        if (match != null) {
          state = SwipeState.matched(match);
        } else {
          state = const SwipeState.success();
        }
      },
    );
  }

  /// Reset state to initial
  void reset() {
    state = const SwipeState.initial();
  }
}

/// Swipe state
class SwipeState {
  final bool isLoading;
  final MatchEntity? match;
  final String? error;

  const SwipeState._({
    this.isLoading = false,
    this.match,
    this.error,
  });

  const factory SwipeState.initial() = SwipeStateInitial;
  const factory SwipeState.loading() = SwipeStateLoading;
  const factory SwipeState.success() = SwipeStateSuccess;
  const factory SwipeState.matched(MatchEntity match) = SwipeStateMatched;
  const factory SwipeState.error(String error) = SwipeStateError;
}

class SwipeStateInitial extends SwipeState {
  const SwipeStateInitial() : super._();
}

class SwipeStateLoading extends SwipeState {
  const SwipeStateLoading() : super._(isLoading: true);
}

class SwipeStateSuccess extends SwipeState {
  const SwipeStateSuccess() : super._();
}

class SwipeStateMatched extends SwipeState {
  final MatchEntity matchEntity;

  const SwipeStateMatched(this.matchEntity) : super._(match: matchEntity);
}

class SwipeStateError extends SwipeState {
  final String errorMessage;

  const SwipeStateError(this.errorMessage) : super._(error: errorMessage);
}

/// Provider for SwipeNotifier
final swipeNotifierProvider =
    StateNotifierProvider<SwipeNotifier, SwipeState>((ref) {
  final repository = ref.read(swipeRepositoryProvider);
  return SwipeNotifier(repository);
});
