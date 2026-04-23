import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:tall_us/core/theme/app_theme.dart';
import 'package:tall_us/features/message/domain/entities/message_entity.dart';

/// Enhanced message bubble supporting text, images, GIFs, reactions, and replies
class RichMessageBubble extends StatelessWidget {
  final MessageEntity message;
  final String currentUserId;
  final VoidCallback? onReply;
  final VoidCallback? onReact;
  final VoidCallback? onImageTap;

  const RichMessageBubble({
    super.key,
    required this.message,
    required this.currentUserId,
    this.onReply,
    this.onReact,
    this.onImageTap,
  });

  @override
  Widget build(BuildContext context) {
    final isFromMe = message.isFromUser(currentUserId);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Column(
        crossAxisAlignment:
            isFromMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          // Reply context
          if (message.replyTo != null) _buildReplyContext(isFromMe),

          // Main message content
          Row(
            mainAxisAlignment:
                isFromMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.7,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isFromMe
                        ? [
                            AppTheme.bordeaux,
                            AppTheme.bordeaux.withValues(alpha: 0.8),
                          ]
                        : [
                            Colors.white,
                            Colors.white.withValues(alpha: 0.95),
                          ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Media content
                    if (message.type == MessageType.image &&
                        message.mediaUrl != null)
                      _buildImageContent(),
                    if (message.type == MessageType.gif &&
                        message.mediaUrl != null)
                      _buildGifContent(),
                    if (message.type == MessageType.video &&
                        message.mediaUrl != null)
                      _buildVideoContent(),

                    // Text content
                    if (message.content.isNotEmpty ||
                        message.type == MessageType.text)
                      _buildTextContent(isFromMe),

                    // Duration for audio/video
                    if (message.duration != null &&
                        (message.type == MessageType.audio ||
                            message.type == MessageType.video))
                      _buildDurationIndicator(),

                    // Timestamp and read status
                    _buildMessageMeta(isFromMe),
                  ],
                ),
              ),
            ],
          ),

          // Reactions
          if (message.reactions != null && message.reactions!.isNotEmpty)
            _buildReactions(isFromMe),

          // Action buttons (reply, react)
          _buildActionButtons(isFromMe),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).slideBegin(
          offset: const Offset(0, 0.1),
          duration: 300.ms,
        );
  }

  Widget _buildReplyContext(bool isFromMe) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 4,
            height: 40,
            decoration: BoxDecoration(
              color: isFromMe
                  ? AppTheme.bordeaux.withValues(alpha: 0.5)
                  : AppTheme.gray400,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message.replyTo!.senderName,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: isFromMe
                        ? AppTheme.bordeaux.withValues(alpha: 0.7)
                        : AppTheme.gray600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  message.replyTo!.content,
                  style: TextStyle(
                    fontSize: 12,
                    color: isFromMe
                        ? AppTheme.bordeaux.withValues(alpha: 0.9)
                        : AppTheme.gray700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageContent() {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
      child: GestureDetector(
        onTap: onImageTap,
        child: Image.network(
          message.mediaUrl!,
          width: double.infinity,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              height: 200,
              color: AppTheme.gray200,
              child: Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                  color: AppTheme.bordeaux,
                ),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return Container(
              height: 200,
              color: AppTheme.gray200,
              child: const Center(
                child:
                    Icon(Icons.broken_image, size: 48, color: AppTheme.gray500),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildGifContent() {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
      child: Stack(
        children: [
          Image.network(
            message.mediaUrl!,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                height: 200,
                color: AppTheme.gray200,
                child: const Center(
                  child: Icon(Icons.gif, size: 48, color: AppTheme.gray500),
                ),
              );
            },
          ),
          Positioned(
            top: 8,
            left: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'GIF',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoContent() {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
      child: Stack(
        children: [
          Container(
            height: 200,
            color: AppTheme.gray900,
            child: Center(
              child: Icon(
                Icons.play_circle_outline,
                size: 64,
                color: AppTheme.bordeaux,
              ),
            ),
          ),
          if (message.duration != null)
            Positioned(
              bottom: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  _formatDuration(message.duration!),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTextContent(bool isFromMe) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Text(
        message.content,
        style: TextStyle(
          fontSize: 16,
          color: isFromMe ? Colors.white : AppTheme.navy,
          height: 1.4,
        ),
      ),
    );
  }

  Widget _buildDurationIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Icon(
            Icons.timer,
            size: 14,
            color: Colors.white.withValues(alpha: 0.7),
          ),
          const SizedBox(width: 4),
          Text(
            _formatDuration(message.duration!),
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageMeta(bool isFromMe) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 4, 12, 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _formatTime(message.createdAt),
            style: TextStyle(
              fontSize: 10,
              color: isFromMe
                  ? Colors.white.withValues(alpha: 0.7)
                  : AppTheme.gray500,
            ),
          ),
          if (isFromMe) ...[
            const SizedBox(width: 4),
            Icon(
              message.isRead ? Icons.done_all : Icons.done,
              size: 14,
              color: message.isRead
                  ? Colors.white.withValues(alpha: 0.9)
                  : Colors.white.withValues(alpha: 0.5),
            ),
          ],
          if (message.isPriority) ...[
            const SizedBox(width: 4),
            Icon(
              Icons.star,
              size: 12,
              color: AppTheme.gold,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildReactions(bool isFromMe) {
    return Transform.translate(
      offset: Offset(isFromMe ? -8 : 8, 0),
      child: Container(
        margin: const EdgeInsets.only(top: 2),
        child: Wrap(
          spacing: 4,
          children: message.reactions!
              .map((reaction) => Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: Text(
                      reaction.emoji,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }

  Widget _buildActionButtons(bool isFromMe) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        mainAxisAlignment:
            isFromMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: onReact,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: const Icon(
                Icons.add_reaction_outlined,
                size: 18,
                color: AppTheme.gray500,
              ),
            ),
          ),
          GestureDetector(
            onTap: onReply,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: const Icon(
                Icons.reply,
                size: 18,
                color: AppTheme.gray500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      'Now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d';
    } else {
      return '${dateTime.day}/${dateTime.month}';
    }
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}
