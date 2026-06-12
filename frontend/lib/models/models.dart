// User Models
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

  User({
    required this.id,
    required this.phone,
    required this.name,
    required this.email,
    required this.role,
    this.profileImage,
    this.rating = 0,
    this.totalOrders = 0,
  });
}

// Depot Model
class Depot {
  final String id;
  final String name;
  final String address;
  final String phone;
  final double latitude;
  final double longitude;
  final int stock6kg;
  final int stock12kg;
  final double rating;
  final int reviewCount;
  final double distance;
  final int price6kg;
  final int price12kg;
  final bool isVerified;
  final bool isOpen;

  Depot({
    required this.id,
    required this.name,
    required this.address,
    required this.phone,
    required this.latitude,
    required this.longitude,
    required this.stock6kg,
    required this.stock12kg,
    this.rating = 4.5,
    this.reviewCount = 0,
    this.distance = 0,
    this.price6kg = 3500,
    this.price12kg = 6500,
    this.isVerified = true,
    this.isOpen = true,
  });

  int getTotalStock() => stock6kg + stock12kg;
  int get reviews => reviewCount;
}

// Order Models
enum OrderStatus {
  pending,
  confirmed,
  assigned,
  in_delivery,
  delivered,
  cancelled
}

class Order {
  final String id;
  final String clientId;
  final String depotId;
  final int quantity6kg;
  final int quantity12kg;
  final double totalPrice;
  final double discount;
  final double finalPrice;
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
    required this.totalPrice,
    required this.discount,
    required this.finalPrice,
    required this.status,
    required this.paymentMethod,
    required this.createdAt,
    this.deliveredAt,
    this.deliveryAddress,
    this.deliveryNotes,
    this.delivererId,
  });

  int getTotalQuantity() => quantity6kg + quantity12kg;

  String get depotName {
    switch (depotId) {
      case 'DEP-001':
        return 'GAZLINK Bonapriso';
      case 'DEP-002':
        return 'GAZLINK Akwa';
      case 'DEP-003':
        return 'GAZLINK Bali';
      default:
        return depotId;
    }
  }

  String? get eta {
    switch (status) {
      case OrderStatus.confirmed:
        return '45 min';
      case OrderStatus.in_delivery:
        return '30 min';
      default:
        return null;
    }
  }
}

// Delivery Models
class Delivery {
  final String id;
  final String orderId;
  final String delivererId;
  final String clientName;
  final String clientPhone;
  final String deliveryAddress;
  final OrderStatus status;
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
    required this.assignedAt,
    this.startedAt,
    this.deliveredAt,
    this.currentLatitude,
    this.currentLongitude,
    this.notes,
  });
}

// Payment Models
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

// Review Model
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
