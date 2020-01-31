import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trains/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:trains/models/user.dart';
import 'package:trains/screens/profile.dart';
import 'package:trains/services/database.dart';

///Widget relativo alla schermata che consente di effettuare il login
class Login extends StatelessWidget {
  final AuthService _authService = AuthService();
  final DatabaseService _dbService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[50],
      appBar: AppBar(
          title: Text('Accedi'),
          backgroundColor: Color(0xff9b0014),
          elevation: 0.0),
      body: Center(
          child: FutureBuilder<SharedPreferences>(
              future: SharedPreferences.getInstance(),
              builder: (context, prefs) {
                if (prefs.hasData && prefs.data.getString("uid") != null) {
                  return Center(child: CircularProgressIndicator());
                } else if (prefs.hasData) return _signInButton(context);
              })),
    );
  }

  ///Funzione che restituisce il bottone di login
  Widget _signInButton(BuildContext context) {
    return Center(
        child: OutlineButton(
      splashColor: Colors.grey,
      onPressed: () async {
        dynamic result = await _authService.signInWithGoogle();
        if (result != null) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('uid', result.uid);
          _dbService.updateUserFromLocal(result.uid);
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => Profile(false, true)));
        }
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      highlightElevation: 0,
      borderSide: BorderSide(color: Colors.grey),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(image: AssetImage("assets/google_logo.png"), height: 35.0),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                'Accedi con Google',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
            )
          ],
        ),
      ),
    ));
  }
}
