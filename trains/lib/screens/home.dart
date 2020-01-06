import 'dart:async';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trains/screens/partenze_load.dart';
import 'package:trains/screens/login.dart';
import 'package:trains/services/database.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:trains/services/viaggiatreno.dart';
import 'package:location/location.dart';

class Home extends StatefulWidget {
  final Location provider = new Location();

  @override
  _HomeState createState() => _HomeState();
}

const List<String> choices = const <String>[
  "profile",
  "tutorial",
];

class _HomeState extends State<Home> {
  Map<String, dynamic> _nearestStation;
  DatabaseService _ds = DatabaseService();
  Future<LocationData> _location;

  @override
  void initState() {
    super.initState();
    widget.provider.changeSettings(accuracy: LocationAccuracy.BALANCED);
    setState(() {
      _location = _getCurrentLocation();
    });
  }

  Future<LocationData> _getCurrentLocation() async {
    try {
      return await widget.provider.getLocation();
    } on PlatformException catch (e) {
      if (e.code == "PERMISSION_DENIED") {
        return _getCurrentLocation();
      }
    }
  }

  void _select(String choice) {
    switch (choice) {
      case "profile":
        {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Login(false)));
        }
        break;
       case "tutorial":{
         print("tutorial");
        //Navigator.push(context,MaterialPageRoute(builder: (context) => Settings(s:"nickname")));
       }
       break;
    }
  }

  @override
  Widget build(BuildContext context) {
    //_ds.deleteAllEvaluations();//to delete all evaluations
    return Scaffold(
      backgroundColor: Colors.brown[50],
      appBar: AppBar(
        title: Text('Home'),
        backgroundColor: Color(0xff9b0014),
        elevation: 0.0,
        actions: <Widget>[
          PopupMenuButton<String>(
                icon: Icon(Icons.menu),
                onSelected: _select,
                itemBuilder: (BuildContext context) {
                  return choices.map((String choice) {
                    return PopupMenuItem<String>(
                      value: choice,
                      child: Text(choice),
                    );
                  }
                ).toList();
              },
            ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
                width: MediaQuery.of(context)
                    .size
                    .width, // or use fixed size like 200
                height: 150,
                child: FutureBuilder<LocationData>(
                    future: _location,
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
                        return Container();
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
            SizedBox(height: 20),
            //lista partenze stazione più vicina
            _getPartenze(),
          ],
        ),
      ),
    );
  }

  /// returns a RaisedButton with the nearest station if it has been found
  /// otherwise returns a CircularProgressIndicator widget
  Widget _getStation() {
    if (_nearestStation != null) {
      //print("scrivo: $_nearestStation['name']");
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
      return PartenzeLoad(
          fetchPartenze(
              toSearch: "S01700" + //_nearestStation['id'] +
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
                  ])),
          _nearestStation['id']);
    }
    return Center(child: CircularProgressIndicator(value: null));
  }
}
