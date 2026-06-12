import 'package:flutter/material.dart';
import '../../theme/glass/glass_components.dart';
import '../../theme/glass/glass_constants.dart';
import '../../routes.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    return GlassScaffold(
      appBar: GlassAppBar(
        title: const Text('À propos'),
      ),
      body: SingleChildScrollView(
        padding: GlassConstants.pagePadding,
        child: Column(
          children: [
            // App Logo
            GlassCard(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: GlassConstants.accent.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.propane_tank,
                      size: 64,
                      color: GlassConstants.accent,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'GAZLINK',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: GlassConstants.titleColor(brightness),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Version 1.0.0',
                    style: TextStyle(
                      fontSize: 14,
                      color: GlassConstants.mutedColor(brightness),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Description
            GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'À propos de GAZLINK',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: GlassConstants.titleColor(brightness),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'GAZLINK est votre solution de livraison de gaz domestique rapide et fiable au Cameroun. Commandez vos bouteilles de gaz en quelques clics et recevez-les directement chez vous.',
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.6,
                      color: GlassConstants.bodyColor(brightness),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Info Cards
            _buildInfoCard(
              'Développé par',
              'GAZLINK Team',
              Icons.code,
              brightness,
            ),
            _buildInfoCard(
              'Email',
              'contact@gazlink.cm',
              Icons.email,
              brightness,
            ),
            _buildInfoCard(
              'Téléphone',
              '+237 6 XX XX XX XX',
              Icons.phone,
              brightness,
            ),
            _buildInfoCard(
              'Site web',
              'www.gazlink.cm',
              Icons.language,
              brightness,
            ),
            const SizedBox(height: 16),

            // Links
            GlassCard(
              child: Column(
                children: [
                  _buildLinkTile(
                    'Conditions d\'utilisation',
                    () {
                      Navigator.pushNamed(context, AppRoutes.terms);
                    },
                    brightness,
                  ),
                  Divider(color: GlassConstants.borderColor(brightness)),
                  _buildLinkTile(
                    'Politique de confidentialité',
                    () {
                      Navigator.pushNamed(context, AppRoutes.privacyPolicy);
                    },
                    brightness,
                  ),
                  Divider(color: GlassConstants.borderColor(brightness)),
                  _buildLinkTile(
                    'Licences open source',
                    () {
                      showLicensePage(context: context);
                    },
                    brightness,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Copyright
            Text(
              '© 2026 GAZLINK. Tous droits réservés.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: GlassConstants.mutedColor(brightness),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(
    String label,
    String value,
    IconData icon,
    Brightness brightness,
  ) {
    return GlassCard(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: GlassConstants.accent.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: GlassConstants.accent,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: GlassConstants.mutedColor(brightness),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: GlassConstants.titleColor(brightness),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLinkTile(
    String title,
    VoidCallback onTap,
    Brightness brightness,
  ) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 15,
                color: GlassConstants.bodyColor(brightness),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: GlassConstants.mutedColor(brightness),
            ),
          ],
        ),
      ),
    );
  }
}
