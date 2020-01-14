import 'package:flutter/material.dart';
import 'package:trains/screens/sidebar.dart';
import 'package:trains/services/database.dart';

class Ranking extends StatelessWidget {
  final DatabaseService _dbService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[50],
      appBar: AppBar(
        backgroundColor: Color(0xff9b0014),
        title: Text('Classifica'),
      ),
      drawer: SideBar("classifica"),
      body: Center(
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _dbService.getLevelRankingList(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    Map<String, dynamic> user = snapshot.data[index];
                    return ListTile(
                      leading: ExcludeSemantics(
                        child: CircleAvatar(
                          backgroundColor: Color(0xff9b0014),
                          foregroundColor: Colors.white,
                          child: ClipOval(
                            child: SizedBox(
                              child: Text(
                                user['position'].toString(),
                                style: TextStyle(
                                    fontSize: 22.0,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ),
                      ),
                      trailing: ExcludeSemantics(
                        child: CircleAvatar(
                          child: FutureBuilder<Image>(
                              future:
                                  _dbService.checkUserImageById(user['uid']),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return ClipOval(
                                    child: new SizedBox(
                                      width: 160.0,
                                      height: 160.0,
                                      child: snapshot.data,
                                    ),
                                  );
                                } else if (snapshot.hasError) {
                                  return ClipOval(
                                    child: new SizedBox(
                                      width: 160.0,
                                      height: 160.0,
                                      child: Image(
                                        image: AssetImage("assets/default.png"),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  );
                                }
                                return ClipOval(
                                  child: new SizedBox(
                                    width: 160.0,
                                    height: 160.0,
                                    child: Image(
                                      image: AssetImage("assets/default.png"),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                );
                              }),
                        ),
                      ),
                      title: Text(user['displayName']),
                      subtitle: Text("Livello ${user['level'].toInt()}"),
                    );
                  });
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
