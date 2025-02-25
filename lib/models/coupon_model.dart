import 'dart:math';

class Coupon {
  final String id;
  final String restaurantId;
  final String description;
  final int discountPercentage;
  final int maxPeople;
  final bool isUsed;
  final bool isActive;
  final String uniqueCode; // ✅ Ajout du code unique

  Coupon({
    required this.id,
    required this.restaurantId,
    required this.description,
    required this.discountPercentage,
    required this.maxPeople,
    this.isUsed = false,
    this.isActive = true,
    required this.uniqueCode, // ✅ Obligation d'avoir un code unique
  });

  /// Génère un code unique aléatoire (ex: ABCD-1234)
  static String generateUniqueCode() {
    const letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    final random = Random();
    String part1 = String.fromCharCodes(
        List.generate(4, (index) => letters.codeUnitAt(random.nextInt(letters.length))));
    String part2 = (random.nextInt(9000) + 1000).toString(); // 4 chiffres
    return '$part1-$part2';
  }

  /// Convertir les données de Firestore en instance de `Coupon`
  factory Coupon.fromJson(Map<String, dynamic> json) {
    return Coupon(
      id: json['id'],
      restaurantId: json['restaurantId'],
      description: json['description'],
      discountPercentage: json['discountPercentage'],
      maxPeople: json['maxPeople'],
      isUsed: json['isUsed'] ?? false,
      isActive: json['isActive'] ?? true,
      uniqueCode: json['uniqueCode'] ?? generateUniqueCode(), // ✅ Génère un code si absent
    );
  }

  /// Convertir une instance de `Coupon` en format JSON pour Firestore
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'restaurantId': restaurantId,
      'description': description,
      'discountPercentage': discountPercentage,
      'maxPeople': maxPeople,
      'isUsed': isUsed,
      'isActive': isActive,
      'uniqueCode': uniqueCode, // ✅ Sauvegarde le code unique
    };
  }

  /// Méthode `copyWith` pour créer une copie modifiée
  Coupon copyWith({
    String? id,
    String? restaurantId,
    String? description,
    int? discountPercentage,
    int? maxPeople,
    bool? isUsed,
    bool? isActive,
    String? uniqueCode,
  }) {
    return Coupon(
      id: id ?? this.id,
      restaurantId: restaurantId ?? this.restaurantId,
      description: description ?? this.description,
      discountPercentage: discountPercentage ?? this.discountPercentage,
      maxPeople: maxPeople ?? this.maxPeople,
      isUsed: isUsed ?? this.isUsed,
      isActive: isActive ?? this.isActive,
      uniqueCode: uniqueCode ?? this.uniqueCode,
    );
  }
}
