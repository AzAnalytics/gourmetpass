import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gourmetpass/providers/restaurant_provider.dart';
import 'add_restaurant_screen.dart';
import 'edit_restaurant_screen.dart';

class ListRestaurantsScreen extends StatelessWidget {
  const ListRestaurantsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final adminRestaurantProvider = Provider.of<RestaurantProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des Restaurants'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddRestaurantScreen()),
              );
            },
          ),
        ],
      ),
      body: adminRestaurantProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : adminRestaurantProvider.restaurants.isEmpty
          ? const Center(child: Text('Aucun restaurant disponible.'))
          : ListView.builder(
        itemCount: adminRestaurantProvider.restaurants.length,
        itemBuilder: (context, index) {
          final restaurant = adminRestaurantProvider.restaurants[index];
          return ListTile(
            title: Text(restaurant.name),
            subtitle: Text(restaurant.cuisineType),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
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
                  icon: const Icon(Icons.delete),
                  onPressed: () async {
                    await adminRestaurantProvider.deleteRestaurant(restaurant.id);

                    if (!context.mounted) return; // Vérifie si le widget est toujours monté

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Restaurant "${restaurant.name}" supprimé.')),
                    );
                  },
                )
                ,
              ],
            ),
          );
        },
      ),
    );
  }
}
