import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appwrite/appwrite.dart';
import 'package:tall_us/core/appwrite/appwrite_client.dart';
import 'package:tall_us/features/message/data/datasources/message_remote_datasource.dart';
import 'package:tall_us/features/message/presentation/providers/message_notifier.dart';
import 'package:tall_us/features/message/presentation/providers/message_state.dart';

/// Provider for MessageRemoteDataSource
final messageRemoteDataSourceProvider = Provider<MessageRemoteDataSource>((ref) {
  final databases = Databases(ref.read(appwriteClientProvider));
  final realtime = Realtime(ref.read(appwriteClientProvider));
  return MessageRemoteDataSource(
    databases: databases,
    realtime: realtime,
  );
});

/// Provider for MessageNotifier (scoped to match ID)
final messageNotifierProvider = StateNotifierProvider.family<MessageNotifier, MessageState, String>((ref, matchId) {
  final dataSource = ref.read(messageRemoteDataSourceProvider);
  final notifier = MessageNotifier(dataSource);

  // Load messages for this match
  ref.onDispose(() {
    notifier.unsubscribe();
  });

  return notifier;
});
