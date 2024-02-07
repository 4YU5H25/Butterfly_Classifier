import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:tflite/tflite.dart';
import 'imagepicker.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  String selectedImagePath = '';
  bool imageSubmitted = false;
  List<dynamic> recognitions = [];

  late List<String> labelList;

  @override
  void initState() {
    super.initState();
    loadModel();
  }

  Future<void> loadModel() async {
    String modelPath = 'assets/butter.tflite'; // Update the path
    String labelsPath = 'assets/labels.txt'; // Update the path

    await Tflite.loadModel(
      model: modelPath,
      labels: labelsPath,
    );

    String labelsContent = await rootBundle.loadString(labelsPath);
    labelList = labelsContent.split('\n');
  }

  Future<void> runModelOnImage(String imagePath) async {
    recognitions = await Tflite.runModelOnImage(
      path: imagePath,
      numResults: labelList.length,
      threshold: 0.1,
    ) as dynamic;
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 254, 75, 25),
        appBar: AppBar(
          title: const Text('Butterfly Classifier'),
        ),
        body: Container(
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 44, 43, 43),
          ),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Column(
                children: [
                  const SizedBox(height: 20), // Add margin

                  if (imageSubmitted && recognitions.isNotEmpty)
                    Text(
                      'Prediction: ${labelList[recognitions[0]['index']] ?? 'Unknown'}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white,
                            ),
                            padding: const EdgeInsets.all(10),
                            child: selectedImagePath == ''
                                ? Image.asset(
                                    'assets/image_placeholder.png',
                                    height: 200,
                                    width: 200,
                                    fit: BoxFit.fill,
                                  )
                                : Image.file(
                                    File(selectedImagePath),
                                    height: 200,
                                    width: 200,
                                    fit: BoxFit.fill,
                                  ),
                          ),
                          const SizedBox(height: 20),
                          // ElevatedButton(
                          //   onPressed: () async {

                          //   },
                          //   child: const Text('Select Image'),
                          // ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      selectedImagePath =
                          await Media.selectImageFromCamera() as String;
                      _showImageSelectionDialog();
                      setState(() {});
                    },
                    child: const Text('Take Picture'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () async {
                      selectedImagePath =
                          await Media.selectImageFromGallery() as String;
                      _showImageSelectionDialog();
                      setState(() {});
                    },
                    child: const Text('Upload from Gallery'),
                  ),
                ],
              ),
              Column(
                children: recognitions.map((result) {
                  int labelIndex = result['index'];
                  String className = labelList[labelIndex];
                  double confidence = result['confidence'];
                  return Column(
                    children: [
                      Text(
                        'Prediction: $className $confidence %',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Color.fromARGB(0, 255, 252, 243),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }



  Future<void> _showImageSelectionDialog() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Image Selection'),
          content: const Text('Do you want to use this image?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                setState(() {
                  imageSubmitted = true;
                });
                runModelOnImage(selectedImagePath); // Call the function here
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }
}
