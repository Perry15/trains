import 'dart:async';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:trains/screens/partenze_load.dart';
import 'package:trains/services/auth.dart';
import 'package:trains/services/database.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:trains/services/location_provider.dart';
import 'package:trains/services/viaggiatreno.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:trains/models/user.dart';
import 'package:trains/screens/sidebar.dart';

class Home extends StatelessWidget {
  final Location provider = new Location();
  final DatabaseService _ds = DatabaseService();
  final AuthService _authService = AuthService();
  final Future<LocationData> _location = LocationProvider().fetchLocation();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    print("user: $user.displayName");
    _authService
        .getCurrentUser()
        .then((onValue) => {print("currentUser: $onValue")});
    //_ds.deleteAllEvaluations();//to delete all evaluations
    return Scaffold(
      drawerEdgeDragWidth: MediaQuery.of(context).size.width / 2.6,
      backgroundColor: Colors.brown[50],
      appBar: AppBar(
        title: Text('Home'),
        backgroundColor: Color(0xff9b0014),
      ),
      drawer: SideBar("home"),
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
                    builder: (context, location) {
                      if (location.hasData) {
                        return GoogleMap(
                          myLocationEnabled: true,
                          mapType: MapType.normal,
                          initialCameraPosition: CameraPosition(
                              target: LatLng(location.data.latitude,
                                  location.data.longitude),
                              zoom: 12.0),
                          zoomGesturesEnabled: true,
                          compassEnabled: true,
                        );
                      } else if (location.hasError) {
                        return Text("${location.error}");
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    })),
            SizedBox(height: 20),
            Text('La stazione più vicina è',
                style: TextStyle(
                  fontSize: 20.0,
                  //fontWeight: FontWeight.w500,
                )),
            SizedBox(height: 20),
            FutureBuilder<LocationData>(
                future: _location,
                builder: (context, location) {
                  if (location.hasData) {
                    return FutureBuilder<Map<String, dynamic>>(
                        future: _ds.searchNearestStations(
                            location.data.latitude, location.data.longitude),
                        builder: (context2, station) {
                          if (station.hasData) {
                            return Text(station.data['name'],
                                style: TextStyle(
                                  fontSize: 20.0,
                                  //fontWeight: FontWeight.w500,
                                ));
                          } else if (station.hasError) {
                            return Text("${station.error}");
                          } else {
                            return Center(child: CircularProgressIndicator());
                          }
                        });
                  } else if (location.hasError) {
                    return Text("${location.error}");
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                }),
            SizedBox(height: 20),
            Text('Dove vuoi andare?',
                style: TextStyle(
                  fontSize: 20.0,
                  //fontWeight: FontWeight.w500,
                )),
            SizedBox(height: 20),
            //lista partenze stazione più vicina
            FutureBuilder<LocationData>(
                future: _location,
                builder: (context, location) {
                  if (location.hasData) {
                    return FutureBuilder<Map<String, dynamic>>(
                        future: _ds.searchNearestStations(
                            location.data.latitude, location.data.longitude),
                        builder: (context2, station) {
                          if (station.hasData) {
                            return PartenzeLoad(
                                fetchPartenze(
                                    toSearch: station.data['id'] +
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
                                station.data['id']);
                          } else if (station.hasError) {
                            return Text("${station.error}");
                          } else {
                            return Center(child: CircularProgressIndicator());
                          }
                        });
                  } else if (location.hasError) {
                    return Text("${location.error}");
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                }),
          ],
        ),
      ),
    );
  }
}
