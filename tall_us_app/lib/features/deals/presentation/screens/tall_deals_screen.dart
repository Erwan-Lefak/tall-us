import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tall_us/core/theme/app_theme.dart';

class TallDealsScreen extends StatelessWidget {
  const TallDealsScreen({super.key});

  static const _modeDeals = [
    ('👔', 'American Tall', 'Vêtements taillés pour les grandes tailles (homme).', 'Partenaire'),
    ('👗', 'Long Tall Sally', 'Mode féminine pour femmes de 1m75 et plus.', 'Partenaire'),
    ('🛍️', 'ASOS Tall', 'Sélection « Tall » : jeans, robes et manteaux longs.', 'Sélection'),
    ('👞', 'Duke & Dexter', 'Chaussures grandes pointures, style britannique.', 'Partenaire'),
  ];

  static const _travelDeals = [
    ('✈️', 'Sièges extra-leg', 'Réserve les rangées avec plus d\'espace jambes (sorties de secours).', 'Conseil'),
    ('🚆', 'SNCF Connect', 'Privilégie les places « Premiere » ou fenêtre couloir pour les jambes.', 'Conseil'),
    ('🏨', 'Hôtels grands lits', 'Filtre « lit king-size » + douches hautes lors de la réservation.', 'Conseil'),
    ('🚗', 'Location SUV', 'Les SUV offrent plus d\'espace conducteur et passager.', 'Conseil'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF8F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.navy),
          onPressed: () => context.pop(),
        ),
        title: const Text('Bons plans Tall',
            style: TextStyle(
                color: AppTheme.navy,
                fontSize: 18,
                fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _intro(),
          const SizedBox(height: 20),
          _section('Mode', _modeDeals),
          const SizedBox(height: 24),
          _section('Voyage & confort', _travelDeals),
          const SizedBox(height: 16),
          Text(
            'D\'autres marques et réductions exclusives arrivent bientôt pour les membres Légende.',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 12, color: AppTheme.navy.withValues(alpha: 0.5)),
          ),
        ],
      ),
    );
  }

  Widget _intro() => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
              colors: [AppTheme.navy, AppTheme.bordeaux]),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(children: [
          const Icon(Icons.redeem, color: Colors.white, size: 32),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Pensé pour les grandes tailles',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w800)),
                SizedBox(height: 4),
                Text(
                    'Marques de mode, conseils voyage et confort : tout ce qui rend la vie plus simple quand on est grand.',
                    style: TextStyle(color: Colors.white70, fontSize: 13)),
              ],
            ),
          ),
        ]),
      );

  Widget _section(String title, List<(String, String, String, String)> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppTheme.navy)),
        const SizedBox(height: 10),
        ...items.map((d) => _DealCard(
              emoji: d.$1,
              name: d.$2,
              description: d.$3,
              tag: d.$4,
            )),
      ],
    );
  }
}

class _DealCard extends StatelessWidget {
  final String emoji;
  final String name;
  final String description;
  final String tag;
  const _DealCard({
    required this.emoji,
    required this.name,
    required this.description,
    required this.tag,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppTheme.bordeaux.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
              child: Text(emoji, style: const TextStyle(fontSize: 22))),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Text(name,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, color: AppTheme.navy)),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppTheme.gold.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(tag,
                      style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.gold)),
                ),
              ]),
              const SizedBox(height: 2),
              Text(description,
                  style: TextStyle(
                      fontSize: 12, color: AppTheme.navy.withValues(alpha: 0.6))),
            ],
          ),
        ),
        const Icon(Icons.chevron_right,
            color: AppTheme.bordeaux, size: 20),
      ]),
    );
  }
}
