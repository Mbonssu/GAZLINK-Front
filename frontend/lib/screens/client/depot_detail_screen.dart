import 'package:flutter/material.dart';
import '../../models/models.dart';
import '../../theme/glass/glass_components.dart';
import '../../theme/glass/glass_constants.dart';
import '../../routes.dart';

class DepotDetailScreen extends StatefulWidget {
  final Depot depot;

  const DepotDetailScreen({
    super.key,
    required this.depot,
  });

  @override
  State<DepotDetailScreen> createState() => _DepotDetailScreenState();
}

class _DepotDetailScreenState extends State<DepotDetailScreen> {
  bool _isFavorite = false;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    return GlassScaffold(
      appBar: GlassAppBar(
        title: Text(widget.depot.name),
        actions: [
          IconButton(
            icon: Icon(
              _isFavorite ? Icons.favorite : Icons.favorite_border,
              color: _isFavorite ? Colors.red : null,
            ),
            onPressed: () {
              setState(() => _isFavorite = !_isFavorite);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    _isFavorite
                        ? 'Ajouté aux favoris'
                        : 'Retiré des favoris',
                  ),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: GlassConstants.pagePadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Card with Image
            GlassCard(
              padding: EdgeInsets.zero,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Depot Image
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(GlassConstants.radiusM),
                      ),
                      gradient: LinearGradient(
                        colors: [
                          GlassConstants.accent.withValues(alpha: 0.3),
                          GlassConstants.accent.withValues(alpha: 0.1),
                        ],
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.store,
                        size: 80,
                        color: GlassConstants.accent,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Status Badge
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: widget.depot.isOpen
                                    ? Colors.green.withValues(alpha: 0.2)
                                    : Colors.red.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: widget.depot.isOpen
                                      ? Colors.green
                                      : Colors.red,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    widget.depot.isOpen
                                        ? Icons.check_circle
                                        : Icons.cancel,
                                    size: 16,
                                    color: widget.depot.isOpen
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    widget.depot.isOpen ? 'Ouvert' : 'Fermé',
                                    style: TextStyle(
                                      color: widget.depot.isOpen
                                          ? Colors.green
                                          : Colors.red,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (widget.depot.isVerified) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: GlassConstants.accent
                                      .withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: GlassConstants.accent,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.verified,
                                      size: 16,
                                      color: GlassConstants.accent,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Vérifié',
                                      style: TextStyle(
                                        color: GlassConstants.accent,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Rating
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 20,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              widget.depot.rating.toStringAsFixed(1),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: GlassConstants.titleColor(brightness),
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '(${widget.depot.reviewCount} avis)',
                              style: TextStyle(
                                fontSize: 14,
                                color: GlassConstants.mutedColor(brightness),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Contact Info
            GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Informations de contact',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: GlassConstants.titleColor(brightness),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildInfoRow(
                    Icons.location_on,
                    widget.depot.address,
                    brightness,
                  ),
                  const SizedBox(height: 12),
                  _buildInfoRow(
                    Icons.phone,
                    widget.depot.phone,
                    brightness,
                  ),
                  const SizedBox(height: 12),
                  _buildInfoRow(
                    Icons.access_time,
                    'Lun - Sam: 7h00 - 19h00',
                    brightness,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Stock Info
            GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Stock disponible',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: GlassConstants.titleColor(brightness),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildStockCard(
                          '6 kg',
                          widget.depot.stock6kg,
                          '${widget.depot.price6kg} FCFA',
                          brightness,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStockCard(
                          '12 kg',
                          widget.depot.stock12kg,
                          '${widget.depot.price12kg} FCFA',
                          brightness,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Reviews Section
            GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Avis clients',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: GlassConstants.titleColor(brightness),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.depotReviews,
                            arguments: widget.depot,
                          );
                        },
                        child: Text('Voir tout'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '${widget.depot.reviewCount} avis • Note moyenne: ${widget.depot.rating}/5',
                    style: TextStyle(
                      color: GlassConstants.mutedColor(brightness),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: GlassButton(
                    onPressed: () {
                      // TODO: Open map/directions
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Ouverture de l\'itinéraire...'),
                        ),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.directions, size: 20),
                        const SizedBox(width: 8),
                        Text('Itinéraire'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GlassButton(
                    onPressed: widget.depot.isOpen
                        ? () {
                            Navigator.pushNamed(
                              context,
                              AppRoutes.orderFlow,
                              arguments: widget.depot,
                            );
                          }
                        : null,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.shopping_cart, size: 20),
                        const SizedBox(width: 8),
                        Text('Commander'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text, Brightness brightness) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: GlassConstants.accent,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: GlassConstants.bodyColor(brightness),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStockCard(
    String size,
    int stock,
    String price,
    Brightness brightness,
  ) {
    final isLowStock = stock < 10;
    final stockColor = isLowStock ? Colors.orange : Colors.green;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: GlassConstants.adaptiveSurfaceColor(brightness),
        borderRadius: BorderRadius.circular(GlassConstants.radiusS),
        border: Border.all(
          color: GlassConstants.borderColor(brightness),
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.propane_tank,
            size: 32,
            color: GlassConstants.accent,
          ),
          const SizedBox(height: 8),
          Text(
            size,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: GlassConstants.titleColor(brightness),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            price,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: GlassConstants.accent,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: stockColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '$stock en stock',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: stockColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
