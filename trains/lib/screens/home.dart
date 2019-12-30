import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:trains/screens/partenze_load.dart';

import 'package:trains/services/database.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as LocationManager;
import 'package:trains/services/viaggiatreno.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map<String, dynamic> _nearestStation;
  DatabaseService ds = DatabaseService();
  GoogleMapController _mapController;

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
                width: MediaQuery.of(context)
                    .size
                    .width, // or use fixed size like 200
                height: 300,
                child: GoogleMap(
                  onMapCreated: _onMapCreated,
                  myLocationEnabled: true,
                  mapType: MapType.normal,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(0.0, 0.0),
                    zoom: 11.0,
                  ),
                )),
            SizedBox(height: 20),
            Text('La stazione più vicina è',
                style: TextStyle(
                  fontSize: 20.0,
                  //fontWeight: FontWeight.w500,
                )),
            SizedBox(height: 20),
            _getStation(),
            SizedBox(height: 20),
            Text('Dove vuoi andare?',
                style: TextStyle(
                  fontSize: 20.0,
                  //fontWeight: FontWeight.w500,
                )),

            //lista partenze stazione più vicina
            _getPartenze(),
          ],
        ),
      ),
    );
  }

  void refresh() async {
    final center = await getUserLocation();
    _mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: center == null ? LatLng(0, 0) : center, zoom: 15.0)));
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    refresh();
  }

  /// returns the position of the user and search the nearest station setting it
  Future<LatLng> getUserLocation() async {
    LocationManager.LocationData currentLocation;
    final location = LocationManager.Location();
    try {
      currentLocation = await location.getLocation();
      final lat = currentLocation.latitude;
      final lng = currentLocation.longitude;
      final center = LatLng(lat, lng);
      ds.searchNearestStations(lat, lng).then((val) => setState(() {
            _nearestStation = val;
          }));
      return center;
    } on Exception {
      currentLocation = null;
      return null;
    }
  }

  /// returns a RaisedButton with the nearest station if it has been found
  /// otherwise returns a CircularProgressIndicator widget
  Widget _getStation() {
    if (_nearestStation != null) {
      print("scrivo: $_nearestStation['name']");
      return Text(_nearestStation['name'],
          style: TextStyle(
            fontSize: 20.0,
            //fontWeight: FontWeight.w500,
          ));
      /*ButtonTheme(
            minWidth: MediaQuery.of(context)
                .size
                .width-100,
            height: 50.0,
            child: RaisedButton(
              color: Color(0xff9b0014),
              child: Text(
                _nearestStation['name'],
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PartenzeLoad(
                    fetchPartenze(
                      toSearch: _nearestStation['id']+'/'+formatDate(DateTime.now(),
                      [
                        D,
                        ' ',
                        M,
                        ' ',
                        d,
                        ' ',
                        yyyy,
                        ' ',
                        HH,
                        ':',
                        nn,
                        ':',
                        ss,
                        ' ',
                        z
                      ])
                    )
                  )),
                );
              },
            ),
        );*/
    }
    return Center(child: CircularProgressIndicator(value: null));
  }

  Widget _getPartenze() {
    if (_nearestStation != null) {
      print(formatDate(DateTime.now(),
          [D, ' ', M, ' ', d, ' ', yyyy, ' ', HH, ':', nn, ':', ss, ' ', z]));
      return PartenzeLoad(fetchPartenze(
          toSearch: _nearestStation['id'] +
              '/' +
              formatDate(DateTime.now(), [
                D,
                ' ',
                M,
                ' ',
                d,
                ' ',
                yyyy,
                ' ',
                HH,
                ':',
                nn,
                ':',
                ss,
                ' ',
                z
              ])));
    }
    return Center(child: CircularProgressIndicator(value: null));
  }
}
