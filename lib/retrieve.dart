// ignore_for_file: library_private_types_in_public_api

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'database.dart';

class ImageRetrieveScreen extends StatefulWidget {
  const ImageRetrieveScreen({Key? key}) : super(key: key);

  @override
  _ImageRetrieveScreenState createState() => _ImageRetrieveScreenState();
}

class _ImageRetrieveScreenState extends State<ImageRetrieveScreen> {
  Future<Uint8List?> _getImage() async {
    final images = await ImageDatabaseHelper.instance.getImages();
    if (images.isNotEmpty) {
      final imageBytes = images.first['image'];
      return Uint8List.fromList(imageBytes);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Image Retrieve')),
      body: FutureBuilder<Uint8List?>(
        future: _getImage(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Text('No image found.');
          } else {
            // Display the retrieved image using the Image.memory widget
            return Center(
              child: Image.memory(snapshot.data!),
            );
          }
        },
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: ImageRetrieveScreen(),
  ));
}
