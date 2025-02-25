import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gourmetpass/providers/restaurant_provider.dart';
import 'package:gourmetpass/models/restaurant_model.dart';

class EditRestaurantScreen extends StatefulWidget {
  final Restaurant restaurant;

  const EditRestaurantScreen({super.key, required this.restaurant});

  @override
  State<EditRestaurantScreen> createState() => _EditRestaurantScreenState();
}

class _EditRestaurantScreenState extends State<EditRestaurantScreen> {
  late TextEditingController nameController;
  late TextEditingController descriptionController;
  late TextEditingController cuisineTypeController;
  late TextEditingController addressController;
  late TextEditingController hoursController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.restaurant.name);
    descriptionController = TextEditingController(text: widget.restaurant.description);
    cuisineTypeController = TextEditingController(text: widget.restaurant.cuisineType);
    addressController = TextEditingController(text: widget.restaurant.address);
    hoursController = TextEditingController(text: widget.restaurant.hours);
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    cuisineTypeController.dispose();
    addressController.dispose();
    hoursController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final adminRestaurantProvider = Provider.of<RestaurantProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text('Modifier un Restaurant')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Nom')),
            TextField(controller: descriptionController, decoration: const InputDecoration(labelText: 'Description')),
            TextField(controller: cuisineTypeController, decoration: const InputDecoration(labelText: 'Cuisine')),
            TextField(controller: addressController, decoration: const InputDecoration(labelText: 'Adresse')),
            TextField(controller: hoursController, decoration: const InputDecoration(labelText: 'Horaires')),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final updatedRestaurant = widget.restaurant.copyWith(
                  name: nameController.text,
                  description: descriptionController.text,
                  cuisineType: cuisineTypeController.text,
                  address: addressController.text,
                  hours: hoursController.text,
                );

                await adminRestaurantProvider.updateRestaurant(updatedRestaurant);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Restaurant mis à jour avec succès.')),
                );

                // Attendre 500 ms pour laisser le temps au SnackBar d'être affiché
                await Future.delayed(const Duration(milliseconds: 500));
                Navigator.pop(context);
              },
              child: const Text('Modifier'),
            ),
          ],
        ),
      ),
    );
  }
}
