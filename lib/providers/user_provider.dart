import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gourmetpass/services/auth_service.dart';
import 'package:gourmetpass/models/user_model.dart';

class UserProvider with ChangeNotifier {
  UserModel? _user;
  final AuthService _authService = AuthService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final List<UserModel> _users = [];

  bool _isLoading = false;
  String? _errorMessage;

  UserModel? get user => _user;
  bool get isLoggedIn => _user != null;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<UserModel> get users => _users;

  /// 🔹 **Récupérer tous les utilisateurs**
  Future<void> fetchUsers() async {
    _setLoading(true);
    try {
      final QuerySnapshot snapshot =
      await _firestore.collection('users').get();

      _users.clear();
      _users.addAll(snapshot.docs.map((doc) =>
          UserModel.fromJson(doc.data() as Map<String, dynamic>)));

      notifyListeners();
      debugPrint("✅ Liste des utilisateurs récupérée (${_users.length} utilisateurs)");
    } catch (e) {
      _errorMessage = "Erreur lors de la récupération des utilisateurs.";
      debugPrint("❌ fetchUsers() : $e");
    } finally {
      _setLoading(false);
    }
  }

  /// 🔹 **Gérer l'état de chargement**
  void _setLoading(bool value) {
    if (_isLoading != value) {
      _isLoading = value;
      notifyListeners();
    }
  }

  /// 🔹 Récupérer l'utilisateur actuellement connecté
  Future<void> fetchCurrentUser() async {
    _setLoading(true);
    try {
      _user = await _authService.getCurrentUser();
      if (_user != null) {
        DocumentSnapshot userDoc =
        await _firestore.collection('users').doc(_user!.id).get();
        if (userDoc.exists) {
          _user = UserModel.fromJson(userDoc.data() as Map<String, dynamic>);
        }
      }
      debugPrint("✅ Utilisateur récupéré: ${_user?.toJson()}");
    } catch (e) {
      _user = null;
      _errorMessage = "Erreur lors de la récupération de l'utilisateur.";
      debugPrint("❌ fetchCurrentUser() : $e");
    } finally {
      _setLoading(false);
    }
  }

  /// 🔹 Connexion utilisateur
  Future<bool> login(String email, String password) async {
    _setLoading(true);
    try {
      _user = await _authService.login(email, password);
      if (_user != null) {
        DocumentSnapshot userDoc =
        await _firestore.collection('users').doc(_user!.id).get();
        if (userDoc.exists) {
          _user = UserModel.fromJson(userDoc.data() as Map<String, dynamic>);
        }
      }
      debugPrint("✅ Connexion réussie: ${_user?.toJson()}");
      return true;
    } catch (e) {
      _handleAuthError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// 🔹 Inscription utilisateur avec abonnement
  Future<UserModel?> signup(
      String email, String password, String displayName, DateTime? subscriptionExpiresAt) async {
    _setLoading(true);
    try {
      final newUser =
      await _authService.signup(email, password, displayName, subscriptionExpiresAt);
      if (newUser != null) {
        _user = newUser.copyWith(
          displayName: displayName,
          role: 'user',
          subscriptionExpiresAt: subscriptionExpiresAt,
        );

        await _firestore.collection('users').doc(_user!.id).set(_user!.toJson());

        debugPrint("✅ Inscription réussie et utilisateur ajouté: ${_user?.toJson()}");
      }
      return newUser;
    } catch (e) {
      _handleAuthError(e.toString());
      return null;
    } finally {
      _setLoading(false);
    }
  }

  /// 🔹 Mettre à jour un utilisateur
  Future<void> updateUser(UserModel updatedUser) async {
    _setLoading(true);
    try {
      DocumentSnapshot userDoc =
      await _firestore.collection('users').doc(updatedUser.id).get();
      String roleInDB = userDoc.exists ? (userDoc['role'] ?? 'user') : 'user';

      final safeUser = updatedUser.copyWith(role: roleInDB);

      await _firestore.collection('users').doc(updatedUser.id).update(safeUser.toJson());

      if (_user?.id == updatedUser.id) {
        _user = safeUser;
      }

      notifyListeners();
      debugPrint("✅ Utilisateur mis à jour: ${safeUser.toJson()}");
    } catch (e) {
      _errorMessage = "Erreur de mise à jour : ${e.toString()}";
      debugPrint("❌ updateUser() : $e");
    } finally {
      _setLoading(false);
    }
  }
  /// 🔹 **Supprimer un utilisateur**
  Future<void> deleteUser(String userId) async {
    _setLoading(true);
    try {
      await _firestore.collection('users').doc(userId).delete();
      _users.removeWhere((user) => user.id == userId);

      // Déconnexion si l'utilisateur supprimé est celui connecté
      if (_user?.id == userId) {
        await logout();
      }

      notifyListeners();
      debugPrint("✅ Utilisateur supprimé: $userId");
    } catch (e) {
      _errorMessage = "Erreur lors de la suppression de l'utilisateur.";
      debugPrint("❌ deleteUser() : $e");
    } finally {
      _setLoading(false);
    }
  }


  /// 🔹 Mettre à jour l'abonnement d'un utilisateur
  Future<void> updateSubscription(String userId, DateTime? newExpiration) async {
    _setLoading(true);
    try {
      await _firestore.collection('users').doc(userId).update({
        "subscriptionExpiresAt": newExpiration?.toIso8601String(),
      });

      if (_user?.id == userId) {
        _user = _user!.copyWith(subscriptionExpiresAt: newExpiration);
      }

      notifyListeners();
      debugPrint("✅ Abonnement mis à jour pour l'utilisateur: $userId");
    } catch (e) {
      debugPrint("❌ updateSubscription() : $e");
    } finally {
      _setLoading(false);
    }
  }

  /// 🔹 Déconnexion utilisateur
  Future<void> logout() async {
    _setLoading(true);
    try {
      await _authService.logout();
      _user = null;
      _users.clear();
      notifyListeners();
      debugPrint("✅ Déconnexion réussie");
    } catch (e) {
      _errorMessage = "Erreur lors de la déconnexion.";
      debugPrint("❌ logout() : $e");
    } finally {
      _setLoading(false);
    }
  }


  /// 🔹 Gérer les erreurs Firebase Auth
  void _handleAuthError(String error) {
    if (error.contains('email-already-in-use')) {
      _errorMessage = "Cet email est déjà utilisé.";
    } else if (error.contains('weak-password')) {
      _errorMessage = "Le mot de passe est trop faible.";
    } else if (error.contains('invalid-email')) {
      _errorMessage = "L'adresse email est invalide.";
    } else if (error.contains('wrong-password')) {
      _errorMessage = "Mot de passe incorrect.";
    } else {
      _errorMessage = "Une erreur est survenue.";
    }
    notifyListeners();
  }
}
