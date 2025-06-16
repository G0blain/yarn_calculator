import 'package:flutter/material.dart';

class MyAppScaffold extends StatelessWidget {
  final Widget child;
  final String title;

  const MyAppScaffold.MyAppScaffold({
    super.key,
    required this.child,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isWide = width > 600;

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body:
          isWide
              ? Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 900),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: child,
                  ),
                ),
              )
              : Padding(padding: const EdgeInsets.all(16), child: child),
    );
  }
}
