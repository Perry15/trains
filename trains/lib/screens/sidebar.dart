import 'dart:async';
import 'package:flutter/material.dart';
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
          ListTile(
            title: new Text('Vai al tuo profilo',
                style: TextStyle(
                  fontSize: 18.0,
                )),
            onTap: () {
              if (user != null) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Profile(false, true)));
                //Navigator.of(context).pop();
              } else {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Profile(false, false)));
                //Navigator.of(context).pop();
              }
            },
          ),
          ListTile(
            title: new Text('Classifica',
                style: TextStyle(
                  fontSize: 18.0,
                )),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Ranking()));
              //Navigator.of(context).pop();
            },
          ),
          ListTile(
            title: new Text('Tutorial',
                style: TextStyle(
                  fontSize: 18.0,
                )),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ValutazioneTreno()));
              //Navigator.of(context).pop();
            },
          ),
          ListTile(
            title: new Text('Informazioni',
                style: TextStyle(
                  fontSize: 18.0,
                )),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Info()));
              //Navigator.of(context).pop();
            },
          ),
          (user != null)
              ? ListTile(
                  title: new Text('Logout',
                      style: TextStyle(
                        fontSize: 18.0,
                      )),
                  onTap: () {
                    _authService.signOut();
                  },
                )
              : ListTile(
                  title: new Text('Accedi',
                      style: TextStyle(
                        fontSize: 18.0,
                      )),
                  onTap: () {
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
}
