import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthService {
  final fb_auth.FirebaseAuth _auth = fb_auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// 🔹 Récupérer l'utilisateur actuellement connecté
  Future<UserModel?> getCurrentUser() async {
    final fb_auth.User? firebaseUser = _auth.currentUser;
    if (firebaseUser == null) return null;

    final DocumentSnapshot userDoc =
    await _firestore.collection('users').doc(firebaseUser.uid).get();

    if (!userDoc.exists) return null;

    return UserModel.fromJson(userDoc.data() as Map<String, dynamic>);
  }

  /// 🔹 Connexion utilisateur
  Future<UserModel?> login(String email, String password) async {
    try {
      final fb_auth.UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final fb_auth.User? firebaseUser = result.user;
      if (firebaseUser == null) return null;

      final DocumentSnapshot userDoc =
      await _firestore.collection('users').doc(firebaseUser.uid).get();

      if (!userDoc.exists) return null;

      return UserModel.fromJson(userDoc.data() as Map<String, dynamic>);
    } catch (e) {
      throw Exception("❌ Erreur de connexion : $e");
    }
  }

  /// 🔹 Inscription utilisateur avec abonnement
  Future<UserModel?> signup(
      String email,
      String password,
      String displayName,
      DateTime? subscriptionExpiresAt,
      ) async {
    try {
      final fb_auth.UserCredential result =
      await _auth.createUserWithEmailAndPassword(email: email, password: password);

      final fb_auth.User? firebaseUser = result.user;
      if (firebaseUser == null) return null;

      final newUser = UserModel( // ✅ Correction ici (remplacement de `User` par `UserModel`)
        id: firebaseUser.uid,
        email: email,
        displayName: displayName,
        role: 'user', // 🔹 Par défaut, rôle utilisateur normal
        subscriptionExpiresAt: subscriptionExpiresAt,
        isActive: true, // 🔹 Par défaut, actif
      );

      await _firestore.collection('users').doc(firebaseUser.uid).set(newUser.toJson());

      return newUser;
    } catch (e) {
      throw Exception("❌ Erreur d'inscription : $e");
    }
  }

  /// 🔹 Déconnexion utilisateur
  Future<void> logout() async {
    await _auth.signOut();
  }
}
