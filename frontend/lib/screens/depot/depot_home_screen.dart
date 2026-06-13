import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:ui';
import '../../models/models.dart';
import '../../providers/auth_provider.dart';
import '../../providers/depot_provider.dart';
import '../../theme/app_theme.dart';
import '../../theme/glass/glass_components.dart';
import '../../theme/glass/glass_constants.dart';
import '../../routes.dart';
import 'depot_orders_screen.dart';
import 'depot_stock_screen.dart';
import 'depot_deliverers_screen.dart';

class DepotHomeScreen extends StatefulWidget {
  const DepotHomeScreen({Key? key}) : super(key: key);

  @override
  State<DepotHomeScreen> createState() => _DepotHomeScreenState();
}

class _DepotHomeScreenState extends State<DepotHomeScreen> {
  int _selectedIndex = 0;

  final List<_NavItem> _navItems = const [
    _NavItem(icon: Icons.dashboard_rounded, label: 'Dashboard'),
    _NavItem(icon: Icons.receipt_long_rounded, label: 'Commandes'),
    _NavItem(icon: Icons.inventory_2_rounded, label: 'Stock'),
    _NavItem(icon: Icons.people_rounded, label: 'Livreurs'),
  ];

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final auth = context.read<AuthProvider>();
      final depotId = auth.currentUser?.depotId ?? 'DEP-001';
      context.read<DepotProvider>().init(depotId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Contenu principal
          IndexedStack(
            index: _selectedIndex,
            children: const [
              _DashboardTab(),
              DepotOrdersTab(),
              DepotStockTab(),
              DepotDeliverersTab(),
            ],
          ),
          // Bottom nav glass
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _GlassBottomNav(
              items: _navItems,
              currentIndex: _selectedIndex,
              onTap: (i) => setState(() => _selectedIndex = i),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// BOTTOM NAV
// ─────────────────────────────────────────────
class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem({required this.icon, required this.label});
}

class _GlassBottomNav extends StatelessWidget {
  final List<_NavItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _GlassBottomNav({
    required this.items,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: GlassConstants.blur, sigmaY: GlassConstants.blur),
        child: Container(
          decoration: BoxDecoration(
            color: GlassConstants.strongSurfaceColor(brightness),
            border: Border(
              top: BorderSide(color: GlassConstants.borderColor(brightness)),
            ),
          ),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).padding.bottom + 4,
            top: 8,
          ),
          child: Row(
            children: List.generate(items.length, (i) {
              final item = items[i];
              final selected = i == currentIndex;
              return Expanded(
                child: GestureDetector(
                  onTap: () => onTap(i),
                  behavior: HitTestBehavior.opaque,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 6),
                        decoration: BoxDecoration(
                          color: selected
                              ? GlassConstants.accent.withValues(alpha: 0.15)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(
                          item.icon,
                          size: 22,
                          color: selected
                              ? GlassConstants.accent
                              : GlassConstants.mutedColor(brightness),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.label,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: selected
                              ? FontWeight.w700
                              : FontWeight.w400,
                          color: selected
                              ? GlassConstants.accent
                              : GlassConstants.mutedColor(brightness),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// DASHBOARD TAB
// ─────────────────────────────────────────────
class _DashboardTab extends StatelessWidget {
  const _DashboardTab();

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final auth = context.watch<AuthProvider>();

    return CustomScrollView(
      slivers: [
        // AppBar
        SliverAppBar(
          pinned: true,
          expandedHeight: 100,
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          surfaceTintColor: Colors.transparent,
          flexibleSpace: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(
                  sigmaX: GlassConstants.blur,
                  sigmaY: GlassConstants.blur),
              child: Container(
                decoration: BoxDecoration(
                  color: GlassConstants.strongSurfaceColor(brightness),
                  border: Border(
                    bottom: BorderSide(
                        color: GlassConstants.borderColor(brightness)),
                  ),
                ),
              ),
            ),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'GAZLINK Dépôt',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: GlassConstants.titleColor(brightness),
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                    ),
              ),
              Consumer<DepotProvider>(
                builder: (_, p, __) => Text(
                  p.isLoading ? 'Chargement…' : p.depot.name,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: GlassConstants.mutedColor(brightness),
                      ),
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.notifications_none_rounded,
                  color: GlassConstants.titleColor(brightness)),
              onPressed: () =>
                  Navigator.of(context).pushNamed(AppRoutes.notifications),
            ),
            IconButton(
              icon: Icon(Icons.account_circle_outlined,
                  color: GlassConstants.titleColor(brightness)),
              onPressed: () =>
                  Navigator.of(context).pushNamed(AppRoutes.profile),
            ),
            const SizedBox(width: 4),
          ],
        ),

        SliverToBoxAdapter(
          child: Consumer<DepotProvider>(
            builder: (context, depot, _) {
              if (depot.isLoading) {
                return const SizedBox(
                  height: 300,
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              return Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Alerte stock bas
                    if (depot.depot.hasLowStock) _StockAlert(depot: depot.depot),

                    // Statut ouverture
                    _OpenStatusBanner(depot: depot.depot),
                    const SizedBox(height: 16),

                    // Stats du jour
                    _SectionTitle('Aujourd\'hui', brightness),
                    const SizedBox(height: 12),
                    _StatsGrid(stats: depot.todayStats),
                    const SizedBox(height: 24),

                    // Commandes en attente
                    _SectionTitle('En attente de confirmation', brightness),
                    const SizedBox(height: 12),
                    if (depot.pendingOrders.isEmpty)
                      _EmptyState(
                          icon: Icons.check_circle_outline_rounded,
                          message: 'Aucune commande en attente')
                    else
                      ...depot.pendingOrders
                          .map((o) => _PendingOrderCard(
                                order: o,
                                onConfirm: () => depot.confirmOrder(o.id),
                              ))
                          .toList(),
                    const SizedBox(height: 24),

                    // Stock rapide
                    _SectionTitle('Stock rapide', brightness),
                    const SizedBox(height: 12),
                    _QuickStockCard(depot: depot.depot),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// WIDGETS DASHBOARD
// ─────────────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  final String title;
  final Brightness brightness;
  const _SectionTitle(this.title, this.brightness);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: GlassConstants.titleColor(brightness),
            fontWeight: FontWeight.w700,
          ),
    );
  }
}

class _OpenStatusBanner extends StatelessWidget {
  final Depot depot;
  const _OpenStatusBanner({required this.depot});

  @override
  Widget build(BuildContext context) {
    final isOpen = depot.isCurrentlyOpen;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: isOpen
            ? Colors.green.withValues(alpha: 0.1)
            : Colors.red.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isOpen
              ? Colors.green.withValues(alpha: 0.3)
              : Colors.red.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            isOpen ? Icons.store_rounded : Icons.store_mall_directory_outlined,
            color: isOpen ? Colors.green : Colors.red,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              isOpen
                  ? 'Dépôt ouvert · Ferme à ${depot.closeTime}'
                  : 'Dépôt fermé · Ouvre à ${depot.openTime}',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: isOpen ? Colors.green : Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StockAlert extends StatelessWidget {
  final Depot depot;
  const _StockAlert({required this.depot});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.orange.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_rounded,
              color: Colors.orange, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Stock bas détecté',
                  style: TextStyle(
                      fontWeight: FontWeight.w700, color: Colors.orange),
                ),
                Text(
                  'Vérifiez les niveaux dans l\'onglet Stock',
                  style: TextStyle(
                      fontSize: 12,
                      color: Colors.orange.withValues(alpha: 0.8)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsGrid extends StatelessWidget {
  final Map<String, dynamic> stats;
  const _StatsGrid({required this.stats});

  @override
  Widget build(BuildContext context) {
    final items = [
      _StatItem(
          label: 'Commandes',
          value: '${stats['totalToday']}',
          color: AppTheme.primaryBlue,
          icon: Icons.receipt_long_rounded),
      _StatItem(
          label: 'Livrées',
          value: '${stats['deliveredToday']}',
          color: Colors.green,
          icon: Icons.check_circle_rounded),
      _StatItem(
          label: 'En attente',
          value: '${stats['pendingOrders']}',
          color: Colors.orange,
          icon: Icons.hourglass_top_rounded),
      _StatItem(
          label: 'Revenu',
          value: '${_formatAmount(stats['revenueToday'])} F',
          color: AppTheme.primaryBlue,
          icon: Icons.payments_rounded),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.7,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: items.length,
      itemBuilder: (_, i) => _StatCard(item: items[i]),
    );
  }

  String _formatAmount(dynamic val) {
    final v = (val as double).toInt();
    if (v >= 1000) return '${(v / 1000).toStringAsFixed(0)}k';
    return '$v';
  }
}

class _StatItem {
  final String label;
  final String value;
  final Color color;
  final IconData icon;
  const _StatItem(
      {required this.label,
      required this.value,
      required this.color,
      required this.icon});
}

class _StatCard extends StatelessWidget {
  final _StatItem item;
  const _StatCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: item.color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(item.icon, color: item.color, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  item.value,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: item.color),
                ),
                Text(
                  item.label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: GlassConstants.mutedColor(
                            Theme.of(context).brightness),
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PendingOrderCard extends StatelessWidget {
  final Order order;
  final VoidCallback onConfirm;

  const _PendingOrderCard({required this.order, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    return GlassCard(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '#${order.id}',
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      order.deliveryAddress ?? 'Adresse non définie',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: GlassConstants.mutedColor(brightness),
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              _PriorityBadge(priority: order.priority),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              // Bouteilles commandées
              _BottleSummary(order: order),
              const Spacer(),
              // Prix + subvention
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Ce que reçoit le dépôt
                  Text(
                    '${order.totalPrice.toInt()} FCFA',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: AppTheme.primaryBlue,
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  Text(
                    'Subvention: −${order.subsidyAmount.toInt()} F',
                    style: const TextStyle(
                        fontSize: 10,
                        color: Colors.orange,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: GlassButton(
              onPressed: onConfirm,
              child: const Text(
                'Confirmer la commande',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BottleSummary extends StatelessWidget {
  final Order order;
  const _BottleSummary({required this.order});

  @override
  Widget build(BuildContext context) {
    final parts = <String>[];
    if (order.quantity6kg > 0) parts.add('${order.quantity6kg}×6kg');
    if (order.quantity12kg > 0) parts.add('${order.quantity12kg}×12.5kg');
    if (order.quantity24kg > 0) parts.add('${order.quantity24kg}×24kg');

    return Row(
      children: [
        const Icon(Icons.propane_tank_rounded,
            size: 16, color: AppTheme.primaryBlue),
        const SizedBox(width: 4),
        Text(
          parts.join('  '),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }
}

class _QuickStockCard extends StatelessWidget {
  final Depot depot;
  const _QuickStockCard({required this.depot});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        children: [
          _StockRow(
            label: '6 kg',
            full: depot.stock6kg,
            empty: depot.emptyBottles6kg,
            exchange: depot.exchangeBottles6kg,
            isLow: depot.stock6kg <= depot.stockAlertThreshold,
          ),
          const Divider(height: 1),
          _StockRow(
            label: '12.5 kg',
            full: depot.stock12kg,
            empty: depot.emptyBottles12kg,
            exchange: depot.exchangeBottles12kg,
            isLow: depot.stock12kg <= depot.stockAlertThreshold,
          ),
          const Divider(height: 1),
          _StockRow(
            label: '24 kg',
            full: depot.stock24kg,
            empty: depot.emptyBottles24kg,
            exchange: depot.exchangeBottles24kg,
            isLow: depot.stock24kg <= depot.stockAlertThreshold,
          ),
        ],
      ),
    );
  }
}

class _StockRow extends StatelessWidget {
  final String label;
  final int full;
  final int empty;
  final int exchange;
  final bool isLow;

  const _StockRow({
    required this.label,
    required this.full,
    required this.empty,
    required this.exchange,
    this.isLow = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
          SizedBox(
            width: 50,
            child: Row(
              children: [
                if (isLow)
                  const Icon(Icons.warning_amber_rounded,
                      size: 14, color: Colors.orange),
                if (isLow) const SizedBox(width: 4),
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: isLow ? Colors.orange : null,
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          _StockChip(
              icon: Icons.propane_tank_rounded,
              value: full,
              color: Colors.green,
              tooltip: 'Pleines'),
          const SizedBox(width: 8),
          _StockChip(
              icon: Icons.propane_tank_outlined,
              value: empty,
              color: Colors.grey,
              tooltip: 'Vides'),
          const SizedBox(width: 8),
          _StockChip(
              icon: Icons.swap_horiz_rounded,
              value: exchange,
              color: Colors.blue,
              tooltip: 'Échange'),
        ],
      ),
    );
  }
}

class _StockChip extends StatelessWidget {
  final IconData icon;
  final int value;
  final Color color;
  final String tooltip;

  const _StockChip({
    required this.icon,
    required this.value,
    required this.color,
    required this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color.withValues(alpha: 0.7)),
          const SizedBox(width: 3),
          Text(
            '$value',
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: color),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String message;
  const _EmptyState({required this.icon, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            Icon(icon,
                size: 48,
                color: GlassConstants.mutedColor(
                    Theme.of(context).brightness)),
            const SizedBox(height: 8),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: GlassConstants.mutedColor(
                        Theme.of(context).brightness),
                  ),
            ),
          ],
        ),
      ),
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        priority.label,
        style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: color),
      ),
    );
  }
}
