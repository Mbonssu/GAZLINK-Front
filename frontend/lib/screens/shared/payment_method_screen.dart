import 'package:flutter/material.dart';
import '../../theme/glass/glass_components.dart';
import '../../theme/glass/glass_constants.dart';
import '../../routes.dart';

class PaymentMethodScreen extends StatefulWidget {
  final double amount;
  final String orderId;

  const PaymentMethodScreen({
    super.key,
    required this.amount,
    required this.orderId,
  });

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  String? _selectedMethod;

  final List<Map<String, dynamic>> _paymentMethods = [
    {
      'id': 'mtn_momo',
      'name': 'MTN Mobile Money',
      'icon': Icons.phone_android,
      'color': GlassConstants.mtnMomoYellow,
      'description': 'Paiement via MTN MoMo',
    },
    {
      'id': 'orange_money',
      'name': 'Orange Money',
      'icon': Icons.phone_iphone,
      'color': GlassConstants.orangeMoneyOrange,
      'description': 'Paiement via Orange Money',
    },
    {
      'id': 'cash',
      'name': 'Espèces',
      'icon': Icons.money,
      'color': Colors.green,
      'description': 'Paiement à la livraison',
    },
  ];

  void _proceedToPayment() {
    if (_selectedMethod == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez sélectionner un mode de paiement'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    switch (_selectedMethod) {
      case 'mtn_momo':
        Navigator.pushNamed(
          context,
          AppRoutes.mtnMomoPayment,
          arguments: {
            'amount': widget.amount,
            'orderId': widget.orderId,
          },
        );
        break;
      case 'orange_money':
        Navigator.pushNamed(
          context,
          AppRoutes.orangeMoneyPayment,
          arguments: {
            'amount': widget.amount,
            'orderId': widget.orderId,
          },
        );
        break;
      case 'cash':
        // For cash payment, go directly to order confirmation
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.orderTracking,
          (route) => route.isFirst,
          arguments: widget.orderId,
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    return GlassScaffold(
      appBar: GlassAppBar(
        title: const Text('Mode de paiement'),
      ),
      body: SingleChildScrollView(
        padding: GlassConstants.pagePadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Amount Card
            GlassCard(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Montant à payer',
                    style: TextStyle(
                      fontSize: 16,
                      color: GlassConstants.mutedColor(brightness),
                    ),
                  ),
                  Text(
                    '${widget.amount.toStringAsFixed(0)} FCFA',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: GlassConstants.accent,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            Text(
              'Choisissez votre mode de paiement',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: GlassConstants.titleColor(brightness),
              ),
            ),
            const SizedBox(height: 16),

            // Payment Methods
            ...(_paymentMethods.map((method) {
              final isSelected = _selectedMethod == method['id'];
              return GlassCard(
                margin: const EdgeInsets.only(bottom: 12),
                onTap: () {
                  setState(() => _selectedMethod = method['id']);
                },
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: (method['color'] as Color).withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        method['icon'],
                        color: method['color'],
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            method['name'],
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: GlassConstants.titleColor(brightness),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            method['description'],
                            style: TextStyle(
                              fontSize: 13,
                              color: GlassConstants.mutedColor(brightness),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Radio<String>(
                      value: method['id'],
                      groupValue: _selectedMethod,
                      onChanged: (value) {
                        setState(() => _selectedMethod = value);
                      },
                      activeColor: GlassConstants.accent,
                    ),
                  ],
                ),
              );
            }).toList()),

            const SizedBox(height: 24),

            // Security Info
            GlassCard(
              child: Row(
                children: [
                  Icon(
                    Icons.security,
                    color: Colors.green,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Vos paiements sont sécurisés et cryptés',
                      style: TextStyle(
                        fontSize: 13,
                        color: GlassConstants.bodyColor(brightness),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Continue Button
            GlassButton(
              onPressed: _proceedToPayment,
              child: const Text('Continuer'),
            ),
          ],
        ),
      ),
    );
  }
}
