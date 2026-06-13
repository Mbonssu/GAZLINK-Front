import '../models/models.dart';

// ─────────────────────────────────────────────
// BOTTLE TYPES
// ─────────────────────────────────────────────
final mockBottleTypes = [
  const BottleType(
    id: 'BT-001',
    label: '6 kg',
    weightKg: 6,
    basePrice: 3500,
    subsidyAmount: 300,
  ),
  const BottleType(
    id: 'BT-002',
    label: '12.5 kg',
    weightKg: 12.5,
    basePrice: 6500,
    subsidyAmount: 300,
  ),
  const BottleType(
    id: 'BT-003',
    label: '24 kg',
    weightKg: 24,
    basePrice: 12000,
    subsidyAmount: 300,
  ),
];

// ─────────────────────────────────────────────
// DEPOTS
// ─────────────────────────────────────────────
final mockDepots = [
  const Depot(
    id: 'DEP-001',
    name: 'GAZLINK Bonapriso',
    address: 'Rue Manga, Bonapriso, Douala',
    phone: '+237 6 12 34 56 78',
    latitude: 4.0511,
    longitude: 9.7679,
    stock6kg: 45,
    stock12kg: 32,
    stock24kg: 8,
    emptyBottles6kg: 12,
    emptyBottles12kg: 7,
    emptyBottles24kg: 2,
    exchangeBottles6kg: 5,
    exchangeBottles12kg: 3,
    exchangeBottles24kg: 1,
    stockAlertThreshold: 10,
    price6kg: 3500,
    price12kg: 6500,
    price24kg: 12000,
    openTime: '07:00',
    closeTime: '20:00',
    rating: 4.6,
    reviewCount: 128,
  ),
  const Depot(
    id: 'DEP-002',
    name: 'GAZLINK Akwa',
    address: 'Avenue Général de Gaulle, Akwa, Douala',
    phone: '+237 6 98 76 54 32',
    latitude: 4.0447,
    longitude: 9.7679,
    stock6kg: 8,   // stock bas — déclenche alerte
    stock12kg: 28,
    stock24kg: 5,
    emptyBottles6kg: 20,
    emptyBottles12kg: 10,
    emptyBottles24kg: 3,
    exchangeBottles6kg: 8,
    exchangeBottles12kg: 4,
    exchangeBottles24kg: 0,
    stockAlertThreshold: 10,
    price6kg: 3500,
    price12kg: 6500,
    price24kg: 12000,
    openTime: '06:30',
    closeTime: '21:00',
    rating: 4.4,
    reviewCount: 95,
  ),
  const Depot(
    id: 'DEP-003',
    name: 'GAZLINK Bali',
    address: 'Rue Nkongamba, Bali, Douala',
    phone: '+237 6 55 44 33 22',
    latitude: 4.0575,
    longitude: 9.7679,
    stock6kg: 52,
    stock12kg: 41,
    stock24kg: 15,
    emptyBottles6kg: 8,
    emptyBottles12kg: 5,
    emptyBottles24kg: 1,
    exchangeBottles6kg: 3,
    exchangeBottles12kg: 2,
    exchangeBottles24kg: 0,
    stockAlertThreshold: 10,
    price6kg: 3500,
    price12kg: 6500,
    price24kg: 12000,
    openTime: '07:00',
    closeTime: '19:30',
    rating: 4.7,
    reviewCount: 156,
  ),
];

// ─────────────────────────────────────────────
// ORDERS
// ─────────────────────────────────────────────
final mockOrders = [
  Order(
    id: 'CMD-001',
    clientId: 'USR-001',
    depotId: 'DEP-001',
    quantity6kg: 1,
    quantity12kg: 1,
    totalPrice: 10000,       // 3500 + 6500
    subsidyAmount: 600,      // 300 × 2 bouteilles
    discount: 600,
    finalPrice: 9400,        // 10000 - 600
    deliveryFee: 0,
    priority: DeliveryPriority.normal,
    status: OrderStatus.delivered,
    paymentMethod: 'MTN MoMo',
    createdAt: DateTime.now().subtract(const Duration(days: 2)),
    deliveredAt: DateTime.now().subtract(const Duration(days: 2, hours: 1)),
    deliveryAddress: 'Rue Manga, Bonapriso, Douala',
  ),
  Order(
    id: 'CMD-002',
    clientId: 'USR-001',
    depotId: 'DEP-002',
    quantity6kg: 2,
    quantity12kg: 0,
    totalPrice: 7000,        // 3500 × 2
    subsidyAmount: 600,      // 300 × 2
    discount: 600,
    finalPrice: 6400,
    deliveryFee: 500,
    priority: DeliveryPriority.express,
    status: OrderStatus.in_delivery,
    paymentMethod: 'Orange Money',
    createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    deliveryAddress: 'Rue de la Paix, Akwa, Douala',
  ),
  Order(
    id: 'CMD-003',
    clientId: 'USR-002',
    depotId: 'DEP-001',
    quantity6kg: 0,
    quantity12kg: 0,
    quantity24kg: 1,
    totalPrice: 12000,
    subsidyAmount: 300,
    discount: 300,
    finalPrice: 11700,
    deliveryFee: 1000,
    priority: DeliveryPriority.urgent,
    status: OrderStatus.confirmed,
    paymentMethod: 'MTN MoMo',
    createdAt: DateTime.now().subtract(const Duration(minutes: 20)),
    deliveryAddress: 'Boulevard de la Liberté, Bonapriso, Douala',
  ),
  Order(
    id: 'CMD-004',
    clientId: 'USR-003',
    depotId: 'DEP-001',
    quantity6kg: 1,
    quantity12kg: 0,
    totalPrice: 3500,
    subsidyAmount: 300,
    discount: 300,
    finalPrice: 3200,
    deliveryFee: 0,
    priority: DeliveryPriority.normal,
    status: OrderStatus.pending,
    paymentMethod: 'Orange Money',
    createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
    deliveryAddress: 'Quartier Makepe, Douala',
  ),
];

// ─────────────────────────────────────────────
// DELIVERIES
// ─────────────────────────────────────────────
final mockDeliveries = [
  Delivery(
    id: 'DLV-001',
    orderId: 'CMD-002',
    delivererId: 'DLV-USER-001',
    clientName: 'Awa Traoré',
    clientPhone: '+237 6 78 90 12 34',
    deliveryAddress: 'Rue de la Paix, Akwa, Douala',
    status: OrderStatus.in_delivery,
    priority: DeliveryPriority.express,
    deliveryFee: 500,
    assignedAt: DateTime.now().subtract(const Duration(minutes: 15)),
    startedAt: DateTime.now().subtract(const Duration(minutes: 10)),
    currentLatitude: 4.0447,
    currentLongitude: 9.7679,
  ),
  Delivery(
    id: 'DLV-002',
    orderId: 'CMD-003',
    delivererId: 'DLV-USER-001',
    clientName: 'Josh Kimmich',
    clientPhone: '+237 6 90 35 12 78',
    deliveryAddress: 'Boulevard de la Liberté, Bonapriso, Douala',
    status: OrderStatus.assigned,
    priority: DeliveryPriority.urgent,
    deliveryFee: 1000,
    assignedAt: DateTime.now().subtract(const Duration(minutes: 5)),
    currentLatitude: 4.0511,
    currentLongitude: 9.7679,
  ),
];

// ─────────────────────────────────────────────
// STOCK ENTRIES (historique mouvements)
// ─────────────────────────────────────────────
final mockStockEntries = [
  StockEntry(
    id: 'STK-001',
    depotId: 'DEP-001',
    bottleTypeId: 'BT-001',
    type: StockMovementType.supply,
    quantity: 50,
    note: 'Approvisionnement mensuel',
    createdAt: DateTime.now().subtract(const Duration(days: 3)),
  ),
  StockEntry(
    id: 'STK-002',
    depotId: 'DEP-001',
    bottleTypeId: 'BT-002',
    type: StockMovementType.sold,
    quantity: 5,
    createdAt: DateTime.now().subtract(const Duration(hours: 4)),
  ),
  StockEntry(
    id: 'STK-003',
    depotId: 'DEP-001',
    bottleTypeId: 'BT-001',
    type: StockMovementType.returned_empty,
    quantity: 3,
    note: 'Retour client',
    createdAt: DateTime.now().subtract(const Duration(hours: 2)),
  ),
  StockEntry(
    id: 'STK-004',
    depotId: 'DEP-001',
    bottleTypeId: 'BT-002',
    type: StockMovementType.exchanged,
    quantity: 2,
    note: 'Échange bouteille vide contre pleine',
    createdAt: DateTime.now().subtract(const Duration(hours: 1)),
  ),
];

// ─────────────────────────────────────────────
// USERS
// ─────────────────────────────────────────────
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
  phone: '+237 6 78 90 12 34',
  name: 'Yannick Koffi',
  email: 'yannick@gazlink.cm',
  role: UserRole.deliverer,
  rating: 4.9,
  totalOrders: 156,
  depotId: 'DEP-001',
);

final mockDepotManager = User(
  id: 'MGR-001',
  phone: '+237 6 55 44 33 22',
  name: 'Marie Ngo',
  email: 'marie.ngo@gazlink.cm',
  role: UserRole.depot_manager,
  rating: 4.7,
  totalOrders: 0,
  depotId: 'DEP-001',
);

// Livreurs assignés au DEP-001
final mockDepotDeliverers = [
  User(
    id: 'DLV-USER-001',
    phone: '+237 6 78 90 12 34',
    name: 'Yannick Koffi',
    email: 'yannick@gazlink.cm',
    role: UserRole.deliverer,
    rating: 4.9,
    totalOrders: 156,
    depotId: 'DEP-001',
  ),
  User(
    id: 'DLV-USER-002',
    phone: '+237 6 45 67 89 01',
    name: 'Patrick Mbarga',
    email: 'patrick@gazlink.cm',
    role: UserRole.deliverer,
    rating: 4.6,
    totalOrders: 89,
    depotId: 'DEP-001',
  ),
  User(
    id: 'DLV-USER-003',
    phone: '+237 6 23 45 67 89',
    name: 'Cédric Ateba',
    email: 'cedric@gazlink.cm',
    role: UserRole.deliverer,
    rating: 4.3,
    totalOrders: 42,
    depotId: 'DEP-001',
    isActive: false,  // compte désactivé
  ),
];

// ─────────────────────────────────────────────
// MOCK DATA CLASS
// ─────────────────────────────────────────────
class MockData {
  static List<Depot> getMockDepots() => List<Depot>.from(mockDepots);
  static List<Order> getMockOrders() => List<Order>.from(mockOrders);
  static List<Delivery> getMockDeliveries() => List<Delivery>.from(mockDeliveries);
  static List<BottleType> getMockBottleTypes() => List<BottleType>.from(mockBottleTypes);
  static List<StockEntry> getMockStockEntries() => List<StockEntry>.from(mockStockEntries);
  static List<User> getMockDepotDeliverers(String depotId) =>
      mockDepotDeliverers.where((u) => u.depotId == depotId).toList();

  // Commandes d'un dépôt spécifique
  static List<Order> getOrdersForDepot(String depotId) =>
      mockOrders.where((o) => o.depotId == depotId).toList();

  // Statistiques rapides pour le dashboard dépôt
  static Map<String, dynamic> getDepotStats(String depotId) {
    final orders = getOrdersForDepot(depotId);
    final today = DateTime.now();
    final todayOrders = orders.where((o) =>
        o.createdAt.day == today.day &&
        o.createdAt.month == today.month).toList();

    final delivered = todayOrders
        .where((o) => o.status == OrderStatus.delivered)
        .toList();

    final revenue = delivered.fold<double>(
        0, (sum, o) => sum + o.totalPrice + o.deliveryFee);

    final subsidyCost = delivered.fold<double>(
        0, (sum, o) => sum + o.subsidyAmount);

    return {
      'totalToday': todayOrders.length,
      'deliveredToday': delivered.length,
      'pendingOrders': todayOrders
          .where((o) =>
              o.status == OrderStatus.pending ||
              o.status == OrderStatus.confirmed)
          .length,
      'revenueToday': revenue,
      'subsidyCostToday': subsidyCost,
    };
  }
}
