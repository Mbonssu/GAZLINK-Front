import 'package:flutter/material.dart';
import '../../theme/glass/glass_components.dart';
import '../../theme/glass/glass_constants.dart';
import '../../routes.dart';

class MtnMomoPaymentScreen extends StatefulWidget {
  final double amount;
  final String orderId;

  const MtnMomoPaymentScreen({
    super.key,
    required this.amount,
    required this.orderId,
  });

  @override
  State<MtnMomoPaymentScreen> createState() => _MtnMomoPaymentScreenState();
}

class _MtnMomoPaymentScreenState extends State<MtnMomoPaymentScreen> {
  final _phoneController = TextEditingController();
  bool _isProcessing = false;
  String? _phoneError;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  bool _validatePhone(String phone) {
    // Remove spaces and special characters
    final cleaned = phone.replaceAll(RegExp(r'[\s\-\(\)]'), '');
    
    // Check if it's a valid Cameroon MTN number
    // MTN numbers start with 67, 650-654, 680-683
    final mtnPattern = RegExp(r'^(\+237)?6(7|5[0-4]|8[0-3])\d{7}$');
    
    return mtnPattern.hasMatch(cleaned);
  }

  Future<void> _processPayment() async {
    final phone = _phoneController.text.trim();

    if (phone.isEmpty) {
      setState(() => _phoneError = 'Veuillez entrer votre numéro');
      return;
    }

    if (!_validatePhone(phone)) {
      setState(() => _phoneError = 'Numéro MTN MoMo invalide');
      return;
    }

    setState(() {
      _phoneError = null;
      _isProcessing = true;
    });

    // Simulate payment processing
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    setState(() => _isProcessing = false);

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
                'Paiement réussi !',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Votre commande a été confirmée',
                style: TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              GlassButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close dialog
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRoutes.orderTracking,
                    (route) => route.isFirst,
                    arguments: widget.orderId,
                  );
                },
                child: const Text('Voir ma commande'),
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
        title: const Text('MTN Mobile Money'),
      ),
      body: SingleChildScrollView(
        padding: GlassConstants.pagePadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // MTN Logo Card
            GlassCard(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: GlassConstants.mtnMomoYellow.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.phone_android,
                      size: 48,
                      color: GlassConstants.mtnMomoYellow,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'MTN Mobile Money',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: GlassConstants.titleColor(brightness),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Paiement sécurisé',
                    style: TextStyle(
                      fontSize: 14,
                      color: GlassConstants.mutedColor(brightness),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

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

            // Phone Number Input
            GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Numéro MTN MoMo',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: GlassConstants.titleColor(brightness),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      hintText: '+237 6 XX XX XX XX',
                      prefixIcon: Icon(Icons.phone),
                      errorText: _phoneError,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(GlassConstants.radiusS),
                      ),
                      filled: true,
                      fillColor: GlassConstants.adaptiveSurfaceColor(brightness),
                    ),
                    onChanged: (value) {
                      if (_phoneError != null) {
                        setState(() => _phoneError = null);
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Numéros acceptés: 67, 650-654, 680-683',
                    style: TextStyle(
                      fontSize: 12,
                      color: GlassConstants.mutedColor(brightness),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Instructions
            GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: GlassConstants.accent,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Instructions',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: GlassConstants.titleColor(brightness),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildInstructionStep(
                    '1',
                    'Entrez votre numéro MTN MoMo',
                    brightness,
                  ),
                  _buildInstructionStep(
                    '2',
                    'Vous recevrez une notification sur votre téléphone',
                    brightness,
                  ),
                  _buildInstructionStep(
                    '3',
                    'Entrez votre code PIN pour confirmer',
                    brightness,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Pay Button
            GlassButton(
              onPressed: _isProcessing ? null : _processPayment,
              child: _isProcessing
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              GlassConstants.titleColor(brightness),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text('Traitement en cours...'),
                      ],
                    )
                  : Text('Payer ${widget.amount.toStringAsFixed(0)} FCFA'),
            ),
            const SizedBox(height: 16),

            // Security Note
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.lock,
                    size: 16,
                    color: GlassConstants.mutedColor(brightness),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Paiement sécurisé par MTN',
                    style: TextStyle(
                      fontSize: 12,
                      color: GlassConstants.mutedColor(brightness),
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

  Widget _buildInstructionStep(
    String number,
    String text,
    Brightness brightness,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: GlassConstants.accent.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: GlassConstants.accent,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: GlassConstants.bodyColor(brightness),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
