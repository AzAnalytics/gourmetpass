import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String displayName;
  final String email;
  final String role;
  final DateTime? subscriptionExpiresAt;
  final bool isActive;

  /// ✅ Vérifie si l'utilisateur est administrateur
  bool get isAdmin => role.toLowerCase() == "admin";

  /// ✅ Vérifie si l'utilisateur a un abonnement valide
  bool get hasValidSubscription =>
      subscriptionExpiresAt != null && subscriptionExpiresAt!.isAfter(DateTime.now());

  UserModel({
    required this.id,
    required this.displayName,
    required this.email,
    required this.role,
    this.subscriptionExpiresAt,
    required this.isActive,
  });

  /// 🔹 Convertir un document Firestore en objet `UserModel`
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      displayName: json['displayName'] as String? ?? "Utilisateur",
      email: json['email'] as String? ?? "Inconnu",
      role: json['role'] as String? ?? "user", // ✅ Assure une valeur par défaut
      subscriptionExpiresAt: json['subscriptionExpiresAt'] != null
          ? (json['subscriptionExpiresAt'] as Timestamp).toDate()
          : null,
      isActive: json['isActive'] as bool? ?? true, // ✅ Par défaut, actif
    );
  }

  /// 🔹 Convertir un objet `UserModel` en Map pour Firestore
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "displayName": displayName,
      "email": email,
      "role": role,
      "subscriptionExpiresAt":
      subscriptionExpiresAt != null ? Timestamp.fromDate(subscriptionExpiresAt!) : null,
      "isActive": isActive,
    };
  }

  /// 🔹 Créer une copie de l'utilisateur avec des valeurs modifiées
  UserModel copyWith({
    String? id,
    String? displayName,
    String? email,
    String? role,
    DateTime? subscriptionExpiresAt,
    bool? isActive,
  }) {
    return UserModel(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      role: role ?? this.role,
      subscriptionExpiresAt: subscriptionExpiresAt ?? this.subscriptionExpiresAt,
      isActive: isActive ?? this.isActive,
    );
  }
}
