import 'package:flutter/material.dart';

class CalculatingPage extends StatefulWidget {
  const CalculatingPage({super.key, required this.title});

  final String title;

  @override
  State<CalculatingPage> createState() => _CalculatingPageState();
}

class _CalculatingPageState extends State<CalculatingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Theme.of(context).colorScheme.inversePrimary, title: Text(widget.title)),
      body: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[const Text('Hello')])),
    );
  }
}
