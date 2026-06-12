import 'package:flutter/material.dart';
import '../../models/models.dart';
import '../../theme/glass/glass_components.dart';
import '../../theme/glass/glass_constants.dart';

class RateDeliveryScreen extends StatefulWidget {
  final Order order;

  const RateDeliveryScreen({
    super.key,
    required this.order,
  });

  @override
  State<RateDeliveryScreen> createState() => _RateDeliveryScreenState();
}

class _RateDeliveryScreenState extends State<RateDeliveryScreen> {
  double _deliveryRating = 0;
  double _depotRating = 0;
  final _commentController = TextEditingController();
  bool _isSubmitting = false;

  final List<String> _quickComments = [
    'Livraison rapide',
    'Livreur professionnel',
    'Bon service',
    'Bouteilles en bon état',
    'Prix correct',
    'Je recommande',
  ];

  final List<String> _selectedQuickComments = [];

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _submitRating() async {
    if (_deliveryRating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez noter la livraison'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    setState(() => _isSubmitting = false);

    // Show success dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => GlassDialog(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_circle,
                  size: 48,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Merci pour votre avis !',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Votre évaluation nous aide à améliorer notre service',
                style: TextStyle(
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              GlassButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close dialog
                  Navigator.of(context).pop(); // Go back to previous screen
                },
                child: const Text('Terminer'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    return GlassScaffold(
      appBar: GlassAppBar(
        title: const Text('Évaluer la livraison'),
      ),
      body: SingleChildScrollView(
        padding: GlassConstants.pagePadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Info
            GlassCard(
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Commande livrée',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: GlassConstants.titleColor(brightness),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.order.id,
                          style: TextStyle(
                            fontSize: 13,
                            color: GlassConstants.mutedColor(brightness),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Delivery Rating
            GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Comment s\'est passée la livraison ?',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: GlassConstants.titleColor(brightness),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(5, (index) {
                            return GestureDetector(
                              onTap: () {
                                setState(() => _deliveryRating = index + 1.0);
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                child: Icon(
                                  index < _deliveryRating
                                      ? Icons.star
                                      : Icons.star_border,
                                  size: 48,
                                  color: Colors.amber,
                                ),
                              ),
                            );
                          }),
                        ),
                        const SizedBox(height: 12),
                        if (_deliveryRating > 0)
                          Text(
                            _getRatingText(_deliveryRating),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: GlassConstants.accent,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Depot Rating
            GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Évaluez le dépôt',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: GlassConstants.titleColor(brightness),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.order.depotName,
                    style: TextStyle(
                      fontSize: 14,
                      color: GlassConstants.mutedColor(brightness),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() => _depotRating = index + 1.0);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Icon(
                              index < _depotRating
                                  ? Icons.star
                                  : Icons.star_border,
                              size: 40,
                              color: Colors.amber,
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Quick Comments
            if (_deliveryRating > 0) ...[
              GlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Commentaires rapides',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: GlassConstants.titleColor(brightness),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _quickComments.map((comment) {
                        final isSelected = _selectedQuickComments.contains(comment);
                        return FilterChip(
                          label: Text(comment),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                _selectedQuickComments.add(comment);
                              } else {
                                _selectedQuickComments.remove(comment);
                              }
                            });
                          },
                          backgroundColor: GlassConstants.adaptiveSurfaceColor(brightness),
                          selectedColor: GlassConstants.accent.withValues(alpha: 0.3),
                          labelStyle: TextStyle(
                            color: isSelected
                                ? GlassConstants.accent
                                : GlassConstants.bodyColor(brightness),
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Comment Field
            GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Commentaire (optionnel)',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: GlassConstants.titleColor(brightness),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _commentController,
                    maxLines: 4,
                    maxLength: 500,
                    decoration: InputDecoration(
                      hintText: 'Partagez votre expérience...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(GlassConstants.radiusS),
                      ),
                      filled: true,
                      fillColor: GlassConstants.adaptiveSurfaceColor(brightness),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Submit Button
            GlassButton(
              onPressed: _isSubmitting ? null : _submitRating,
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
                  : const Text('Envoyer l\'évaluation'),
            ),
            const SizedBox(height: 12),

            // Skip Button
            Center(
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Passer',
                  style: TextStyle(
                    color: GlassConstants.mutedColor(brightness),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getRatingText(double rating) {
    if (rating >= 5) return 'Excellent !';
    if (rating >= 4) return 'Très bien';
    if (rating >= 3) return 'Bien';
    if (rating >= 2) return 'Moyen';
    return 'Peut mieux faire';
  }
}
