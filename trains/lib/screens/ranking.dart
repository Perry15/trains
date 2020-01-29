import 'package:flutter/material.dart';
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
      body: Center(
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _dbService.getLevelRankingList(),
          builder: (contextRankingList, rankingList) {
            if (rankingList.hasData) {
              return ListView.builder(
                  itemCount: rankingList.data.length,
                  itemBuilder: (context, index) {
                    Map<String, dynamic> user = rankingList.data[index];
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
                          radius: 30,
                        ),
                      ),
                      trailing: ExcludeSemantics(
                        child: CircleAvatar(
                          child: FutureBuilder<Image>(
                              future:
                                  _dbService.checkUserImageById(user['uid']),
                              builder: (contextImage, image) {
                                if (image.hasData) {
                                  return ClipOval(
                                    child: new SizedBox(
                                      width: 160.0,
                                      height: 160.0,
                                      child: image.data,
                                    ),
                                  );
                                } else if (image.hasError) {
                                  return Text("${image.error}");
                                } else {
                                  return CircularProgressIndicator();
                                }
                              }),
                          radius: 30,
                        ),
                      ),
                      title: Text(user['displayName']),
                      subtitle: Text("Livello ${user['level'].toInt()}"),
                    );
                  });
            } else if (rankingList.hasError) {
              return Text("${rankingList.error}");
            }
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
