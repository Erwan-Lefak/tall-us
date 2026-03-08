# Tall Us - Appwrite Setup Scripts

This directory contains scripts to automatically set up your Appwrite backend for Tall Us.

## Prerequisites

- Node.js 18+ installed
- An Appwrite Cloud account (free tier works)
- Appwrite project created

## Quick Start

### 1. Get your Appwrite credentials

1. Go to https://cloud.appwrite.io
2. Create a new project (or use existing)
3. Go to Settings → API Keys
4. Create a new API key with these permissions:
   - ✓ Databases: Read & Write
   - ✓ Storage: Read & Write
   - ✓ Users: Read & Write

### 2. Set environment variables

Create a `.env` file in the project root:

```bash
# Appwrite Configuration
APPWRITE_ENDPOINT=https://cloud.appwrite.io/v1
APPWRITE_PROJECT_ID=your-project-id
APPWRITE_API_KEY=your-api-key-here
```

### 3. Install dependencies and run setup

```bash
cd scripts
npm install
npm run setup
```

## What the script does

The setup script will automatically create:

### Database
- **Database ID**: `tall_us_db`
- **Name**: Tall Us Database

### Collections (9 total)

1. **users** - User accounts and authentication
2. **profiles** - Extended profile information (height, location, bio, etc.)
3. **swipes** - Like/Pass/Super-Like actions
4. **matches** - Matched pairs of users
5. **messages** - Chat messages between matches
6. **subscriptions** - Premium subscription status
7. **presence** - Online/offline status
8. **notifications** - Push notification history
9. **reports** - User reports for moderation

### Storage Bucket
- **Bucket ID**: `tall-us-photos`
- **Name**: Tall Us Photos
- **Allowed formats**: jpg, jpeg, png, gif, webp
- **Max file size**: 100MB

### Permissions

- **Read**: Anyone (for public profile photos)
- **Write**: Authenticated users only

## Environment Variables Reference

| Variable | Description | Example |
|----------|-------------|---------|
| `APPWRITE_ENDPOINT` | Appwrite API endpoint | `https://cloud.appwrite.io/v1` |
| `APPWRITE_PROJECT_ID` | Your project ID | `tall-us-production` |
| `APPWRITE_API_KEY` | API key with full permissions | `your-api-key-here` |

## Collection Schemas

### users
```javascript
{
  email: "user@example.com",
  password_hash: "hashed_password",
  email_verified: true,
  role: "FREE", // FREE, PREMIUM, or ADMIN
  deleted_at: null
}
```

### profiles
```javascript
{
  user_id: "user_id",
  display_name: "John",
  gender: "male", // male, female, other
  height_cm: 185,
  birthday: "1992-05-15T00:00:00Z",
  country_code: "FR",
  city: "Paris",
  latitude: 48.8566,
  longitude: 2.3522,
  bio: "Tall guy looking for love",
  occupation: "Software Engineer",
  education: "Master's Degree",
  interests: ["travel", "photography", "fitness"],
  preferred_gender: "female",
  preferred_age_min: 23,
  preferred_age_max: 35,
  preferred_distance_km: 50,
  profile_completed: true,
  height_verified: true,
  photo_urls: ["https://..."]
}
```

### swipes
```javascript
{
  swiper_id: "user_1_id",
  swiped_id: "user_2_id",
  action: "LIKE" // LIKE, PASS, SUPER_LIKE
}
```

### matches
```javascript
{
  user1_id: "user_1_id",
  user2_id: "user_2_id",
  status: "ACTIVE", // ACTIVE, ARCHIVED, UNMATCHED
  last_message: "Hey!",
  last_message_at: "2026-03-03T10:30:00Z"
}
```

### messages
```javascript
{
  match_id: "match_id",
  sender_id: "user_id",
  content: "Hey! How's your day?",
  message_type: "TEXT", // TEXT, IMAGE, VOICE, SYSTEM
  is_read: false,
  read_at: null,
  image_url: null, // For IMAGE type
  voice_url: null, // For VOICE type
  duration: null // Voice message duration in seconds
}
```

### subscriptions
```javascript
{
  user_id: "user_id",
  stripe_customer_id: "cus_xxx",
  stripe_subscription_id: "sub_xxx",
  price_id: "price_xxx",
  plan: "YEARLY", // MONTHLY or YEARLY
  status: "ACTIVE", // ACTIVE, CANCELED, PAST_DUE, TRIALING, INCOMPLETE
  trial_start: "2026-03-03T00:00:00Z",
  trial_end: "2026-03-10T00:00:00Z",
  current_period_start: "2026-03-03T00:00:00Z",
  current_period_end: "2027-03-03T00:00:00Z",
  cancel_at_period_end: false,
  canceled_at: null
}
```

### presence
```javascript
{
  status: "ONLINE", // ONLINE, OFFLINE, AWAY
  last_seen: "2026-03-03T10:30:00Z"
}
```

### notifications
```javascript
{
  user_id: "user_id",
  type: "NEW_MATCH", // NEW_MATCH, NEW_MESSAGE, SUPER_LIKE, etc.
  title: "New Match!",
  body: "You matched with Emma!",
  data: "{\"matchId\": \"xxx\"}", // JSON string
  read: false
}
```

### reports
```javascript
{
  reporter_id: "user_1_id",
  reported_id: "user_2_id",
  reason: "INAPPROPRIATE_CONTENT", // HARASSMENT, FAKE_PROFILE, SPAM, OTHER
  description: "User posted inappropriate content",
  status: "PENDING", // PENDING, REVIEWED, RESOLVED, DISMISSED
  admin_notes: null,
  resolved_at: null
}
```

## Troubleshooting

### "Collection already exists" errors
These are safe to ignore - the script checks for existing collections before creating them.

### "Permission denied" errors
Make sure your API key has the correct permissions:
- Databases: Read & Write
- Storage: Read & Write
- Users: Read & Write

### "Invalid API key" errors
Double-check your `.env` file and make sure:
- The API key is copied correctly (no extra spaces)
- The project ID matches your Appwrite project
- The endpoint is correct (usually `https://cloud.appwrite.io/v1`)

## Next Steps

After running the setup script:

1. **Update your Flutter app configuration**:
   ```bash
   # In lib/core/appwrite/appwrite_client.dart
   # Update the constants with your project ID
   ```

2. **Run the app**:
   ```bash
   cd ..
   flutter run
   ```

3. **Create your first account** to test the authentication flow

4. **Verify in Appwrite Console**:
   - Go to Databases → Browse collections
   - Check that all 9 collections exist
   - Go to Storage → Browse buckets
   - Check that the `tall-us-photos` bucket exists

## Production Checklist

Before deploying to production:

- [ ] Switch from test API keys to production keys
- [ ] Update CORS settings in Appwrite Console
- [ ] Enable encryption for storage bucket
- [ ] Set up custom domain (optional)
- [ ] Configure backup strategy
- [ ] Enable monitoring and alerts
- [ ] Review and adjust permissions
- [ ] Set up webhooks for Stripe integration

## Additional Scripts

### Seed Development Data

For testing, you may want to seed some sample data:

```bash
npm run seed  # (coming soon)
```

### Reset Database

⚠️ **WARNING**: This will delete all data!

```bash
npm run reset  # (coming soon)
```

## Support

If you encounter issues:
1. Check the Appwrite Console logs
2. Review your API key permissions
3. Check the error messages carefully
4. Refer to [Appwrite Documentation](https://appwrite.io/docs)

## License

MIT License - See LICENSE file for details
