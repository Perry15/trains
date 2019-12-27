import 'package:flutter/material.dart';
import 'package:trains/services/database.dart';
import 'package:trains/models/user.dart';
import 'package:provider/provider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:trains/screens/settings.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileSate createState() => _ProfileSate();
}

class _ProfileSate extends State<Profile>{
  final DatabaseService _dbService = DatabaseService();

  void _select(String choice) {
     switch(choice){
       case "settings":{
        Navigator.push(context,MaterialPageRoute(builder: (context) => Settings()));
       }
       break;
       /*
       case "Nickname":{
        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Settings(s:"nickname")));
       }
       break;
       */
     }
     

  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    //_dbService.updateUserPoints(user.uid,10,10,20).then((val) => {print("update $val")});
    _dbService.getUserById(user.uid).then((val) => setState(() {
            //print("val $val");
            user.displayName = val['displayName'];
            user.email = val['email'];
            user.valutationsPoints = val['valutationsPoints'];
            user.locationsPoints = val['locationsPoints'];
            user.trainsPoints = val['trainsPoints'];
            user.level = val['level'];
    }));

    return Scaffold(
        backgroundColor: Colors.brown[50],
        appBar: AppBar(
          title: Text('Profilo'),
          backgroundColor: Color(0xff9b0014),
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
          child: Column(
            children: <Widget>[
              SizedBox(height:20),
              Text(
                'Il tuo profilo ${user.displayName}',
                style: TextStyle(
                  fontSize: 20.0,
                  //fontWeight: FontWeight.w500,
                )
              ),
              new CircularPercentIndicator(
                radius: 100.0,
                animation: true,
                animationDuration: 1200,
                lineWidth: 13.0,
                percent:0.1,
                center: new Text(
                  "${user.valutationsPoints}",
                  style:
                      new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                ),
                circularStrokeCap: CircularStrokeCap.butt,
                backgroundColor: Colors.yellow,
                progressColor: Colors.red,
              ),
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