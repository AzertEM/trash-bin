import 'package:flutter/material.dart';
import 'upload.dart';
import 'retrieve.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => ImageUploaderScreen(),
        '/retrieve': (context) => ImageRetrieveScreen(),
        // Add other routes if needed
      },
    );
  }
}