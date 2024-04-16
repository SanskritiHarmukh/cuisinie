import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_v2/tflite_v2.dart';

class SmartSearchPage extends StatefulWidget {
  @override
  _SmartSearchPageState createState() => _SmartSearchPageState();
}

class _SmartSearchPageState extends State<SmartSearchPage> {
  File? _image;
  String _result = '';
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _loading = true;
    loadModel().then((value) {
      setState(() {
        _loading = false;
      });
    });
  }

  Future loadModel() async {
    await Tflite.loadModel(
      model: 'assets/model.tflite',
      labels: 'assets/labels.txt',
    );
  }

  Future classifyImage() async {
    setState(() {
      _loading = true;
    });

    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      _image = File(pickedFile.path);

      var prediction = await Tflite.runModelOnImage(
        path: _image!.path,
        numResults: 1,
        threshold: 0.5,
        imageMean: 127.5,
        imageStd: 127.5,
      );

      if (prediction != null && prediction.isNotEmpty) {
        setState(() {
          _result = prediction[0]['label']?.split(' ').last ?? ''; // Extracting last part of label
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Smart Search'),
      ),
      backgroundColor: Color(0xFF25262A), // Background color
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _image == null
                ? Text('No image selected.', style: TextStyle(color: Colors.white))
                : Image.file(_image!),
            SizedBox(height: 10,),
            ElevatedButton(
              onPressed: classifyImage,
              style: ElevatedButton.styleFrom(
                primary: Color(0xFFE4AD0C), // Button background color
              ),
              child: Text(
                'Classify Image',
                style: TextStyle(color: Color(0xFF25262A)), // Button text color
              ),
            ),
            SizedBox(height: 10,),
            Text(
              'Result: $_result',
              style: TextStyle(color: Colors.white), // Result text color
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    title: 'Smart Search',
    theme: ThemeData(primarySwatch: Colors.blue),
    home: SmartSearchPage(),
  ));
}
