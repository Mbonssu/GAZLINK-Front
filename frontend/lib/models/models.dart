// =============================================================
// GAZLINK — Models
// Alignés avec le schéma Supabase (migration 20240001000000)
// =============================================================

// ─────────────────────────────────────────────
// USER / PROFIL
// ─────────────────────────────────────────────
enum UserRole { client, livreur, admin_global, gerant_depot }

extension UserRoleExt on UserRole {
  // Correspond aux valeurs CHECK de la colonne `role` en base
  String get dbValue {
    switch (this) {
      case UserRole.client:       return 'client';
      case UserRole.livreur:      return 'livreur';
      case UserRole.admin_global: return 'admin_global';
      case UserRole.gerant_depot: return 'gerant_depot';
    }
  }

  static UserRole fromDb(String value) {
    switch (value) {
      case 'client':       return UserRole.client;
      case 'livreur':      return UserRole.livreur;
      case 'admin_global': return UserRole.admin_global;
      case 'gerant_depot': return UserRole.gerant_depot;
      default:             return UserRole.client;
    }
  }

  String get label {
    switch (this) {
      case UserRole.client:       return 'Client';
      case UserRole.livreur:      return 'Livreur';
      case UserRole.admin_global: return 'Administrateur';
      case UserRole.gerant_depot: return 'Gérant de dépôt';
    }
  }
}

class UserModel {
  final String id;
  final String email;
  final String nom;
  final String telephone;
  final UserRole role;
  final String? depotId;       // renseigné pour gerant_depot et livreur
  final bool estActif;
  final DateTime? deletedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserModel({
    required this.id,
    required this.email,
    required this.nom,
    required this.telephone,
    required this.role,
    this.depotId,
    this.estActif = true,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id:         json['id'] as String,
      email:      json['email'] as String,
      nom:        json['nom'] as String,
      telephone:  json['telephone'] as String,
      role:       UserRoleExt.fromDb(json['role'] as String),
      depotId:    json['depot_id'] as String?,
      estActif:   json['est_actif'] as bool? ?? true,
      deletedAt:  json['deleted_at'] != null
                    ? DateTime.parse(json['deleted_at'] as String)
                    : null,
      createdAt:  DateTime.parse(json['created_at'] as String),
      updatedAt:  DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'id':         id,
    'email':      email,
    'nom':        nom,
    'telephone':  telephone,
    'role':       role.dbValue,
    'depot_id':   depotId,
    'est_actif':  estActif,
  };

  UserModel copyWith({
    String? nom,
    String? telephone,
    String? depotId,
    bool? estActif,
    DateTime? deletedAt,
  }) {
    return UserModel(
      id:         id,
      email:      email,
      nom:        nom ?? this.nom,
      telephone:  telephone ?? this.telephone,
      role:       role,
      depotId:    depotId ?? this.depotId,
      estActif:   estActif ?? this.estActif,
      deletedAt:  deletedAt ?? this.deletedAt,
      createdAt:  createdAt,
      updatedAt:  DateTime.now(),
    );
  }

  // Raccourcis utiles
  bool get isClient      => role == UserRole.client;
  bool get isLivreur     => role == UserRole.livreur;
  bool get isGerant      => role == UserRole.gerant_depot;
  bool get isAdmin       => role == UserRole.admin_global;
}

// ─────────────────────────────────────────────
// DEPOT
// ─────────────────────────────────────────────
class DepotModel {
  final String id;
  final String nom;
  final String adresse;
  final String telephone;
  final double? latitude;
  final double? longitude;
  final String heureOuverture;   // ex: "08:00:00"
  final String heureFermeture;   // ex: "18:00:00"
  final bool estActif;
  final DateTime createdAt;

  const DepotModel({
    required this.id,
    required this.nom,
    required this.adresse,
    required this.telephone,
    this.latitude,
    this.longitude,
    required this.heureOuverture,
    required this.heureFermeture,
    this.estActif = true,
    required this.createdAt,
  });

  factory DepotModel.fromJson(Map<String, dynamic> json) {
    return DepotModel(
      id:              json['id'] as String,
      nom:             json['nom'] as String,
      adresse:         json['adresse'] as String,
      telephone:       json['telephone'] as String,
      latitude:        json['latitude'] != null
                         ? double.tryParse(json['latitude'].toString())
                         : null,
      longitude:       json['longitude'] != null
                         ? double.tryParse(json['longitude'].toString())
                         : null,
      heureOuverture:  json['heure_ouverture'] as String,
      heureFermeture:  json['heure_fermeture'] as String,
      estActif:        json['est_actif'] as bool? ?? true,
      createdAt:       DateTime.parse(json['created_at'] as String),
    );
  }

  bool get estOuvert {
    final now = DateTime.now();
    final ouv   = _parseTime(heureOuverture);
    final ferm  = _parseTime(heureFermeture);
    final nowT  = TimeOfDay(hour: now.hour, minute: now.minute);
    return estActif && _timeToMinutes(nowT) >= _timeToMinutes(ouv)
        && _timeToMinutes(nowT) <= _timeToMinutes(ferm);
  }

  TimeOfDay _parseTime(String t) {
    final parts = t.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  int _timeToMinutes(TimeOfDay t) => t.hour * 60 + t.minute;

  String get horaires => '${heureOuverture.substring(0, 5)} – ${heureFermeture.substring(0, 5)}';
}

// ─────────────────────────────────────────────
// TYPE DE BOUTEILLE
// ─────────────────────────────────────────────
class TypeBouteilleModel {
  final String id;
  final String depotId;
  final String nom;
  final int poidsKg;
  final int prixVente;          // Prix réel dépôt
  final int prixSubventionne;   // Prix payé par le client (calculé par trigger)
  final bool estActif;
  final DateTime createdAt;

  const TypeBouteilleModel({
    required this.id,
    required this.depotId,
    required this.nom,
    required this.poidsKg,
    required this.prixVente,
    required this.prixSubventionne,
    this.estActif = true,
    required this.createdAt,
  });

  factory TypeBouteilleModel.fromJson(Map<String, dynamic> json) {
    return TypeBouteilleModel(
      id:               json['id'] as String,
      depotId:          json['depot_id'] as String,
      nom:              json['nom'] as String,
      poidsKg:          json['poids_kg'] as int,
      prixVente:        json['prix_vente'] as int,
      prixSubventionne: json['prix_subventionne'] as int,
      estActif:         json['est_actif'] as bool? ?? true,
      createdAt:        DateTime.parse(json['created_at'] as String),
    );
  }

  // Subvention = ce que GazLink absorbe par bouteille
  int get subvention => prixVente - prixSubventionne;
}

// ─────────────────────────────────────────────
// STOCK
// ─────────────────────────────────────────────
class StockModel {
  final String id;
  final String depotId;
  final String typeBouteilleId;
  final int quantitePleine;
  final int quantiteVide;
  final int seuilAlerte;
  final DateTime lastUpdated;

  const StockModel({
    required this.id,
    required this.depotId,
    required this.typeBouteilleId,
    required this.quantitePleine,
    required this.quantiteVide,
    required this.seuilAlerte,
    required this.lastUpdated,
  });

  factory StockModel.fromJson(Map<String, dynamic> json) {
    return StockModel(
      id:               json['id'] as String,
      depotId:          json['depot_id'] as String,
      typeBouteilleId:  json['type_bouteille_id'] as String,
      quantitePleine:   json['quantite_pleine'] as int? ?? 0,
      quantiteVide:     json['quantite_vide'] as int? ?? 0,
      seuilAlerte:      json['seuil_alerte'] as int? ?? 5,
      lastUpdated:      DateTime.parse(json['last_updated'] as String),
    );
  }

  bool get estBas => quantitePleine <= seuilAlerte;
}

// ─────────────────────────────────────────────
// ADRESSE CLIENT
// ─────────────────────────────────────────────
class AdresseModel {
  final String id;
  final String clientId;
  final String libelle;
  final String adresse;
  final double? latitude;
  final double? longitude;
  final bool estPrincipale;
  final bool estActive;
  final DateTime createdAt;

  const AdresseModel({
    required this.id,
    required this.clientId,
    required this.libelle,
    required this.adresse,
    this.latitude,
    this.longitude,
    this.estPrincipale = false,
    this.estActive = true,
    required this.createdAt,
  });

  factory AdresseModel.fromJson(Map<String, dynamic> json) {
    return AdresseModel(
      id:            json['id'] as String,
      clientId:      json['client_id'] as String,
      libelle:       json['libelle'] as String? ?? 'Domicile',
      adresse:       json['adresse'] as String,
      latitude:      json['latitude'] != null
                       ? double.tryParse(json['latitude'].toString())
                       : null,
      longitude:     json['longitude'] != null
                       ? double.tryParse(json['longitude'].toString())
                       : null,
      estPrincipale: json['est_principale'] as bool? ?? false,
      estActive:     json['est_active'] as bool? ?? true,
      createdAt:     DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'client_id':      clientId,
    'libelle':        libelle,
    'adresse':        adresse,
    'latitude':       latitude,
    'longitude':      longitude,
    'est_principale': estPrincipale,
    'est_active':     estActive,
  };

  bool get hasCoordinates => latitude != null && longitude != null;
}

// ─────────────────────────────────────────────
// COMMANDE
// ─────────────────────────────────────────────
enum StatutCommande {
  en_attente,
  confirmee,
  preparee,
  en_livraison,
  livree,
  annulee,
}

extension StatutCommandeExt on StatutCommande {
  String get dbValue {
    switch (this) {
      case StatutCommande.en_attente:   return 'en_attente';
      case StatutCommande.confirmee:    return 'confirmee';
      case StatutCommande.preparee:     return 'preparee';
      case StatutCommande.en_livraison: return 'en_livraison';
      case StatutCommande.livree:       return 'livree';
      case StatutCommande.annulee:      return 'annulee';
    }
  }

  static StatutCommande fromDb(String v) {
    switch (v) {
      case 'confirmee':    return StatutCommande.confirmee;
      case 'preparee':     return StatutCommande.preparee;
      case 'en_livraison': return StatutCommande.en_livraison;
      case 'livree':       return StatutCommande.livree;
      case 'annulee':      return StatutCommande.annulee;
      default:             return StatutCommande.en_attente;
    }
  }

  String get label {
    switch (this) {
      case StatutCommande.en_attente:   return 'En attente';
      case StatutCommande.confirmee:    return 'Confirmée';
      case StatutCommande.preparee:     return 'Préparée';
      case StatutCommande.en_livraison: return 'En livraison';
      case StatutCommande.livree:       return 'Livrée';
      case StatutCommande.annulee:      return 'Annulée';
    }
  }
}

enum Priorite { normal, urgent, express }

extension PrioriteExt on Priorite {
  String get dbValue {
    switch (this) {
      case Priorite.normal:  return 'normal';
      case Priorite.urgent:  return 'urgent';
      case Priorite.express: return 'express';
    }
  }

  static Priorite fromDb(String v) {
    switch (v) {
      case 'urgent':  return Priorite.urgent;
      case 'express': return Priorite.express;
      default:        return Priorite.normal;
    }
  }

  String get label {
    switch (this) {
      case Priorite.normal:  return 'Normal';
      case Priorite.urgent:  return 'Urgent';
      case Priorite.express: return 'Express';
    }
  }

  String get description {
    switch (this) {
      case Priorite.normal:  return 'Livraison standard (~45 min)';
      case Priorite.urgent:  return 'Livraison rapide (~25 min)';
      case Priorite.express: return 'Livraison immédiate (~10 min)';
    }
  }
}

class CommandeModel {
  final String id;
  final String clientId;
  final String adresseLivraisonId;
  final String typeBouteilleId;
  final String depotId;
  final int quantite;

  // Prix snapshot au moment de la commande
  final int prixUnitaire;          // prix dépôt
  final int prixUnitaireClient;    // prix après subvention
  final int montantTotalDepot;     // ce que reçoit le dépôt
  final int montantTotalClient;    // ce que paie le client (hors livraison)
  final int subventionAppliquee;   // ce que GazLink absorbe
  final String? campagneId;

  // Livraison
  final double? distanceKm;
  final int fraisLivraison;
  final int montantAPayerClient;   // montantTotalClient + fraisLivraison

  final StatutCommande statut;
  final Priorite priorite;
  final bool estEchange;
  final int? noteClient;
  final String? commentaire;

  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? livreeLe;

  const CommandeModel({
    required this.id,
    required this.clientId,
    required this.adresseLivraisonId,
    required this.typeBouteilleId,
    required this.depotId,
    required this.quantite,
    required this.prixUnitaire,
    required this.prixUnitaireClient,
    required this.montantTotalDepot,
    required this.montantTotalClient,
    required this.subventionAppliquee,
    this.campagneId,
    this.distanceKm,
    required this.fraisLivraison,
    required this.montantAPayerClient,
    required this.statut,
    required this.priorite,
    this.estEchange = false,
    this.noteClient,
    this.commentaire,
    required this.createdAt,
    required this.updatedAt,
    this.livreeLe,
  });

  factory CommandeModel.fromJson(Map<String, dynamic> json) {
    return CommandeModel(
      id:                   json['id'] as String,
      clientId:             json['client_id'] as String,
      adresseLivraisonId:   json['adresse_livraison_id'] as String,
      typeBouteilleId:      json['type_bouteille_id'] as String,
      depotId:              json['depot_id'] as String,
      quantite:             json['quantite'] as int,
      prixUnitaire:         json['prix_unitaire'] as int,
      prixUnitaireClient:   json['prix_unitaire_client'] as int,
      montantTotalDepot:    json['montant_total_depot'] as int,
      montantTotalClient:   json['montant_total_client'] as int,
      subventionAppliquee:  json['subvention_appliquee'] as int? ?? 0,
      campagneId:           json['campagne_id'] as String?,
      distanceKm:           json['distance_km'] != null
                              ? double.tryParse(json['distance_km'].toString())
                              : null,
      fraisLivraison:       json['frais_livraison'] as int? ?? 0,
      montantAPayerClient:  json['montant_a_payer_client'] as int,
      statut:               StatutCommandeExt.fromDb(json['statut'] as String),
      priorite:             PrioriteExt.fromDb(json['priorite'] as String),
      estEchange:           json['est_echange'] as bool? ?? false,
      noteClient:           json['note_client'] as int?,
      commentaire:          json['commentaire'] as String?,
      createdAt:            DateTime.parse(json['created_at'] as String),
      updatedAt:            DateTime.parse(json['updated_at'] as String),
      livreeLe:             json['livree_le'] != null
                              ? DateTime.parse(json['livree_le'] as String)
                              : null,
    );
  }

  Map<String, dynamic> toInsertJson() => {
    'client_id':             clientId,
    'adresse_livraison_id':  adresseLivraisonId,
    'type_bouteille_id':     typeBouteilleId,
    'depot_id':              depotId,
    'quantite':              quantite,
    // Les montants sont calculés par le trigger Supabase
    // On envoie juste ce qui est nécessaire avant le trigger
    'prix_unitaire':         0,
    'prix_unitaire_client':  0,
    'montant_total_depot':   0,
    'montant_total_client':  0,
    'montant_a_payer_client': 0,
    'frais_livraison':       fraisLivraison,
    'distance_km':           distanceKm,
    'priorite':              priorite.dbValue,
    'est_echange':           estEchange,
  };
}

// ─────────────────────────────────────────────
// LIVRAISON
// ─────────────────────────────────────────────
enum StatutLivraison {
  assigne,
  pris_en_charge,
  en_route,
  arrive_site,
  livree,
  retour_entrepot,
}

extension StatutLivraisonExt on StatutLivraison {
  String get dbValue {
    switch (this) {
      case StatutLivraison.assigne:          return 'assigne';
      case StatutLivraison.pris_en_charge:   return 'pris_en_charge';
      case StatutLivraison.en_route:         return 'en_route';
      case StatutLivraison.arrive_site:      return 'arrive_site';
      case StatutLivraison.livree:           return 'livree';
      case StatutLivraison.retour_entrepot:  return 'retour_entrepot';
    }
  }

  static StatutLivraison fromDb(String v) {
    switch (v) {
      case 'pris_en_charge':  return StatutLivraison.pris_en_charge;
      case 'en_route':        return StatutLivraison.en_route;
      case 'arrive_site':     return StatutLivraison.arrive_site;
      case 'livree':          return StatutLivraison.livree;
      case 'retour_entrepot': return StatutLivraison.retour_entrepot;
      default:                return StatutLivraison.assigne;
    }
  }

  String get label {
    switch (this) {
      case StatutLivraison.assigne:          return 'Assignée';
      case StatutLivraison.pris_en_charge:   return 'Prise en charge';
      case StatutLivraison.en_route:         return 'En route';
      case StatutLivraison.arrive_site:      return 'Arrivé sur site';
      case StatutLivraison.livree:           return 'Livrée';
      case StatutLivraison.retour_entrepot:  return 'Retour entrepôt';
    }
  }
}

class LivraisonModel {
  final String id;
  final String commandeId;
  final String livreurId;
  final StatutLivraison statutLivraison;
  final double? positionLatitude;
  final double? positionLongitude;
  final DateTime? positionUpdatedAt;
  final double? distanceParcourue;
  final int? dureeEstimee;        // minutes restantes
  final DateTime? heureDepart;
  final DateTime? heureArrivee;
  final DateTime createdAt;

  const LivraisonModel({
    required this.id,
    required this.commandeId,
    required this.livreurId,
    required this.statutLivraison,
    this.positionLatitude,
    this.positionLongitude,
    this.positionUpdatedAt,
    this.distanceParcourue,
    this.dureeEstimee,
    this.heureDepart,
    this.heureArrivee,
    required this.createdAt,
  });

  factory LivraisonModel.fromJson(Map<String, dynamic> json) {
    return LivraisonModel(
      id:                 json['id'] as String,
      commandeId:         json['commande_id'] as String,
      livreurId:          json['livreur_id'] as String,
      statutLivraison:    StatutLivraisonExt.fromDb(json['statut_livraison'] as String),
      positionLatitude:   json['position_latitude'] != null
                            ? double.tryParse(json['position_latitude'].toString())
                            : null,
      positionLongitude:  json['position_longitude'] != null
                            ? double.tryParse(json['position_longitude'].toString())
                            : null,
      positionUpdatedAt:  json['position_updated_at'] != null
                            ? DateTime.parse(json['position_updated_at'] as String)
                            : null,
      distanceParcourue:  json['distance_parcourue'] != null
                            ? double.tryParse(json['distance_parcourue'].toString())
                            : null,
      dureeEstimee:       json['duree_estimee'] as int?,
      heureDepart:        json['heure_depart'] != null
                            ? DateTime.parse(json['heure_depart'] as String)
                            : null,
      heureArrivee:       json['heure_arrivee'] != null
                            ? DateTime.parse(json['heure_arrivee'] as String)
                            : null,
      createdAt:          DateTime.parse(json['created_at'] as String),
    );
  }

  bool get hasPosition => positionLatitude != null && positionLongitude != null;
}

// ─────────────────────────────────────────────
// PAIEMENT
// ─────────────────────────────────────────────
enum MoyenPaiement { orange_money, mtn_money, especes }

extension MoyenPaiementExt on MoyenPaiement {
  String get dbValue {
    switch (this) {
      case MoyenPaiement.orange_money: return 'orange_money';
      case MoyenPaiement.mtn_money:    return 'mtn_money';
      case MoyenPaiement.especes:      return 'especes';
    }
  }

  static MoyenPaiement fromDb(String v) {
    switch (v) {
      case 'orange_money': return MoyenPaiement.orange_money;
      case 'mtn_money':    return MoyenPaiement.mtn_money;
      default:             return MoyenPaiement.especes;
    }
  }

  String get label {
    switch (this) {
      case MoyenPaiement.orange_money: return 'Orange Money';
      case MoyenPaiement.mtn_money:    return 'MTN MoMo';
      case MoyenPaiement.especes:      return 'Espèces';
    }
  }
}

class PaiementModel {
  final String id;
  final String commandeId;
  final String clientId;
  final MoyenPaiement moyenPaiement;
  final String telephoneTransaction;
  final String? referenceTransaction;
  final int montant;
  final String statut;
  final DateTime? paidAt;
  final DateTime createdAt;

  const PaiementModel({
    required this.id,
    required this.commandeId,
    required this.clientId,
    required this.moyenPaiement,
    required this.telephoneTransaction,
    this.referenceTransaction,
    required this.montant,
    required this.statut,
    this.paidAt,
    required this.createdAt,
  });

  factory PaiementModel.fromJson(Map<String, dynamic> json) {
    return PaiementModel(
      id:                     json['id'] as String,
      commandeId:             json['commande_id'] as String,
      clientId:               json['client_id'] as String,
      moyenPaiement:          MoyenPaiementExt.fromDb(json['moyen_paiement'] as String),
      telephoneTransaction:   json['telephone_transaction'] as String,
      referenceTransaction:   json['reference_transaction'] as String?,
      montant:                json['montant'] as int,
      statut:                 json['statut'] as String,
      paidAt:                 json['paid_at'] != null
                                ? DateTime.parse(json['paid_at'] as String)
                                : null,
      createdAt:              DateTime.parse(json['created_at'] as String),
    );
  }

  bool get estConfirme => statut == 'confirme';
}

// ─────────────────────────────────────────────
// CAMPAGNE SUBVENTION
// ─────────────────────────────────────────────
class CampagneSubventionModel {
  final String id;
  final int montantSubvention;
  final DateTime dateDebut;
  final DateTime dateFin;
  final bool estActive;
  final DateTime createdAt;

  const CampagneSubventionModel({
    required this.id,
    required this.montantSubvention,
    required this.dateDebut,
    required this.dateFin,
    required this.estActive,
    required this.createdAt,
  });

  factory CampagneSubventionModel.fromJson(Map<String, dynamic> json) {
    return CampagneSubventionModel(
      id:                 json['id'] as String,
      montantSubvention:  json['montant_subvention'] as int,
      dateDebut:          DateTime.parse(json['date_debut'] as String),
      dateFin:            DateTime.parse(json['date_fin'] as String),
      estActive:          json['est_active'] as bool? ?? false,
      createdAt:          DateTime.parse(json['created_at'] as String),
    );
  }

  bool get estEnCours {
    final now = DateTime.now();
    return estActive && now.isAfter(dateDebut) && now.isBefore(dateFin);
  }

  int get joursRestants => dateFin.difference(DateTime.now()).inDays;
}

// ─────────────────────────────────────────────
// ALERTE STOCK
// ─────────────────────────────────────────────
class AlerteStockModel {
  final String id;
  final String depotId;
  final String typeBouteilleId;
  final int? niveauActuel;
  final int? seuilAlerte;
  final bool estResolue;
  final DateTime createdAt;
  final DateTime? resolueL;

  const AlerteStockModel({
    required this.id,
    required this.depotId,
    required this.typeBouteilleId,
    this.niveauActuel,
    this.seuilAlerte,
    required this.estResolue,
    required this.createdAt,
    this.resolueL,
  });

  factory AlerteStockModel.fromJson(Map<String, dynamic> json) {
    return AlerteStockModel(
      id:               json['id'] as String,
      depotId:          json['depot_id'] as String,
      typeBouteilleId:  json['type_bouteille_id'] as String,
      niveauActuel:     json['niveau_actuel'] as int?,
      seuilAlerte:      json['seuil_alerte'] as int?,
      estResolue:       json['est_resolue'] as bool? ?? false,
      createdAt:        DateTime.parse(json['created_at'] as String),
      resolueL:         json['resolue_le'] != null
                          ? DateTime.parse(json['resolue_le'] as String)
                          : null,
    );
  }
}