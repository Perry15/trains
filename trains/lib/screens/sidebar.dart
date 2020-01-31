import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trains/screens/home.dart';
import 'package:trains/screens/info.dart';
import 'package:trains/screens/login.dart';
import 'package:trains/screens/ranking.dart';
import 'package:trains/services/auth.dart';
import 'package:trains/screens/profile.dart';
import 'package:trains/screens/valutazione_treno.dart';
import 'package:provider/provider.dart';
import 'package:trains/models/user.dart';

///Widget per rappresentare un menu laterale
class SideBar extends StatelessWidget {
  final AuthService _authService = AuthService();
  final String page;

  SideBar(this.page);

  @override
  Widget build(BuildContext context) {
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
                    Navigator.popUntil(context, (route) => route.isFirst);
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => Home()));
                  },
                )
              : Container(),
          (page != "profilo")
              ? FutureBuilder<SharedPreferences>(
                  future: SharedPreferences.getInstance(),
                  builder: (contextPrefs, prefs) {
                    if (prefs.hasData) {
                      return ListTile(
                          title: new Text('Vai al tuo profilo',
                              style: TextStyle(
                                fontSize: 18.0,
                              )),
                          onTap: () {
                            _goToProfile(context, prefs.data.getString("uid"));
                          });
                    } else if (prefs.hasError) {
                      return Text("${prefs.error}");
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  })
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
          FutureBuilder<SharedPreferences>(
              future: SharedPreferences.getInstance(),
              builder: (context, preferences) {
                if (preferences.hasData) {
                  if (preferences.data.getString('uid') != null) {
                    return ListTile(
                      title: new Text('Logout',
                          style: TextStyle(
                            fontSize: 18.0,
                          )),
                      onTap: () {
                        _authService.signOut();
                        if (page == "profilo") {
                          _goToProfile(context, null);
                        } else if (page == "home") {
                          Navigator.pop(context);
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => Home()));
                        }
                      },
                    );
                  } else {
                    return ListTile(
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
                    );
                  }
                } else if (preferences.hasError) {
                  return Text("${preferences.error}");
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              }),
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
