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
      _orders[index] = Order(
        id: _orders[index].id,
        clientId: _orders[index].clientId,
        depotId: _orders[index].depotId,
        quantity6kg: _orders[index].quantity6kg,
        quantity12kg: _orders[index].quantity12kg,
        totalPrice: _orders[index].totalPrice,
        discount: _orders[index].discount,
        finalPrice: _orders[index].finalPrice,
        status: status,
        paymentMethod: _orders[index].paymentMethod,
        createdAt: _orders[index].createdAt,
        deliveredAt: status == OrderStatus.delivered
            ? DateTime.now()
            : _orders[index].deliveredAt,
      );
      notifyListeners();
    }
  }
}
