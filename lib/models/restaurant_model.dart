class Restaurant {
  final String id;
  final String name;
  final String description;
  final String cuisineType;
  final String address;
  final String city;
  final String hours;
  final List<double> ratings;
  final List<String> coupons;
  final List<String> salles; // 🔹 Images des salles
  final List<String> plats; // 🔹 Images des plats// 🔹 Chemin vers l'image locale

  Restaurant({
    required this.id,
    required this.name,
    required this.description,
    required this.cuisineType,
    required this.address,
    required this.city,
    required this.hours,
    required this.ratings,
    required this.coupons,
    required this.salles,
    required this.plats, // ✅ Ajout des images des plats
  });

  /// Convertir les données JSON en `Restaurant`
  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      cuisineType: json['cuisineType'],
      address: json['address'],
      city: json['city'],
      hours: json['hours'],
      ratings: List<double>.from(json['ratings'] ?? []),
      coupons: List<String>.from(json['coupons'] ?? []),
      salles: List<String>.from(json['salles'] ?? []),
      plats: List<String>.from(json['plats'] ?? []), // ✅ Ajout des images des plats
    );
  }

  /// Convertir `Restaurant` en JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'cuisineType': cuisineType,
      'address': address,
      'city': city,
      'hours': hours,
      'ratings': ratings,
      'coupons': coupons,
      'salles': salles,
      'plats': plats, // ✅ Ajout des images des plats
    };
  }

  /// 🔹 Méthode `copyWith` pour créer une copie modifiée
  Restaurant copyWith({
    String? id,
    String? name,
    String? description,
    String? cuisineType,
    String? address,
    String? city,
    String? hours,
    List<double>? ratings,
    List<String>? coupons,
    List<String>? salles, // 🔹 Images des salles
    List<String>? plats,
  }) {
    return Restaurant(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      cuisineType: cuisineType ?? this.cuisineType,
      address: address ?? this.address,
      city: city ?? this.city,
      hours: hours ?? this.hours,
      ratings: ratings ?? this.ratings,
      coupons: coupons ?? this.coupons,
      salles: salles ?? this.salles, // 🔹 Images des salles
      plats: plats ?? this.plats, // 🔹 Images des plats
    );
  }
}
