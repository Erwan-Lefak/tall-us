import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:tall_us/core/theme/app_theme.dart';

/// Subscription tier enum
enum SubscriptionTier {
  free,
  gold,
  platinum,
}

/// Subscription plan
class SubscriptionPlan {
  final SubscriptionTier tier;
  final String name;
  final String description;
  final Color color;
  final IconData icon;
  final List<String> features;
  final double monthlyPrice;
  final double yearlyPrice;
  final int yearlyDiscount;

  SubscriptionPlan({
    required this.tier,
    required this.name,
    required this.description,
    required this.color,
    required this.icon,
    required this.features,
    required this.monthlyPrice,
    required this.yearlyPrice,
    this.yearlyDiscount = 20,
  });

  /// Get free plan
  static SubscriptionPlan get free => SubscriptionPlan(
    tier: SubscriptionTier.free,
    name: 'Gratuit',
    description: 'Pour commencer',
    color: AppTheme.gray600,
    icon: Icons.person_outline,
    features: [
      'Profils illimités',
      'Likes limités par jour',
      '1 Super Like par jour',
      'Publicités',
      'Filtres de base',
    ],
    monthlyPrice: 0,
    yearlyPrice: 0,
  );

  /// Get gold plan
  static SubscriptionPlan get gold => SubscriptionPlan(
    tier: SubscriptionTier.gold,
    name: 'Gold',
    description: 'Pour les utilisateurs sérieux',
    color: AppTheme.gold,
    icon: Icons.stars,
    features: [
      'Tout le plan Gratuit',
      'Likes illimités',
      '5 Super Likes par jour',
      'Pas de publicités',
      'Filtres avancés',
      'Mode Incognito (24h/mois)',
      'Remonter en arrière (illimité)',
      'Voir qui vous aime',
    ],
    monthlyPrice: 9.99,
    yearlyPrice: 79.99,
  );

  /// Get platinum plan
  static SubscriptionPlan get platinum => SubscriptionPlan(
    tier: SubscriptionTier.platinum,
    name: 'Platinum',
    description: 'L\'expérience ultime',
    color: AppTheme.bordeaux,
    icon: Icons.workspace_premium,
    features: [
      'Tout le plan Gold',
      'Super Likes illimités',
      'Boost gratuit par semaine',
      'Mode Incognito illimité',
      'Travel Pass inclus',
      'Priorité dans les profils',
      'Vérification prioritaire',
      'Support prioritaire',
    ],
    monthlyPrice: 19.99,
    yearlyPrice: 159.99,
  );
}

/// Premium Subscription Widget
class PremiumSubscriptionWidget extends StatefulWidget {
  final SubscriptionTier currentTier;
  final bool isYearly;
  final Function(SubscriptionTier, bool) onSubscribe;

  const PremiumSubscriptionWidget({
    super.key,
    required this.currentTier,
    this.isYearly = false,
    required this.onSubscribe,
  });

  @override
  State<PremiumSubscriptionWidget> createState() =>
      _PremiumSubscriptionWidgetState();
}

class _PremiumSubscriptionWidgetState
    extends State<PremiumSubscriptionWidget> {
  late bool _isYearly;
  SubscriptionTier? _selectedTier;

  @override
  void initState() {
    super.initState();
    _isYearly = widget.isYearly;
    _selectedTier = widget.currentTier;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          const Text(
            'Passez au Niveau Supérieur',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppTheme.navy,
            ),
          ).animate().fadeIn(duration: 300.ms),

          const SizedBox(height: 8),

          Text(
            'Débloquez des fonctionnalités exclusives pour plus de matchs',
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.gray600,
            ),
          ).animate().fadeIn(duration: 300.ms),

          const SizedBox(height: 24),

          // Billing toggle
          _buildBillingToggle().animate().fadeIn(duration: 300.ms).then(),

          const SizedBox(height: 24),

          // Plans
          ...[
            SubscriptionPlan.gold,
            SubscriptionPlan.platinum,
          ].map((plan) => _buildPlanCard(plan)).map((widget) =>
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: widget,
              ).animate().fadeIn(duration: 300.ms)),

          const SizedBox(height: 16),

          // Subscribe button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _selectedTier != null &&
                  _selectedTier != widget.currentTier
                  ? () => widget.onSubscribe(_selectedTier!, _isYearly)
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.bordeaux,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                _selectedTier != null && _selectedTier != widget.currentTier
                    ? 'S\'abonner à ${_selectedTier == SubscriptionTier.gold ? "Gold" : "Platinum"}'
                    : 'Sélectionnez un forfait',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ).animate().fadeIn(duration: 300.ms),

          const SizedBox(height: 12),

          // Cancel button
          if (widget.currentTier != SubscriptionTier.free)
            Center(
              child: TextButton(
                onPressed: () {
                  // TODO: Handle cancellation
                },
                child: Text(
                  'Annuler l\'abonnement',
                  style: TextStyle(
                    color: AppTheme.gray600,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBillingToggle() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppTheme.gray100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _isYearly = false;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: !_isYearly ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'Mensuel',
                  style: TextStyle(
                    color: !_isYearly ? AppTheme.navy : AppTheme.gray600,
                    fontWeight: !_isYearly ? FontWeight.bold : FontWeight.normal,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _isYearly = true;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _isYearly ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Annuel',
                      style: TextStyle(
                        color: _isYearly ? AppTheme.navy : AppTheme.gray600,
                        fontWeight: _isYearly ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.green,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '-20%',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanCard(SubscriptionPlan plan) {
    final price = _isYearly ? plan.yearlyPrice : plan.monthlyPrice;
    final isSelected = _selectedTier == plan.tier;
    final isCurrent = widget.currentTier == plan.tier;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTier = plan.tier;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              plan.color.withValues(alpha: 0.1),
              plan.color.withValues(alpha: 0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? plan.color
                : isCurrent
                    ? plan.color.withValues(alpha: 0.5)
                    : AppTheme.gray200,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: plan.color.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: plan.color.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        plan.icon,
                        color: plan.color,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              plan.name,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: plan.color,
                              ),
                            ),
                            if (isCurrent) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: plan.color.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  'Actuel',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: plan.color,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        Text(
                          plan.description,
                          style: TextStyle(
                            fontSize: 12,
                            color: AppTheme.gray600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                if (isSelected)
                  Icon(
                    Icons.check_circle,
                    color: plan.color,
                    size: 24,
                  ),
              ],
            ),

            const SizedBox(height: 12),

            // Price
            Row(
              baseline: TextBaseline.alphabetic,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              children: [
                Text(
                  _isYearly ? '${price.toStringAsFixed(2)}€' : '${price.toStringAsFixed(2)}€',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: plan.color,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  _isYearly ? '/an' : '/mois',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.gray600,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Features
            ...plan.features.map((feature) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: plan.color,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          feature,
                          style: TextStyle(
                            fontSize: 13,
                            color: AppTheme.gray700,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

/// Premium features comparison widget
class PremiumFeaturesComparison extends StatelessWidget {
  const PremiumFeaturesComparison({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Comparaison des Forfaits',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.navy,
            ),
          ),
          const SizedBox(height: 16),

          // Features table
          _buildFeatureRow('Likes', unlimited: true, gold: true, platinum: true),
          _buildFeatureRow('Super Likes', unlimited: false, gold: '5/jour', platinum: true),
          _buildFeatureRow('Mode Incognito', unlimited: false, gold: '24h/mois', platinum: true),
          _buildFeatureRow('Remonter', unlimited: false, gold: true, platinum: true),
          _buildFeatureRow('Boost', unlimited: false, gold: false, platinum: '1/semaine'),
          _buildFeatureRow('Travel Pass', unlimited: false, gold: false, platinum: true),
          _buildFeatureRow('Filtres avancés', unlimited: false, gold: true, platinum: true),
          _buildFeatureRow('Pas de pub', unlimited: false, gold: true, platinum: true),
        ],
      ),
    );
  }

  Widget _buildFeatureRow(
    String feature, {
    required bool unlimited,
    required dynamic gold,
    required dynamic platinum,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppTheme.gray200,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              feature,
              style: const TextStyle(
                fontSize: 13,
                color: AppTheme.navy,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: _buildValueCell(unlimited),
          ),
          Expanded(
            child: _buildValueCell(gold),
          ),
          Expanded(
            child: _buildValueCell(platinum, isHighlight: true),
          ),
        ],
      ),
    );
  }

  Widget _buildValueCell(dynamic value, {bool isHighlight = false}) {
    if (value is bool && value) {
      return Center(
        child: Icon(
          Icons.check_circle,
          color: isHighlight ? AppTheme.bordeaux : AppTheme.green,
          size: 20,
        ),
      );
    } else if (value is bool && !value) {
      return Center(
        child: Icon(
          Icons.cancel,
          color: AppTheme.gray400,
          size: 20,
        ),
      );
    } else if (value is String) {
      return Center(
        child: Text(
          value,
          style: TextStyle(
            fontSize: 11,
            color: isHighlight ? AppTheme.bordeaux : AppTheme.gray700,
            fontWeight: isHighlight ? FontWeight.bold : FontWeight.normal,
          ),
          textAlign: TextAlign.center,
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
