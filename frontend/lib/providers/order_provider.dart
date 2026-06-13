import 'package:flutter/material.dart';
import '../models/models.dart';
import '../data/mock_data.dart';

class OrderProvider extends ChangeNotifier {
  List<Order> _orders = mockOrders;
  Order? _currentOrder;
  bool _isLoading = false;

  List<Order> get orders => _orders;
  List<Depot> get availableDepots => mockDepots;
  Order? get currentOrder => _currentOrder;
  bool get isLoading => _isLoading;

  Future<void> fetchOrders() async {
    _isLoading = true;
    notifyListeners();
    await Future.delayed(Duration(seconds: 1));
    _orders = mockOrders;
    _isLoading = false;
    notifyListeners();
  }

  void createOrder(Order order) {
    _orders.add(order);
    _currentOrder = order;
    notifyListeners();
  }

  void updateOrderStatus(String orderId, OrderStatus status) {
    final index = _orders.indexWhere((o) => o.id == orderId);
    if (index != -1) {
      final o = _orders[index];
      _orders[index] = Order(
        id: o.id,
        clientId: o.clientId,
        depotId: o.depotId,
        quantity6kg: o.quantity6kg,
        quantity12kg: o.quantity12kg,
        totalPrice: o.totalPrice,
        subsidyAmount: o.subsidyAmount,   // ← ajouté
        discount: o.discount,
        finalPrice: o.finalPrice,
        priority: o.priority,             // ← ajouté
        deliveryFee: o.deliveryFee,       // ← ajouté
        status: status,
        paymentMethod: o.paymentMethod,
        createdAt: o.createdAt,
        deliveredAt: status == OrderStatus.delivered
            ? DateTime.now()
            : o.deliveredAt,
        deliveryAddress: o.deliveryAddress,
        delivererId: o.delivererId,
      );
      notifyListeners();
    }
  }
}