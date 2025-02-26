import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gourmetpass/providers/coupon_provider.dart';
import 'package:gourmetpass/models/coupon_model.dart';

class DeleteCouponScreen extends StatefulWidget {
  final CouponModel coupon;

  const DeleteCouponScreen({super.key, required this.coupon});

  @override
  DeleteCouponScreenState createState() => DeleteCouponScreenState();
}

class DeleteCouponScreenState extends State<DeleteCouponScreen> {
  bool _isDeleting = false;

  Future<void> _deleteCoupon() async {
    if (_isDeleting) return;
    setState(() => _isDeleting = true);

    final couponProvider = Provider.of<CouponProvider>(context, listen: false);
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    try {
      await couponProvider.deleteCoupon(widget.coupon.restaurantId, widget.coupon.id);

      messenger.showSnackBar(
        SnackBar(
          key: const Key('delete_coupon_success_snackbar'),
          content: Text('✅ Coupon "${widget.coupon.description}" supprimé avec succès.'),
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
        setState(() => _isDeleting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Supprimer ce coupon ?"),
      content: Text(
        "Êtes-vous sûr de vouloir supprimer le coupon :\n\n"
            "\"${widget.coupon.description}\" ?\n\nCette action est irréversible.",
        style: const TextStyle(fontSize: 16),
      ),
      actions: [
        TextButton(
          key: const Key('cancel_delete_coupon'),
          onPressed: () => Navigator.pop(context),
          child: const Text("Annuler", style: TextStyle(color: Colors.grey)),
        ),
        ElevatedButton.icon(
          key: const Key('confirm_delete_coupon'),
          icon: const Icon(Icons.delete, color: Colors.white),
          label: _isDeleting
              ? const SizedBox(
            height: 16,
            width: 16,
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2,
            ),
          )
              : const Text("Supprimer"),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          onPressed: _isDeleting ? null : _deleteCoupon,
        ),
      ],
    );
  }
}
