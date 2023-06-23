import 'dart:convert';
import 'dart:io';
import 'package:ecommerce_image_search/screens/result_page.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

import 'animation.dart';


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  File? _image;

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: source);

    setState(() {
      if (pickedImage != null) {
        _image = File(pickedImage.path);
      } else {
        Fluttertoast.showToast(msg: 'No image selected');
      }
    });
  }

  Future<void> _navigateToResultPage() async {
    if (_image != null) {
      final url = 'http://192.168.42.251:8000/api/similar-images/'; 

      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.files.add(
        await http.MultipartFile.fromPath('image', _image!.path),
      );

      var response = await request.send();

      if (response.statusCode == 200) {
        var responseString = await response.stream.bytesToString();
        final responseData = jsonDecode(responseString);

        final similarImages = responseData["similar_images"] as List<dynamic>;

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResultScreen(similarImages),
          ),
        );
      } else {
        Fluttertoast.showToast(msg: 'Failed to send image');
      }
    } else {
      Fluttertoast.showToast(msg: 'No image selected');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Center(child: Text('Image Picker Demo',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.purple),)),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'lib/assets/downlaaad.jpg',
            fit: BoxFit.cover,
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withOpacity(0.5),
                  Colors.transparent,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedText(),
                  SizedBox(height: 50),
                  SizedBox(
                    width: 200,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: () => _pickImage(ImageSource.gallery),
                      child: Text('Choose from Gallery'),
                    ),
                  ),
                  SizedBox(height: 16),
                  SizedBox(
                    width: 200,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: () => _pickImage(ImageSource.camera),
                      child: Text('Take a Photo'),
                    ),
                  ),
                  SizedBox(height: 32),
                  SizedBox(
                    width: 200,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: _navigateToResultPage,
                      child: Text('Submit Image'),
                    ),
                  ),
                  SizedBox(height: 32),
                  
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
