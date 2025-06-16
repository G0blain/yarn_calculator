import 'package:flutter/material.dart';
import 'package:yarn_calculator/features/calculator/presentation/screens/calculating_page.dart';
import 'package:yarn_calculator/core/theme/bauhaus_theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Yarn Calculator',
      theme: buildBauhausTheme(),
      debugShowCheckedModeBanner: false,
      home: CalculatingPage(),
    );
  }
}
