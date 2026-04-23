import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tall_us/core/constants/app_constants.dart';
import 'package:tall_us/core/theme/app_theme.dart';
import 'package:tall_us/features/auth/presentation/providers/auth_providers.dart';
import 'package:tall_us/features/auth/presentation/providers/auth_state.dart';

/// Register Screen
///
/// Screen for new user registration
class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _displayNameController = TextEditingController();
  final _cityController = TextEditingController();
  final _heightController = TextEditingController();

  String _selectedGender = 'male';
  DateTime? _selectedBirthday;
  String _selectedCountryCode = 'FR';
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _acceptTerms = false;
  bool _isLoading = false;

  final List<Map<String, String>> _countries = [
    {'code': 'FR', 'name': 'France'},
    {'code': 'BE', 'name': 'Belgium'},
    {'code': 'CH', 'name': 'Switzerland'},
    {'code': 'LU', 'name': 'Luxembourg'},
    {'code': 'CA', 'name': 'Canada'},
    {'code': 'US', 'name': 'United States'},
    {'code': 'GB', 'name': 'United Kingdom'},
    {'code': 'DE', 'name': 'Germany'},
    {'code': 'NL', 'name': 'Netherlands'},
    {'code': 'ES', 'name': 'Spain'},
    {'code': 'IT', 'name': 'Italy'},
  ];

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _displayNameController.dispose();
    _cityController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!_acceptTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              const Text('Veuillez accepter les conditions d\'utilisation'),
          backgroundColor: AppTheme.bordeaux,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
      return;
    }

    if (_selectedBirthday == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Veuillez sélectionner votre date de naissance'),
          backgroundColor: AppTheme.bordeaux,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final height = int.tryParse(_heightController.text) ?? 0;

    await ref.read(authNotifierProvider.notifier).register(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          displayName: _displayNameController.text.trim(),
          gender: _selectedGender,
          height: height,
          birthday: _selectedBirthday!,
          countryCode: _selectedCountryCode,
          city: _cityController.text.trim(),
        );

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _selectBirthday() async {
    final now = DateTime.now();
    final initialDate = _selectedBirthday ?? DateTime(now.year - 25);
    final firstDate = DateTime(now.year - 120);
    final lastDate = DateTime(now.year - 18);

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
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
      setState(() {
        _selectedBirthday = picked;
      });
    }
  }

  int _calculateAge(DateTime birthday) {
    final now = DateTime.now();
    int age = now.year - birthday.year;

    if (now.month < birthday.month ||
        (now.month == birthday.month && now.day < birthday.day)) {
      age--;
    }

    return age;
  }

  @override
  Widget build(BuildContext context) {
    // Listen to auth state changes
    ref.listen<AuthState>(authNotifierProvider, (previous, next) {
      next.maybeWhen(
        error: (message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              backgroundColor: AppTheme.bordeaux,
              behavior: SnackBarBehavior.floating,
              margin: const EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          );
        },
        authenticated: (_) {
          // Navigate to home screen on successful registration
          context.go('/home');
        },
        orElse: () {},
      );
    });

    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      backgroundColor: AppTheme.offWhite,
      appBar: AppBar(
        backgroundColor: AppTheme.offWhite,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.navy),
          onPressed: () => context.go('/login'),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 20,
            bottom: keyboardHeight > 0 ? 24 : 40,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Logo
                Center(
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.white,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        'assets/images/logo.jpg',
                        width: 120,
                        height: 120,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Header
                Text(
                  'Créer un compte',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: AppTheme.navy,
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Rejoignez la communauté de grands célibataires',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.navy.withValues(alpha: 0.7),
                      ),
                ),

                const SizedBox(height: 32),

                // Email
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  enabled: !_isLoading,
                  decoration: _buildInputDecoration(
                    label: 'Email',
                    hintText: 'Entrez votre email',
                    icon: Icons.email_outlined,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Veuillez entrer votre email';
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                        .hasMatch(value)) {
                      return 'Veuillez entrer un email valide';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // Password
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  textInputAction: TextInputAction.next,
                  enabled: !_isLoading,
                  decoration: _buildInputDecoration(
                    label: 'Mot de passe',
                    hintText: 'Créez un mot de passe',
                    icon: Icons.lock_outlined,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer un mot de passe';
                    }
                    if (value.length < 8) {
                      return 'Le mot de passe doit contenir au moins 8 caractères';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // Confirm Password
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirmPassword,
                  textInputAction: TextInputAction.next,
                  enabled: !_isLoading,
                  decoration: _buildInputDecoration(
                    label: 'Confirmer le mot de passe',
                    hintText: 'Confirmez votre mot de passe',
                    icon: Icons.lock_outlined,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez confirmer votre mot de passe';
                    }
                    if (value != _passwordController.text) {
                      return 'Les mots de passe ne correspondent pas';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // Display Name
                TextFormField(
                  controller: _displayNameController,
                  textInputAction: TextInputAction.next,
                  enabled: !_isLoading,
                  decoration: _buildInputDecoration(
                    label: 'Nom d\'affichage',
                    hintText: 'Comment devons-nous vous appeler ?',
                    icon: Icons.person_outlined,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Veuillez entrer votre nom d\'affichage';
                    }
                    if (value.length < 2) {
                      return 'Le nom doit contenir au moins 2 caractères';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // Gender
                InputDecorator(
                  decoration: _buildInputDecoration(
                    label: 'Genre',
                    hintText: 'Sélectionnez votre genre',
                    icon: Icons.wc_outlined,
                  ),
                  child: SegmentedButton<String>(
                    segments: const [
                      ButtonSegment(
                        value: 'male',
                        label: Text('Homme'),
                        icon: Icon(Icons.male, size: 20),
                      ),
                      ButtonSegment(
                        value: 'female',
                        label: Text('Femme'),
                        icon: Icon(Icons.female, size: 20),
                      ),
                    ],
                    selected: {_selectedGender},
                    onSelectionChanged: _isLoading
                        ? null
                        : (Set<String> newSelection) {
                            setState(() {
                              _selectedGender = newSelection.first;
                            });
                          },
                  ),
                ),

                const SizedBox(height: 20),

                // Height
                TextFormField(
                  controller: _heightController,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  enabled: !_isLoading,
                  decoration: _buildInputDecoration(
                    label: 'Taille (cm)',
                    hintText: 'Votre taille en centimètres',
                    icon: Icons.height,
                    suffixText: 'cm',
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Veuillez entrer votre taille';
                    }
                    final height = int.tryParse(value);
                    if (height == null) {
                      return 'Veuillez entrer un nombre valide';
                    }
                    final minHeight = _selectedGender == 'male'
                        ? AppConstants.minHeightMale
                        : AppConstants.minHeightFemale;
                    if (height < minHeight) {
                      final genderText =
                          _selectedGender == 'male' ? 'hommes' : 'femmes';
                      return 'La taille minimum pour les $genderText est de $minHeight cm';
                    }
                    if (height > 250) {
                      return 'La taille doit être inférieure à 250 cm';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // Birthday
                GestureDetector(
                  onTap: _isLoading ? null : _selectBirthday,
                  child: InputDecorator(
                    decoration: _buildInputDecoration(
                      label: 'Date de naissance',
                      hintText: 'Sélectionnez votre date de naissance',
                      icon: Icons.cake_outlined,
                    ),
                    child: _selectedBirthday == null
                        ? Text(
                            'Sélectionnez votre date de naissance',
                            style: TextStyle(
                              color: AppTheme.navy.withValues(alpha: 0.5),
                              fontSize: 16,
                            ),
                          )
                        : Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                size: 20,
                                color: AppTheme.bordeaux,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  '${_selectedBirthday!.day}/${_selectedBirthday!.month}/${_selectedBirthday!.year} (${_calculateAge(_selectedBirthday!)} ans)',
                                  style: const TextStyle(
                                    color: AppTheme.navy,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ),
                ),

                const SizedBox(height: 20),

                // Country
                InputDecorator(
                  decoration: _buildInputDecoration(
                    label: 'Pays',
                    hintText: 'Sélectionnez votre pays',
                    icon: Icons.public_outlined,
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedCountryCode,
                      isExpanded: true,
                      iconEnabledColor: AppTheme.bordeaux,
                      dropdownColor: Colors.white,
                      items: _countries.map((country) {
                        return DropdownMenuItem(
                          value: country['code'],
                          child: Row(
                            children: [
                              Text(
                                country['flag'] ?? '',
                                style: const TextStyle(fontSize: 20),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                country['name']!,
                                style: const TextStyle(
                                  color: AppTheme.navy,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: _isLoading
                          ? null
                          : (value) {
                              if (value != null) {
                                setState(() {
                                  _selectedCountryCode = value;
                                });
                              }
                            },
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // City
                TextFormField(
                  controller: _cityController,
                  textInputAction: TextInputAction.done,
                  enabled: !_isLoading,
                  decoration: _buildInputDecoration(
                    label: 'Ville',
                    hintText: 'Entrez votre ville',
                    icon: Icons.location_city_outlined,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Veuillez entrer votre ville';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 24),

                // Terms checkbox
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: Checkbox(
                        value: _acceptTerms,
                        onChanged: _isLoading
                            ? null
                            : (value) {
                                setState(() {
                                  _acceptTerms = value ?? false;
                                });
                              },
                        activeColor: AppTheme.bordeaux,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        onTap: _isLoading
                            ? null
                            : () {
                                setState(() {
                                  _acceptTerms = !_acceptTerms;
                                });
                              },
                        child: Text(
                          'J\'accepte les conditions d\'utilisation et la politique de confidentialité',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppTheme.navy.withValues(alpha: 0.7),
                                  ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Register button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleRegister,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.bordeaux,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor:
                          AppTheme.bordeaux.withValues(alpha: 0.6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text(
                            'Créer un compte',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 16),

                // Already have account link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Vous avez déjà un compte ? ",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme.navy.withValues(alpha: 0.7),
                          ),
                    ),
                    TextButton(
                      onPressed: _isLoading ? null : () => context.go('/login'),
                      child: Text(
                        'Se connecter',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppTheme.bordeaux,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration({
    required String label,
    required String hintText,
    required IconData icon,
    Widget? suffixIcon,
    String? suffixText,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hintText,
      prefixIcon: Icon(icon),
      suffixIcon: suffixIcon,
      suffixText: suffixText,
      suffixStyle: const TextStyle(
        color: AppTheme.navy,
        fontWeight: FontWeight.bold,
      ),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: AppTheme.bordeaux,
          width: 2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Colors.red,
          width: 1,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Colors.red,
          width: 2,
        ),
      ),
    );
  }
}
