import 'package:flutter/material.dart';
import '../../theme/glass/glass_components.dart';
import '../../theme/glass/glass_constants.dart';
import '../../routes.dart';

class ReceiptScreen extends StatelessWidget {
  final Map<String, dynamic> payment;

  const ReceiptScreen({
    super.key,
    required this.payment,
  });

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    return GlassScaffold(
      appBar: GlassAppBar(
        title: const Text('Reçu'),
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Partage du reçu...')),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.download),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Téléchargement du reçu...')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: GlassConstants.pagePadding,
        child: Column(
          children: [
            GlassCard(
              child: Column(
                children: [
                  // Success Icon
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check_circle,
                      size: 64,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Paiement réussi',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: GlassConstants.titleColor(brightness),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _formatDate(payment['date']),
                    style: TextStyle(
                      fontSize: 14,
                      color: GlassConstants.mutedColor(brightness),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Amount
                  Text(
                    '${payment['amount'].toStringAsFixed(0)} FCFA',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w800,
                      color: GlassConstants.accent,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Divider(color: GlassConstants.borderColor(brightness)),
                  const SizedBox(height: 20),
                  // Details
                  _buildDetailRow(
                    'ID Transaction',
                    payment['id'],
                    brightness,
                  ),
                  _buildDetailRow(
                    'Numéro de commande',
                    payment['orderId'],
                    brightness,
                  ),
                  _buildDetailRow(
                    'Mode de paiement',
                    payment['method'],
                    brightness,
                  ),
                  _buildDetailRow(
                    'Statut',
                    payment['status'],
                    brightness,
                    valueColor: _getStatusColor(payment['status']),
                  ),
                  _buildDetailRow(
                    'Date',
                    _formatFullDate(payment['date']),
                    brightness,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Order Details
            GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Détails de la commande',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: GlassConstants.titleColor(brightness),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildDetailRow(
                    'Bouteille 6kg',
                    '1 x 3500 FCFA',
                    brightness,
                  ),
                  _buildDetailRow(
                    'Bouteille 12kg',
                    '1 x 6500 FCFA',
                    brightness,
                  ),
                  _buildDetailRow(
                    'Livraison',
                    '1500 FCFA',
                    brightness,
                  ),
                  _buildDetailRow(
                    'Réduction',
                    '-600 FCFA',
                    brightness,
                    valueColor: Colors.green,
                  ),
                  const SizedBox(height: 12),
                  Divider(color: GlassConstants.borderColor(brightness)),
                  const SizedBox(height: 12),
                  _buildDetailRow(
                    'Total',
                    '${payment['amount'].toStringAsFixed(0)} FCFA',
                    brightness,
                    isTotal: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Action Buttons
            GlassButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.orderHistory);
              },
              child: const Text('Voir mes commandes'),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.chatSupport);
              },
              child: const Text('Contacter le support'),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                side: BorderSide(color: GlassConstants.accent),
                foregroundColor: GlassConstants.accent,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    String label,
    String value,
    Brightness brightness, {
    Color? valueColor,
    bool isTotal = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
              color: GlassConstants.bodyColor(brightness),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 18 : 14,
              fontWeight: isTotal ? FontWeight.w800 : FontWeight.w600,
              color: valueColor ?? GlassConstants.titleColor(brightness),
            ),
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
      return 'Aujourd\'hui à ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      return 'Hier à ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  String _formatFullDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} à ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
