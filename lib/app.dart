import 'package:flutter/material.dart';
import 'package:yarn_calculator/features/calculator/presentation/screens/calculating_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Yarn Calculator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: CalculatingPage(),
      // Tu peux aussi ajouter une gestion des routes ici plus tard
    );
  }
}
