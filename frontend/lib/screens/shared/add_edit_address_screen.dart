import 'package:flutter/material.dart';
import '../../theme/glass/glass_components.dart';
import '../../theme/glass/glass_constants.dart';

class AddEditAddressScreen extends StatefulWidget {
  final Map<String, dynamic>? address;

  const AddEditAddressScreen({Key? key, this.address}) : super(key: key);

  @override
  State<AddEditAddressScreen> createState() => _AddEditAddressScreenState();
}

class _AddEditAddressScreenState extends State<AddEditAddressScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _labelController;
  late TextEditingController _addressController;
  late TextEditingController _cityController;
  late TextEditingController _notesController;
  bool _isDefault = false;
  bool _isLoading = false;
  String? _addressId;

  final List<String> _labelSuggestions = ['Maison', 'Bureau', 'Parents', 'Autre'];
  String _selectedLabel = 'Maison';

  @override
  void initState() {
    super.initState();
    _labelController = TextEditingController();
    _addressController = TextEditingController();
    _cityController = TextEditingController(text: 'Douala');
    _notesController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Get address ID if editing
    _addressId = ModalRoute.of(context)?.settings.arguments as String?;
    if (_addressId != null) {
      // Load address data for editing
      _loadAddressData();
    }
  }

  void _loadAddressData() {
    // Mock data loading
    _selectedLabel = 'Bureau';
    _addressController.text = 'Avenue Général de Gaulle, Akwa';
    _cityController.text = 'Douala';
    _notesController.text = 'Près de la pharmacie';
    _isDefault = false;
  }

  @override
  void dispose() {
    _labelController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_addressId == null
              ? 'Adresse ajoutée avec succès'
              : 'Adresse modifiée avec succès'),
        ),
      );
      Navigator.of(context).pop();
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = _addressId != null;

    return GlassScaffold(
      appBar: GlassAppBar(
        title: Text(isEditing ? 'Modifier l\'adresse' : 'Ajouter une adresse'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Label selection
                Text(
                  'Type d\'adresse',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _labelSuggestions.map((label) {
                    final isSelected = _selectedLabel == label;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedLabel = label),
                      child: AnimatedContainer(
                        duration: GlassConstants.motionFast,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? GlassConstants.accent.withValues(alpha: 0.15)
                              : GlassConstants.surfaceColor(Theme.of(context).brightness),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? GlassConstants.accent
                                : GlassConstants.borderColor(Theme.of(context).brightness),
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _getIconForLabel(label),
                              size: 18,
                              color: isSelected
                                  ? GlassConstants.accent
                                  : GlassConstants.mutedColor(Theme.of(context).brightness),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              label,
                              style: TextStyle(
                                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                color: isSelected
                                    ? GlassConstants.accent
                                    : GlassConstants.titleColor(Theme.of(context).brightness),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),
                
                // Form
                GlassCard(
                  radius: 28,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Address field
                      Text(
                        'Adresse complète',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _addressController,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.location_on_outlined, size: 20),
                          hintText: 'Ex: Boulevard de la Liberté, Bonapriso',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'L\'adresse est requise';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      
                      // City field
                      Text(
                        'Ville',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _cityController,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.location_city_outlined, size: 20),
                          hintText: 'Ex: Douala',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'La ville est requise';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      
                      // Notes field
                      Text(
                        'Instructions de livraison (optionnel)',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _notesController,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.notes_outlined, size: 20),
                          hintText: 'Ex: Près de la pharmacie, 2ème étage...',
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Default checkbox
                      CheckboxListTile(
                        value: _isDefault,
                        onChanged: (value) => setState(() => _isDefault = value ?? false),
                        title: const Text('Définir comme adresse par défaut'),
                        contentPadding: EdgeInsets.zero,
                        activeColor: GlassConstants.accent,
                      ),
                      const SizedBox(height: 8),
                      
                      // Save button
                      SizedBox(
                        width: double.infinity,
                        child: GlassButton(
                          onPressed: _isLoading ? null : _handleSave,
                          child: _isLoading
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.3,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                )
                              : Text(isEditing ? 'Modifier' : 'Ajouter'),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                
                // Map placeholder
                GlassCard(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.map_outlined, color: GlassConstants.accent),
                          const SizedBox(width: 8),
                          Text(
                            'Localiser sur la carte',
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Container(
                        height: 150,
                        decoration: BoxDecoration(
                          color: GlassConstants.surfaceColor(Theme.of(context).brightness),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.map,
                                size: 48,
                                color: GlassConstants.mutedColor(Theme.of(context).brightness),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Carte interactive à venir',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: GlassConstants.mutedColor(Theme.of(context).brightness),
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
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
}
