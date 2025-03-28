import 'package:flutter/material.dart';
import 'package:crop_your_image/crop_your_image.dart';
import 'dart:typed_data';

class CroppingPage extends StatefulWidget {
  final Uint8List imageBytes;
  CroppingPage({required this.imageBytes});

  @override
  _CroppingPageState createState() => _CroppingPageState();
}

class _CroppingPageState extends State<CroppingPage> {
  final CropController _cropController = CropController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Crop image')),
      body: Column(
        children: [
          Expanded(
            child: Crop(
              image: widget.imageBytes,
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
                            content: Text('Failed to crop image: ${cause}'),
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
            ),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () => _cropController.crop(),
            child: Text('Valider'),
          ),
        ],
      ),
    );
  }
}
