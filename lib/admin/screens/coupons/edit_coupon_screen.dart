import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gourmetpass/providers/coupon_provider.dart';
import 'package:gourmetpass/models/coupon_model.dart';

class EditCouponScreen extends StatefulWidget {
  final CouponModel coupon;

  const EditCouponScreen({super.key, required this.coupon});

  @override
  State<EditCouponScreen> createState() => _EditCouponScreenState();
}

class _EditCouponScreenState extends State<EditCouponScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController descriptionController;
  late TextEditingController discountController;
  late TextEditingController maxPeopleController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    descriptionController = TextEditingController(text: widget.coupon.description);
    discountController = TextEditingController(text: widget.coupon.discountPercentage.toString());
    maxPeopleController = TextEditingController(text: widget.coupon.maxPeople.toString());
  }

  @override
  void dispose() {
    descriptionController.dispose();
    discountController.dispose();
    maxPeopleController.dispose();
    super.dispose();
  }

  Future<void> _updateCoupon() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final couponProvider = Provider.of<CouponProvider>(context, listen: false);
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    try {
      final updatedCoupon = widget.coupon.copyWith(
        description: descriptionController.text.trim(),
        discountPercentage: int.parse(discountController.text.trim()),
        maxPeople: int.parse(maxPeopleController.text.trim()),
      );

      await couponProvider.updateCoupon(updatedCoupon);

      messenger.showSnackBar(
        const SnackBar(
          content: Text("✅ Coupon mis à jour avec succès !"),
          backgroundColor: Colors.green,
        ),
      );

      await Future.delayed(const Duration(milliseconds: 500));
      if (navigator.canPop()) navigator.pop();
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(
          content: Text("❌ Erreur : ${e.toString()}"),
          backgroundColor: Colors.red,
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
        title: const Text("Modifier le Coupon"),
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
                icon: const Icon(Icons.save),
                label: const Text("Enregistrer les modifications"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                onPressed: _updateCoupon,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
