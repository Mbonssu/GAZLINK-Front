import 'package:flutter/material.dart';
import '../../theme/glass/glass_components.dart';
import '../../theme/glass/glass_constants.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    return GlassScaffold(
      appBar: GlassAppBar(
        title: const Text('Politique de confidentialité'),
      ),
      body: SingleChildScrollView(
        padding: GlassConstants.pagePadding,
        child: GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Politique de confidentialité',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: GlassConstants.titleColor(brightness),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Dernière mise à jour: 13 Mai 2026',
                style: TextStyle(
                  fontSize: 13,
                  color: GlassConstants.mutedColor(brightness),
                ),
              ),
              const SizedBox(height: 24),
              _buildSection(
                '1. Collecte des informations',
                'Nous collectons les informations que vous nous fournissez directement, telles que votre nom, numéro de téléphone, adresse email, et adresse de livraison. Nous collectons également des informations sur votre utilisation de l\'application.',
                brightness,
              ),
              _buildSection(
                '2. Utilisation des informations',
                'Nous utilisons vos informations pour: traiter vos commandes, communiquer avec vous, améliorer nos services, et vous envoyer des notifications importantes.',
                brightness,
              ),
              _buildSection(
                '3. Partage des informations',
                'Nous partageons vos informations avec les dépôts de gaz et les livreurs uniquement dans le cadre de l\'exécution de vos commandes. Nous ne vendons pas vos informations personnelles à des tiers.',
                brightness,
              ),
              _buildSection(
                '4. Sécurité des données',
                'Nous mettons en œuvre des mesures de sécurité appropriées pour protéger vos informations personnelles contre l\'accès non autorisé, la modification, la divulgation ou la destruction.',
                brightness,
              ),
              _buildSection(
                '5. Cookies et technologies similaires',
                'Nous utilisons des cookies et des technologies similaires pour améliorer votre expérience, analyser l\'utilisation de l\'application et personnaliser le contenu.',
                brightness,
              ),
              _buildSection(
                '6. Vos droits',
                'Vous avez le droit d\'accéder, de corriger ou de supprimer vos informations personnelles. Vous pouvez également vous opposer au traitement de vos données ou demander leur portabilité.',
                brightness,
              ),
              _buildSection(
                '7. Conservation des données',
                'Nous conservons vos informations personnelles aussi longtemps que nécessaire pour fournir nos services et respecter nos obligations légales.',
                brightness,
              ),
              _buildSection(
                '8. Modifications de la politique',
                'Nous pouvons modifier cette politique de confidentialité à tout moment. Nous vous informerons de tout changement important par notification dans l\'application.',
                brightness,
              ),
              _buildSection(
                '9. Contact',
                'Pour toute question concernant cette politique de confidentialité, veuillez nous contacter à privacy@gazlink.cm',
                brightness,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content, Brightness brightness) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: GlassConstants.titleColor(brightness),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(
              fontSize: 14,
              height: 1.6,
              color: GlassConstants.bodyColor(brightness),
            ),
          ),
        ],
      ),
    );
  }
}
