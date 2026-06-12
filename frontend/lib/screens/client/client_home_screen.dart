import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:gazlink_app/providers/auth_provider.dart';
import 'package:gazlink_app/providers/theme_provider.dart';
import 'package:gazlink_app/data/mock_data.dart';
import 'package:gazlink_app/models/models.dart';
import 'package:gazlink_app/screens/client/order_flow_screen.dart';
import 'package:gazlink_app/theme/app_theme.dart';
import 'package:gazlink_app/theme/glass/glass_components.dart';
import 'package:gazlink_app/theme/glass/glass_constants.dart';
import 'package:gazlink_app/widgets/telegram_liquid_nav_bar.dart';
import 'package:gazlink_app/widgets/hide_on_scroll_bottom_nav.dart';
import '../../routes.dart';

class ClientHomeScreen extends StatefulWidget {
  const ClientHomeScreen({Key? key}) : super(key: key);

  @override
  State<ClientHomeScreen> createState() => _ClientHomeScreenState();
}

class _ClientHomeScreenState extends State<ClientHomeScreen>
    with SingleTickerProviderStateMixin {
  static const Duration _pageTransitionDuration = Duration(milliseconds: 300);

  int _selectedIndex = 0;
  Widget? _outgoingPage;
  late final AnimationController _pageTransitionController;
  late final Animation<double> _incomingOpacity;
  late final Animation<double> _incomingScale;
  late final Animation<double> _outgoingOpacity;
  late final Animation<double> _outgoingScale;
  
  // Scroll controllers for each tab
  final ScrollController _homeScrollController = ScrollController();
  final ScrollController _ordersScrollController = ScrollController();
  final ScrollController _settingsScrollController = ScrollController();
  final ScrollController _profileScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _pageTransitionController = AnimationController(
      vsync: this,
      duration: _pageTransitionDuration,
      value: 1,
    );
    final curve = CurvedAnimation(
      parent: _pageTransitionController,
      curve: Curves.easeOutCubic,
    );
    _incomingOpacity = Tween<double>(begin: 0.78, end: 1).animate(curve);
    _incomingScale = Tween<double>(begin: 0.96, end: 1).animate(curve);
    _outgoingOpacity = Tween<double>(begin: 1, end: 0).animate(curve);
    _outgoingScale = Tween<double>(begin: 1, end: 0.97).animate(curve);

    _pageTransitionController.addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted) {
        setState(() => _outgoingPage = null);
      }
    });
  }

  @override
  void dispose() {
    _pageTransitionController.dispose();
    _homeScrollController.dispose();
    _ordersScrollController.dispose();
    _settingsScrollController.dispose();
    _profileScrollController.dispose();
    super.dispose();
  }

  ScrollController _getScrollControllerForIndex(int index) {
    switch (index) {
      case 0:
        return _homeScrollController;
      case 1:
        return _ordersScrollController;
      case 2:
        return _settingsScrollController;
      case 3:
        return _profileScrollController;
      default:
        return _homeScrollController;
    }
  }

  void _onNavTap(int index) {
    if (_selectedIndex == index) {
      return;
    }

    setState(() {
      _outgoingPage = _buildTabForIndex(_selectedIndex);
      _selectedIndex = index;
    });
    _pageTransitionController.forward(from: 0);
  }

  Widget _buildTabForIndex(int index) {
    final scrollController = _getScrollControllerForIndex(index);
    switch (index) {
      case 0:
        return _HomeTab(scrollController: scrollController);
      case 1:
        return _OrdersTab(scrollController: scrollController);
      case 2:
        return _SettingsTab(scrollController: scrollController);
      case 3:
        return _ProfileTab(scrollController: scrollController);
      default:
        return _HomeTab(scrollController: scrollController);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final statusBarStyle = isDarkMode
        ? SystemUiOverlayStyle.light
        : (_selectedIndex == 2
            ? SystemUiOverlayStyle.dark
            : SystemUiOverlayStyle.light);

    return GlassScaffold(
      statusBarStyle: statusBarStyle,
      body: Stack(
        fit: StackFit.expand,
        children: [
          AnimatedBuilder(
            animation: _pageTransitionController,
            child: IndexedStack(
              index: _selectedIndex,
              children: [
                _buildTabForIndex(0),
                _buildTabForIndex(1),
                _buildTabForIndex(2),
                _buildTabForIndex(3),
              ],
            ),
            builder: (context, child) {
              return Opacity(
                opacity: _incomingOpacity.value,
                child: Transform.scale(
                  scale: _incomingScale.value,
                  child: child,
                ),
              );
            },
          ),
          if (_outgoingPage != null)
            IgnorePointer(
              child: AnimatedBuilder(
                animation: _pageTransitionController,
                child: _outgoingPage,
                builder: (context, child) {
                  return Opacity(
                    opacity: _outgoingOpacity.value,
                    child: Transform.scale(
                      scale: _outgoingScale.value,
                      child: child,
                    ),
                  );
                },
              ),
            ),
        ],
      ),
      bottomNavigationBar: HideOnScrollBottomNav(
        scrollController: _getScrollControllerForIndex(_selectedIndex),
        child: TelegramLiquidNavBar(
          currentIndex: _selectedIndex,
          onTap: _onNavTap,
          items: const [
            TelegramNavItemData(
              icon: Icons.home_rounded,
              label: 'Accueil',
            ),
            TelegramNavItemData(
              icon: Icons.receipt_long_rounded,
              label: 'Commandes',
            ),
            TelegramNavItemData(
              icon: Icons.settings_rounded,
              label: 'Réglages',
            ),
            TelegramNavItemData(
              icon: Icons.account_circle_rounded,
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// HOME TAB
// ─────────────────────────────────────────────
class _HomeTab extends StatelessWidget {
  final ScrollController scrollController;

  const _HomeTab({required this.scrollController});

  @override
  Widget build(BuildContext context) {
    final depots = MockData.getMockDepots();

    return CustomScrollView(
      controller: scrollController,
      slivers: [
        // Blue App Bar with search bar below
        SliverAppBar(
          pinned: true,
          expandedHeight: 130,
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          surfaceTintColor: Colors.transparent,
          centerTitle: false,
          flexibleSpace: const _GlassSliverHeaderBackdrop(),
          title: Text(
            'GAZLINK',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color:
                      GlassConstants.titleColor(Theme.of(context).brightness),
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.5,
                ),
          ),
          actions: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.notifications_none_rounded,
                    color:
                        GlassConstants.titleColor(Theme.of(context).brightness),
                    size: 26,
                  ),
                  onPressed: () => Navigator.of(context).pushNamed(AppRoutes.notifications),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    width: 18,
                    height: 18,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Text(
                        '3',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            IconButton(
              icon: Icon(
                Icons.account_circle_outlined,
                color: GlassConstants.titleColor(Theme.of(context).brightness),
                size: 26,
              ),
              onPressed: () => Navigator.of(context).pushNamed(AppRoutes.profile),
            ),
            const SizedBox(width: 4),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(56),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: SizedBox(
                height: 44,
                child: GlassCard(
                  radius: 14,
                  padding: EdgeInsets.zero,
                  child: Row(
                    children: [
                      const SizedBox(width: 12),
                      Icon(
                        Icons.search_rounded,
                        color: GlassConstants.mutedColor(
                          Theme.of(context).brightness,
                        ),
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Rechercher un dépôt...',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: GlassConstants.mutedColor(
                                Theme.of(context).brightness,
                              ),
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),

        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Hero Banner ──
                _HeroBanner(),
                const SizedBox(height: 24),

                // ── Section Title ──
                Row(
                  children: [
                    const Icon(Icons.location_on_rounded,
                        color: AppTheme.lightText, size: 20),
                    const SizedBox(width: 6),
                    Text(
                      'Dépôts à proximité',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color:
                          GlassConstants.titleColor(Theme.of(context).brightness),
                      fontWeight: FontWeight.w800,
                      // letterSpacing: 1.5,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => Navigator.of(context).pushNamed(AppRoutes.depotList),
                      child: Row(
                        children: [
                          Text(
                            'Voir tout',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: AppTheme.primaryBlue,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          const SizedBox(width: 2),
                          const Icon(Icons.chevron_right_rounded,
                              color: AppTheme.primaryBlue, size: 18),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // ── Depot Cards ──
                ...depots.map((depot) => _DepotCard(depot: depot)).toList(),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// HERO BANNER
// ─────────────────────────────────────────────
class _HeroBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            GlassConstants.primaryDark,
            GlassConstants.primaryDarker,
          ],
        ),
      ),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: [
          // Background subtle radial
          Positioned(
            right: -20,
            top: -20,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.06),
              ),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                // Text + CTA
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Gaz fiable.',
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                  height: 1.2,
                                ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Livraison en moins\nd'une heure",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.white.withValues(alpha: 0.85),
                              height: 1.4,
                            ),
                      ),
                      const SizedBox(height: 14),
                      OutlinedButton(
                        onPressed: () => Navigator.of(context).pushNamed(AppRoutes.depotList),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppTheme.primaryBlue,
                          backgroundColor: Colors.white,
                          side: BorderSide.none,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Commander maintenant',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: AppTheme.primaryBlue,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(Icons.chevron_right_rounded,
                                size: 14, color: AppTheme.primaryBlue),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Illustration placeholder (replace with actual asset)
                Expanded(
                  flex: 2,
                  child: Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Clock silhouette
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withValues(alpha: 0.15),
                            border: Border.all(
                                color: Colors.white.withValues(alpha: 0.3),
                                width: 3),
                          ),
                        ),
                        // Gas cylinder icon
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.propane_tank_rounded,
                              color: Color.fromARGB(255, 255, 255, 255),
                              size: 50,
                            ),
                            Text(
                              'GAZLINK',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.9),
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
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

// ─────────────────────────────────────────────
// DEPOT CARD
// ─────────────────────────────────────────────
class _DepotCard extends StatelessWidget {
  final Depot depot;
  const _DepotCard({required this.depot});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Depot photo
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: 80,
              height: 80,
              color: AppTheme.primaryBlue.withValues(alpha: 0.1),
              ///color: GlassConstants.surfaceColor(Theme.of(context).brightness),
              child: const Center(
                child: Icon(
                  Icons.store_rounded,
                  color: AppTheme.primaryBlue,
                  size: 36,
                ),
              ),
              // PRODUCTION: Replace with:
              // Image.network(depot.imageUrl, fit: BoxFit.cover)
              // or Image.asset('assets/images/depot_placeholder.jpg')
            ),
          ),
          const SizedBox(width: 12),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name + verified
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        depot.name,
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (depot.isVerified) ...[
                      const SizedBox(width: 4),
                      const Icon(Icons.verified_rounded,
                          color: AppTheme.primaryBlue, size: 16),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                // Rating
                Row(
                  children: [
                    const Icon(Icons.star_rounded,
                        color: Colors.amber, size: 15),
                    const SizedBox(width: 3),
                    Text(
                      '${depot.rating}  (${depot.reviews})',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: const Color.fromARGB(255, 26, 110, 228),
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                // Distance
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined,
                        color: AppTheme.lightTextSecondary, size: 13),
                    const SizedBox(width: 2),
                    Text(
                      '${depot.distance} km',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.lightTextSecondary,
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          // Products + CTA column
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Bottles row
              Row(
                children: [
                  _GasBottlePrice(
                    weight: '6kg',
                    price: depot.price6kg,
                    inStock: depot.stock6kg > 0,
                  ),
                  const SizedBox(width: 10),
                  _GasBottlePrice(
                    weight: '12.5kg',
                    price: depot.price12kg,
                    inStock: depot.stock12kg > 0,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // Commander button
              SizedBox(
                height: 42,
                child: GlassButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => OrderFlowScreen(depot: depot),
                      ),
                    );
                  },
                  child: const Text(
                    'Commander',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// GAS BOTTLE PRICE WIDGET
// ─────────────────────────────────────────────
class _GasBottlePrice extends StatelessWidget {
  final String weight;
  final int price;
  final bool inStock;

  const _GasBottlePrice({
    required this.weight,
    required this.price,
    required this.inStock,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Icon(
          Icons.propane_tank_rounded,
          color: AppTheme.primaryBlue,
          size: 24,
        ),
        const SizedBox(height: 2),
        Text(
          weight,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: AppTheme.lightText,
              ),
        ),
        Text(
          inStock ? 'En stock' : 'Épuisé',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: inStock ? AppTheme.successGreen : AppTheme.errorRed,
          ),
        ),
        Text(
          '${price ~/ 1000} ${price % 1000 == 0 ? "500" : price % 1000} FCFA',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.primaryBlue,
                fontWeight: FontWeight.w700,
              ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// ORDERS TAB
// ─────────────────────────────────────────────
class _OrdersTab extends StatelessWidget {
  final ScrollController scrollController;

  const _OrdersTab({required this.scrollController});

  @override
  Widget build(BuildContext context) {
    final orders = MockData.getMockOrders();

    return CustomScrollView(
      controller: scrollController,
      slivers: [
        SliverAppBar(
          pinned: true,
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          scrolledUnderElevation: 0,
          flexibleSpace: const _GlassSliverHeaderBackdrop(),
          title: Text(
            'Mes commandes',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color:
                      GlassConstants.titleColor(Theme.of(context).brightness),
                  fontWeight: FontWeight.w800,
                ),
          ),
          centerTitle: true,
        ),
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, i) => _OrderCard(order: orders[i]),
              childCount: orders.length,
            ),
          ),
        ),
      ],
    );
  }
}

class _OrderCard extends StatelessWidget {
  final Order order;
  const _OrderCard({required this.order});

  Color _statusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.delivered:
        return AppTheme.successGreen;
      case OrderStatus.in_delivery:
        return AppTheme.primaryBlue;
      case OrderStatus.confirmed:
      case OrderStatus.pending:
        return AppTheme.warningOrange;
      default:
        return AppTheme.lightTextSecondary;
    }
  }

  String _statusLabel(OrderStatus status) {
    switch (status) {
      case OrderStatus.delivered:
        return 'Livré';
      case OrderStatus.in_delivery:
        return 'En livraison';
      case OrderStatus.confirmed:
        return 'Confirmé';
      case OrderStatus.pending:
        return 'En attente';
      case OrderStatus.assigned:
        return 'Assignée';
      case OrderStatus.cancelled:
        return 'Annulée';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '#${order.id}',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _statusColor(order.status).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _statusLabel(order.status),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: _statusColor(order.status),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            order.depotName,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: AppTheme.lightTextSecondary),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${order.totalPrice} FCFA',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppTheme.primaryBlue,
                      fontWeight: FontWeight.w800,
                    ),
              ),
              if (order.eta != null)
                Row(
                  children: [
                    const Icon(
                      Icons.access_time_rounded,
                      size: 14,
                      color: AppTheme.successGreen,
                    ),
                    const SizedBox(width: 3),
                    Text(
                      order.eta!,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.successGreen,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// PROFILE TAB
// ─────────────────────────────────────────────
class _ProfileTab extends StatelessWidget {
  final ScrollController scrollController;

  const _ProfileTab({required this.scrollController});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return CustomScrollView(
      controller: scrollController,
      slivers: [
        SliverAppBar(
          pinned: true,
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          scrolledUnderElevation: 0,
          flexibleSpace: const _GlassSliverHeaderBackdrop(),
          title: Text('Mon profil',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color:
                        GlassConstants.titleColor(Theme.of(context).brightness),
                    fontWeight: FontWeight.w800,
                  )),
          centerTitle: true,
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const SizedBox(height: 8),
                // Avatar
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryBlue.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.person_rounded,
                      color: AppTheme.primaryBlue, size: 44),
                ),
                const SizedBox(height: 12),
                Text(
                  auth.currentUser?.name ?? 'Utilisateur',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.w800),
                ),
                Text(
                  auth.currentUser?.phone ?? '',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: AppTheme.lightTextSecondary),
                ),
                const SizedBox(height: 24),
                // Menu items
                ...[
                  (Icons.location_on_outlined, 'Mon adresse', AppRoutes.savedAddresses),
                  (Icons.receipt_long_outlined, 'Historique paiements', AppRoutes.paymentHistory),
                  (Icons.notifications_outlined, 'Notifications', AppRoutes.notifications),
                  (Icons.help_outline_rounded, 'Aide & Support', AppRoutes.faq),
                ].map(
                  (item) => GlassListTile(
                    margin: const EdgeInsets.only(bottom: 8),
                    leading: Icon(item.$1, color: AppTheme.lightText, size: 22),
                    title: Text(
                      item.$2,
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(fontWeight: FontWeight.w500),
                    ),
                    trailing: const Icon(Icons.chevron_right_rounded,
                        color: AppTheme.lightTextSecondary, size: 20),
                    onTap: () => Navigator.of(context).pushNamed(item.$3),
                  ),
                ),
                const SizedBox(height: 8),
                // Logout
                GlassListTile(
                  leading: const Icon(Icons.logout_rounded,
                      color: AppTheme.errorRed, size: 22),
                  title: Text('Déconnexion',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppTheme.errorRed,
                          fontWeight: FontWeight.w600)),
                  onTap: () {
                    context.read<AuthProvider>().logout();
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      AppRoutes.login,
                      (route) => false,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// SETTINGS TAB
// ─────────────────────────────────────────────
class _SettingsTab extends StatelessWidget {
  final ScrollController scrollController;

  const _SettingsTab({required this.scrollController});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final themeMode = context.watch<ThemeProvider>().themeMode;

    return CustomScrollView(
      controller: scrollController,
      slivers: [
        SliverAppBar(
          pinned: true,
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          scrolledUnderElevation: 0,
          flexibleSpace: const _GlassSliverHeaderBackdrop(),
          title: Text(
            'Paramètres',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color:
                      GlassConstants.titleColor(Theme.of(context).brightness),
                  fontWeight: FontWeight.w800,
                ),
          ),
          centerTitle: true,
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GlassCard(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: AppTheme.primaryBlue.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.person_rounded,
                            color: AppTheme.primaryBlue, size: 26),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              auth.currentUser?.name ?? 'Utilisateur',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              auth.currentUser?.phone ?? '',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                      color: AppTheme.lightTextSecondary),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right_rounded,
                          color: AppTheme.lightTextSecondary),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  'Apparence',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: GlassConstants.titleColor(
                          Theme.of(context).brightness,
                        ),
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 8),
                GlassCard(
                  child: Column(
                    children: [
                      _ThemeModeTile(
                        title: 'Mode clair',
                        icon: Icons.light_mode_rounded,
                        value: ThemeMode.light,
                        groupValue: themeMode,
                      ),
                      const Divider(height: 1),
                      _ThemeModeTile(
                        title: 'Mode sombre',
                        icon: Icons.dark_mode_rounded,
                        value: ThemeMode.dark,
                        groupValue: themeMode,
                      ),
                      const Divider(height: 1),
                      _ThemeModeTile(
                        title: 'Mode système',
                        icon: Icons.settings_suggest_rounded,
                        value: ThemeMode.system,
                        groupValue: themeMode,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                ...[
                  (
                    Icons.notifications_none_rounded,
                    'Notifications',
                    GlassConstants.infoBlue,
                    AppRoutes.notificationSettings
                  ),
                  (
                    Icons.lock_outline_rounded,
                    'Confidentialité',
                    GlassConstants.successGreen,
                    AppRoutes.privacyPolicy
                  ),
                  (Icons.language_rounded, 'Langue', GlassConstants.warningOrange, AppRoutes.language),
                  (Icons.help_outline_rounded, 'Aide', GlassConstants.helpPurple, AppRoutes.faq),
                ].map(
                  (item) => GlassListTile(
                    leading: Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: item.$3.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(item.$1, color: item.$3, size: 20),
                    ),
                    title: Text(
                      item.$2,
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    trailing: const Icon(Icons.chevron_right_rounded,
                        color: AppTheme.lightTextSecondary, size: 20),
                    onTap: () => Navigator.of(context).pushNamed(item.$4),
                  ),
                ),
                const SizedBox(height: 8),
                GlassListTile(
                  leading: const Icon(Icons.logout_rounded,
                      color: AppTheme.errorRed, size: 22),
                  title: Text(
                    'Déconnexion',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppTheme.errorRed, fontWeight: FontWeight.w700),
                  ),
                  onTap: () {
                    context.read<AuthProvider>().logout();
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      AppRoutes.login,
                      (route) => false,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ThemeModeTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final ThemeMode value;
  final ThemeMode groupValue;

  const _ThemeModeTile({
    required this.title,
    required this.icon,
    required this.value,
    required this.groupValue,
  });

  @override
  Widget build(BuildContext context) {
    final selected = groupValue == value;

    return ListTile(
      onTap: () => context.read<ThemeProvider>().setThemeMode(value),
      leading: Icon(
        icon,
        color: selected ? GlassConstants.accent : AppTheme.lightTextSecondary,
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            ),
      ),
      trailing: Icon(
        selected ? Icons.check_circle_rounded : Icons.circle_outlined,
        color: selected ? GlassConstants.accent : AppTheme.lightTextSecondary,
      ),
    );
  }
}

class _GlassSliverHeaderBackdrop extends StatelessWidget {
  const _GlassSliverHeaderBackdrop();

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: GlassConstants.blur,
          sigmaY: GlassConstants.blur,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: GlassConstants.strongSurfaceColor(brightness),
            border: Border(
              bottom: BorderSide(
                color: GlassConstants.borderColor(brightness),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
