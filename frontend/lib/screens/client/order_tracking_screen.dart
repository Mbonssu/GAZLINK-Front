import 'package:flutter/material.dart';
import 'dart:async';
import '../../models/models.dart';
import '../../theme/glass/glass_components.dart';
import '../../theme/glass/glass_constants.dart';
import '../../routes.dart';

class OrderTrackingScreen extends StatefulWidget {
  final Order order;

  const OrderTrackingScreen({
    super.key,
    required this.order,
  });

  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen> {
  Timer? _timer;
  int _estimatedMinutes = 30;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 30), (timer) {
      if (_estimatedMinutes > 0) {
        setState(() => _estimatedMinutes--);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    return GlassScaffold(
      appBar: GlassAppBar(
        title: const Text('Suivi de commande'),
      ),
      body: SingleChildScrollView(
        padding: GlassConstants.pagePadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Map Placeholder
            GlassCard(
              padding: EdgeInsets.zero,
              child: Container(
                height: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(GlassConstants.radiusM),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      GlassConstants.accent.withValues(alpha: 0.3),
                      GlassConstants.accent.withValues(alpha: 0.1),
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.map,
                            size: 64,
                            color: GlassConstants.accent,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Carte interactive',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: GlassConstants.titleColor(brightness),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Position en temps réel du livreur',
                            style: TextStyle(
                              fontSize: 13,
                              color: GlassConstants.mutedColor(brightness),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Deliverer marker
                    Positioned(
                      top: 100,
                      left: 150,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.green.withValues(alpha: 0.5),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.delivery_dining,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                    // Destination marker
                    Positioned(
                      bottom: 80,
                      right: 100,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.red.withValues(alpha: 0.5),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.location_on,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ETA Card
            GlassCard(
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.access_time,
                      color: Colors.green,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Arrivée estimée',
                          style: TextStyle(
                            fontSize: 13,
                            color: GlassConstants.mutedColor(brightness),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '$_estimatedMinutes minutes',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Order Status Timeline
            GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'État de la commande',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: GlassConstants.titleColor(brightness),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildTimelineItem(
                    'Commande confirmée',
                    'Votre commande a été acceptée',
                    true,
                    true,
                    brightness,
                  ),
                  _buildTimelineItem(
                    'En préparation',
                    'Le dépôt prépare votre commande',
                    true,
                    true,
                    brightness,
                  ),
                  _buildTimelineItem(
                    'En livraison',
                    'Le livreur est en route',
                    true,
                    widget.order.status != OrderStatus.delivered,
                    brightness,
                  ),
                  _buildTimelineItem(
                    'Livrée',
                    'Commande livrée avec succès',
                    widget.order.status == OrderStatus.delivered,
                    false,
                    brightness,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Deliverer Info
            GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Votre livreur',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: GlassConstants.titleColor(brightness),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: GlassConstants.accent.withValues(alpha: 0.2),
                        child: Icon(
                          Icons.person,
                          size: 32,
                          color: GlassConstants.accent,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Yannick KOFFI',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: GlassConstants.titleColor(brightness),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(Icons.star, size: 14, color: Colors.amber),
                                const SizedBox(width: 4),
                                Text(
                                  '4.9',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: GlassConstants.bodyColor(brightness),
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '(156 livraisons)',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: GlassConstants.mutedColor(brightness),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          // TODO: Call deliverer
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Appel du livreur...'),
                            ),
                          );
                        },
                        icon: Icon(
                          Icons.phone,
                          color: GlassConstants.accent,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Order Details
            GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Détails de la commande',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: GlassConstants.titleColor(brightness),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildDetailRow(
                    'Numéro',
                    widget.order.id,
                    brightness,
                  ),
                  _buildDetailRow(
                    'Dépôt',
                    widget.order.depotName,
                    brightness,
                  ),
                  _buildDetailRow(
                    'Quantité',
                    '${widget.order.getTotalQuantity()} bouteilles',
                    brightness,
                  ),
                  _buildDetailRow(
                    'Montant',
                    '${widget.order.finalPrice.toStringAsFixed(0)} FCFA',
                    brightness,
                  ),
                  _buildDetailRow(
                    'Paiement',
                    widget.order.paymentMethod,
                    brightness,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Action Buttons
            if (widget.order.status != OrderStatus.delivered) ...[
              GlassButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.cancelOrder,
                    arguments: widget.order,
                  );
                },
                child: const Text('Annuler la commande'),
              ),
              const SizedBox(height: 12),
            ],
            
            GlassButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  AppRoutes.chatSupport,
                );
              },
              child: const Text('Contacter le support'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineItem(
    String title,
    String subtitle,
    bool isCompleted,
    bool showLine,
    Brightness brightness,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: isCompleted
                    ? Colors.green
                    : GlassConstants.mutedColor(brightness).withValues(alpha: 0.3),
                shape: BoxShape.circle,
                border: Border.all(
                  color: isCompleted
                      ? Colors.green
                      : GlassConstants.mutedColor(brightness),
                  width: 2,
                ),
              ),
              child: isCompleted
                  ? Icon(
                      Icons.check,
                      size: 14,
                      color: Colors.white,
                    )
                  : null,
            ),
            if (showLine)
              Container(
                width: 2,
                height: 40,
                color: isCompleted
                    ? Colors.green
                    : GlassConstants.mutedColor(brightness).withValues(alpha: 0.3),
              ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: isCompleted
                        ? GlassConstants.titleColor(brightness)
                        : GlassConstants.mutedColor(brightness),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: GlassConstants.mutedColor(brightness),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value, Brightness brightness) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: GlassConstants.mutedColor(brightness),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: GlassConstants.titleColor(brightness),
            ),
          ),
        ],
      ),
    );
  }
}
