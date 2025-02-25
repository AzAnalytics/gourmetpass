import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gourmetpass/providers/restaurant_provider.dart';
import 'package:gourmetpass/models/restaurant_model.dart';

class AddRestaurantScreen extends StatefulWidget {
  const AddRestaurantScreen({super.key});

  @override
  State<AddRestaurantScreen> createState() => _AddRestaurantScreenState();
}

class _AddRestaurantScreenState extends State<AddRestaurantScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController cuisineTypeController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController hoursController = TextEditingController();

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
    final adminRestaurantProvider =
    Provider.of<RestaurantProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text('Ajouter un Restaurant')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                key: const Key('restaurant_name'),
                controller: nameController,
                decoration:
                const InputDecoration(labelText: 'Nom du restaurant'),
                validator: (value) => value!.isEmpty ? 'Champ requis' : null,
              ),
              TextFormField(
                key: const Key('restaurant_description'),
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              TextFormField(
                key: const Key('restaurant_cuisine'),
                controller: cuisineTypeController,
                decoration:
                const InputDecoration(labelText: 'Type de cuisine'),
              ),
              TextFormField(
                key: const Key('restaurant_address'),
                controller: addressController,
                decoration: const InputDecoration(labelText: 'Adresse'),
              ),
              TextFormField(
                key: const Key('restaurant_hours'),
                controller: hoursController,
                decoration: const InputDecoration(labelText: 'Horaires'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                key: const Key('add_restaurant_button'),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final newRestaurant = Restaurant(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      name: nameController.text,
                      description: descriptionController.text,
                      cuisineType: cuisineTypeController.text,
                      address: addressController.text,
                      hours: hoursController.text,
                      ratings: [],
                      coupons: [],
                    );

                    // Appel du provider pour ajouter le restaurant
                    await adminRestaurantProvider.addRestaurant(newRestaurant);

                    // Vérifie si une erreur est présente dans le provider
                    if (adminRestaurantProvider.errorMessage != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          key: const Key('restaurant_error_snackbar'),
                          content: Text(
                              'Erreur lors de l\'ajout du restaurant : ${adminRestaurantProvider.errorMessage}'),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          key: Key('restaurant_success_snackbar'),
                          content: Text('Restaurant ajouté avec succès.'),
                        ),
                      );
                      // Attendre un délai pour laisser le temps au SnackBar d'apparaître
                      await Future.delayed(const Duration(milliseconds: 500));
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      }
                    }
                  }
                },
                child: const Text('Ajouter'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
