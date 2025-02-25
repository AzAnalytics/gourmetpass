import 'package:flutter/material.dart';
import 'package:gourmetpass/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:gourmetpass/models/user_model.dart';
import 'edit_user_screen.dart';

class ListUsersScreen extends StatefulWidget {
  const ListUsersScreen({super.key});

  @override
  State<ListUsersScreen> createState() => _ListUsersScreenState();
}

class _ListUsersScreenState extends State<ListUsersScreen> {
  @override
  void initState() {
    super.initState();
    _fetchUsers(); // Charge les utilisateurs au démarrage
  }

  Future<void> _fetchUsers() async {
    try {
      await Provider.of<UserProvider>(context, listen: false).fetchUsers();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur de chargement : ${e.toString()}')),
      );
    }
  }

  void _confirmAction({
    required BuildContext context,
    required String title,
    required String message,
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onConfirm();
            },
            child: const Text('Confirmer', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _addUser(BuildContext context) {
    final parentContext = context;
    final TextEditingController nameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Ajouter un utilisateur'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Nom'),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () async {
              if (nameController.text.isNotEmpty && emailController.text.isNotEmpty) {
                final newUser = User(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  name: nameController.text,
                  email: emailController.text,
                  isAdmin: false,
                  isActive: true,
                  displayName: '',
                );
                await Provider.of<UserProvider>(parentContext, listen: false)
                    .addUser(newUser);
                ScaffoldMessenger.of(parentContext).showSnackBar(
                  const SnackBar(content: Text('Nouvel utilisateur ajouté !')),
                );
                Navigator.pop(dialogContext);
              }
            },
            child: const Text('Ajouter'),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestion des Utilisateurs'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _addUser(context),
          ),
        ],
      ),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          if (userProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (userProvider.users.isEmpty) {
            return const Center(child: Text('Aucun utilisateur trouvé.'));
          }

          return RefreshIndicator(
            onRefresh: _fetchUsers,
            child: ListView.builder(
              itemCount: userProvider.users.length,
              itemBuilder: (context, index) {
                final User user = userProvider.users[index];

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    leading: Icon(
                      Icons.person,
                      color: user.isAdmin ? Colors.amber : Colors.grey,
                    ),
                    title: Text(user.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(user.email, style: TextStyle(color: Colors.grey[700])),
                        Row(
                          children: [
                            Text(
                              user.isAdmin ? 'Admin' : 'Utilisateur',
                              style: TextStyle(
                                color: user.isAdmin ? Colors.orange : Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              user.isActive ? 'Actif' : 'Suspendu',
                              style: TextStyle(
                                color: user.isActive ? Colors.green : Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'Suspend') {
                          _confirmAction(
                            context: context,
                            title: 'Suspendre l\'utilisateur',
                            message: 'Voulez-vous suspendre "${user.name}" ?',
                            onConfirm: () async {
                              final updatedUser = user.copyWith(isActive: false);
                              await userProvider.updateUser(updatedUser);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Utilisateur "${user.name}" suspendu.')),
                              );
                            },
                          );
                        } else if (value == 'Delete') {
                          _confirmAction(
                            context: context,
                            title: 'Supprimer l\'utilisateur',
                            message: 'Êtes-vous sûr de vouloir supprimer "${user.name}" ?',
                            onConfirm: () async {
                              await userProvider.deleteUser(user.id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Utilisateur "${user.name}" supprimé.')),
                              );
                            },
                          );
                        } else if (value == 'Edit') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditUserScreen(user: user),
                            ),
                          );
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'Edit',
                          child: const Text('Modifier'),
                        ),
                        if (user.isActive)
                          PopupMenuItem(
                            value: 'Suspend',
                            child: const Text('Suspendre'),
                          ),
                        PopupMenuItem(
                          value: 'Delete',
                          child: const Text('Supprimer', style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
