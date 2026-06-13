import 'package:flutter/material.dart';
import '../models/models.dart';
import '../data/mock_data.dart';

class DepotProvider extends ChangeNotifier {
  late Depot _depot;
  List<Order> _orders = [];
  List<User> _deliverers = [];
  List<StockEntry> _stockEntries = [];
  bool _isLoading = false;
  String? _error;

  Depot get depot => _depot;
  List<Order> get orders => _orders;
  List<User> get deliverers => _deliverers;
  List<User> get activeDeliverers =>
      _deliverers.where((d) => d.isActive).toList();
  List<StockEntry> get stockEntries => _stockEntries;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Commandes par statut
  List<Order> get pendingOrders => _orders
      .where((o) => o.status == OrderStatus.pending)
      .toList();
  List<Order> get confirmedOrders => _orders
      .where((o) => o.status == OrderStatus.confirmed)
      .toList();
  List<Order> get activeOrders => _orders
      .where((o) =>
          o.status == OrderStatus.confirmed ||
          o.status == OrderStatus.assigned ||
          o.status == OrderStatus.in_delivery)
      .toList();

  void init(String depotId) {
    _depot = mockDepots.firstWhere((d) => d.id == depotId);
    _orders = MockData.getOrdersForDepot(depotId);
    _deliverers = MockData.getMockDepotDeliverers(depotId);
    _stockEntries = MockData.getMockStockEntries()
        .where((e) => e.depotId == depotId)
        .toList();
    notifyListeners();
  }

  // ── Commandes ──

  Future<void> confirmOrder(String orderId) async {
    _setLoading(true);
    await Future.delayed(const Duration(milliseconds: 500));
    _updateOrderStatus(orderId, OrderStatus.confirmed);
    _setLoading(false);
  }

  Future<void> assignDeliverer(String orderId, String delivererId) async {
    _setLoading(true);
    await Future.delayed(const Duration(milliseconds: 500));
    final idx = _orders.indexWhere((o) => o.id == orderId);
    if (idx != -1) {
      _orders[idx] = Order(
        id: _orders[idx].id,
        clientId: _orders[idx].clientId,
        depotId: _orders[idx].depotId,
        quantity6kg: _orders[idx].quantity6kg,
        quantity12kg: _orders[idx].quantity12kg,
        quantity24kg: _orders[idx].quantity24kg,
        totalPrice: _orders[idx].totalPrice,
        subsidyAmount: _orders[idx].subsidyAmount,
        discount: _orders[idx].discount,
        finalPrice: _orders[idx].finalPrice,
        deliveryFee: _orders[idx].deliveryFee,
        priority: _orders[idx].priority,
        status: OrderStatus.assigned,
        paymentMethod: _orders[idx].paymentMethod,
        createdAt: _orders[idx].createdAt,
        deliveryAddress: _orders[idx].deliveryAddress,
        delivererId: delivererId,
      );
    }
    _setLoading(false);
  }

  void _updateOrderStatus(String orderId, OrderStatus status) {
    final idx = _orders.indexWhere((o) => o.id == orderId);
    if (idx != -1) {
      final o = _orders[idx];
      _orders[idx] = Order(
        id: o.id,
        clientId: o.clientId,
        depotId: o.depotId,
        quantity6kg: o.quantity6kg,
        quantity12kg: o.quantity12kg,
        quantity24kg: o.quantity24kg,
        totalPrice: o.totalPrice,
        subsidyAmount: o.subsidyAmount,
        discount: o.discount,
        finalPrice: o.finalPrice,
        deliveryFee: o.deliveryFee,
        priority: o.priority,
        status: status,
        paymentMethod: o.paymentMethod,
        createdAt: o.createdAt,
        deliveryAddress: o.deliveryAddress,
        delivererId: o.delivererId,
      );
      notifyListeners();
    }
  }

  // ── Stock ──

  Future<void> addStockEntry({
    required String bottleTypeId,
    required StockMovementType type,
    required int quantity,
    String? note,
  }) async {
    _setLoading(true);
    await Future.delayed(const Duration(milliseconds: 500));

    final entry = StockEntry(
      id: 'STK-${DateTime.now().millisecondsSinceEpoch}',
      depotId: _depot.id,
      bottleTypeId: bottleTypeId,
      type: type,
      quantity: quantity,
      note: note,
      createdAt: DateTime.now(),
    );
    _stockEntries.insert(0, entry);
    _setLoading(false);
  }

  // ── Livreurs ──

  Future<void> addDeliverer({
    required String name,
    required String phone,
  }) async {
    _setLoading(true);
    await Future.delayed(const Duration(milliseconds: 600));

    final newDeliverer = User(
      id: 'DLV-${DateTime.now().millisecondsSinceEpoch}',
      phone: phone,
      name: name,
      email: '${name.toLowerCase().replaceAll(' ', '.')}@gazlink.cm',
      role: UserRole.deliverer,
      depotId: _depot.id,
    );
    _deliverers.add(newDeliverer);
    _setLoading(false);
  }

  // Soft-delete livreur
  Future<void> deactivateDeliverer(String delivererId) async {
    _setLoading(true);
    await Future.delayed(const Duration(milliseconds: 400));
    final idx = _deliverers.indexWhere((d) => d.id == delivererId);
    if (idx != -1) {
      _deliverers[idx] = _deliverers[idx].copyWith(
        isActive: false,
        deactivatedAt: DateTime.now(),
      );
    }
    _setLoading(false);
  }

  Future<void> reactivateDeliverer(String delivererId) async {
    _setLoading(true);
    await Future.delayed(const Duration(milliseconds: 400));
    final idx = _deliverers.indexWhere((d) => d.id == delivererId);
    if (idx != -1) {
      _deliverers[idx] = _deliverers[idx].copyWith(isActive: true);
    }
    _setLoading(false);
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Map<String, dynamic> get todayStats =>
      MockData.getDepotStats(_depot.id);
}
