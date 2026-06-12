# GAZLINK - Application Mobile Flutter

Application mobile complète pour la livraison de gaz domestique (bouteilles 6kg et 12.5kg) au Cameroun.

## 🎯 Fonctionnalités

### Interface Client
- ✅ Catalogue des dépôts disponibles
- ✅ Flux de commande complet (quantités → récapitulatif → paiement → confirmation)
- ✅ Calcul automatique du prix avec subvention (300 FCFA par bouteille)
- ✅ Historique des commandes
- ✅ Suivi en temps réel du statut de la commande
- ✅ Paiement Mobile Money (MTN MoMo, Orange Money)

### Interface Livreur
- ✅ Dashboard avec statistiques du jour
- ✅ Liste des livraisons assignées
- ✅ Suivi de la progression (Assignée → En livraison → Livrée)
- ✅ Détails de livraison avec adresse et client
- ✅ Actions de mise à jour du statut
- ✅ Signalement de problèmes
- ✅ Notes de livraison
- ✅ Gestion de la disponibilité
- ✅ Suivi des revenus et bonus

## 🎨 Design

- **Palette neutre et bleue** : Bleu primaire #1D4ED8 avec tons neutres
- **Système de thème complet** : Mode clair, sombre, système
- **Optimisé pour Android entrée de gamme** : Performance légère, interfaces épurées
- **Design professionnel** : Interfaces claires et intuitives

## 🚀 Installation

### Prérequis
- Flutter 3.0+
- Dart 3.0+
- Android SDK (pour Android)
- iOS SDK (pour iOS, optionnel)

### Étapes

1. **Cloner le projet**
   ```bash
   cd gazlink_app
   ```

2. **Installer les dépendances**
   ```bash
   flutter pub get
   ```

3. **Lancer l'application**
   ```bash
   flutter run
   ```

## 📦 Structure du Projet

```
lib/
├── main.dart                          # Point d'entrée
├── theme/
│   └── app_theme.dart                 # Thèmes clair/sombre
├── models/
│   └── models.dart                    # Modèles de données
├── providers/
│   ├── auth_provider.dart             # Authentification
│   ├── theme_provider.dart            # Gestion du thème
│   ├── order_provider.dart            # Gestion des commandes
│   └── delivery_provider.dart         # Gestion des livraisons
├── data/
│   └── mock_data.dart                 # Données mockées
└── screens/
    ├── shared/
    │   └── login_screen.dart          # Écran de connexion
    ├── client/
    │   ├── client_home_screen.dart    # Accueil client
    │   └── order_flow_screen.dart     # Flux de commande
    └── deliverer/
        ├── deliverer_home_screen.dart # Accueil livreur
        └── delivery_detail_screen.dart # Détails de livraison
```

## 🔐 Authentification

### Identifiants de test

**Client**
- Rôle: Client
- Téléphone: N'importe quel numéro
- Mot de passe: N'importe quel mot de passe

**Livreur**
- Rôle: Livreur
- Téléphone: N'importe quel numéro
- Mot de passe: N'importe quel mot de passe

## 📊 Données Mockées

L'application utilise des données mockées pour les tests :
- 3 dépôts disponibles
- 2 commandes d'exemple
- 2 livraisons d'exemple
- Utilisateurs de test

## 🎯 Prochaines Étapes

1. **Intégration Backend** : Connecter à l'API GAZLINK
2. **Authentification JWT** : Remplacer l'authentification mockée
3. **WebSocket** : Suivi GPS en temps réel
4. **Notifications Push** : FCM pour les alertes
5. **Paiements Monetbil** : Intégration des paiements réels
6. **Tests** : Tests unitaires et d'intégration

## 📱 Compatibilité

- **Android** : 5.0+ (API 21+)
- **iOS** : 11.0+
- **Écrans** : Optimisé pour tous les formats (petit, moyen, grand)

## 🛠️ Dépendances Principales

- **provider** : Gestion d'état
- **shared_preferences** : Stockage local
- **http** : Requêtes HTTP
- **intl** : Internationalisation
- **form_builder_flutter** : Formulaires

## 📝 Licence

Propriétaire - GAZLINK

## 👥 Support

Pour toute question ou problème, contactez l'équipe GAZLINK.
