/// Script to setup Appwrite collections for Tall Us
/// Run with: dart scripts/setup_appwrite_collections.dart
import 'dart:io';
import 'package:appwrite/appwrite.dart';

void main() async {
  // Appwrite configuration
  const endpoint = 'https://fra.cloud.appwrite.io/v1';
  const projectId = '69a85fa1000386efe620';
  const databaseId = 'tall_us_db';
  const apiKey = ''; // TODO: Add your API key with databases.write scope

  // Initialize Appwrite client
  final client = Client()
    ..setEndpoint(endpoint)
    ..setProject(projectId)
    ..setKey(apiKey);

  final databases = Databases(client);

  print('🔧 Setting up Appwrite collections for Tall Us...\n');

  try {
    // ====================================================================
    // SWIPES COLLECTION
    // ====================================================================
    print('📝 Creating swipes collection...');

    try {
      await databases.createCollection(
        databaseId: databaseId,
        collectionId: 'swipes',
        name: 'Swipes',
        permissions: [
          Permission.read(Role.any()), // Anyone can read swipes (for matching)
        ],
      );
      print('   ✅ Swipes collection created');
    } on AppwriteException catch (e) {
      if (e.code == 409) {
        print('   ⚠️  Swipes collection already exists');
      } else {
        print('   ❌ Error creating swipes collection: ${e.message}');
        rethrow;
      }
    }

    // Add attributes to swipes collection
    final swipeAttributes = [
      {'name': 'swiperId', 'type': 'string', 'size': 128, 'required': true},
      {'name': 'targetId', 'type': 'string', 'size': 128, 'required': true},
      {'name': 'action', 'type': 'enum', 'elements': ['like', 'pass', 'superLike'], 'required': true},
      {'name': 'createdAt', 'type': 'datetime', 'required': true},
    ];

    for (var attr in swipeAttributes) {
      try {
        await databases.createAttribute(
          databaseId: databaseId,
          collectionId: 'swipes',
          attributeId: attr['name'] as String,
          type: attr['type'] as String,
          size: attr['size'] as int?,
          elements: attr['elements'] as List<String>?,
          required: attr['required'] as bool,
        );
        print('   ✅ Attribute "${attr['name']}" created');
      } on AppwriteException catch (e) {
        if (e.code == 409) {
          print('   ⚠️  Attribute "${attr['name']}" already exists');
        } else {
          print('   ⚠️  Error creating attribute "${attr['name']}": ${e.message}');
        }
      }
    }

    // Create indexes for swipes
    try {
      await databases.createIndex(
        databaseId: databaseId,
        collectionId: 'swipes',
        indexId: 'swiper_target',
        type: 'key',
        attributes: ['swiperId', 'targetId'],
      );
      print('   ✅ Index "swiper_target" created');
    } on AppwriteException catch (e) {
      if (e.code == 409) {
        print('   ⚠️  Index "swiper_target" already exists');
      } else {
        print('   ⚠️  Error creating index: ${e.message}');
      }
    }

    // ====================================================================
    // MATCHES COLLECTION
    // ====================================================================
    print('\n📝 Creating matches collection...');

    try {
      await databases.createCollection(
        databaseId: databaseId,
        collectionId: 'matches',
        name: 'Matches',
        permissions: [
          Permission.read(Role.users()), // Only authenticated users can read matches
        ],
      );
      print('   ✅ Matches collection created');
    } on AppwriteException catch (e) {
      if (e.code == 409) {
        print('   ⚠️  Matches collection already exists');
      } else {
        print('   ❌ Error creating matches collection: ${e.message}');
        rethrow;
      }
    }

    // Add attributes to matches collection
    final matchAttributes = [
      {'name': 'user1Id', 'type': 'string', 'size': 128, 'required': true},
      {'name': 'user2Id', 'type': 'string', 'size': 128, 'required': true},
      {'name': 'createdAt', 'type': 'datetime', 'required': true},
      {'name': 'isRead', 'type': 'boolean', 'required': true, 'default': false},
      {'name': 'lastMessageId', 'type': 'string', 'size': 128},
      {'name': 'lastMessageAt', 'type': 'datetime'},
    ];

    for (var attr in matchAttributes) {
      try {
        await databases.createAttribute(
          databaseId: databaseId,
          collectionId: 'matches',
          attributeId: attr['name'] as String,
          type: attr['type'] as String,
          size: attr['size'] as int?,
          required: attr['required'] as bool,
          xdefault: attr['default'] as bool?,
        );
        print('   ✅ Attribute "${attr['name']}" created');
      } on AppwriteException catch (e) {
        if (e.code == 409) {
          print('   ⚠️  Attribute "${attr['name']}" already exists');
        } else {
          print('   ⚠️  Error creating attribute "${attr['name']}": ${e.message}');
        }
      }
    }

    // Create indexes for matches
    try {
      await databases.createIndex(
        databaseId: databaseId,
        collectionId: 'matches',
        indexId: 'user1_user2',
        type: 'key',
        attributes: ['user1Id', 'user2Id'],
      );
      print('   ✅ Index "user1_user2" created');
    } on AppwriteException catch (e) {
      if (e.code == 409) {
        print('   ⚠️  Index "user1_user2" already exists');
      } else {
        print('   ⚠️  Error creating index: ${e.message}');
      }
    }

    print('\n✨ Setup completed successfully!');
    print('\n📚 Next steps:');
    print('1. Create profiles collection if not exists');
    print('2. Add some test profiles');
    print('3. Test swipes and matching');

  } on AppwriteException catch (e) {
    print('\n❌ Appwrite Error: ${e.message}');
    print('   Code: ${e.code}');
    print('   Type: ${e.type}');
    exit(1);
  } catch (e) {
    print('\n❌ Error: $e');
    exit(1);
  }
}
