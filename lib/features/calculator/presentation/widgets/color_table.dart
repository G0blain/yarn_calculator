import 'package:flutter/material.dart';
import 'package:yarn_calculator/core/constants/app_radius.dart';
import 'package:yarn_calculator/features/calculator/data/models/color_zone.dart';

class ColorTable extends StatelessWidget {
  final List<ColorZone> zones;

  const ColorTable({super.key, required this.zones});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 12.0),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16.0),
          initiallyExpanded: true,
          controlAffinity: ListTileControlAffinity.leading,
          title: const Text(
            'Color Zones',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          childrenPadding: const EdgeInsets.only(bottom: 12.0),
          children:
              zones.isEmpty
                  ? [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text('No color zone.'),
                    ),
                  ]
                  : zones.asMap().entries.map((entry) {
                    final index = entry.key + 1;
                    final zone = entry.value;

                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 8,
                          ),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 24,
                                child: Text(
                                  '$index',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Container(
                                width: 40,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: zone.color,
                                  borderRadius: BorderRadius.circular(
                                    AppRadius.soft,
                                  ),
                                  border: Border.all(color: Colors.black26),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  zone.getColorHexCode(),
                                  style: const TextStyle(
                                    fontFamily: 'monospace',
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.palette),
                                onPressed: () {
                                  // Future color picker
                                },
                              ),
                            ],
                          ),
                        ),
                        if (index < zones.length)
                          const Divider(
                            indent: 16,
                            endIndent: 16,
                            thickness: 0.5,
                          ),
                      ],
                    );
                  }).toList(),
        ),
      ),
    );
  }
}
