/*import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/restaurant_model.dart';
import 'package:logger/logger.dart';

class RestaurantProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore;
  final logger = Logger();

  List<Restaurant> _restaurants = [];
  bool _isLoading = false;
  String? _errorMessage; // Propriété pour stocker le message d'erreur

  RestaurantProvider({FirebaseFirestore? fakeFirestore})
      : _firestore = fakeFirestore ?? FirebaseFirestore.instance;

  List<Restaurant> get restaurants => _restaurants;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage; // Getter pour récupérer l'erreur

  /// Charger les restaurants depuis Firestore
  Future<void> fetchRestaurants() async {
    _setLoadingState(true);
    try {
      final QuerySnapshot snapshot =
      await _firestore.collection('restaurants').get();
      _restaurants = snapshot.docs
          .map((doc) => Restaurant.fromJson(doc.data() as Map<String, dynamic>)
          .copyWith(id: doc.id)) // Assigner l'ID Firestore
          .toList();
    } catch (e) {
      logger.e('Erreur lors de la récupération des restaurants', error: e);
      _restaurants = [];
    } finally {
      _setLoadingState(false);
    }
  }

  /// 🔹 Ajouter un restaurant
  Future<void> addRestaurant(Restaurant restaurant) async {
    _setLoadingState(true);
    try {
      final docRef =
      await _firestore.collection('restaurants').add(restaurant.toJson());
      _restaurants.add(restaurant.copyWith(id: docRef.id)); // Assigner l'ID généré
      notifyListeners();
    } catch (e) {
      logger.e('Erreur lors de l\'ajout du restaurant', error: e);
      // Vous pouvez utiliser setErrorState ici pour notifier l'erreur.
      setErrorState('Erreur lors de l\'ajout du restaurant');
    } finally {
      _setLoadingState(false);
    }
  }

  /// 🔹 Supprimer un restaurant
  Future<void> deleteRestaurant(String restaurantId) async {
    _setLoadingState(true);
    try {
      await _firestore.collection('restaurants').doc(restaurantId).delete();
      _restaurants.removeWhere((restaurant) => restaurant.id == restaurantId);
      notifyListeners();
    } catch (e) {
      logger.e('Erreur lors de la suppression du restaurant', error: e);
    } finally {
      _setLoadingState(false);
    }
  }

  /// 🔹 Mettre à jour un restaurant
  Future<void> updateRestaurant(Restaurant updatedRestaurant) async {
    _setLoadingState(true);
    try {
      await _firestore
          .collection('restaurants')
          .doc(updatedRestaurant.id)
          .update(updatedRestaurant.toJson());
      _restaurants = _restaurants
          .map((restaurant) => restaurant.id == updatedRestaurant.id
          ? updatedRestaurant
          : restaurant)
          .toList();
      notifyListeners();
    } catch (e) {
      logger.e('Erreur lors de la mise à jour du restaurant', error: e);
    } finally {
      _setLoadingState(false);
    }
  }

  /// Simuler l'état de chargement pour les tests
  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  /// Définir des restaurants personnalisés pour les tests
  void setRestaurants(List<Restaurant> restaurants) {
    _restaurants = restaurants;
    notifyListeners();
  }

  /// Déconnexion (vider les données)
  void logout() {
    _restaurants = [];
    notifyListeners();
  }

  /// Définir l'état de chargement et notifier les widgets abonnés
  void _setLoadingState(bool value) {
    _isLoading = value;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  /// Méthode pour définir un message d'erreur dans le provider
  void setErrorState(String errorMessage) {
    _errorMessage = errorMessage;
    notifyListeners();
    Future.delayed(const Duration(milliseconds: 300));
  }
}*/

import 'package:flutter/material.dart';
import '../models/restaurant_model.dart';

class RestaurantProvider with ChangeNotifier {
  final List<Restaurant> _restaurants = [
    Restaurant(
      id: 'restaurant_1',
      name: 'Le Gourmet Français',
      description: 'Un restaurant français avec une cuisine raffinée',
      cuisineType: 'Française',
      address: '10 Rue de Paris',
      city: 'Paris',
      hours: '12:00 - 23:00',
      ratings: [5.0, 4.5, 4.8],
      coupons: ['coupon_1'],
      salles: [
        'assets/images/salles/restaurant_1.png',
      ], // ✅ Ajout des images des salles
      plats: [
        'assets/images/plats/plat_1.jpg',
        'assets/images/plats/plat_2.jpg',
      ], // ✅ Ajout des images des plats
    ),
    Restaurant(
      id: 'restaurant_2',
      name: 'Pasta Bella',
      description: 'Le meilleur des pâtes italiennes',
      cuisineType: 'Italienne',
      address: '25 Avenue de Rome',
      city: "Rome",
      hours: '11:30 - 22:00',
      ratings: [4.0, 4.2, 3.8],
      coupons: ['coupon_2'],
      salles: [
        'assets/images/salles/restaurant_2.png',
      ], // ✅ Ajout des images des salles
      plats: [
        'assets/images/plats/plat_3.jpg',
        'assets/images/plats/plat_4.jpg',
      ], // ✅ Ajout des images des plats
    ),
  ];

  List<Restaurant> get restaurants => List.unmodifiable(_restaurants);

  /// 🔹 Ajouter un restaurant (en local)
  Future<void> addRestaurant(Restaurant restaurant) async {
    final newRestaurant = restaurant.copyWith(
      id: 'restaurant_${_restaurants.length + 1}',
      salles: [
        'assets/images/salles/salle${_restaurants.length + 1}_1.jpg',
        'assets/images/salles/salle${_restaurants.length + 1}_2.jpg',
        'assets/images/salles/salle${_restaurants.length + 1}_3.jpg'
      ], // 🔹 Générer dynamiquement les images des salles
      plats: [
        'assets/images/plats/plat${_restaurants.length + 1}_1.jpg',
        'assets/images/plats/plat${_restaurants.length + 1}_2.jpg',
        'assets/images/plats/plat${_restaurants.length + 1}_3.jpg'
      ], // 🔹 Générer dynamiquement les images des plats
    );
    _restaurants.add(newRestaurant);
    notifyListeners();
  }

  /// 🔹 Mettre à jour un restaurant (en local)
  Future<void> updateRestaurant(Restaurant updatedRestaurant) async {
    int index = _restaurants.indexWhere((r) => r.id == updatedRestaurant.id);
    if (index != -1) {
      _restaurants[index] = updatedRestaurant;
      notifyListeners();
    }
  }

  /// 🔹 Supprimer un restaurant (en local)
  Future<void> deleteRestaurant(String restaurantId) async {
    _restaurants.removeWhere((restaurant) => restaurant.id == restaurantId);
    notifyListeners();
  }
}
