import 'package:flutter/material.dart';
import '../../theme/glass/glass_components.dart';
import '../../theme/glass/glass_constants.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    return GlassScaffold(
      appBar: GlassAppBar(
        title: const Text('Conditions d\'utilisation'),
      ),
      body: SingleChildScrollView(
        padding: GlassConstants.pagePadding,
        child: GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Conditions d\'utilisation',
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
                '1. Acceptation des conditions',
                'En utilisant l\'application GAZLINK, vous acceptez d\'être lié par ces conditions d\'utilisation. Si vous n\'acceptez pas ces conditions, veuillez ne pas utiliser l\'application.',
                brightness,
              ),
              _buildSection(
                '2. Description du service',
                'GAZLINK est une plateforme de livraison de gaz domestique qui connecte les clients avec des dépôts de gaz et des livreurs. Nous facilitons la commande et la livraison de bouteilles de gaz.',
                brightness,
              ),
              _buildSection(
                '3. Inscription et compte',
                'Vous devez créer un compte pour utiliser nos services. Vous êtes responsable de maintenir la confidentialité de vos informations de compte et de toutes les activités qui se produisent sous votre compte.',
                brightness,
              ),
              _buildSection(
                '4. Commandes et paiements',
                'Toutes les commandes sont soumises à la disponibilité. Les prix sont indiqués en FCFA et incluent toutes les taxes applicables. Le paiement doit être effectué au moment de la commande.',
                brightness,
              ),
              _buildSection(
                '5. Livraison',
                'Nous nous efforçons de livrer dans les délais indiqués, mais les délais de livraison sont des estimations et peuvent varier. Vous devez être disponible à l\'adresse de livraison indiquée.',
                brightness,
              ),
              _buildSection(
                '6. Annulations et remboursements',
                'Vous pouvez annuler votre commande gratuitement avant qu\'elle ne soit en cours de livraison. Les remboursements sont traités dans un délai de 3-5 jours ouvrables.',
                brightness,
              ),
              _buildSection(
                '7. Responsabilité',
                'GAZLINK agit en tant qu\'intermédiaire entre les clients et les fournisseurs de gaz. Nous ne sommes pas responsables de la qualité des produits livrés.',
                brightness,
              ),
              _buildSection(
                '8. Modifications des conditions',
                'Nous nous réservons le droit de modifier ces conditions à tout moment. Les modifications entreront en vigueur dès leur publication dans l\'application.',
                brightness,
              ),
              _buildSection(
                '9. Contact',
                'Pour toute question concernant ces conditions, veuillez nous contacter à contact@gazlink.cm',
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
