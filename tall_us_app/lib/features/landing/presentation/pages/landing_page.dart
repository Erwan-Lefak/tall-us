import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:tall_us/core/theme/app_theme.dart';

/// Landing Page for Tall Us
///
/// A modern, responsive landing page showcasing the dating app for tall people
class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: const [
            // Hero Section
            _HeroSection(),

            // Features Section
            _FeaturesSection(),

            // How It Works Section
            _HowItWorksSection(),

            // CTA Section
            _CTASection(),

            // Footer
            _Footer(),
          ],
        ),
      ),
    );
  }
}

/// Hero Section
class _HeroSection extends StatelessWidget {
  const _HeroSection();

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.sizeOf(context).width > 900;

    return Container(
      height: isDesktop ? 700 : 500,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.bordeaux,
            AppTheme.bordeaux.withValues(alpha: 0.8),
            AppTheme.navy.withValues(alpha: 0.9),
          ],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: isDesktop ? 80 : 24),
          child: Column(
            children: [
              // Navigation Bar
              const _NavBar(),

              const Spacer(),

              // Hero Content
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo
                      const _Logo(size: 80),
                      const SizedBox(height: 24),

                      // Tagline
                      Text(
                        'Date Tall. Date Proud.',
                        style: TextStyle(
                          fontSize: isDesktop ? 64 : 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          height: 1.2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),

                      // Subtitle
                      Text(
                        'The first dating app exclusively for tall people.\nFind meaningful connections with people who understand your world.',
                        style: TextStyle(
                          fontSize: isDesktop ? 24 : 18,
                          color: Colors.white.withValues(alpha: 0.9),
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 40),

                      // CTA Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _DownloadButton(
                            icon: Icons.phone_android,
                            label: 'Get for Android',
                            onPressed: () => _launchUrl('https://play.google.com'),
                          ),
                          const SizedBox(width: 16),
                          _DownloadButton(
                            icon: Icons.phone_iphone,
                            label: 'Get for iOS',
                            onPressed: () => _launchUrl('https://apps.apple.com'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}

/// Logo Widget
class _Logo extends StatelessWidget {
  final double size;

  const _Logo({required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(size * 0.2),
      ),
      child: Center(
        child: Text(
          'TU',
          style: TextStyle(
            fontSize: size * 0.5,
            fontWeight: FontWeight.bold,
            color: AppTheme.bordeaux,
          ),
        ),
      ),
    );
  }
}

/// Navigation Bar
class _NavBar extends StatelessWidget {
  const _NavBar();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const _Logo(size: 40),
        Row(
          children: [
            _NavLink(label: 'Features', onPressed: () {}),
            const SizedBox(width: 24),
            _NavLink(label: 'How It Works', onPressed: () {}),
            const SizedBox(width: 24),
            _NavLink(label: 'About', onPressed: () {}),
            const SizedBox(width: 24),
            _NavLink(label: 'Contact', onPressed: () {}),
          ],
        ),
      ],
    );
  }
}

/// Navigation Link
class _NavLink extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const _NavLink({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

/// Download Button
class _DownloadButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const _DownloadButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: AppTheme.bordeaux,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}

/// Features Section
class _FeaturesSection extends StatelessWidget {
  const _FeaturesSection();

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.sizeOf(context).width > 900;

    return Container(
      padding: EdgeInsets.symmetric(vertical: isDesktop ? 100 : 60),
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: isDesktop ? 80 : 24),
        child: Column(
          children: [
            // Section Title
            Text(
              'Why Tall Us?',
              style: TextStyle(
                fontSize: isDesktop ? 48 : 32,
                fontWeight: FontWeight.bold,
                color: AppTheme.navy,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Features designed specifically for tall singles',
              style: TextStyle(
                fontSize: isDesktop ? 20 : 16,
                color: AppTheme.navy.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 60),

            // Features Grid
            Wrap(
              spacing: 32,
              runSpacing: 32,
              children: const [
                _FeatureCard(
                  icon: Icons.height,
                  title: 'Height Verification',
                  description:
                      'Verified height profiles mean you can trust what you see. No more surprises on the first date!',
                ),
                _FeatureCard(
                  icon: Icons.filter_alt,
                  title: 'Height-Based Matching',
                  description:
                      'Filter by height preferences to find your perfect match who meets your criteria.',
                ),
                _FeatureCard(
                  icon: Icons.explore,
                  title: 'Nearby Discovery',
                  description:
                      'Find tall singles in your area using geolocation-based matching.',
                ),
                _FeatureCard(
                  icon: Icons.chat,
                  title: 'Instant Messaging',
                  description:
                      'Connect instantly with built-in chat and real-time messaging.',
                ),
                _FeatureCard(
                  icon: Icons.security,
                  title: 'Safe & Secure',
                  description:
                      'Your privacy is our priority with advanced security features.',
                ),
                _FeatureCard(
                  icon: Icons.workspace_premium,
                  title: 'Premium Features',
                  description:
                      'Unlock unlimited swipes, see who likes you, and more with Premium.',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Feature Card
class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.sizeOf(context).width > 900;
    final cardWidth = isDesktop ? 350.0 : double.infinity;

    return SizedBox(
      width: cardWidth,
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppTheme.bordeaux.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  icon,
                  size: 32,
                  color: AppTheme.bordeaux,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: TextStyle(
                  fontSize: isDesktop ? 20 : 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.navy,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: TextStyle(
                  fontSize: 16,
                  color: AppTheme.navy.withValues(alpha: 0.7),
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// How It Works Section
class _HowItWorksSection extends StatelessWidget {
  const _HowItWorksSection();

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.sizeOf(context).width > 900;

    return Container(
      padding: EdgeInsets.symmetric(vertical: isDesktop ? 100 : 60),
      color: AppTheme.navy.withValues(alpha: 0.05),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: isDesktop ? 80 : 24),
        child: Column(
          children: [
            // Section Title
            Text(
              'How It Works',
              style: TextStyle(
                fontSize: isDesktop ? 48 : 32,
                fontWeight: FontWeight.bold,
                color: AppTheme.navy,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Start connecting in 3 simple steps',
              style: TextStyle(
                fontSize: isDesktop ? 20 : 16,
                color: AppTheme.navy.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 60),

            // Steps
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                _StepCard(
                  number: '1',
                  title: 'Create Profile',
                  description:
                      'Sign up with your email and create your profile with photos.',
                ),
                _StepCard(
                  number: '2',
                  title: 'Verify Height',
                  description:
                      'Upload a verification photo to confirm your height.',
                ),
                _StepCard(
                  number: '3',
                  title: 'Start Matching',
                  description:
                      'Swipe through profiles and match with tall singles.',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Step Card
class _StepCard extends StatelessWidget {
  final String number;
  final String title;
  final String description;

  const _StepCard({
    required this.number,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.sizeOf(context).width > 900;

    return SizedBox(
      width: isDesktop ? 300 : 250,
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppTheme.bordeaux,
              borderRadius: BorderRadius.circular(40),
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            title,
            style: TextStyle(
              fontSize: isDesktop ? 22 : 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.navy,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: TextStyle(
              fontSize: isDesktop ? 16 : 14,
              color: AppTheme.navy.withValues(alpha: 0.7),
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// CTA Section
class _CTASection extends StatelessWidget {
  const _CTASection();

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.sizeOf(context).width > 900;

    return Container(
      padding: EdgeInsets.symmetric(vertical: isDesktop ? 100 : 60),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.bordeaux,
            AppTheme.bordeaux.withValues(alpha: 0.9),
          ],
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: isDesktop ? 80 : 24),
        child: Column(
          children: [
            // Section Title
            Text(
              'Ready to Find Your Perfect Match?',
              style: TextStyle(
                fontSize: isDesktop ? 48 : 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Join thousands of tall singles finding meaningful connections.',
              style: TextStyle(
                fontSize: isDesktop ? 20 : 16,
                color: Colors.white.withValues(alpha: 0.9),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),

            // CTA Button
            ElevatedButton(
              onPressed: () => _launchUrl('https://tallus.app/signup'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppTheme.bordeaux,
                padding: const EdgeInsets.symmetric(
                  horizontal: 48,
                  vertical: 20,
                ),
                textStyle: TextStyle(
                  fontSize: isDesktop ? 20 : 18,
                  fontWeight: FontWeight.bold,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text('Get Started Free'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Footer
class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.sizeOf(context).width > 900;

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: isDesktop ? 60 : 40,
        horizontal: isDesktop ? 80 : 24,
      ),
      color: AppTheme.navy,
      child: Column(
        children: [
          // Logo
          const _Logo(size: 40),
          const SizedBox(height: 24),

          // Links
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _FooterLink(label: 'Privacy Policy', onPressed: () {}),
              const SizedBox(width: 24),
              _FooterLink(label: 'Terms of Service', onPressed: () {}),
              const SizedBox(width: 24),
              _FooterLink(label: 'Safety Tips', onPressed: () {}),
              const SizedBox(width: 24),
              _FooterLink(label: 'Contact', onPressed: () {}),
            ],
          ),
          const SizedBox(height: 24),

          // Copyright
          Text(
            '© 2024 Tall Us. All rights reserved.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}

/// Footer Link
class _FooterLink extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const _FooterLink({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        label,
        style: TextStyle(
          color: Colors.white.withValues(alpha: 0.8),
          fontSize: 14,
        ),
      ),
    );
  }
}

/// Launch URL helper
void _launchUrl(String urlString) async {
  final url = Uri.parse(urlString);
  if (await canLaunchUrl(url)) {
    await launchUrl(url);
  }
}
