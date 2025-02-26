import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gourmetpass/providers/coupon_provider.dart';
import 'package:gourmetpass/models/coupon_model.dart';

class AddCouponScreen extends StatefulWidget {
  const AddCouponScreen({super.key});

  @override
  State<AddCouponScreen> createState() => _AddCouponScreenState();
}

class _AddCouponScreenState extends State<AddCouponScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController discountController = TextEditingController();
  final TextEditingController maxPeopleController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    descriptionController.dispose();
    discountController.dispose();
    maxPeopleController.dispose();
    super.dispose();
  }

  Future<void> _addCoupon() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final couponProvider = Provider.of<CouponProvider>(context, listen: false);
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    try {
      const restaurantId = "some_restaurant_id"; // ✅ Remplace par l'ID réel du restaurant

      final newCoupon = CouponModel(
        id: '', // L'ID sera généré par Firestore
        restaurantId: restaurantId,
        description: descriptionController.text.trim(),
        discountPercentage: int.parse(discountController.text.trim()),
        maxPeople: int.parse(maxPeopleController.text.trim()),
        isActive: true,
        uniqueCode: '', // Généré ultérieurement si nécessaire
        createdAt: DateTime.now(),
        usedAt: null, // 🔥 Par défaut, le coupon n'a pas été utilisé
      );

      await couponProvider.addCoupon(restaurantId, newCoupon);

      messenger.showSnackBar(
        const SnackBar(
          content: Text('✅ Coupon ajouté avec succès !'),
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
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ajouter un Coupon"),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: "Description du coupon"),
                validator: (value) => value == null || value.isEmpty ? "Ce champ est requis" : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: discountController,
                decoration: const InputDecoration(labelText: "Pourcentage de réduction"),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return "Ce champ est requis";
                  final parsedValue = int.tryParse(value);
                  if (parsedValue == null || parsedValue <= 0 || parsedValue > 100) {
                    return "Entrez une valeur entre 1 et 100";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: maxPeopleController,
                decoration: const InputDecoration(labelText: "Nombre maximal de personnes"),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return "Ce champ est requis";
                  final parsedValue = int.tryParse(value);
                  if (parsedValue == null || parsedValue <= 0) {
                    return "Entrez une valeur valide";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text("Ajouter le coupon"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                onPressed: _addCoupon,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
