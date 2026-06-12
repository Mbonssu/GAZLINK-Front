import 'package:flutter/material.dart';
import '../../theme/glass/glass_components.dart';
import '../../theme/glass/glass_constants.dart';
import '../../routes.dart';

class PaymentHistoryScreen extends StatefulWidget {
  const PaymentHistoryScreen({super.key});

  @override
  State<PaymentHistoryScreen> createState() => _PaymentHistoryScreenState();
}

class _PaymentHistoryScreenState extends State<PaymentHistoryScreen> {
  String _selectedFilter = 'Tous';
  final List<String> _filters = ['Tous', 'Réussi', 'En attente', 'Échoué'];

  // Mock payment data
  final List<Map<String, dynamic>> _mockPayments = [
    {
      'id': 'PAY-001',
      'orderId': 'CMD-001',
      'amount': 12400.0,
      'method': 'MTN MoMo',
      'status': 'Réussi',
      'date': DateTime.now().subtract(const Duration(days: 2)),
      'icon': Icons.phone_android,
      'color': GlassConstants.mtnMomoYellow,
    },
    {
      'id': 'PAY-002',
      'orderId': 'CMD-002',
      'amount': 6400.0,
      'method': 'Orange Money',
      'status': 'Réussi',
      'date': DateTime.now().subtract(const Duration(hours: 5)),
      'icon': Icons.phone_iphone,
      'color': GlassConstants.orangeMoneyOrange,
    },
    {
      'id': 'PAY-003',
      'orderId': 'CMD-003',
      'amount': 13000.0,
      'method': 'Espèces',
      'status': 'En attente',
      'date': DateTime.now().subtract(const Duration(hours: 1)),
      'icon': Icons.money,
      'color': Colors.green,
    },
    {
      'id': 'PAY-004',
      'orderId': 'CMD-004',
      'amount': 7000.0,
      'method': 'MTN MoMo',
      'status': 'Échoué',
      'date': DateTime.now().subtract(const Duration(days: 5)),
      'icon': Icons.phone_android,
      'color': GlassConstants.mtnMomoYellow,
    },
  ];

  List<Map<String, dynamic>> get _filteredPayments {
    if (_selectedFilter == 'Tous') return _mockPayments;
    return _mockPayments
        .where((payment) => payment['status'] == _selectedFilter)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    return GlassScaffold(
      appBar: GlassAppBar(
        title: const Text('Historique des paiements'),
      ),
      body: Column(
        children: [
          // Filter Chips
          SizedBox(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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

          // Payments List
          Expanded(
            child: _filteredPayments.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.receipt_long,
                          size: 64,
                          color: GlassConstants.mutedColor(brightness),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Aucun paiement',
                          style: TextStyle(
                            fontSize: 16,
                            color: GlassConstants.mutedColor(brightness),
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: GlassConstants.pagePadding,
                    itemCount: _filteredPayments.length,
                    itemBuilder: (context, index) {
                      final payment = _filteredPayments[index];
                      return _buildPaymentCard(payment, brightness);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentCard(
      Map<String, dynamic> payment, Brightness brightness) {
    final statusColor = _getStatusColor(payment['status']);

    return GlassCard(
      margin: const EdgeInsets.only(bottom: 12),
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoutes.receipt,
          arguments: payment,
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: (payment['color'] as Color).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  payment['icon'],
                  color: payment['color'],
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      payment['method'],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: GlassConstants.titleColor(brightness),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      payment['id'],
                      style: TextStyle(
                        fontSize: 13,
                        color: GlassConstants.mutedColor(brightness),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${payment['amount'].toStringAsFixed(0)} FCFA',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: GlassConstants.titleColor(brightness),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      payment['status'],
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: statusColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Divider(
            color: GlassConstants.borderColor(brightness),
            height: 1,
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.shopping_bag,
                    size: 14,
                    color: GlassConstants.mutedColor(brightness),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    payment['orderId'],
                    style: TextStyle(
                      fontSize: 13,
                      color: GlassConstants.mutedColor(brightness),
                    ),
                  ),
                ],
              ),
              Text(
                _formatDate(payment['date']),
                style: TextStyle(
                  fontSize: 13,
                  color: GlassConstants.mutedColor(brightness),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Réussi':
        return Colors.green;
      case 'En attente':
        return Colors.orange;
      case 'Échoué':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return 'Il y a ${difference.inMinutes} min';
      }
      return 'Il y a ${difference.inHours}h';
    } else if (difference.inDays == 1) {
      return 'Hier';
    } else if (difference.inDays < 7) {
      return 'Il y a ${difference.inDays} jours';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
