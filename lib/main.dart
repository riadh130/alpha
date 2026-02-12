import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:alpha_fitness/utils/constants.dart';
import 'package:alpha_fitness/screens/auth/login_screen.dart'; // Nous allons créer cet écran ensuite

// IMPORTANT : Vous devez ajouter votre fichier de configuration Firebase ici
// Pour l'instant, nous utilisons une configuration factice.
const FirebaseOptions _firebaseOptions = FirebaseOptions(
  apiKey: "votre-api-key",
  appId: "votre-app-id",
  messagingSenderId: "votre-sender-id",
  projectId: "votre-project-id",
);

void main() async {
  // Assure que les liaisons Flutter sont initialisées
  WidgetsFlutterBinding.ensureInitialized();
  // Initialise Firebase avec les options
  await Firebase.initializeApp(options: _firebaseOptions);
  runApp(const AlphaFitnessApp());
}

class AlphaFitnessApp extends StatelessWidget {
  const AlphaFitnessApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Alpha Fitness',
      debugShowCheckedModeBanner: false,
      // Application du thème sombre
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppConstants.backgroundColor,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppConstants.backgroundColor,
          elevation: 0,
          titleTextStyle: AppConstants.headlineStyle,
        ),
        textTheme: const TextTheme(
          bodyLarge: AppConstants.bodyStyle,
          bodyMedium: AppConstants.bodyStyle,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppConstants.accentColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
      // L'écran de départ est l'écran de connexion
      home: const LoginScreen(),
    );
  }
}