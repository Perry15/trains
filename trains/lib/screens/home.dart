import 'package:flutter/material.dart';
import 'package:trains/screens/destination.dart';

import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:trains/services/geolocation.dart';

import 'package:geolocator/geolocator.dart';


class Home extends StatefulWidget {

  @override
  _HomeState createState() => _HomeState();

}

class _HomeState extends State<Home> {
  final _geolocationService = Geolocation();
  Position _position;

  _HomeState() {
    _geolocationService.getCurrentPosition().then((val) => setState(() {
      _position = val;
    }));
  }

  //----- per vedere mappa
  Completer<GoogleMapController> _controller = Completer();
  static const LatLng _center = const LatLng(45.521563, -122.677433);
  void _onMapCreated(GoogleMapController controller){
    _controller.complete(controller);
  }
  //-----


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[50],
      appBar: AppBar(
        title: Text('Home'),
        backgroundColor: Color(0xff9b0014),
        elevation: 0.0,
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width, // or use fixed size like 200
              height: 200,
              child: GoogleMap(
                onMapCreated: _onMapCreated,
                myLocationEnabled: true,
                mapType: MapType.normal,
                initialCameraPosition: CameraPosition(
                  target: _center,
                  zoom: 11.0,
                ),
              )
            ),
            Text(
              _position.toString(),
            ),
            RaisedButton(
              color: Color(0xff9b0014),
              child: Text(
                'Cerca destinazione',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Destination()),
                );
              },
            ),
          ],
      ),
      ),
    );
  }

}

/*
Center(
RaisedButton(
                color: Color(0xff9b0014),
                child: Text(
                  'Cerca destinazione',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Destination()),
                  );
                },
              ),
             ),
              */
/*
GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: const LatLng(_position.latitude, _position.longitude),
                  zoom: 11.0,
                ),
              ),
      );
 */
