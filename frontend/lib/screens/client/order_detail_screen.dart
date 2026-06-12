import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/models.dart';
import '../../providers/order_provider.dart';
import '../../theme/glass/glass_components.dart';
import '../../theme/glass/glass_constants.dart';
import '../../routes.dart';

class OrderDetailScreen extends StatelessWidget {
  final Order order;

  const OrderDetailScreen({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GlassScaffold(
      appBar: GlassAppBar(
        title: Text(order.id),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.receipt_outlined),
            onPressed: () => Navigator.of(context).pushNamed(AppRoutes.receipt, arguments: order.id),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status card
            _buildStatusCard(context, order),
            const SizedBox(height: 20),
            
            // Order info
            _buildSectionTitle(context, 'Informations de commande'),
            const SizedBox(height: 12),
            _buildOrderInfoCard(context, order),
            const SizedBox(height: 20),
            
            // Items
            _buildSectionTitle(context, 'Articles'),
            const SizedBox(height: 12),
            _buildItemsCard(context, order),
            const SizedBox(height: 20),
            
            // Delivery info
            if (order.deliveryAddress != null) ...[
              _buildSectionTitle(context, 'Livraison'),
              const SizedBox(height: 12),
              _buildDeliveryCard(context, order),
              const SizedBox(height: 20),
            ],
            
            // Payment
            _buildSectionTitle(context, 'Paiement'),
            const SizedBox(height: 12),
            _buildPaymentCard(context, order),
            const SizedBox(height: 20),
            
            // Actions
            if (order.status == OrderStatus.in_delivery)
              SizedBox(
                width: double.infinity,
                child: GlassButton(
                  onPressed: () => Navigator.of(context).pushNamed(AppRoutes.orderTracking, arguments: order.id),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.location_on_outlined, size: 20),
                      SizedBox(width: 8),
                      Text('Suivre la livraison'),
                    ],
                  ),
                ),
              ),
            
            if (order.status == OrderStatus.pending || order.status == OrderStatus.confirmed)
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => _showCancelDialog(context, order),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.red),
                  ),
                  child: const Text(
                    'Annuler la commande',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ),
            
            if (order.status == OrderStatus.delivered)
              SizedBox(
                width: double.infinity,
                child: GlassButton(
                  onPressed: () => Navigator.of(context).pushNamed(AppRoutes.rateDelivery, arguments: order.id),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.star_outline, size: 20),
                      SizedBox(width: 8),
                      Text('Évaluer la livraison'),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard(BuildContext context, Order order) {
    final statusInfo = _getStatusInfo(order.status);
    return GlassCard(
      color: statusInfo.color.withValues(alpha: 0.1),
      child: Column(
        children: [
          Icon(
            statusInfo.icon,
            size: 48,
            color: statusInfo.color,
          ),
          const SizedBox(height: 12),
          Text(
            statusInfo.label,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: statusInfo.color,
                ),
          ),
          if (order.eta != null) ...[
            const SizedBox(height: 8),
            Text(
              'Arrivée estimée: ${order.eta}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: statusInfo.color,
                  ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildOrderInfoCard(BuildContext context, Order order) {
    return GlassCard(
      child: Column(
        children: [
          _buildInfoRow(context, 'Dépôt', order.depotName),
          const SizedBox(height: 12),
          _buildInfoRow(context, 'Date', _formatDate(order.createdAt)),
          if (order.deliveredAt != null) ...[
            const SizedBox(height: 12),
            _buildInfoRow(context, 'Livrée le', _formatDate(order.deliveredAt!)),
          ],
        ],
      ),
    );
  }

  Widget _buildItemsCard(BuildContext context, Order order) {
    return GlassCard(
      child: Column(
        children: [
          if (order.quantity6kg > 0)
            _buildItemRow(
              context,
              'Bouteille 6kg',
              order.quantity6kg,
              3500,
            ),
          if (order.quantity6kg > 0 && order.quantity12kg > 0)
            const SizedBox(height: 12),
          if (order.quantity12kg > 0)
            _buildItemRow(
              context,
              'Bouteille 12.5kg',
              order.quantity12kg,
              6500,
            ),
        ],
      ),
    );
  }

  Widget _buildDeliveryCard(BuildContext context, Order order) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.location_on_outlined, color: GlassConstants.accent),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  order.deliveryAddress ?? 'Adresse non spécifiée',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
          ),
          if (order.deliveryNotes != null) ...[
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.notes_outlined,
                  color: GlassConstants.mutedColor(Theme.of(context).brightness),
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    order.deliveryNotes!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: GlassConstants.mutedColor(Theme.of(context).brightness),
                        ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPaymentCard(BuildContext context, Order order) {
    return GlassCard(
      child: Column(
        children: [
          _buildInfoRow(context, 'Sous-total', '${order.totalPrice.toStringAsFixed(0)} FCFA'),
          const SizedBox(height: 12),
          _buildInfoRow(
            context,
            'Réduction',
            '- ${order.discount.toStringAsFixed(0)} FCFA',
            valueColor: Colors.green,
          ),
          const SizedBox(height: 12),
          Divider(color: GlassConstants.borderColor(Theme.of(context).brightness)),
          const SizedBox(height: 12),
          _buildInfoRow(
            context,
            'Total',
            '${order.finalPrice.toStringAsFixed(0)} FCFA',
            isBold: true,
            valueColor: GlassConstants.accent,
          ),
          const SizedBox(height: 12),
          _buildInfoRow(context, 'Mode de paiement', order.paymentMethod),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: GlassConstants.mutedColor(Theme.of(context).brightness),
          ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    String label,
    String value, {
    bool isBold = false,
    Color? valueColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: GlassConstants.mutedColor(Theme.of(context).brightness),
              ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
                color: valueColor,
              ),
        ),
      ],
    );
  }

  Widget _buildItemRow(BuildContext context, String name, int quantity, int price) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              Icons.local_fire_department,
              size: 20,
              color: GlassConstants.accent,
            ),
            const SizedBox(width: 8),
            Text(
              name,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
        Text(
          '$quantity x $price FCFA',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }

  _StatusInfo _getStatusInfo(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return _StatusInfo('En attente', Colors.grey, Icons.schedule);
      case OrderStatus.confirmed:
        return _StatusInfo('Confirmée', Colors.blue, Icons.check_circle_outline);
      case OrderStatus.assigned:
        return _StatusInfo('Assignée', Colors.purple, Icons.person_outline);
      case OrderStatus.in_delivery:
        return _StatusInfo('En livraison', Colors.orange, Icons.local_shipping_outlined);
      case OrderStatus.delivered:
        return _StatusInfo('Livrée', Colors.green, Icons.check_circle);
      case OrderStatus.cancelled:
        return _StatusInfo('Annulée', Colors.red, Icons.cancel_outlined);
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} à ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  void _showCancelDialog(BuildContext context, Order order) {
    showDialog(
      context: context,
      builder: (context) => GlassDialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.cancel_outlined,
              size: 48,
              color: Colors.red.withValues(alpha: 0.8),
            ),
            const SizedBox(height: 16),
            Text(
              'Annuler la commande',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Êtes-vous sûr de vouloir annuler cette commande ?',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Non'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      context.read<OrderProvider>().updateOrderStatus(
                            order.id,
                            OrderStatus.cancelled,
                          );
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Commande annulée')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: const Text('Oui, annuler'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusInfo {
  final String label;
  final Color color;
  final IconData icon;

  _StatusInfo(this.label, this.color, this.icon);
}
