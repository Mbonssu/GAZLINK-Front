import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../theme/glass/glass_components.dart';
import '../../theme/glass/glass_constants.dart';

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({Key? key}) : super(key: key);

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  String? _selectedRole;

  @override
  Widget build(BuildContext context) {
    return GlassScaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 40),
              
              // Logo
              GlassCard(
                radius: 28,
                padding: const EdgeInsets.all(20),
                child: const Icon(
                  Icons.local_fire_department_rounded,
                  color: Colors.white,
                  size: 56,
                ),
              ),
              const SizedBox(height: 24),
              
              // Title
              Text(
                'Bienvenue sur GAZLINK',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: GlassConstants.titleColor(Theme.of(context).brightness),
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              
              // Subtitle
              Text(
                'Choisissez votre profil pour continuer',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: GlassConstants.mutedColor(Theme.of(context).brightness),
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              
              // Role cards
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildRoleCard(
                      context,
                      role: 'client',
                      icon: Icons.shopping_bag_outlined,
                      title: 'Client',
                      description: 'Commander du gaz domestique',
                      color: GlassConstants.accent,
                    ),
                    const SizedBox(height: 16),
                    _buildRoleCard(
                      context,
                      role: 'deliverer',
                      icon: Icons.local_shipping_outlined,
                      title: 'Livreur',
                      description: 'Effectuer des livraisons',
                      color: Colors.orange,
                    ),
                  ],
                ),
              ),
              
              // Continue button
              SizedBox(
                width: double.infinity,
                child: GlassButton(
                  onPressed: _selectedRole != null ? _handleContinue : null,
                  child: const Text('Continuer'),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCard(
    BuildContext context, {
    required String role,
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    final isSelected = _selectedRole == role;
    
    return GestureDetector(
      onTap: () => setState(() => _selectedRole = role),
      child: AnimatedContainer(
        duration: GlassConstants.motionFast,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected
              ? color.withValues(alpha: 0.15)
              : GlassConstants.surfaceColor(Theme.of(context).brightness),
          borderRadius: BorderRadius.circular(GlassConstants.radiusL),
          border: Border.all(
            color: isSelected ? color : GlassConstants.borderColor(Theme.of(context).brightness),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                icon,
                size: 32,
                color: color,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: isSelected ? color : null,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: GlassConstants.mutedColor(Theme.of(context).brightness),
                        ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: color,
                size: 28,
              ),
          ],
        ),
      ),
    );
  }

  void _handleContinue() {
    if (_selectedRole == null) return;

    // Navigate to appropriate home screen
    if (_selectedRole == 'client') {
      Navigator.of(context).pushReplacementNamed('/client-home');
    } else {
      Navigator.of(context).pushReplacementNamed('/deliverer-home');
    }
  }
}
