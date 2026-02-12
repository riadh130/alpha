import 'package:flutter/material.dart';
import 'package:alpha_fitness/utils/constants.dart';
import 'package:alpha_fitness/services/auth_service.dart';
import 'package:alpha_fitness/screens/auth/login_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  void _logout(BuildContext context) async {
    final AuthService _auth = AuthService();
    await _auth.signOut();
    // Redirige vers l'écran de connexion et supprime toutes les routes précédentes
    if (context.mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (Route<dynamic> route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Paramètres'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        children: [
          // Option de profil (placeholder)
          ListTile(
            leading: const Icon(Icons.person, color: AppConstants.accentColor),
            title: const Text('Profil Utilisateur', style: AppConstants.bodyStyle),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Fonctionnalité à venir')),
              );
            },
          ),
          const Divider(color: AppConstants.cardColor),
          // Option de notifications (placeholder)
          ListTile(
            leading: const Icon(Icons.notifications, color: AppConstants.accentColor),
            title: const Text('Notifications', style: AppConstants.bodyStyle),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Fonctionnalité à venir')),
              );
            },
          ),
          const Divider(color: AppConstants.cardColor),
          // Option "À Propos" (placeholder)
          ListTile(
            leading: const Icon(Icons.info, color: AppConstants.accentColor),
            title: const Text('À Propos', style: AppConstants.bodyStyle),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Alpha Fitness v1.0')),
              );
            },
          ),
          const Divider(color: AppConstants.cardColor),
          // Bouton de déconnexion
          ListTile(
            leading: const Icon(Icons.logout, color: AppConstants.errorColor),
            title: const Text(
              'Se Déconnecter',
              style: TextStyle(color: AppConstants.errorColor, fontWeight: FontWeight.bold),
            ),
            onTap: () => _logout(context),
          ),
        ],
      ),
    );
  }
}