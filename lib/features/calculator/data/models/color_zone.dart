import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as imgPck;

class ColorZone {
  final List<imgPck.Pixel> pixels;
  final Color color;

  ColorZone({required this.pixels, required this.color});

  String getColorHexCode() {
    int to255(double v) => (v * 255).round().clamp(0, 255);
    final r = to255(color.r);
    final g = to255(color.g);
    final b = to255(color.b);
    return '#${r.toRadixString(16).padLeft(2, '0').toUpperCase()}'
        '${g.toRadixString(16).padLeft(2, '0').toUpperCase()}'
        '${b.toRadixString(16).padLeft(2, '0').toUpperCase()}';
  }
}
