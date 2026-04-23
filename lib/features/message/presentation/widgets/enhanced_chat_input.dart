import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tall_us/core/theme/app_theme.dart';
import 'package:tall_us/features/message/domain/entities/message_entity.dart';

/// Enhanced chat input with media upload, GIF support, and reply functionality
class EnhancedChatInput extends StatefulWidget {
  final Function(String content) onSendMessage;
  final Function(String mediaUrl, MessageType type) onSendMedia;
  final Function(MessageReply reply) onReply;
  final MessageReply? replyTo;
  final VoidCallback onCancelReply;

  const EnhancedChatInput({
    super.key,
    required this.onSendMessage,
    required this.onSendMedia,
    required this.onReply,
    this.replyTo,
    required this.onCancelReply,
  });

  @override
  State<EnhancedChatInput> createState() => _EnhancedChatInputState();
}

class _EnhancedChatInputState extends State<EnhancedChatInput> {
  final TextEditingController _textController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();
  bool _isExpanded = false;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1920,
      maxHeight: 1920,
      imageQuality: 85,
    );

    if (image != null) {
      widget.onSendMedia(image.path, MessageType.image);
    }
  }

  Future<void> _takePhoto() async {
    final XFile? photo = await _imagePicker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1920,
      maxHeight: 1920,
      imageQuality: 85,
    );

    if (photo != null) {
      widget.onSendMedia(photo.path, MessageType.image);
    }
  }

  Future<void> _pickGif() async {
    // TODO: Integrate GIF picker (GIPHY/Tenor)
    // For now, just show a placeholder
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('GIF picker coming soon!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _sendMessage() {
    if (_textController.text.trim().isEmpty) return;

    widget.onSendMessage(_textController.text.trim());
    _textController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Column(
        children: [
          // Reply context
          if (widget.replyTo != null) _buildReplyContext(),

          // Input area
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                // Media button
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isExpanded = !_isExpanded;
                    });
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppTheme.gray100,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _isExpanded ? Icons.close : Icons.add,
                      color: AppTheme.navy,
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                // Text input
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: AppTheme.gray100,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: TextField(
                      controller: _textController,
                      decoration: const InputDecoration(
                        hintText: 'Écrivez votre message...',
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                          color: AppTheme.gray500,
                          fontSize: 16,
                        ),
                      ),
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppTheme.navy,
                      ),
                      maxLines: 5,
                      minLines: 1,
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                // Send button
                GestureDetector(
                  onTap: _sendMessage,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.bordeaux,
                          AppTheme.bordeaux.withValues(alpha: 0.8),
                        ],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Expanded media options
          if (_isExpanded)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildMediaOption(
                    icon: Icons.photo_library,
                    label: 'Galerie',
                    color: AppTheme.bordeaux,
                    onTap: _pickImage,
                  ),
                  _buildMediaOption(
                    icon: Icons.camera_alt,
                    label: 'Photo',
                    color: AppTheme.navy,
                    onTap: _takePhoto,
                  ),
                  _buildMediaOption(
                    icon: Icons.gif,
                    label: 'GIF',
                    color: AppTheme.purple,
                    onTap: _pickGif,
                  ),
                  _buildMediaOption(
                    icon: Icons.mic,
                    label: 'Audio',
                    color: AppTheme.teal,
                    onTap: () {
                      // TODO: Implement audio recording
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Audio recording coming soon!'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 200.ms).slideBegin(
                  offset: const Offset(0, -0.1),
                  duration: 200.ms,
                ),
        ],
      ),
    );
  }

  Widget _buildReplyContext() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.gray100,
        border: Border(
          left: BorderSide(
            color: AppTheme.bordeaux,
            width: 4,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Réponse à ${widget.replyTo!.senderName}',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.bordeaux,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  widget.replyTo!.content,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.gray700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: widget.onCancelReply,
            child: const Icon(
              Icons.close,
              size: 18,
              color: AppTheme.gray500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMediaOption({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
              border: Border.all(
                color: color.withValues(alpha: 0.3),
                width: 2,
              ),
            ),
            child: Icon(
              icon,
              color: color,
              size: 28,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppTheme.gray700,
            ),
          ),
        ],
      ),
    );
  }
}
