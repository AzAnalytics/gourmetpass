import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gourmetpass/providers/restaurant_provider.dart';
import 'package:gourmetpass/models/restaurant_model.dart';

class EditRestaurantScreen extends StatefulWidget {
  final RestaurantModel restaurant;

  const EditRestaurantScreen({super.key, required this.restaurant});

  @override
  State<EditRestaurantScreen> createState() => _EditRestaurantScreenState();
}

class _EditRestaurantScreenState extends State<EditRestaurantScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController descriptionController;
  late TextEditingController cuisineTypeController;
  late TextEditingController addressController;
  late TextEditingController cityController;
  late TextEditingController hoursController;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.restaurant.name);
    descriptionController = TextEditingController(text: widget.restaurant.description);
    cuisineTypeController = TextEditingController(text: widget.restaurant.cuisineType);
    addressController = TextEditingController(text: widget.restaurant.address);
    cityController = TextEditingController(text: widget.restaurant.city);
    hoursController = TextEditingController(text: widget.restaurant.hours);
  }

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

  Future<void> _updateRestaurant() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);
    final restaurantProvider = Provider.of<RestaurantProvider>(context, listen: false);
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    final updatedRestaurant = widget.restaurant.copyWith(
      name: nameController.text.trim(),
      description: descriptionController.text.trim(),
      cuisineType: cuisineTypeController.text.trim(),
      address: addressController.text.trim(),
      city: cityController.text.trim(),
      hours: hoursController.text.trim(),
    );

    try {
      await restaurantProvider.updateRestaurant(updatedRestaurant);

      messenger.showSnackBar(
        const SnackBar(
          content: Text('✅ Restaurant mis à jour avec succès !'),
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
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Modifier un restaurant"),
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
                decoration: const InputDecoration(labelText: "Nom du restaurant"),
                validator: (value) => value == null || value.isEmpty ? "Ce champ est requis" : null,
              ),
              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: "Description"),
              ),
              TextFormField(
                controller: cuisineTypeController,
                decoration: const InputDecoration(labelText: "Type de cuisine"),
              ),
              TextFormField(
                controller: addressController,
                decoration: const InputDecoration(labelText: "Adresse"),
              ),
              TextFormField(
                controller: cityController,
                decoration: const InputDecoration(labelText: "Ville"),
              ),
              TextFormField(
                controller: hoursController,
                decoration: const InputDecoration(labelText: "Horaires"),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Enregistrer"),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                onPressed: isLoading ? null : _updateRestaurant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
