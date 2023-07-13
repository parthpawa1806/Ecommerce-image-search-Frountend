import 'dart:convert';
import 'dart:io';

import 'package:ecommerce_image_search/screens/result_page.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  XFile? _image;

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: source);

    setState(() {
      if (pickedImage != null) {
        _image = XFile(pickedImage.path);
        _cropImage();
      } else {
        Fluttertoast.showToast(msg: 'No image selected');
      }
    });
  }

  Future<void> _cropImage() async {
    if (_image != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: _image!.path,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 100,
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: Colors.white,
              toolbarWidgetColor: Colors.green,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          IOSUiSettings(
            title: 'Cropper',
          ),
          WebUiSettings(
            context: context,
            presentStyle: CropperPresentStyle.dialog,
            boundary: const CroppieBoundary(
              width: 520,
              height: 520,
            ),
            viewPort:
                const CroppieViewPort(width: 480, height: 480, type: 'circle'),
            enableExif: true,
            enableZoom: true,
            showZoomer: true,
          ),
        ],
      ) ;
      if (croppedFile != null) {
        setState(() {
        
        });
      }
    }
  }


  Future<void> _navigateToResultPage() async {
    if (_image != null) {
      final url = 'http://110.227.255.212:6021/api/similar-images/';

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
        leading: Padding(
          padding: const EdgeInsets.only(right: 20),
          child: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.grey[500]),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        title: Center(
          child: Padding(
            padding: const EdgeInsets.only(right: 50),
            child: Text(
              'Visual Search',
              style: TextStyle(
                fontWeight: FontWeight.w100,
                color: Colors.grey,
                fontSize: 17,
              ),
            ),
          ),
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'lib/assets/bgimageee.jpg',
            fit: BoxFit.cover,
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withOpacity(0.5),
                  Colors.transparent,
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Center(
                    child: Text(
                      'Search For an Outfit by Uploading',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  const Center(
                    child: Text(
                      'Photo or Taking Image',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                  SizedBox(
                    width: 300,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: () => _pickImage(ImageSource.gallery),
                      child: Text('Choose from Gallery'),
                    ),
                  ),
                  SizedBox(height: 16),
                  SizedBox(
                    width: 300,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: () => _pickImage(ImageSource.camera),
                      child: Text('Take a Photo'),
                    ),
                  ),
                  SizedBox(height: 32),
                  SizedBox(
                    width: 300,
                    height: 60,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        side: BorderSide(
                          width: 2.0,
                          color: Colors.white,
                        ),
                      ),
                      onPressed: _navigateToResultPage,
                      child: Text(
                        'Submit Image',
                        style: TextStyle(color: Colors.white),
                      ),
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

class CropImageScreen extends StatefulWidget {
  final File image;

  CropImageScreen({required this.image});

  @override
  _CropImageScreenState createState() => _CropImageScreenState();
}

class _CropImageScreenState extends State<CropImageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crop Image'),
      ),
      body: Container(
        child: Image.file(widget.image),
      ),
    );
  }
}
