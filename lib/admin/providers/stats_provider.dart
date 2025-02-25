import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/stats_model.dart';

class StatsProvider with ChangeNotifier {
  final FirebaseFirestore _firestore;
  AdminStats? _stats;
  bool _isLoading = false;

  StatsProvider({FirebaseFirestore? fakeFirestore})
      : _firestore = fakeFirestore ?? FirebaseFirestore.instance;

  AdminStats? get stats => _stats;
  bool get isLoading => _isLoading;

  /// Charger les statistiques depuis Firestore
  Future<void> fetchStats() async {
    _setLoadingState(true);
    try {
      final doc = await _firestore.collection('admin_data').doc('admin_stats').get();
      if (doc.exists) {
        _stats = AdminStats.fromJson(doc.data() as Map<String, dynamic>);
      }
    } catch (e) {
      debugPrint('Erreur lors de la récupération des statistiques : $e');
    } finally {
      _setLoadingState(false);
    }
  }

  void _setLoadingState(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
