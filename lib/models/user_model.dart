class User {
  final String id;
  final String name;
  final String email;
  final String displayName;
  final bool isAdmin;
  final bool isActive;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.displayName,
    required this.isAdmin,
    required this.isActive,
  });

  /// 🔹 Convertir les données Firestore en instance de `User`
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String? ?? '', // ✅ Ajout d'une valeur par défaut
      name: json['name'] as String? ?? json['displayName'] ?? '', // ✅ Fallback sur displayName
      email: json['email'] as String? ?? '',
      displayName: json['displayName'] as String? ?? '',
      isAdmin: json['isAdmin'] as bool? ?? false,
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  /// 🔹 Convertir une instance `User` en format JSON pour Firestore
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'displayName': displayName,
      'isAdmin': isAdmin,
      'isActive': isActive,
    };
  }

  /// 🔹 Créer une nouvelle instance avec des valeurs modifiées
  User copyWith({
    String? id,
    String? name,
    String? email,
    String? displayName,
    bool? isAdmin,
    bool? isActive,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      isAdmin: isAdmin ?? this.isAdmin,
      isActive: isActive ?? this.isActive,
    );
  }

  /// 🔹 Vérifier si le pseudo est valide (3 à 20 caractères, lettres, chiffres, _ . -)
  static bool isValidDisplayName(String displayName) {
    final validPseudoRegex = RegExp(r'^[a-zA-Z0-9._-]{3,20}$');
    return validPseudoRegex.hasMatch(displayName);
  }
}
