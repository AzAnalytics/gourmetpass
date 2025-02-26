import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gourmetpass/providers/restaurant_provider.dart';
import 'package:gourmetpass/models/restaurant_model.dart';

class DeleteRestaurantScreen extends StatelessWidget {
  final RestaurantModel restaurant;

  const DeleteRestaurantScreen({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    final restaurantProvider = Provider.of<RestaurantProvider>(context, listen: false);
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Supprimer un restaurant"),
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.warning, size: 80, color: Colors.red),
            const SizedBox(height: 20),
            Text(
              "Êtes-vous sûr de vouloir supprimer \"${restaurant.name}\" ?",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton.icon(
                  key: const Key('cancel_delete_restaurant'),
                  icon: const Icon(Icons.cancel, color: Colors.grey),
                  label: const Text('Annuler', style: TextStyle(color: Colors.grey)),
                  onPressed: () => navigator.pop(),
                ),
                FilledButton.icon(
                  key: const Key('confirm_delete_restaurant'),
                  icon: const Icon(Icons.delete, color: Colors.white),
                  label: const Text("Supprimer"),
                  style: FilledButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: () async {
                    await restaurantProvider.deleteRestaurant(restaurant.id);

                    messenger.showSnackBar(
                      SnackBar(
                        key: const Key('delete_restaurant_success_snackbar'),
                        content: Text('Restaurant "${restaurant.name}" supprimé avec succès.'),
                        backgroundColor: Colors.green,
                      ),
                    );

                    await Future.delayed(const Duration(milliseconds: 500));
                    if (navigator.canPop()) navigator.pop();
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
