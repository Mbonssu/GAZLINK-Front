import 'package:flutter/material.dart';
import '../../theme/glass/glass_components.dart';
import '../../theme/glass/glass_constants.dart';
import '../../routes.dart';

class SavedAddressesScreen extends StatefulWidget {
  const SavedAddressesScreen({Key? key}) : super(key: key);

  @override
  State<SavedAddressesScreen> createState() => _SavedAddressesScreenState();
}

class _SavedAddressesScreenState extends State<SavedAddressesScreen> {
  final List<_Address> _addresses = [
    _Address(
      id: '1',
      label: 'Maison',
      address: 'Boulevard de la Liberté, Bonapriso, Douala',
      isDefault: true,
    ),
    _Address(
      id: '2',
      label: 'Bureau',
      address: 'Avenue Général de Gaulle, Akwa, Douala',
      isDefault: false,
    ),
    _Address(
      id: '3',
      label: 'Parents',
      address: 'Rue Nkongamba, Bali, Douala',
      isDefault: false,
    ),
  ];

  void _setDefaultAddress(String id) {
    setState(() {
      for (var address in _addresses) {
        address.isDefault = address.id == id;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Adresse par défaut modifiée')),
    );
  }

  void _deleteAddress(String id) {
    setState(() {
      _addresses.removeWhere((a) => a.id == id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Adresse supprimée')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GlassScaffold(
      appBar: GlassAppBar(
        title: const Text('Mes adresses'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: _addresses.isEmpty
          ? _buildEmptyState(context)
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: _addresses.length + 1,
              itemBuilder: (context, index) {
                if (index == _addresses.length) {
                  return _buildAddButton(context);
                }
                return _buildAddressCard(context, _addresses[index]);
              },
            ),
      floatingActionButton: _addresses.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: () => Navigator.of(context).pushNamed(AppRoutes.addEditAddress),
              icon: const Icon(Icons.add),
              label: const Text('Ajouter'),
              backgroundColor: GlassConstants.accent,
            )
          : null,
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.location_off_outlined,
            size: 80,
            color: GlassConstants.mutedColor(Theme.of(context).brightness),
          ),
          const SizedBox(height: 16),
          Text(
            'Aucune adresse',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: GlassConstants.mutedColor(Theme.of(context).brightness),
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Ajoutez une adresse de livraison',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: GlassConstants.mutedColor(Theme.of(context).brightness),
                ),
          ),
          const SizedBox(height: 24),
          GlassButton(
            onPressed: () => Navigator.of(context).pushNamed(AppRoutes.addEditAddress),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add, size: 20),
                SizedBox(width: 8),
                Text('Ajouter une adresse'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: GlassCard(
        onTap: () => Navigator.of(context).pushNamed(AppRoutes.addEditAddress),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, color: GlassConstants.accent),
            const SizedBox(width: 8),
            Text(
              'Ajouter une nouvelle adresse',
              style: TextStyle(
                color: GlassConstants.accent,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressCard(BuildContext context, _Address address) {
    return GlassCard(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(
                      _getIconForLabel(address.label),
                      color: GlassConstants.accent,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      address.label,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    if (address.isDefault) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: GlassConstants.accent.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Par défaut',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: GlassConstants.accent,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              PopupMenuButton<String>(
                icon: Icon(
                  Icons.more_vert,
                  color: GlassConstants.mutedColor(Theme.of(context).brightness),
                ),
                onSelected: (value) {
                  if (value == 'edit') {
                    Navigator.of(context).pushNamed(AppRoutes.addEditAddress, arguments: {'address': address.id});
                  } else if (value == 'default') {
                    _setDefaultAddress(address.id);
                  } else if (value == 'delete') {
                    _showDeleteDialog(address);
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit_outlined, size: 20),
                        SizedBox(width: 12),
                        Text('Modifier'),
                      ],
                    ),
                  ),
                  if (!address.isDefault)
                    const PopupMenuItem(
                      value: 'default',
                      child: Row(
                        children: [
                          Icon(Icons.check_circle_outline, size: 20),
                          SizedBox(width: 12),
                          Text('Définir par défaut'),
                        ],
                      ),
                    ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete_outline, size: 20, color: Colors.red),
                        SizedBox(width: 12),
                        Text('Supprimer', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            address.address,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: GlassConstants.mutedColor(Theme.of(context).brightness),
                ),
          ),
        ],
      ),
    );
  }

  IconData _getIconForLabel(String label) {
    switch (label.toLowerCase()) {
      case 'maison':
        return Icons.home_outlined;
      case 'bureau':
        return Icons.work_outline;
      case 'parents':
        return Icons.family_restroom_outlined;
      default:
        return Icons.location_on_outlined;
    }
  }

  void _showDeleteDialog(_Address address) {
    showDialog(
      context: context,
      builder: (context) => GlassDialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.delete_outline,
              size: 48,
              color: Colors.red.withValues(alpha: 0.8),
            ),
            const SizedBox(height: 16),
            Text(
              'Supprimer l\'adresse',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Êtes-vous sûr de vouloir supprimer "${address.label}" ?',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Annuler'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _deleteAddress(address.id);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: const Text('Supprimer'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Address {
  final String id;
  final String label;
  final String address;
  bool isDefault;

  _Address({
    required this.id,
    required this.label,
    required this.address,
    required this.isDefault,
  });
}
