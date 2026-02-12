import 'package:flutter/material.dart';
import 'package:alpha_fitness/utils/constants.dart';
import 'package:alpha_fitness/screens/dashboard/dashboard_screen.dart';
import 'package:alpha_fitness/screens/members/members_list_screen.dart'; // Écran placeholder
import 'package:alpha_fitness/screens/reports/reports_screen.dart'; // Écran placeholder
import 'package:alpha_fitness/screens/settings/settings_screen.dart'; // Écran placeholder

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  // Liste des écrans pour chaque onglet
  final List<Widget> _screens = [
    const DashboardScreen(),
    const MembersListScreen(), // Nous allons créer cet écran
    const ReportsScreen(), // Nous allons créer cet écran
    const SettingsScreen(), // Nous allons créer cet écran
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppConstants.cardColor,
        selectedItemColor: AppConstants.accentColor,
        unselectedItemColor: AppConstants.secondaryTextColor,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Abonnés',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assessment),
            label: 'Rapports',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Paramètres',
          ),
        ],
      ),
    );
  }
}