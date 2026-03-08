import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tall_us/core/theme/app_theme.dart';
import 'package:tall_us/core/utils/logger.dart';
import 'package:tall_us/features/auth/presentation/providers/auth_providers.dart';
import 'package:tall_us/features/message/domain/entities/message_entity.dart';
import 'package:tall_us/features/message/presentation/providers/message_providers.dart';

/// Chat screen for messaging matches
class ChatScreen extends ConsumerStatefulWidget {
  final String matchId;
  final String otherUserId;
  final String otherUserName;

  const ChatScreen({
    super.key,
    required this.matchId,
    required this.otherUserId,
    required this.otherUserName,
  });

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Load messages and subscribe to real-time updates
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(messageNotifierProvider(widget.matchId).notifier).loadMessages(widget.matchId);
      ref.read(messageNotifierProvider(widget.matchId).notifier).subscribeToMessages(widget.matchId);
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    // Unsubscribe when leaving chat
    ref.read(messageNotifierProvider(widget.matchId).notifier).unsubscribe();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    final content = _messageController.text.trim();
    _messageController.clear();

    final currentUser = ref.read(authenticatedUserProvider);
    if (currentUser == null) {
      AppLogger.e('User not authenticated, cannot send message');
      return;
    }

    await ref.read(messageNotifierProvider(widget.matchId).notifier).sendMessage(
      matchId: widget.matchId,
      senderId: currentUser.id,
      receiverId: widget.otherUserId,
      content: content,
    );

    // Scroll to bottom
    _scrollToBottom();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 100), () {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final messageState = ref.watch(messageNotifierProvider(widget.matchId));
    final currentUser = ref.watch(authenticatedUserProvider);

    return Scaffold(
      appBar: _buildAppBar(),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.bordeaux.withValues(alpha: 0.05),
              AppTheme.navy.withValues(alpha: 0.02),
            ],
          ),
        ),
        child: Column(
          children: [
            // Messages list
            Expanded(
              child: messageState.when(
                loading: () => const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(AppTheme.bordeaux),
                  ),
                ),
                loaded: (messages) => messages.isEmpty
                    ? _buildEmptyState()
                    : _buildMessagesList(messages, currentUser?.id ?? ''),
                error: (message) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: AppTheme.navy.withValues(alpha: 0.5),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Erreur de chargement',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.navy,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        message,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppTheme.navy.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                ),
                initial: () => const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(AppTheme.bordeaux),
                  ),
                ),
              ),
            ),

            // Message input
            _buildMessageInput(),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppTheme.navy),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Column(
        children: [
          Text(
            widget.otherUserName,
            style: const TextStyle(
              color: AppTheme.navy,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.more_vert, color: AppTheme.navy),
          onPressed: () {
            // TODO: Show options (unmatch, report, etc.)
          },
        ),
      ],
    );
  }

  Widget _buildMessagesList(List<MessageEntity> messages, String currentUserId) {
    // Scroll to bottom when new messages arrive
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        final isMe = message.isFromUser(currentUserId);

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isMe) ...[
                const CircleAvatar(
                  radius: 16,
                  backgroundColor: AppTheme.navy,
                  child: Icon(Icons.person, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: isMe ? AppTheme.bordeaux : Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(20),
                      topRight: const Radius.circular(20),
                      bottomLeft: Radius.circular(isMe ? 20 : 4),
                      bottomRight: Radius.circular(isMe ? 4 : 20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    message.content,
                    style: TextStyle(
                      color: isMe ? Colors.white : AppTheme.navy,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              if (isMe) ...[
                const SizedBox(width: 8),
                CircleAvatar(
                  radius: 16,
                  backgroundColor: AppTheme.bordeaux,
                  child: const Icon(Icons.person, color: Colors.white, size: 20),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Add attachment button
            IconButton(
              icon: Icon(
                Icons.add_circle_outline,
                color: AppTheme.bordeaux,
                size: 28,
              ),
              onPressed: () {
                // TODO: Add attachment (photo, etc.)
              },
            ),

            // Text field
            Expanded(
              child: TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: 'Écrivez votre message...',
                  hintStyle: TextStyle(
                    color: AppTheme.navy.withValues(alpha: 0.5),
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                ),
                textCapitalization: TextCapitalization.sentences,
                maxLines: null,
                onSubmitted: (_) => _sendMessage(),
              ),
            ),

            // Send button
            IconButton(
              icon: Icon(
                Icons.send,
                color: AppTheme.bordeaux,
                size: 24,
              ),
              onPressed: _sendMessage,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 80,
            color: AppTheme.navy.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 24),
          Text(
            'Envoyez un message pour briser la glace !',
            style: TextStyle(
              fontSize: 18,
              color: AppTheme.navy,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Soyez original, soyez vous-même',
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.navy.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}
