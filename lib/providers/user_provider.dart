/*import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';
import 'package:flutter/foundation.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  final AuthService _authService;
  final FirebaseFirestore _firestore;

  List<User> _users = [];
  bool _isLoading = false;
  String? _errorMessage;

  UserProvider({AuthService? authService, FirebaseFirestore? firestore})
      : _authService = authService ?? RealAuthService(), // Utilisation d'une implémentation concrète
        _firestore = firestore ?? FirebaseFirestore.instance;

  User? get user => _user;
  bool get isLoggedIn => _user != null;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<User> get users => _users;

  /// Récupérer l'utilisateur actuellement connecté
  Future<void> fetchCurrentUser() async {
    _setLoading(true);
    try {
      _user = await _authService.getCurrentUser();
      if (_user != null && _user!.displayName.isEmpty) {
        _user = _user!.copyWith(displayName: "Utilisateur");
      }
      _errorMessage = null;
      debugPrint("✅ Utilisateur récupéré: ${_user?.toJson()}");
    } catch (e) {
      _errorMessage = "Erreur lors de la récupération des données utilisateur.";
      debugPrint("❌ fetchCurrentUser() : $e");
    } finally {
      _setLoading(false);
    }
  }

  /// Connexion utilisateur
  Future<bool> login(String email, String password) async {
    _setLoading(true);
    try {
      _user = await _authService.login(email, password);
      if (_user != null && _user!.displayName.isEmpty) {
        _user = _user!.copyWith(displayName: "Utilisateur");
      }
      _errorMessage = null;
      debugPrint("✅ Connexion réussie: ${_user?.toJson()}");
      return true;
    } catch (e) {
      _errorMessage = "Erreur de connexion : ${e.toString()}";
      debugPrint("❌ login() : $e");
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Inscription utilisateur
  Future<User?> signup(String email, String password, String displayName) async {
    _setLoading(true);
    try {
      final newUser = await _authService.signup(email, password, displayName);
      if (newUser != null) {
        _user = newUser.copyWith(displayName: displayName.isNotEmpty ? displayName : "Utilisateur");
        _errorMessage = null;
        debugPrint("✅ Inscription réussie: ${_user?.toJson()}");
      }
      return newUser;
    } catch (e) {
      _errorMessage = "Erreur d'inscription : ${e.toString()}";
      debugPrint("❌ signup() : $e");
      return null;
    } finally {
      _setLoading(false);
    }
  }

  /// Mise à jour des informations utilisateur
  Future<void> updateUser(User updatedUser) async {
    _setLoading(true);
    try {
      await _firestore.collection('users').doc(updatedUser.id).update(updatedUser.toJson());
      _users = _users.map((u) => u.id == updatedUser.id ? updatedUser : u).toList();
      if (_user?.id == updatedUser.id) {
        _user = updatedUser; // Met à jour l'utilisateur connecté s'il est modifié
      }
      _errorMessage = null;
      notifyListeners();
      debugPrint("✅ Utilisateur mis à jour: ${updatedUser.toJson()}");
    } catch (e) {
      _errorMessage = "Erreur de mise à jour : ${e.toString()}";
      debugPrint("❌ updateUser() : $e");
    } finally {
      _setLoading(false);
    }
  }

  /// Ajouter un utilisateur à Firestore
  Future<void> addUser(User newUser) async {
    _setLoading(true);
    try {
      await _firestore.collection('users').doc(newUser.id).set(newUser.toJson());
      _users.add(newUser);
      _errorMessage = null;
      notifyListeners();
      debugPrint("✅ Utilisateur ajouté: ${newUser.toJson()}");
    } catch (e) {
      _errorMessage = "Erreur lors de l'ajout de l'utilisateur.";
      debugPrint("❌ addUser() : $e");
    } finally {
      _setLoading(false);
    }
  }

  /// Supprimer un utilisateur de Firestore
  Future<void> deleteUser(String id) async {
    _setLoading(true);
    try {
      await _firestore.collection('users').doc(id).delete();
      _users.removeWhere((user) => user.id == id);
      if (_user?.id == id) {
        _user = null; // Déconnecter l'utilisateur si c'est lui qui est supprimé
      }
      _errorMessage = null;
      notifyListeners();
      debugPrint("✅ Utilisateur supprimé: $id");
    } catch (e) {
      _errorMessage = "Erreur lors de la suppression de l'utilisateur.";
      debugPrint("❌ deleteUser() : $e");
    } finally {
      _setLoading(false);
    }
  }

  /// Récupérer tous les utilisateurs
  Future<void> fetchUsers() async {
    _setLoading(true);
    try {
      final snapshot = await _firestore.collection('users').get();
      _users = snapshot.docs.map((doc) => User.fromJson(doc.data())).toList();
      _errorMessage = null;
      notifyListeners();
      debugPrint("✅ Utilisateurs récupérés: ${_users.length}");
    } catch (e) {
      _errorMessage = "Erreur de récupération des utilisateurs.";
      debugPrint("❌ fetchUsers() : $e");
    } finally {
      _setLoading(false);
    }
  }

  /// Déconnexion utilisateur
  Future<void> logout() async {
    _setLoading(true);
    try {
      await _authService.logout();
      _user = null;
      _users.clear();
      _errorMessage = null;
      notifyListeners();
      debugPrint("✅ Déconnexion réussie");
    } catch (e) {
      _errorMessage = "Erreur lors de la déconnexion.";
      debugPrint("❌ logout() : $e");
    } finally {
      _setLoading(false);
    }
  }

  /// Gère l'état de chargement
  void _setLoading(bool value) {
    if (_isLoading != value) {
      _isLoading = value;
      notifyListeners();
    }
  }

  /// Méthode pour définir un message d'erreur dans le provider
  void setErrorState(String errorMessage) {
    _errorMessage = errorMessage;
    notifyListeners();
    Future.delayed(const Duration(milliseconds: 300));
  }

  /// Ajout d'une méthode pour définir la liste des utilisateurs (pour les tests)
  void setUsers(List<User> users) {
    _users = users;
    notifyListeners();
  }
}
*/