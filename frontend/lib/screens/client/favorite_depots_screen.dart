import 'package:flutter/material.dart';
import '../../data/mock_data.dart';
import '../../models/models.dart';
import '../../theme/glass/glass_components.dart';
import '../../theme/glass/glass_constants.dart';
import '../../routes.dart';

class FavoriteDepotsScreen extends StatefulWidget {
  const FavoriteDepotsScreen({super.key});

  @override
  State<FavoriteDepotsScreen> createState() => _FavoriteDepotsScreenState();
}

class _FavoriteDepotsScreenState extends State<FavoriteDepotsScreen> {
  late List<Depot> _favoriteDepots;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _favoriteDepots = MockData.getMockDepots();
      _isLoading = false;
    });
  }

  void _removeFavorite(Depot depot) {
    setState(() {
      _favoriteDepots.removeWhere((d) => d.id == depot.id);
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${depot.name} retiré des favoris'),
        action: SnackBarAction(
          label: 'Annuler',
          onPressed: () {
            setState(() {
              _favoriteDepots.add(depot);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    return GlassScaffold(
      appBar: GlassAppBar(
        title: const Text('Dépôts favoris'),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: GlassConstants.accent,
              ),
            )
          : _favoriteDepots.isEmpty
              ? _buildEmptyState(brightness)
              : RefreshIndicator(
                  onRefresh: _loadFavorites,
                  color: GlassConstants.accent,
                  child: ListView.builder(
                    padding: GlassConstants.pagePadding,
                    itemCount: _favoriteDepots.length,
                    itemBuilder: (context, index) {
                      final depot = _favoriteDepots[index];
                      return _buildDepotCard(depot, brightness);
                    },
                  ),
                ),
    );
  }

  Widget _buildEmptyState(Brightness brightness) {
    return Center(
      child: Padding(
        padding: GlassConstants.pagePadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_border,
              size: 80,
              color: GlassConstants.mutedColor(brightness),
            ),
            const SizedBox(height: 24),
            Text(
              'Aucun dépôt favori',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: GlassConstants.titleColor(brightness),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Ajoutez vos dépôts préférés pour y accéder rapidement',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: GlassConstants.mutedColor(brightness),
              ),
            ),
            const SizedBox(height: 32),
            GlassButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.depotList);
              },
              child: const Text('Découvrir les dépôts'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDepotCard(Depot depot, Brightness brightness) {
    return GlassCard(
      margin: const EdgeInsets.only(bottom: 12),
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoutes.depotDetail,
          arguments: depot,
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Depot Icon
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: GlassConstants.accent.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(GlassConstants.radiusS),
                ),
                child: Icon(
                  Icons.store,
                  color: GlassConstants.accent,
                  size: 30,
                ),
              ),
              const SizedBox(width: 12),
              // Depot Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            depot.name,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: GlassConstants.titleColor(brightness),
                            ),
                          ),
                        ),
                        if (depot.isVerified)
                          Icon(
                            Icons.verified,
                            size: 18,
                            color: GlassConstants.accent,
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          size: 14,
                          color: Colors.amber,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          depot.rating.toStringAsFixed(1),
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: GlassConstants.bodyColor(brightness),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '(${depot.reviewCount})',
                          style: TextStyle(
                            fontSize: 13,
                            color: GlassConstants.mutedColor(brightness),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: depot.isOpen ? Colors.green : Colors.red,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          depot.isOpen ? 'Ouvert' : 'Fermé',
                          style: TextStyle(
                            fontSize: 13,
                            color: depot.isOpen ? Colors.green : Colors.red,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 14,
                          color: GlassConstants.mutedColor(brightness),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            depot.address,
                            style: TextStyle(
                              fontSize: 12,
                              color: GlassConstants.mutedColor(brightness),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Stock Info
          Row(
            children: [
              Expanded(
                child: _buildStockInfo(
                  '6kg',
                  depot.stock6kg,
                  '${depot.price6kg} FCFA',
                  brightness,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStockInfo(
                  '12kg',
                  depot.stock12kg,
                  '${depot.price12kg} FCFA',
                  brightness,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _removeFavorite(depot),
                  icon: Icon(Icons.favorite, size: 18),
                  label: Text('Retirer'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: BorderSide(color: Colors.red),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GlassButton(
                  onPressed: depot.isOpen
                      ? () {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.orderFlow,
                            arguments: depot,
                          );
                        }
                      : null,
                  child: const Text('Commander'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStockInfo(
    String size,
    int stock,
    String price,
    Brightness brightness,
  ) {
    final isLowStock = stock < 10;
    final stockColor = isLowStock ? Colors.orange : Colors.green;

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: GlassConstants.adaptiveSurfaceColor(brightness),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: GlassConstants.borderColor(brightness),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.propane_tank,
                size: 16,
                color: GlassConstants.accent,
              ),
              const SizedBox(width: 4),
              Text(
                size,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: GlassConstants.titleColor(brightness),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            price,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: GlassConstants.accent,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '$stock en stock',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: stockColor,
            ),
          ),
        ],
      ),
    );
  }
}
