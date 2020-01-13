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
    /*user['evaluationsPoints'] = await points.getEvaluationsPoints();
    user['trainsPoints'] = await points.getTrainsPoints();
    user['locationsPoints'] = await points.getLocationsPoints();
    user['level'] = await points.getLevel();*/
    user['displayName'] = 'Utente locale';
    return user;
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context); 
    return Drawer(
        child: ListView(
          children: <Widget>[
            /*FutureBuilder<Map<String, dynamic>>(
                  future: getUserData(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var data = snapshot.data;
                      return UserAccountsDrawerHeader(
                        decoration: BoxDecoration(
                          color: Color(0xff9b0014),
                        ),
                        accountName: Text(data['displayName']),
                        /*currentAccountPicture: CircleAvatar(
                          //backgroundImage: ,
                        ),*/
                      );
                    }
                    return CircularProgressIndicator();
                  }
            ),*/
            ListTile(
              title: new Text('Vai al tuo profilo'),
              onTap: () {
                if (user != null)
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Profile(false,true)));//Profile(false)
                    else
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Profile(false,false)));//Login(false)
              },
            ),
            ListTile(
              title: new Text('Classifica'),
              onTap: () {
                Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Ranking()));
              },
            ),
            ListTile(
              title: new Text('Tutorial'),
              onTap: () {
                Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ValutazioneTreno()));
              },
            ),
            ListTile(
              title: new Text('Informazioni'),
              onTap: () {
                Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Info()));
              },
            ),
            (user!=null)?ListTile(
              title: new Text('Logout'),
              onTap: () {
                _authService.signOut();
              },
            ):SizedBox()

          ],
        ),
      );
  }
}