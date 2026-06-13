import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'dart:ui';
import '../../models/models.dart';
import '../../providers/auth_provider.dart';
import '../../providers/delivery_provider.dart';
import '../../theme/glass/glass_components.dart';
import '../../theme/glass/glass_constants.dart';
import '../../routes.dart';
import 'delivery_detail_screen.dart';

class DelivererHomeScreen extends StatefulWidget {
  @override
  State<DelivererHomeScreen> createState() => _DelivererHomeScreenState();
}

class _DelivererHomeScreenState extends State<DelivererHomeScreen>
    with TickerProviderStateMixin {
  bool _isOnline = true;
  int _selectedTab = 0; // 0 = livraisons, 1 = stats
  late AnimationController _onlineToggleController;
  late AnimationController _sheetController;
  late Animation<double> _sheetAnimation;

  // Bottom sheet drag
  double _sheetPosition = 0.38; // 0.0 = fermé, 1.0 = plein écran
  final double _minSheet = 0.28;
  final double _maxSheet = 0.82;

  @override
  void initState() {
    super.initState();
    _onlineToggleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _sheetController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _sheetAnimation = Tween<double>(begin: _sheetPosition, end: _sheetPosition)
        .animate(CurvedAnimation(
            parent: _sheetController, curve: Curves.easeOutCubic));

    Future.microtask(
        () => context.read<DeliveryProvider>().fetchDeliveries());
  }

  @override
  void dispose() {
    _onlineToggleController.dispose();
    _sheetController.dispose();
    super.dispose();
  }

  void _snapSheet(double velocity) {
    final target = velocity > 300 || _sheetPosition > 0.55
        ? _maxSheet
        : _minSheet;
    setState(() => _sheetPosition = target);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    return Scaffold(
      backgroundColor: const Color(0xFF0F1923),
      body: Stack(
        children: [
          // ── FOND CARTE MOCK ──
          _MockMap(isOnline: _isOnline),

          // ── HEADER FLOTTANT ──
          Positioned(
            top: MediaQuery.of(context).padding.top + 12,
            left: 16,
            right: 16,
            child: _FloatingHeader(
              isOnline: _isOnline,
              onToggle: () => setState(() => _isOnline = !_isOnline),
              onProfile: () => _showProfileSheet(context),
              selectedTab: _selectedTab,
              onTabChange: (i) => setState(() => _selectedTab = i),
            ),
          ),

          // ── STATS COMPACTES (quand online) ──
          if (_isOnline && _selectedTab == 0)
            Positioned(
              top: MediaQuery.of(context).padding.top + 90,
              left: 16,
              right: 16,
              child: const _CompactStats(),
            ),

          // ── BOTTOM SHEET DRAGGABLE ──
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: size.height * _sheetPosition,
            child: GestureDetector(
              onVerticalDragUpdate: (d) {
                setState(() {
                  _sheetPosition -= d.delta.dy / size.height;
                  _sheetPosition =
                      _sheetPosition.clamp(_minSheet, _maxSheet);
                });
              },
              onVerticalDragEnd: (d) =>
                  _snapSheet(d.primaryVelocity ?? 0),
              child: _selectedTab == 0
                  ? _DeliveriesSheet(isOnline: _isOnline)
                  : _StatsSheet(),
            ),
          ),
        ],
      ),
    );
  }

  void _showProfileSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _ProfileSheet(),
    );
  }
}

// ─────────────────────────────────────────────
// MOCK MAP — remplacer par GoogleMap() quand clé API prête
// ─────────────────────────────────────────────
class _MockMap extends StatefulWidget {
  final bool isOnline;
  const _MockMap({required this.isOnline});

  @override
  State<_MockMap> createState() => _MockMapState();
}

class _MockMapState extends State<_MockMap> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _pulseAnimation =
        Tween<double>(begin: 0.6, end: 1.0).animate(_pulseController);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 600),
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: widget.isOnline
              ? [const Color(0xFF0D1B2A), const Color(0xFF1B2838), const Color(0xFF0A1628)]
              : [const Color(0xFF1A1A1A), const Color(0xFF2A2A2A), const Color(0xFF1A1A1A)],
        ),
      ),
      child: Stack(
        children: [
          // Grille de rues simulée
          CustomPaint(
            size: Size.infinite,
            painter: _MapGridPainter(isOnline: widget.isOnline),
          ),
          // Point de position livreur
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (_, __) => Stack(
                    alignment: Alignment.center,
                    children: [
                      // Cercle de pulsation
                      Container(
                        width: 60 * _pulseAnimation.value,
                        height: 60 * _pulseAnimation.value,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: (widget.isOnline
                                  ? const Color(0xFF00C853)
                                  : Colors.grey)
                              .withValues(alpha: 0.15),
                        ),
                      ),
                      // Point central
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: widget.isOnline
                              ? const Color(0xFF00C853)
                              : Colors.grey,
                          border: Border.all(color: Colors.white, width: 3),
                          boxShadow: [
                            BoxShadow(
                              color: (widget.isOnline
                                      ? const Color(0xFF00C853)
                                      : Colors.grey)
                                  .withValues(alpha: 0.5),
                              blurRadius: 12,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    'Bonapriso, Douala',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
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

class _MapGridPainter extends CustomPainter {
  final bool isOnline;
  const _MapGridPainter({required this.isOnline});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = (isOnline ? const Color(0xFF1E3A5F) : const Color(0xFF2A2A2A))
          .withValues(alpha: 0.6)
      ..strokeWidth = 1;

    // Rues horizontales
    for (double y = 0; y < size.height; y += 60) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
    // Rues verticales
    for (double x = 0; x < size.width; x += 80) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    // Quelques rues plus larges (axes principaux)
    final mainPaint = Paint()
      ..color = (isOnline ? const Color(0xFF2E5A8E) : const Color(0xFF3A3A3A))
          .withValues(alpha: 0.8)
      ..strokeWidth = 2.5;

    canvas.drawLine(
        Offset(size.width * 0.3, 0), Offset(size.width * 0.3, size.height), mainPaint);
    canvas.drawLine(
        Offset(size.width * 0.7, 0), Offset(size.width * 0.7, size.height), mainPaint);
    canvas.drawLine(
        Offset(0, size.height * 0.35), Offset(size.width, size.height * 0.35), mainPaint);
    canvas.drawLine(
        Offset(0, size.height * 0.65), Offset(size.width, size.height * 0.65), mainPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─────────────────────────────────────────────
// HEADER FLOTTANT
// ─────────────────────────────────────────────
class _FloatingHeader extends StatelessWidget {
  final bool isOnline;
  final VoidCallback onToggle;
  final VoidCallback onProfile;
  final int selectedTab;
  final ValueChanged<int> onTabChange;

  const _FloatingHeader({
    required this.isOnline,
    required this.onToggle,
    required this.onProfile,
    required this.selectedTab,
    required this.onTabChange,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Toggle online/offline
        GestureDetector(
          onTap: onToggle,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: isOnline
                      ? const Color(0xFF00C853).withValues(alpha: 0.25)
                      : Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: isOnline
                        ? const Color(0xFF00C853).withValues(alpha: 0.5)
                        : Colors.white.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 400),
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isOnline
                            ? const Color(0xFF00C853)
                            : Colors.grey,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      isOnline ? 'En ligne' : 'Hors ligne',
                      style: TextStyle(
                        color: isOnline
                            ? const Color(0xFF00C853)
                            : Colors.white.withValues(alpha: 0.7),
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const Spacer(),
        // Tabs Livraisons / Stats
        ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                    color: Colors.white.withValues(alpha: 0.15)),
              ),
              child: Row(
                children: [
                  _TabPill(
                    icon: Icons.local_shipping_rounded,
                    label: 'Livraisons',
                    selected: selectedTab == 0,
                    onTap: () => onTabChange(0),
                  ),
                  _TabPill(
                    icon: Icons.bar_chart_rounded,
                    label: 'Stats',
                    selected: selectedTab == 1,
                    onTap: () => onTabChange(1),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        // Avatar
        GestureDetector(
          onTap: onProfile,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: Colors.white.withValues(alpha: 0.25)),
                ),
                child: const Icon(Icons.person_rounded,
                    color: Colors.white, size: 22),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _TabPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _TabPill({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected
              ? Colors.white.withValues(alpha: 0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          children: [
            Icon(icon,
                size: 14,
                color: selected
                    ? Colors.white
                    : Colors.white.withValues(alpha: 0.5)),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight:
                    selected ? FontWeight.w700 : FontWeight.w400,
                color: selected
                    ? Colors.white
                    : Colors.white.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// STATS COMPACTES (flottantes sur la carte)
// ─────────────────────────────────────────────
class _CompactStats extends StatelessWidget {
  const _CompactStats();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
            border:
                Border.all(color: Colors.white.withValues(alpha: 0.15)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              _StatPill(value: '6', label: 'Livrées', color: Color(0xFF00C853)),
              _Divider(),
              _StatPill(value: '2', label: 'En cours', color: Color(0xFFFF9500)),
              _Divider(),
              _StatPill(value: '45k', label: 'FCFA', color: Color(0xFF4FC3F7)),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  final String value;
  final String label;
  final Color color;

  const _StatPill({
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w900,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.white.withValues(alpha: 0.6),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 28,
      color: Colors.white.withValues(alpha: 0.15),
    );
  }
}

// ─────────────────────────────────────────────
// BOTTOM SHEET — LIVRAISONS
// ─────────────────────────────────────────────
class _DeliveriesSheet extends StatelessWidget {
  final bool isOnline;
  const _DeliveriesSheet({required this.isOnline});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius:
          const BorderRadius.vertical(top: Radius.circular(24)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF0F1923).withValues(alpha: 0.92),
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(24)),
            border: Border(
              top: BorderSide(
                  color: Colors.white.withValues(alpha: 0.1)),
            ),
          ),
          child: Column(
            children: [
              // Handle
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 12, bottom: 16),
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // Titre
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                child: Row(
                  children: [
                    Text(
                      isOnline
                          ? 'Mes livraisons'
                          : 'Hors ligne',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const Spacer(),
                    if (isOnline)
                      Consumer<DeliveryProvider>(
                        builder: (_, p, __) => Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF4FC3F7)
                                .withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: const Color(0xFF4FC3F7)
                                    .withValues(alpha: 0.3)),
                          ),
                          child: Text(
                            '${p.deliveries.length} actives',
                            style: const TextStyle(
                              color: Color(0xFF4FC3F7),
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // Liste
              Expanded(
                child: isOnline
                    ? Consumer<DeliveryProvider>(
                        builder: (context, prov, _) {
                          if (prov.isLoading) {
                            return const Center(
                              child: CircularProgressIndicator(
                                  color: Color(0xFF4FC3F7)),
                            );
                          }
                          if (prov.deliveries.isEmpty) {
                            return _EmptyDeliveries();
                          }
                          return ListView.builder(
                            padding: const EdgeInsets.fromLTRB(
                                16, 0, 16, 32),
                            itemCount: prov.deliveries.length,
                            itemBuilder: (_, i) => _DeliveryCard(
                              delivery: prov.deliveries[i],
                              index: i,
                            ),
                          );
                        },
                      )
                    : _OfflineState(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// DELIVERY CARD — style Uber Driver
// ─────────────────────────────────────────────
class _DeliveryCard extends StatelessWidget {
  final Delivery delivery;
  final int index;

  const _DeliveryCard({required this.delivery, required this.index});

  @override
  Widget build(BuildContext context) {
    final isUrgent = delivery.priority == DeliveryPriority.urgent;
    final isExpress = delivery.priority == DeliveryPriority.express;

    final priorityColor = isUrgent
        ? const Color(0xFFFF3B30)
        : isExpress
            ? const Color(0xFFFF9500)
            : const Color(0xFF00C853);

    final statusColor = delivery.status == OrderStatus.in_delivery
        ? const Color(0xFF4FC3F7)
        : delivery.status == OrderStatus.assigned
            ? const Color(0xFFFF9500)
            : const Color(0xFF00C853);

    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => DeliveryDetailScreen(delivery: delivery),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isUrgent
                ? const Color(0xFFFF3B30).withValues(alpha: 0.3)
                : Colors.white.withValues(alpha: 0.1),
          ),
        ),
        child: Column(
          children: [
            // Bande priorité en haut si urgent
            if (isUrgent)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 6),
                decoration: const BoxDecoration(
                  color: Color(0xFFFF3B30),
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(15)),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.flash_on_rounded,
                        size: 13, color: Colors.white),
                    SizedBox(width: 4),
                    Text(
                      'LIVRAISON URGENTE',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),

            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                children: [
                  Row(
                    children: [
                      // Numéro de livraison
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color:
                              priorityColor.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: priorityColor
                                  .withValues(alpha: 0.4)),
                        ),
                        child: Center(
                          child: Text(
                            '${index + 1}',
                            style: TextStyle(
                              color: priorityColor,
                              fontWeight: FontWeight.w900,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              delivery.clientName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              delivery.clientPhone,
                              style: TextStyle(
                                color: Colors.white
                                    .withValues(alpha: 0.5),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Status badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color:
                              statusColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: statusColor
                                  .withValues(alpha: 0.35)),
                        ),
                        child: Text(
                          _statusLabel(delivery.status),
                          style: TextStyle(
                            color: statusColor,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Adresse + infos
                  Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: Color(0xFFFF3B30),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          delivery.deliveryAddress,
                          style: TextStyle(
                            color:
                                Colors.white.withValues(alpha: 0.7),
                            fontSize: 13,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Footer : ETA + frais + priorité
                  Row(
                    children: [
                      // ETA
                      Icon(Icons.access_time_rounded,
                          size: 14,
                          color:
                              Colors.white.withValues(alpha: 0.5)),
                      const SizedBox(width: 4),
                      Text(
                        _getETA(delivery),
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.7),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 14),
                      // Frais livraison
                      if (delivery.deliveryFee > 0) ...[
                        Icon(Icons.payments_rounded,
                            size: 14,
                            color:
                                Colors.white.withValues(alpha: 0.5)),
                        const SizedBox(width: 4),
                        Text(
                          '+${delivery.deliveryFee} FCFA',
                          style: const TextStyle(
                            color: Color(0xFF00C853),
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                      const Spacer(),
                      // Badge priorité compact
                      if (!isUrgent)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: priorityColor
                                .withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            delivery.priority.label,
                            style: TextStyle(
                              color: priorityColor,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      const SizedBox(width: 8),
                      Icon(Icons.chevron_right_rounded,
                          color: Colors.white.withValues(alpha: 0.3),
                          size: 18),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _statusLabel(OrderStatus s) {
    switch (s) {
      case OrderStatus.assigned:    return 'Assignée';
      case OrderStatus.in_delivery: return 'En route';
      case OrderStatus.delivered:   return 'Livrée';
      default:                       return 'En attente';
    }
  }

  String _getETA(Delivery d) {
    final estimated = d.assignedAt.add(
      Duration(minutes: d.priority == DeliveryPriority.urgent ? 10 : 45),
    );
    final remaining = estimated.difference(DateTime.now());
    if (remaining.isNegative) return 'En retard';
    final m = remaining.inMinutes;
    return m < 1 ? 'Imminent' : '$m min';
  }
}

// ─────────────────────────────────────────────
// STATS SHEET
// ─────────────────────────────────────────────
class _StatsSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius:
          const BorderRadius.vertical(top: Radius.circular(24)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF0F1923).withValues(alpha: 0.92),
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(24)),
            border: Border(
                top: BorderSide(
                    color: Colors.white.withValues(alpha: 0.1))),
          ),
          child: Column(
            children: [
              // Handle
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 12, bottom: 16),
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                child: Row(
                  children: [
                    const Text(
                      'Statistiques',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Aujourd\'hui',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.6),
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding:
                      const EdgeInsets.fromLTRB(16, 0, 16, 32),
                  children: [
                    // Revenus
                    _RevenueCard(),
                    const SizedBox(height: 12),
                    // Grid stats
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 1.6,
                      children: const [
                        _StatsGridCard(
                          value: '8',
                          label: 'Total',
                          icon: Icons.local_shipping_rounded,
                          color: Color(0xFF4FC3F7),
                        ),
                        _StatsGridCard(
                          value: '6',
                          label: 'Complétées',
                          icon: Icons.check_circle_rounded,
                          color: Color(0xFF00C853),
                        ),
                        _StatsGridCard(
                          value: '2',
                          label: 'En cours',
                          icon: Icons.pending_rounded,
                          color: Color(0xFFFF9500),
                        ),
                        _StatsGridCard(
                          value: '4.9★',
                          label: 'Note',
                          icon: Icons.star_rounded,
                          color: Color(0xFFFFD60A),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RevenueCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1A3A5C), Color(0xFF0D2137)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: const Color(0xFF4FC3F7).withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Revenus du jour',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.6),
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '45 000 FCFA',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _RevenuePill(
                  label: 'Moy/livraison', value: '5 625 F'),
              const SizedBox(width: 10),
              _RevenuePill(label: 'Bonus', value: '+3 000 F',
                  color: const Color(0xFF00C853)),
            ],
          ),
        ],
      ),
    );
  }
}

class _RevenuePill extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;

  const _RevenuePill({
    required this.label,
    required this.value,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.5),
              fontSize: 10,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: color ?? Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsGridCard extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final Color color;

  const _StatsGridCard({
    required this.value,
    required this.label,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                value,
                style: TextStyle(
                  color: color,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                label,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.5),
                  fontSize: 11,
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
// ÉTATS VIDES
// ─────────────────────────────────────────────
class _EmptyDeliveries extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox_rounded,
              size: 52, color: Colors.white.withValues(alpha: 0.2)),
          const SizedBox(height: 12),
          Text(
            'Aucune livraison pour l\'instant',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.4),
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Les nouvelles commandes apparaîtront ici',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.25),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _OfflineState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.wifi_off_rounded,
                size: 32, color: Colors.white.withValues(alpha: 0.3)),
          ),
          const SizedBox(height: 14),
          Text(
            'Vous êtes hors ligne',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.5),
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Activez votre statut pour recevoir des livraisons',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.3),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// PROFILE SHEET
// ─────────────────────────────────────────────
class _ProfileSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthProvider>();
    final user = auth.currentUser;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      decoration: BoxDecoration(
        color: const Color(0xFF151F2B),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 20),
          // Avatar
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: const Color(0xFF4FC3F7).withValues(alpha: 0.15),
              shape: BoxShape.circle,
              border: Border.all(
                  color: const Color(0xFF4FC3F7).withValues(alpha: 0.3),
                  width: 2),
            ),
            child: const Icon(Icons.person_rounded,
                color: Color(0xFF4FC3F7), size: 32),
          ),
          const SizedBox(height: 10),
          Text(
            user?.name ?? 'Livreur',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            user?.phone ?? '',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.5),
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 20),
          const Divider(color: Color(0xFF1E2D3D), height: 1),
          _SheetTile(
            icon: Icons.person_outline_rounded,
            label: 'Mon profil',
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).pushNamed(AppRoutes.profile);
            },
          ),
          _SheetTile(
            icon: Icons.history_rounded,
            label: 'Historique',
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).pushNamed(AppRoutes.deliveryHistory);
            },
          ),
          _SheetTile(
            icon: Icons.settings_outlined,
            label: 'Paramètres',
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).pushNamed(AppRoutes.settings);
            },
          ),
          const Divider(color: Color(0xFF1E2D3D), height: 1),
          _SheetTile(
            icon: Icons.logout_rounded,
            label: 'Déconnexion',
            color: const Color(0xFFFF3B30),
            onTap: () {
              auth.logout();
              Navigator.of(context).pushNamedAndRemoveUntil(
                AppRoutes.login,
                (route) => false,
              );
            },
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _SheetTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;

  const _SheetTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final c = color ?? Colors.white;
    return ListTile(
      leading: Icon(icon, color: c.withValues(alpha: 0.7), size: 20),
      title: Text(
        label,
        style: TextStyle(
          color: c,
          fontWeight: FontWeight.w500,
          fontSize: 15,
        ),
      ),
      trailing: Icon(Icons.chevron_right_rounded,
          color: Colors.white.withValues(alpha: 0.2), size: 18),
      onTap: onTap,
    );
  }
}