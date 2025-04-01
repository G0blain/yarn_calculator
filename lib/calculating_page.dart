import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:yarn_calculator/cropping_page.dart';
import 'package:image/image.dart' as imgPck;

enum ClusteringMethods {
  K_MEANS(label: 'K-Means'),
  TEST(label: 'Test'),
  HELLO_WORLD(label: 'Hello world');

  final String label;

  const ClusteringMethods({required this.label});
}

class CalculatingPage extends StatefulWidget {
  @override
  _CalculatingPageState createState() => _CalculatingPageState();
}

class _CalculatingPageState extends State<CalculatingPage> {
  Uint8List? _imageBytes;
  // imgPck.Image? workingImage;
  ClusteringMethods? _selectedClusteringMethod;
  final TextEditingController _kTextFieldController = TextEditingController(
    text: '3',
  );

  Future<void> _pickImage() async {
    final XFile? pickedFile = await new ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      final Uint8List bytes = await pickedFile.readAsBytes();
      setState(() {
        _imageBytes = bytes;
      });
    }
  }

  Future<void> _cropImage() async {
    if (_imageBytes == null) {
      return;
    }
    final croppedImage = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CroppingPage(imageBytes: _imageBytes!),
      ),
    );
    if (croppedImage != null) {
      setState(() {
        _imageBytes = croppedImage;
      });
    }
  }

  imgPck.Image _bytesToImage(Uint8List uint8list) {
    return imgPck.decodeImage(uint8list)!;
  }

  Uint8List _imageToBytes(imgPck.Image image) {
    return Uint8List.fromList(imgPck.encodePng(image));
  }

  void _test() {
    if (_imageBytes == null) {
      return;
    }
    imgPck.Image test = _bytesToImage(_imageBytes!);
    Uint8List test2 = _imageToBytes(test);
    setState(() {
      _imageBytes = test2;
    });
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
                  onPressed: _test,
                  icon: Icon(Icons.rocket),
                  label: Text('Test'),
                ),
              ],
            ),
            const SizedBox(height: 10),
            _imageBytes != null
                ? Image.memory(_imageBytes!, height: 300, fit: BoxFit.fitHeight)
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
                if (_selectedClusteringMethod == ClusteringMethods.K_MEANS) ...[
                  const SizedBox(width: 20),
                  const Text('K:', style: TextStyle(fontSize: 14)),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 60,
                    child: TextField(
                      controller: _kTextFieldController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 5,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _pickImage,
              icon: Icon(Icons.play_arrow),
              label: const Text('GO'),
            ),
          ],
        ),
      ),
    );
  }
}
