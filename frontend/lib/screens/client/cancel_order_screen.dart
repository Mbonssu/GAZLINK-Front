import 'package:flutter/material.dart';
import '../../models/models.dart';
import '../../theme/glass/glass_components.dart';
import '../../theme/glass/glass_constants.dart';

class CancelOrderScreen extends StatefulWidget {
  final Order order;

  const CancelOrderScreen({
    super.key,
    required this.order,
  });

  @override
  State<CancelOrderScreen> createState() => _CancelOrderScreenState();
}

class _CancelOrderScreenState extends State<CancelOrderScreen> {
  String? _selectedReason;
  final _otherReasonController = TextEditingController();
  bool _isSubmitting = false;

  final List<Map<String, dynamic>> _cancellationReasons = [
    {
      'title': 'Délai de livraison trop long',
      'icon': Icons.access_time,
    },
    {
      'title': 'J\'ai trouvé un meilleur prix',
      'icon': Icons.attach_money,
    },
    {
      'title': 'Commande par erreur',
      'icon': Icons.error_outline,
    },
    {
      'title': 'Changement d\'adresse',
      'icon': Icons.location_off,
    },
    {
      'title': 'Problème de paiement',
      'icon': Icons.payment,
    },
    {
      'title': 'Autre raison',
      'icon': Icons.more_horiz,
    },
  ];

  @override
  void dispose() {
    _otherReasonController.dispose();
    super.dispose();
  }

  bool get _canCancel {
    return widget.order.status == OrderStatus.pending ||
        widget.order.status == OrderStatus.confirmed;
  }

  Future<void> _confirmCancellation() async {
    if (_selectedReason == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez sélectionner une raison'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_selectedReason == 'Autre raison' &&
        _otherReasonController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez préciser la raison'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => GlassDialog(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.warning_amber_rounded,
                size: 48,
                color: Colors.orange,
              ),
              const SizedBox(height: 16),
              Text(
                'Confirmer l\'annulation',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Êtes-vous sûr de vouloir annuler cette commande ?',
                style: TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Non'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GlassButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Oui, annuler'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    if (confirmed != true) return;

    setState(() => _isSubmitting = true);

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    setState(() => _isSubmitting = false);

    // Show success message and go back
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Commande annulée avec succès'),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.pop(context, true); // Return true to indicate cancellation
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    if (!_canCancel) {
      return GlassScaffold(
        appBar: GlassAppBar(
          title: const Text('Annuler la commande'),
        ),
        body: Center(
          child: Padding(
            padding: GlassConstants.pagePadding,
            child: GlassCard(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.block,
                    size: 64,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Impossible d\'annuler',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: GlassConstants.titleColor(brightness),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Cette commande ne peut plus être annulée car elle est déjà en cours de livraison.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: GlassConstants.bodyColor(brightness),
                    ),
                  ),
                  const SizedBox(height: 24),
                  GlassButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Retour'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return GlassScaffold(
      appBar: GlassAppBar(
        title: const Text('Annuler la commande'),
      ),
      body: SingleChildScrollView(
        padding: GlassConstants.pagePadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Info
            GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Commande ${widget.order.id}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: GlassConstants.titleColor(brightness),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildInfoRow(
                    'Dépôt',
                    widget.order.depotName,
                    brightness,
                  ),
                  _buildInfoRow(
                    'Quantité',
                    '${widget.order.getTotalQuantity()} bouteilles',
                    brightness,
                  ),
                  _buildInfoRow(
                    'Montant',
                    '${widget.order.finalPrice.toStringAsFixed(0)} FCFA',
                    brightness,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Warning Message
            GlassCard(
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Colors.orange,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'L\'annulation est gratuite. Vous serez remboursé sous 3-5 jours ouvrables.',
                      style: TextStyle(
                        fontSize: 13,
                        color: GlassConstants.bodyColor(brightness),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Cancellation Reasons
            Text(
              'Raison de l\'annulation',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: GlassConstants.titleColor(brightness),
              ),
            ),
            const SizedBox(height: 12),

            ...(_cancellationReasons.map((reason) {
              final isSelected = _selectedReason == reason['title'];
              return GlassCard(
                margin: const EdgeInsets.only(bottom: 8),
                onTap: () {
                  setState(() => _selectedReason = reason['title']);
                },
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? GlassConstants.accent.withValues(alpha: 0.2)
                            : GlassConstants.mutedColor(brightness)
                                .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        reason['icon'],
                        color: isSelected
                            ? GlassConstants.accent
                            : GlassConstants.mutedColor(brightness),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        reason['title'],
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                          color: isSelected
                              ? GlassConstants.titleColor(brightness)
                              : GlassConstants.bodyColor(brightness),
                        ),
                      ),
                    ),
                    Radio<String>(
                      value: reason['title'],
                      groupValue: _selectedReason,
                      onChanged: (value) {
                        setState(() => _selectedReason = value);
                      },
                      activeColor: GlassConstants.accent,
                    ),
                  ],
                ),
              );
            }).toList()),

            // Other Reason Text Field
            if (_selectedReason == 'Autre raison') ...[
              const SizedBox(height: 12),
              GlassCard(
                child: TextField(
                  controller: _otherReasonController,
                  maxLines: 3,
                  maxLength: 200,
                  decoration: InputDecoration(
                    hintText: 'Précisez la raison...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(GlassConstants.radiusS),
                    ),
                    filled: true,
                    fillColor: GlassConstants.adaptiveSurfaceColor(brightness),
                  ),
                ),
              ),
            ],

            const SizedBox(height: 32),

            // Action Buttons
            GlassButton(
              onPressed: _isSubmitting ? null : _confirmCancellation,
              child: _isSubmitting
                  ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          GlassConstants.titleColor(brightness),
                        ),
                      ),
                    )
                  : const Text('Confirmer l\'annulation'),
            ),
            const SizedBox(height: 12),

            Center(
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Garder ma commande',
                  style: TextStyle(
                    color: GlassConstants.accent,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, Brightness brightness) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: GlassConstants.mutedColor(brightness),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: GlassConstants.titleColor(brightness),
            ),
          ),
        ],
      ),
    );
  }
}
