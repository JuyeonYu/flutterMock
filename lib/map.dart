import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'search.dart';
import 'package:geolocator/geolocator.dart';

class Map extends StatefulWidget {
  const Map({super.key});

  @override
  State<Map> createState() => _MapState();
}

class _MapState extends State<Map> {
  late GoogleMapController mapController;
  LatLng? _currentPosition;

  final LatLng _center = const LatLng(45.521563, -122.677433);

  Future<void> _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  void _getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.deniedForever) {
        await setCurrentPosition();
        return;
      }
    }
    await setCurrentPosition();
  }

  Future<void> setCurrentPosition() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(position.latitude, position.longitude), zoom: 15.0)));

    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Stack(
          children: [
            GoogleMap(
                myLocationButtonEnabled: false,
                myLocationEnabled: true,
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                    target:
                        _currentPosition == null ? _center : _currentPosition!,
                    zoom: 11.0)),
            Positioned(
                top: 50,
                left: 8,
                right: 8,
                child: Container(
                    color: Colors.white,
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Search()));
                        },
                        child: Row(
                          children: [
                            Icon(Icons.search),
                            Text('장소, 주소  검색'),
                          ],
                        ))))
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _getCurrentLocation();
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
