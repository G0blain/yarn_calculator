import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yarn_calculator/cropping_page.dart';
import 'package:image/image.dart' as imgPck;
import 'package:yarn_calculator/segmentation_service.dart';

enum ClusteringMethods {
  CUT_PEAR_IN_HALF(label: 'Cut pear in half'),
  K_MEANS(label: 'K-Means');

  final String label;

  const ClusteringMethods({required this.label});
}

class CalculatingPage extends StatefulWidget {
  @override
  _CalculatingPageState createState() => _CalculatingPageState();
}

class _CalculatingPageState extends State<CalculatingPage> {
  /**  
   * Format of the image once loaded and used to display it
  */
  Uint8List? _imageBytes;
  /** 
   * Key for accessing the image widget to retrieve its screen size (useful for converting a tap to actual image coordinates)
   */
  final GlobalKey _imageKey = GlobalKey();
  /**
   * Image format obtained from _imageBytes and used to process the image before saving the result back into _imageBytes
  */
  imgPck.Image? _workingImage;

  ClusteringMethods? _selectedClusteringMethod;

  List<ColorZone> _colorZones = [];
  ColorZone? _selectedColorZone;

  /**
 * Allows the user to select an image from his gallery and store it in _imageBytes
 */
  Future<void> _pickImage() async {
    final XFile? pickedFile = await new ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      final Uint8List bytes = await pickedFile.readAsBytes();
      setState(() {
        _imageBytes = bytes;
        _workingImage = null;
        _colorZones = [];
        _selectedColorZone = null;
      });
    }
  }

  /**
 * Allows the user to crop the image on another page
 */
  Future<void> _cropImage() async {
    if (_imageBytes == null) return;

    final croppedImage = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CroppingPage(imageBytes: _imageBytes!),
      ),
    );
    if (croppedImage != null) {
      setState(() {
        _imageBytes = croppedImage;
        _workingImage = null;
        _colorZones = [];
        _selectedColorZone = null;
      });
    }
  }

  /**
 * Convert image : Uint8List to 'package:image/image.dart' Image
 */
  imgPck.Image _bytesToImage(Uint8List uint8list) {
    // return decodeImageFromList(uint8list);
    return imgPck.decodeImage(uint8list)!;
  }

  /**
 * Convert image : 'package:image/image.dart' Image to Uint8List
 */
  // ignore: unused_element
  Uint8List _imageToBytes(imgPck.Image image) {
    return Uint8List.fromList(imgPck.encodePng(image));
  }

  void _go() {
    if (_imageBytes == null) return;

    setState(() {
      _workingImage = _bytesToImage(_imageBytes!);
      _colorZones = SegmentationService.cutPearInHalf(_workingImage!);
      _selectedColorZone = null;
    });
  }

  /**
   * When the user touches a color zone on the image
   */
  void _handleTouchOnImage(Offset localPosition) {
    if (_workingImage == null || _colorZones.isEmpty) return;

    final context = _imageKey.currentContext;
    if (context == null) return;

    final RenderBox box = context.findRenderObject() as RenderBox;
    final Size displayedSize = box.size;

    final Offset imageCoords = _mapTapToImageCoordinates(
      localPosition,
      displayedSize,
      _workingImage!,
    );

    final zone = _getTouchedZone(imageCoords);
    setState(() {
      _selectedColorZone = zone;
    });
  }

  /**
   * Convert screen coordinates to image coordinates
   */
  Offset _mapTapToImageCoordinates(
    Offset localPosition,
    Size displayedSize,
    imgPck.Image image,
  ) {
    double scaleX = image.width / displayedSize.width;
    double scaleY = image.height / displayedSize.height;
    return Offset(localPosition.dx * scaleX, localPosition.dy * scaleY);
  }

  /**
 * Indicates the color zone corresponding to a position on the image
 */
  ColorZone? _getTouchedZone(Offset position) {
    final int tappedX = position.dx.toInt();
    final int tappedY = position.dy.toInt();

    for (final ColorZone zone in _colorZones) {
      for (final pixel in zone.pixels) {
        if (pixel.x == tappedX && pixel.y == tappedY) {
          return zone;
        }
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Yarn Calculator'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: _pickImage,
                  icon: Icon(Icons.add_photo_alternate),
                  label: const Text('Load image'),
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: _cropImage,
                  icon: Icon(Icons.crop),
                  label: Text('Crop'),
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: () => {},
                  icon: Icon(Icons.rocket),
                  label: Text('Test'),
                ),
              ],
            ),
            const SizedBox(height: 10),
            _imageBytes != null
                ? GestureDetector(
                  child: Stack(
                    children: [
                      Image.memory(
                        _imageBytes!,
                        key: _imageKey,
                        height: 300,
                        fit: BoxFit.fitHeight,
                      ),
                      if (_workingImage != null)
                        CustomPaint(
                          painter: ColorZonePainter(
                            zoneToColor: _selectedColorZone,
                            imageSize: Size(
                              _workingImage!.width.toDouble(),
                              _workingImage!.height.toDouble(),
                            ),
                            displaySize: Size(
                              300,
                              300 *
                                  _workingImage!.height /
                                  _workingImage!.width,
                            ),
                          ),
                        ),
                    ],
                  ),
                  onTapDown: (TapDownDetails details) {
                    final Offset position = details.localPosition;
                    _handleTouchOnImage(position);
                  },
                )
                : const Text('No image selected'),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Clustering method :',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 20),
                DropdownButton<ClusteringMethods>(
                  value: _selectedClusteringMethod,
                  onChanged: (ClusteringMethods? newValue) {
                    setState(() {
                      _selectedClusteringMethod = newValue;
                    });
                  },
                  items: [
                    const DropdownMenuItem<ClusteringMethods>(
                      value: null,
                      child: Text(''),
                    ),
                    ...ClusteringMethods.values.map((ClusteringMethods method) {
                      return DropdownMenuItem<ClusteringMethods>(
                        value: method,
                        child: Text(method.label),
                      );
                    }).toList(),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _go,
              icon: Icon(Icons.play_arrow),
              label: const Text('GO'),
            ),
          ],
        ),
      ),
    );
  }
}

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
          ..color = Colors.red.withAlpha(128)
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
