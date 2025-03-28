import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:yarn_calculator/cropping_page.dart';

class CalculatingPage extends StatefulWidget {
  @override
  _CalculatingPageState createState() => _CalculatingPageState();
}

class _CalculatingPageState extends State<CalculatingPage> {
  Uint8List? imageBytes;

  Future<void> pickImage() async {
    final XFile? pickedFile = await new ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      final Uint8List bytes = await pickedFile.readAsBytes();
      setState(() {
        imageBytes = bytes;
      });
    }
  }

  Future<void> cropImage() async {
    if (imageBytes == null) {
      return;
    }
    final croppedImage = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CroppingPage(imageBytes: imageBytes!),
      ),
    );
    if (croppedImage != null) {
      setState(() {
        imageBytes = croppedImage;
      });
    }
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
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: pickImage,
                  child: const Text('Importer une image'),
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: cropImage,
                  icon: Icon(Icons.crop),
                  label: Text('Crop'),
                ),
              ],
            ),
            const SizedBox(height: 10),
            imageBytes != null
                ? Image.memory(imageBytes!, height: 300, fit: BoxFit.fitHeight)
                : const Text('Aucune image sélectionnée'),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
