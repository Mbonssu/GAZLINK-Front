import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';

class DeliveryHistoryScreen extends StatefulWidget {
  const DeliveryHistoryScreen({Key? key}) : super(key: key);

  @override
  State<DeliveryHistoryScreen> createState() => _DeliveryHistoryScreenState();
}

class _DeliveryHistoryScreenState extends State<DeliveryHistoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;

  final _history = [
    {
      'id': 'DLV-001',
      'clientName': 'Marie Kouassi',
      'address': 'Rue de la Paix, Akwa',
      'amount': 12400.0,
      'fee': 500.0,
      'status': 'delivered',
      'priority': 'Express',
      'date': DateTime.now().subtract(const Duration(hours: 2)),
      'rating': 5.0,
    },
    {
      'id': 'DLV-002',
      'clientName': 'Jean Mbarga',
      'address': 'Bld de la Liberté, Bonapriso',
      'amount': 6400.0,
      'fee': 0.0,
      'status': 'delivered',
      'priority': 'Normal',
      'date': DateTime.now().subtract(const Duration(hours: 5)),
      'rating': 4.0,
    },
    {
      'id': 'DLV-003',
      'clientName': 'Fatou Diallo',
      'address': 'Rue Nkongamba, Bali',
      'amount': 13000.0,
      'fee': 1000.0,
      'status': 'cancelled',
      'priority': 'Urgent',
      'date': DateTime.now().subtract(const Duration(days: 1)),
      'rating': 0.0,
    },
    {
      'id': 'DLV-004',
      'clientName': 'Paul Eto\'o',
      'address': 'Quartier Makepe, Douala',
      'amount': 9700.0,
      'fee': 500.0,
      'status': 'delivered',
      'priority': 'Express',
      'date': DateTime.now().subtract(const Duration(days: 1, hours: 3)),
      'rating': 5.0,
    },
    {
      'id': 'DLV-005',
      'clientName': 'Awa Traoré',
      'address': 'Akwa Nord, Douala',
      'amount': 3200.0,
      'fee': 0.0,
      'status': 'delivered',
      'priority': 'Normal',
      'date': DateTime.now().subtract(const Duration(days: 2)),
      'rating': 4.5,
    },
  ];

  List<Map<String, dynamic>> get _delivered =>
      _history.where((d) => d['status'] == 'delivered').toList();
  List<Map<String, dynamic>> get _cancelled =>
      _history.where((d) => d['status'] == 'cancelled').toList();

  double get _totalRevenue =>
      _delivered.fold(0, (s, d) => s + (d['amount'] as double) + (d['fee'] as double));
  double get _avgRating {
    final rated = _delivered.where((d) => (d['rating'] as double) > 0).toList();
    if (rated.isEmpty) return 0;
    return rated.fold(0.0, (s, d) => s + (d['rating'] as double)) / rated.length;
  }

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    return Scaffold(
      backgroundColor: const Color(0xFF0F1923),
      body: Column(
        children: [
          // Header
          _Header(
            total: _history.length,
            delivered: _delivered.length,
            revenue: _totalRevenue,
            rating: _avgRating,
            tabCtrl: _tabCtrl,
          ),

          // Liste
          Expanded(
            child: TabBarView(
              controller: _tabCtrl,
              children: [
                _HistoryList(items: _history),
                _HistoryList(items: _delivered),
                _HistoryList(items: _cancelled),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// HEADER
// ─────────────────────────────────────────────
class _Header extends StatelessWidget {
  final int total;
  final int delivered;
  final double revenue;
  final double rating;
  final TabController tabCtrl;

  const _Header({
    required this.total,
    required this.delivered,
    required this.revenue,
    required this.rating,
    required this.tabCtrl,
  });

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;

    return Container(
      color: const Color(0xFF0F1923),
      child: Column(
        children: [
          SizedBox(height: top + 8),
          // Nav row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.08),
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: Colors.white.withValues(alpha: 0.12)),
                    ),
                    child: const Icon(Icons.arrow_back_rounded,
                        color: Colors.white, size: 20),
                  ),
                ),
                const SizedBox(width: 14),
                const Text(
                  'Historique',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Stats row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _MiniStat(
                    value: '$total', label: 'Total', color: const Color(0xFF4FC3F7)),
                const SizedBox(width: 10),
                _MiniStat(
                    value: '$delivered',
                    label: 'Livrées',
                    color: const Color(0xFF00C853)),
                const SizedBox(width: 10),
                _MiniStat(
                    value: '${_formatRevenue(revenue)} F',
                    label: 'Revenus',
                    color: const Color(0xFFFFD60A)),
                const SizedBox(width: 10),
                _MiniStat(
                    value: '${rating.toStringAsFixed(1)}★',
                    label: 'Note',
                    color: const Color(0xFFFF9500)),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // TabBar
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(12),
            ),
            child: TabBar(
              controller: tabCtrl,
              indicator: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              labelColor: Colors.white,
              unselectedLabelColor:
                  Colors.white.withValues(alpha: 0.4),
              labelStyle: const TextStyle(
                  fontWeight: FontWeight.w700, fontSize: 13),
              unselectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.w400, fontSize: 13),
              dividerColor: Colors.transparent,
              tabs: const [
                Tab(text: 'Toutes'),
                Tab(text: 'Livrées'),
                Tab(text: 'Annulées'),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  String _formatRevenue(double v) {
    if (v >= 1000) return '${(v / 1000).toStringAsFixed(0)}k';
    return v.toStringAsFixed(0);
  }
}

class _MiniStat extends StatelessWidget {
  final String value;
  final String label;
  final Color color;
  const _MiniStat(
      {required this.value, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
          border:
              Border.all(color: color.withValues(alpha: 0.15)),
        ),
        child: Column(
          children: [
            Text(value,
                style: TextStyle(
                    color: color,
                    fontSize: 16,
                    fontWeight: FontWeight.w900)),
            Text(label,
                style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.4),
                    fontSize: 10)),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// HISTORY LIST
// ─────────────────────────────────────────────
class _HistoryList extends StatelessWidget {
  final List<Map<String, dynamic>> items;
  const _HistoryList({required this.items});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox_rounded,
                size: 48,
                color: Colors.white.withValues(alpha: 0.15)),
            const SizedBox(height: 12),
            Text('Aucune livraison',
                style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.3),
                    fontSize: 15)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
      itemCount: items.length,
      itemBuilder: (_, i) => _HistoryCard(item: items[i]),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  final Map<String, dynamic> item;
  const _HistoryCard({required this.item});

  Color get _priorityColor {
    switch (item['priority'] as String) {
      case 'Urgent':  return const Color(0xFFFF3B30);
      case 'Express': return const Color(0xFFFF9500);
      default:        return const Color(0xFF00C853);
    }
  }

  bool get _isDelivered => item['status'] == 'delivered';

  @override
  Widget build(BuildContext context) {
    final date = item['date'] as DateTime;
    final fee = (item['fee'] as double);
    final total = (item['amount'] as double) + fee;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF151F2B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _isDelivered
              ? Colors.white.withValues(alpha: 0.07)
              : const Color(0xFFFF3B30).withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Icône statut
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: (_isDelivered
                          ? const Color(0xFF00C853)
                          : const Color(0xFFFF3B30))
                      .withValues(alpha: 0.12),
                ),
                child: Icon(
                  _isDelivered
                      ? Icons.check_circle_rounded
                      : Icons.cancel_rounded,
                  color: _isDelivered
                      ? const Color(0xFF00C853)
                      : const Color(0xFFFF3B30),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['clientName'] as String,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item['id'] as String,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.35),
                        fontSize: 11,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${total.toInt()} FCFA',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                    ),
                  ),
                  if (fee > 0)
                    Text(
                      '+${fee.toInt()} F livraison',
                      style: const TextStyle(
                          color: Color(0xFF00C853),
                          fontSize: 10,
                          fontWeight: FontWeight.w600),
                    ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.location_on_outlined,
                  size: 13,
                  color: Colors.white.withValues(alpha: 0.35)),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  item['address'] as String,
                  style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.5),
                      fontSize: 12),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              // Badge priorité
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: _priorityColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  item['priority'] as String,
                  style: TextStyle(
                      color: _priorityColor,
                      fontSize: 10,
                      fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.access_time_rounded,
                  size: 12,
                  color: Colors.white.withValues(alpha: 0.3)),
              const SizedBox(width: 4),
              Text(
                _formatDate(date),
                style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.35),
                    fontSize: 11),
              ),
              const Spacer(),
              if (_isDelivered && (item['rating'] as double) > 0) ...[
                const Icon(Icons.star_rounded,
                    size: 13, color: Color(0xFFFFD60A)),
                const SizedBox(width: 3),
                Text(
                  (item['rating'] as double).toStringAsFixed(1),
                  style: const TextStyle(
                      color: Color(0xFFFFD60A),
                      fontSize: 12,
                      fontWeight: FontWeight.w700),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime d) {
    final diff = DateTime.now().difference(d);
    if (diff.inHours < 1) return 'Il y a ${diff.inMinutes} min';
    if (diff.inHours < 24)
      return 'Aujourd\'hui ${d.hour}:${d.minute.toString().padLeft(2, '0')}';
    if (diff.inDays == 1) return 'Hier';
    return '${d.day}/${d.month}/${d.year}';
  }
}