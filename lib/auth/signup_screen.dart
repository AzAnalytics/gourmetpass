/*import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gourmetpass/providers/user_provider.dart';


class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  SignupScreenState createState() => SignupScreenState();
}

class SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _displayNameController = TextEditingController();
  bool _isLoading = false; // ✅ Indicateur de chargement

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _displayNameController.dispose();
    super.dispose();
  }

  /// 🔹 Validation du pseudo (displayName)
  bool _isValidDisplayName(String name) {
    final regex = RegExp(r'^[a-zA-Z0-9_.-]{3,20}$');
    return regex.hasMatch(name);
  }

  /// 🔹 Vérification de l'email
  bool _isValidEmail(String email) {
    final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    return regex.hasMatch(email);
  }

  /// 🔹 Vérification du mot de passe
  bool _isValidPassword(String password) {
    return password.length >= 6;
  }

  /// 🔹 Fonction pour gérer l'inscription
  Future<void> _signup() async {
    final displayName = _displayNameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (!_isValidDisplayName(displayName)) {
      _showSnackbar("Pseudo invalide : utilisez 3-20 caractères, lettres/chiffres/_ . -");
      return;
    }
    if (!_isValidEmail(email)) {
      _showSnackbar("Adresse email invalide.");
      return;
    }
    if (!_isValidPassword(password)) {
      _showSnackbar("Le mot de passe doit contenir au moins 6 caractères.");
      return;
    }

    setState(() => _isLoading = true);

    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final newUser = await userProvider.signup(email, password, displayName);

      if (!mounted) return;

      if (newUser != null) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        _showSnackbar("Échec de l'inscription. Veuillez réessayer.");
      }
    } catch (e) {
      if (!mounted) return;
      _handleAuthError(e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }



  /// 🔹 Afficher un message d'erreur dans `ScaffoldMessenger`
  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.red,
      ),
    );
  }

  /// 🔹 Gestion des erreurs Firebase Auth
  void _handleAuthError(String error) {
    String errorMessage = 'Une erreur est survenue. Veuillez réessayer.';
    if (error.contains('email-already-in-use')) {
      errorMessage = "Cet email est déjà utilisé.";
    } else if (error.contains('weak-password')) {
      errorMessage = "Le mot de passe est trop faible.";
    } else if (error.contains('invalid-email')) {
      errorMessage = "L'adresse email est invalide.";
    }
    _showSnackbar(errorMessage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inscription')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildTextField(_displayNameController, 'Nom d\'utilisateur'),
            _buildTextField(_emailController, 'Email', keyboardType: TextInputType.emailAddress),
            _buildTextField(_passwordController, 'Mot de passe', isPassword: true),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator() // ✅ Indicateur de chargement
                : ElevatedButton(
              onPressed: _signup,
              child: const Text('S\'inscrire'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context), // Retour à la connexion
              child: const Text("Retour à la connexion"),
            ),
          ],
        ),
      ),
    );
  }

  /// 🔹 Widget réutilisable pour les champs de texte
  Widget _buildTextField(TextEditingController controller, String label,
      {bool isPassword = false, TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
        ),
        obscureText: isPassword,
        keyboardType: keyboardType,
      ),
    );
  }
}
*/