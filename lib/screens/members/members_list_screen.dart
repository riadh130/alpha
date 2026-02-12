import 'package:flutter/material.dart';
import 'package:alpha_fitness/utils/constants.dart';
import 'package:alpha_fitness/models/member_model.dart';
import 'package:alpha_fitness/services/firebase_service.dart';
import 'package:intl/intl.dart';

class MembersListScreen extends StatefulWidget {
  const MembersListScreen({super.key});

  @override
  State<MembersListScreen> createState() => _MembersListScreenState();
}

class _MembersListScreenState extends State<MembersListScreen> {
  final FirebaseService _db = FirebaseService();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Fonction pour déterminer la couleur de la date de fin
  Color _getEndDateColor(DateTime endDate) {
    int remainingDays = endDate.difference(DateTime.now()).inDays;
    if (remainingDays < 0) {
      return AppConstants.errorColor; // Expiré
    } else if (remainingDays <= 7) {
      return AppConstants.warningColor; // Expire bientôt
    }
    return AppConstants.successColor; // Valide
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des Abonnés'),
      ),
      body: Column(
        children: [
          // Barre de recherche
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              style: AppConstants.bodyStyle.copyWith(color: AppConstants.primaryTextColor),
              decoration: InputDecoration(
                hintText: 'Rechercher un abonné...',
                hintStyle: const TextStyle(color: AppConstants.secondaryTextColor),
                prefixIcon: const Icon(Icons.search, color: AppConstants.secondaryTextColor),
                filled: true,
                fillColor: AppConstants.cardColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          // Liste des abonnés
          Expanded(
            child: StreamBuilder<List<MemberModel>>(
              stream: _db.getActiveMembers(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text(
                      'Aucun abonné actif trouvé.',
                      style: AppConstants.bodyStyle,
                    ),
                  );
                }

                // Filtrer la liste en fonction de la recherche
                final allMembers = snapshot.data!;
                final filteredMembers = allMembers.where((member) {
                  return member.name.toLowerCase().contains(_searchQuery);
                }).toList();

                if (filteredMembers.isEmpty) {
                  return const Center(
                    child: Text(
                      'Aucun résultat pour votre recherche.',
                      style: AppConstants.bodyStyle,
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: filteredMembers.length,
                  itemBuilder: (context, index) {
                    final member = filteredMembers[index];
                    return MemberCard(member: member);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Widget pour la carte d'un membre dans la liste
class MemberCard extends StatelessWidget {
  final MemberModel member;

  const MemberCard({super.key, required this.member});

  @override
  Widget build(BuildContext context) {
    final endDateColor = _getEndDateColor(member.endDate);
    final DateFormat formatter = DateFormat('dd/MM/yyyy');

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: AppConstants.cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(
          member.name,
          style: AppConstants.titleStyle,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              'Abonnement: ${member.subscriptionType}',
              style: AppConstants.bodyStyle,
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16, color: AppConstants.secondaryTextColor),
                const SizedBox(width: 4),
                Text(
                  'Fin: ${formatter.format(member.endDate)}',
                  style: AppConstants.bodyStyle.copyWith(color: endDateColor, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
        trailing: const Icon(Icons.chevron_right, color: AppConstants.secondaryTextColor),
        onTap: () {
          // TODO: Naviguer vers l'écran de détails du membre
          // Navigator.of(context).push(
          //   MaterialPageRoute(builder: (context) => MemberDetailsScreen(memberId: member.id!)),
          // );
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Détails pour ${member.name} (à implémenter)')),
          );
        },
      ),
    );
  }

  // Helper function (peut être déplacée dans une classe utilitaire)
  Color _getEndDateColor(DateTime endDate) {
    int remainingDays = endDate.difference(DateTime.now()).inDays;
    if (remainingDays < 0) {
      return AppConstants.errorColor;
    } else if (remainingDays <= 7) {
      return AppConstants.warningColor;
    }
    return AppConstants.successColor;
  }
}