import 'package:flutter/foundation.dart';
import 'package:gourmetpass/models/user_model.dart';
import 'package:gourmetpass/services/admin_service.dart';

class AdminProvider with ChangeNotifier {
  final AdminService _adminService = AdminService();
  List<UserModel> _users = []; // ✅ Correction ici
  bool _isLoading = false;
  String? _errorMessage;

  List<UserModel> get users => _users; // ✅ Correction ici
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// 🔹 Récupérer tous les utilisateurs
  Future<void> fetchUsers() async {
    _setLoading(true);
    try {
      final fetchedUsers = await _adminService.getAllUsers(); // ✅ Correction ici
      _users = fetchedUsers.map((user) => UserModel.fromJson(user)).toList(); // ✅ Conversion nécessaire
      notifyListeners();
    } catch (e) {
      _errorMessage = "Erreur lors de la récupération des utilisateurs.";
      debugPrint("❌ fetchUsers() : $e");
    } finally {
      _setLoading(false);
    }
  }

  /// 🔹 Mettre à jour le rôle d'un utilisateur
  Future<void> updateUserRole(String userId, String newRole) async {
    _setLoading(true);
    try {
      await _adminService.updateUserRole(userId, newRole);
      _users = _users.map((user) {
        if (user.id == userId) return user.copyWith(role: newRole); // ✅ Correction ici
        return user;
      }).toList();
      notifyListeners();
    } catch (e) {
      _errorMessage = "Erreur lors de la mise à jour du rôle.";
      debugPrint("❌ updateUserRole() : $e");
    } finally {
      _setLoading(false);
    }
  }

  /// 🔹 Suspendre ou réactiver un utilisateur
  Future<void> toggleUserStatus(String userId, bool isActive) async {
    _setLoading(true);
    try {
      await _adminService.updateUserStatus(userId, isActive); // 🚀 Correction ici
      _users = _users.map((user) {
        if (user.id == userId) return user.copyWith(isActive: isActive);
        return user;
      }).toList();
      notifyListeners();
    } catch (e) {
      _errorMessage = "Erreur lors de la mise à jour du statut.";
      debugPrint("❌ toggleUserStatus() : $e");
    } finally {
      _setLoading(false);
    }
  }


  /// 🔹 Supprimer un utilisateur
  Future<void> deleteUser(String userId) async {
    _setLoading(true);
    try {
      await _adminService.deleteUser(userId);
      _users.removeWhere((user) => user.id == userId); // ✅ Correction ici
      notifyListeners();
    } catch (e) {
      _errorMessage = "Erreur lors de la suppression.";
      debugPrint("❌ deleteUser() : $e");
    } finally {
      _setLoading(false);
    }
  }

  /// 🔹 Gère l'état de chargement
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
