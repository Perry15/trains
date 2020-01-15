import 'dart:async';
import 'package:flutter/material.dart';
import 'package:trains/screens/home.dart';
import 'package:trains/screens/info.dart';
import 'package:trains/screens/login.dart';
import 'package:trains/screens/ranking.dart';
import 'package:trains/services/auth.dart';
import 'package:trains/screens/profile.dart';
import 'package:trains/screens/valutazione_treno.dart';
import 'package:trains/services/database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:trains/models/user.dart';

class SideBar extends StatelessWidget {
  final DatabaseService _dbService = DatabaseService();
  final AuthService _authService = AuthService();
  final String page;

  SideBar(this.page);

  Future<Map<String, dynamic>> getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String uid = prefs.getString('uid') ?? "";
    if (uid != "") return await _dbService.getUserById(uid);
    Map<String, dynamic> user = new Map();
    user['displayName'] = 'Utente locale';
    return user;
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return Drawer(
      child: ListView(
        children: <Widget>[
          (page != "home")
              ? ListTile(
                  title: new Text('Vai alla home',
                      style: TextStyle(
                        fontSize: 18.0,
                      )),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Home()));
                  },
                )
              : Container(),
          (page != "profilo")
              ? ListTile(
                  title: new Text('Vai al tuo profilo',
                      style: TextStyle(
                        fontSize: 18.0,
                      )),
                  onTap: () {
                    _goToProfile(context, user);
                  },
                )
              : Container(),
          (page != "classifica")
              ? ListTile(
                  title: new Text('Classifica',
                      style: TextStyle(
                        fontSize: 18.0,
                      )),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Ranking()));
                  },
                )
              : Container(),
          (page != "tutorial")
              ? ListTile(
                  title: new Text('Tutorial',
                      style: TextStyle(
                        fontSize: 18.0,
                      )),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ValutazioneTreno()));
                  },
                )
              : Container(),
          (page != "informazioni")
              ? ListTile(
                  title: new Text('Informazioni',
                      style: TextStyle(
                        fontSize: 18.0,
                      )),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Info()));
                  },
                )
              : Container(),
          (user != null)
              ? ListTile(
                  title: new Text('Logout',
                      style: TextStyle(
                        fontSize: 18.0,
                      )),
                  onTap: () {
                    _authService.signOut();
                    if (page == "profilo") {
                      _goToProfile(context, null);
                    }
                  },
                )
              : ListTile(
                  title: new Text('Accedi',
                      style: TextStyle(
                        fontSize: 18.0,
                      )),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Login()),
                    );
                  },
                )
        ],
      ),
    );
  }

  void _goToProfile(context, user) {
    if (user != null) {
      Navigator.pop(context);
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => Profile(false, true)));
    } else {
      Navigator.pop(context);
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => Profile(false, false)));
    }
  }
}
