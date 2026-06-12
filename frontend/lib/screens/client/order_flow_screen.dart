import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/models.dart';
import '../../providers/order_provider.dart';
import '../../theme/glass/glass_components.dart';
import '../../theme/glass/glass_constants.dart';

class OrderFlowScreen extends StatefulWidget {
  final Depot depot;

  OrderFlowScreen({required this.depot});

  @override
  State<OrderFlowScreen> createState() => _OrderFlowScreenState();
}

class _OrderFlowScreenState extends State<OrderFlowScreen> {
  int _currentStep = 0;
  int _quantity6kg = 0;
  int _quantity12kg = 0;
  String _selectedPayment = 'MTN_MOMO';
  String _deliveryAddress = '';
  bool _hasAttemptedContinue = false; // Pour afficher l'erreur seulement après tentative

  final double _pricePerBottle6kg = 4500;
  final double _pricePerBottle12kg = 6500;
  final double _discountPerBottle = 300;

  @override
  Widget build(BuildContext context) {
    return GlassScaffold(
      appBar: GlassAppBar(
        title: const Text('Nouvelle commande',
        style: TextStyle(
          color: Colors.white
          ),
        ),
        
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,
              color: Colors.white
           ),
          onPressed: () => Navigator.pop(context),
        ),

        backgroundColor: const Color.fromARGB(255, 18, 37, 214),
        // elevation: 0,
        foregroundColor: Colors.white,
        ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Stepper(
              type: StepperType.vertical,
              currentStep: _currentStep,
              onStepContinue: _handleStepContinue,
              onStepCancel: _handleStepCancel,
              elevation: 0,
              margin: EdgeInsets.zero,
              controlsBuilder: (context, details) => Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: GlassButton(
                        onPressed: details.onStepContinue,
                        child: Text(_currentStep == 3 ? 'Terminer' : 'Continuer'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (_currentStep > 0)
                      Expanded(
                        child: GlassButton(
                          onPressed: details.onStepCancel,
                          child: const Text('Retour'),
                        ),
                      ),
                  ],
                ),
              ),
              steps: [
                Step(
                  title: const Text('Quantités'),
                  content: _buildQuantityStep(),
                  isActive: _currentStep >= 0,
                  state: _currentStep > 0 ? StepState.complete : StepState.indexed,
                ),
                Step(
                  title: const Text('Récapitulatif'),
                  content: _buildSummaryStep(),
                  isActive: _currentStep >= 1,
                  state: _currentStep > 1 ? StepState.complete : StepState.indexed,
                ),
                Step(
                  title: const Text('Paiement'),
                  content: _buildPaymentStep(),
                  isActive: _currentStep >= 2,
                  state: _currentStep > 2 ? StepState.complete : StepState.indexed,
                ),
                Step(
                  title: const Text('Confirmation'),
                  content: _buildConfirmationStep(),
                  isActive: _currentStep >= 3,
                  state: _currentStep >= 3 ? StepState.complete : StepState.indexed,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuantityStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GlassCard(
          padding: const EdgeInsets.all(9),
          child: Row(
            children: [
              Icon(Icons.store_rounded, color: GlassConstants.accent, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Dépôt: ${widget.depot.name}',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _buildQuantitySelector('6 kg', _quantity6kg,
            (val) => setState(() => _quantity6kg = val)),
        const SizedBox(height: 12),
        _buildQuantitySelector('12.5 kg', _quantity12kg,
            (val) => setState(() => _quantity12kg = val)),
        const SizedBox(height: 16),
        if (_hasAttemptedContinue && _quantity6kg == 0 && _quantity12kg == 0)
          GlassCard(
            padding: const EdgeInsets.all(10),
            color: Colors.orange.withValues(alpha: 0.20),
            child: Row(
              children: [
                Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Sélectionnez au moins une bouteille',
                    style: TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildQuantitySelector(
      String label, int value, Function(int) onChanged) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.remove_circle_outline),
                onPressed: value > 0 ? () => onChanged(value - 1) : null,
                iconSize: 28,
                padding: EdgeInsets.all(8),
                constraints: BoxConstraints(),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: GlassConstants.accent.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$value',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              IconButton(
                icon: Icon(Icons.add_circle_outline),
                onPressed: () => onChanged(value + 1),
                iconSize: 28,
                padding: EdgeInsets.all(8),
                constraints: BoxConstraints(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryStep() {
    final total6kg = _quantity6kg * _pricePerBottle6kg;
    final total12kg = _quantity12kg * _pricePerBottle12kg;
    final totalPrice = total6kg + total12kg;
    final totalDiscount = (_quantity6kg + _quantity12kg) * _discountPerBottle;
    final finalPrice = totalPrice - totalDiscount;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GlassCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Récapitulatif de votre commande',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 16),
              _buildSummaryRow('Dépôt', widget.depot.name),
              const Divider(height: 24),
              _buildSummaryRow('Bouteilles 6 kg', '${_quantity6kg}x'),
              _buildSummaryRow('Prix 6 kg', '${total6kg.toStringAsFixed(0)} FCFA'),
              const SizedBox(height: 8),
              _buildSummaryRow('Bouteilles 12.5 kg', '${_quantity12kg}x'),
              _buildSummaryRow(
                  'Prix 12.5 kg', '${total12kg.toStringAsFixed(0)} FCFA'),
              const Divider(height: 24),
              _buildSummaryRow('Sous-total', '${totalPrice.toStringAsFixed(0)} FCFA',
                  isBold: true),
            ],
          ),
        ),
        const SizedBox(height: 12),
        GlassCard(
          padding: const EdgeInsets.all(16),
          color: Colors.green.withValues(alpha: 0.15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.discount_rounded, color: Colors.green, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Subvention',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '-${totalDiscount.toStringAsFixed(0)} FCFA (300 FCFA par bouteille)',
                style: TextStyle(
                  color: Colors.green.shade700,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        GlassCard(
          padding: const EdgeInsets.all(16),
          color: GlassConstants.accent.withValues(alpha: 0.15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total à payer',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                '${finalPrice.toStringAsFixed(0)} FCFA',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: GlassConstants.accent,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
          Text(value,
              style: TextStyle(
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }

  Widget _buildPaymentStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GlassCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Méthode de paiement',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 16),
              _buildPaymentOption('MTN_MOMO', 'MTN MoMo', Icons.phone_android),
              const SizedBox(height: 12),
              _buildPaymentOption(
                  'ORANGE_MONEY', 'Orange Money', Icons.phone_android),
            ],
          ),
        ),
        const SizedBox(height: 16),
        GlassCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Adresse de livraison',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 12),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Entrez votre adresse complète',
                  prefixIcon: Icon(Icons.location_on_rounded),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white.withValues(alpha: 0.05)
                      : Colors.black.withValues(alpha: 0.03),
                ),
                onChanged: (value) => setState(() => _deliveryAddress = value),
                maxLines: 3,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentOption(String value, String label, IconData icon) {
    final isSelected = _selectedPayment == value;
    return GestureDetector(
      onTap: () => setState(() => _selectedPayment = value),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected
              ? GlassConstants.accent.withValues(alpha: 0.15)
              : (Theme.of(context).brightness == Brightness.dark
                  ? Colors.white.withValues(alpha: 0.05)
                  : Colors.black.withValues(alpha: 0.03)),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? GlassConstants.accent
                : (Theme.of(context).brightness == Brightness.dark
                    ? Colors.white.withValues(alpha: 0.1)
                    : Colors.black.withValues(alpha: 0.1)),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? GlassConstants.accent : Colors.grey,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle_rounded,
                color: GlassConstants.accent,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildConfirmationStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GlassCard(
          padding: const EdgeInsets.all(14),
          color: Colors.green.withValues(alpha: 0.15),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_circle_rounded,
                  size: 56,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Commande confirmée !',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Colors.green,
                ),
              ),
              // const SizedBox(height: 8),
              // Text(
              //   'Votre commande a été enregistrée avec succès',
              //   style: Theme.of(context).textTheme.bodyMedium,
              //   textAlign: TextAlign.center,
              // ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        GlassCard(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Détails de la commande',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 16),
              _buildConfirmationRow(
                  'ID Commande', 'CMD-${DateTime.now().millisecondsSinceEpoch}'),
              _buildConfirmationRow('Dépôt', widget.depot.name),
              _buildConfirmationRow(
                  'Quantité', '${_quantity6kg + _quantity12kg} bouteilles'),
              _buildConfirmationRow('Paiement',
                  _selectedPayment == 'MTN_MOMO' ? 'MTN MoMo' : 'Orange Money'),
              _buildConfirmationRow('Statut', 'En attente de confirmation'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildConfirmationRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
          Text(value, style: TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  void _handleStepContinue() {
    if (_currentStep == 0) {
      setState(() => _hasAttemptedContinue = true);
      
      if (_quantity6kg == 0 && _quantity12kg == 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sélectionnez au moins une bouteille')),
        );
        return;
      }
    }

    if (_currentStep == 2 && _deliveryAddress.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Entrez votre adresse de livraison')),
      );
      return;
    }

    if (_currentStep < 3) {
      setState(() => _currentStep++);
    } else {
      // Create order
      final order = Order(
        id: 'CMD-${DateTime.now().millisecondsSinceEpoch}',
        clientId: 'USR-001',
        depotId: widget.depot.id,
        quantity6kg: _quantity6kg,
        quantity12kg: _quantity12kg,
        totalPrice: (_quantity6kg * 4500) + (_quantity12kg * 6500),
        discount: (_quantity6kg + _quantity12kg) * 300,
        finalPrice: ((_quantity6kg * 4500) + (_quantity12kg * 6500)) -
            ((_quantity6kg + _quantity12kg) * 300),
        status: OrderStatus.pending,
        paymentMethod: _selectedPayment,
        createdAt: DateTime.now(),
        deliveryAddress: _deliveryAddress,
      );

      context.read<OrderProvider>().createOrder(order);

      Future.delayed(Duration(seconds: 2), () {
        if (mounted) {
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
      });
    }
  }

  void _handleStepCancel() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }
}
