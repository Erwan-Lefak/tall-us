import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tall_us/core/theme/app_theme.dart';
import 'package:tall_us/core/widgets/skeleton/skeleton_loading.dart';
import 'package:tall_us/features/profile/domain/entities/user_profile_entity.dart';
import 'package:tall_us/features/profile/domain/entities/discovery_preferences_entity.dart';
import 'package:tall_us/features/profile/domain/entities/prompt_entity.dart';
import 'package:tall_us/features/profile/presentation/widgets/prompt_selector_widget.dart';
import 'package:tall_us/features/profile/presentation/widgets/interests_selector_widget.dart';
import 'package:tall_us/features/profile/presentation/widgets/photo_gallery_editor.dart';
import 'package:tall_us/features/settings/presentation/screens/settings_screen.dart';

/// Main profile screen with view and edit modes
class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool _isEditing = false;

  // Dummy data - will be replaced with provider
  UserProfileEntity? _profile;
  DiscoveryPreferencesEntity? _preferences;

  // NEW: Prompts and interests
  List<UserPrompt> _prompts = [];
  List<String> _interests = [];

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    // TODO: Load from provider
    setState(() {
      _profile = UserProfileEntity(
        id: '1',
        userId: 'user1',
        displayName: 'Thomas',
        birthday: DateTime.now().subtract(const Duration(days: 8000)),
        heightCm: 192,
        city: 'Paris',
        country: 'France',
        gender: 'homme',
        bio:
            'Passionné de voyages et de randonnée. Je cherche une partenaire pour partager mes aventures !',
        photoUrls: [
          'https://via.placeholder.com/400x600',
          'https://via.placeholder.com/400x601',
          'https://via.placeholder.com/400x602',
        ],
        // NEW: Sample prompts
        prompts: const [
          UserPrompt(
            promptId: 'convo_bucket_list',
            promptText: 'Sur ma bucket list cette année :',
            answer: 'Faire un tour du monde et visiter le Japon !',
            displayOrder: 0,
          ),
        ],
        // NEW: Sample interests
        interests: [
          'Voyage',
          'Randonnée',
          'Photographie',
          'Fitness',
          'Cuisine'
        ],
      );
      _preferences = DiscoveryPreferencesEntity(
        userId: 'user1',
        minAge: 18,
        maxAge: 35,
        minHeightCm: 165,
        maxHeightCm: 210,
        preferredGenders: ['femme'],
        maxDistanceKm: 50,
        city: 'Paris',
        country: 'France',
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_profile == null) {
      return Scaffold(
        body: Center(
          child: SkeletonProfileCard(),
        ),
      );
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App bar
          _buildAppBar(),

          // Content
          SliverToBoxAdapter(
            child: _isEditing ? _buildEditMode() : _buildViewMode(),
          ),
        ],
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
        // Settings button
        if (!_isEditing)
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ),
              );
            },
          ),
        // Edit button
        if (!_isEditing)
          IconButton(
            icon: Icon(
              _isEditing ? Icons.close : Icons.edit,
              color: AppTheme.navy,
            ),
            onPressed: () {
              setState(() {
                _isEditing = !_isEditing;
              });
            },
          ),
        if (_isEditing)
          IconButton(
            icon: const Icon(Icons.check, color: AppTheme.bordeaux),
            onPressed: _saveProfile,
          ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildViewMode() {
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

          // Prompts (UPDATED - Now functional)
          _buildPromptsSection(),

          const SizedBox(height: 24),

          // Interests (NEW)
          _buildInterestsSection(),

          const SizedBox(height: 24),

          // Work & Education (NEW)
          _buildWorkEducationSection(),

          const SizedBox(height: 24),

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

  Widget _buildEditMode() {
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
          // Photos edit
          _buildPhotosEditSection(),

          const SizedBox(height: 24),

          // Basic info edit
          _buildBasicInfoEditSection(),

          const SizedBox(height: 24),

          // Bio edit
          _buildBioEditSection(),

          const SizedBox(height: 24),

          // Prompts edit (UPDATED)
          _buildPromptsEditSection(),

          const SizedBox(height: 24),

          // Interests edit (NEW)
          _buildInterestsEditSection(),

          const SizedBox(height: 24),

          // Work & Education edit (NEW)
          _buildWorkEducationEditSection(),

          const SizedBox(height: 48),
        ],
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
                        child: const Icon(Icons.person,
                            size: 50, color: Colors.grey),
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: PhotoGalleryEditor(
        photoUrls: _profile!.photoUrls,
        onPhotosUpdated: (photos) {
          setState(() {
            _profile = _profile!.copyWith(photoUrls: photos);
          });
        },
        maxPhotos: 6,
        allowReorder: true,
        allowDelete: true,
      ),
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
            initialValue: _profile!.displayName,
            decoration: const InputDecoration(
              labelText: 'Prénom',
              prefixIcon: Icon(Icons.person),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            initialValue: '${_profile!.city}, ${_profile!.country}',
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
            initialValue: _profile!.bio,
            maxLines: 5,
            maxLength: 500,
            decoration: const InputDecoration(
              hintText: 'Parlez-nous de vous...',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromptsSection() {
    if (_profile!.prompts.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Mes Prompts',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.navy,
            ),
          ),
          const SizedBox(height: 12),
          ...List.generate(_profile!.prompts.length, (index) {
            final prompt = _profile!.prompts[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.bordeaux.withValues(alpha: 0.05),
                      AppTheme.navy.withValues(alpha: 0.02),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppTheme.bordeaux.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      prompt.promptText,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.navy,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      prompt.answer,
                      style: TextStyle(
                        fontSize: 16,
                        color: AppTheme.navy.withValues(alpha: 0.8),
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildInterestsSection() {
    if (_profile!.interests.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Mes Intérêts',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.navy,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _profile!.interests.map((interest) {
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppTheme.bordeaux,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.bordeaux.withValues(alpha: 0.3),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  interest,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkEducationSection() {
    final hasWork = _profile!.jobTitle != null || _profile!.company != null;
    final hasEducation = _profile!.school != null;

    if (!hasWork && !hasEducation) {
      return const SizedBox.shrink();
    }

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
            'Travail & Études',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.navy,
            ),
          ),
          const SizedBox(height: 12),
          if (hasWork) ...[
            Row(
              children: [
                const Icon(Icons.work, color: AppTheme.bordeaux, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${_profile!.jobTitle ?? ''}${_profile!.company != null ? ' chez ${_profile!.company}' : ''}',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppTheme.navy.withValues(alpha: 0.8),
                    ),
                  ),
                ),
              ],
            ),
          ],
          if (hasEducation) ...[
            if (hasWork) const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.school, color: AppTheme.bordeaux, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _profile!.school ?? '',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppTheme.navy.withValues(alpha: 0.8),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPromptsEditSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: PromptSelectorWidget(
        existingPrompts: _profile!.prompts,
        onPromptsUpdated: (prompts) {
          setState(() {
            _profile = _profile!.copyWith(prompts: prompts);
          });
        },
        maxPrompts: 3,
      ),
    );
  }

  Widget _buildInterestsEditSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: InterestsSelectorWidget(
        selectedInterests: _profile!.interests,
        onInterestsUpdated: (interests) {
          setState(() {
            _profile = _profile!.copyWith(interests: interests);
          });
        },
        maxInterests: 5,
      ),
    );
  }

  Widget _buildWorkEducationEditSection() {
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
            'Travail & Études',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.navy,
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            initialValue: _profile!.jobTitle,
            decoration: const InputDecoration(
              labelText: 'Titre du poste',
              prefixIcon: Icon(Icons.work),
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              _profile = _profile!.copyWith(jobTitle: value);
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            initialValue: _profile!.company,
            decoration: const InputDecoration(
              labelText: 'Entreprise',
              prefixIcon: Icon(Icons.business),
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              _profile = _profile!.copyWith(company: value);
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            initialValue: _profile!.school,
            decoration: const InputDecoration(
              labelText: 'École / Université',
              prefixIcon: Icon(Icons.school),
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              _profile = _profile!.copyWith(school: value);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPreferencesButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () {
            // TODO: Navigate to preferences
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
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: Logout
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

  void _saveProfile() {
    // TODO: Save profile
    setState(() {
      _isEditing = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profil mis à jour avec succès !'),
        backgroundColor: AppTheme.bordeaux,
      ),
    );
  }
}
