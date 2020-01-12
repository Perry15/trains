import 'dart:async';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:trains/screens/info.dart';

import 'package:trains/screens/partenze_load.dart';
import 'package:trains/screens/login.dart';
import 'package:trains/screens/ranking.dart';
import 'package:trains/services/auth.dart';
import 'package:trains/screens/profile.dart';
import 'package:trains/screens/valutazione_treno.dart';
import 'package:trains/services/database.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:trains/services/location_provider.dart';
import 'package:trains/services/viaggiatreno.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:trains/models/user.dart';

class Home extends StatelessWidget {
  final Location provider = new Location();
  final DatabaseService _ds = DatabaseService();
  final AuthService _authService = AuthService();
  final Future<LocationData> _location = LocationProvider().fetchLocation();
  final List<String> choices = const <String>[
    "Il tuo profilo",
    "Classifica",
    "Tutorial",
    "Informazioni",
    "Logout",
  ];

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    print("user: $user.displayName");
    _authService
        .getCurrentUser()
        .then((onValue) => {print("currentUser: $onValue")});
    //_ds.deleteAllEvaluations();//to delete all evaluations
    return Scaffold(
      backgroundColor: Colors.brown[50],
      appBar: AppBar(
        title: Text('Home'),
        backgroundColor: Color(0xff9b0014),
        elevation: 0.0,
        actions: <Widget>[
          /*user != null
              ? FlatButton.icon(
                  icon: Icon(Icons.person),
                  label: Text('Logout'),
                  onPressed: () {
                    _authService.signOut();
                  },
                )
              : SizedBox(),*/
          PopupMenuButton<String>(
            icon: Icon(Icons.menu),
            onSelected: (choice) {
              switch (choice) {
                case "Classifica":
                  {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Ranking()));
                  }
                  break;
                case "Il tuo profilo":
                  {
                    if (user != null)
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Profile()));
                    else
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Login(false)));
                  }
                  break;
                case "Tutorial":
                  {
                    print("Tutorial");
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ValutazioneTreno()));
                  }
                  break;
                case "Informazioni":
                  {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Info()));
                  }
                  break;
                case "Logout":
                  {
                    _authService.signOut();
                  }
                  break;
              }
            },
            itemBuilder: (BuildContext context) {
              return choices.map((String choice) {
                if (user == null && choice == "Logout") return null;
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
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
