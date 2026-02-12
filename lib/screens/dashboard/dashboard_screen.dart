import 'package:flutter/material.dart';
import 'package:alpha_fitness/utils/constants.dart';
import 'package:alpha_fitness/services/firebase_service.dart';
import 'package:alpha_fitness/screens/members/add_member_screen.dart'; // Nous allons créer cet écran ensuite
import 'package:intl/intl.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final FirebaseService _db = FirebaseService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tableau de Bord'),
      ),
      body: StreamBuilder<Map<String, dynamic>>(
        stream: _db.getDashboardStats(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text("Aucune donnée disponible", style: AppConstants.bodyStyle,));
          }

          final stats = snapshot.data!;
          final activeCount = stats['activeCount'] ?? 0;
          final expiringCount = stats['expiringThisMonthCount'] ?? 0;
          final revenue = stats['monthlyRevenue'] ?? 0.0;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Carte de Statistiques
                Row(
                  children: [
                    Expanded(
                      child: StatCard(
                        title: 'Abonnés Actifs',
                        value: activeCount.toString(),
                        icon: Icons.people,
                        color: AppConstants.successColor,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: StatCard(
                        title: 'Échéances ce mois',
                        value: expiringCount.toString(),
                        icon: Icons.event,
                        color: AppConstants.warningColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                StatCard(
                  title: 'Revenus Estimés',
                  value: "${revenue.toStringAsFixed(2)} TND",
                  icon: Icons.attach_money,
                  color: AppConstants.accentColor,
                ),
                const Spacer(),
                // Bouton d'ajout
                FloatingActionButton.extended(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const AddMemberScreen()),
                    );
                  },
                  label: const Text('Ajouter un Abonné'),
                  icon: const Icon(Icons.add),
                  backgroundColor: AppConstants.accentColor,
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }
}

// Widget réutilisable pour les cartes de statistiques
class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppConstants.cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(title, style: AppConstants.bodyStyle),
            ],
          ),
          const SizedBox(height: 8),
          Text(value, style: AppConstants.titleStyle.copyWith(color: color)),
        ],
      ),
    );
  }
}