import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tall_us/core/theme/app_theme.dart';
import 'package:tall_us/features/auth/presentation/providers/auth_providers.dart';
import 'package:tall_us/features/events/presentation/providers/events_provider.dart';
import 'package:tall_us/features/profile/domain/entities/user_profile_entity.dart';
import 'package:tall_us/features/profile/domain/entities/discovery_preferences_entity.dart';
import 'package:tall_us/core/utils/logger.dart';
import 'package:tall_us/features/profile/presentation/providers/profile_provider.dart';
import 'package:tall_us/features/profile/presentation/screens/discovery_preferences_screen.dart';

/// Main profile screen with view and edit modes
class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool _isEditing = false;
  bool _isLoading = false;
  UserProfileEntity? _profile;
  DateTime _selectedBirthday = DateTime(2000, 1, 1);

  final _formKey = GlobalKey<FormState>();
  late TextEditingController _displayNameController;
  late TextEditingController _locationController;
  late TextEditingController _bioController;
  late TextEditingController _spotifyController;

  @override
  void initState() {
    super.initState();
    _displayNameController = TextEditingController();
    _locationController = TextEditingController();
    _bioController = TextEditingController();
    _spotifyController = TextEditingController();

    // Load profile after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadProfile();
    });
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    _locationController.dispose();
    _bioController.dispose();
    _spotifyController.dispose();
    super.dispose();
  }

  void _loadProfile() {
    final user = ref.read(authenticatedUserProvider);
    if (user != null) {
      ref.read(profileProvider.notifier).loadProfile(user.id);
    } else {
      AppLogger.w('Cannot load profile: no authenticated user');
    }
  }

  void _initControllers(UserProfileEntity profile) {
    _displayNameController.text = profile.displayName;
    _locationController.text = '${profile.city}, ${profile.country}';
    _bioController.text = profile.bio ?? '';
    _spotifyController.text = profile.spotifyPlaylistUrl ?? '';
    _selectedBirthday = profile.birthday;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer(
        builder: (context, ref, _) {
          final profileState = ref.watch(profileProvider);

          // Listen for errors
          ref.listen<ProfileState>(profileProvider, (prev, next) {
            if (next.error != null && next.error != prev?.error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(next.error!),
                  backgroundColor: AppTheme.error,
                ),
              );
            }
          });

          // Loading state
          if (profileState.profile == null && profileState.isLoading) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppTheme.bordeaux),
              ),
            );
          }

          // Error / no profile state
          if (profileState.profile == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 60, color: AppTheme.bordeaux.withOpacity(0.3)),
                  const SizedBox(height: 16),
                  Text(
                    profileState.error ?? 'Impossible de charger le profil',
                    style: TextStyle(color: AppTheme.navy, fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadProfile,
                    child: const Text('Réessayer'),
                    style: ElevatedButton.styleFrom(backgroundColor: AppTheme.bordeaux, foregroundColor: Colors.white),
                  ),
                ],
              ),
            );
          }

          final profile = profileState.profile!;
          _profile = profile;

          return CustomScrollView(
            slivers: [
              // App bar
              _buildAppBar(),

              // Content
              SliverToBoxAdapter(
                child: _isEditing ? _buildEditMode(profile) : _buildViewMode(profile),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 120,
      floating: false,
      pinned: true,
      elevation: 0,
      backgroundColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          _isEditing ? 'Modifier mon profil' : 'Mon profil',
          style: const TextStyle(
            color: AppTheme.navy,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      actions: [
        if (!_isEditing)
          IconButton(
            icon: const Icon(Icons.edit, color: AppTheme.navy),
            onPressed: () {
              setState(() {
                _isEditing = true;
              });
            },
          ),
        if (_isEditing) ...[
          IconButton(
            icon: const Icon(Icons.close, color: AppTheme.navy),
            onPressed: () {
              setState(() {
                _isEditing = false;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.check, color: AppTheme.bordeaux),
            onPressed: _isLoading ? null : _saveProfile,
          ),
        ],
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildViewMode(UserProfileEntity _profile) {
    return Container(
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Photos
          _buildPhotosSection(),

          const SizedBox(height: 24),

          // Basic info
          _buildBasicInfoSection(),

          const SizedBox(height: 24),

          // Bio
          _buildBioSection(),

          const SizedBox(height: 24),

          // Spotify (only if set)
          _buildSpotifySection(),

          const SizedBox(height: 24),

          // Prompts
          _buildPromptsSection(),

          const SizedBox(height: 24),

          // Feature cards (events, coaching, subscription, deals)
          _buildFeatureCards(),

          const SizedBox(height: 24),

          // Legal links
          _buildLegalLinks(),

          const SizedBox(height: 16),

          // Preferences button
          _buildPreferencesButton(),

          const SizedBox(height: 32),

          // Logout button
          _buildLogoutButton(),

          const SizedBox(height: 48),
        ],
      ),
    );
  }

  /// Small centered row linking to the legal pages (CGU + privacy).
  Widget _buildLegalLinks() {
    return Center(
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 4,
        children: [
          TextButton(
            onPressed: () => context.push('/legal/terms'),
            style: TextButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap),
            child: Text("Conditions d'utilisation",
                style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.navy.withValues(alpha: 0.5))),
          ),
          Text('·',
              style: TextStyle(
                  fontSize: 12, color: AppTheme.navy.withValues(alpha: 0.3))),
          TextButton(
            onPressed: () => context.push('/legal/privacy'),
            style: TextButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap),
            child: Text('Confidentialité',
                style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.navy.withValues(alpha: 0.5))),
          ),
        ],
      ),
    );
  }

  /// Tappable cards linking to the profile enrichment sections.
  Widget _buildFeatureCards() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Text('Découvrir',
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.navy.withValues(alpha: 0.5),
                  letterSpacing: 0.5)),
        ),
        const SizedBox(height: 8),
        _FeatureCard(
          icon: Icons.confirmation_number_outlined,
          title: 'Événements',
          subtitle: Consumer(
            builder: (context, ref, _) {
              final events = ref.watch(eventsProvider);
              return Text(
                events.maybeWhen(
                  data: (e) =>
                      e.isEmpty ? 'Aucun à venir' : '${e.length} à venir',
                  orElse: () => 'Soirées, speed dating...',
                ),
                style: TextStyle(
                    fontSize: 13,
                    color: AppTheme.navy.withValues(alpha: 0.6)),
              );
            },
          ),
          onTap: () => context.push('/events'),
        ),
        _FeatureCard(
          icon: Icons.psychology_outlined,
          title: 'Coaching',
          subtitle: Text(
            '30 min avec un pro (Légende)',
            style: TextStyle(
                fontSize: 13, color: AppTheme.navy.withValues(alpha: 0.6)),
          ),
          onTap: () => context.push('/coaching'),
        ),
        _FeatureCard(
          icon: Icons.workspace_premium_outlined,
          title: 'Mon abonnement',
          subtitle: Consumer(
            builder: (context, ref, _) {
              final role = ref.watch(authenticatedUserProvider)?.role;
              final plan = role?.maybeWhen(
                premium: () => 'Tall',
                admin: () => 'Légende',
                orElse: () => 'Freemium',
              );
              return Text(
                'Forfait actuel : $plan',
                style: TextStyle(
                    fontSize: 13,
                    color: AppTheme.navy.withValues(alpha: 0.6)),
              );
            },
          ),
          onTap: () => context.push('/subscription'),
        ),
        _FeatureCard(
          icon: Icons.redeem_outlined,
          title: 'Bons plans Tall',
          subtitle: Text(
            'Mode & voyage pour grandes tailles',
            style: TextStyle(
                fontSize: 13, color: AppTheme.navy.withValues(alpha: 0.6)),
          ),
          onTap: () => context.push('/tall-deals'),
        ),
      ],
    );
  }

  Widget _buildEditMode(UserProfileEntity _profile) {
    // Init controllers with current profile values
    _initControllers(_profile);

    return Form(
      key: _formKey,
      child: Container(
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Photos edit
          _buildPhotosEditSection(),

          const SizedBox(height: 24),

          // Basic info edit
          _buildBasicInfoEditSection(),

          const SizedBox(height: 24),

          // Bio edit
          _buildBioEditSection(),

          const SizedBox(height: 24),

          // Prompts edit
          _buildPromptsEditSection(),

          const SizedBox(height: 48),
        ],
      ),
    ),
    );
  }

  Widget _buildPhotosSection() {
    final photos = _profile!.photoUrls;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Mes photos',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.navy,
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: photos.length,
            itemBuilder: (context, index) {
              return Container(
                width: 150,
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    photos[index],
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: const Icon(Icons.person, size: 50, color: Colors.grey),
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPhotosEditSection() {
    final photos = _profile!.photoUrls;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Mes photos',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.navy,
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: photos.length + 1,
            itemBuilder: (context, index) {
              if (index == photos.length) {
                // Add photo button
                return Container(
                  width: 150,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppTheme.bordeaux.withValues(alpha: 0.5),
                      width: 2,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: _pickPhoto,
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_circle_outline,
                              size: 48,
                              color: AppTheme.bordeaux,
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Ajouter',
                              style: TextStyle(
                                color: AppTheme.navy,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }

              return Container(
                width: 150,
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        photos[index],
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[300],
                            child: const Icon(Icons.person, size: 50, color: Colors.grey),
                          );
                        },
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.delete, color: AppTheme.bordeaux, size: 20),
                          onPressed: () {
                            // TODO: Remove photo
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Glissez pour réorganiser, appuyez sur X pour supprimer',
            style: TextStyle(
              fontSize: 12,
              color: AppTheme.navy,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBasicInfoSection() {
    final age = _profile!.calculateAge();
    final height = _profile!.getHeightInFeetInches();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '${_profile!.displayName}, $age',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.navy,
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.verified, color: AppTheme.gold, size: 24),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.location_on, color: AppTheme.bordeaux, size: 20),
              const SizedBox(width: 4),
              Text(
                '${_profile!.city}, ${_profile!.country}',
                style: TextStyle(
                  fontSize: 16,
                  color: AppTheme.navy.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.height, color: AppTheme.bordeaux, size: 20),
              const SizedBox(width: 4),
              Text(
                '${_profile!.heightCm} cm ($height)',
                style: TextStyle(
                  fontSize: 16,
                  color: AppTheme.navy.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBasicInfoEditSection() {
    final age = _calculateAge(_selectedBirthday);
    final formattedDate = '${_selectedBirthday.day.toString().padLeft(2, '0')}/${_selectedBirthday.month.toString().padLeft(2, '0')}/${_selectedBirthday.year}';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Informations de base',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.navy,
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _displayNameController,
            decoration: const InputDecoration(
              labelText: 'Prénom',
              prefixIcon: Icon(Icons.person),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          InkWell(
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: _selectedBirthday,
                firstDate: DateTime(1950),
                lastDate: DateTime.now().subtract(const Duration(days: 18 * 365)),
                locale: const Locale('fr', 'FR'),
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: ColorScheme.light(
                        primary: AppTheme.bordeaux,
                        onPrimary: Colors.white,
                        surface: Colors.white,
                        onSurface: AppTheme.navy,
                      ),
                    ),
                    child: child!,
                  );
                },
              );
              if (picked != null) {
                setState(() => _selectedBirthday = picked);
              }
            },
            child: InputDecorator(
              decoration: const InputDecoration(
                labelText: 'Date de naissance',
                prefixIcon: Icon(Icons.cake),
                border: OutlineInputBorder(),
              ),
              child: Text('$formattedDate ($age ans)'),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _locationController,
            decoration: const InputDecoration(
              labelText: 'Ville',
              prefixIcon: Icon(Icons.location_on),
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }

  int _calculateAge(DateTime birthday) {
    final today = DateTime.now();
    int age = today.year - birthday.year;
    if (today.month < birthday.month ||
        (today.month == birthday.month && today.day < birthday.day)) {
      age--;
    }
    return age;
  }

  Widget _buildBioSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'À propos de moi',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.navy,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            _profile!.bio ?? 'Pas encore de bio',
            style: TextStyle(
              fontSize: 16,
              color: AppTheme.navy.withValues(alpha: 0.8),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpotifySection() {
    final url = _profile?.spotifyPlaylistUrl;
    if (url == null || url.isEmpty) return const SizedBox.shrink();
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: const Color(0xFF1DB954).withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.library_music,
              color: Color(0xFF1DB954), size: 24),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Ma musique',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.navy)),
              const SizedBox(height: 2),
              Text('Playlist Spotify',
                  style: TextStyle(
                      fontSize: 13,
                      color: AppTheme.navy.withValues(alpha: 0.6))),
            ],
          ),
        ),
        const Icon(Icons.chevron_right, color: AppTheme.bordeaux),
      ]),
    );
  }

  Widget _buildBioEditSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'À propos de moi',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.navy,
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _bioController,
            maxLines: 5,
            maxLength: 500,
            decoration: const InputDecoration(
              hintText: 'Parlez-nous de vous...',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _spotifyController,
            keyboardType: TextInputType.url,
            decoration: const InputDecoration(
              labelText: 'Playlist Spotify (URL)',
              prefixIcon: Icon(Icons.library_music),
              hintText: 'https://open.spotify.com/playlist/...',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromptsSection() {
    // TODO: Implement prompts when the entity supports it
    return const SizedBox.shrink();
  }

  Widget _buildPromptsEditSection() {
    // TODO: Implement prompts when the entity supports it
    return const SizedBox.shrink();
  }

  Widget _buildPreferencesButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const DiscoveryPreferencesScreen(),
              ),
            );
          },
          icon: const Icon(Icons.tune, color: Colors.white),
          label: const Text(
            'Préférences de découverte',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.bordeaux,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 2,
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          onPressed: () {
            _showLogoutDialog();
          },
          icon: const Icon(Icons.logout, color: AppTheme.bordeaux),
          label: const Text(
            'Se déconnecter',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.bordeaux,
            ),
          ),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            side: const BorderSide(color: AppTheme.bordeaux, width: 2),
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Se déconnecter',
          style: TextStyle(
            color: AppTheme.navy,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text(
          'Êtes-vous sûr de vouloir vous déconnecter ?',
          style: TextStyle(color: AppTheme.navy),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Annuler',
              style: TextStyle(color: AppTheme.navy),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await ref.read(authNotifierProvider.notifier).logout();
              // The router's refreshListenable will redirect to /login
              // automatically once the auth state becomes unauthenticated.
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.bordeaux,
            ),
            child: const Text(
              'Se déconnecter',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickPhoto() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1080,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        final bytes = await pickedFile.readAsBytes();
        final filename = 'photo_${DateTime.now().millisecondsSinceEpoch}.jpg';

        await ref.read(profileProvider.notifier).uploadPhotoBytes(bytes, filename);

        if (mounted) {
          final state = ref.read(profileProvider);
          if (state.error != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error!), backgroundColor: AppTheme.error),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Photo ajoutée !'), backgroundColor: AppTheme.bordeaux),
            );
          }
        }
      }
    } catch (e) {
      AppLogger.e('Failed to pick photo', error: e);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: $e'), backgroundColor: AppTheme.error),
        );
      }
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // Parse location (city, country)
    final locationParts = _locationController.text.split(',');
    final city = locationParts.isNotEmpty ? locationParts[0].trim() : '';
    final country = locationParts.length > 1 ? locationParts[1].trim() : '';

    // Call provider to save (full entity so all fields incl. spotify serialize).
    final spotify = _spotifyController.text.trim();
    if (_profile != null) {
      final updated = _profile!.copyWith(
        displayName: _displayNameController.text.trim(),
        bio: _bioController.text.trim(),
        birthday: _selectedBirthday ?? _profile!.birthday,
        city: city,
        country: country,
        spotifyPlaylistUrl: spotify.isEmpty ? null : spotify,
      );
      await ref.read(profileProvider.notifier).updateProfile(updated);
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
        _isEditing = false;
      });

      final state = ref.read(profileProvider);
      if (state.error == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profil mis à jour avec succès !'),
            backgroundColor: AppTheme.bordeaux,
          ),
        );
      }
    }
  }
}

/// A tappable feature card used in the profile's "Découvrir" section.
/// Matches the profile section style: white, circular(16), soft shadow.
class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget subtitle;
  final VoidCallback onTap;
  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: AppTheme.bordeaux.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: AppTheme.bordeaux, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.navy)),
                    const SizedBox(height: 2),
                    subtitle,
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: AppTheme.bordeaux),
            ]),
          ),
        ),
      ),
    );
  }
}
