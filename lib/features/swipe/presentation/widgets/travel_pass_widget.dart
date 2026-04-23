import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:tall_us/core/theme/app_theme.dart';

/// Travel Pass Widget - Swipe in different cities
class TravelPassWidget extends StatefulWidget {
  final bool isActive;
  final String? currentLocation;
  final DateTime? expiresAt;
  final List<String> availableCities;
  final Function(String location) onActivate;
  final VoidCallback onExtend;

  const TravelPassWidget({
    super.key,
    required this.isActive,
    this.currentLocation,
    this.expiresAt,
    required this.availableCities,
    required this.onActivate,
    required this.onExtend,
  });

  @override
  State<TravelPassWidget> createState() => _TravelPassWidgetState();
}

class _TravelPassWidgetState extends State<TravelPassWidget> {
  String? _selectedCity;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: widget.isActive
              ? [
                  AppTheme.blue.withValues(alpha: 0.1),
                  AppTheme.blue.withValues(alpha: 0.05),
                ]
              : [
                  AppTheme.gray100,
                  Colors.white,
                ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: widget.isActive
              ? AppTheme.blue.withValues(alpha: 0.3)
              : AppTheme.gray300,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: widget.isActive
                      ? AppTheme.blue.withValues(alpha: 0.1)
                      : AppTheme.gray200,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.flight_takeoff,
                  color: widget.isActive ? AppTheme.blue : AppTheme.gray600,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Travel Pass',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color:
                            widget.isActive ? AppTheme.blue : AppTheme.gray700,
                      ),
                    ),
                    if (widget.isActive && widget.currentLocation != null)
                      Text(
                        'Destination: ${widget.currentLocation}',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppTheme.blue.withValues(alpha: 0.7),
                        ),
                      )
                    else
                      Text(
                        'Rencontrez des personnes ailleurs',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppTheme.gray600,
                        ),
                      ),
                  ],
                ),
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
    final remaining = widget.expiresAt != null
        ? widget.expiresAt!.difference(DateTime.now())
        : Duration.zero;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timer and destination
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppTheme.blue.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(
                Icons.location_on,
                color: AppTheme.blue,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Temps Restant à ${widget.currentLocation ?? "destination"}',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppTheme.blue.withValues(alpha: 0.7),
                      ),
                    ),
                    StreamBuilder(
                      stream: Stream.periodic(const Duration(seconds: 1)),
                      builder: (context, snapshot) {
                        if (remaining.isNegative) {
                          return const Text(
                            'Expiré',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.gray600,
                            ),
                          );
                        }
                        final days = remaining.inDays;
                        final hours = remaining.inHours % 24;
                        final minutes = remaining.inMinutes % 60;
                        return Text(
                          '$daysj ${hours}h ${minutes}m',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.blue,
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

        // Active benefits
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
                    Icons.public,
                    color: AppTheme.blue,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Travel Pass Activé',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.blue,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '• Votre profil est visible à ${widget.currentLocation ?? "votre destination"}\n'
                '• Vous voyez les profils locaux de cette destination\n'
                '• Match avec des personnes avant votre voyage\n'
                '• Préparez vos rendez-vous à l\'avance',
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
          label: const Text('Prolonger le séjour'),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppTheme.blue,
            side: const BorderSide(color: AppTheme.blue),
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
                    Icons.travel_explore,
                    color: AppTheme.blue,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Voyagez Bientôt ?',
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
                'Changez votre destination pour match avec des personnes dans une autre ville avant votre voyage.',
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

        // Popular cities
        const Text(
          'Destinations Populaires',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppTheme.navy,
          ),
        ),
        const SizedBox(height: 12),

        // City grid
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 2,
          children: widget.availableCities.take(6).map((city) {
            final isSelected = _selectedCity == city;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedCity = isSelected ? null : city;
                });
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? AppTheme.blue : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? AppTheme.blue : AppTheme.gray300,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.location_city,
                      size: 14,
                      color: isSelected ? Colors.white : AppTheme.gray600,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        city,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? Colors.white : AppTheme.gray700,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),

        const SizedBox(height: 16),

        // Activate button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _selectedCity != null
                ? () => widget.onActivate(_selectedCity!)
                : null,
            icon: const Icon(Icons.flight),
            label: const Text('Activer Travel Pass'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.blue,
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
}

/// Travel Pass active indicator for status bar
class TravelPassIndicator extends StatelessWidget {
  final String destination;
  final DateTime expiresAt;

  const TravelPassIndicator({
    super.key,
    required this.destination,
    required this.expiresAt,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.blue,
            AppTheme.blue.withValues(alpha: 0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.flight_takeoff, color: Colors.white, size: 16),
          const SizedBox(width: 6),
          Text(
            destination,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ).animate().pulse(
          duration: const Duration(milliseconds: 2000),
          curve: Curves.easeInOut,
        );
  }
}

/// Travel Pass city selection dialog
class TravelPassCityDialog extends StatelessWidget {
  final List<String> availableCities;
  final Function(String) onCitySelected;

  const TravelPassCityDialog({
    super.key,
    required this.availableCities,
    required this.onCitySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Choisir une Destination',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.navy,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(Icons.close, color: AppTheme.gray600),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Sélectionnez une ville pour commencer à swiper',
              style: TextStyle(
                fontSize: 13,
                color: AppTheme.gray600,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 400,
              child: ListView.builder(
                itemCount: availableCities.length,
                itemBuilder: (context, index) {
                  final city = availableCities[index];
                  return ListTile(
                    leading: Icon(Icons.location_city, color: AppTheme.blue),
                    title: Text(city),
                    trailing: Icon(Icons.arrow_forward_ios, size: 14),
                    onTap: () {
                      onCitySelected(city);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
