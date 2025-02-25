import 'package:flutter/material.dart';
import 'package:gourmetpass/models/user_model.dart';
import 'package:gourmetpass/providers/user_provider.dart';
import 'package:provider/provider.dart';

class EditUserScreen extends StatefulWidget {
  final User user;

  const EditUserScreen({super.key, required this.user});

  @override
  State<EditUserScreen> createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditUserScreen> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  bool isAdmin = false;
  bool isActive = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.user.name);
    emailController = TextEditingController(text: widget.user.email);
    isAdmin = widget.user.isAdmin;
    isActive = widget.user.isActive;
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text('Modifier un utilisateur')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Nom')),
            TextField(controller: emailController, decoration: const InputDecoration(labelText: 'Email')),
            SwitchListTile(
              title: const Text('Admin'),
              value: isAdmin,
              onChanged: (value) => setState(() => isAdmin = value),
            ),
            SwitchListTile(
              title: const Text('Actif'),
              value: isActive,
              onChanged: (value) => setState(() => isActive = value),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final updatedUser = widget.user.copyWith(
                  name: nameController.text,
                  email: emailController.text,
                  isAdmin: isAdmin,
                  isActive: isActive,
                );

                await userProvider.updateUser(updatedUser);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Utilisateur mis à jour avec succès')),
                );

                // Attendre un court délai pour que le SnackBar soit visible lors des tests.
                await Future.delayed(const Duration(milliseconds: 500));
                Navigator.pop(context);
              },
              child: const Text('Mettre à jour'),
            ),
          ],
        ),
      ),
    );
  }
}
