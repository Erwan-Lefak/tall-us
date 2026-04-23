# Phase 1 Navigation Plan

## Overview
This document outlines the navigation structure and routing for all Phase 1 features.

## Current Navigation Structure

### Bottom Navigation (3 tabs)
1. **Découvrir** (Discovery) - DiscoveryScreen
2. **Matchs** (Matches) - MatchesScreen
3. **Profil** (Profile) - ProfileScreen

## Phase 1 Navigation Additions

### 1. Discovery Tab Enhancements

#### Top Picks Screen
- **Route**: `/home/top-picks`
- **Access**: From Discovery tab via "Top Picks" button
- **Widget**: `TopPicksWidget`
- **Provider**: `topPicksProvider`
- **Navigation**: Full-screen modal with close button

#### Who Likes You Screen
- **Route**: `/home/who-likes-you`
- **Access**: From Discovery tab via "Who Likes You" (Gold/Platinum feature)
- **Widget**: `WhoLikesYouWidget`
- **Provider**: `whoLikesYouProvider`
- **Navigation**: Full-screen modal with close button
- **Premium**: Requires Gold or Platinum subscription

### 2. Profile Tab Enhancements

#### Profile Details Screen
- **Route**: `/profile/details`
- **Access**: From Profile tab via "Edit Profile"
- **Widgets**:
  - `JobEducationWidget`
  - `LifestyleWidget`
  - `ZodiacPronounsWidget`
- **Navigation**: Pushed onto navigation stack

#### Photo Management Screen
- **Route**: `/profile/photos`
- **Access**: From Profile tab via photo grid
- **Widgets**:
  - `PhotoCaptionsWidget` (add/edit captions, reorder photos)
  - `PhotoLikeButton` (view photo likes)
- **Navigation**: Pushed onto navigation stack

#### Smart Photos Screen
- **Route**: `/profile/smart-photos`
- **Access**: From Profile tab via "Smart Photos" settings
- **Widget**: `SmartPhotosWidget`
- **Features**:
  - View photo performance metrics
  - Enable/disable auto-reordering
  - Verify photo order (anti-catfish)
- **Navigation**: Pushed onto navigation stack
- **Premium**: Requires Gold subscription

### 3. Social Features Screen (NEW TAB)

**Recommendation**: Add a 4th tab to bottom navigation
- **Icon**: `Icons.groups_outlined` / `Icons.groups`
- **Label**: `Social`

#### Social Home Screen
- **Route**: `/home/social` (via bottom nav)
- **Features**:
  - Events section
  - Groups section
  - Friends of Friends section
  - Double Date mode

#### Events Screen
- **Route**: `/social/events`
- **Access**: From Social tab
- **Widget**: `EventsWidget` (within `SocialFeaturesWidget`)
- **Provider**: `eventsProvider`
- **Features**:
  - View upcoming events
  - Create new events
  - Join events
  - See event attendees
- **Navigation**: Pushed onto navigation stack

#### Groups Screen
- **Route**: `/social/groups`
- **Access**: From Social tab
- **Widget**: `GroupsWidget` (within `SocialFeaturesWidget`)
- **Provider**: `groupsProvider`
- **Features**:
  - Browse groups
  - Create groups
  - Join groups
  - See group members
- **Navigation**: Pushed onto navigation stack

#### Friends of Friends Screen
- **Route**: `/social/friends-of-friends`
- **Access**: From Social tab
- **Widget**: `FriendsOfFriendsWidget`
- **Provider**: `friendsOfFriendsProvider`
- **Features**:
  - See friends of friends
  - Match count
  - Mutual friend names
- **Navigation**: Pushed onto navigation stack
- **Premium**: Requires Gold subscription

#### Double Date Screen
- **Route**: `/social/double-date`
- **Access**: From Social tab
- **Widget**: `DoubleDateWidget`
- **Provider**: `doubleDateProvider`
- **Features**:
  - Select up to 2 friends
  - Create double date
- **Navigation**: Pushed onto navigation stack
- **Premium**: Requires Platinum subscription

### 4. Messaging Enhancements

#### Rich Messaging (Already in Matches tab)
- **Route**: `/match/:matchId/messages` (existing)
- **Enhanced Widget**: `RichMessagingWidget`
- **Provider**: `richMessagesProvider` (to be created)
- **New Features**:
  - GIF support
  - Voice notes
  - Video messages
  - Message reactions
  - Replies/threads
  - Shared locations
  - "Tonight" feature
- **Note**: This is an enhancement to existing chat, not a new route

## Premium Feature Gates

### Free Tier
- Basic discovery
- Basic matching
- Standard messaging
- Profile viewing

### Gold Tier
- Top Picks (algorithm matching)
- Smart Photos (auto-reordering)
- Friends of Friends
- Events & Groups access

### Platinum Tier
- Who Likes You
- Double Date mode
- Video profiles
- Advanced messaging features (GIFs, voice, video)

## Implementation Priority

### Phase 1.4 - Create Navigation Routes (Current)
1. ✅ Document navigation structure (this file)
2. ⏳ Create SocialScreen for new 4th tab
3. ⏳ Add go_router routes for new screens
4. ⏳ Update HomeScreenWithNav to include 4th tab

### Phase 1.5 - Build Settings Pages
1. ⏳ Create SettingsScreen with premium tier management
2. ⏳ Add subscription management UI
3. ⏳ Add feature toggle controls

### Phase 1.6 - Integrate Widgets
1. ⏳ Integrate TopPicksWidget into DiscoveryScreen
2. ⏳ Integrate PhotoCaptionsWidget into ProfileScreen
3. ⏳ Integrate SmartPhotosWidget into ProfileScreen
4. ⏳ Create SocialScreen with all social widgets
5. ⏳ Integrate RichMessagingWidget into chat

## Navigation Flow Examples

### User wants to see Top Picks
```
HomeScreenWithNav (tab 0: Discovery)
  -> DiscoveryScreen
    -> Tap "Top Picks" button
      -> Navigator.push(TopPicksScreen)
        -> Shows TopPicksWidget with compatibility scores
```

### User wants to edit photo captions
```
HomeScreenWithNav (tab 2: Profile)
  -> ProfileScreen
    -> Tap photo grid
      -> Navigator.push(PhotoManagementScreen)
        -> Shows PhotoCaptionsWidget
          -> Edit caption, reorder, view likes
```

### User wants to join an event
```
HomeScreenWithNav (tab 3: Social)
  -> SocialScreen
    -> Tap "Events" card
      -> Navigator.push(EventsScreen)
        -> Shows EventsWidget
          -> Tap event -> EventDetailScreen
          -> Tap "Join" -> Updates attendees via eventsProvider
```

### User wants to send GIF in chat
```
HomeScreenWithNav (tab 1: Matches)
  -> MatchesScreen
    -> Tap match conversation
      -> ChatScreen (existing)
        -> Tap GIF icon
          -> Shows GIF picker
          -> Select GIF
            -> RichMessagingWidget sends GIF message
```

## Next Steps

1. Create `lib/features/social/presentation/screens/social_screen.dart`
2. Update `lib/core/router/app_router.dart` with new routes
3. Update `lib/core/screens/home_screen_with_nav.dart` to add 4th tab
4. Create individual screen files for each feature
5. Integrate widgets into screens
