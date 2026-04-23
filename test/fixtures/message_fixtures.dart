import 'package:tall_us/features/message/domain/entities/rich_message_entities.dart';
import 'package:tall_us/features/social/domain/entities/social_entities.dart';

/// Test fixtures for messages and social features
///
/// Provides reusable test data across all tests
class MessageFixtures {
  /// Simple text message
  static RichMessage get textMessage {
    return RichMessage(
      id: 'msg_text_001',
      conversationId: 'conv_001',
      senderId: 'user_001',
      receiverId: 'user_002',
      type: MessageType.text,
      content: 'Salut ! Comment ça va ?',
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      isSeen: false,
    );
  }

  /// Image message
  static RichMessage get imageMessage {
    return RichMessage(
      id: 'msg_image_001',
      conversationId: 'conv_001',
      senderId: 'user_002',
      receiverId: 'user_001',
      type: MessageType.image,
      content: 'https://example.com/images/photo.jpg',
      timestamp: DateTime.now().subtract(const Duration(minutes: 2)),
      isSeen: false,
      metadata: {
        'width': 1920,
        'height': 1080,
      },
    );
  }

  /// GIF message
  static RichMessage get gifMessage {
    return RichMessage(
      id: 'msg_gif_001',
      conversationId: 'conv_001',
      senderId: 'user_001',
      receiverId: 'user_002',
      type: MessageType.gif,
      content: 'https://media.giphy.com/media/xyz/giphy.gif',
      timestamp: DateTime.now().subtract(const Duration(minutes: 1)),
      isSeen: true,
      metadata: {
        'previewUrl': 'https://media.giphy.com/media/xyz/200.gif',
      },
    );
  }

  /// Audio message
  static RichMessage get audioMessage {
    return RichMessage(
      id: 'msg_audio_001',
      conversationId: 'conv_001',
      senderId: 'user_002',
      receiverId: 'user_001',
      type: MessageType.audio,
      content: 'https://example.com/audio/voice_note.mp3',
      timestamp: DateTime.now(),
      isSeen: false,
      metadata: {
        'duration': 45, // seconds
      },
    );
  }

  /// Location message
  static RichMessage get locationMessage {
    return RichMessage(
      id: 'msg_location_001',
      conversationId: 'conv_001',
      senderId: 'user_001',
      receiverId: 'user_002',
      type: MessageType.location,
      content: '48.8566, 2.3522',
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      isSeen: true,
      metadata: {
        'latitude': 48.8566,
        'longitude': 2.3522,
        'address': 'Tour Eiffel, Paris',
      },
    );
  }

  /// Reply message
  static RichMessage get replyMessage {
    return RichMessage(
      id: 'msg_reply_001',
      conversationId: 'conv_001',
      senderId: 'user_002',
      receiverId: 'user_001',
      type: MessageType.reply,
      content: 'Oui bien sûr !',
      timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
      isSeen: true,
      repliedToMessageId: 'msg_text_001',
      repliedToContent: 'Salut ! On se voit ce soir ?',
    );
  }

  /// System message
  static RichMessage get systemMessage {
    return RichMessage(
      id: 'msg_system_001',
      conversationId: 'conv_001',
      senderId: 'system',
      receiverId: 'user_001',
      type: MessageType.system,
      content: 'Vous avez matché avec Marie ! 💕',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      isSeen: true,
      metadata: {
        'type': 'match',
        'matchedUserId': 'user_002',
      },
    );
  }

  /// List of messages for testing pagination
  static List<RichMessage> get messageList => [
    textMessage,
    imageMessage,
    gifMessage,
    audioMessage,
    locationMessage,
    replyMessage,
    systemMessage,
  ];

  /// Message reaction
  static MessageReaction get heartReaction {
    return MessageReaction(
      id: 'reaction_001',
      messageId: 'msg_text_001',
      userId: 'user_002',
      emoji: '❤️',
      timestamp: DateTime.now().subtract(const Duration(minutes: 4)),
    );
  }

  /// Message reaction with different emoji
  static MessageReaction get laughReaction {
    return MessageReaction(
      id: 'reaction_002',
      messageId: 'msg_text_001',
      userId: 'user_003',
      emoji: '😂',
      timestamp: DateTime.now().subtract(const Duration(minutes: 3)),
    );
  }

  /// Updated reaction (user changed emoji)
  static MessageReaction get updatedReaction {
    return MessageReaction(
      id: 'reaction_001',
      messageId: 'msg_text_001',
      userId: 'user_002',
      emoji: '🔥',
      timestamp: DateTime.now().subtract(const Duration(minutes: 2)),
    );
  }

  /// Conversation metadata
  static ConversationMetadata get conversationMetadata {
    return ConversationMetadata(
      conversationId: 'conv_001',
      participantIds: const ['user_001', 'user_002'],
      unreadCount: 2,
      lastMessageId: 'msg_audio_001',
      lastMessageContent: '🎤',
      lastMessageTimestamp: DateTime.now(),
      lastMessageSenderId: 'user_002',
      isMuted: false,
      isArchived: false,
      createdAt: DateTime.now().subtract(const Duration(days: 7)),
    );
  }

  /// Conversation metadata with no unread messages
  static ConversationMetadata get readConversationMetadata {
    return ConversationMetadata(
      conversationId: 'conv_002',
      participantIds: const ['user_001', 'user_003'],
      unreadCount: 0,
      lastMessageId: 'msg_reply_001',
      lastMessageContent: 'D\'accord !',
      lastMessageTimestamp: DateTime.now().subtract(const Duration(hours: 2)),
      lastMessageSenderId: 'user_001',
      isMuted: false,
      isArchived: false,
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
    );
  }
}

/// Test fixtures for social features
class SocialFixtures {
  /// Simple social event
  static SocialEvent get simpleEvent {
    final now = DateTime.now();
    return SocialEvent(
      id: 'event_simple_001',
      hostId: 'user_host_001',
      title: 'Afterwork Tall Us Paris',
      description: 'Venez rencontrer d\'autres personnes grandes !',
      location: 'Bar Le Central, Paris 11ème',
      eventDateTime: now.add(const Duration(days: 7)),
      maxAttendees: 20,
      currentAttendees: const [
        'user_host_001',
        'user_attendee_001',
        'user_attendee_002',
      ],
      interest: const ['Social', 'Rencontres'],
      price: 0.0,
      currency: 'EUR',
      createdAt: now.subtract(const Duration(days: 14)),
    );
  }

  /// Paid social event
  static SocialEvent get paidEvent {
    final now = DateTime.now();
    return SocialEvent(
      id: 'event_paid_001',
      hostId: 'user_host_002',
      title: 'Soirée VIP - Club Elite',
      description: 'Soirée exclusive pour les membres premium',
      location: 'Club Elite, Paris 8ème',
      eventDateTime: now.add(const Duration(days: 14)),
      maxAttendees: 50,
      currentAttendees: const [
        'user_host_002',
        'user_attendee_003',
      ],
      interest: const ['Soirée', 'VIP'],
      price: 50.0,
      currency: 'EUR',
      createdAt: now.subtract(const Duration(days: 3)),
    );
  }

  /// Full social event (at capacity)
  static SocialEvent get fullEvent {
    final now = DateTime.now();
    return SocialEvent(
      id: 'event_full_001',
      hostId: 'user_host_003',
      title: 'Randonnée dans la forêt',
      description: 'Belle randonnée nature en forêt de Fontainebleau',
      location: 'Gare de Fontainebleau',
      eventDateTime: now.add(const Duration(days: 21)),
      maxAttendees: 10,
      currentAttendees: List.generate(10, (i) => 'user_$i'),
      interest: const ['Randonnée', 'Nature', 'Sport'],
      price: 15.0,
      currency: 'EUR',
      createdAt: now.subtract(const Duration(days: 1)),
    );
  }

  /// Social group
  static SocialGroup get simpleGroup {
    final now = DateTime.now();
    return SocialGroup(
      id: 'group_simple_001',
      hostId: 'user_host_001',
      name: 'Les Grands de Paris',
      description: 'Groupe pour tous les grands de Paris région !',
      interest: const ['Social', 'Rencontres', 'Événements'],
      maxMembers: 100,
      currentMemberCount: 45,
      isPublic: true,
      createdAt: now.subtract(const Duration(days: 30)),
    );
  }

  /// Private social group
  static SocialGroup get privateGroup {
    final now = DateTime.now();
    return SocialGroup(
      id: 'group_private_001',
      hostId: 'user_host_002',
      name: 'Basketball Tall People',
      description: 'Groupe privé pour les basketteurs de 190cm+',
      interest: const ['Sport', 'Basketball'],
      maxMembers: 20,
      currentMemberCount: 18,
      isPublic: false,
      createdAt: now.subtract(const Duration(days: 60)),
    );
  }

  /// Photo metadata for testing
  static PhotoMetadata get photoMetadata {
    return PhotoMetadata(
      photoId: 'photo_001',
      userId: 'user_001',
      profileId: 'profile_001',
      url: 'https://example.com/photos/test1.jpg',
      uploadDate: DateTime.now().subtract(const Duration(days: 7)),
      isVisible: true,
      orderIndex: 0,
      likesCount: 25,
      matchesCount: 8,
      lastScoreUpdate: DateTime.now().subtract(const Duration(hours: 3)),
      topPickScore: 85.5,
    );
  }

  /// Like record
  static LikeRecord get likeRecord {
    return LikeRecord(
      id: 'like_001',
      fromUserId: 'user_liker_001',
      toProfileId: 'profile_001',
      type: LikeType.regular,
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      isSeen: false,
    );
  }

  /// Super like record
  static LikeRecord get superLikeRecord {
    return LikeRecord(
      id: 'like_002',
      fromUserId: 'user_liker_002',
      toProfileId: 'profile_001',
      type: LikeType.superLike,
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      isSeen: true,
    );
  }

  /// Top pick score
  static TopPickScore get topPickScore {
    return TopPickScore(
      profileId: 'profile_001',
      scorerId: 'user_001',
      compatibilityScore: 92.5,
      matchReasons: const [
        'Hauteur compatible',
        'Intérêts communs: Randonnée, Voyage',
        'Proche géographique',
        'Style de vie similaire',
      ],
      calculatedAt: DateTime.now().subtract(const Duration(minutes: 30)),
    );
  }
}
