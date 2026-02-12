import 'package:flutter/material.dart';
import 'package:alpha_fitness/utils/constants.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rapports'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.insert_chart,
              size: 80,
              color: AppConstants.accentColor,
            ),
            SizedBox(height: 16),
            Text(
              'Rapports',
              style: AppConstants.headlineStyle,
            ),
            SizedBox(height: 8),
            Text(
              'Cette section affichera bientôt\nles rapports financiers et de fréquentation.',
              textAlign: TextAlign.center,
              style: AppConstants.bodyStyle,
            ),
          ],
        ),
      ),
    );
  }
}