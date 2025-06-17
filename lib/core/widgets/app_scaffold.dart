import 'package:flutter/material.dart';
import 'package:yarn_calculator/core/constants/app_spacing.dart';

class AppScaffold extends StatelessWidget {
  final Widget child;
  final String title;

  const AppScaffold.MyAppScaffold({
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.m,
                    ),
                    child: child,
                  ),
                ),
              )
              : Padding(
                padding: const EdgeInsets.all(AppSpacing.m),
                child: child,
              ),
    );
  }
}
