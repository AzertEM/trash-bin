import 'package:flutter/material.dart';
import 'map.dart';
import 'database.dart';

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

class MyAppState extends ChangeNotifier {
    List<BinLocation>? locations;
    
    void getBins() async {
      locations = await DBprovider.db.getAllBins();
    }
}
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePage();
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
        page = const Placeholder();
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
