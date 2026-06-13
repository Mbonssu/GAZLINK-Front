import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/models.dart';
import '../../providers/depot_provider.dart';
import '../../theme/app_theme.dart';
import '../../theme/glass/glass_components.dart';
import '../../theme/glass/glass_constants.dart';

class DepotDeliverersTab extends StatelessWidget {
  const DepotDeliverersTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    return Consumer<DepotProvider>(
      builder: (context, depotProv, _) {
        final deliverers = depotProv.deliverers;
        final active = deliverers.where((d) => d.isActive).toList();
        final inactive = deliverers.where((d) => !d.isActive).toList();

        return Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            scrolledUnderElevation: 0,
            title: Text(
              'Livreurs',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: GlassConstants.titleColor(brightness),
                    fontWeight: FontWeight.w800,
                  ),
            ),
            actions: [
              TextButton.icon(
                onPressed: () =>
                    _showAddDelivererSheet(context, depotProv),
                icon: const Icon(Icons.person_add_rounded),
                label: const Text('Ajouter'),
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
            children: [
              // Stats rapides
              _DelivererStats(active: active.length, total: deliverers.length),
              const SizedBox(height: 20),

              // Livreurs actifs
              _SectionHeader(
                title: 'Actifs (${active.length})',
                brightness: brightness,
              ),
              const SizedBox(height: 10),
              if (active.isEmpty)
                _EmptyState(
                  icon: Icons.person_off_outlined,
                  message: 'Aucun livreur actif\nAjoutez-en un avec le bouton ci-dessus',
                )
              else
                ...active
                    .map((d) => _DelivererCard(
                          deliverer: d,
                          depotProv: depotProv,
                          isActive: true,
                        ))
                    .toList(),

              // Livreurs désactivés
              if (inactive.isNotEmpty) ...[
                const SizedBox(height: 20),
                _SectionHeader(
                  title: 'Désactivés (${inactive.length})',
                  brightness: brightness,
                ),
                const SizedBox(height: 10),
                ...inactive
                    .map((d) => _DelivererCard(
                          deliverer: d,
                          depotProv: depotProv,
                          isActive: false,
                        ))
                    .toList(),
              ],
            ],
          ),
        );
      },
    );
  }

  void _showAddDelivererSheet(BuildContext context, DepotProvider depotProv) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _AddDelivererSheet(depotProv: depotProv),
    );
  }
}

// ─────────────────────────────────────────────
// STATS
// ─────────────────────────────────────────────
class _DelivererStats extends StatelessWidget {
  final int active;
  final int total;
  const _DelivererStats({required this.active, required this.total});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GlassCard(
            padding: const EdgeInsets.all(14),
            child: Column(
              children: [
                Text(
                  '$active',
                  style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: Colors.green),
                ),
                Text(
                  'Actifs',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: GlassConstants.mutedColor(
                            Theme.of(context).brightness),
                      ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: GlassCard(
            padding: const EdgeInsets.all(14),
            child: Column(
              children: [
                Text(
                  '$total',
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.primaryBlue),
                ),
                Text(
                  'Total',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: GlassConstants.mutedColor(
                            Theme.of(context).brightness),
                      ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// CARTE LIVREUR
// ─────────────────────────────────────────────
class _DelivererCard extends StatelessWidget {
  final User deliverer;
  final DepotProvider depotProv;
  final bool isActive;

  const _DelivererCard({
    required this.deliverer,
    required this.depotProv,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    return GlassCard(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          // Avatar avec initiales
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isActive
                  ? AppTheme.primaryBlue.withValues(alpha: 0.12)
                  : Colors.grey.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                deliverer.name.substring(0, 1).toUpperCase(),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: isActive ? AppTheme.primaryBlue : Colors.grey,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Infos
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      deliverer.name,
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: isActive
                                  ? null
                                  : GlassConstants.mutedColor(brightness)),
                    ),
                    const SizedBox(width: 6),
                    // Badge statut
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: isActive
                            ? Colors.green.withValues(alpha: 0.1)
                            : Colors.red.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        isActive ? 'Actif' : 'Désactivé',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: isActive ? Colors.green : Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  deliverer.phone,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: GlassConstants.mutedColor(brightness),
                      ),
                ),
                const SizedBox(height: 4),
                // ID livreur + stats
                Row(
                  children: [
                    Icon(Icons.badge_outlined,
                        size: 12,
                        color: GlassConstants.mutedColor(brightness)),
                    const SizedBox(width: 3),
                    Text(
                      deliverer.id,
                      style: TextStyle(
                        fontSize: 10,
                        color: GlassConstants.mutedColor(brightness),
                        fontFamily: 'monospace',
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Icon(Icons.star_rounded,
                        size: 12, color: Colors.amber),
                    const SizedBox(width: 3),
                    Text(
                      '${deliverer.rating}  ·  ${deliverer.totalOrders} liv.',
                      style: TextStyle(
                          fontSize: 10,
                          color: GlassConstants.mutedColor(brightness)),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Menu actions
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert_rounded,
                color: GlassConstants.mutedColor(brightness)),
            onSelected: (val) => _handleAction(context, val),
            itemBuilder: (_) => [
              if (isActive) ...[
                const PopupMenuItem(
                  value: 'copy_id',
                  child: Row(
                    children: [
                      Icon(Icons.copy_rounded, size: 18),
                      SizedBox(width: 8),
                      Text('Copier l\'identifiant'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'deactivate',
                  child: Row(
                    children: [
                      Icon(Icons.person_off_rounded,
                          size: 18, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Désactiver',
                          style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ] else
                const PopupMenuItem(
                  value: 'reactivate',
                  child: Row(
                    children: [
                      Icon(Icons.person_rounded,
                          size: 18, color: Colors.green),
                      SizedBox(width: 8),
                      Text('Réactiver',
                          style: TextStyle(color: Colors.green)),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  void _handleAction(BuildContext context, String action) {
    switch (action) {
      case 'copy_id':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Identifiant copié : ${deliverer.id}')),
        );
        break;
      case 'deactivate':
        _showDeactivateDialog(context);
        break;
      case 'reactivate':
        depotProv.reactivateDeliverer(deliverer.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${deliverer.name} réactivé')),
        );
        break;
    }
  }

  void _showDeactivateDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Désactiver ce livreur ?'),
        content: Text(
          '${deliverer.name} ne pourra plus accéder à l\'application. '
          'Son historique est conservé. Vous pourrez le réactiver à tout moment.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              depotProv.deactivateDeliverer(deliverer.id);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      '${deliverer.name} désactivé — accès coupé'),
                ),
              );
            },
            child: const Text('Désactiver',
                style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// SHEET AJOUT LIVREUR
// ─────────────────────────────────────────────
class _AddDelivererSheet extends StatefulWidget {
  final DepotProvider depotProv;
  const _AddDelivererSheet({required this.depotProv});

  @override
  State<_AddDelivererSheet> createState() => _AddDelivererSheetState();
}

class _AddDelivererSheetState extends State<_AddDelivererSheet> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        left: 16,
        right: 16,
      ),
      child: GlassCard(
        radius: GlassConstants.radiusL,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Text(
                  'Ajouter un livreur',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 6, 16, 2),
                child: Text(
                  'Un identifiant unique sera généré automatiquement',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: GlassConstants.mutedColor(brightness),
                      ),
                ),
              ),
              const Divider(height: 20),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Column(
                  children: [
                    // Nom
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Nom complet',
                        hintText: 'Ex: Patrick Mbarga',
                        prefixIcon: const Icon(Icons.person_outline_rounded),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      validator: (v) =>
                          (v == null || v.trim().isEmpty)
                              ? 'Le nom est requis'
                              : null,
                    ),
                    const SizedBox(height: 14),

                    // Téléphone
                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: 'Numéro de téléphone',
                        hintText: '+237 6 XX XX XX XX',
                        prefixIcon:
                            const Icon(Icons.phone_outlined),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      validator: (v) =>
                          (v == null || v.trim().length < 9)
                              ? 'Numéro invalide'
                              : null,
                    ),
                    const SizedBox(height: 20),

                    // Info box
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryBlue.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: AppTheme.primaryBlue.withValues(alpha: 0.2)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.info_outline_rounded,
                              size: 16, color: AppTheme.primaryBlue),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'L\'identifiant généré sera communiqué au livreur pour se connecter à l\'application.',
                              style:
                                  Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: AppTheme.primaryBlue,
                                      ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Bouton
                    SizedBox(
                      width: double.infinity,
                      child: GlassButton(
                        onPressed: _loading ? null : _submit,
                        child: _loading
                            ? const SizedBox(
                                height: 18,
                                width: 18,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2, color: Colors.white),
                              )
                            : const Text(
                                'Créer le compte livreur',
                                style:
                                    TextStyle(fontWeight: FontWeight.w700),
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
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    await widget.depotProv.addDeliverer(
      name: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
    );

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Compte créé pour ${_nameController.text.trim()} — identifiant généré'),
        ),
      );
    }
  }
}

// ─────────────────────────────────────────────
// HELPERS
// ─────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  final String title;
  final Brightness brightness;
  const _SectionHeader({required this.title, required this.brightness});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: GlassConstants.mutedColor(brightness),
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String message;
  const _EmptyState({required this.icon, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          children: [
            Icon(icon,
                size: 48,
                color: GlassConstants.mutedColor(
                    Theme.of(context).brightness)),
            const SizedBox(height: 10),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: GlassConstants.mutedColor(
                        Theme.of(context).brightness),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
