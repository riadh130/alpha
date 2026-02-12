import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Obtenir l'utilisateur actuellement connecté
  User? get currentUser => _auth.currentUser;

  // Connexion avec email et mot de passe
  Future<String?> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null; // Retourne null en cas de succès
    } on FirebaseAuthException catch (e) {
      return e.message; // Retourne le message d'erreur
    }
  }

  // Déconnexion
  Future<void> signOut() async {
    await _auth.signOut();
  }
}