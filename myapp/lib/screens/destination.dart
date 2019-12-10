import 'package:flutter/material.dart';
import 'package:myapp/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:myapp/models/user.dart';

class Destination extends StatelessWidget {

  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    Widget _button, _logout;
    _logout =
        FlatButton.icon(
          icon: Icon(Icons.person),
          label: Text('logout'),
          onPressed: () {
            _authService.signOut();
          },
        );
    if (user == null) {
      print("user ${user}");
      _button = _signInButton(context);
    }
    else{
      print("user ${user}");
      _button = _goToGameButton();
    }
    print("button: $_button logout: $_logout");
    return Scaffold(
        backgroundColor: Colors.brown[50],
        appBar: AppBar(
          title: Text('Destination'),
          backgroundColor: Color(0xff9b0014),
          elevation: 0.0,
          actions: <Widget>[
            _logout
          ],
        ),
        body: Center(
          //padding: EdgeInsets.symmetric(vertical:20.0, horizontal: 50.0), //4 side symmetric padding
          child: Column(
            children: <Widget>[
              Text(
                'Cerca destinazione',
              ),
              _button,
            ]
          ),
        ),
    );
  }

  Widget _goToGameButton() {
    return RaisedButton (
      color: Color(0xff9b0014),
      child: Text(
        'Vai al gioco',
        style: TextStyle(color: Colors.white),
      ),
      onPressed: () async {
        print("already signed in giochiamo");
      },
    );
  }

  Widget _signInButton(BuildContext context) {
    return OutlineButton(
      splashColor: Colors.grey,
      onPressed: () async {
        dynamic result = await _authService.signInWithGoogle();
        if(result == null){
          print('error signing in');
        } else {
          print('signed in giochiamo');
          print(result.uid);
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
                'Sign in with Google',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

}