import 'package:flutter/material.dart';
import 'package:alpha_fitness/utils/constants.dart';
import 'package:alpha_fitness/models/member_model.dart';
import 'package:alpha_fitness/services/firebase_service.dart';

class AddMemberScreen extends StatefulWidget {
  const AddMemberScreen({super.key});

  @override
  State<AddMemberScreen> createState() => _AddMemberScreenState();
}

class _AddMemberScreenState extends State<AddMemberScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final FirebaseService _db = FirebaseService();

  // --- État du formulaire ---
  String _selectedSubscription = 'Mensuel';
  double _price = 50.0; // Prix par défaut pour Mensuel
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 30));
  bool _isLoading = false;

  // --- Packs d'abonnement prédéfinis ---
  final Map<String, double> _subscriptionPacks = {
    'Mensuel': 50.0,
    'Trimestriel': 135.0,
    'Annuel': 480.0,
  };

  // --- Méthodes pour mettre à jour l'état ---
  void _updateSubscription(String? newType) {
    if (newType != null) {
      setState(() {
        _selectedSubscription = newType;
        _price = _subscriptionPacks[newType]!;
        _calculateEndDate();
      });
    }
  }

  void _calculateEndDate() {
    int duration = 0;
    switch (_selectedSubscription) {
      case 'Mensuel':
        duration = 30;
        break;
      case 'Trimestriel':
        duration = 90;
        break;
      case 'Annuel':
        duration = 365;
        break;
    }
    setState(() {
      _endDate = _startDate.add(Duration(days: duration));
    });
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != _startDate) {
      setState(() {
        _startDate = picked;
        _calculateEndDate();
      });
    }
  }

  void _saveMember() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final newMember = MemberModel(
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        email: _emailController.text.trim(),
        subscriptionType: _selectedSubscription,
        price: _price,
        startDate: _startDate,
        endDate: _endDate,
      );

      await _db.addMember(newMember);

      if (!mounted) return;
      
      setState(() => _isLoading = false);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Abonné ajouté avec succès !'),
          backgroundColor: AppConstants.successColor,
        ),
      );
      Navigator.of(context).pop(); // Retour à l'écran précédent
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nouvel Abonné'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Nom
              TextFormField(
                controller: _nameController,
                style: AppConstants.bodyStyle.copyWith(color: AppConstants.primaryTextColor),
                decoration: _inputDecoration('Nom complet'),
                validator: (value) => value!.isEmpty ? 'Champ obligatoire' : null,
              ),
              const SizedBox(height: 16),
              // Téléphone
              TextFormField(
                controller: _phoneController,
                style: AppConstants.bodyStyle.copyWith(color: AppConstants.primaryTextColor),
                decoration: _inputDecoration('Téléphone'),
                validator: (value) => value!.isEmpty ? 'Champ obligatoire' : null,
              ),
              const SizedBox(height: 16),
              // Email
              TextFormField(
                controller: _emailController,
                style: AppConstants.bodyStyle.copyWith(color: AppConstants.primaryTextColor),
                decoration: _inputDecoration('Email (optionnel)'),
              ),
              const SizedBox(height: 16),
              // Type d'abonnement
              DropdownButtonFormField<String>(
                value: _selectedSubscription,
                style: AppConstants.bodyStyle.copyWith(color: AppConstants.primaryTextColor),
                decoration: _inputDecoration("Type d'abonnement"),
                items: _subscriptionPacks.keys.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: _updateSubscription,
              ),
              const SizedBox(height: 16),
              // Date de début
              ListTile(
                title: Text('Date de début: ${_formatDate(_startDate)}', style: AppConstants.bodyStyle),
                trailing: const Icon(Icons.calendar_today, color: AppConstants.accentColor),
                onTap: () => _selectStartDate(context),
              ),
              // Date de fin (calculée)
              ListTile(
                title: Text('Date de fin: ${_formatDate(_endDate)}', style: AppConstants.bodyStyle),
                trailing: const Icon(Icons.info_outline, color: AppConstants.secondaryTextColor),
              ),
              // Prix
              ListTile(
                title: Text('Prix: ${_price.toStringAsFixed(2)} TND', style: AppConstants.titleStyle),
                trailing: const Icon(Icons.attach_money, color: AppConstants.accentColor),
              ),
              const SizedBox(height: 24),
              // Bouton Enregistrer
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _saveMember,
                      child: const Text('Enregistrer'),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: AppConstants.secondaryTextColor),
      enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: AppConstants.secondaryTextColor)),
      focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: AppConstants.accentColor)),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}