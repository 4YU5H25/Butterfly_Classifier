import 'dart:io';

import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerScreen extends StatefulWidget {
  const ImagePickerScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ImagePickerScreenState createState() => _ImagePickerScreenState();
}

class _ImagePickerScreenState extends State<ImagePickerScreen> {
  File? _imageFile;
  String filepath = "";

  Future<void> _getImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        filepath = pickedFile.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Image'),
      ),
      body: Center(
        child: ScreenTypeLayout.builder(
          mobile: (BuildContext context) => _buildMobileLayout(context),
          desktop: (BuildContext context) => _buildDesktopLayout(context),
        ),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        if (_imageFile != null) ...[
          SizedBox(
            height: 200,
            child: Image.asset(filepath),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _imageFile = null;
                });
              },
              child: Text('Clear Image'),
            ),
          ),
        ] else ...[
          Padding(
            padding: const EdgeInsets.all(12),
            child: ElevatedButton(
              onPressed: () => _getImage(ImageSource.gallery),
              child: Text('Select Image from Gallery'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: ElevatedButton(
              onPressed: () => _getImage(ImageSource.camera),
              child: Text('Take a Photo'),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (_imageFile != null) ...[
                SizedBox(
                  height: 200,
                  child: Image.network(_imageFile!.path),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _imageFile = null;
                      });
                    },
                    child: Text('Clear Image'),
                  ),
                ),
              ] else ...[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () => _getImage(ImageSource.gallery),
                    child: Text('Select Image from Gallery'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () => _getImage(ImageSource.camera),
                    child: Text('Take a Photo'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
