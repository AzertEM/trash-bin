import 'database.dart';
import 'package:flutter/material.dart';

class MyAppState extends ChangeNotifier {
    List<BinLocation>? locations;
    
    void getBins() async {
      locations = await DBprovider.db.getAllBins();
    }
}