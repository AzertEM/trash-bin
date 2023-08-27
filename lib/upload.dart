// ignore_for_file: library_private_types_in_public_api, prefer_const_constructors, avoid_print

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'retrieve.dart';
import 'database.dart';

// setting up a screen where users can upload images
class ImageUploaderScreen extends StatefulWidget {
  const ImageUploaderScreen({Key? key}) : super(key: key);

  @override
  _ImageUploaderScreenState createState() => _ImageUploaderScreenState();
}

// // handles the core functionality of uploading an image from the gallery
// // and displaying a simple UI to trigger the image upload process
// class _ImageUploaderScreenState extends State<ImageUploaderScreen> {
//   final picker = ImagePicker();

//   Future<void> _uploadImage() async {
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);
//     if (pickedFile == null) {
//       print("No image selected");
//       return;
//     }

//     final Uint8List imageBytes = await pickedFile.readAsBytes();
//     print("Image bytes read: ${imageBytes.length} bytes");

//     final insertedId =
//         await ImageDatabaseHelper.instance.insertImage(imageBytes);
//     print("Image inserted with ID: $insertedId");

//     setState(() {});
//     // Navigator.pushNamed(context, '/retrieve'); // Navigate to retrieve screen
//   }

class _ImageUploaderScreenState extends State<ImageUploaderScreen> {
  final picker = ImagePicker();

  Future<void> _uploadImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) {
      print("No image selected");
      return;
    }

    final Uint8List imageBytes = await pickedFile.readAsBytes();
    print("Image bytes read: ${imageBytes.length} bytes");

    final insertedId =
        await ImageDatabaseHelper.instance.insertImage(imageBytes);
    print("Image inserted with ID: $insertedId");

    setState(() {});
    // Navigator.pushNamed(context, '/retrieve'); // Navigate to retrieve screen
  }

  Future<void> _navigateToRetrieve() async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ImageRetrieveScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Image Uploader')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _uploadImage,
              child: const Text('Upload Image'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _navigateToRetrieve,
              child: const Text('Retrieve Images'),
            ),
          ],
        ),
      ),
    );
  }
}

// sets up the ImageListScreen widget to be a stateful widget
class ImageListScreen extends StatefulWidget {
  const ImageListScreen({Key? key}) : super(key: key);

  @override
  _ImageListScreenState createState() => _ImageListScreenState();
}

// fetch images from the database and render them in a list
class _ImageListScreenState extends State<ImageListScreen> {
  // This variable will hold the result of fetching images from the database
  late Future<List<Map<String, dynamic>>> _images;

  @override
  void initState() {
    super.initState();
    _images = ImageDatabaseHelper.instance.getImages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Image List')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _images,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Text('No images found.');
          } else {
            // builds each image using the Image.memory widget
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final imageBytes = snapshot.data![index]['image'];
                // converts the image bytes into a Uint8List that Image.memory can display
                return Image.memory(Uint8List.fromList(imageBytes));
              },
            );
          }
        },
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: ImageUploaderScreen(),
  ));
}
