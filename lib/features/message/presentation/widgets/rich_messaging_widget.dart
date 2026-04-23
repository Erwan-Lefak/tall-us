import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:tall_us/core/theme/app_theme.dart';

/// Message types
enum MessageType {
  text,
  image,
  gif,
  audio,
  video,
  reaction,
  reply,
  location,
  system,
}

/// Rich message entity
class RichMessage {
  final String id;
  final String senderId;
  final MessageType type;
  final String? content;
  final String? mediaUrl;
  final String? thumbnailUrl;
  final String? repliedToMessageId;
  final DateTime timestamp;
  final bool isSeen;
  final Map<String, String>? metadata; // For GIF info, location, etc.

  const RichMessage({
    required this.id,
    required this.senderId,
    required this.type,
    this.content,
    this.mediaUrl,
    this.thumbnailUrl,
    this.repliedToMessageId,
    required this.timestamp,
    this.isSeen = false,
    this.metadata,
  });

  RichMessage copyWith({
    String? id,
    String? senderId,
    MessageType? type,
    String? content,
    String? mediaUrl,
    String? thumbnailUrl,
    String? repliedToMessageId,
    DateTime? timestamp,
    bool? isSeen,
    Map<String, String>? metadata,
  }) {
    return RichMessage(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      type: type ?? this.type,
      content: content ?? this.content,
      mediaUrl: mediaUrl ?? this.mediaUrl,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      repliedToMessageId: repliedToMessageId ?? this.repliedToMessageId,
      timestamp: timestamp ?? this.timestamp,
      isSeen: isSeen ?? this.isSeen,
      metadata: metadata ?? this.metadata,
    );
  }
}

/// Message reaction
class MessageReaction {
  final String emoji;
  final String userId;
  final DateTime timestamp;

  const MessageReaction({
    required this.emoji,
    required this.userId,
    required this.timestamp,
  });
}

/// Rich messaging interface with all advanced features
class RichMessagingWidget extends StatefulWidget {
  final String matchId;
  final String otherUserId;
  final List<RichMessage> messages;
  final Function(RichMessage) onSendMessage;
  final Function(String, MessageReaction?) onReact;

  const RichMessagingWidget({
    super.key,
    required this.matchId,
    required this.otherUserId,
    required this.messages,
    required this.onSendMessage,
    required this.onReact,
  });

  @override
  State<RichMessagingWidget> createState() => _RichMessagingWidgetState();
}

class _RichMessagingWidgetState extends State<RichMessagingWidget> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String _replyingTo = '';

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendTextMessage() {
    if (_messageController.text.trim().isEmpty) return;

    final message = RichMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: 'currentUserId',
      type: _replyingTo.isNotEmpty ? MessageType.reply : MessageType.text,
      content: _messageController.text.trim(),
      repliedToMessageId: _replyingTo.isNotEmpty ? _replyingTo : null,
      timestamp: DateTime.now(),
    );

    widget.onSendMessage(message);
    _messageController.clear();
    setState(() => _replyingTo = '');
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

  void _showReactionPicker(String messageId) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _ReactionPicker(
        onReactionSelected: (emoji) {
          Navigator.pop(context);
          widget.onReact(
              messageId,
              MessageReaction(
                emoji: emoji,
                userId: 'currentUserId',
                timestamp: DateTime.now(),
              ));
        },
        onRemove: () {
          Navigator.pop(context);
          widget.onReact(messageId, null);
        },
      ),
    );
  }

  void _startReply(String messageId) {
    setState(() => _replyingTo = messageId);
    _messageController.focus();
  }

  void _cancelReply() {
    setState(() => _replyingTo = '');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Messages list
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(16),
            itemCount: widget.messages.length,
            itemBuilder: (context, index) {
              final message = widget.messages[index];
              final isMe = message.senderId != widget.otherUserId;

              return _RichMessageBubble(
                message: message,
                isMe: isMe,
                onReact: () => _showReactionPicker(message.id),
                onReply: () => _startReply(message.id),
              );
            },
          ),
        ),

        // Reply preview
        if (_replyingTo.isNotEmpty)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppTheme.bordeaux.withValues(alpha: 0.1),
              border: Border(
                left: BorderSide(
                  color: AppTheme.bordeaux,
                  width: 4,
                ),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.reply,
                  color: AppTheme.bordeaux,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Répondre au message',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.bordeaux,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _cancelReply,
                  icon: const Icon(Icons.close, size: 16),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),

        // Message input
        _MessageInputBar(
          controller: _messageController,
          onSend: _sendTextMessage,
          onImageSend: () => _showMediaPicker(MessageType.image),
          onGifSend: () => _showGifPicker(),
          onAudioSend: () => _showAudioRecorder(),
        ),
      ],
    );
  }

  void _showMediaPicker(MessageType type) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _MediaPickerSheet(
        type: type,
        onMediaSelected: (file) {
          // Handle media selection
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showGifPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _GifPickerSheet(
        onGifSelected: (gifUrl, metadata) {
          final message = RichMessage(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            senderId: 'currentUserId',
            type: MessageType.gif,
            mediaUrl: gifUrl,
            timestamp: DateTime.now(),
            metadata: metadata,
          );
          widget.onSendMessage(message);
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showAudioRecorder() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _AudioRecorderSheet(
        onAudioSent: (audioPath) {
          final message = RichMessage(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            senderId: 'currentUserId',
            type: MessageType.audio,
            mediaUrl: audioPath,
            timestamp: DateTime.now(),
          );
          widget.onSendMessage(message);
          Navigator.pop(context);
        },
      ),
    );
  }
}

/// Rich message bubble with reactions and replies
class _RichMessageBubble extends StatelessWidget {
  final RichMessage message;
  final bool isMe;
  final VoidCallback onReact;
  final VoidCallback onReply;

  const _RichMessageBubble({
    required this.message,
    required this.isMe,
    required this.onReact,
    required this.onReply,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: onReact,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        child: Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            // Reply preview
            if (message.repliedToMessageId != null)
              Container(
                margin: const EdgeInsets.only(bottom: 4),
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.gray100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.reply,
                      size: 12,
                      color: AppTheme.gray600,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Message original',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppTheme.gray600,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),

            // Main message bubble
            Row(
              mainAxisAlignment:
                  isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (!isMe) ...[
                  const CircleAvatar(
                    radius: 16,
                    backgroundColor: AppTheme.navy,
                    child: Icon(Icons.person, color: Colors.white, size: 18),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Message content based on type
                        _buildMessageContent(),

                        // Timestamp
                        const SizedBox(height: 4),
                        Text(
                          _formatTimestamp(message.timestamp),
                          style: TextStyle(
                            fontSize: 10,
                            color: isMe
                                ? Colors.white.withValues(alpha: 0.7)
                                : AppTheme.gray500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (isMe) ...[
                  const SizedBox(width: 8),
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: AppTheme.bordeaux,
                    child:
                        const Icon(Icons.person, color: Colors.white, size: 18),
                  ),
                ],
              ],
            ),

            // Reactions
            const SizedBox(height: 4),
            if (!isMe)
              IconButton(
                onPressed: onReply,
                icon: const Icon(Icons.reply, size: 16),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                color: AppTheme.gray400,
              ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 200.ms).slideX();
  }

  Widget _buildMessageContent() {
    switch (message.type) {
      case MessageType.text:
      case MessageType.reply:
        return Text(
          message.content ?? '',
          style: TextStyle(
            color: isMe ? Colors.white : AppTheme.navy,
            fontSize: 16,
          ),
        );

      case MessageType.image:
        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            message.mediaUrl ?? '',
            width: 200,
            fit: BoxFit.cover,
          ),
        );

      case MessageType.gif:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                message.mediaUrl ?? '',
                width: 200,
                height: 150,
                fit: BoxFit.cover,
              ),
            ),
            if (message.metadata?['title'] != null) ...[
              const SizedBox(height: 4),
              Text(
                message.metadata!['title']!,
                style: TextStyle(
                  fontSize: 11,
                  color: isMe ? Colors.white70 : AppTheme.gray600,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ],
        );

      case MessageType.audio:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.play_circle_outline,
              color: isMe ? Colors.white : AppTheme.navy,
              size: 32,
            ),
            const SizedBox(width: 8),
            Container(
              width: 100,
              height: 30,
              decoration: BoxDecoration(
                color: isMe
                    ? Colors.white.withValues(alpha: 0.3)
                    : AppTheme.gray200,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Center(
                child: Text(
                  '0:15',
                  style: TextStyle(
                    fontSize: 11,
                    color: isMe ? Colors.white : AppTheme.navy,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        );

      case MessageType.video:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    message.thumbnailUrl ?? '',
                    width: 200,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned.fill(
                  child: Center(
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.5),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );

      case MessageType.reaction:
        return Text(
          message.content ?? '',
          style: TextStyle(
            fontSize: 32,
            color: isMe ? Colors.white : AppTheme.navy,
          ),
        );

      default:
        return const SizedBox.shrink();
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'À l\'instant';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h';
    } else {
      return '${difference.inDays}j';
    }
  }
}

/// Message input bar with media options
class _MessageInputBar extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final VoidCallback onImageSend;
  final VoidCallback onGifSend;
  final VoidCallback onAudioSend;

  const _MessageInputBar({
    required this.controller,
    required this.onSend,
    required this.onImageSend,
    required this.onGifSend,
    required this.onAudioSend,
  });

  @override
  State<_MessageInputBar> createState() => _MessageInputBarState();
}

class _MessageInputBarState extends State<_MessageInputBar> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
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
        child: Column(
          children: [
            // Media options (expanded)
            if (_isExpanded)
              Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.gray100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _MediaOption(
                      icon: Icons.image,
                      label: 'Photo',
                      color: AppTheme.bordeaux,
                      onTap: () {
                        widget.onImageSend();
                        setState(() => _isExpanded = false);
                      },
                    ),
                    _MediaOption(
                      icon: Icons.gif,
                      label: 'GIF',
                      color: AppTheme.gold,
                      onTap: () {
                        widget.onGifSend();
                        setState(() => _isExpanded = false);
                      },
                    ),
                    _MediaOption(
                      icon: Icons.mic,
                      label: 'Audio',
                      color: AppTheme.success,
                      onTap: () {
                        widget.onAudioSend();
                        setState(() => _isExpanded = false);
                      },
                    ),
                  ],
                ),
              ),

            // Input row
            Row(
              children: [
                // Expand button
                IconButton(
                  onPressed: () {
                    setState(() => _isExpanded = !_isExpanded);
                  },
                  icon: Icon(
                    _isExpanded ? Icons.expand_less : Icons.add_circle_outline,
                    color: AppTheme.bordeaux,
                    size: 28,
                  ),
                ),

                // Text field
                Expanded(
                  child: TextField(
                    controller: widget.controller,
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
                    onSubmitted: (_) => widget.onSend(),
                  ),
                ),

                // Send button
                IconButton(
                  onPressed: widget.onSend,
                  icon: const Icon(
                    Icons.send,
                    color: AppTheme.bordeaux,
                    size: 24,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Media option button
class _MediaOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _MediaOption({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppTheme.navy,
            ),
          ),
        ],
      ),
    );
  }
}

/// Reaction picker bottom sheet
class _ReactionPicker extends StatelessWidget {
  final Function(String) onReactionSelected;
  final VoidCallback onRemove;

  const _ReactionPicker({
    required this.onReactionSelected,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final reactions = ['❤️', '😂', '😮', '😢', '😡', '👍', '🔥', '🎉'];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Réagir',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppTheme.navy,
            ),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
            ),
            itemCount: reactions.length,
            itemBuilder: (context, index) {
              final emoji = reactions[index];
              return GestureDetector(
                onTap: () => onReactionSelected(emoji),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppTheme.gray100,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      emoji,
                      style: const TextStyle(fontSize: 32),
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: onRemove,
            child: const Text(
              'Supprimer la réaction',
              style: TextStyle(
                color: AppTheme.gray600,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// GIF picker sheet (placeholder)
class _GifPickerSheet extends StatelessWidget {
  final Function(String, Map<String, String>) onGifSelected;

  const _GifPickerSheet({required this.onGifSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: 'Rechercher des GIFs...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 1,
              ),
              itemCount: 9,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    onGifSelected(
                      'https://media.giphy.com/media/gif${index + 1}/giphy.gif',
                      {'title': 'Funny GIF ${index + 1}'},
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppTheme.gray100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Icon(Icons.gif, size: 32, color: AppTheme.gray400),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Media picker sheet
class _MediaPickerSheet extends StatelessWidget {
  final MessageType type;
  final Function(File) onMediaSelected;

  const _MediaPickerSheet({
    required this.type,
    required this.onMediaSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Prendre une photo'),
              onTap: () {
                // Handle camera
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choisir dans la galerie'),
              onTap: () {
                // Handle gallery
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// Audio recorder sheet
class _AudioRecorderSheet extends StatefulWidget {
  final Function(String) onAudioSent;

  const _AudioRecorderSheet({required this.onAudioSent});

  @override
  State<_AudioRecorderSheet> createState() => _AudioRecorderSheetState();
}

class _AudioRecorderSheetState extends State<_AudioRecorderSheet> {
  bool _isRecording = false;
  int _recordingDuration = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Enregistrement audio',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.navy,
              ),
            ),
            const SizedBox(height: 24),
            if (_isRecording) ...[
              Text(
                '${(_recordingDuration / 60).toStringAsFixed(0)}:${(_recordingDuration % 60).toString().padLeft(2, '0')}',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.bordeaux,
                ),
              ),
              const SizedBox(height: 16),
              const LinearProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppTheme.bordeaux),
              ),
            ],
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (!_isRecording)
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _isRecording = true;
                        _recordingDuration = 0;
                      });
                      // Simulate recording
                      Future.delayed(const Duration(seconds: 3), () {
                        if (mounted) {
                          setState(() => _isRecording = false);
                          widget.onAudioSent('audio_path.mp3');
                        }
                      });
                    },
                    icon: Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: AppTheme.bordeaux,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.mic,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                  )
                else
                  IconButton(
                    onPressed: () {
                      setState(() => _isRecording = false);
                    },
                    icon: Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: AppTheme.gray400,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.stop,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
