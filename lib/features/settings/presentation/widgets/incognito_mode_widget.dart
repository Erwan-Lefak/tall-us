import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:tall_us/core/theme/app_theme.dart';

/// Incognito Mode Widget - Browse profiles anonymously
class IncognitoModeWidget extends StatefulWidget {
  final bool isActive;
  final DateTime? activatedAt;
  final Function(bool) onToggle;
  final VoidCallback onExtend;

  const IncognitoModeWidget({
    super.key,
    required this.isActive,
    this.activatedAt,
    required this.onToggle,
    required this.onExtend,
  });

  @override
  State<IncognitoModeWidget> createState() => _IncognitoModeWidgetState();
}

class _IncognitoModeWidgetState extends State<IncognitoModeWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: widget.isActive
              ? [
                  AppTheme.navy.withValues(alpha: 0.1),
                  AppTheme.navy.withValues(alpha: 0.05),
                ]
              : [
                  AppTheme.gray100,
                  Colors.white,
                ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: widget.isActive
              ? AppTheme.navy.withValues(alpha: 0.3)
              : AppTheme.gray300,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: widget.isActive
                          ? AppTheme.navy.withValues(alpha: 0.1)
                          : AppTheme.gray200,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      widget.isActive
                          ? IncognitoMode.activeIcon
                          : Icons.visibility_off,
                      color: widget.isActive ? AppTheme.navy : AppTheme.gray600,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Mode Incognito',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: widget.isActive
                              ? AppTheme.navy
                              : AppTheme.gray700,
                        ),
                      ),
                      Text(
                        widget.isActive ? 'Activé' : 'Désactivé',
                        style: TextStyle(
                          fontSize: 13,
                          color: widget.isActive
                              ? AppTheme.navy.withValues(alpha: 0.7)
                              : AppTheme.gray600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              // Toggle switch
              Switch(
                value: widget.isActive,
                onChanged: widget.onToggle,
                activeColor: AppTheme.navy,
              ),
            ],
          ),

          if (widget.isActive) ...[
            const SizedBox(height: 16),
            _buildActiveContent(),
          ] else ...[
            const SizedBox(height: 16),
            _buildInactiveContent(),
          ],
        ],
      ),
    ).animate().fadeIn(duration: 300.ms);
  }

  Widget _buildActiveContent() {
    final remaining = widget.activatedAt != null
        ? const Duration(hours: 24) -
            DateTime.now().difference(widget.activatedAt!)
        : Duration.zero;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timer
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppTheme.navy.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(
                Icons.timer_outlined,
                color: AppTheme.navy,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Temps Restant',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppTheme.navy.withValues(alpha: 0.7),
                      ),
                    ),
                    StreamBuilder(
                      stream: Stream.periodic(const Duration(seconds: 1)),
                      builder: (context, snapshot) {
                        final hours = remaining.inHours;
                        final minutes = remaining.inMinutes % 60;
                        final seconds = remaining.inSeconds % 60;
                        return Text(
                          '$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.navy,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Benefits
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppTheme.gray200,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    color: AppTheme.green,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Mode Incognito Activé',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.navy,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '• Votre profil n\'apparaît pas dans les résultats de recherche\n'
                '• Les utilisateurs ne voient pas quand vous visitez leur profil\n'
                '• Vous pouvez naviguer en toute discrétion\n'
                '• Vos likes sont anonymes',
                style: TextStyle(
                  fontSize: 12,
                  color: AppTheme.gray700,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Extend button
        OutlinedButton.icon(
          onPressed: widget.onExtend,
          icon: const Icon(Icons.add),
          label: const Text('Prolonger de 24h'),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppTheme.navy,
            side: const BorderSide(color: AppTheme.navy),
          ),
        ),
      ],
    );
  }

  Widget _buildInactiveContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Description
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppTheme.gray200,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: AppTheme.bordeaux,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Qu\'est-ce que le Mode Incognito ?',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.navy,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Naviguez en toute discrétion sans que les autres utilisateurs ne le sachent.',
                style: TextStyle(
                  fontSize: 12,
                  color: AppTheme.gray700,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Features list
        _buildFeatureItem(
          Icons.visibility_off,
          'Rester invisible dans les recherches',
          'Votre profil n\'apparaît pas',
        ),
        const SizedBox(height: 12),
        _buildFeatureItem(
          Icons.remove_red_eye,
          'Visiter des profils anonymement',
          'Les utilisateurs ne le verront pas',
        ),
        const SizedBox(height: 12),
        _buildFeatureItem(
          IncognitoMode.activeIcon,
          'Likes anonymes',
          'Vos likes restent confidentiels',
        ),

        const SizedBox(height: 16),

        // Activate button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => widget.onToggle(true),
            icon: const Icon(Icons.flash_on),
            label: const Text('Activer le Mode Incognito'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.navy,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureItem(IconData icon, String title, String subtitle) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppTheme.navy.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: AppTheme.navy,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.navy,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 11,
                  color: AppTheme.gray600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class IncognitoMode {
  static IconData get activeIcon => Icons.incognito;

  static String get formattedDuration {
    return '24h';
  }

  static String get description {
    return 'Naviguez en toute discrétion';
  }
}
