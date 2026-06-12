import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/models.dart';
import '../../providers/order_provider.dart';
import '../../theme/glass/glass_components.dart';
import '../../theme/glass/glass_constants.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({Key? key}) : super(key: key);

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  OrderStatus? _selectedFilter;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<OrderProvider>().fetchOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GlassScaffold(
      appBar: GlassAppBar(
        title: const Text('Mes Commandes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list_outlined),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: Consumer<OrderProvider>(
        builder: (context, orderProvider, _) {
          if (orderProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final orders = _selectedFilter == null
              ? orderProvider.orders
              : orderProvider.orders.where((o) => o.status == _selectedFilter).toList();

          if (orders.isEmpty) {
            return _buildEmptyState(context);
          }

          return RefreshIndicator(
            onRefresh: () => orderProvider.fetchOrders(),
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                return _buildOrderCard(context, orders[index]);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_bag_outlined,
            size: 80,
            color: GlassConstants.mutedColor(Theme.of(context).brightness),
          ),
          const SizedBox(height: 16),
          Text(
            _selectedFilter == null ? 'Aucune commande' : 'Aucune commande trouvée',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: GlassConstants.mutedColor(Theme.of(context).brightness),
                ),
          ),
          const SizedBox(height: 8),
          Text(
            _selectedFilter == null
                ? 'Vous n\'avez pas encore passé de commande'
                : 'Aucune commande avec ce statut',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: GlassConstants.mutedColor(Theme.of(context).brightness),
                ),
            textAlign: TextAlign.center,
          ),
          if (_selectedFilter != null) ...[
            const SizedBox(height: 24),
            GlassButton(
              onPressed: () => setState(() => _selectedFilter = null),
              child: const Text('Réinitialiser le filtre'),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildOrderCard(BuildContext context, Order order) {
    return GlassCard(
      margin: const EdgeInsets.only(bottom: 12),
      onTap: () => Navigator.of(context).pushNamed(
        '/order-detail',
        arguments: order.id,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                order.id,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              _buildStatusBadge(context, order.status),
            ],
          ),
          const SizedBox(height: 12),
          
          // Depot info
          Row(
            children: [
              Icon(
                Icons.store_outlined,
                size: 16,
                color: GlassConstants.mutedColor(Theme.of(context).brightness),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  order.depotName,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          
          // Items
          Row(
            children: [
              Icon(
                Icons.local_fire_department_outlined,
                size: 16,
                color: GlassConstants.mutedColor(Theme.of(context).brightness),
              ),
              const SizedBox(width: 8),
              Text(
                '${order.quantity6kg}x 6kg, ${order.quantity12kg}x 12.5kg',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
          const SizedBox(height: 8),
          
          // Date
          Row(
            children: [
              Icon(
                Icons.calendar_today_outlined,
                size: 16,
                color: GlassConstants.mutedColor(Theme.of(context).brightness),
              ),
              const SizedBox(width: 8),
              Text(
                _formatDate(order.createdAt),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: GlassConstants.mutedColor(Theme.of(context).brightness),
                    ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // Divider
          Divider(color: GlassConstants.borderColor(Theme.of(context).brightness)),
          const SizedBox(height: 12),
          
          // Footer
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${order.finalPrice.toStringAsFixed(0)} FCFA',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: GlassConstants.accent,
                    ),
              ),
              if (order.eta != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.orange.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.access_time, size: 14, color: Colors.orange),
                      const SizedBox(width: 4),
                      Text(
                        'ETA: ${order.eta}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.orange,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context, OrderStatus status) {
    final statusInfo = _getStatusInfo(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: statusInfo.color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        statusInfo.label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: statusInfo.color,
        ),
      ),
    );
  }

  _StatusInfo _getStatusInfo(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return _StatusInfo('En attente', Colors.grey);
      case OrderStatus.confirmed:
        return _StatusInfo('Confirmée', Colors.blue);
      case OrderStatus.assigned:
        return _StatusInfo('Assignée', Colors.purple);
      case OrderStatus.in_delivery:
        return _StatusInfo('En livraison', Colors.orange);
      case OrderStatus.delivered:
        return _StatusInfo('Livrée', Colors.green);
      case OrderStatus.cancelled:
        return _StatusInfo('Annulée', Colors.red);
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Aujourd\'hui à ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      return 'Hier à ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  void _showFilterDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
        child: GlassCard(
          radius: GlassConstants.radiusL,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Filtrer par statut',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              _buildFilterOption(null, 'Tous'),
              _buildFilterOption(OrderStatus.pending, 'En attente'),
              _buildFilterOption(OrderStatus.confirmed, 'Confirmée'),
              _buildFilterOption(OrderStatus.in_delivery, 'En livraison'),
              _buildFilterOption(OrderStatus.delivered, 'Livrée'),
              _buildFilterOption(OrderStatus.cancelled, 'Annulée'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterOption(OrderStatus? status, String label) {
    final isSelected = _selectedFilter == status;
    return ListTile(
      title: Text(label),
      trailing: isSelected
          ? Icon(Icons.check, color: GlassConstants.accent)
          : null,
      onTap: () {
        setState(() => _selectedFilter = status);
        Navigator.of(context).pop();
      },
    );
  }
}

class _StatusInfo {
  final String label;
  final Color color;

  _StatusInfo(this.label, this.color);
}
