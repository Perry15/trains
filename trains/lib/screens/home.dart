import 'dart:async';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:trains/screens/partenze_load.dart';
import 'package:trains/services/database.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:trains/services/viaggiatreno.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map<String, dynamic> _nearestStation;
  DatabaseService _ds = DatabaseService();
  //GoogleMapController _mapController;
  Completer<GoogleMapController> controller;
  Future<Position> _position;

  @override
  void initState() {
    super.initState();
    _position = _getCurrentLocation();
  }

  Future<Position> _getCurrentLocation() async {
    return await Geolocator().getCurrentPosition();
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
                width: MediaQuery.of(context)
                    .size
                    .width, // or use fixed size like 200
                height: 300,
                child: FutureBuilder(
                    future: _position,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        _ds
                            .searchNearestStations(
                                snapshot.data.latitude, snapshot.data.longitude)
                            .then((val) => setState(() {
                                  _nearestStation = val;
                                }));
                        return GoogleMap(
                          myLocationEnabled: true,
                          mapType: MapType.normal,
                          initialCameraPosition: CameraPosition(
                              target: LatLng(snapshot.data.latitude,
                                  snapshot.data.longitude),
                              zoom: 12.0),
                          zoomGesturesEnabled: true,
                          compassEnabled: true,
                        );
                      } else if (snapshot.hasError) {
                        return Text("${snapshot.error}");
                      } else {
                        return CircularProgressIndicator();
                      }
                    })),
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

  /*void refresh() async {
    LocationData currentLocation;
    final location = Location();

    currentLocation = await location.getLocation();
    final lat = currentLocation.latitude;
    final lng = currentLocation.longitude;
    final center = LatLng(lat, lng);
    _ds.searchNearestStations(lat, lng).then((val) => setState(() {
          _nearestStation = val;
        }));
    _mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: center == null ? LatLng(0, 0) : center, zoom: 15.0)));
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      _mapController = controller;
    });
    refresh();
  }*/

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
