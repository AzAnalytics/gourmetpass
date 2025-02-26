import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gourmetpass/models/user_model.dart';
import 'package:gourmetpass/providers/user_provider.dart';

class DeleteUserScreen extends StatelessWidget {
  final UserModel user;

  const DeleteUserScreen({super.key, required this.user});

  Future<void> _deleteUser(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      await userProvider.deleteUser(user.id);

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("✅ Utilisateur supprimé avec succès !"),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("❌ Erreur lors de la suppression : $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Supprimer l'utilisateur"),
      content: Text("Voulez-vous vraiment supprimer ${user.displayName} ?"),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Annuler"),
        ),
        ElevatedButton.icon(
          icon: const Icon(Icons.delete),
          label: const Text("Supprimer"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
          onPressed: () => _deleteUser(context),
        ),
      ],
    );
  }
}
