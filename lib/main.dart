import 'package:flutter/material.dart';
import 'package:trash_bin/upload.dart';
import 'database.dart';
import 'package:image_picker/image_picker.dart';
import 'photo.dart';
import 'utility.dart';
import 'map.dart';

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

 
class GalleryAccess extends StatefulWidget {
  const GalleryAccess({super.key});
 
  @override
  State<GalleryAccess> createState() => _GalleryAccessState();
}
 
class _GalleryAccessState extends State<GalleryAccess> {
  File? galleryFile;
  final picker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    //display image selected from gallery
 
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gallery and Camera Access'),
        backgroundColor: Colors.green,
        actions: const [],
      ),
      body: Builder(
        builder: (BuildContext context) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.green)),
                  child: const Text('Select Image from Gallery and Camera'),
                  onPressed: () {
                    _showPicker(context: context);
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 200.0,
                  width: 300.0,
                  child: galleryFile == null
                      ? const Center(child: Text('Sorry nothing selected!!'))
                      : Center(child: Image.file(galleryFile!)),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 18.0),
                  child: Text(
                    "GFG",
                    textScaleFactor: 3,
                    style: TextStyle(color: Colors.green),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
 
  void _showPicker({
    required BuildContext context,
  }) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Photo Library'),
                onTap: () {
                  getImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () {
                  getImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }
 
  Future getImage(
    ImageSource img,
  ) async {
    final pickedFile = await picker.pickImage(source: img);
    XFile? xfilePick = pickedFile;
    setState(
      () {
        if (xfilePick != null) {
          galleryFile = File(pickedFile!.path);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(// is this context <<<
              const SnackBar(content: Text('Nothing is selected')));
        }
      },
    );
  }
}
class _HomePage extends State<HomePage> {
  int currentPageIndex = 0;


  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    Widget page;
    switch (currentPageIndex) {
      case 0:
        page = const MapGenerator();
        break;
      case 1:
        page = const GalleryAccess();
      default:
        throw UnimplementedError('Not implemented :<');
    }
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
  
      body: page,
    );
    }
  }
