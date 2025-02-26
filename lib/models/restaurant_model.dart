import 'coupon_model.dart';

class RestaurantModel {
  final String id;
  final String name;
  final String description;
  final String cuisineType;
  final String address;
  final String city;
  final String hours;
  final List<String> ratings;
  final List<String> salles;
  final List<String> plats;
  final List<CouponModel> coupons; // ✅ Ajout des coupons au modèle

  RestaurantModel({
    required this.id,
    required this.name,
    required this.description,
    required this.cuisineType,
    required this.address,
    required this.city,
    required this.hours,
    required this.ratings,
    required this.salles,
    required this.plats,
    required this.coupons, // ✅ Initialisation des coupons
  });

  /// 🔹 **Calcul de la note moyenne**
  double get averageRating {
    if (ratings.isEmpty) return 0.0; // ✅ Si aucune note, retourne 0.0
    final List<double> parsedRatings =
    ratings.map((r) => double.tryParse(r) ?? 0.0).toList();
    final double sum = parsedRatings.reduce((a, b) => a + b);
    return sum / parsedRatings.length;
  }
  /// 🔹 Convertir un document Firestore en objet `RestaurantModel`
  factory RestaurantModel.fromJson(Map<String, dynamic> json) {
    return RestaurantModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      cuisineType: json['cuisineType'] as String,
      address: json['address'] as String,
      city: json['city'] as String,
      hours: json['hours'] as String,
      ratings: List<String>.from(json['ratings'] ?? []),
      salles: List<String>.from(json['salles'] ?? []),
      plats: List<String>.from(json['plats'] ?? []),
      coupons: (json['coupons'] as List<dynamic>?)
          ?.map((coupon) => CouponModel.fromJson(coupon as Map<String, dynamic>))
          .toList() ??
          [], // ✅ Conversion des coupons Firestore
    );
  }

  /// 🔹 Convertir un objet `RestaurantModel` en Map pour Firestore
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "description": description,
      "cuisineType": cuisineType,
      "address": address,
      "city": city,
      "hours": hours,
      "ratings": ratings,
      "salles": salles,
      "plats": plats,
      "coupons": coupons.map((coupon) => coupon.toJson()).toList(), // ✅ Conversion des coupons en JSON
    };
  }

  /// 🔹 Créer une copie du restaurant avec des valeurs modifiées
  RestaurantModel copyWith({
    String? id,
    String? name,
    String? description,
    String? cuisineType,
    String? address,
    String? city,
    String? hours,
    List<String>? ratings,
    List<String>? salles,
    List<String>? plats,
    List<CouponModel>? coupons,
  }) {
    return RestaurantModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      cuisineType: cuisineType ?? this.cuisineType,
      address: address ?? this.address,
      city: city ?? this.city,
      hours: hours ?? this.hours,
      ratings: ratings ?? this.ratings,
      salles: salles ?? this.salles,
      plats: plats ?? this.plats,
      coupons: coupons ?? this.coupons, // ✅ Ajout des coupons
    );
  }
}
