import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/restaurant_provider.dart';
import '../../../models/restaurant_model.dart';

class DeleteRestaurantScreen extends StatelessWidget {
  final Restaurant restaurant;

  const DeleteRestaurantScreen({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    final adminRestaurantProvider =
    Provider.of<RestaurantProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text('Supprimer un Restaurant')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Voulez-vous vraiment supprimer le restaurant "${restaurant.name}" ?',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Text('Adresse: ${restaurant.address}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('Type de cuisine: ${restaurant.cuisineType}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('Horaires: ${restaurant.hours}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  key: const Key('delete_restaurant_cancel_button'),
                  icon: const Icon(Icons.cancel),
                  label: const Text('Annuler'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                ElevatedButton.icon(
                  key: const Key('delete_restaurant_confirm_button'),
                  icon: const Icon(Icons.delete),
                  label: const Text('Supprimer'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: () async {
                    await adminRestaurantProvider.deleteRestaurant(restaurant.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        key: const Key('delete_restaurant_success_snackbar'),
                        content: Text('Restaurant "${restaurant.name}" supprimé avec succès.'),
                      ),
                    );
                    // Attendre 500 ms pour que le SnackBar reste visible lors des tests
                    await Future.delayed(const Duration(milliseconds: 500));
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
