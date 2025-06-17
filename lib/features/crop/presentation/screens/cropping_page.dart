import 'package:flutter/material.dart';
import 'package:crop_your_image/crop_your_image.dart';
import 'dart:typed_data';

import 'package:yarn_calculator/core/constants/app_spacing.dart';

class CroppingPage extends StatefulWidget {
  final Uint8List _imageBytes;
  CroppingPage({required Uint8List imageBytes}) : _imageBytes = imageBytes;

  @override
  _CroppingPageState createState() => _CroppingPageState();
}

class _CroppingPageState extends State<CroppingPage> {
  final CropController _cropController = CropController();
  bool _isCircleUI = false;

  void _useCircleUI(bool circle) {
    setState(() {
      _isCircleUI = circle;
      _cropController.withCircleUi = circle;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Crop image')),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: Crop(
                image: widget._imageBytes,
                controller: _cropController,
                onCropped: (result) {
                  switch (result) {
                    case CropSuccess(:final croppedImage):
                      Navigator.pop(context, croppedImage);
                      break;
                    case CropFailure(:final cause):
                      showDialog(
                        context: context,
                        builder:
                            (context) => AlertDialog(
                              title: Text('Error'),
                              content: Text('Failed to crop image: $cause'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text('OK'),
                                ),
                              ],
                            ),
                      );
                      break;
                  }
                },
                withCircleUi: _isCircleUI,
              ),
            ),
            const SizedBox(height: AppSpacing.l),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        _isCircleUI
                            ? Colors.blue
                            : Colors.blue.withAlpha((0.3 * 255).toInt()),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                  onPressed: () => _useCircleUI(true),
                  icon: const Icon(Icons.circle_outlined),
                  label: const Text('CIRCLE'),
                ),
                const SizedBox(width: AppSpacing.s),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        !_isCircleUI
                            ? Colors.blue
                            : Colors.blue.withAlpha((0.3 * 255).toInt()),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                  onPressed: () => _useCircleUI(false),
                  icon: const Icon(Icons.crop_square),
                  label: const Text('RECT'),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.l),
            ElevatedButton(
              onPressed: () {
                _isCircleUI
                    ? _cropController.cropCircle()
                    : _cropController.crop();
              },
              child: Text('Validate'),
            ),
            const SizedBox(height: AppSpacing.l),
          ],
        ),
      ),
    );
  }
}
