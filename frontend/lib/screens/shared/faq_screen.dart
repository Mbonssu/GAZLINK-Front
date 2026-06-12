import 'package:flutter/material.dart';
import '../../theme/glass/glass_components.dart';
import '../../theme/glass/glass_constants.dart';
import '../../routes.dart';

class FaqScreen extends StatefulWidget {
  const FaqScreen({super.key});

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  String _selectedCategory = 'Tous';
  final List<String> _categories = [
    'Tous',
    'Commandes',
    'Livraison',
    'Paiement',
    'Compte',
  ];

  final List<Map<String, dynamic>> _faqs = [
    {
      'category': 'Commandes',
      'question': 'Comment passer une commande ?',
      'answer':
          'Pour passer une commande, sélectionnez un dépôt, choisissez vos bouteilles de gaz, ajoutez votre adresse de livraison et procédez au paiement.',
    },
    {
      'category': 'Commandes',
      'question': 'Puis-je annuler ma commande ?',
      'answer':
          'Oui, vous pouvez annuler votre commande gratuitement tant qu\'elle n\'est pas en cours de livraison.',
    },
    {
      'category': 'Livraison',
      'question': 'Quel est le délai de livraison ?',
      'answer':
          'Le délai de livraison est généralement de 30 à 60 minutes selon votre localisation et la disponibilité des livreurs.',
    },
    {
      'category': 'Livraison',
      'question': 'Comment suivre ma livraison ?',
      'answer':
          'Vous pouvez suivre votre livraison en temps réel sur la carte dans l\'écran de suivi de commande.',
    },
    {
      'category': 'Paiement',
      'question': 'Quels modes de paiement acceptez-vous ?',
      'answer':
          'Nous acceptons MTN Mobile Money, Orange Money et le paiement en espèces à la livraison.',
    },
    {
      'category': 'Paiement',
      'question': 'Mon paiement est-il sécurisé ?',
      'answer':
          'Oui, tous les paiements sont sécurisés et cryptés. Nous ne stockons pas vos informations de paiement.',
    },
    {
      'category': 'Compte',
      'question': 'Comment créer un compte ?',
      'answer':
          'Téléchargez l\'application, cliquez sur "S\'inscrire" et suivez les instructions pour créer votre compte.',
    },
    {
      'category': 'Compte',
      'question': 'J\'ai oublié mon mot de passe',
      'answer':
          'Cliquez sur "Mot de passe oublié" sur l\'écran de connexion et suivez les instructions pour réinitialiser votre mot de passe.',
    },
  ];

  List<Map<String, dynamic>> get _filteredFaqs {
    if (_selectedCategory == 'Tous') return _faqs;
    return _faqs.where((faq) => faq['category'] == _selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    return GlassScaffold(
      appBar: GlassAppBar(
        title: const Text('FAQ'),
      ),
      body: Column(
        children: [
          // Category Filter
          SizedBox(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = category == _selectedCategory;

                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() => _selectedCategory = category);
                    },
                    backgroundColor:
                        GlassConstants.adaptiveSurfaceColor(brightness),
                    selectedColor:
                        GlassConstants.accent.withValues(alpha: 0.3),
                    labelStyle: TextStyle(
                      color: isSelected
                          ? GlassConstants.accent
                          : GlassConstants.bodyColor(brightness),
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                );
              },
            ),
          ),

          // FAQ List
          Expanded(
            child: ListView.builder(
              padding: GlassConstants.pagePadding,
              itemCount: _filteredFaqs.length,
              itemBuilder: (context, index) {
                final faq = _filteredFaqs[index];
                return _buildFaqCard(faq, brightness);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.chatSupport);
        },
        icon: Icon(Icons.chat),
        label: Text('Contacter le support'),
        backgroundColor: GlassConstants.accent,
      ),
    );
  }

  Widget _buildFaqCard(Map<String, dynamic> faq, Brightness brightness) {
    return GlassCard(
      margin: const EdgeInsets.only(bottom: 12),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: EdgeInsets.zero,
          childrenPadding: const EdgeInsets.only(top: 8),
          title: Text(
            faq['question'],
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: GlassConstants.titleColor(brightness),
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              faq['category'],
              style: TextStyle(
                fontSize: 12,
                color: GlassConstants.accent,
              ),
            ),
          ),
          children: [
            Text(
              faq['answer'],
              style: TextStyle(
                fontSize: 14,
                height: 1.5,
                color: GlassConstants.bodyColor(brightness),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
