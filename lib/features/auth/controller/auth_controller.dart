import 'package:flutter/material.dart';
import '../../../core/services/storage_service.dart';
import '../service/auth_service.dart';
import '../model/user_model.dart';

class AuthController with ChangeNotifier {
  final AuthService _authService;
  final StorageService _storageService;

  bool _isLoading = false;
  bool _isInitialized = false;
  String? _errorMessage;
  UserModel? _user;

  AuthController(this._authService, this._storageService);

  bool get isLoading => _isLoading;
  bool get isInitialized => _isInitialized;
  String? get errorMessage => _errorMessage;
  UserModel? get user => _user;
  bool get isLoggedIn => _user != null;

  Future<void> checkLoginStatus() async {
    try {
      final userJson = await _storageService.getUser();
      if (userJson != null) {
        _user = UserModel.deserialize(userJson);
      }
    } catch (e) {
      debugPrint("Error checking login status: $e");
    } finally {
      _isInitialized = true;
      notifyListeners();
    }
  }

  Future<bool> login(String username, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _authService.login(username, password);

    if (result.error != null) {
      _errorMessage = result.error;
      _isLoading = false;
      notifyListeners();
      return false;
    }

    if (result.user != null && result.token != null) {
      await _storageService.saveToken(result.token!);
      await _storageService.saveUser(UserModel.serialize(result.user!));
      _user = result.user;
      _isLoading = false;
      notifyListeners();
      return true;
    }

    _errorMessage = "Unknown error";
    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<void> logout() async {
    await _storageService.deleteToken();
    await _storageService.deleteUser();
    _user = null;
    notifyListeners();
  }
}
