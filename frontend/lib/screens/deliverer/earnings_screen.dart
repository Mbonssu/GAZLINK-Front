import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EarningsScreen extends StatefulWidget {
  const EarningsScreen({Key? key}) : super(key: key);

  @override
  State<EarningsScreen> createState() => _EarningsScreenState();
}

class _EarningsScreenState extends State<EarningsScreen> {
  int _selectedPeriod = 0;
  final _periods = [
    'Aujourd\'hui',
    'Cette semaine',
    'Ce mois',
    'Total',
  ];

  final _data = [
    {
      'total': 15000.0,
      'deliveries': 5,
      'fee': 2000.0,
      'bonus': 500.0,
      'rating': 4.9,
    },
    {
      'total': 85000.0,
      'deliveries': 28,
      'fee': 12000.0,
      'bonus': 3000.0,
      'rating': 4.8,
    },
    {
      'total': 320000.0,
      'deliveries': 98,
      'fee': 45000.0,
      'bonus': 15000.0,
      'rating': 4.9,
    },
    {
      'total': 1250000.0,
      'deliveries': 412,
      'fee': 180000.0,
      'bonus': 65000.0,
      'rating': 4.9,
    },
  ];

  Map<String, dynamic> get _current => _data[_selectedPeriod];

  double get _base =>
      (_current['total'] as double) -
      (_current['fee'] as double) -
      (_current['bonus'] as double);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    return Scaffold(
      backgroundColor: const Color(0xFF0F1923),
      body: Column(
        children: [
          _TopBar(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 40),
              children: [
                // Sélecteur période
                _PeriodSelector(
                  periods: _periods,
                  selected: _selectedPeriod,
                  onSelect: (i) => setState(() => _selectedPeriod = i),
                ),
                const SizedBox(height: 20),

                // Carte total
                _TotalCard(current: _current, period: _periods[_selectedPeriod]),
                const SizedBox(height: 14),

                // Répartition
                _BreakdownRow(base: _base, current: _current),
                const SizedBox(height: 14),

                // Barre de progression objectif
                _GoalCard(current: _current, selectedPeriod: _selectedPeriod),
                const SizedBox(height: 14),

                // Statistiques
                _StatsCard(current: _current),
                const SizedBox(height: 20),

                // Bouton retrait
                _WithdrawButton(total: _current['total'] as double),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// TOP BAR
// ─────────────────────────────────────────────
class _TopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    return Container(
      color: const Color(0xFF0F1923),
      padding: EdgeInsets.fromLTRB(16, top + 12, 16, 16),
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
            'Mes gains',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// SÉLECTEUR PÉRIODE
// ─────────────────────────────────────────────
class _PeriodSelector extends StatelessWidget {
  final List<String> periods;
  final int selected;
  final ValueChanged<int> onSelect;

  const _PeriodSelector({
    required this.periods,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: List.generate(periods.length, (i) {
          final sel = i == selected;
          return Expanded(
            child: GestureDetector(
              onTap: () => onSelect(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: sel
                      ? Colors.white.withValues(alpha: 0.12)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  periods[i],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: sel
                        ? Colors.white
                        : Colors.white.withValues(alpha: 0.4),
                    fontWeight:
                        sel ? FontWeight.w700 : FontWeight.w400,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// CARTE TOTAL
// ─────────────────────────────────────────────
class _TotalCard extends StatelessWidget {
  final Map<String, dynamic> current;
  final String period;
  const _TotalCard({required this.current, required this.period});

  @override
  Widget build(BuildContext context) {
    final total = current['total'] as double;
    final deliveries = current['deliveries'] as int;

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1A3A5C), Color(0xFF0D2137)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color: const Color(0xFF4FC3F7).withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Gains — $period',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.5),
                  fontSize: 13,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color:
                      const Color(0xFF4FC3F7).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: const Color(0xFF4FC3F7)
                          .withValues(alpha: 0.25)),
                ),
                child: Text(
                  '$deliveries livraisons',
                  style: const TextStyle(
                    color: Color(0xFF4FC3F7),
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            _formatAmount(total),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.5,
            ),
          ),
          Text(
            'FCFA',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.4),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          // Gain moyen par livraison
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.trending_up_rounded,
                    color: Color(0xFF00C853), size: 18),
                const SizedBox(width: 8),
                Text(
                  'Moy. par livraison : ${_formatAmount(total / deliveries)} FCFA',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatAmount(double v) {
    if (v >= 1000000)
      return '${(v / 1000000).toStringAsFixed(1)} M';
    if (v >= 1000) return '${(v / 1000).toStringAsFixed(0)} k';
    return v.toStringAsFixed(0);
  }
}

// ─────────────────────────────────────────────
// BREAKDOWN ROW
// ─────────────────────────────────────────────
class _BreakdownRow extends StatelessWidget {
  final double base;
  final Map<String, dynamic> current;
  const _BreakdownRow({required this.base, required this.current});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _BreakdownCard(
            icon: Icons.local_shipping_rounded,
            label: 'Livraisons',
            amount: base,
            color: const Color(0xFF4FC3F7),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _BreakdownCard(
            icon: Icons.flash_on_rounded,
            label: 'Frais urgence',
            amount: current['fee'] as double,
            color: const Color(0xFFFF9500),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _BreakdownCard(
            icon: Icons.star_rounded,
            label: 'Bonus',
            amount: current['bonus'] as double,
            color: const Color(0xFFFFD60A),
          ),
        ),
      ],
    );
  }
}

class _BreakdownCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final double amount;
  final Color color;

  const _BreakdownCard({
    required this.icon,
    required this.label,
    required this.amount,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(14),
        border:
            Border.all(color: color.withValues(alpha: 0.15)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 6),
          Text(
            _fmt(amount),
            style: TextStyle(
              color: color,
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.4),
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  String _fmt(double v) {
    if (v >= 1000) return '${(v / 1000).toStringAsFixed(0)}k';
    return v.toStringAsFixed(0);
  }
}

// ─────────────────────────────────────────────
// GOAL CARD
// ─────────────────────────────────────────────
class _GoalCard extends StatelessWidget {
  final Map<String, dynamic> current;
  final int selectedPeriod;

  const _GoalCard({
    required this.current,
    required this.selectedPeriod,
  });

  @override
  Widget build(BuildContext context) {
    final goals = [50000.0, 150000.0, 500000.0, 2000000.0];
    final goal = goals[selectedPeriod];
    final total = current['total'] as double;
    final progress = (total / goal).clamp(0.0, 1.0);
    final percent = (progress * 100).toInt();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF151F2B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF1E2D3D)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Objectif de la période',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
              const Spacer(),
              Text(
                '$percent%',
                style: const TextStyle(
                  color: Color(0xFF00C853),
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor:
                  Colors.white.withValues(alpha: 0.08),
              valueColor: const AlwaysStoppedAnimation<Color>(
                  Color(0xFF00C853)),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${_fmt(total)} FCFA',
                style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.5),
                    fontSize: 11),
              ),
              Text(
                'Objectif : ${_fmt(goal)} FCFA',
                style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.5),
                    fontSize: 11),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _fmt(double v) {
    if (v >= 1000000)
      return '${(v / 1000000).toStringAsFixed(1)} M';
    if (v >= 1000) return '${(v / 1000).toStringAsFixed(0)} k';
    return v.toStringAsFixed(0);
  }
}

// ─────────────────────────────────────────────
// STATS CARD
// ─────────────────────────────────────────────
class _StatsCard extends StatelessWidget {
  final Map<String, dynamic> current;
  const _StatsCard({required this.current});

  @override
  Widget build(BuildContext context) {
    final deliveries = current['deliveries'] as int;
    final total = current['total'] as double;
    final rating = current['rating'] as double;

    final rows = [
      ('Gain moyen / livraison', '${(total / deliveries).toStringAsFixed(0)} FCFA'),
      ('Taux de réussite', '98 %'),
      ('Note moyenne', '$rating ★'),
      ('Livraisons complétées', '$deliveries'),
    ];

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF151F2B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF1E2D3D)),
      ),
      child: Column(
        children: List.generate(rows.length, (i) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 14),
                child: Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      rows[i].$1,
                      style: TextStyle(
                        color:
                            Colors.white.withValues(alpha: 0.5),
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      rows[i].$2,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              if (i < rows.length - 1)
                Container(
                    height: 1,
                    color: const Color(0xFF1E2D3D)),
            ],
          );
        }),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// WITHDRAW BUTTON
// ─────────────────────────────────────────────
class _WithdrawButton extends StatelessWidget {
  final double total;
  const _WithdrawButton({required this.total});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showWithdrawSheet(context),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF00C853), Color(0xFF009624)],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF00C853).withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.account_balance_wallet_rounded,
                color: Colors.white, size: 20),
            SizedBox(width: 10),
            Text(
              'Retirer mes gains',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showWithdrawSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF151F2B),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
              color: const Color(0xFF00C853).withValues(alpha: 0.2)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Retirer mes gains',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 6),
            Text(
              'Disponible : ${total.toStringAsFixed(0)} FCFA',
              style: const TextStyle(
                  color: Color(0xFF00C853),
                  fontSize: 14,
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            _WithdrawOption(
                icon: Icons.phone_android_rounded,
                label: 'MTN Mobile Money',
                color: const Color(0xFFFFD60A)),
            const SizedBox(height: 10),
            _WithdrawOption(
                icon: Icons.phone_iphone_rounded,
                label: 'Orange Money',
                color: const Color(0xFFFF9500)),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Text('Annuler',
                  style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.4),
                      fontSize: 14)),
            ),
          ],
        ),
      ),
    );
  }
}

class _WithdrawOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _WithdrawOption(
      {required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Retrait via $label en cours...')),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 14),
            ),
            const Spacer(),
            Icon(Icons.chevron_right_rounded,
                color: Colors.white.withValues(alpha: 0.3)),
          ],
        ),
      ),
    );
  }
}