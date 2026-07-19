import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tall_us/core/theme/app_theme.dart';

/// Sidebar navigation items for admin dashboard
class _NavItem {
  final String path;
  final String label;
  final IconData icon;

  const _NavItem({
    required this.path,
    required this.label,
    required this.icon,
  });
}

/// Admin scaffold with sidebar + topbar layout
class AdminScaffold extends StatefulWidget {
  final Widget child;

  const AdminScaffold({super.key, required this.child});

  @override
  State<AdminScaffold> createState() => _AdminScaffoldState();
}

class _AdminScaffoldState extends State<AdminScaffold> {
  static const _navItems = [
    _NavItem(path: '/admin', label: 'Dashboard', icon: Icons.dashboard),
    _NavItem(
        path: '/admin/users', label: 'Utilisateurs', icon: Icons.people),
    _NavItem(
        path: '/admin/verifications',
        label: 'Vérifications',
        icon: Icons.verified_user),
    _NavItem(
        path: '/admin/newsletters',
        label: 'Newsletters',
        icon: Icons.mail),
    _NavItem(
        path: '/admin/templates',
        label: 'Templates Email',
        icon: Icons.email),
    _NavItem(
        path: '/admin/analytics',
        label: 'Analytics',
        icon: Icons.analytics),
  ];

  int _selectedIndex = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateSelectedIndex();
  }

  void _updateSelectedIndex() {
    final location = GoRouterState.of(context).uri.path;
    final exactMatch = _navItems.indexWhere((item) => item.path == location);
    if (exactMatch >= 0) {
      _selectedIndex = exactMatch;
    } else {
      // Partial match for nested routes like /admin/users/123
      final partialMatch = _navItems.lastIndexWhere(
          (item) => location.startsWith(item.path));
      if (partialMatch >= 0) {
        _selectedIndex = partialMatch;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          _buildSidebar(),

          // Main content
          Expanded(
            child: Column(
              children: [
                // Top bar
                _buildTopBar(),

                // Content area
                Expanded(
                  child: Container(
                    color: const Color(0xFFF5F5F5),
                    child: widget.child,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar() {
    return Container(
      width: 240,
      color: AppTheme.navy,
      child: Column(
        children: [
          // Logo / App name
          Container(
            height: 64,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.white.withValues(alpha: 0.1),
                ),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.favorite, color: AppTheme.bordeaux, size: 28),
                const SizedBox(width: 12),
                const Text(
                  'Tall Us',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 8),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppTheme.bordeaux,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'ADMIN',
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

          // Navigation items
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: _navItems.length,
              itemBuilder: (context, index) {
                final item = _navItems[index];
                final isSelected = index == _selectedIndex;

                return Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      setState(() => _selectedIndex = index);
                      context.go(item.path);
                    },
                    child: Container(
                      height: 48,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppTheme.bordeaux.withValues(alpha: 0.2)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 16),
                          Icon(
                            item.icon,
                            color: isSelected
                                ? AppTheme.bordeaux
                                : Colors.white.withValues(alpha: 0.6),
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            item.label,
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : Colors.white.withValues(alpha: 0.6),
                              fontSize: 14,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Back to app button
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Colors.white.withValues(alpha: 0.1),
                ),
              ),
            ),
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => context.go('/home'),
                icon: const Icon(Icons.arrow_back, size: 16),
                label: const Text('Retour à l\'app'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white.withValues(alpha: 0.6),
                  side: BorderSide(
                      color: Colors.white.withValues(alpha: 0.2)),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: Row(
        children: [
          // Page title
          Text(
            _navItems[_selectedIndex].label,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.navy,
            ),
          ),

          const Spacer(),

          // Refresh button
          IconButton(
            icon: const Icon(Icons.refresh, color: AppTheme.navy),
            onPressed: () {
              // Trigger refresh
              // Refresh current page - re-navigate
              context.go(GoRouterState.of(context).uri.path);
            },
            tooltip: 'Actualiser',
          ),

          const SizedBox(width: 8),

          // User avatar placeholder
          CircleAvatar(
            radius: 18,
            backgroundColor: AppTheme.bordeaux.withValues(alpha: 0.1),
            child: const Icon(Icons.admin_panel_settings,
                size: 20, color: AppTheme.bordeaux),
          ),
        ],
      ),
    );
  }
}
