import 'package:flutter/material.dart';
import 'database.dart';
import 'package:image_picker/image_picker.dart';
import 'photo.dart';
import 'utility.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: HomePage(),
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePage();
}


class MyAppState extends ChangeNotifier {
  var images = <Photo>[];

  pickImageFromGallery() {
    ImagePicker().pickImage(source: ImageSource.gallery).then((imgFile) async {
        String imgString = Utility.base64String(await imgFile!.readAsBytes());
        print(imgString);
        Photo photo1 = Photo(0, imgString);
        var dbHelper = DBHelper();
        dbHelper.save(photo1);
        // refreshImages();
    });
  }

  gridView(){
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 1.0,
        mainAxisSpacing: 4.0,
        crossAxisSpacing: 4.0,
        children: images.map((photo) {
          print("photo name");
          print(photo.photoName);
          return Utility.imageFromBase64String(photo.photoName ?? "");
        }).toList(),
      ),
    );
  }
}

class _HomePage extends State<HomePage> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar (
          onDestinationSelected: (int index) {
            setState(() {
              currentPageIndex = index;
            });
          },
          selectedIndex: currentPageIndex,
          destinations: const [
            NavigationDestination(
              selectedIcon: Icon(Icons.map),
              icon: Icon(Icons.map_outlined), 
              label: 'Map',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.find_in_page),
              icon: Icon(Icons.find_in_page_outlined), 
              label: 'Find',
            ),
          ],
        ),
      );
    }
  }
