import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:trains/screens/partenze_load.dart';
import 'package:trains/services/auth.dart';
import 'package:trains/services/database.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:trains/services/location_provider.dart';
import 'package:trains/services/viaggiatreno.dart';
import 'package:location/location.dart';
import 'package:trains/screens/sidebar.dart';

class Home extends StatelessWidget {
  final DatabaseService _ds = DatabaseService();
  final AuthService _authService = AuthService();
  final Future<LocationData> _location = LocationProvider().fetchLocation();

  @override
  Widget build(BuildContext context) {
    _authService.getCurrentUser();
    return Scaffold(
      drawerEdgeDragWidth: MediaQuery.of(context).size.width / 2.6,
      backgroundColor: Colors.brown[50],
      appBar: AppBar(
        title: Text('Home'),
        backgroundColor: Color(0xff9b0014),
      ),
      drawer: SideBar("home"),
      body: Center(
        child: FutureBuilder<ConnectivityResult>(
            future: Connectivity().checkConnectivity(),
            builder: (contextConnectivity, connectivity) {
              if (connectivity.hasData &&
                  connectivity.data != ConnectivityResult.none) {
                return Column(
                  children: [
                    SizedBox(
                        width: MediaQuery.of(context).size.width,
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
                                return Center(
                                    child: CircularProgressIndicator());
                              }
                            })),
                    SizedBox(height: 20),
                    Text('La stazione più vicina è',
                        style: TextStyle(
                          fontSize: 20.0,
                        )),
                    SizedBox(height: 20),
                    FutureBuilder<LocationData>(
                        future: _location,
                        builder: (context, location) {
                          if (location.hasData) {
                            return FutureBuilder<Map<String, dynamic>>(
                                future: _ds.searchNearestStations(
                                    location.data.latitude,
                                    location.data.longitude),
                                builder: (context2, station) {
                                  if (station.hasData) {
                                    return Text(station.data['name'],
                                        style: TextStyle(
                                          fontSize: 20.0,
                                        ));
                                  } else if (station.hasError) {
                                    return Text("${station.error}");
                                  } else {
                                    return Center(
                                        child: CircularProgressIndicator());
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
                        )),
                    SizedBox(height: 20),
                    FutureBuilder<LocationData>(
                        future: _location,
                        builder: (context, location) {
                          if (location.hasData) {
                            return FutureBuilder<Map<String, dynamic>>(
                                future: _ds.searchNearestStations(
                                    location.data.latitude,
                                    location.data.longitude),
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
                                    return Center(
                                        child: CircularProgressIndicator());
                                  }
                                });
                          } else if (location.hasError) {
                            return Text("${location.error}");
                          } else {
                            return Center(child: CircularProgressIndicator());
                          }
                        }),
                  ],
                );
              } else if (connectivity.hasError) {
                return Text("${connectivity.error}");
              } else {
                return Center(
                    child: Text(
                        "Ops...\nNon riusciamo a trovare Rino e gli altri treni.\nRiprova connettendo lo smartphone alla rete.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20.0,
                        )));
              }
            }),
      ),
    );
  }
}
