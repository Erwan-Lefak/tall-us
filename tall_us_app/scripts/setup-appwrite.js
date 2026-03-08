#!/usr/bin/env node

/**
 * Tall Us - Appwrite Setup Script
 *
 * This script automatically sets up the entire Appwrite backend:
 * - Creates database with all collections
 * - Sets up attributes and indexes
 * - Creates storage bucket for photos
 * - Configures permissions
 *
 * Usage:
 *   node scripts/setup-appwrite.js
 *
 * Environment variables required:
 *   APPWRITE_ENDPOINT
 *   APPWRITE_API_KEY
 *   APPWRITE_PROJECT_ID
 */

const { Client, Databases, Storage, Users } = require('node-appwrite');
const readline = require('readline');

// ANSI color codes for terminal output
const colors = {
  reset: '\x1b[0m',
  bright: '\x1b[1m',
  red: '\x1b[31m',
  green: '\x1b[32m',
  yellow: '\x1b[33m',
  blue: '\x1b[34m',
  cyan: '\x1b[36m',
};

const log = {
  info: (msg) => console.log(`${colors.blue}ℹ${colors.reset} ${msg}`),
  success: (msg) => console.log(`${colors.green}✓${colors.reset} ${msg}`),
  error: (msg) => console.log(`${colors.red}✗${colors.reset} ${msg}`),
  warn: (msg) => console.log(`${colors.yellow}⚠${colors.reset} ${msg}`),
  step: (msg) => console.log(`\n${colors.bright}${colors.cyan}▶ ${msg}${colors.reset}`),
};

// Configuration
const DATABASE_ID = 'tall_us_db';
const STORAGE_BUCKET_ID = 'tall-us-photos';

// Collection definitions
const collections = [
  {
    id: 'users',
    name: 'users',
    attributes: [
      { id: 'email', type: 'email', size: 255, required: true, array: false },
      { id: 'password_hash', type: 'string', size: 255, required: true, array: false },
      { id: 'email_verified', type: 'boolean', required: false, array: false },
      { id: 'role', type: 'enum', elements: ['FREE', 'PREMIUM', 'ADMIN'], required: false, array: false },
      { id: 'deleted_at', type: 'datetime', required: false, array: false },
    ],
    indexes: [
      { key: 'idx_email', type: 'key', attributes: ['email'], orders: ['ASC'] },
      { key: 'idx_role', type: 'key', attributes: ['role'], orders: ['ASC'] },
      { key: 'idx_deleted_at', type: 'key', attributes: ['deleted_at'], orders: ['ASC'] },
    ],
  },
  {
    id: 'profiles',
    name: 'profiles',
    attributes: [
      { id: 'user_id', type: 'string', size: 255, required: true, array: false },
      { id: 'display_name', type: 'string', size: 100, required: true, array: false },
      { id: 'gender', type: 'enum', elements: ['male', 'female', 'other'], required: true, array: false },
      { id: 'height_cm', type: 'integer', required: true, array: false },
      { id: 'birthday', type: 'datetime', required: true, array: false },
      { id: 'country_code', type: 'string', size: 2, required: true, array: false },
      { id: 'city', type: 'string', size: 100, required: true, array: false },
      { id: 'latitude', type: 'float', required: true, array: false },
      { id: 'longitude', type: 'float', required: true, array: false },
      { id: 'bio', type: 'string', size: 5000, required: false, array: false },
      { id: 'occupation', type: 'string', size: 100, required: false, array: false },
      { id: 'education', type: 'string', size: 100, required: false, array: false },
      { id: 'interests', type: 'string', size: 1000, required: false, array: true },
      { id: 'preferred_gender', type: 'enum', elements: ['male', 'female', 'both'], required: true, array: false },
      { id: 'preferred_age_min', type: 'integer', required: false, array: false },
      { id: 'preferred_age_max', type: 'integer', required: false, array: false },
      { id: 'preferred_distance_km', type: 'integer', required: false, array: false },
      { id: 'profile_completed', type: 'boolean', required: false, array: false },
      { id: 'height_verified', type: 'boolean', required: false, array: false },
      { id: 'photo_urls', type: 'string', size: 2000, required: false, array: true },
    ],
    indexes: [
      { key: 'idx_user_id', type: 'key', attributes: ['user_id'], orders: ['ASC'] },
      { key: 'idx_height_cm', type: 'key', attributes: ['height_cm'], orders: ['ASC'] },
      { key: 'idx_gender', type: 'key', attributes: ['gender'], orders: ['ASC'] },
      { key: 'idx_completed', type: 'key', attributes: ['profile_completed'], orders: ['ASC'] },
    ],
  },
  {
    id: 'swipes',
    name: 'swipes',
    attributes: [
      { id: 'swiper_id', type: 'string', size: 255, required: true, array: false },
      { id: 'swiped_id', type: 'string', size: 255, required: true, array: false },
      { id: 'action', type: 'enum', elements: ['LIKE', 'PASS', 'SUPER_LIKE'], required: true, array: false },
    ],
    indexes: [
      { key: 'idx_swiper_id', type: 'key', attributes: ['swiper_id'], orders: ['ASC'] },
      { key: 'idx_swiped_id', type: 'key', attributes: ['swiped_id'], orders: ['ASC'] },
      { key: 'idx_created_at', type: 'key', attributes: ['$createdAt'], orders: ['DESC'] },
    ],
  },
  {
    id: 'matches',
    name: 'matches',
    attributes: [
      { id: 'user1_id', type: 'string', size: 255, required: true, array: false },
      { id: 'user2_id', type: 'string', size: 255, required: true, array: false },
      { id: 'status', type: 'enum', elements: ['ACTIVE', 'ARCHIVED', 'UNMATCHED'], required: false, array: false },
      { id: 'last_message', type: 'string', size: 500, required: false, array: false },
      { id: 'last_message_at', type: 'datetime', required: false, array: false },
    ],
    indexes: [
      { key: 'idx_user1_id', type: 'key', attributes: ['user1_id'], orders: ['ASC'] },
      { key: 'idx_user2_id', type: 'key', attributes: ['user2_id'], orders: ['ASC'] },
      { key: 'idx_status', type: 'key', attributes: ['status'], orders: ['ASC'] },
      { key: 'idx_created_at', type: 'key', attributes: ['$createdAt'], orders: ['DESC'] },
    ],
  },
  {
    id: 'messages',
    name: 'messages',
    attributes: [
      { id: 'match_id', type: 'string', size: 255, required: true, array: false },
      { id: 'sender_id', type: 'string', size: 255, required: true, array: false },
      { id: 'content', type: 'string', size: 5000, required: true, array: false },
      { id: 'message_type', type: 'enum', elements: ['TEXT', 'IMAGE', 'VOICE', 'SYSTEM'], required: false, array: false },
      { id: 'is_read', type: 'boolean', required: false, array: false },
      { id: 'read_at', type: 'datetime', required: false, array: false },
      { id: 'image_url', type: 'string', size: 2000, required: false, array: false },
      { id: 'voice_url', type: 'string', size: 2000, required: false, array: false },
      { id: 'duration', type: 'integer', required: false, array: false },
    ],
    indexes: [
      { key: 'idx_match_id', type: 'key', attributes: ['match_id', '$createdAt'], orders: ['ASC', 'DESC'] },
      { key: 'idx_sender_id', type: 'key', attributes: ['sender_id'], orders: ['ASC'] },
      { key: 'idx_is_read', type: 'key', attributes: ['match_id', 'is_read'], orders: ['ASC', 'ASC'] },
    ],
  },
  {
    id: 'subscriptions',
    name: 'subscriptions',
    attributes: [
      { id: 'user_id', type: 'string', size: 255, required: true, array: false },
      { id: 'stripe_customer_id', type: 'string', size: 255, required: false, array: false },
      { id: 'stripe_subscription_id', type: 'string', size: 255, required: false, array: false },
      { id: 'price_id', type: 'string', size: 255, required: false, array: false },
      { id: 'plan', type: 'enum', elements: ['MONTHLY', 'YEARLY'], required: true, array: false },
      { id: 'status', type: 'enum', elements: ['ACTIVE', 'CANCELED', 'PAST_DUE', 'TRIALING', 'INCOMPLETE'], required: false, array: false },
      { id: 'trial_start', type: 'datetime', required: false, array: false },
      { id: 'trial_end', type: 'datetime', required: false, array: false },
      { id: 'current_period_start', type: 'datetime', required: false, array: false },
      { id: 'current_period_end', type: 'datetime', required: false, array: false },
      { id: 'cancel_at_period_end', type: 'boolean', required: false, array: false },
      { id: 'canceled_at', type: 'datetime', required: false, array: false },
    ],
    indexes: [
      { key: 'idx_user_id', type: 'key', attributes: ['user_id'], orders: ['ASC'] },
      { key: 'idx_stripe_customer', type: 'key', attributes: ['stripe_customer_id'], orders: ['ASC'] },
      { key: 'idx_stripe_subscription', type: 'key', attributes: ['stripe_subscription_id'], orders: ['ASC'] },
      { key: 'idx_status', type: 'key', attributes: ['status'], orders: ['ASC'] },
      { key: 'idx_trial_end', type: 'key', attributes: ['trial_end'], orders: ['ASC'] },
    ],
  },
  {
    id: 'presence',
    name: 'presence',
    attributes: [
      { id: 'status', type: 'enum', elements: ['ONLINE', 'OFFLINE', 'AWAY'], required: false, array: false },
      { id: 'last_seen', type: 'datetime', required: false, array: false },
    ],
    indexes: [
      { key: 'idx_status', type: 'key', attributes: ['status'], orders: ['ASC'] },
      { key: 'idx_last_seen', type: 'key', attributes: ['last_seen'], orders: ['DESC'] },
    ],
  },
  {
    id: 'notifications',
    name: 'notifications',
    attributes: [
      { id: 'user_id', type: 'string', size: 255, required: true, array: false },
      { id: 'type', type: 'enum', elements: ['NEW_MATCH', 'NEW_MESSAGE', 'SUPER_LIKE', 'PROFILE_VIEW', 'WEEKLY_DIGEST', 'TRIAL_EXPIRATION'], required: true, array: false },
      { id: 'title', type: 'string', size: 255, required: true, array: false },
      { id: 'body', type: 'string', size: 2000, required: true, array: false },
      { id: 'data', type: 'string', size: 5000, required: false, array: false },
      { id: 'read', type: 'boolean', required: false, array: false },
    ],
    indexes: [
      { key: 'idx_user_id_read', type: 'key', attributes: ['user_id', 'read'], orders: ['ASC', 'ASC'] },
      { key: 'idx_user_id_created', type: 'key', attributes: ['user_id', '$createdAt'], orders: ['ASC', 'DESC'] },
      { key: 'idx_type', type: 'key', attributes: ['type'], orders: ['ASC'] },
    ],
  },
  {
    id: 'reports',
    name: 'reports',
    attributes: [
      { id: 'reporter_id', type: 'string', size: 255, required: true, array: false },
      { id: 'reported_id', type: 'string', size: 255, required: true, array: false },
      { id: 'reason', type: 'enum', elements: ['INAPPROPRIATE_CONTENT', 'HARASSMENT', 'FAKE_PROFILE', 'SPAM', 'OTHER'], required: true, array: false },
      { id: 'description', type: 'string', size: 2000, required: false, array: false },
      { id: 'status', type: 'enum', elements: ['PENDING', 'REVIEWED', 'RESOLVED', 'DISMISSED'], required: false, array: false },
      { id: 'admin_notes', type: 'string', size: 5000, required: false, array: false },
      { id: 'resolved_at', type: 'datetime', required: false, array: false },
    ],
    indexes: [
      { key: 'idx_reported_id', type: 'key', attributes: ['reported_id'], orders: ['ASC'] },
      { key: 'idx_status', type: 'key', attributes: ['status'], orders: ['ASC'] },
      { key: 'idx_created_at', type: 'key', attributes: ['$createdAt'], orders: ['DESC'] },
    ],
  },
];

// Initialize Appwrite client
function initClient() {
  const endpoint = process.env.APPWRITE_ENDPOINT || 'https://cloud.appwrite.io/v1';
  const apiKey = process.env.APPWRITE_API_KEY;
  const projectId = process.env.APPWRITE_PROJECT_ID;

  if (!apiKey) {
    log.error('APPWRITE_API_KEY environment variable is required');
    process.exit(1);
  }

  if (!projectId) {
    log.error('APPWRITE_PROJECT_ID environment variable is required');
    process.exit(1);
  }

  const client = new Client()
    .setEndpoint(endpoint)
    .setProject(projectId)
    .setKey(apiKey);

  return {
    databases: new Databases(client),
    storage: new Storage(client),
    users: new Users(client),
  };
}

// Create database
async function createDatabase(databases) {
  log.step('Creating database...');
  try {
    await databases.create(DATABASE_ID, 'Tall Us Database');
    log.success(`Database created: ${DATABASE_ID}`);
  } catch (error) {
    if (error.message.includes('already exists')) {
      log.warn(`Database already exists: ${DATABASE_ID}`);
    } else {
      throw error;
    }
  }
}

// Create a collection
async function createCollection(databases, collection) {
  log.info(`Creating collection: ${collection.name}...`);

  try {
    // Create collection
    await databases.createCollection(
      DATABASE_ID,
      collection.id,
      collection.name,
      [
        // Permissions
        // Documents are readable by the user who created them
        // For most collections, only authenticated users can read
      ]
    );

    // Update collection permissions
    await databases.updateCollection(
      DATABASE_ID,
      collection.id,
      collection.name,
      [
        // Read permission: Any user can read
        'role:all', // For testing - adjust in production
        // Write permission: Only authenticated users can create
        'role:member', // Only authenticated users can write
      ]
    );

    log.success(`Collection created: ${collection.id}`);
  } catch (error) {
    if (error.message.includes('already exists')) {
      log.warn(`Collection already exists: ${collection.id}`);
      // Continue to attributes/indexes
    } else {
      log.error(`Failed to create collection ${collection.id}: ${error.message}`);
      return; // Skip to next collection
    }
  }

  // Create attributes
  for (const attr of collection.attributes) {
    try {
      await databases.createAttribute(
        DATABASE_ID,
        collection.id,
        attr.id,
        attr.size,
        attr.required,
        attr.default,
        attr.array,
        attr.elements // For enum types
      );
      log.success(`  ✓ Attribute: ${attr.id}`);
    } catch (error) {
      if (error.message.includes('already exists')) {
        log.warn(`  ⚠ Attribute already exists: ${attr.id}`);
      } else {
        log.error(`  ✗ Failed to create attribute ${attr.id}: ${error.message}`);
      }
    }
  }

  // Create indexes
  for (const index of collection.indexes) {
    try {
      await databases.createIndex(
        DATABASE_ID,
        collection.id,
        index.key,
        index.type,
        index.attributes,
        index.orders
      );
      log.success(`  ✓ Index: ${index.key}`);
    } catch (error) {
      if (error.message.includes('already exists')) {
        log.warn(`  ⚠ Index already exists: ${index.key}`);
      } else {
        log.error(`  ✗ Failed to create index ${index.key}: ${error.message}`);
      }
    }
  }
}

// Create storage bucket
async function createStorageBucket(storage) {
  log.step('Creating storage bucket...');

  try {
    await storage.createBucket(
      STORAGE_BUCKET_ID,
      'Tall Us Photos',
      [
        // Permissions
        'role:all', // Read permission (public for profile photos)
        'role:member', // Write permission (authenticated users only)
      ],
      false, // Not enabled
      100, // Maximum file size in MB (100MB for photos)
      [
        // Allowed file extensions
        'jpg',
        'jpeg',
        'png',
        'gif',
        'webp',
      ],
      false // Not encrypted
    );

    log.success(`Storage bucket created: ${STORAGE_BUCKET_ID}`);
  } catch (error) {
    if (error.message.includes('already exists')) {
      log.warn(`Storage bucket already exists: ${STORAGE_BUCKET_ID}`);
    } else {
      log.error(`Failed to create storage bucket: ${error.message}`);
    }
  }
}

// Main setup function
async function setup() {
  log.step(`${colors.bright}Tall Us - Appwrite Setup${colors.reset}`);
  log.info('This script will set up your Appwrite backend.\n');

  // Initialize client
  const { databases, storage, users } = initClient();
  log.success('Connected to Appwrite');

  // Create database
  await createDatabase(databases);

  // Create collections
  log.step('Creating collections...');
  for (const collection of collections) {
    await createCollection(databases, collection);
  }

  // Create storage bucket
  await createStorageBucket(storage);

  // Success message
  console.log(`\n${colors.bright}${colors.green}╔════════════════════════════════════════╗${colors.reset}`);
  console.log(`${colors.bright}${colors.green}║      Setup Completed Successfully!     ║${colors.reset}`);
  console.log(`${colors.bright}${colors.green}╚════════════════════════════════════════╝${colors.reset}\n`);

  log.success('Database: ' + DATABASE_ID);
  log.success('Collections: ' + collections.length);
  log.success('Storage Bucket: ' + STORAGE_BUCKET_ID);

  console.log(`\n${colors.cyan}Next steps:${colors.reset}`);
  console.log(`  1. Update your .env file with these IDs`);
  console.log(`  2. Run the app with: flutter run`);
  console.log(`  3. Create your first account to test!`);
  console.log('');
}

// Run setup
setup().catch((error) => {
  log.error(`Setup failed: ${error.message}`);
  console.error(error);
  process.exit(1);
});
