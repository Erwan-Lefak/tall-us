import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tall_us/core/theme/app_theme.dart';
import 'package:tall_us/features/auth/presentation/providers/auth_providers.dart';

class SubscriptionScreen extends ConsumerWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final role = ref.watch(authenticatedUserProvider)?.role;
    final currentPlanId = _planIdForRole(role);

    return Scaffold(
      backgroundColor: const Color(0xFFFAF8F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.navy),
          onPressed: () => context.pop(),
        ),
        title: const Text('Mon abonnement',
            style: TextStyle(
                color: AppTheme.navy,
                fontSize: 18,
                fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Current plan
          Container(
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
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppTheme.gold.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.workspace_premium,
                    color: AppTheme.gold, size: 26),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        'Forfait actuel : ${_plans.firstWhere((p) => p.id == currentPlanId).name}',
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.navy)),
                    const SizedBox(height: 4),
                    Text(
                        'Débloque plus de likes, de filtres et d\'avantages.',
                        style: TextStyle(
                            fontSize: 13,
                            color: AppTheme.navy.withValues(alpha: 0.6))),
                  ],
                ),
              ),
            ]),
          ),
          const SizedBox(height: 24),
          const Text('Choisis ton forfait',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.navy)),
          const SizedBox(height: 14),
          ..._plans.map((p) => _PlanCard(
                plan: p,
                isCurrent: p.id == currentPlanId,
              )),
          const SizedBox(height: 16),
          Text(
            'Le paiement Stripe sera bientôt disponible. En attendant, les forfaits sont affichés à titre informatif.',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 12, color: AppTheme.navy.withValues(alpha: 0.5)),
          ),
        ],
      ),
    );
  }

  String _planIdForRole(role) {
    final name = role?.maybeWhen(
      premium: () => 'premium',
      admin: () => 'admin',
      orElse: () => 'free',
    );
    switch (name) {
      case 'premium':
        return 'tall';
      case 'admin':
        return 'legende';
      default:
        return 'freemium';
    }
  }
}

class _Plan {
  final String id;
  final String name;
  final String price;
  final List<String> perks;
  final bool featured;
  const _Plan(this.id, this.name, this.price, this.perks,
      {this.featured = false});
}

const _plans = [
  _Plan('freemium', 'Freemium', 'Gratuit', [
    '5 likes par jour',
    'Swipes illimités',
    'Messagerie avec tes matchs',
  ]),
  _Plan('tall', 'Tall', '14,99 €/mois', [
    '15 likes par jour',
    '5 super likes par jour',
    'Filtres avancés (distance, taille, intention)',
    'Sans publicité',
  ], featured: true),
  _Plan('elite', 'Élite', '24,99 €/mois', [
    'Likes illimités',
    'Voir combien de likes tu as reçus',
    'Appels vidéo',
    'Tout le forfait Tall',
  ]),
  _Plan('legende', 'Légende', '30,99 €/mois', [
    'Boosts illimités',
    'Accès aux événements + codes réductions',
    'Coaching 30 min avec un pro',
    'Badge Platinum + matching EU',
    'Tout le forfait Élite',
  ]),
];

class _PlanCard extends StatelessWidget {
  final _Plan plan;
  final bool isCurrent;
  const _PlanCard({required this.plan, required this.isCurrent});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: plan.featured
            ? Border.all(color: AppTheme.bordeaux, width: 2)
            : Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Expanded(
              child: Text(plan.name,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: plan.featured
                          ? AppTheme.bordeaux
                          : AppTheme.navy)),
            ),
            if (plan.featured)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppTheme.bordeaux,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text('Populaire',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w700)),
              ),
          ]),
          const SizedBox(height: 4),
          Text(plan.price,
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.navy.withValues(alpha: 0.7))),
          const SizedBox(height: 12),
          ...plan.perks.map((p) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.check,
                        color: AppTheme.bordeaux, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                        child: Text(p,
                            style: TextStyle(
                                fontSize: 13,
                                color: AppTheme.navy.withValues(alpha: 0.8)))),
                  ],
                ),
              )),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: isCurrent
                ? OutlinedButton(
                    onPressed: null,
                    style: OutlinedButton.styleFrom(
                        foregroundColor: AppTheme.navy),
                    child: const Text('Forfait actuel'),
                  )
                : ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text(
                                'Bientôt : paiement Stripe pour ce forfait.'),
                            backgroundColor: AppTheme.bordeaux),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: plan.featured
                          ? AppTheme.bordeaux
                          : AppTheme.navy,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text('Passer à ${plan.name}'),
                  ),
          ),
        ],
      ),
    );
  }
}
