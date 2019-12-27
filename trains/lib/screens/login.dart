import 'package:flutter/material.dart';
import 'package:trains/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:trains/models/user.dart';
import 'package:trains/screens/profile.dart';

class Login extends StatelessWidget {

  final AuthService _authService = AuthService();
  //Widget _button, _logout;
  bool _logged=false;
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    
   /* _logout =
        FlatButton.icon(
          icon: Icon(Icons.person),
          label: Text('logout'),
          onPressed: () {
            _authService.signOut();
          },
        );*/
    if (user == null) {
      //print("user ${user}");
      _logged=false;
      //_button = _signInButtons(context);
    }
    else{
      //print("user ${user}");
      _logged=true;
      //_button = _goToGameButton(context);
    }
    //print("button: $_button logout: $_logout");
    return Scaffold(
        backgroundColor: Colors.brown[50],
        appBar: AppBar(
          title: Text('Hai valutato'),
          backgroundColor: Color(0xff9b0014),
          elevation: 0.0,
          actions: <Widget>[
            (_logged==true)?
            FlatButton.icon(
              icon: Icon(Icons.person),
              label: Text('logout'),
              onPressed: () {
                _authService.signOut();
              },
            ):SizedBox()
          ],
        ),
        body: Center(
          //padding: EdgeInsets.symmetric(vertical:20.0, horizontal: 50.0), //4 side symmetric padding
          child: Column(
            children: <Widget>[
              SizedBox(height:20),
              Text(
                'Congratulazioni hai valutato il treno!!!',
                style: TextStyle(
                  fontSize: 20.0,
                  //fontWeight: FontWeight.w500,
                )
              ),
              SizedBox(height:550),
              (_logged==true)?_goToGameButton(context):_signInButtons(context)
            ]
          ),
        ),
    );
  }

  Widget _goToGameButton(BuildContext context) {
    return 
    ButtonTheme(
      minWidth: MediaQuery.of(context).size.width -50,
      height: 70.0,
      child:RaisedButton (
        color: Color(0xff9b0014),
        child: Text(
          'Vai al profilo',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
          ),
        ),
        onPressed: () {
          Navigator.push(context,MaterialPageRoute(builder: (context) => Profile()));
        },
      ),
      );
  }

  Widget _signInButtons(BuildContext context) {
    return 
    Column(
      children: <Widget>[
        OutlineButton(
          splashColor: Colors.grey,
          onPressed: () async {
            dynamic result = await _authService.signInWithGoogle();
            if(result == null){
              print('Errore di accesso');
            } else {
              print('Accesso effettuato');
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
        ),
        /*SizedBox(height:20),
        RaisedButton(
          child: Text('sign in anon'),
          onPressed: () async {
            dynamic result = await _authService.signInAnon();
            if(result == null){
              print('error signing in');
            } else {
              print('signed in');
              print(result);
            }
          },
        ),*/
      ]
    );

  }

}