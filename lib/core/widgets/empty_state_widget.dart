import 'package:flutter/material.dart';

/// Widget d'état vide réutilisable
///
/// Affiche un message convivial quand il n'y a pas de données
class EmptyStateWidget extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;
  final IconData icon;
  final Widget? customIllustration;

  const EmptyStateWidget({
    super.key,
    required this.title,
    this.subtitle,
    this.actionLabel,
    this.onAction,
    this.icon = Icons.inbox,
    this.customIllustration,
  });

  /// Empty state pour "plus de profils"
  factory EmptyStateWidget.noMoreProfiles({VoidCallback? onRefresh}) {
    return EmptyStateWidget(
      icon: Icons.person_off,
      title: 'Plus de profils',
      subtitle:
          'Vous avez vu tous les profils de votre zone. Élargissez vos critères de recherche ou revenez plus tard !',
      actionLabel: 'Actualiser',
      onAction: onRefresh,
    );
  }

  /// Empty state pour "pas de messages"
  factory EmptyStateWidget.noMessages({VoidCallback? onStartChat}) {
    return EmptyStateWidget(
      icon: Icons.chat_bubble_outline,
      title: 'Aucun message',
      subtitle: 'Commencez une conversation avec vos matchs !',
      actionLabel: 'Voir les matchs',
      onAction: onStartChat,
    );
  }

  /// Empty state pour "pas d'événements"
  factory EmptyStateWidget.noEvents({VoidCallback? onCreateEvent}) {
    return EmptyStateWidget(
      icon: Icons.event_busy,
      title: 'Aucun événement',
      subtitle: 'Soyez le premier à créer un événement dans votre région !',
      actionLabel: 'Créer un événement',
      onAction: onCreateEvent,
    );
  }

  /// Empty state pour "pas de groupes"
  factory EmptyStateWidget.noGroups({VoidCallback? onBrowseGroups}) {
    return EmptyStateWidget(
      icon: Icons.group_off,
      title: 'Aucun groupe',
      subtitle:
          'Rejoignez ou créez un groupe pour rencontrer des personnes qui partagent vos intérêts !',
      actionLabel: 'Explorer les groupes',
      onAction: onBrowseGroups,
    );
  }

  /// Empty state pour "pas de matchs"
  factory EmptyStateWidget.noMatches({VoidCallback? onDiscover}) {
    return EmptyStateWidget(
      icon: Icons.favorite_border,
      title: 'Pas encore de matchs',
      subtitle: 'Continuez à explorer pour trouver votre partenaire idéal !',
      actionLabel: 'Découvrir des profils',
      onAction: onDiscover,
    );
  }

  /// Empty state pour "pas de résultats recherche"
  factory EmptyStateWidget.noSearchResults({VoidCallback? onClearFilters}) {
    return EmptyStateWidget(
      icon: Icons.search_off,
      title: 'Aucun résultat',
      subtitle: 'Essayez d\'ajuster vos critères de recherche',
      actionLabel: 'Réinitialiser les filtres',
      onAction: onClearFilters,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (customIllustration != null)
              customIllustration!
            else
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 64,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            const SizedBox(height: 24),
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 12),
              Text(
                subtitle!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                textAlign: TextAlign.center,
              ),
            ],
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: onAction,
                icon: const Icon(Icons.refresh),
                label: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Widget d'état vide avec illustration personnalisée
class EmptyStateWithIllustration extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Widget illustration;

  const EmptyStateWithIllustration({
    super.key,
    required this.title,
    this.subtitle,
    this.actionLabel,
    this.onAction,
    required this.illustration,
  });

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      title: title,
      subtitle: subtitle,
      actionLabel: actionLabel,
      onAction: onAction,
      customIllustration: illustration,
    );
  }
}
