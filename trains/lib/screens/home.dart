import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:trains/screens/destination.dart';

import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:trains/services/geolocation.dart';

import 'package:geolocator/geolocator.dart';

import 'package:trains/services/database.dart';

class Home extends StatefulWidget {

  @override
  _HomeState createState() => _HomeState();

}

class _HomeState extends State<Home> {
  final _geolocationService = Geolocation();
  Position _position;
  Map<String,dynamic> _nearestStation;
  DatabaseService ds = DatabaseService();

  _HomeState() {
    _geolocationService.getCurrentPosition().then((val) => setState(() {
      _position = val;
      if (_position != null){
        ds.searchNearestStations(_position.latitude, _position.longitude).then((val) => setState(() {
          _nearestStation = val;
        }));
      }
    }));

  }


  //----- per vedere mappa
  GoogleMapController _mapController;
  static const LatLng _center = LatLng(0,0);
  void _onMapCreated(GoogleMapController controller){
    _mapController = controller;
    refresh();
  }
  //-----

  void refresh() async {
    _mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: _position == null ? LatLng(0, 0) : LatLng(_position.latitude, _position.longitude), zoom: 15.0)));
  }

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
              //_position.toString(),
              'La stazione più vicina è'
            ),
              _station(),

          ],
      ),
      ),
    );
  }
  Widget _station(){
    if(_nearestStation != null){
      print("scrivo: $_nearestStation['name']");
      return RaisedButton(
        color: Color(0xff9b0014),
        child: Text(
        _nearestStation['name'],
        style: TextStyle(color: Colors.white),
      ),
      onPressed: () async {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Destination()),
        );
      },
      );
    }
    return  Text('');

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
