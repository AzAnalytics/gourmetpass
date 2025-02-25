/*import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/restaurant_provider.dart';
import 'restaurant_detail_screen.dart';

class RestaurantListScreen extends StatelessWidget {
  const RestaurantListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GourmetPass'),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              // Déconnexion et retour à l'écran de connexion
              Provider.of<RestaurantProvider>(context, listen: false).logout();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: Consumer<RestaurantProvider>(
        builder: (context, restaurantProvider, child) {
          if (restaurantProvider.isLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (restaurantProvider.restaurants.isEmpty) {
            return Center(
              child: Text('Aucun restaurant trouvé.'),
            );
          }

          return ListView.builder(
            itemCount: restaurantProvider.restaurants.length,
            itemBuilder: (context, index) {
              final restaurant = restaurantProvider.restaurants[index];
              return ListTile(
                leading: Icon(Icons.restaurant),
                title: Text(restaurant.name),
                subtitle: Text(restaurant.cuisineType),
                trailing: Icon(Icons.arrow_forward),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          RestaurantDetailScreen(restaurantId: restaurant.id),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}*/

import 'package:flutter/material.dart';
import 'restaurant_detail_screen.dart';

class RestaurantListScreen extends StatefulWidget {
  const RestaurantListScreen({super.key});

  @override
  State<RestaurantListScreen> createState() => _RestaurantListScreenState();
}

class _RestaurantListScreenState extends State<RestaurantListScreen> {
  String? selectedCity; // 🔹 Ville sélectionnée pour filtrer les restaurants

  // 🔹 Données statiques avec valeurs réelles pour `city`
  static final List<Map<String, dynamic>> dummyRestaurants = [
    {
      'id': '1',
      'name': 'La Belle Vue',
      'description': 'Un excellent restaurant avec une ambiance agréable.',
      'cuisineType': 'Française',
      'address': '12 Rue des Champs',
      'city': 'Paris', // 🔹 Ville réelle
      'hours': '12:00 - 22:00',
      'ratings': [4.5, 4.0, 5.0],
      'salles': 'assets/images/salles/restaurant_1.png',
    },
    {
      'id': '2',
      'name': 'Pasta Bella',
      'description': 'Spécialités italiennes avec des produits frais.',
      'cuisineType': 'Italienne',
      'address': '45 Avenue Roma',
      'city': 'Lyon', // 🔹 Ville réelle
      'hours': '11:30 - 23:00',
      'ratings': [4.2, 4.3, 4.8],
      'salles': 'assets/images/salles/restaurant_2.png',
    },
    {
      'id': '3',
      'name': 'Sushi Zen',
      'description': 'Le meilleur sushi de la ville !',
      'cuisineType': 'Japonaise',
      'address': '8 Rue du Soleil',
      'city': 'Marseille', // 🔹 Ville réelle
      'hours': '18:00 - 23:30',
      'ratings': [4.7, 4.9, 5.0],
      'salles': 'assets/images/salles/restaurant_3.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    // 🔹 Extraire les villes uniques
    List cities = dummyRestaurants.map((r) => r['city']).toSet().toList();

    // 🔹 Filtrer les restaurants selon la ville sélectionnée
    List<Map<String, dynamic>> filteredRestaurants = selectedCity == null
        ? dummyRestaurants
        : dummyRestaurants.where((r) => r['city'] == selectedCity).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'GourmetPass',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true, // 🔹 Centrer le titre
        backgroundColor: Colors.orange,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.location_city), // 🔹 Icône pour afficher les villes
            onPressed: () => _showCitySelector(context, cities.cast<String>()),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: GridView.builder(
          itemCount: filteredRestaurants.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 🔹 Deux colonnes
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.8, // 🔹 Ajustement de la hauteur des cartes
          ),
          itemBuilder: (context, index) {
            final restaurant = filteredRestaurants[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        RestaurantDetailScreen(restaurantId: restaurant['id']),
                  ),
                );
              },
              child: Card(
                key: ValueKey(restaurant['id']),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 4, // 🔹 Effet d'ombre pour un design plus pro
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // 🔹 Image du restaurant avec Hero animation
                    Expanded(
                      child: Hero(
                        tag: 'restaurant_${restaurant['id']}',
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                          child: Image.asset(
                            restaurant['salles'],
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            restaurant['name'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            restaurant['cuisineType'],
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  /// 🔹 Affiche une liste des villes dans un `BottomSheet`
  void _showCitySelector(BuildContext context, List<String> cities) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.clear),
              title: const Text("Toutes les villes"),
              onTap: () {
                setState(() {
                  selectedCity = null; // 🔹 Afficher tous les restaurants
                });
                Navigator.pop(context);
              },
            ),
            const Divider(),
            ...cities.map((city) => ListTile(
                  leading: const Icon(Icons.location_on),
                  title: Text(city),
                  onTap: () {
                    setState(() {
                      selectedCity = city; // 🔹 Filtrer par ville sélectionnée
                    });
                    Navigator.pop(context);
                  },
                )),
          ],
        );
      },
    );
  }
}
