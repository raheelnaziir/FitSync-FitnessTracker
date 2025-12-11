import 'package:flutter/material.dart';
import '../services/api_service.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoggedIn = false;
  String? _token;
  String? _userName;
  String? _userEmail;

  bool get isLoggedIn => _isLoggedIn;
  String? get token => _token;
  String? get userName => _userName;
  String? get userEmail => _userEmail;

  // ---------------- LOGIN ----------------
  Future<bool> login(String email, String password) async {
    try {
      final res = await ApiService.login(email, password);
      if (res['token'] != null) {
        _token = res['token'];
        ApiService.token = _token; // set token for API calls
        _userName = res['user']['name'];
        _userEmail = res['user']['email'];
        _isLoggedIn = true;
        notifyListeners();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  // ---------------- REGISTER ----------------
  Future<bool> register(String name, String email, String password) async {
    try {
      final res = await ApiService.register(name, email, password);
      if (res['token'] != null) {
        _token = res['token'];
        ApiService.token = _token;
        _userName = res['user']['name'];
        _userEmail = res['user']['email'];
        _isLoggedIn = true;
        notifyListeners();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  // ---------------- LOGOUT ----------------
  void logout() {
    _isLoggedIn = false;
    _token = null;
    _userName = null;
    _userEmail = null;
    ApiService.token = null;
    notifyListeners();
  }
}
