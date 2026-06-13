import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/models.dart';
import '../../providers/depot_provider.dart';
import '../../theme/app_theme.dart';
import '../../theme/glass/glass_components.dart';
import '../../theme/glass/glass_constants.dart';

class DepotStockTab extends StatelessWidget {
  const DepotStockTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    return Consumer<DepotProvider>(
      builder: (context, depotProv, _) {
        final depot = depotProv.depot;
        final entries = depotProv.stockEntries;

        return Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            scrolledUnderElevation: 0,
            title: Text(
              'Stock',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: GlassConstants.titleColor(brightness),
                    fontWeight: FontWeight.w800,
                  ),
            ),
            actions: [
              TextButton.icon(
                onPressed: () => _showAddMovementSheet(context, depotProv),
                icon: const Icon(Icons.add_rounded),
                label: const Text('Mouvement'),
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
            children: [
              // Alerte stock bas
              if (depot.hasLowStock) ...[
                _AlertBanner(depot: depot),
                const SizedBox(height: 16),
              ],

              // Résumé global
              _GlobalSummaryCard(depot: depot),
              const SizedBox(height: 20),

              // Stock par type de bouteille
              Text(
                'Détail par type',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: GlassConstants.titleColor(brightness),
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 12),
              _BottleStockCard(
                label: '6 kg',
                price: depot.price6kg,
                full: depot.stock6kg,
                empty: depot.emptyBottles6kg,
                exchange: depot.exchangeBottles6kg,
                alertThreshold: depot.stockAlertThreshold,
                onAddMovement: () => _showAddMovementSheet(
                    context, depotProv,
                    preselectedBottle: 'BT-001'),
              ),
              const SizedBox(height: 10),
              _BottleStockCard(
                label: '12.5 kg',
                price: depot.price12kg,
                full: depot.stock12kg,
                empty: depot.emptyBottles12kg,
                exchange: depot.exchangeBottles12kg,
                alertThreshold: depot.stockAlertThreshold,
                onAddMovement: () => _showAddMovementSheet(
                    context, depotProv,
                    preselectedBottle: 'BT-002'),
              ),
              const SizedBox(height: 10),
              _BottleStockCard(
                label: '24 kg',
                price: depot.price24kg,
                full: depot.stock24kg,
                empty: depot.emptyBottles24kg,
                exchange: depot.exchangeBottles24kg,
                alertThreshold: depot.stockAlertThreshold,
                onAddMovement: () => _showAddMovementSheet(
                    context, depotProv,
                    preselectedBottle: 'BT-003'),
              ),
              const SizedBox(height: 24),

              // Historique mouvements
              Text(
                'Mouvements récents',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: GlassConstants.titleColor(brightness),
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 12),
              if (entries.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      'Aucun mouvement enregistré',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: GlassConstants.mutedColor(brightness),
                          ),
                    ),
                  ),
                )
              else
                ...entries.map((e) => _StockEntryRow(entry: e)).toList(),
            ],
          ),
        );
      },
    );
  }

  void _showAddMovementSheet(BuildContext context, DepotProvider depotProv,
      {String? preselectedBottle}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _AddMovementSheet(
        depotProv: depotProv,
        preselectedBottle: preselectedBottle,
      ),
    );
  }
}

// ─────────────────────────────────────────────
// ALERTE STOCK BAS
// ─────────────────────────────────────────────
class _AlertBanner extends StatelessWidget {
  final Depot depot;
  const _AlertBanner({required this.depot});

  @override
  Widget build(BuildContext context) {
    final lowItems = <String>[];
    if (depot.stock6kg <= depot.stockAlertThreshold) lowItems.add('6 kg');
    if (depot.stock12kg <= depot.stockAlertThreshold) lowItems.add('12.5 kg');
    if (depot.stock24kg <= depot.stockAlertThreshold) lowItems.add('24 kg');

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.orange.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_rounded,
              color: Colors.orange, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Stock bas — approvisionnement recommandé',
                  style: TextStyle(
                      fontWeight: FontWeight.w700, color: Colors.orange),
                ),
                Text(
                  'Bouteilles concernées : ${lowItems.join(', ')}',
                  style: TextStyle(
                      fontSize: 12,
                      color: Colors.orange.withValues(alpha: 0.85)),
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
// RÉSUMÉ GLOBAL
// ─────────────────────────────────────────────
class _GlobalSummaryCard extends StatelessWidget {
  final Depot depot;
  const _GlobalSummaryCard({required this.depot});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Vue globale',
            style: Theme.of(context)
                .textTheme
                .titleSmall
                ?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _SummaryItem(
                icon: Icons.propane_tank_rounded,
                color: Colors.green,
                label: 'Pleines',
                value: depot.totalFullBottles,
              ),
              const SizedBox(width: 16),
              _SummaryItem(
                icon: Icons.propane_tank_outlined,
                color: Colors.grey,
                label: 'Vides',
                value: depot.totalEmptyBottles,
              ),
              const SizedBox(width: 16),
              _SummaryItem(
                icon: Icons.swap_horiz_rounded,
                color: Colors.blue,
                label: 'Échange',
                value: depot.exchangeBottles6kg +
                    depot.exchangeBottles12kg +
                    depot.exchangeBottles24kg,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final int value;
  const _SummaryItem({
    required this.icon,
    required this.color,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 6),
            Text(
              '$value',
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.w800, color: color),
            ),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color:
                        GlassConstants.mutedColor(Theme.of(context).brightness),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// CARTE STOCK PAR TYPE DE BOUTEILLE
// ─────────────────────────────────────────────
class _BottleStockCard extends StatelessWidget {
  final String label;
  final int price;
  final int full;
  final int empty;
  final int exchange;
  final int alertThreshold;
  final VoidCallback onAddMovement;

  const _BottleStockCard({
    required this.label,
    required this.price,
    required this.full,
    required this.empty,
    required this.exchange,
    required this.alertThreshold,
    required this.onAddMovement,
  });

  bool get _isLow => full <= alertThreshold;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    return GlassCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: (_isLow ? Colors.orange : AppTheme.primaryBlue)
                      .withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.propane_tank_rounded,
                  color:
                      _isLow ? Colors.orange : AppTheme.primaryBlue,
                  size: 22,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Bouteille $label',
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        if (_isLow) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.orange.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              'Stock bas',
                              style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.orange,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],
                      ],
                    ),
                    Text(
                      '$price FCFA · Client paie ${price - 300} FCFA',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: GlassConstants.mutedColor(brightness),
                          ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: onAddMovement,
                icon: const Icon(Icons.add_circle_outline_rounded),
                color: AppTheme.primaryBlue,
                tooltip: 'Ajouter un mouvement',
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Barre de stock
          _StockBar(
            full: full,
            empty: empty,
            exchange: exchange,
            threshold: alertThreshold,
          ),
          const SizedBox(height: 12),
          // Détail chiffres
          Row(
            children: [
              _StockDetail(
                  icon: Icons.propane_tank_rounded,
                  color: Colors.green,
                  label: 'Pleines',
                  value: full),
              _StockDetail(
                  icon: Icons.propane_tank_outlined,
                  color: Colors.grey,
                  label: 'Vides',
                  value: empty),
              _StockDetail(
                  icon: Icons.swap_horiz_rounded,
                  color: Colors.blue,
                  label: 'Échange',
                  value: exchange),
            ],
          ),
        ],
      ),
    );
  }
}

class _StockBar extends StatelessWidget {
  final int full;
  final int empty;
  final int exchange;
  final int threshold;

  const _StockBar({
    required this.full,
    required this.empty,
    required this.exchange,
    required this.threshold,
  });

  @override
  Widget build(BuildContext context) {
    final total = full + empty + exchange;
    if (total == 0) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Row(
            children: [
              // Pleines (vert)
              Flexible(
                flex: full,
                child: Container(height: 8, color: Colors.green),
              ),
              // Échange (bleu)
              Flexible(
                flex: exchange,
                child: Container(height: 8, color: Colors.blue),
              ),
              // Vides (gris)
              Flexible(
                flex: empty,
                child: Container(
                    height: 8,
                    color: Colors.grey.withValues(alpha: 0.3)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        // Ligne seuil d'alerte
        if (full <= threshold)
          Text(
            'Seuil d\'alerte : $threshold bouteilles pleines',
            style: const TextStyle(
                fontSize: 10,
                color: Colors.orange,
                fontWeight: FontWeight.w600),
          ),
      ],
    );
  }
}

class _StockDetail extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final int value;

  const _StockDetail({
    required this.icon,
    required this.color,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(height: 4),
          Text(
            '$value',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: color),
          ),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color:
                      GlassConstants.mutedColor(Theme.of(context).brightness),
                  fontSize: 10,
                ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// HISTORIQUE MOUVEMENT
// ─────────────────────────────────────────────
class _StockEntryRow extends StatelessWidget {
  final StockEntry entry;
  const _StockEntryRow({required this.entry});

  String get _typeLabel {
    switch (entry.type) {
      case StockMovementType.supply:          return 'Approvisionnement';
      case StockMovementType.sold:            return 'Vendu';
      case StockMovementType.returned_empty:  return 'Retour vide';
      case StockMovementType.exchanged:       return 'Échange';
    }
  }

  Color get _typeColor {
    switch (entry.type) {
      case StockMovementType.supply:         return Colors.green;
      case StockMovementType.sold:           return AppTheme.primaryBlue;
      case StockMovementType.returned_empty: return Colors.grey;
      case StockMovementType.exchanged:      return Colors.orange;
    }
  }

  IconData get _typeIcon {
    switch (entry.type) {
      case StockMovementType.supply:         return Icons.add_shopping_cart_rounded;
      case StockMovementType.sold:           return Icons.sell_rounded;
      case StockMovementType.returned_empty: return Icons.keyboard_return_rounded;
      case StockMovementType.exchanged:      return Icons.swap_horiz_rounded;
    }
  }

  String get _bottleLabel {
    switch (entry.bottleTypeId) {
      case 'BT-001': return '6 kg';
      case 'BT-002': return '12.5 kg';
      case 'BT-003': return '24 kg';
      default: return entry.bottleTypeId;
    }
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    return GlassCard(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: _typeColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(_typeIcon, color: _typeColor, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$_typeLabel · $_bottleLabel',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
                if (entry.note != null)
                  Text(
                    entry.note!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
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
                entry.type == StockMovementType.supply
                    ? '+${entry.quantity}'
                    : '−${entry.quantity}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: entry.type == StockMovementType.supply
                      ? Colors.green
                      : Colors.red,
                ),
              ),
              Text(
                _formatTime(entry.createdAt),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: GlassConstants.mutedColor(brightness),
                      fontSize: 10,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 60) return 'il y a ${diff.inMinutes} min';
    if (diff.inHours < 24) return 'il y a ${diff.inHours}h';
    return '${dt.day}/${dt.month}';
  }
}

// ─────────────────────────────────────────────
// SHEET AJOUT MOUVEMENT
// ─────────────────────────────────────────────
class _AddMovementSheet extends StatefulWidget {
  final DepotProvider depotProv;
  final String? preselectedBottle;

  const _AddMovementSheet({
    required this.depotProv,
    this.preselectedBottle,
  });

  @override
  State<_AddMovementSheet> createState() => _AddMovementSheetState();
}

class _AddMovementSheetState extends State<_AddMovementSheet> {
  String _selectedBottle = 'BT-001';
  StockMovementType _selectedType = StockMovementType.supply;
  final _quantityController = TextEditingController(text: '1');
  final _noteController = TextEditingController();

  final _bottleOptions = const [
    ('BT-001', '6 kg'),
    ('BT-002', '12.5 kg'),
    ('BT-003', '24 kg'),
  ];

  final _typeOptions = const [
    (StockMovementType.supply, 'Approvisionnement', Icons.add_shopping_cart_rounded, Colors.green),
    (StockMovementType.sold, 'Vendu', Icons.sell_rounded, Colors.blue),
    (StockMovementType.returned_empty, 'Retour vide', Icons.keyboard_return_rounded, Colors.grey),
    (StockMovementType.exchanged, 'Échange', Icons.swap_horiz_rounded, Colors.orange),
  ];

  @override
  void initState() {
    super.initState();
    if (widget.preselectedBottle != null) {
      _selectedBottle = widget.preselectedBottle!;
    }
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        left: 16,
        right: 16,
        top: 0,
      ),
      child: GlassCard(
        radius: GlassConstants.radiusL,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Text(
                'Enregistrer un mouvement',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(height: 16),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Type de bouteille
                  Text('Type de bouteille',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: GlassConstants.mutedColor(brightness),
                          )),
                  const SizedBox(height: 8),
                  Row(
                    children: _bottleOptions.map((opt) {
                      final selected = _selectedBottle == opt.$1;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () =>
                              setState(() => _selectedBottle = opt.$1),
                          child: Container(
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: selected
                                  ? GlassConstants.accent.withValues(alpha: 0.15)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: selected
                                    ? GlassConstants.accent
                                    : GlassConstants.borderColor(brightness),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                opt.$2,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                  color: selected
                                      ? GlassConstants.accent
                                      : GlassConstants.bodyColor(brightness),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),

                  // Type de mouvement
                  Text('Type de mouvement',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: GlassConstants.mutedColor(brightness),
                          )),
                  const SizedBox(height: 8),
                  GridView.count(
                    shrinkWrap: true,
                    crossAxisCount: 2,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childAspectRatio: 3.2,
                    physics: const NeverScrollableScrollPhysics(),
                    children: _typeOptions.map((opt) {
                      final selected = _selectedType == opt.$1;
                      return GestureDetector(
                        onTap: () =>
                            setState(() => _selectedType = opt.$1),
                        child: Container(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: selected
                                ? opt.$4.withValues(alpha: 0.15)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: selected
                                  ? opt.$4
                                  : GlassConstants.borderColor(brightness),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(opt.$3,
                                  size: 16,
                                  color: selected ? opt.$4 : GlassConstants.mutedColor(brightness)),
                              const SizedBox(width: 6),
                              Flexible(
                                child: Text(
                                  opt.$2,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: selected
                                        ? opt.$4
                                        : GlassConstants.bodyColor(brightness),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),

                  // Quantité
                  Text('Quantité',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: GlassConstants.mutedColor(brightness),
                          )),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          final v = int.tryParse(_quantityController.text) ?? 1;
                          if (v > 1)
                            setState(() => _quantityController.text = '${v - 1}');
                        },
                        icon: const Icon(Icons.remove_circle_outline_rounded),
                        color: AppTheme.primaryBlue,
                      ),
                      Expanded(
                        child: TextField(
                          controller: _quantityController,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8)),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 12),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          final v = int.tryParse(_quantityController.text) ?? 1;
                          setState(() => _quantityController.text = '${v + 1}');
                        },
                        icon: const Icon(Icons.add_circle_outline_rounded),
                        color: AppTheme.primaryBlue,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Note (optionnelle)
                  TextField(
                    controller: _noteController,
                    decoration: InputDecoration(
                      labelText: 'Note (optionnel)',
                      hintText: 'Ex: Approvisionnement fournisseur Kotto',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Bouton enregistrer
                  SizedBox(
                    width: double.infinity,
                    child: GlassButton(
                      onPressed: () {
                        final qty =
                            int.tryParse(_quantityController.text) ?? 1;
                        widget.depotProv.addStockEntry(
                          bottleTypeId: _selectedBottle,
                          type: _selectedType,
                          quantity: qty,
                          note: _noteController.text.isEmpty
                              ? null
                              : _noteController.text,
                        );
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Mouvement enregistré')),
                        );
                      },
                      child: const Text(
                        'Enregistrer',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
