import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trains/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:trains/models/user.dart';
import 'package:trains/screens/profile.dart';
import 'package:trains/services/database.dart';

class Login extends StatelessWidget {
  //final bool_didHeVote; // boolean value per sapere se arriva da una votazione o no
  final AuthService _authService = AuthService();
  final DatabaseService _dbService = DatabaseService();

  //Login(this._didHeVote);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    /*if(_didHeVote)
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Congratulations(true)));
      });
      */

    return Scaffold(
      backgroundColor: Colors.brown[50],
      appBar: AppBar(
          title: Text('Accedi'),
          backgroundColor: Color(0xff9b0014),
          elevation: 0.0),
      body: Center(
        //padding: EdgeInsets.symmetric(vertical:20.0, horizontal: 50.0), //4 side symmetric padding
        child:
            /*(_didHeVote)
              ? Text('Congratulazioni hai valutato il treno!!!',
                  style: TextStyle(
                    fontSize: 20.0,
                    //fontWeight: FontWeight.w500,
                  ))
              : SizedBox(), //SizedBox vuota per mettere un Widget vuoto
          SizedBox(height: MediaQuery.of(context).size.height / 2.5),*/
            user != null
                ? Center(child: CircularProgressIndicator())
                : _signInButton(context),
      ),
    );
  }

  Widget _signInButton(BuildContext context) {
    return Center(
        child: OutlineButton(
      splashColor: Colors.grey,
      onPressed: () async {
        dynamic result = await _authService.signInWithGoogle();
        if (result == null) {
          print('Errore di accesso');
        } else {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('uid', result.uid);
          _dbService.updateUserFromLocal(result.uid);
          print('Accesso effettuato');
          print(result.uid);
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => Profile(false, true))); //Profile(false)
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
