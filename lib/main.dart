import 'package:flutter/material.dart';
import 'imagepicker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const ImagePickerScreen(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.purple,
        backgroundColor: Color.fromARGB(221, 26, 25, 25),
        primarySwatch: Colors.deepPurple,
      ),
    );
  }
}
