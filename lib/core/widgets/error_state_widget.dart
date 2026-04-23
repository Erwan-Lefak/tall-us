import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

/// Widget d'état d'erreur réutilisable
///
/// Affiche un message d'erreur avec option de retry
class ErrorStateWidget extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? errorDetails;
  final String? actionLabel;
  final VoidCallback? onRetry;
  final IconData icon;
  final Object? error;

  const ErrorStateWidget({
    super.key,
    required this.title,
    this.subtitle,
    this.errorDetails,
    this.actionLabel,
    this.onRetry,
    this.icon = Icons.error_outline,
    this.error,
  });

  /// Error state pour "erreur de connexion"
  factory ErrorStateWidget.connectionError({VoidCallback? onRetry}) {
    return ErrorStateWidget(
      icon: Icons.wifi_off,
      title: 'Problème de connexion',
      subtitle: 'Vérifiez votre connexion internet et réessayez',
      actionLabel: 'Réessayer',
      onRetry: onRetry,
    );
  }

  /// Error state pour "timeout"
  factory ErrorStateWidget.timeoutError({VoidCallback? onRetry}) {
    return ErrorStateWidget(
      icon: Icons.access_time,
      title: 'Délai d\'attente dépassé',
      subtitle: 'La requête a pris trop de temps. Réessayez.',
      actionLabel: 'Réessayer',
      onRetry: onRetry,
    );
  }

  /// Error state pour "serveur indisponible"
  factory ErrorStateWidget.serverError({VoidCallback? onRetry}) {
    return ErrorStateWidget(
      icon: Icons.cloud_off,
      title: 'Serveur indisponible',
      subtitle:
          'Nos services sont momentanément indisponibles. Réessayez dans quelques instants.',
      actionLabel: 'Réessayer',
      onRetry: onRetry,
    );
  }

  /// Error state pour "erreur de chargement"
  factory ErrorStateWidget.loadingFailed({
    String? message,
    VoidCallback? onRetry,
  }) {
    return ErrorStateWidget(
      icon: Icons.sync_problem,
      title: 'Échec du chargement',
      subtitle:
          message ?? 'Une erreur est survenue lors du chargement des données.',
      actionLabel: 'Réessayer',
      onRetry: onRetry,
    );
  }

  /// Error state pour "non autorisé"
  factory ErrorStateWidget.unauthorized({VoidCallback? onLogin}) {
    return ErrorStateWidget(
      icon: Icons.lock,
      title: 'Non autorisé',
      subtitle: 'Vous devez être connecté pour accéder à cette fonctionnalité.',
      actionLabel: 'Se connecter',
      onRetry: onLogin,
    );
  }

  /// Error state pour "pas de résultats"
  factory ErrorStateWidget.noResults({VoidCallback? onRetry}) {
    return ErrorStateWidget(
      icon: Icons.search_off,
      title: 'Aucun résultat trouvé',
      subtitle: 'Aucun résultat ne correspond à votre recherche.',
      actionLabel: 'Réessayer',
      onRetry: onRetry,
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
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.red[50],
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 56,
                color: Colors.red[400],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[900],
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
            if (errorDetails != null) ...[
              const SizedBox(height: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  errorDetails!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[700],
                        fontFamily: 'monospace',
                      ),
                ),
              ),
            ],
            if (actionLabel != null && onRetry != null) ...[
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: onRetry,
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

/// Widget de détection de connexion avec état
class ConnectivityErrorWidget extends StatefulWidget {
  final VoidCallback? onRetry;

  const ConnectivityErrorWidget({
    super.key,
    this.onRetry,
  });

  @override
  State<ConnectivityErrorWidget> createState() =>
      _ConnectivityErrorWidgetState();
}

class _ConnectivityErrorWidgetState extends State<ConnectivityErrorWidget> {
  final Connectivity _connectivity = Connectivity();
  List<ConnectivityResult> _connectionStatus = [];
  bool _isChecking = false;

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
  }

  Future<void> _checkConnectivity() async {
    setState(() => _isChecking = true);
    try {
      final results = await _connectivity.checkConnectivity();
      setState(() => _connectionStatus = results);
    } catch (e) {
      setState(() => _connectionStatus = []);
    } finally {
      setState(() => _isChecking = false);
    }
  }

  bool get _isOffline => _connectionStatus.contains(ConnectivityResult.none);

  String get _connectionMessage {
    if (_isChecking) return 'Vérification de la connexion...';
    if (_isOffline) return 'Vous êtes hors ligne';
    return 'Connexion rétablie';
  }

  @override
  Widget build(BuildContext context) {
    return ErrorStateWidget(
      icon: _isOffline ? Icons.wifi_off : Icons.wifi,
      title: 'Problème de connexion',
      subtitle: _connectionMessage,
      actionLabel: 'Réessayer',
      onRetry: () {
        _checkConnectivity();
        widget.onRetry?.call();
      },
    );
  }
}

/// Bouton de retry avec animation
class RetryButton extends StatefulWidget {
  final VoidCallback onRetry;
  final String? label;
  final bool isLoading;

  const RetryButton({
    super.key,
    required this.onRetry,
    this.label,
    this.isLoading = false,
  });

  @override
  State<RetryButton> createState() => _RetryButtonState();
}

class _RetryButtonState extends State<RetryButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: ElevatedButton.icon(
        onPressed: widget.isLoading ? null : _handleRetry,
        icon: widget.isLoading
            ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.refresh),
        label: Text(widget.label ?? 'Réessayer'),
      ),
    );
  }

  Future<void> _handleRetry() async {
    await _controller.forward();
    await _controller.reverse();
    widget.onRetry();
  }
}

/// Widget de retry simplifié
class SimpleRetryWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const SimpleRetryWidget({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: onRetry,
              child: const Text('Réessayer'),
            ),
          ],
        ),
      ),
    );
  }
}
