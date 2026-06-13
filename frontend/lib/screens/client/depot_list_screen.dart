import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/models.dart';
import '../../providers/order_provider.dart';
import '../../theme/glass/glass_components.dart';
import '../../theme/glass/glass_constants.dart';

class DepotListScreen extends StatefulWidget {
  const DepotListScreen({Key? key}) : super(key: key);

  @override
  State<DepotListScreen> createState() => _DepotListScreenState();
}

class _DepotListScreenState extends State<DepotListScreen> {
  bool _showMap = false;
  String _searchQuery = '';
  bool _filterVerified = false;
  bool _filterOpen = false;
  bool _filterInStock = false;

  @override
  Widget build(BuildContext context) {
    return GlassScaffold(
      appBar: GlassAppBar(
        title: const Text('Dépôts'),
        actions: [
          IconButton(
            icon: Icon(_showMap ? Icons.list : Icons.map_outlined),
            onPressed: () => setState(() => _showMap = !_showMap),
          ),
          IconButton(
            icon: const Icon(Icons.filter_list_outlined),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(20),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Rechercher un dépôt...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () => setState(() => _searchQuery = ''),
                      )
                    : null,
              ),
              onChanged: (value) => setState(() => _searchQuery = value),
            ),
          ),
          
          // Active filters
          if (_filterVerified || _filterOpen || _filterInStock)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Wrap(
                spacing: 8,
                children: [
                  if (_filterVerified) _buildFilterChip('Vérifié', () => setState(() => _filterVerified = false)),
                  if (_filterOpen) _buildFilterChip('Ouvert', () => setState(() => _filterOpen = false)),
                  if (_filterInStock) _buildFilterChip('En stock', () => setState(() => _filterInStock = false)),
                ],
              ),
            ),
          
          // Content
          Expanded(
            child: _showMap ? _buildMapView(context) : _buildListView(context),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, VoidCallback onDelete) {
    return Chip(
      label: Text(label),
      deleteIcon: const Icon(Icons.close, size: 16),
      onDeleted: onDelete,
      backgroundColor: GlassConstants.accent.withValues(alpha: 0.15),
      labelStyle: TextStyle(
        color: GlassConstants.accent,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildMapView(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.map_outlined,
            size: 80,
            color: GlassConstants.mutedColor(Theme.of(context).brightness),
          ),
          const SizedBox(height: 16),
          Text(
            'Vue carte',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: GlassConstants.mutedColor(Theme.of(context).brightness),
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Intégration de la carte à venir',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: GlassConstants.mutedColor(Theme.of(context).brightness),
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildListView(BuildContext context) {
    return Consumer<OrderProvider>(
      builder: (context, orderProvider, _) {
        var depots = orderProvider.availableDepots;

        // Apply search filter
        if (_searchQuery.isNotEmpty) {
          depots = depots.where((d) =>
              d.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              d.address.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
        }

        // Apply filters
        if (_filterVerified) {
          depots = depots.where((d) => d.isVerified).toList();
        }
        if (_filterOpen) {
          depots = depots.where((d) => d.isOpen).toList();
        }
        if (_filterInStock) {
          depots = depots.where((d) => d.totalFullBottles > 0).toList();
        }

        if (depots.isEmpty) {
          return _buildEmptyState(context);
        }

        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          itemCount: depots.length,
          itemBuilder: (context, index) {
            return _buildDepotCard(context, depots[index]);
          },
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.store_outlined,
            size: 80,
            color: GlassConstants.mutedColor(Theme.of(context).brightness),
          ),
          const SizedBox(height: 16),
          Text(
            'Aucun dépôt trouvé',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: GlassConstants.mutedColor(Theme.of(context).brightness),
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Essayez de modifier vos filtres',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: GlassConstants.mutedColor(Theme.of(context).brightness),
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildDepotCard(BuildContext context, Depot depot) {
    return GlassCard(
      margin: const EdgeInsets.only(bottom: 12),
      onTap: () => Navigator.of(context).pushNamed(
        '/depot-detail',
        arguments: depot.id,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            depot.name,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                        ),
                        if (depot.isVerified)
                          Icon(
                            Icons.verified,
                            size: 20,
                            color: GlassConstants.accent,
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          size: 16,
                          color: Colors.amber,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          depot.rating.toStringAsFixed(1),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '(${depot.reviews})',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: GlassConstants.mutedColor(Theme.of(context).brightness),
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: depot.isOpen
                      ? Colors.green.withValues(alpha: 0.15)
                      : Colors.red.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  depot.isOpen ? 'Ouvert' : 'Fermé',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: depot.isOpen ? Colors.green : Colors.red,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // Address
          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 16,
                color: GlassConstants.mutedColor(Theme.of(context).brightness),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  depot.address,
                  style: Theme.of(context).textTheme.bodySmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                '${depot.distance.toStringAsFixed(1)} km',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: GlassConstants.accent,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // Stock info
          Row(
            children: [
              Expanded(
                child: _buildStockInfo(
                  context,
                  '6kg',
                  depot.stock6kg,
                  '${depot.price6kg} FCFA',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStockInfo(
                  context,
                  '12.5kg',
                  depot.stock12kg,
                  '${depot.price12kg} FCFA',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStockInfo(BuildContext context, String size, int stock, String price) {
    final inStock = stock > 0;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: inStock
            ? GlassConstants.accent.withValues(alpha: 0.08)
            : Colors.grey.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.local_fire_department,
                size: 16,
                color: inStock ? GlassConstants.accent : Colors.grey,
              ),
              const SizedBox(width: 4),
              Text(
                size,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: inStock ? GlassConstants.accent : Colors.grey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            inStock ? '$stock en stock' : 'Rupture',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: GlassConstants.mutedColor(Theme.of(context).brightness),
                ),
          ),
          const SizedBox(height: 2),
          Text(
            price,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
            child: GlassCard(
              radius: GlassConstants.radiusL,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Filtres',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  CheckboxListTile(
                    title: const Text('Dépôts vérifiés'),
                    value: _filterVerified,
                    onChanged: (value) {
                      setModalState(() => _filterVerified = value ?? false);
                      setState(() => _filterVerified = value ?? false);
                    },
                    activeColor: GlassConstants.accent,
                  ),
                  CheckboxListTile(
                    title: const Text('Ouverts maintenant'),
                    value: _filterOpen,
                    onChanged: (value) {
                      setModalState(() => _filterOpen = value ?? false);
                      setState(() => _filterOpen = value ?? false);
                    },
                    activeColor: GlassConstants.accent,
                  ),
                  CheckboxListTile(
                    title: const Text('En stock'),
                    value: _filterInStock,
                    onChanged: (value) {
                      setModalState(() => _filterInStock = value ?? false);
                      setState(() => _filterInStock = value ?? false);
                    },
                    activeColor: GlassConstants.accent,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            setModalState(() {
                              _filterVerified = false;
                              _filterOpen = false;
                              _filterInStock = false;
                            });
                            setState(() {
                              _filterVerified = false;
                              _filterOpen = false;
                              _filterInStock = false;
                            });
                          },
                          child: const Text('Réinitialiser'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Appliquer'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
