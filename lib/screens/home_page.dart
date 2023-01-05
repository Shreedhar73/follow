import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

   // on below line we have created the list of markers
  final List<Marker> _markers = <Marker>[
    const Marker(
      markerId: MarkerId('1'),
      position:  LatLng(1223, -122.085749655962),
      infoWindow: InfoWindow(
        title: 'My Position',
      )
  ),
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: GoogleMap(
          initialCameraPosition: _kGooglePlex,
          markers: Set<Marker>.of(_markers),
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
            
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: ()async{
            getUserCurrentLocation().then((value) async {
            // print(value.latitude.toString() +" "+value.longitude.toString());
 
            // marker added for current users location
            _markers.add(
                Marker(
                  markerId: const MarkerId("2"),
                  position: LatLng(value.latitude, value.longitude),
                  infoWindow: const InfoWindow(
                    title: 'Current Location',
                  ),
                )
            );
 
            // specified current users location
            CameraPosition cameraPosition =  CameraPosition(
              target: LatLng(value.latitude, value.longitude),
              zoom: 14,
            );
 
            final GoogleMapController controller = await _controller.future;
            controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
            setState(() {
            });
          });
          },
          child: const Icon(Icons.location_on),
        ),
      ),
    );
  }
}

 // created method for getting user current location
  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission().then((value){
    }).onError((error, stackTrace) async {
      await Geolocator.requestPermission();
    });
    return await Geolocator.getCurrentPosition();
  }