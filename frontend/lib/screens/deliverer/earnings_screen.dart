import 'package:flutter/material.dart';
import '../../theme/glass/glass_components.dart';
import '../../theme/glass/glass_constants.dart';

class EarningsScreen extends StatefulWidget {
  const EarningsScreen({super.key});

  @override
  State<EarningsScreen> createState() => _EarningsScreenState();
}

class _EarningsScreenState extends State<EarningsScreen> {
  String _selectedPeriod = 'Aujourd\'hui';
  final List<String> _periods = [
    'Aujourd\'hui',
    'Cette semaine',
    'Ce mois',
    'Total',
  ];

  final Map<String, Map<String, dynamic>> _earnings = {
    'Aujourd\'hui': {
      'total': 15000.0,
      'deliveries': 5,
      'tips': 2000.0,
      'bonus': 500.0,
    },
    'Cette semaine': {
      'total': 85000.0,
      'deliveries': 28,
      'tips': 12000.0,
      'bonus': 3000.0,
    },
    'Ce mois': {
      'total': 320000.0,
      'deliveries': 98,
      'tips': 45000.0,
      'bonus': 15000.0,
    },
    'Total': {
      'total': 1250000.0,
      'deliveries': 412,
      'tips': 180000.0,
      'bonus': 65000.0,
    },
  };

  Map<String, dynamic> get _currentEarnings =>
      _earnings[_selectedPeriod] ?? {};

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    return GlassScaffold(
      appBar: GlassAppBar(
        title: const Text('Mes gains'),
      ),
      body: SingleChildScrollView(
        padding: GlassConstants.pagePadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Period Selector
            SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _periods.length,
                itemBuilder: (context, index) {
                  final period = _periods[index];
                  final isSelected = period == _selectedPeriod;

                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(period),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() => _selectedPeriod = period);
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
            const SizedBox(height: 16),

            // Total Earnings Card
            GlassCard(
              child: Column(
                children: [
                  Text(
                    'Gains totaux',
                    style: TextStyle(
                      fontSize: 16,
                      color: GlassConstants.mutedColor(brightness),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '${_currentEarnings['total']?.toStringAsFixed(0) ?? '0'} FCFA',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w800,
                      color: GlassConstants.accent,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${_currentEarnings['deliveries'] ?? 0} livraisons',
                    style: TextStyle(
                      fontSize: 14,
                      color: GlassConstants.mutedColor(brightness),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Breakdown
            Row(
              children: [
                Expanded(
                  child: _buildEarningCard(
                    'Livraisons',
                    (_currentEarnings['total'] ?? 0) -
                        (_currentEarnings['tips'] ?? 0) -
                        (_currentEarnings['bonus'] ?? 0),
                    Icons.local_shipping,
                    Colors.blue,
                    brightness,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildEarningCard(
                    'Pourboires',
                    _currentEarnings['tips'] ?? 0,
                    Icons.attach_money,
                    Colors.green,
                    brightness,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildEarningCard(
              'Bonus',
              _currentEarnings['bonus'] ?? 0,
              Icons.star,
              Colors.amber,
              brightness,
              fullWidth: true,
            ),
            const SizedBox(height: 24),

            // Statistics
            Text(
              'Statistiques',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: GlassConstants.titleColor(brightness),
              ),
            ),
            const SizedBox(height: 12),
            GlassCard(
              child: Column(
                children: [
                  _buildStatRow(
                    'Gain moyen par livraison',
                    '${((_currentEarnings['total'] ?? 0) / (_currentEarnings['deliveries'] ?? 1)).toStringAsFixed(0)} FCFA',
                    brightness,
                  ),
                  Divider(color: GlassConstants.borderColor(brightness)),
                  _buildStatRow(
                    'Pourboire moyen',
                    '${((_currentEarnings['tips'] ?? 0) / (_currentEarnings['deliveries'] ?? 1)).toStringAsFixed(0)} FCFA',
                    brightness,
                  ),
                  Divider(color: GlassConstants.borderColor(brightness)),
                  _buildStatRow(
                    'Taux de réussite',
                    '98%',
                    brightness,
                  ),
                  Divider(color: GlassConstants.borderColor(brightness)),
                  _buildStatRow(
                    'Note moyenne',
                    '4.9 ⭐',
                    brightness,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Withdraw Button
            GlassButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Retrait en cours de traitement...'),
                  ),
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.account_balance_wallet, size: 20),
                  const SizedBox(width: 8),
                  Text('Retirer mes gains'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEarningCard(
    String label,
    double amount,
    IconData icon,
    Color color,
    Brightness brightness, {
    bool fullWidth = false,
  }) {
    return GlassCard(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: color,
              size: 28,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: GlassConstants.mutedColor(brightness),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${amount.toStringAsFixed(0)} FCFA',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: GlassConstants.titleColor(brightness),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value, Brightness brightness) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: GlassConstants.bodyColor(brightness),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: GlassConstants.titleColor(brightness),
            ),
          ),
        ],
      ),
    );
  }
}
