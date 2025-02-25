import 'package:flutter/material.dart';
import 'package:gourmetpass/providers/coupon_provider.dart';
import 'package:provider/provider.dart';
import 'package:gourmetpass/models/coupon_model.dart';

class EditCouponScreen extends StatefulWidget {
  final Coupon coupon;

  const EditCouponScreen({super.key, required this.coupon});

  @override
  State<EditCouponScreen> createState() => _EditCouponScreenState();
}

class _EditCouponScreenState extends State<EditCouponScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController descriptionController;
  late TextEditingController discountController;
  late TextEditingController maxPeopleController;

  @override
  void initState() {
    super.initState();
    descriptionController = TextEditingController(text: widget.coupon.description);
    discountController = TextEditingController(text: widget.coupon.discountPercentage.toString());
    maxPeopleController = TextEditingController(text: widget.coupon.maxPeople.toString());
  }

  @override
  void dispose() {
    // Libération des contrôleurs pour éviter les fuites de mémoire
    descriptionController.dispose();
    discountController.dispose();
    maxPeopleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final couponProvider = Provider.of<CouponProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Modifier le Coupon'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                key: const Key('edit_coupon_description'), // ✅ Ajout de clé pour le test
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer une description';
                  }
                  return null;
                },
              ),
              TextFormField(
                key: const Key('edit_coupon_discount'), // ✅ Ajout de clé pour le test
                controller: discountController,
                decoration: const InputDecoration(labelText: 'Pourcentage de réduction'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un pourcentage';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Veuillez entrer un nombre valide';
                  }
                  return null;
                },
              ),
              TextFormField(
                key: const Key('edit_coupon_max_people'), // ✅ Ajout de clé pour le test
                controller: maxPeopleController,
                decoration: const InputDecoration(labelText: 'Nombre maximum de personnes'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un nombre de personnes';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Veuillez entrer un nombre valide';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                key: const Key('update_coupon_button'), // ✅ Ajout de clé pour le test
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final updatedCoupon = widget.coupon.copyWith(
                      description: descriptionController.text,
                      discountPercentage: int.parse(discountController.text),
                      maxPeople: int.parse(maxPeopleController.text),
                    );

                    await couponProvider.updateCoupon(updatedCoupon);

                    if (!context.mounted) return;

                    debugPrint('✅ SnackBar affiché après mise à jour'); // ✅ Ajout du print pour voir si le SnackBar est bien appelé

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        key: Key('coupon_update_success_snackbar'), // ✅ Ajout de la clé pour le test
                        content: Text('Coupon mis à jour avec succès'),
                      ),
                    );
                    debugPrint("✅ SnackBar affiché après mise à jour"); // 🔹 Ajoute ceci

                    await Future.delayed(const Duration(milliseconds: 500)); // Délai pour laisser le temps au SnackBar d’apparaître
                    if (!context.mounted) return;
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    }

                  }
                },
                child: const Text('Mettre à jour'),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
