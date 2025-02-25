import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gourmetpass/providers/coupon_provider.dart';
import 'package:gourmetpass/models/coupon_model.dart';

class AddCouponScreen extends StatefulWidget {
  final String restaurantId;

  const AddCouponScreen({super.key, required this.restaurantId});

  @override
  State<AddCouponScreen> createState() => _AddCouponScreenState();
}

class _AddCouponScreenState extends State<AddCouponScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController discountController = TextEditingController();
  final TextEditingController maxPeopleController = TextEditingController();

  @override
  void dispose() {
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
        title: const Text('Ajouter un Coupon'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                key: const Key('coupon_description'),
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) => (value == null || value.isEmpty)
                    ? 'Veuillez entrer une description'
                    : null,
              ),
              TextFormField(
                key: const Key('coupon_discount'),
                controller: discountController,
                decoration: const InputDecoration(labelText: 'Pourcentage de réduction'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un pourcentage';
                  }
                  final parsedValue = int.tryParse(value);
                  if (parsedValue == null) return 'Veuillez entrer un nombre valide';
                  if (parsedValue <= 0 || parsedValue > 100) return 'Valeur entre 1 et 100';
                  return null;
                },
              ),
              TextFormField(
                key: const Key('coupon_max_people'),
                controller: maxPeopleController,
                decoration: const InputDecoration(labelText: 'Nombre maximum de personnes'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un nombre de personnes';
                  }
                  final parsedValue = int.tryParse(value);
                  if (parsedValue == null) return 'Veuillez entrer un nombre valide';
                  if (parsedValue < 1) return 'Minimum 1 personne';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                key: const Key('add_coupon_button'),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    FocusScope.of(context).unfocus();

                    final newCoupon = Coupon(
                      id: '',
                      restaurantId: widget.restaurantId,
                      description: descriptionController.text,
                      discountPercentage: int.parse(discountController.text),
                      maxPeople: int.parse(maxPeopleController.text),
                      isUsed: false,
                      isActive: true,
                    );

                    // Appel de l'ajout de coupon
                    await couponProvider.addCoupon(widget.restaurantId, newCoupon);

                    // Vérifie si une erreur a été définie dans le provider
                    if (couponProvider.errorMessage != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          key: const Key('coupon_error_snackbar'),
                          content: Text('Erreur lors de l\'ajout du coupon : ${couponProvider.errorMessage}'),
                        ),
                      );
                      setState(() {}); // Mise à jour de l'UI pour l'erreur
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          key: Key('coupon_success_snackbar'),
                          content: Text('Coupon ajouté avec succès'),
                        ),
                      );
                      setState(() {}); // Mise à jour de l'UI
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
