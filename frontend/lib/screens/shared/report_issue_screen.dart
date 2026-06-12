import 'package:flutter/material.dart';
import '../../theme/glass/glass_components.dart';
import '../../theme/glass/glass_constants.dart';

class ReportIssueScreen extends StatefulWidget {
  const ReportIssueScreen({super.key});

  @override
  State<ReportIssueScreen> createState() => _ReportIssueScreenState();
}

class _ReportIssueScreenState extends State<ReportIssueScreen> {
  String? _selectedCategory;
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isSubmitting = false;

  final List<Map<String, dynamic>> _categories = [
    {'id': 'order', 'name': 'Problème de commande', 'icon': Icons.shopping_cart},
    {'id': 'delivery', 'name': 'Problème de livraison', 'icon': Icons.local_shipping},
    {'id': 'payment', 'name': 'Problème de paiement', 'icon': Icons.payment},
    {'id': 'app', 'name': 'Problème technique', 'icon': Icons.bug_report},
    {'id': 'account', 'name': 'Problème de compte', 'icon': Icons.account_circle},
    {'id': 'other', 'name': 'Autre', 'icon': Icons.more_horiz},
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submitReport() async {
    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez sélectionner une catégorie'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez entrer un titre'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_descriptionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez décrire le problème'),
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
                'Signalement envoyé',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Nous avons bien reçu votre signalement. Notre équipe va l\'examiner et vous contacter si nécessaire.',
                style: TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              GlassButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close dialog
                  Navigator.of(context).pop(); // Go back
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
        title: const Text('Signaler un problème'),
      ),
      body: SingleChildScrollView(
        padding: GlassConstants.pagePadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Catégorie du problème',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: GlassConstants.titleColor(brightness),
              ),
            ),
            const SizedBox(height: 12),

            // Categories
            ...(_categories.map((category) {
              final isSelected = _selectedCategory == category['id'];
              return GlassCard(
                margin: const EdgeInsets.only(bottom: 8),
                onTap: () {
                  setState(() => _selectedCategory = category['id']);
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
                        category['icon'],
                        color: isSelected
                            ? GlassConstants.accent
                            : GlassConstants.mutedColor(brightness),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        category['name'],
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w500,
                          color: isSelected
                              ? GlassConstants.titleColor(brightness)
                              : GlassConstants.bodyColor(brightness),
                        ),
                      ),
                    ),
                    Radio<String>(
                      value: category['id'],
                      groupValue: _selectedCategory,
                      onChanged: (value) {
                        setState(() => _selectedCategory = value);
                      },
                      activeColor: GlassConstants.accent,
                    ),
                  ],
                ),
              );
            }).toList()),

            const SizedBox(height: 24),

            // Title
            Text(
              'Titre',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: GlassConstants.titleColor(brightness),
              ),
            ),
            const SizedBox(height: 12),
            GlassCard(
              padding: EdgeInsets.zero,
              child: TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: 'Résumé du problème',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(GlassConstants.radiusM),
                  ),
                  filled: true,
                  fillColor: GlassConstants.adaptiveSurfaceColor(brightness),
                  contentPadding: const EdgeInsets.all(16),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Description
            Text(
              'Description',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: GlassConstants.titleColor(brightness),
              ),
            ),
            const SizedBox(height: 12),
            GlassCard(
              padding: EdgeInsets.zero,
              child: TextField(
                controller: _descriptionController,
                maxLines: 6,
                maxLength: 500,
                decoration: InputDecoration(
                  hintText: 'Décrivez le problème en détail...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(GlassConstants.radiusM),
                  ),
                  filled: true,
                  fillColor: GlassConstants.adaptiveSurfaceColor(brightness),
                  contentPadding: const EdgeInsets.all(16),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Submit Button
            GlassButton(
              onPressed: _isSubmitting ? null : _submitReport,
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
                  : const Text('Envoyer le signalement'),
            ),
          ],
        ),
      ),
    );
  }
}
