class AdminStats {
  final int totalRestaurants;
  final int totalCoupons;
  final int totalUsers;
  final int activeUsers;

  const AdminStats({
    required this.totalRestaurants,
    required this.totalCoupons,
    required this.totalUsers,
    required this.activeUsers,
  });

  /// Convertir les données Firestore en instance de `AdminStats`
  factory AdminStats.fromJson(Map<String, dynamic> json) {
    return AdminStats(
      totalRestaurants: json['totalRestaurants'] as int,
      totalCoupons: json['totalCoupons'] as int,
      totalUsers: json['totalUsers'] as int,
      activeUsers: json['activeUsers'] as int,
    );
  }

  /// Convertir une instance de `AdminStats` en format JSON pour Firestore
  Map<String, dynamic> toJson() {
    return {
      'totalRestaurants': totalRestaurants,
      'totalCoupons': totalCoupons,
      'totalUsers': totalUsers,
      'activeUsers': activeUsers,
    };
  }
}
