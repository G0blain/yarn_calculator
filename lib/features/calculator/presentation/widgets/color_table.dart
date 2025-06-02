import 'package:flutter/material.dart';
import 'package:yarn_calculator/features/calculator/data/models/color_zone.dart';

class ColorTable extends StatelessWidget {
  final List<ColorZone> zones;

  const ColorTable({super.key, required this.zones});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 12.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 4.0,
                      horizontal: 16.0,
                    ),
                    child: Card(
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '$index',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Container(
                              width: 40,
                              height: 20,
                              decoration: BoxDecoration(
                                color: zone.color,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: Colors.black26),
                              ),
                            ),
                            Text(
                              zone.getColorHexCode(),
                              style: const TextStyle(fontFamily: 'monospace'),
                            ),
                            IconButton(
                              icon: const Icon(Icons.palette),
                              onPressed: () {
                                // Future color picker or action
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
      ),
    );
  }
}
