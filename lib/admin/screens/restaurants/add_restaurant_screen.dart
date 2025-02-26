import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gourmetpass/models/restaurant_model.dart';
import 'package:gourmetpass/providers/restaurant_provider.dart';

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
  final TextEditingController cityController = TextEditingController();
  final TextEditingController hoursController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    cuisineTypeController.dispose();
    addressController.dispose();
    cityController.dispose();
    hoursController.dispose();
    super.dispose();
  }

  Future<void> _addRestaurant() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);
    final restaurantProvider = Provider.of<RestaurantProvider>(context, listen: false);
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    final newRestaurant = RestaurantModel(
      id: '', // Firestore Auto-ID (géré dans `addRestaurant`)
      name: nameController.text.trim(),
      description: descriptionController.text.trim(),
      cuisineType: cuisineTypeController.text.trim(),
      address: addressController.text.trim(),
      city: cityController.text.trim(),
      hours: hoursController.text.trim(),
      ratings: [],
      coupons: [],
      salles: [],
      plats: [],
    );

    try {
      await restaurantProvider.addRestaurant(newRestaurant);

      messenger.showSnackBar(
        const SnackBar(
          content: Text('✅ Restaurant ajouté avec succès !'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );

      await Future.delayed(const Duration(milliseconds: 500));

      if (navigator.canPop()) navigator.pop();
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(
          content: Text('❌ Erreur : ${e.toString()}'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ajouter un Restaurant"),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Nom du Restaurant"),
                validator: (value) => value!.isEmpty ? "Champ obligatoire" : null,
              ),
              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: "Description"),
                validator: (value) => value!.isEmpty ? "Champ obligatoire" : null,
              ),
              TextFormField(
                controller: cuisineTypeController,
                decoration: const InputDecoration(labelText: "Type de Cuisine"),
                validator: (value) => value!.isEmpty ? "Champ obligatoire" : null,
              ),
              TextFormField(
                controller: addressController,
                decoration: const InputDecoration(labelText: "Adresse"),
                validator: (value) => value!.isEmpty ? "Champ obligatoire" : null,
              ),
              TextFormField(
                controller: cityController,
                decoration: const InputDecoration(labelText: "Ville"),
                validator: (value) => value!.isEmpty ? "Champ obligatoire" : null,
              ),
              TextFormField(
                controller: hoursController,
                decoration: const InputDecoration(labelText: "Horaires d'ouverture"),
                validator: (value) => value!.isEmpty ? "Champ obligatoire" : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: isLoading ? null : _addRestaurant,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Ajouter", style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
