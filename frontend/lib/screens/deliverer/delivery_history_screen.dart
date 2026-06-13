import 'package:flutter/material.dart';
import '../../theme/glass/glass_components.dart';
import '../../theme/glass/glass_constants.dart';

class DeliveryHistoryScreen extends StatefulWidget {
  const DeliveryHistoryScreen({super.key});

  @override
  State<DeliveryHistoryScreen> createState() => _DeliveryHistoryScreenState();
}

class _DeliveryHistoryScreenState extends State<DeliveryHistoryScreen> {
  String _selectedFilter = 'Tous';
  final List<String> _filters = ['Tous', 'Livrées', 'Annulées'];

  // Mock delivery history
  final List<Map<String, dynamic>> _mockHistory = [
    {
      'id': 'DLV-001',
      'orderId': 'CMD-001',
      'clientName': 'Marie KOUASSI',
      'address': 'Rue de la Paix, Akwa',
      'amount': 12400.0,
      'status': 'Livrées',
      'date': DateTime.now().subtract(const Duration(hours: 2)),
      'rating': 5.0,
      'tip': 500.0,
    },
    {
      'id': 'DLV-002',
      'orderId': 'CMD-002',
      'clientName': 'Jean MBARGA',
      'address': 'Boulevard de la Liberté, Bonapriso',
      'amount': 6400.0,
      'status': 'Livrées',
      'date': DateTime.now().subtract(const Duration(days: 1)),
      'rating': 4.0,
      'tip': 0.0,
    },
    {
      'id': 'DLV-003',
      'orderId': 'CMD-003',
      'clientName': 'Fatou DIALLO',
      'address': 'Rue Nkongamba, Bali',
      'amount': 13000.0,
      'status': 'Annulées',
      'date': DateTime.now().subtract(const Duration(days: 2)),
      'rating': 0.0,
      'tip': 0.0,
    },
  ];

  List<Map<String, dynamic>> get _filteredHistory {
    if (_selectedFilter == 'Tous') return _mockHistory;
    return _mockHistory
        .where((delivery) => delivery['status'] == _selectedFilter)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    return GlassScaffold(
      appBar: GlassAppBar(
        title: const Text('Historique des livraisons'),
      ),
      body: Column(
        children: [
          // Stats Card
          GlassCard(
            margin: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    'Total',
                    '${_mockHistory.length}',
                    Icons.local_shipping,
                    brightness,
                  ),
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: GlassConstants.borderColor(brightness),
                ),
                Expanded(
                  child: _buildStatItem(
                    'Livrées',
                    '${_mockHistory.where((d) => d['status'] == 'Livrées').length}',
                    Icons.check_circle,
                    brightness,
                  ),
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: GlassConstants.borderColor(brightness),
                ),
                Expanded(
                  child: _buildStatItem(
                    'Annulées',
                    '${_mockHistory.where((d) => d['status'] == 'Annulées').length}',
                    Icons.cancel,
                    brightness,
                  ),
                ),
              ],
            ),
          ),

          // Filter Chips
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _filters.length,
              itemBuilder: (context, index) {
                final filter = _filters[index];
                final isSelected = filter == _selectedFilter;

                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(filter),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() => _selectedFilter = filter);
                    },
                    backgroundColor:
                        GlassConstants.adaptiveSurfaceColor(brightness),
                    selectedColor:
                        GlassConstants.accent.withValues(alpha: 0.3),
                    labelStyle: TextStyle(
                      color: isSelected
                          ? GlassConstants.accent
                          : GlassConstants.bodyColor(brightness),
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                );
              },
            ),
          ),

          // Deliveries List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _filteredHistory.length,
              itemBuilder: (context, index) {
                final delivery = _filteredHistory[index];
                return _buildDeliveryCard(delivery, brightness);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    String label,
    String value,
    IconData icon,
    Brightness brightness,
  ) {
    return Column(
      children: [
        Icon(
          icon,
          color: GlassConstants.accent,
          size: 24,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: GlassConstants.titleColor(brightness),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: GlassConstants.mutedColor(brightness),
          ),
        ),
      ],
    );
  }

  Widget _buildDeliveryCard(
      Map<String, dynamic> delivery, Brightness brightness) {
    final isDelivered = delivery['status'] == 'Livrées';

    return GlassCard(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isDelivered
                      ? Colors.green.withValues(alpha: 0.2)
                      : Colors.red.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  isDelivered ? Icons.check_circle : Icons.cancel,
                  color: isDelivered ? Colors.green : Colors.red,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      delivery['clientName'],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: GlassConstants.titleColor(brightness),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      delivery['id'],
                      style: TextStyle(
                        fontSize: 13,
                        color: GlassConstants.mutedColor(brightness),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '${delivery['amount'].toStringAsFixed(0)} FCFA',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: GlassConstants.accent,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(
                Icons.location_on,
                size: 14,
                color: GlassConstants.mutedColor(brightness),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  delivery['address'],
                  style: TextStyle(
                    fontSize: 13,
                    color: GlassConstants.bodyColor(brightness),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatDate(delivery['date']),
                style: TextStyle(
                  fontSize: 12,
                  color: GlassConstants.mutedColor(brightness),
                ),
              ),
              if (isDelivered && delivery['rating'] > 0)
                Row(
                  children: [
                    Icon(Icons.star, size: 14, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text(
                      delivery['rating'].toStringAsFixed(1),
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: GlassConstants.bodyColor(brightness),
                      ),
                    ),
                  ],
                ),
            ],
          ),
          if (delivery['tip'] > 0) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.attach_money, size: 14, color: Colors.green),
                  const SizedBox(width: 4),
                  Text(
                    'Pourboire: ${delivery['tip'].toStringAsFixed(0)} FCFA',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Aujourd\'hui à ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      return 'Hier';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
