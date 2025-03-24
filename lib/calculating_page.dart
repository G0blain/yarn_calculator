import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CalculatingPage extends StatefulWidget {
  const CalculatingPage({super.key, required this.title});

  final String title;

  @override
  State<CalculatingPage> createState() => _CalculatingPageState();
}

class _CalculatingPageState extends State<CalculatingPage> {
  final ImagePicker _picker = ImagePicker();
  Uint8List? _imageBytes;

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final Uint8List bytes = await pickedFile.readAsBytes();
      setState(() {
        _imageBytes = bytes;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Theme.of(context).colorScheme.inversePrimary, title: Text(widget.title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(onPressed: _pickImage, child: const Text('Importer une image')),
            const SizedBox(height: 10),
            _imageBytes != null
                ? Image.memory(_imageBytes!, width: 300, height: 300, fit: BoxFit.cover)
                : const Text('Aucune image sélectionnée'),
          ],
        ),
      ),
    );
  }
}
