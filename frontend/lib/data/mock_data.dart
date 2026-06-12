import '../models/models.dart';

// Mock Depots
final mockDepots = [
  Depot(
    id: 'DEP-001',
    name: 'GAZLINK Bonapriso',
    address: 'Rue Manga, Bonapriso, Douala',
    phone: '+237 6 12 34 56 78',
    latitude: 4.0511,
    longitude: 9.7679,
    stock6kg: 45,
    stock12kg: 32,
    rating: 4.6,
    reviewCount: 128,
  ),
  Depot(
    id: 'DEP-002',
    name: 'GAZLINK Akwa',
    address: 'Avenue Général de Gaulle, Akwa, Douala',
    phone: '+237 6 98 76 54 32',
    latitude: 4.0447,
    longitude: 9.7679,
    stock6kg: 38,
    stock12kg: 28,
    rating: 4.4,
    reviewCount: 95,
  ),
  Depot(
    id: 'DEP-003',
    name: 'GAZLINK Bali',
    address: 'Rue Nkongamba, Bali, Douala',
    phone: '+237 6 55 44 33 22',
    latitude: 4.0575,
    longitude: 9.7679,
    stock6kg: 52,
    stock12kg: 41,
    rating: 4.7,
    reviewCount: 156,
  ),
];

// Mock Orders
final mockOrders = [
  Order(
    id: 'CMD-001',
    clientId: 'USR-001',
    depotId: 'DEP-001',
    quantity6kg: 1,
    quantity12kg: 1,
    totalPrice: 13000,
    discount: 600,
    finalPrice: 12400,
    status: OrderStatus.delivered,
    paymentMethod: 'MTN MoMo',
    createdAt: DateTime.now().subtract(Duration(days: 2)),
    deliveredAt: DateTime.now().subtract(Duration(days: 2, hours: 1)),
  ),
  Order(
    id: 'CMD-002',
    clientId: 'USR-001',
    depotId: 'DEP-002',
    quantity6kg: 2,
    quantity12kg: 0,
    totalPrice: 7000,
    discount: 600,
    finalPrice: 6400,
    status: OrderStatus.in_delivery,
    paymentMethod: 'Orange Money',
    createdAt: DateTime.now().subtract(Duration(hours: 2)),
  ),
];

// Mock Deliveries
final mockDeliveries = [
  Delivery(
    id: 'DLV-001',
    orderId: 'CMD-002',
    delivererId: 'DLV-USER-001',
    clientName: 'Awa TRAORÉ',
    clientPhone: '+225 05 46 78 90 12',
    deliveryAddress: 'Rue de la Paix, Akwa, Douala',
    status: OrderStatus.in_delivery,
    assignedAt: DateTime.now().subtract(Duration(minutes: 15)),
    startedAt: DateTime.now().subtract(Duration(minutes: 10)),
    currentLatitude: 4.0447,
    currentLongitude: 9.7679,
  ),
  Delivery(
    id: 'DLV-002',
    orderId: 'CMD-003',
    delivererId: 'DLV-USER-001',
    clientName: 'Josh KIMMICH',
    clientPhone: '+237 6 90 35 12 78',
    deliveryAddress: 'Boulevard de la Liberté, Bonapriso, Douala',
    status: OrderStatus.assigned,
    assignedAt: DateTime.now().subtract(Duration(minutes: 5)),
  ),
];

// Mock User
final mockUser = User(
  id: 'USR-001',
  phone: '+237 6 90 35 12 78',
  name: 'Josh Kimmich',
  email: 'josh.kimmich@gazlink.cm',
  role: UserRole.client,
  rating: 4.8,
  totalOrders: 12,
);

final mockDeliveryUser = User(
  id: 'DLV-USER-001',
  phone: '+225 07 89 01 23 45',
  name: 'Yannick Koffi',
  email: 'yannick@gazlink.cm',
  role: UserRole.deliverer,
  rating: 4.9,
  totalOrders: 156,
);

class MockData {
  static List<Depot> getMockDepots() => List<Depot>.from(mockDepots);
  static List<Order> getMockOrders() => List<Order>.from(mockOrders);
  static List<Delivery> getMockDeliveries() =>
      List<Delivery>.from(mockDeliveries);
}
