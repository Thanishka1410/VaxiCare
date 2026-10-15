import 'package:flutter/foundation.dart';
import '../services/storage_service.dart';

class AuthProvider with ChangeNotifier {
  final StorageService _storage;

  bool _isAuthenticated = false;
  String _userName = 'Priya Sharma';
  String _userEmail = 'priya.sharma@example.com';
  String _userPhone = '+91 98765 43210';

  AuthProvider(this._storage) {
    _loadSession();
  }

  bool get isAuthenticated => _isAuthenticated;
  String get userName => _userName;
  String get userEmail => _userEmail;
  String get userPhone => _userPhone;

  void _loadSession() {
    final user = _storage.getSimulatedUser();
    if (user != null) {
      _userName = user['name'] ?? 'Priya Sharma';
      _userEmail = user['email'] ?? 'priya.sharma@example.com';
      _userPhone = user['phone'] ?? '+91 98765 43210';
      _isAuthenticated = true;
    } else {
      // Default logged-in state for presentation convenience
      _isAuthenticated = true;
    }
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    // Simulated validation for UI/UX demonstration
    if (email.isNotEmpty && password.length >= 6) {
      _userEmail = email;
      _userName = email.split('@').first;
      _userName = _userName[0].toUpperCase() + _userName.substring(1);
      _isAuthenticated = true;
      await _storage.saveSimulatedUser({
        'name': _userName,
        'email': _userEmail,
        'phone': _userPhone,
      });
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<void> demoQuickLogin() async {
    _userName = 'Priya Sharma';
    _userEmail = 'priya.sharma@example.com';
    _userPhone = '+91 98765 43210';
    _isAuthenticated = true;
    await _storage.saveSimulatedUser({
      'name': _userName,
      'email': _userEmail,
      'phone': _userPhone,
    });
    notifyListeners();
  }

  Future<void> logout() async {
    _isAuthenticated = false;
    await _storage.clearSimulatedUser();
    notifyListeners();
  }

  Future<void> updateProfile({required String name, required String phone}) async {
    _userName = name;
    _userPhone = phone;
    await _storage.saveSimulatedUser({
      'name': _userName,
      'email': _userEmail,
      'phone': _userPhone,
    });
    notifyListeners();
  }
}
