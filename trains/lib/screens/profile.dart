import 'package:flutter/material.dart';
import 'package:trains/screens/ranking.dart';
import 'package:trains/services/database.dart';
import 'package:trains/models/user.dart';
import 'package:provider/provider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:trains/screens/settings.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final DatabaseService _dbService = DatabaseService();

  void _select(String choice) {
    switch (choice) {
      case "settings":
        {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Settings()));
        }
        break;
      /*
       case "Nickname":{
        Navigator.push(context,MaterialPageRoute(builder: (context) => Settings(s:"nickname")));
       }
       break;
       */
    }
  }

  Future<Map<String, dynamic>> getUserData(BuildContext context) async {
    final user = Provider.of<User>(context);
    //_dbService.updateUserPoints(user.uid,20,10,20);
    return await _dbService.getUserById(user.uid);
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    //getUserData(context);
    //checkImage(context);
    return Scaffold(
      backgroundColor: Colors.brown[50],
      appBar: AppBar(
        backgroundColor: Color(0xff9b0014),
        title: Text('Il tuo profilo'),
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              _select("settings");
            },
          ),
          /*PopupMenuButton<String>(
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
            ),*/
        ],
      ),
      body: Center(
        child: Stack(
            alignment: AlignmentDirectional.bottomCenter,
            overflow: Overflow.visible,
            children: <Widget>[
              Positioned(
                top:0,
                child:SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 6,
                  child:const DecoratedBox(
                    decoration: const BoxDecoration(
                      color: Color(0xff9b0014),
                    ),
                  ),
                ),
              ),
              FutureBuilder<Image>(
                  future: _dbService.checkUserImageById(user.uid),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Positioned(
                        top: 15,
                        child: CircleAvatar(
                          radius: 90,
                          backgroundColor: Colors.brown[50],
                          child: ClipOval(
                            child: new SizedBox(
                              width: 160.0,
                              height: 160.0,
                              child: snapshot.data,
                            ),
                          ),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Text("ERROR: ${snapshot.error}");
                    } else {
                      return Positioned(
                        top: 15,
                        child: CircleAvatar(
                          radius: 90,
                          backgroundColor: Colors.brown[50],
                          child: ClipOval(
                            child: new SizedBox(
                              width: 160.0,
                              height: 160.0,
                              child: CircularProgressIndicator(
                                strokeWidth: 7,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                  }),
              FutureBuilder<Map<String, dynamic>>(
                  future: getUserData(context),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var data = snapshot.data;
                      return Stack(
                        alignment: AlignmentDirectional.bottomCenter,
                        overflow: Overflow.visible,
                        children: <Widget>[
                          Positioned(
                            top: 195,
                            child: Text('${data['displayName']}',
                                style: TextStyle(
                                  fontSize: 25.0,
                                  fontWeight: FontWeight.w600,
                                )),
                          ),
                          Positioned(
                            top: 260,
                            left: 0,
                            child: Column(
                              children: <Widget>[
                                Icon(
                                  Icons.assignment_turned_in,
                                  color: Colors.black,
                                  size: 50.0,
                                  semanticLabel:
                                      'Text to announce in accessibility modes',
                                ),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width / 3,
                                  child: Text('${data['valutationsPoints']}',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 25.0)),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            top: 260,
                            left: MediaQuery.of(context).size.width / 3,
                            child: Column(
                              children: <Widget>[
                                Icon(
                                  Icons.train,
                                  color: Colors.black,
                                  size: 50.0,
                                  semanticLabel:
                                      'Text to announce in accessibility modes',
                                ),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width / 3,
                                  child: Text('${data['trainsPoints']}',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 25.0)),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            top: 260,
                            left: MediaQuery.of(context).size.width / 3 * 2,
                            child: Column(
                              children: <Widget>[
                                Icon(
                                  Icons.access_time,
                                  color: Colors.black,
                                  size: 50.0,
                                  semanticLabel:
                                      'Text to announce in accessibility modes',
                                ),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width / 3,
                                  child: Text('${data['locationsPoints']}',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 25.0)),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            top: 350,
                            child: new CircularPercentIndicator(
                              radius: 150.0,
                              animation: true,
                              animationDuration: 1200,
                              lineWidth: 13.0,
                              percent: data['level'] - data['level'].toInt(),
                              center: new Text(
                                "Livello ${data['level'].toInt()}",
                                style: new TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0),
                              ),
                              circularStrokeCap: CircularStrokeCap.butt,
                              backgroundColor: Colors.yellow,
                              progressColor: Colors.red,
                            ),
                          ),
                          Positioned(
                            top:540,
                            child: RaisedButton (
                              color: Color(0xff9b0014),
                              child: Text(
                                'Classifica utenti',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => Ranking()));
                              },
                            ),
                          ),
                        ],
                      );
                    } else if (snapshot.hasError) {
                      return Text("ERROR: ${snapshot.error}");
                    } else {
                      return Positioned(
                        top: 15,
                        child: SizedBox(
                          width: 160.0,
                          height: 160.0,
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                  }),
                ]
              ),
      ),
    );
  }
}

/*const List<String> choices = const <String>[
  "settings",
  //'Nickname',
];*/
