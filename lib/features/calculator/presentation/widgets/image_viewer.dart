import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as imgPck;
import 'package:yarn_calculator/features/calculator/domain/segmentation_service.dart';

class ColorZonePainter extends CustomPainter {
  final ColorZone? zoneToColor;
  final Size imageSize;
  final Size displaySize;

  ColorZonePainter({
    required this.zoneToColor,
    required this.imageSize,
    required this.displaySize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (zoneToColor == null) return;

    double scaleX = displaySize.width / imageSize.width;
    double scaleY = displaySize.height / imageSize.height;

    final Paint paint =
        Paint()
          ..color = zoneToColor!.color.withAlpha(128)
          ..style = PaintingStyle.fill;

    final Path path = Path();

    for (var pixel in zoneToColor!.pixels) {
      final Rect rect = Rect.fromLTWH(
        pixel.x * scaleX,
        pixel.y * scaleY,
        scaleX,
        scaleY,
      );
      path.addRect(rect);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class ImageViewer extends StatelessWidget {
  final Uint8List? imageBytes;
  final imgPck.Image? workingImage;
  final ColorZone? zoneToColor;
  final GlobalKey imageKey;
  final void Function(Offset localPosition) onTap;

  const ImageViewer({
    required this.imageBytes,
    required this.workingImage,
    required this.zoneToColor,
    required this.imageKey,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (imageBytes == null) {
      return const Center(child: Text('No image selected'));
    }

    return GestureDetector(
      child: Stack(
        children: [
          Image.memory(
            imageBytes!,
            key: imageKey,
            height: 300,
            fit: BoxFit.fitHeight,
          ),
          if (workingImage != null)
            CustomPaint(
              painter: ColorZonePainter(
                zoneToColor: zoneToColor,
                imageSize: Size(
                  workingImage!.width.toDouble(),
                  workingImage!.height.toDouble(),
                ),
                displaySize: Size(
                  300,
                  300 * workingImage!.height / workingImage!.width,
                ),
              ),
            ),
        ],
      ),
      onTapDown: (TapDownDetails details) {
        onTap(details.localPosition);
      },
    );
  }
}
