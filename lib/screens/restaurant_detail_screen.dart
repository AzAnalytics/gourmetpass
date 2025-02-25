/*import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/restaurant_provider.dart';
import '../providers/coupon_provider.dart';

class RestaurantDetailScreen extends StatefulWidget {
  final String restaurantId;

  const RestaurantDetailScreen({super.key, required this.restaurantId});

  @override
  State<RestaurantDetailScreen> createState() => _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState extends State<RestaurantDetailScreen> {
  late Future<void> _future;

  @override
  void initState() {
    super.initState();
    debugPrint('Restaurant ID reçu : ${widget.restaurantId}');
    _future = _fetchData();
  }

  Future<void> _fetchData() async {
    final restaurantProvider = Provider.of<RestaurantProvider>(context, listen: false);
    final couponProvider = Provider.of<CouponProvider>(context, listen: false);

    try {
      // Charger les restaurants si nécessaire
      if (restaurantProvider.restaurants.isEmpty) {
        debugPrint('Chargement des restaurants...');
        await restaurantProvider.fetchRestaurants();
        debugPrint('Restaurants disponibles : ${restaurantProvider.restaurants.map((r) => r.name).toList()}');
      }

      // Charger les coupons si nécessaire
      if (couponProvider.coupons.isEmpty ||
          !couponProvider.coupons.any((coupon) => coupon.restaurantId == widget.restaurantId)) {
        debugPrint('Chargement des coupons pour le restaurant ${widget.restaurantId}...');
        await couponProvider.fetchCoupons(widget.restaurantId);
        debugPrint('Coupons chargés pour le restaurant ${widget.restaurantId} : ${couponProvider.coupons.map((c) => c.description).toList()}');
      }
    } catch (e, stackTrace) {
      debugPrint('Erreur lors du chargement des données : $e');
      debugPrint('Stack trace : $stackTrace');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails du Restaurant'),
      ),
      body: FutureBuilder<void>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('Erreur : ${snapshot.error}', textAlign: TextAlign.center),
              ),
            );
          }

          return _buildContent(context);
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final restaurantProvider = Provider.of<RestaurantProvider>(context, listen: false);

    // Vérifiez si les restaurants ont été chargés
    if (restaurantProvider.restaurants.isEmpty) {
      debugPrint('Aucun restaurant trouvé après le chargement.');
      return const Center(
        child: Text('Aucun restaurant trouvé.'),
      );
    }

    // Récupérer le restaurant correspondant
    final restaurant = restaurantProvider.restaurants.firstWhere(
          (r) => r.id == widget.restaurantId,
      orElse: () {
        debugPrint('Restaurant introuvable avec ID : ${widget.restaurantId}');
        throw Exception("Restaurant introuvable");
      },
    );

    debugPrint('Nom du restaurant affiché dans _buildContent : ${restaurant.name}');

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  restaurant.name,
                  key: const Key('restaurant_name'),
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  restaurant.description,
                  key: const Key('restaurant_description'),
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                ),
                const SizedBox(height: 16),
                Text(
                  'Type de cuisine : ${restaurant.cuisineType}',
                  key: const Key('restaurant_cuisine_type'),
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(
                  'Adresse : ${restaurant.address}',
                  key: const Key('restaurant_address'),
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(
                  'Horaires : ${restaurant.hours}',
                  key: const Key('restaurant_hours'),
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          // Section Coupons
          Consumer<CouponProvider>(
            builder: (context, couponProvider, child) {
              debugPrint('Coupons affichés dans Consumer : ${couponProvider.coupons.map((c) => c.description).toList()}');

              if (couponProvider.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (couponProvider.coupons.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('Aucun coupon disponible.'),
                  ),
                );
              }

              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: couponProvider.coupons.length,
                itemBuilder: (context, index) {
                  final coupon = couponProvider.coupons[index];

                  return Card(
                    key: ValueKey(coupon.id), // Clé unique
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ListTile(
                      title: Text(coupon.description),
                      subtitle: Text(
                        '${coupon.discountPercentage}% de réduction pour ${coupon.maxPeople} personnes',
                      ),
                      trailing: ElevatedButton(
                        onPressed: coupon.isUsed
                            ? null
                            : () async {
                          final success = await couponProvider.validateCoupon(
                            widget.restaurantId,
                            coupon.id,
                          );

                          if (!context.mounted) return;

                          final message = success
                              ? 'Coupon utilisé avec succès!'
                              : 'Erreur : Ce coupon a déjà été utilisé.';

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(message)),
                          );
                        },
                        child: Text(coupon.isUsed ? 'Utilisé' : 'Utiliser'),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}*/
import 'package:flutter/material.dart';
import 'dart:math';

class RestaurantDetailScreen extends StatefulWidget {
  final String restaurantId;

  const RestaurantDetailScreen({super.key, required this.restaurantId});

  @override
  State<RestaurantDetailScreen> createState() => _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState extends State<RestaurantDetailScreen> {
  int _currentIndex = 0; // 🔹 Index du carrousel

  /// 🔹 Fonction pour générer un code unique aléatoire (6 caractères)
  String generateUniqueCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    return List.generate(
      6,
      (index) => chars[random.nextInt(chars.length)],
    ).join();
  }

 /// 🔹 Dummy Data avec images des plats et coupons
static final List<Map<String, dynamic>> dummyRestaurants = [
  {
    'id': '1',
    'name': 'La Belle Vue',
    'description': 'Restaurant gastronomique avec une vue magnifique.',
    'cuisineType': 'Française',
    'address': '12 Rue des Champs',
    'city': 'Paris',
    'hours': '12:00 - 22:00',
    'plats': [
      'assets/images/plats/plat_1.jpg',
      'assets/images/plats/plat_2.jpg',
    ],
    'coupons': [
      {
        'id': 'C101',
        'description': '10% de réduction',
        'maxPeople': 2,
        'isUsed': false,
        'uniqueCode': '',
      },
      {
        'id': 'C102',
        'description': 'Dessert offert',
        'maxPeople': 1,
        'isUsed': false,
        'uniqueCode': '',
      },
    ],
  },
  {
    'id': '2',
    'name': 'Pasta Bella',
    'description': 'Cuisine italienne traditionnelle avec des produits frais.',
    'cuisineType': 'Italienne',
    'address': '45 Avenue Roma',
    'city': 'Lyon',
    'hours': '11:30 - 23:00',
    'plats': [
      'assets/images/plats/plat_3.jpg',
      'assets/images/plats/plat_4.jpg',
    ],
    'coupons': [
      {
        'id': 'C201',
        'description': '-15% sur le menu',
        'maxPeople': 3,
        'isUsed': false,
        'uniqueCode': '',
      },
    ],
  },
  {
    'id': '3',
    'name': 'Sushi Zen',
    'description': 'Le meilleur sushi de la ville !',
    'cuisineType': 'Japonaise',
    'address': '8 Rue du Soleil',
    'city': 'Marseille', // 🔹 Ville ajoutée
    'hours': '18:00 - 23:30',
    'plats': [
      'assets/images/plats/sushi_1.jpg',
      'assets/images/plats/sushi_2.jpg',
    ],
    'coupons': [
      {
        'id': 'C301',
        'description': '5€ de réduction sur une commande de 30€',
        'maxPeople': 2,
        'isUsed': false,
        'uniqueCode': '',
      },
      {
        'id': 'C302',
        'description': 'Boisson offerte pour un plateau de sushi',
        'maxPeople': 1,
        'isUsed': false,
        'uniqueCode': '',
      },
    ],
  },
];
  @override
  void initState() {
    super.initState();
    // 🔹 Générer des codes uniques pour chaque coupon au démarrage
    for (var restaurant in dummyRestaurants) {
      for (var coupon in restaurant['coupons']) {
        if (coupon['uniqueCode'] == '') {
          coupon['uniqueCode'] = generateUniqueCode();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final restaurant = dummyRestaurants.firstWhere(
      (r) => r['id'] == widget.restaurantId,
      orElse: () => {},
    );

    if (restaurant.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Erreur')),
        body: const Center(child: Text('Restaurant introuvable. En cours de rédaction')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          restaurant['name'],
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Informations du restaurant
            _buildRestaurantInfo(restaurant),

            // 🔹 Section Coupons
            _buildCouponsSection(restaurant['coupons']),

            // 🔹 Carrousel des plats
            _buildImageCarousel(restaurant['plats']),
          ],
        ),
      ),
    );
  }

  /// 🔹 Affichage des informations du restaurant
  Widget _buildRestaurantInfo(Map<String, dynamic> restaurant) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.center, // 🔥 Centre tout horizontalement
            children: [
              Text(
                restaurant['name'],
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                restaurant['description'],
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
              const SizedBox(height: 12),
              Text(
                '🍽 Cuisine : ${restaurant['cuisineType']}',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              Text(
                '📍 Adresse : ${restaurant['address']}',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),

              // 🔹 Ligne avec l'icône de ville (elle reste alignée à gauche pour un bon rendu)
              Row(
                mainAxisAlignment:
                    MainAxisAlignment
                        .center, // 🔥 Centre la ligne horizontalement
                children: [
                  const Icon(
                    Icons.location_city,
                    size: 20,
                    color: Colors.orange,
                  ), // Icône ville
                  const SizedBox(
                    width: 8,
                  ), // Espacement entre l'icône et le texte
                  Text(
                    restaurant['city'] ?? 'Ville inconnue',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),

              Text(
                '⏰ Horaires : ${restaurant['hours']}',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 🔹 Affichage des coupons disponibles
  Widget _buildCouponsSection(List<Map<String, dynamic>> coupons) {
    if (coupons.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(child: Text('Aucun coupon disponible.')),
      );
    }

    return Column(
      children:
          coupons.map((coupon) {
            return Card(
              key: ValueKey(coupon['id']),
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: ListTile(
                title: Text(coupon['description']),
                subtitle: Text(
                  'Code : ${coupon['uniqueCode']}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                trailing: ElevatedButton(
                  onPressed:
                      coupon['isUsed']
                          ? null
                          : () {
                            setState(() {
                              coupon['isUsed'] = true;
                            });

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "Coupon utilisé avec succès! Code : ${coupon['uniqueCode']}",
                                ),
                              ),
                            );
                          },
                  child: Text(coupon['isUsed'] ? 'Utilisé' : 'Utiliser'),
                ),
              ),
            );
          }).toList(),
    );
  }

  /// 🔹 Carrousel des images des plats
  Widget _buildImageCarousel(List<String> plats) {
    return Column(
      children: [
        SizedBox(
          height: 220,
          child: PageView.builder(
            itemCount: plats.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  _showFullImage(plats[index]); // 🔹 Afficher en plein écran
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.asset(
                    plats[index],
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        _buildImageIndicator(plats.length),
      ],
    );
  }

  /// 🔹 Indicateurs sous le carrousel
  Widget _buildImageIndicator(int length) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(length, (index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: _currentIndex == index ? 12 : 8,
          height: _currentIndex == index ? 12 : 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _currentIndex == index ? Colors.orange : Colors.grey,
          ),
        );
      }),
    );
  }

  /// 🔹 Afficher une image en plein écran
  void _showFullImage(String imagePath) {
    showDialog(
      context: context,
      builder:
          (_) => Dialog(
            backgroundColor: Colors.black,
            child: InteractiveViewer(
              child: Image.asset(imagePath, fit: BoxFit.contain),
            ),
          ),
    );
  }
}
