import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/models.dart';
import '../../providers/depot_provider.dart';
import '../../theme/app_theme.dart';
import '../../theme/glass/glass_components.dart';
import '../../theme/glass/glass_constants.dart';

class DepotOrdersTab extends StatefulWidget {
  const DepotOrdersTab({Key? key}) : super(key: key);

  @override
  State<DepotOrdersTab> createState() => _DepotOrdersTabState();
}

class _DepotOrdersTabState extends State<DepotOrdersTab>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    return Consumer<DepotProvider>(
      builder: (context, depotProv, _) {
        final allOrders = depotProv.orders;
        final pending = allOrders
            .where((o) =>
                o.status == OrderStatus.pending ||
                o.status == OrderStatus.confirmed)
            .toList();
        final active = allOrders
            .where((o) =>
                o.status == OrderStatus.assigned ||
                o.status == OrderStatus.in_delivery)
            .toList();
        final done = allOrders
            .where((o) =>
                o.status == OrderStatus.delivered ||
                o.status == OrderStatus.cancelled)
            .toList();

        return Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            scrolledUnderElevation: 0,
            title: Text(
              'Commandes',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: GlassConstants.titleColor(brightness),
                    fontWeight: FontWeight.w800,
                  ),
            ),
            bottom: TabBar(
              controller: _tabController,
              indicatorColor: GlassConstants.accent,
              labelColor: GlassConstants.accent,
              unselectedLabelColor: GlassConstants.mutedColor(brightness),
              tabs: [
                Tab(text: 'En attente (${pending.length})'),
                Tab(text: 'En cours (${active.length})'),
                Tab(text: 'Terminées'),
              ],
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              _OrderList(
                orders: pending,
                emptyMessage: 'Aucune commande en attente',
                showConfirmButton: true,
                depotProv: depotProv,
              ),
              _OrderList(
                orders: active,
                emptyMessage: 'Aucune livraison en cours',
                depotProv: depotProv,
              ),
              _OrderList(
                orders: done,
                emptyMessage: 'Aucune commande terminée aujourd\'hui',
                depotProv: depotProv,
              ),
            ],
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────
// ORDER LIST
// ─────────────────────────────────────────────
class _OrderList extends StatelessWidget {
  final List<Order> orders;
  final String emptyMessage;
  final bool showConfirmButton;
  final DepotProvider depotProv;

  const _OrderList({
    required this.orders,
    required this.emptyMessage,
    this.showConfirmButton = false,
    required this.depotProv,
  });

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_rounded,
              size: 56,
              color:
                  GlassConstants.mutedColor(Theme.of(context).brightness),
            ),
            const SizedBox(height: 12),
            Text(
              emptyMessage,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: GlassConstants.mutedColor(
                        Theme.of(context).brightness),
                  ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      itemCount: orders.length,
      itemBuilder: (_, i) => _OrderCard(
        order: orders[i],
        showConfirmButton: showConfirmButton,
        depotProv: depotProv,
      ),
    );
  }
}

// ─────────────────────────────────────────────
// ORDER CARD
// ─────────────────────────────────────────────
class _OrderCard extends StatelessWidget {
  final Order order;
  final bool showConfirmButton;
  final DepotProvider depotProv;

  const _OrderCard({
    required this.order,
    required this.showConfirmButton,
    required this.depotProv,
  });

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    return GlassCard(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Expanded(
                child: Text(
                  '#${order.id}',
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              _PriorityBadge(priority: order.priority),
              const SizedBox(width: 8),
              _StatusBadge(status: order.status),
            ],
          ),
          const SizedBox(height: 8),

          // Adresse
          Row(
            children: [
              const Icon(Icons.location_on_outlined,
                  size: 14, color: AppTheme.lightTextSecondary),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  order.deliveryAddress ?? 'Adresse non précisée',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: GlassConstants.mutedColor(brightness),
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Bouteilles + prix
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _BottlesSummary(order: order),
              _PriceDisplay(order: order),
            ],
          ),

          // Boutons action
          if (showConfirmButton && order.status == OrderStatus.pending) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _showCancelDialog(context),
                    child: const Text('Refuser'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 2,
                  child: GlassButton(
                    onPressed: () => depotProv.confirmOrder(order.id),
                    child: const Text(
                      'Confirmer',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),
          ],

          // Assignation livreur (commande confirmée)
          if (order.status == OrderStatus.confirmed) ...[
            const SizedBox(height: 12),
            GlassButton(
              onPressed: () => _showAssignDialog(context),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.person_add_rounded, size: 16),
                  SizedBox(width: 6),
                  Text(
                    'Assigner un livreur',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
          ],

          // Livreur assigné
          if (order.delivererId != null &&
              order.status == OrderStatus.assigned) ...[
            const SizedBox(height: 8),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.bike_scooter_rounded,
                      size: 14, color: Colors.blue),
                  const SizedBox(width: 6),
                  Text(
                    'Livreur assigné · En route',
                    style: const TextStyle(
                        fontSize: 12,
                        color: Colors.blue,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showAssignDialog(BuildContext context) {
    final deliverers = depotProv.activeDeliverers;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        child: GlassCard(
          radius: GlassConstants.radiusL,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Choisir un livreur',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              const Divider(height: 1),
              if (deliverers.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text('Aucun livreur disponible'),
                )
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: deliverers.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (_, i) {
                    final d = deliverers[i];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor:
                            GlassConstants.accent.withValues(alpha: 0.15),
                        child: Text(
                          d.name.substring(0, 1).toUpperCase(),
                          style: TextStyle(
                              color: GlassConstants.accent,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                      title: Text(d.name,
                          style: const TextStyle(fontWeight: FontWeight.w600)),
                      subtitle: Row(
                        children: [
                          const Icon(Icons.star_rounded,
                              size: 13, color: Colors.amber),
                          const SizedBox(width: 3),
                          Text('${d.rating}  ·  ${d.totalOrders} livraisons'),
                        ],
                      ),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () {
                        Navigator.pop(context);
                        depotProv.assignDeliverer(order.id, d.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(
                                  '${d.name} assigné à la commande #${order.id}')),
                        );
                      },
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCancelDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Refuser la commande ?'),
        content: const Text(
            'Le client sera notifié du refus. Cette action est irréversible.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Commande refusée')),
              );
            },
            child: const Text('Refuser',
                style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// WIDGETS PARTAGÉS
// ─────────────────────────────────────────────

class _PriceDisplay extends StatelessWidget {
  final Order order;
  const _PriceDisplay({required this.order});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Montant reçu par le dépôt (prix plein)
        Text(
          '${order.totalPrice.toInt()} FCFA',
          style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: AppTheme.primaryBlue),
        ),
        // Subvention supportée par GAZLINK
        Text(
          'Subvention: −${order.subsidyAmount.toInt()} F',
          style: const TextStyle(
              fontSize: 10, color: Colors.orange, fontWeight: FontWeight.w600),
        ),
        // Frais de livraison si présents
        if (order.deliveryFee > 0)
          Text(
            'Livraison: +${order.deliveryFee} F',
            style: const TextStyle(
                fontSize: 10,
                color: Colors.green,
                fontWeight: FontWeight.w600),
          ),
      ],
    );
  }
}

class _BottlesSummary extends StatelessWidget {
  final Order order;
  const _BottlesSummary({required this.order});

  @override
  Widget build(BuildContext context) {
    final parts = <String>[];
    if (order.quantity6kg > 0) parts.add('${order.quantity6kg}×6kg');
    if (order.quantity12kg > 0) parts.add('${order.quantity12kg}×12.5kg');
    if (order.quantity24kg > 0) parts.add('${order.quantity24kg}×24kg');

    return Row(
      children: [
        const Icon(Icons.propane_tank_rounded,
            size: 15, color: AppTheme.primaryBlue),
        const SizedBox(width: 4),
        Text(
          parts.join('  '),
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

class _PriorityBadge extends StatelessWidget {
  final DeliveryPriority priority;
  const _PriorityBadge({required this.priority});

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (priority) {
      case DeliveryPriority.urgent:
        color = Colors.red;
        break;
      case DeliveryPriority.express:
        color = Colors.orange;
        break;
      case DeliveryPriority.normal:
        color = Colors.green;
        break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        priority.label,
        style: TextStyle(
            fontSize: 10, fontWeight: FontWeight.w700, color: color),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final OrderStatus status;
  const _StatusBadge({required this.status});

  String get _label {
    switch (status) {
      case OrderStatus.pending:     return 'En attente';
      case OrderStatus.confirmed:   return 'Confirmée';
      case OrderStatus.assigned:    return 'Assignée';
      case OrderStatus.in_delivery: return 'En livraison';
      case OrderStatus.delivered:   return 'Livrée';
      case OrderStatus.cancelled:   return 'Annulée';
    }
  }

  Color get _color {
    switch (status) {
      case OrderStatus.pending:     return Colors.orange;
      case OrderStatus.confirmed:   return Colors.blue;
      case OrderStatus.assigned:    return Colors.purple;
      case OrderStatus.in_delivery: return Colors.teal;
      case OrderStatus.delivered:   return Colors.green;
      case OrderStatus.cancelled:   return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        _label,
        style: TextStyle(
            fontSize: 10, fontWeight: FontWeight.w700, color: _color),
      ),
    );
  }
}
