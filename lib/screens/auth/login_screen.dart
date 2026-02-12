import 'package:flutter/material.dart';
import 'package:alpha_fitness/services/auth_service.dart';
import 'package:alpha_fitness/utils/constants.dart';
import 'package:alpha_fitness/screens/main_screen.dart'; // Nous allons créer cet écran ensuite

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthService _auth = AuthService();
  bool _isLoading = false;

  void _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      String? error = await _auth.signIn(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      if (!mounted) return;

      setState(() => _isLoading = false);

      if (error != null) {
        // Affiche l'erreur
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error),
            backgroundColor: AppConstants.errorColor,
          ),
        );
      } else {
        // Redirige vers l'écran principal
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const MainScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo ou Titre
                Text(
                  'Alpha Fitness',
                  style: AppConstants.headlineStyle.copyWith(fontSize: 32),
                ),
                const SizedBox(height: 48),
                // Champ Email
                TextFormField(
                  controller: _emailController,
                  style: AppConstants.bodyStyle.copyWith(color: AppConstants.primaryTextColor),
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(color: AppConstants.secondaryTextColor),
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: AppConstants.secondaryTextColor)),
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AppConstants.accentColor)),
                  ),
                  validator: (value) => value!.isEmpty ? 'Veuillez entrer un email' : null,
                ),
                const SizedBox(height: 16),
                // Champ Mot de Passe
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  style: AppConstants.bodyStyle.copyWith(color: AppConstants.primaryTextColor),
                  decoration: const InputDecoration(
                    labelText: 'Mot de passe',
                    labelStyle: TextStyle(color: AppConstants.secondaryTextColor),
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: AppConstants.secondaryTextColor)),
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AppConstants.accentColor)),
                  ),
                  validator: (value) => value!.isEmpty ? 'Veuillez entrer un mot de passe' : null,
                ),
                const SizedBox(height: 32),
                // Bouton de Connexion
                _isLoading
                    ? const CircularProgressIndicator(color: AppConstants.accentColor)
                    : ElevatedButton(
                        onPressed: _login,
                        child: const Text('Se Connecter'),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}