// ─────────────────────────────────────────────
// USER MODELS
// ─────────────────────────────────────────────
enum UserRole { client, deliverer, depot_manager, admin }

class User {
  final String id;
  final String phone;
  final String name;
  final String email;
  final UserRole role;
  final String? profileImage;
  final double rating;
  final int totalOrders;
  // Soft-delete
  final bool isActive;
  final DateTime? deactivatedAt;
  // Pour le livreur : dépôt auquel il est assigné
  final String? depotId;

  User({
    required this.id,
    required this.phone,
    required this.name,
    required this.email,
    required this.role,
    this.profileImage,
    this.rating = 0,
    this.totalOrders = 0,
    this.isActive = true,
    this.deactivatedAt,
    this.depotId,
  });

  User copyWith({bool? isActive, DateTime? deactivatedAt}) {
    return User(
      id: id,
      phone: phone,
      name: name,
      email: email,
      role: role,
      profileImage: profileImage,
      rating: rating,
      totalOrders: totalOrders,
      isActive: isActive ?? this.isActive,
      deactivatedAt: deactivatedAt ?? this.deactivatedAt,
      depotId: depotId,
    );
  }
}

// ─────────────────────────────────────────────
// BOTTLE TYPE MODEL
// ─────────────────────────────────────────────
class BottleType {
  final String id;
  final String label;        // ex: "6 kg", "12.5 kg", "24 kg"
  final double weightKg;
  final int basePrice;       // Prix dépôt (ex: 3500)
  final int subsidyAmount;   // Subvention par bouteille (300 FCFA)
  final bool isActive;

  const BottleType({
    required this.id,
    required this.label,
    required this.weightKg,
    required this.basePrice,
    this.subsidyAmount = 300,
    this.isActive = true,
  });

  // Prix payé par le client après subvention
  int get clientPrice => basePrice - subsidyAmount;
}

// ─────────────────────────────────────────────
// STOCK ENTRY MODEL (mouvements de stock)
// ─────────────────────────────────────────────
enum StockMovementType { supply, sold, returned_empty, exchanged }

class StockEntry {
  final String id;
  final String depotId;
  final String bottleTypeId;
  final StockMovementType type;
  final int quantity;
  final String? note;
  final DateTime createdAt;

  StockEntry({
    required this.id,
    required this.depotId,
    required this.bottleTypeId,
    required this.type,
    required this.quantity,
    this.note,
    required this.createdAt,
  });
}

// ─────────────────────────────────────────────
// DEPOT MODEL
// ─────────────────────────────────────────────
class Depot {
  final String id;
  final String name;
  final String address;
  final String phone;
  final double latitude;
  final double longitude;
  // Stock par type (plein / vide / échange)
  final int stock6kg;
  final int stock12kg;
  final int stock24kg;
  final int emptyBottles6kg;
  final int emptyBottles12kg;
  final int emptyBottles24kg;
  final int exchangeBottles6kg;
  final int exchangeBottles12kg;
  final int exchangeBottles24kg;
  // Seuil d'alerte stock bas
  final int stockAlertThreshold;
  // Prix
  final int price6kg;
  final int price12kg;
  final int price24kg;
  // Horaires
  final String openTime;   // ex: "07:00"
  final String closeTime;  // ex: "20:00"
  // Métadonnées
  final double rating;
  final int reviewCount;
  final double distance;
  final bool isVerified;
  final bool isOpen;

  const Depot({
    required this.id,
    required this.name,
    required this.address,
    required this.phone,
    required this.latitude,
    required this.longitude,
    this.stock6kg = 0,
    this.stock12kg = 0,
    this.stock24kg = 0,
    this.emptyBottles6kg = 0,
    this.emptyBottles12kg = 0,
    this.emptyBottles24kg = 0,
    this.exchangeBottles6kg = 0,
    this.exchangeBottles12kg = 0,
    this.exchangeBottles24kg = 0,
    this.stockAlertThreshold = 10,
    this.price6kg = 3500,
    this.price12kg = 6500,
    this.price24kg = 12000,
    this.openTime = '07:00',
    this.closeTime = '20:00',
    this.rating = 4.5,
    this.reviewCount = 0,
    this.distance = 0,
    this.isVerified = true,
    this.isOpen = true,
  });

  int get totalFullBottles => stock6kg + stock12kg + stock24kg;
  int get totalEmptyBottles => emptyBottles6kg + emptyBottles12kg + emptyBottles24kg;
  int get reviews => reviewCount;

  bool get hasLowStock =>
      stock6kg <= stockAlertThreshold ||
      stock12kg <= stockAlertThreshold ||
      stock24kg <= stockAlertThreshold;

  // Vérifie si le dépôt est ouvert selon l'heure actuelle
  bool get isCurrentlyOpen {
    final now = DateTime.now();
    final parts = openTime.split(':');
    final closeParts = closeTime.split(':');
    final open = DateTime(now.year, now.month, now.day,
        int.parse(parts[0]), int.parse(parts[1]));
    final close = DateTime(now.year, now.month, now.day,
        int.parse(closeParts[0]), int.parse(closeParts[1]));
    return now.isAfter(open) && now.isBefore(close);
  }
}

// ─────────────────────────────────────────────
// ORDER MODELS
// ─────────────────────────────────────────────
enum OrderStatus {
  pending,
  confirmed,
  assigned,
  in_delivery,
  delivered,
  cancelled
}

enum DeliveryPriority { normal, express, urgent }

extension DeliveryPriorityExt on DeliveryPriority {
  String get label {
    switch (this) {
      case DeliveryPriority.normal:  return 'Normal';
      case DeliveryPriority.express: return 'Express';
      case DeliveryPriority.urgent:  return 'Urgent';
    }
  }

  int get extraFee {
    switch (this) {
      case DeliveryPriority.normal:  return 0;
      case DeliveryPriority.express: return 500;
      case DeliveryPriority.urgent:  return 1000;
    }
  }

  String get description {
    switch (this) {
      case DeliveryPriority.normal:  return 'Livraison standard (~45 min)';
      case DeliveryPriority.express: return 'Livraison rapide (~25 min)';
      case DeliveryPriority.urgent:  return 'Livraison immédiate (~10 min)';
    }
  }
}

class Order {
  final String id;
  final String clientId;
  final String depotId;
  final int quantity6kg;
  final int quantity12kg;
  final int quantity24kg;
  final double totalPrice;       // Prix avant subvention
  final double subsidyAmount;    // Total subvention (300 × nb bouteilles)
  final double discount;         // Alias subsidyAmount pour compatibilité
  final double finalPrice;       // Prix après subvention (payé par client)
  final int deliveryFee;         // Frais de livraison (selon priorité)
  final DeliveryPriority priority;
  final OrderStatus status;
  final String paymentMethod;
  final DateTime createdAt;
  final DateTime? deliveredAt;
  final String? deliveryAddress;
  final String? deliveryNotes;
  final String? delivererId;

  Order({
    required this.id,
    required this.clientId,
    required this.depotId,
    required this.quantity6kg,
    required this.quantity12kg,
    this.quantity24kg = 0,
    required this.totalPrice,
    required this.subsidyAmount,
    required this.discount,
    required this.finalPrice,
    this.deliveryFee = 0,
    this.priority = DeliveryPriority.normal,
    required this.status,
    required this.paymentMethod,
    required this.createdAt,
    this.deliveredAt,
    this.deliveryAddress,
    this.deliveryNotes,
    this.delivererId,
  });

  int getTotalQuantity() => quantity6kg + quantity12kg + quantity24kg;

  // Montant total payé par le client (articles + livraison)
  double get amountDueByClient => finalPrice + deliveryFee;

  // Montant reçu par le dépôt (prix plein, sans subvention)
  double get amountReceivedByDepot => totalPrice + deliveryFee;

  String get depotName {
    switch (depotId) {
      case 'DEP-001': return 'GAZLINK Bonapriso';
      case 'DEP-002': return 'GAZLINK Akwa';
      case 'DEP-003': return 'GAZLINK Bali';
      default: return depotId;
    }
  }

  String? get eta {
    switch (status) {
      case OrderStatus.confirmed:   return priority == DeliveryPriority.urgent ? '10 min' : '45 min';
      case OrderStatus.in_delivery: return priority == DeliveryPriority.urgent ? '5 min' : '30 min';
      default: return null;
    }
  }
}

// ─────────────────────────────────────────────
// DELIVERY MODELS
// ─────────────────────────────────────────────
class Delivery {
  final String id;
  final String orderId;
  final String delivererId;
  final String clientName;
  final String clientPhone;
  final String deliveryAddress;
  final OrderStatus status;
  final DeliveryPriority priority;
  final int deliveryFee;
  final DateTime assignedAt;
  final DateTime? startedAt;
  final DateTime? deliveredAt;
  final double? currentLatitude;
  final double? currentLongitude;
  final String? notes;

  Delivery({
    required this.id,
    required this.orderId,
    required this.delivererId,
    required this.clientName,
    required this.clientPhone,
    required this.deliveryAddress,
    required this.status,
    this.priority = DeliveryPriority.normal,
    this.deliveryFee = 0,
    required this.assignedAt,
    this.startedAt,
    this.deliveredAt,
    this.currentLatitude,
    this.currentLongitude,
    this.notes,
  });
}

// ─────────────────────────────────────────────
// PAYMENT MODELS
// ─────────────────────────────────────────────
enum PaymentMethod { mtn_momo, orange_money, cash }

class Payment {
  final String id;
  final String orderId;
  final double amount;
  final PaymentMethod method;
  final String status;
  final DateTime createdAt;
  final String? transactionId;

  Payment({
    required this.id,
    required this.orderId,
    required this.amount,
    required this.method,
    required this.status,
    required this.createdAt,
    this.transactionId,
  });
}

// ─────────────────────────────────────────────
// REVIEW MODEL
// ─────────────────────────────────────────────
class Review {
  final String id;
  final String depotId;
  final String clientId;
  final double rating;
  final String comment;
  final DateTime createdAt;

  Review({
    required this.id,
    required this.depotId,
    required this.clientId,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });
}
