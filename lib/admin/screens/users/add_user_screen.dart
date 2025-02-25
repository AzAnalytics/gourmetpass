import 'package:flutter/material.dart';
import 'package:gourmetpass/models/user_model.dart';
import 'package:gourmetpass/providers/user_provider.dart';
import 'package:provider/provider.dart';

class AddUserScreen extends StatefulWidget {
  final bool autoPopAfterSuccess;
  const AddUserScreen({super.key, this.autoPopAfterSuccess = true});

  @override
  State<AddUserScreen> createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isAdmin = false;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text('Ajouter un utilisateur')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                key: const Key('user_name'),
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nom'),
                validator: (value) =>
                value!.isEmpty ? 'Veuillez entrer un nom' : null,
              ),
              TextFormField(
                key: const Key('user_email'),
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) =>
                value!.isEmpty ? 'Veuillez entrer un email' : null,
              ),
              SwitchListTile(
                title: const Text('Admin'),
                value: isAdmin,
                onChanged: (value) => setState(() => isAdmin = value),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                key: const Key('add_user_button'),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final newUser = User(
                      id: '',
                      name: nameController.text,
                      email: emailController.text,
                      isAdmin: isAdmin,
                      isActive: true,
                      displayName: '',
                    );

                    await userProvider.addUser(newUser);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        key: Key('user_success_snackbar'),
                        content: Text('Utilisateur ajouté avec succès'),
                      ),
                    );

                    // Attendre un délai pour laisser le temps au SnackBar d'être visible
                    await Future.delayed(const Duration(milliseconds: 500));
                    if (widget.autoPopAfterSuccess && Navigator.canPop(context)) {
                      Navigator.pop(context);
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
