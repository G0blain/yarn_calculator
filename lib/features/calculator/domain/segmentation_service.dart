import 'package:flutter/material.dart';
import 'package:image/image.dart' as imgPck;

class ColorZone {
  final List<imgPck.Pixel> pixels;
  final Color color;

  ColorZone({required this.pixels, required this.color});
}

class SegmentationService {
  /**
   * Cuts the image into two zones
   */
  static List<ColorZone> cutPearInHalf(imgPck.Image srcImage) {
    final List<imgPck.Pixel> leftPixels = [];
    final List<imgPck.Pixel> rightPixels = [];

    final int midX = (srcImage.width / 2).floor();

    for (int y = 0; y < srcImage.height; y++) {
      for (int x = 0; x < srcImage.width; x++) {
        final imgPck.Pixel pixel = srcImage.getPixelSafe(x, y);
        if (x < midX) {
          leftPixels.add(pixel);
        } else {
          rightPixels.add(pixel);
        }
      }
    }

    final ColorZone leftZone = ColorZone(
      pixels: leftPixels,
      color: Colors.green,
    );
    final ColorZone rightZone = ColorZone(
      pixels: rightPixels,
      color: Colors.blue,
    );

    return [leftZone, rightZone];
  }
}
