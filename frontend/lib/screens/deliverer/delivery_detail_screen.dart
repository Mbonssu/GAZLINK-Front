import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/models.dart';
import '../../providers/delivery_provider.dart';
import '../../theme/glass/glass_components.dart';
import '../../theme/glass/glass_constants.dart';

class DeliveryDetailScreen extends StatefulWidget {
  final Delivery delivery;

  DeliveryDetailScreen({required this.delivery});

  @override
  State<DeliveryDetailScreen> createState() => _DeliveryDetailScreenState();
}

class _DeliveryDetailScreenState extends State<DeliveryDetailScreen> {
  late Delivery _delivery;
  String? _deliveryNotes;

  @override
  void initState() {
    super.initState();
    _delivery = widget.delivery;
  }

  @override
  Widget build(BuildContext context) {
    return GlassScaffold(
      appBar: GlassAppBar(
        title: const Text('Détails de livraison'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Progress
            _buildStatusProgress(),
            SizedBox(height: 24),
            // Client Info
            _buildClientInfo(),
            SizedBox(height: 24),
            // Delivery Address
            _buildDeliveryAddress(),
            SizedBox(height: 24),
            // Tracking Map (Mockée)
            _buildTrackingMap(),
            SizedBox(height: 24),
            // Action Buttons
            _buildActionButtons(),
            SizedBox(height: 24),
            // Notes
            _buildNotesField(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusProgress() {
    final statuses = [
      ('Assignée', OrderStatus.assigned),
      ('En route', OrderStatus.in_delivery),
      ('Livrée', OrderStatus.delivered),
    ];

    return GlassCard(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Progression', style: Theme.of(context).textTheme.titleSmall),
            SizedBox(height: 16),
            Column(
              children: List.generate(statuses.length, (index) {
                final (label, status) = statuses[index];
                final isCompleted = _isStatusCompleted(status);
                final isCurrent = _delivery.status == status;

                return Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: isCompleted || isCurrent
                                ? GlassConstants.accent
                                : Colors.grey.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isCompleted ? Icons.check : Icons.circle,
                            color: isCompleted || isCurrent
                                ? Colors.white
                                : Colors.grey,
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(label,
                                  style:
                                      Theme.of(context).textTheme.bodyMedium),
                              if (isCurrent)
                                Text('En cours',
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: GlassConstants.accent,
                                        fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    if (index < statuses.length - 1)
                      Padding(
                        padding: EdgeInsets.only(left: 20, top: 8, bottom: 8),
                        child: Container(
                          height: 20,
                          width: 2,
                          color: isCompleted
                              ? GlassConstants.accent
                              : Colors.grey.withValues(alpha: 0.2),
                        ),
                      ),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClientInfo() {
    return GlassCard(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Client', style: Theme.of(context).textTheme.titleSmall),
            SizedBox(height: 12),
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: GlassConstants.accent.withValues(alpha: 0.2),
                  child: Icon(Icons.person, color: GlassConstants.accent),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_delivery.clientName,
                          style: Theme.of(context).textTheme.titleMedium),
                      SizedBox(height: 4),
                      Text(_delivery.clientPhone,
                          style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.phone, color: GlassConstants.accent),
                  onPressed: () {
                    // TODO: Implement phone call functionality
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Appel vers ${_delivery.clientPhone}')),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeliveryAddress() {
    return GlassCard(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Adresse de livraison',
                style: Theme.of(context).textTheme.titleSmall),
            SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.location_on, color: Colors.red, size: 24),
                SizedBox(width: 12),
                Expanded(
                  child: Text(_delivery.deliveryAddress,
                      style: Theme.of(context).textTheme.bodyMedium),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrackingMap() {
    return GlassCard(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Position actuelle',
                style: Theme.of(context).textTheme.titleSmall),
            SizedBox(height: 12),
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.map, size: 48, color: Colors.grey),
                    SizedBox(height: 8),
                    Text('Carte mockée',
                        style: Theme.of(context).textTheme.bodySmall),
                    SizedBox(height: 4),
                    Text(
                        'Lat: ${_delivery.currentLatitude?.toStringAsFixed(4)}, Lng: ${_delivery.currentLongitude?.toStringAsFixed(4)}',
                        style: TextStyle(fontSize: 10, color: Colors.grey)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        if (_delivery.status == OrderStatus.assigned)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: Icon(Icons.navigation),
              label: Text('Commencer la livraison'),
              onPressed: () => _updateStatus(OrderStatus.in_delivery),
            ),
          ),
        if (_delivery.status == OrderStatus.in_delivery) ...[
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: Icon(Icons.check_circle),
              label: Text('Marquer comme livrée'),
              onPressed: () => _updateStatus(OrderStatus.delivered),
            ),
          ),
          SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              icon: Icon(Icons.report_problem_outlined),
              label: Text('Signaler un problème'),
              onPressed: () => _showProblemDialog(),
            ),
          ),
        ],
        if (_delivery.status == OrderStatus.delivered)
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.green),
            ),
            child: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green),
                SizedBox(width: 12),
                Expanded(
                  child: Text('Livraison complétée',
                      style: TextStyle(
                          color: Colors.green, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildNotesField() {
    return GlassCard(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Notes de livraison',
                style: Theme.of(context).textTheme.titleSmall),
            SizedBox(height: 12),
            TextField(
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Ajouter des notes...',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onChanged: (value) => setState(() => _deliveryNotes = value),
            ),
            if (_deliveryNotes != null && _deliveryNotes!.isNotEmpty) ...[
              SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _saveNotes(),
                  child: Text('Enregistrer les notes'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  bool _isStatusCompleted(OrderStatus status) {
    final statuses = [
      OrderStatus.assigned,
      OrderStatus.in_delivery,
      OrderStatus.delivered
    ];
    final currentIndex = statuses.indexOf(_delivery.status);
    final statusIndex = statuses.indexOf(status);
    return statusIndex < currentIndex;
  }

  void _updateStatus(OrderStatus status) {
    context.read<DeliveryProvider>().updateDeliveryStatus(_delivery.id, status);
    setState(() => _delivery = _delivery);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Statut mis à jour')),
    );
  }

  void _showProblemDialog() {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.38),
      builder: (context) => GlassDialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Signaler un problème',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            const TextField(
              decoration: InputDecoration(
                hintText: 'Décrivez le problème...',
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Annuler'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Problème signalé')),
                      );
                    },
                    child: const Text('Envoyer'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _saveNotes() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Notes enregistrées')),
    );
  }
}
