import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gourmetpass/models/restaurant_model.dart';

class RestaurantProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<RestaurantModel> _restaurants = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<RestaurantModel> get restaurants => _restaurants;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// 🔹 Récupérer tous les restaurants depuis Firestore
  Future<void> fetchRestaurants() async {
    _setLoading(true);
    try {
      final snapshot = await _firestore.collection('restaurants').get();
      _restaurants = snapshot.docs
          .map((doc) => RestaurantModel.fromJson(doc.data()))
          .toList();

      notifyListeners();
    } catch (e) {
      _errorMessage = "Erreur lors de la récupération des restaurants.";
      debugPrint("❌ fetchRestaurants() : $e");
    } finally {
      _setLoading(false);
    }
  }

  /// 🔹 Ajouter un restaurant
  Future<void> addRestaurant(RestaurantModel restaurant) async {
    _setLoading(true);
    try {
      final docRef = _firestore.collection('restaurants').doc(); // Firestore génère un ID
      final restaurantWithId = restaurant.copyWith(id: docRef.id);

      await docRef.set(restaurantWithId.toJson());
      _restaurants.add(restaurantWithId);
      notifyListeners();
    } catch (e) {
      _errorMessage = "Erreur lors de l'ajout du restaurant.";
      debugPrint("❌ addRestaurant() : $e");
    } finally {
      _setLoading(false);
    }
  }

  /// 🔹 Mettre à jour un restaurant
  Future<void> updateRestaurant(RestaurantModel updatedRestaurant) async {
    _setLoading(true);
    try {
      await _firestore
          .collection('restaurants')
          .doc(updatedRestaurant.id)
          .update(updatedRestaurant.toJson());

      int index = _restaurants.indexWhere((r) => r.id == updatedRestaurant.id);
      if (index != -1) {
        _restaurants[index] = updatedRestaurant;
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = "Erreur lors de la mise à jour du restaurant.";
      debugPrint("❌ updateRestaurant() : $e");
    } finally {
      _setLoading(false);
    }
  }

  /// 🔹 Supprimer un restaurant
  Future<void> deleteRestaurant(String restaurantId) async {
    _setLoading(true);
    try {
      await _firestore.collection('restaurants').doc(restaurantId).delete();
      _restaurants.removeWhere((r) => r.id == restaurantId);
      notifyListeners();
    } catch (e) {
      _errorMessage = "Erreur lors de la suppression du restaurant.";
      debugPrint("❌ deleteRestaurant() : $e");
    } finally {
      _setLoading(false);
    }
  }

  /// 🔹 Gérer l'état de chargement
  void _setLoading(bool value) {
    if (_isLoading != value) {
      _isLoading = value;
      notifyListeners();
    }
  }
}
