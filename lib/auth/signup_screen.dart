import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gourmetpass/providers/user_provider.dart';
import 'package:gourmetpass/screens/home_screen.dart';
import 'package:gourmetpass/services/payment_service.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  bool isLoading = false;
  bool obscurePassword = true;

  /// 🔹 Gère l'inscription de l'utilisateur avec paiement obligatoire
  Future<void> _signup() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      // 🔥 Étape 1 : Traitement du paiement Stripe
      final success = await PaymentService().processPayment(
        emailController.text.trim(), // ✅ Ajout de l'email comme argument
        80, // ✅ Prix de l'abonnement annuel en euros
      );

      if (!success) {
        if (!mounted) return;
        _showSnackbar("❌ Paiement annulé.");
        setState(() => isLoading = false);
        return;
      }

      // 🔥 Étape 2 : Inscription Firebase
      final newUser = await userProvider.signup(
        emailController.text.trim(),
        passwordController.text.trim(),
        nameController.text.trim(),
        DateTime.now().add(const Duration(days: 365)), // 🔹 Abonnement d'1 an
      );

      if (!mounted) return;

      if (newUser != null) {
        _showSnackbar("✅ Inscription réussie !");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else {
        _showSnackbar("❌ Échec de l'inscription.");
      }
    } catch (e) {
      _showSnackbar("❌ Erreur : $e");
    } finally {
      setState(() => isLoading = false);
    }
  }


  /// 🔹 Affiche un message Snackbar
  void _showSnackbar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange.shade50,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.person_add, size: 80, color: Colors.orange),
              const SizedBox(height: 16),
              const Text(
                "Inscription",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),

              /// 🔹 Formulaire d'inscription
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: "Nom complet",
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                      value != null && value.isNotEmpty ? null : "Nom requis",
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: "Email",
                        prefixIcon: Icon(Icons.email),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                      value != null && value.contains("@") ? null : "Email invalide",
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: passwordController,
                      obscureText: obscurePassword,
                      decoration: InputDecoration(
                        labelText: "Mot de passe",
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(obscurePassword ? Icons.visibility : Icons.visibility_off),
                          onPressed: () => setState(() => obscurePassword = !obscurePassword),
                        ),
                        border: const OutlineInputBorder(),
                      ),
                      validator: (value) =>
                      value != null && value.length >= 6 ? null : "Mot de passe trop court",
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              /// 🔹 Bouton d'inscription
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _signup,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("S'inscrire et payer"),
                ),
              ),

              const SizedBox(height: 16),

              /// 🔹 Lien vers connexion
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Déjà un compte ? Connectez-vous"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
