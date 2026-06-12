import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/models.dart';
import '../../providers/auth_provider.dart';
import '../../providers/delivery_provider.dart';
import '../../theme/glass/glass_components.dart';
import '../../theme/glass/glass_constants.dart';
import '../../widgets/hide_on_scroll_bottom_nav.dart';
import '../../widgets/telegram_liquid_nav_bar.dart';
import '../../routes.dart';
import 'delivery_detail_screen.dart';

class DelivererHomeScreen extends StatefulWidget {
  @override
  State<DelivererHomeScreen> createState() => _DelivererHomeScreenState();
}

class _DelivererHomeScreenState extends State<DelivererHomeScreen>
    with SingleTickerProviderStateMixin {
  bool _isAvailable = true;
  int _selectedTabIndex = 0;
  final ScrollController _deliveriesScrollController = ScrollController();
  final ScrollController _statsScrollController = ScrollController();
  
  // Page transition animation
  late final AnimationController _pageTransitionController;
  late final Animation<double> _incomingOpacity;
  late final Animation<double> _incomingScale;
  late final Animation<double> _outgoingOpacity;
  late final Animation<double> _outgoingScale;
  Widget? _outgoingPage;

  @override
  void initState() {
    super.initState();
    
    // Initialize page transition controller
    _pageTransitionController = AnimationController(
      duration: GlassConstants.motionMedium,
      vsync: this,
    );
    
    // Create animations for incoming page
    _incomingOpacity = Tween<double>(begin: 0.78, end: 1.0).animate(
      CurvedAnimation(
        parent: _pageTransitionController,
        curve: Curves.easeOutCubic,
      ),
    );
    
    _incomingScale = Tween<double>(begin: 0.96, end: 1.0).animate(
      CurvedAnimation(
        parent: _pageTransitionController,
        curve: Curves.easeOutCubic,
      ),
    );
    
    // Create animations for outgoing page
    _outgoingOpacity = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _pageTransitionController,
        curve: Curves.easeOutCubic,
      ),
    );
    
    _outgoingScale = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(
        parent: _pageTransitionController,
        curve: Curves.easeOutCubic,
      ),
    );
    
    // Listen for animation completion to clean up outgoing page
    _pageTransitionController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() => _outgoingPage = null);
        _pageTransitionController.reset();
      }
    });
    
    Future.microtask(() {
      context.read<DeliveryProvider>().fetchDeliveries();
    });
  }

  @override
  void dispose() {
    _pageTransitionController.dispose();
    _deliveriesScrollController.dispose();
    _statsScrollController.dispose();
    super.dispose();
  }

  ScrollController get _currentScrollController {
    return _selectedTabIndex == 0
        ? _deliveriesScrollController
        : _statsScrollController;
  }
  
  void _onNavTap(int index) {
    if (index == _selectedTabIndex) return;
    
    // Capture the current page before changing index
    setState(() {
      _outgoingPage = _buildTabForIndex(_selectedTabIndex);
      _selectedTabIndex = index;
    });
    
    // Start the transition animation
    _pageTransitionController.forward();
  }
  
  Widget _buildTabForIndex(int index) {
    return index == 0 ? _buildDeliveriesTab() : _buildStatsTab();
  }

  @override
  Widget build(BuildContext context) {
    return GlassScaffold(
      appBar: GlassAppBar(
        title: const Text('GAZLINK Livreur'),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () => _showProfileMenu(context),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Outgoing page (fading out and scaling down)
          if (_outgoingPage != null)
            FadeTransition(
              opacity: _outgoingOpacity,
              child: ScaleTransition(
                scale: _outgoingScale,
                child: _outgoingPage!,
              ),
            ),
          // Incoming page (fading in and scaling up)
          FadeTransition(
            opacity: _incomingOpacity,
            child: ScaleTransition(
              scale: _incomingScale,
              child: _buildTabForIndex(_selectedTabIndex),
            ),
          ),
        ],
      ),
      bottomNavigationBar: HideOnScrollBottomNav(
        scrollController: _currentScrollController,
        child: TelegramLiquidNavBar(
          currentIndex: _selectedTabIndex,
          onTap: _onNavTap,
          activeColor: GlassConstants.accent,
          items: const [
            TelegramNavItemData(
              icon: Icons.local_shipping_rounded,
              label: 'Livraisons',
            ),
            TelegramNavItemData(
              icon: Icons.bar_chart_rounded,
              label: 'Statistiques',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeliveriesTab() {
    final brightness = Theme.of(context).brightness;
    
    return SingleChildScrollView(
      controller: _deliveriesScrollController,
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Availability Card
          GlassCard(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Statut',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: GlassConstants.titleColor(brightness),
                        ),
                      ),
                      SizedBox(height: 8),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: _isAvailable
                              ? Colors.green.withValues(alpha: 0.1)
                              : Colors.red.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          _isAvailable ? 'Disponible' : 'Indisponible',
                          style: TextStyle(
                            color: _isAvailable ? Colors.green : Colors.red,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Switch(
                    value: _isAvailable,
                    onChanged: (value) => setState(() => _isAvailable = value),
                    activeThumbColor: Colors.green,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 24),
          // Deliveries List
          Text(
            'Livraisons d\'aujourd\'hui',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: GlassConstants.titleColor(brightness),
            ),
          ),
          SizedBox(height: 12),
          Consumer<DeliveryProvider>(
            builder: (context, deliveryProvider, _) {
              if (deliveryProvider.isLoading) {
                return Center(child: CircularProgressIndicator());
              }

              if (deliveryProvider.deliveries.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.local_shipping_outlined,
                        size: 64,
                        color: GlassConstants.mutedColor(brightness),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Aucune livraison',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: GlassConstants.bodyColor(brightness),
                        ),
                      ),
                    ],
                  ),
                );
              }

              return Column(
                children: deliveryProvider.deliveries
                    .map((delivery) => _buildDeliveryCard(context, delivery))
                    .toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryCard(BuildContext context, Delivery delivery) {
    final brightness = Theme.of(context).brightness;
    
    return GlassCard(
      margin: EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        delivery.clientName,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: GlassConstants.titleColor(brightness),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        delivery.clientPhone,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: GlassConstants.bodyColor(brightness),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color:
                        _getStatusColor(delivery.status).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    _getStatusLabel(delivery.status),
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: _getStatusColor(delivery.status)),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  Icons.location_on,
                  size: 16,
                  color: GlassConstants.mutedColor(brightness),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    delivery.deliveryAddress,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: GlassConstants.mutedColor(brightness),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'ETA: ${_getTimeRemaining(delivery)}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: GlassConstants.accent,
                  ),
                ),
                GlassButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (_) =>
                            DeliveryDetailScreen(delivery: delivery)),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Text('Détails'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsTab() {
    final brightness = Theme.of(context).brightness;
    
    return SingleChildScrollView(
      controller: _statsScrollController,
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Statistiques d\'aujourd\'hui',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: GlassConstants.titleColor(brightness),
            ),
          ),
          SizedBox(height: 16),
          _buildStatCard('Livraisons', '8', Colors.blue),
          SizedBox(height: 12),
          _buildStatCard('Complétées', '6', Colors.green),
          SizedBox(height: 12),
          _buildStatCard('En cours', '2', Colors.orange),
          SizedBox(height: 24),
          Text(
            'Revenus',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: GlassConstants.titleColor(brightness),
            ),
          ),
          SizedBox(height: 16),
          GlassCard(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total du jour',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: GlassConstants.bodyColor(brightness),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text('45 000 FCFA',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: GlassConstants.accent)),
                  SizedBox(height: 16),
                  Divider(),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Revenu moyen par livraison',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: GlassConstants.mutedColor(brightness),
                        ),
                      ),
                      Text(
                        '5 625 FCFA',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: GlassConstants.bodyColor(brightness),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Bonus de performance',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: GlassConstants.mutedColor(brightness),
                        ),
                      ),
                      Text('+ 3 000 FCFA',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.green)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, Color color) {
    final brightness = Theme.of(context).brightness;
    
    return GlassCard(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: GlassConstants.bodyColor(brightness),
                  ),
                ),
                SizedBox(height: 8),
                Text(value,
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: color)),
              ],
            ),
            Icon(Icons.trending_up,
                size: 32, color: color.withValues(alpha: 0.3)),
          ],
        ),
      ),
    );
  }

  String _getStatusLabel(OrderStatus status) {
    switch (status) {
      case OrderStatus.assigned:
        return 'Assignée';
      case OrderStatus.in_delivery:
        return 'En livraison';
      case OrderStatus.delivered:
        return 'Livrée';
      default:
        return 'En attente';
    }
  }

  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.assigned:
        return Colors.blue;
      case OrderStatus.in_delivery:
        return Colors.orange;
      case OrderStatus.delivered:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String _getTimeRemaining(Delivery delivery) {
    final now = DateTime.now();
    final estimated = delivery.assignedAt.add(Duration(minutes: 45));
    final remaining = estimated.difference(now);

    if (remaining.isNegative) {
      return 'Retard';
    }

    final minutes = remaining.inMinutes;
    if (minutes < 1) {
      return 'Imminent';
    }
    return '${minutes} min';
  }

  void _showProfileMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
        child: GlassCard(
          radius: GlassConstants.radiusL,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Mon profil'),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Paramètres'),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Déconnexion'),
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
    );
  }
}
