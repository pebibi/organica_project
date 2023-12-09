import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Delivery Map',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const DeliveryMapScreen(),
    );
  }
}

class DeliveryMapScreen extends StatefulWidget {
  const DeliveryMapScreen({Key? key}) : super(key: key);

  @override
  _DeliveryMapScreenState createState() => _DeliveryMapScreenState();
}

class _DeliveryMapScreenState extends State<DeliveryMapScreen> {
  final LatLng _initialCameraPosition = const LatLng(37.7749, -122.4194);
  late GoogleMapController _mapController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delivery Map'),
      ),
      body: GoogleMap(
        initialCameraPosition:
            CameraPosition(target: _initialCameraPosition, zoom: 15),
        onMapCreated: (controller) {
          setState(() {
            _mapController = controller;
          });
        },
        markers: {
          Marker(
            markerId: const MarkerId('deliveryLocation'),
            position: _initialCameraPosition,
            infoWindow: const InfoWindow(title: 'Delivery Location'),
          ),
        },
      ),
    );
  }
}
