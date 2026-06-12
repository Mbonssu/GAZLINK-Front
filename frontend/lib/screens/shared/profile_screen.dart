import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../theme/glass/glass_components.dart';
import '../../theme/glass/glass_constants.dart';
import '../../routes.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.user;

    if (user == null) {
      return const GlassScaffold(
        body: Center(child: Text('Utilisateur non connecté')),
      );
    }

    return GlassScaffold(
      appBar: GlassAppBar(
        title: const Text('Mon Profil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => Navigator.of(context).pushNamed(AppRoutes.editProfile),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Profile header
            GlassCard(
              radius: 28,
              child: Column(
                children: [
                  // Avatar
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: GlassConstants.accent.withValues(alpha: 0.2),
                    ),
                    child: Icon(
                      Icons.person,
                      size: 50,
                      color: GlassConstants.accent,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    user.name,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.email,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: GlassConstants.mutedColor(Theme.of(context).brightness),
                        ),
                  ),
                  const SizedBox(height: 16),
                  // Stats
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStat(
                        context,
                        icon: Icons.shopping_bag_outlined,
                        label: 'Commandes',
                        value: user.totalOrders.toString(),
                      ),
                      Container(
                        width: 1,
                        height: 40,
                        color: GlassConstants.borderColor(Theme.of(context).brightness),
                      ),
                      _buildStat(
                        context,
                        icon: Icons.star_outline,
                        label: 'Note',
                        value: user.rating.toStringAsFixed(1),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // Account section
            _buildSectionTitle(context, 'Compte'),
            const SizedBox(height: 12),
            _buildMenuItem(
              context,
              icon: Icons.person_outline,
              title: 'Informations personnelles',
              onTap: () => Navigator.of(context).pushNamed(AppRoutes.editProfile),
            ),
            _buildMenuItem(
              context,
              icon: Icons.lock_outline,
              title: 'Changer le mot de passe',
              onTap: () => Navigator.of(context).pushNamed(AppRoutes.changePassword),
            ),
            _buildMenuItem(
              context,
              icon: Icons.location_on_outlined,
              title: 'Adresses sauvegardées',
              onTap: () => Navigator.of(context).pushNamed(AppRoutes.savedAddresses),
            ),
            const SizedBox(height: 24),
            
            // Preferences section
            _buildSectionTitle(context, 'Préférences'),
            const SizedBox(height: 12),
            _buildMenuItem(
              context,
              icon: Icons.notifications_outlined,
              title: 'Notifications',
              onTap: () => Navigator.of(context).pushNamed(AppRoutes.notificationSettings),
            ),
            _buildMenuItem(
              context,
              icon: Icons.language_outlined,
              title: 'Langue',
              subtitle: 'Français',
              onTap: () => Navigator.of(context).pushNamed(AppRoutes.language),
            ),
            _buildMenuItem(
              context,
              icon: Icons.dark_mode_outlined,
              title: 'Thème',
              subtitle: 'Système',
              onTap: () => Navigator.of(context).pushNamed(AppRoutes.themeSettings),
            ),
            const SizedBox(height: 24),
            
            // Support section
            _buildSectionTitle(context, 'Support'),
            const SizedBox(height: 12),
            _buildMenuItem(
              context,
              icon: Icons.help_outline,
              title: 'Centre d\'aide',
              onTap: () => Navigator.of(context).pushNamed(AppRoutes.faq),
            ),
            _buildMenuItem(
              context,
              icon: Icons.chat_outlined,
              title: 'Contacter le support',
              onTap: () => Navigator.of(context).pushNamed(AppRoutes.chatSupport),
            ),
            _buildMenuItem(
              context,
              icon: Icons.info_outline,
              title: 'À propos',
              onTap: () => Navigator.of(context).pushNamed(AppRoutes.about),
            ),
            const SizedBox(height: 24),
            
            // Logout button
            SizedBox(
              width: double.infinity,
              child: GlassButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => GlassDialog(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.logout,
                            size: 48,
                            color: Colors.red.withValues(alpha: 0.8),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Déconnexion',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Êtes-vous sûr de vouloir vous déconnecter ?',
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
                                    context.read<AuthProvider>().logout();
                                    Navigator.of(context).pushNamedAndRemoveUntil(
                                      AppRoutes.login,
                                      (route) => false,
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                  ),
                                  child: const Text('Déconnexion'),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.logout, size: 20),
                    SizedBox(width: 8),
                    Text('Se déconnecter'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          size: 24,
          color: GlassConstants.accent,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: GlassConstants.mutedColor(Theme.of(context).brightness),
              ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: GlassConstants.mutedColor(Theme.of(context).brightness),
            ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return GlassCard(
      margin: const EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.zero,
      onTap: onTap,
      child: ListTile(
        leading: Icon(icon, color: GlassConstants.accent),
        title: Text(title),
        subtitle: subtitle != null ? Text(subtitle) : null,
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}
