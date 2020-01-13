import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trains/screens/congratulations.dart';
import 'package:trains/screens/ranking.dart';
import 'package:trains/services/database.dart';
import 'package:trains/models/user.dart';
import 'package:provider/provider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

import 'package:trains/services/points.dart';

class Profile extends StatefulWidget {
  final bool _didHeVote;
  final bool _isLoggedIn;
  final DatabaseService _dbService = DatabaseService();
  final Points points = Points();

  Profile(this._didHeVote, this._isLoggedIn);

  Future<Map<String, dynamic>> getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String uid = prefs.getString('uid') ?? "";
    if (uid != "") return await _dbService.getUserById(uid);
    Map<String, dynamic> user = new Map();
    user['evaluationsPoints'] = await points.getEvaluationsPoints();
    user['trainsPoints'] = await points.getTrainsPoints();
    user['locationsPoints'] = await points.getLocationsPoints();
    user['level'] = await points.getLevel();
    user['displayName'] = 'Utente locale';
    return user;
  }

  Future _setImage(BuildContext context) async {
    File image = await FilePicker.getFile(type: FileType.IMAGE);
    //upload
    final user = Provider.of<User>(context);
    StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('profileImages/${user.uid}');
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(image);
    await uploadTask.onComplete;
  }

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Image _image;

  @override
  void initState() {
    super.initState();
    if (widget._didHeVote) {
      if (widget._isLoggedIn) {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => Congratulations(false)));
        });
      } else {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => Congratulations(true)));
        });
      }
    }
  }

  Future<Image> _getImage(BuildContext context) async {
    dynamic user = Provider.of<User>(context);
    Image temp = await widget._dbService.checkUserImageById(user.uid);
    if (this.mounted) {
      setState(() {
        _image = temp;
      });
    }
    return _image;
  }

  @override
  Widget build(BuildContext context) {
    Widget image, button;
    if (widget._isLoggedIn) {
      image = FutureBuilder<Image>(
          future: _getImage(context),
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
              return Text("${snapshot.error}");
            } else {
              return Container();
            }
          });
      button = Positioned(
        top: MediaQuery.of(context).size.height / 6,
        left: MediaQuery.of(context).size.width / 1.7,
        child: FloatingActionButton(
          backgroundColor: Colors.black,
          onPressed: () {
            widget._setImage(context);
          },
          tooltip: 'Modifica immagine',
          child: Icon(Icons.add_a_photo),
        ),
      );
    } else {
      image = Positioned(
        top: 15,
        child: CircleAvatar(
          radius: 90,
          backgroundColor: Colors.brown[50],
          child: ClipOval(
            child: new SizedBox(
              width: 160.0,
              height: 160.0,
              child: Image.asset("assets/default.png", fit: BoxFit.cover),
            ),
          ),
        ),
      );
      button = null;
    }
    return Scaffold(
      backgroundColor: Colors.brown[50],
      appBar: AppBar(
        backgroundColor: Color(0xff9b0014),
        title: Text('Il tuo profilo'),
        elevation: 0.0,
      ),
      body: Center(
        child: Stack(
            alignment: AlignmentDirectional.bottomCenter,
            overflow: Overflow.visible,
            children: <Widget>[
              Positioned(
                top: 0,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 6,
                  child: const DecoratedBox(
                    decoration: const BoxDecoration(
                      color: Color(0xff9b0014),
                    ),
                  ),
                ),
              ),
              image,
              (button != null) ? button : SizedBox(),
              FutureBuilder<Map<String, dynamic>>(
                  future: widget.getUserData(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var data = snapshot.data;
                      return Stack(
                        alignment: AlignmentDirectional.bottomCenter,
                        overflow: Overflow.visible,
                        children: <Widget>[
                          Positioned(
                            top: 210,
                            child: Text(data['displayName'],
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
                                  child: Text('${data['evaluationsPoints']}',
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
                                  Icons.location_on,
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
                              percent:
                                  (data['level'] - data['level'].truncate())
                                      .toDouble(),
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
                            top: 540,
                            child: ButtonTheme(
                              minWidth: MediaQuery.of(context).size.width / 1.4,
                              height: 60.0,
                              child: RaisedButton(
                                color: Color(0xff9b0014),
                                child: Text(
                                  'Classifica utenti',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.0,
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Ranking()));
                                },
                              ),
                            ),
                          ),
                        ],
                      );
                    } else if (snapshot.hasError) {
                      return Text("ERROR: ${snapshot.error}");
                    } else {
                      return Positioned(
                        top: 540,
                        child: CircularProgressIndicator(),
                      );
                    }
                  }),
            ]),
      ),
    );
  }
}
