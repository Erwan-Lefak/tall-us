import 'package:flutter/material.dart';

/// Configuration pour la pagination
class PaginationConfig {
  final int pageSize;
  final int initialPageSize;
  final Duration debounceDuration;

  const PaginationConfig({
    this.pageSize = 20,
    this.initialPageSize = 20,
    this.debounceDuration = const Duration(milliseconds: 300),
  });

  static const PaginationConfig defaultConfig = PaginationConfig();
}

/// État de la pagination
enum PaginationStatus {
  initial,
  loading,
  success,
  loadingMore,
  error,
  noMoreResults,
}

/// Contrôleur pour gérer la pagination
class PaginationController<T> extends ChangeNotifier {
  final PaginationConfig config;

  List<T> _items = [];
  PaginationStatus _status = PaginationStatus.initial;
  String? _errorMessage;
  int _currentPage = 0;
  bool _hasMore = true;

  PaginationController({
    this.config = PaginationConfig.defaultConfig,
  });

  // Getters
  List<T> get items => List.unmodifiable(_items);
  PaginationStatus get status => _status;
  String? get errorMessage => _errorMessage;
  bool get hasMore => _hasMore;
  bool get isLoading => _status == PaginationStatus.loading;
  bool get isLoadingMore => _status == PaginationStatus.loadingMore;
  bool get isFirstLoad => _status == PaginationStatus.initial;
  bool get hasError => _status == PaginationStatus.error;
  int get itemCount => _items.length;

  /// Initialise la pagination avec la première page
  Future<void> initialize(
      Future<List<T>> Function(int page, int limit) fetcher) async {
    if (_status == PaginationStatus.loading) return;

    _setStatus(PaginationStatus.loading);
    _currentPage = 0;

    try {
      final newItems = await fetcher(_currentPage, config.initialPageSize);
      _items = newItems;
      _currentPage++;
      _hasMore = newItems.length >= config.initialPageSize;
      _setStatus(PaginationStatus.success);
    } catch (e) {
      _errorMessage = e.toString();
      _setStatus(PaginationStatus.error);
    }
  }

  /// Charge la page suivante
  Future<void> loadMore(
      Future<List<T>> Function(int page, int limit) fetcher) async {
    if (_status == PaginationStatus.loading ||
        _status == PaginationStatus.loadingMore ||
        !_hasMore) {
      return;
    }

    _setStatus(PaginationStatus.loadingMore);

    try {
      final newItems = await fetcher(_currentPage, config.pageSize);

      if (newItems.isEmpty) {
        _hasMore = false;
        _setStatus(PaginationStatus.noMoreResults);
      } else {
        _items.addAll(newItems);
        _currentPage++;
        _hasMore = newItems.length >= config.pageSize;
        _setStatus(PaginationStatus.success);
      }
    } catch (e) {
      _errorMessage = e.toString();
      _setStatus(PaginationStatus.error);
    }
  }

  /// Rafraîchit la liste depuis le début
  Future<void> refresh(
      Future<List<T>> Function(int page, int limit) fetcher) async {
    _items.clear();
    await initialize(fetcher);
  }

  /// Ajoute un item à la liste (utile pour les mises à jour en temps réel)
  void addItem(T item) {
    _items.insert(0, item);
    notifyListeners();
  }

  /// Met à jour un item existant
  void updateItem(int index, T item) {
    if (index >= 0 && index < _items.length) {
      _items[index] = item;
      notifyListeners();
    }
  }

  /// Supprime un item
  void removeItem(int index) {
    if (index >= 0 && index < _items.length) {
      _items.removeAt(index);
      notifyListeners();
    }
  }

  /// Vide tous les items
  void clear() {
    _items.clear();
    _status = PaginationStatus.initial;
    _currentPage = 0;
    _hasMore = true;
    notifyListeners();
  }

  void _setStatus(PaginationStatus status) {
    _status = status;
    notifyListeners();
  }

  @override
  void dispose() {
    _items.clear();
    super.dispose();
  }
}

/// Widget pour gérer l'infinite scroll
class PaginationListView<T> extends StatefulWidget {
  final PaginationController<T> controller;
  final Future<List<T>> Function(int page, int limit) fetchData;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final Widget Function(BuildContext context)? loadingBuilder;
  final Widget Function(BuildContext context)? loadingMoreBuilder;
  final Widget Function(BuildContext context, String? error)? errorBuilder;
  final Widget Function(BuildContext context)? emptyBuilder;
  final Widget Function(BuildContext context)? noMoreItemsBuilder;
  final EdgeInsetsGeometry? padding;
  final ScrollPhysics? physics;
  final SliverChildDelegate? childrenDelegate;

  const PaginationListView({
    super.key,
    required this.controller,
    required this.fetchData,
    required this.itemBuilder,
    this.loadingBuilder,
    this.loadingMoreBuilder,
    this.errorBuilder,
    this.emptyBuilder,
    this.noMoreItemsBuilder,
    this.padding,
    this.physics,
    this.childrenDelegate,
  });

  @override
  State<PaginationListView<T>> createState() => _PaginationListViewState<T>();
}

class _PaginationListViewState<T> extends State<PaginationListView<T>> {
  final ScrollController _scrollController = ScrollController();
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    widget.controller.addListener(_onControllerChanged);

    // Initialiser au premier build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_isInitialized) {
        _isInitialized = true;
        widget.controller.initialize(widget.fetchData);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    widget.controller.removeListener(_onControllerChanged);
    super.dispose();
  }

  void _onScroll() {
    if (_isLoadMoreTriggered()) {
      widget.controller.loadMore(widget.fetchData);
    }
  }

  bool _isLoadMoreTriggered() {
    if (!widget.controller.hasMore ||
        widget.controller.isLoading ||
        widget.controller.isLoadingMore) {
      return false;
    }

    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    final delta = 200; // Distance du bas avant de déclencher le chargement
    return maxScroll - currentScroll < delta;
  }

  void _onControllerChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, child) {
        if (widget.controller.isFirstLoad) {
          return widget.loadingBuilder?.call(context) ?? _buildDefaultLoading();
        }

        if (widget.controller.hasError && widget.controller.itemCount == 0) {
          return widget.errorBuilder
                  ?.call(context, widget.controller.errorMessage) ??
              _buildDefaultError();
        }

        if (widget.controller.itemCount == 0) {
          return widget.emptyBuilder?.call(context) ?? _buildDefaultEmpty();
        }

        return ListView.builder(
          controller: _scrollController,
          padding: widget.padding,
          physics: widget.physics,
          itemCount:
              widget.controller.itemCount + (widget.controller.hasMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index < widget.controller.itemCount) {
              return widget.itemBuilder(
                  context, widget.controller.items[index], index);
            } else {
              return widget.loadingMoreBuilder?.call(context) ??
                  _buildDefaultLoadingMore();
            }
          },
        );
      },
    );
  }

  Widget _buildDefaultLoading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildDefaultLoadingMore() {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildDefaultError() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            widget.controller.errorMessage ?? 'Une erreur est survenue',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => widget.controller.initialize(widget.fetchData),
            child: const Text('Réessayer'),
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultEmpty() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'Aucun élément trouvé',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
