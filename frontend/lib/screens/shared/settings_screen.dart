import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/theme_provider.dart';
import '../../theme/glass/glass_components.dart';
import '../../theme/glass/glass_constants.dart';
import '../../routes.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    
    return GlassScaffold(
      appBar: GlassAppBar(
        title: const Text('Paramètres'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Account section
            _buildSectionTitle(context, 'Compte'),
            const SizedBox(height: 12),
            _buildMenuItem(
              context,
              icon: Icons.person_outline,
              title: 'Mon profil',
              subtitle: 'Gérer vos informations personnelles',
              onTap: () => Navigator.of(context).pushNamed(AppRoutes.profile),
            ),
            _buildMenuItem(
              context,
              icon: Icons.lock_outline,
              title: 'Sécurité',
              subtitle: 'Mot de passe et authentification',
              onTap: () => Navigator.of(context).pushNamed(AppRoutes.changePassword),
            ),
            _buildMenuItem(
              context,
              icon: Icons.location_on_outlined,
              title: 'Adresses',
              subtitle: 'Gérer vos adresses de livraison',
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
              subtitle: 'Gérer vos notifications',
              onTap: () => Navigator.of(context).pushNamed(AppRoutes.notificationSettings),
            ),
            _buildMenuItem(
              context,
              icon: Icons.language_outlined,
              title: 'Langue',
              subtitle: 'Français',
              onTap: () => Navigator.of(context).pushNamed(AppRoutes.language),
            ),
            GlassCard(
              margin: const EdgeInsets.only(bottom: 8),
              padding: EdgeInsets.zero,
              child: ListTile(
                leading: Icon(Icons.dark_mode_outlined, color: GlassConstants.accent),
                title: const Text('Thème'),
                subtitle: Text(_getThemeLabel(themeProvider.themeMode)),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.of(context).pushNamed(AppRoutes.themeSettings),
              ),
            ),
            const SizedBox(height: 24),
            
            // Payment section
            _buildSectionTitle(context, 'Paiement'),
            const SizedBox(height: 12),
            _buildMenuItem(
              context,
              icon: Icons.payment_outlined,
              title: 'Moyens de paiement',
              subtitle: 'Gérer vos méthodes de paiement',
              onTap: () => Navigator.of(context).pushNamed(AppRoutes.paymentMethod),
            ),
            _buildMenuItem(
              context,
              icon: Icons.history_outlined,
              title: 'Historique des paiements',
              subtitle: 'Consulter vos transactions',
              onTap: () => Navigator.of(context).pushNamed(AppRoutes.paymentHistory),
            ),
            const SizedBox(height: 24),
            
            // Support section
            _buildSectionTitle(context, 'Aide & Support'),
            const SizedBox(height: 12),
            _buildMenuItem(
              context,
              icon: Icons.help_outline,
              title: 'Centre d\'aide',
              subtitle: 'FAQ et guides',
              onTap: () => Navigator.of(context).pushNamed(AppRoutes.faq),
            ),
            _buildMenuItem(
              context,
              icon: Icons.chat_outlined,
              title: 'Contacter le support',
              subtitle: 'Besoin d\'aide ?',
              onTap: () => Navigator.of(context).pushNamed(AppRoutes.chatSupport),
            ),
            _buildMenuItem(
              context,
              icon: Icons.bug_report_outlined,
              title: 'Signaler un problème',
              subtitle: 'Rapporter un bug',
              onTap: () => Navigator.of(context).pushNamed(AppRoutes.reportIssue),
            ),
            const SizedBox(height: 24),
            
            // Legal section
            _buildSectionTitle(context, 'Légal'),
            const SizedBox(height: 12),
            _buildMenuItem(
              context,
              icon: Icons.description_outlined,
              title: 'Conditions d\'utilisation',
              onTap: () => Navigator.of(context).pushNamed(AppRoutes.terms),
            ),
            _buildMenuItem(
              context,
              icon: Icons.privacy_tip_outlined,
              title: 'Politique de confidentialité',
              onTap: () => Navigator.of(context).pushNamed(AppRoutes.privacyPolicy),
            ),
            _buildMenuItem(
              context,
              icon: Icons.info_outline,
              title: 'À propos',
              subtitle: 'Version 1.0.0',
              onTap: () => Navigator.of(context).pushNamed(AppRoutes.about),
            ),
            const SizedBox(height: 32),
            
            // Logout button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _showLogoutDialog(context),
                icon: const Icon(Icons.logout, color: Colors.red),
                label: const Text(
                  'Se déconnecter',
                  style: TextStyle(color: Colors.red),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.red),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  String _getThemeLabel(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'Clair';
      case ThemeMode.dark:
        return 'Sombre';
      case ThemeMode.system:
        return 'Système';
    }
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

  void _showLogoutDialog(BuildContext context) {
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
  }
}
