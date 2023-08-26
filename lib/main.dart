import 'package:flutter/material.dart';

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
