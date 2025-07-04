import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yarn_calculator/core/constants/app_spacing.dart';
import 'package:yarn_calculator/core/widgets/app_scaffold.dart';
import 'package:yarn_calculator/core/widgets/separated_column.dart';
import 'package:yarn_calculator/features/calculator/data/models/color_zone.dart';
import 'package:yarn_calculator/features/calculator/presentation/widgets/color_table.dart';
import 'package:yarn_calculator/features/crop/presentation/screens/cropping_page.dart';
import 'package:image/image.dart' as imgPck;
import 'package:yarn_calculator/features/calculator/presentation/widgets/image_viewer.dart';
import 'package:yarn_calculator/features/calculator/domain/segmentation_service.dart';

enum SegmentationMethods {
  CUT_PEAR_IN_HALF(label: 'Cut pear in half'),
  K_MEANS(label: 'K-Means');

  final String label;

  const SegmentationMethods({required this.label});
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
  /**
   * Color area in the image detected by the segmentation method
   */
  List<ColorZone> _colorZones = [];

  ColorZone? _selectedColorZone;
  SegmentationMethods? _selectedSegmentationMethod;

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
    return AppScaffold.MyAppScaffold(
      title: 'Yarn Calculator',
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: AppSpacing.l),
        child: SeparatedColumn(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: _pickImage,
                  icon: Icon(Icons.add_photo_alternate),
                  label: const Text('Load image'),
                ),
                ElevatedButton.icon(
                  onPressed: _cropImage,
                  icon: Icon(Icons.crop),
                  label: Text('Crop'),
                ),
                ElevatedButton.icon(
                  onPressed: () => {},
                  icon: Icon(Icons.rocket),
                  label: Text('Test'),
                ),
              ],
            ),
            ImageViewer(
              imageBytes: _imageBytes,
              workingImage: _workingImage,
              zoneToColor: _selectedColorZone,
              imageKey: _imageKey,
              onTap: _handleTouchOnImage,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Clustering method :',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: AppSpacing.l),
                DropdownButton<SegmentationMethods>(
                  value: _selectedSegmentationMethod,
                  onChanged: (SegmentationMethods? newValue) {
                    setState(() {
                      _selectedSegmentationMethod = newValue;
                    });
                  },
                  items: [
                    const DropdownMenuItem<SegmentationMethods>(
                      value: null,
                      child: Text(''),
                    ),
                    ...SegmentationMethods.values.map((
                      SegmentationMethods method,
                    ) {
                      return DropdownMenuItem<SegmentationMethods>(
                        value: method,
                        child: Text(method.label),
                      );
                    }).toList(),
                  ],
                ),
              ],
            ),
            ElevatedButton.icon(
              onPressed: _go,
              icon: Icon(Icons.play_arrow),
              label: const Text('GO'),
            ),
            ColorTable(zones: _colorZones),
          ],
        ),
      ),
    );
  }
}
