import 'package:flutter/material.dart';
import '../models/models.dart';
import '../data/mock_data.dart';

class AuthProvider extends ChangeNotifier {
  User? _user;
  bool _isLoading = false;
  String? _error;

  User? get user => _user;
  User? get currentUser => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _user != null;

  Future<bool> login({
    required String phone,
    required String password,
    required dynamic role,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await Future.delayed(Duration(seconds: 2));

      final parsedRole = _parseRole(role);

      if (parsedRole == UserRole.client) {
        _user = mockUser;
      } else if (parsedRole == UserRole.deliverer) {
        _user = mockDeliveryUser;
      } else {
        _user = mockUser;
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Erreur de connexion';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  UserRole _parseRole(dynamic role) {
    if (role is UserRole) {
      return role;
    }

    final roleValue = role.toString().toUpperCase();
    switch (roleValue) {
      case 'CLIENT':
      case 'USERROLE.CLIENT':
        return UserRole.client;
      case 'DELIVERER':
      case 'USERROLE.DELIVERER':
        return UserRole.deliverer;
      case 'DEPOT_MANAGER':
      case 'USERROLE.DEPOT_MANAGER':
        return UserRole.depot_manager;
      case 'ADMIN':
      case 'USERROLE.ADMIN':
        return UserRole.admin;
      default:
        return UserRole.client;
    }
  }

  void logout() {
    _user = null;
    _error = null;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
