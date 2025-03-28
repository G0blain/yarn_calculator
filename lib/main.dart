import 'package:flutter/material.dart';
import 'package:yarn_calculator/calculating_page.dart';

void main() {
  MyApp myApp = MyApp();
  runApp(myApp);
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

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
    );
  }
}
