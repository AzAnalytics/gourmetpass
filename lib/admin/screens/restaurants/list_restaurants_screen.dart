import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gourmetpass/providers/restaurant_provider.dart';
import 'package:gourmetpass/admin/screens/restaurants/edit_restaurant_screen.dart';
import 'package:gourmetpass/admin/screens/restaurants/delete_restaurant_screen.dart';

class ListRestaurantsScreen extends StatelessWidget {
  const ListRestaurantsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final restaurantProvider = Provider.of<RestaurantProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Liste des Restaurants"),
        backgroundColor: Colors.orange,
      ),
      body: FutureBuilder(
        future: restaurantProvider.fetchRestaurants(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (restaurantProvider.restaurants.isEmpty) {
            return const Center(
              child: Text(
                "Aucun restaurant disponible.",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: restaurantProvider.restaurants.length,
            itemBuilder: (context, index) {
              final restaurant = restaurantProvider.restaurants[index];

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  leading: CircleAvatar(
                    backgroundImage: restaurant.salles.isNotEmpty
                        ? NetworkImage(restaurant.salles.first) // ✅ Prend la première image de la salle
                        : null,
                    backgroundColor: Colors.orange.shade100,
                    child: restaurant.salles.isEmpty
                        ? const Icon(Icons.image, color: Colors.orange) // 🔹 Icône si pas d'image
                        : null,
                  ),
                  title: Text(
                    restaurant.name,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(restaurant.address),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditRestaurantScreen(restaurant: restaurant),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => DeleteRestaurantScreen(restaurant: restaurant),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );

            },
          );
        },
      ),
    );
  }
}
