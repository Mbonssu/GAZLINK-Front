import 'package:flutter/material.dart';
import '../models/models.dart';
import '../data/mock_data.dart';

class DeliveryProvider extends ChangeNotifier {
  List<Delivery> _deliveries = mockDeliveries;
  bool _isLoading = false;

  List<Delivery> get deliveries => _deliveries;
  bool get isLoading => _isLoading;

  Future<void> fetchDeliveries() async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(Duration(seconds: 1));
    _deliveries = mockDeliveries;

    _isLoading = false;
    notifyListeners();
  }

  void updateDeliveryStatus(String deliveryId, OrderStatus status) {
    final index = _deliveries.indexWhere((d) => d.id == deliveryId);
    if (index != -1) {
      _deliveries[index] = Delivery(
        id: _deliveries[index].id,
        orderId: _deliveries[index].orderId,
        delivererId: _deliveries[index].delivererId,
        clientName: _deliveries[index].clientName,
        clientPhone: _deliveries[index].clientPhone,
        deliveryAddress: _deliveries[index].deliveryAddress,
        status: status,
        assignedAt: _deliveries[index].assignedAt,
        startedAt: status == OrderStatus.in_delivery
            ? DateTime.now()
            : _deliveries[index].startedAt,
        deliveredAt: status == OrderStatus.delivered
            ? DateTime.now()
            : _deliveries[index].deliveredAt,
        currentLatitude: _deliveries[index].currentLatitude,
        currentLongitude: _deliveries[index].currentLongitude,
      );
      notifyListeners();
    }
  }
}
