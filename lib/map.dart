import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'database.dart';

class MapGenerator extends StatefulWidget {
  const MapGenerator({super.key});

  @override
  State<MapGenerator> createState() => _MapGeneratorState();
}

class _MapGeneratorState extends State<MapGenerator> {
  // late GoogleMapController mapController;
  LatLng? _currentPosition;
  bool _isLoading = true;
  var locations;

  @override
  void initState() {
    super.initState();
    getLocation();
  }
  getLocation() async {
    LocationPermission permission;
    permission = await Geolocator.requestPermission();

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    double lat = position.latitude;
    double long = position.longitude;

    LatLng location = LatLng(lat, long);

    setState(() {
      _currentPosition = location;
      _isLoading = false;
    });

    locations =await DBprovider.db.getAllBins();
  }
  BitmapDescriptor currentLocationIcon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure);
  // void _onMapCreated(GoogleMapController controller) {
  @override
  Widget build(BuildContext context) {

    return _isLoading? const Center(child: CircularProgressIndicator(),) : 
      GoogleMap(
      // onMapCreated: _onMapCreated,
      initialCameraPosition: CameraPosition(
          target: _currentPosition!,
          zoom: 15.0,
      ),
      markers: {
        Marker( 
          markerId: const MarkerId('Home'),
          icon: currentLocationIcon,
          position: _currentPosition!,
        ),

        for (var location in locations)
          Marker(
            markerId: const MarkerId('bin'),
            position: LatLng(location.latitude, location.longitude),
          )
      }
    );
  }
}
