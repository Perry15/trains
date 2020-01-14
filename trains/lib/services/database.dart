import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import "package:latlong/latlong.dart";
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:trains/models/evaluation.dart';
import 'package:trains/models/location.dart';
import 'package:trains/models/train.dart';
import 'package:trains/services/local_database.dart';
import 'package:path_provider/path_provider.dart';
import 'package:trains/services/points.dart';

class DatabaseService {
  //collection reference
  final db = Firestore.instance;
  final LocalDatabaseService _localDbService = LocalDatabaseService();

  ///old funtion to load the stations in the db
  Future load() async {
    String jsonString = await _loadA();
    final jsonResponse = json.decode(jsonString);
    var n = 1;
    String id = "S00001";
    while (n <= 12973) {
      if (n >= 1) id = "S0000$n";
      if (n >= 10) id = "S000$n";
      if (n >= 100) id = "S00$n";
      if (n >= 1000) id = "S0$n";
      if (n >= 10000) id = "S$n";
      if (jsonResponse[id] != null) {
        db.collection("stations").document(id).setData(jsonResponse[id]);
      }
      n++;
    }
    //db.collection("stations").document("nHhas6DsePZTEebJWW5T").delete();
    //db.collection("stations").document("S00001").setData(jsonResponse["S00001"]);
    return jsonResponse;
  }

  ///old funtion to load the stations in the db
  Future<String> _loadA() async {
    return await rootBundle.loadString('assets/stations.json');
  }

  ///old funtion to load the stations in the db
  Future loadData(String docId, Map<String, dynamic> data) async {
    db.collection("stations").document(docId).setData(data);
  }

  Future _getStationById(String docId) async {
    DocumentReference docRef = db.collection("stations").document(docId);
    DocumentSnapshot doc = await docRef.get();
    doc.data.putIfAbsent('id', () => docId);
    return doc.data;
  }

  Future delete(String docId, Map<String, dynamic> data) async {
    db.collection("stations").document(docId).delete();
  }

  ///deletes all documents within evaluations collection
  Future deleteAllEvaluations() async {
    QuerySnapshot querySnapshot =
        await db.collection("evaluations").getDocuments();
    for (DocumentSnapshot doc in querySnapshot.documents) {
      db.collection("evaluations").document(doc.documentID).delete();
    }
  }

  Future<Map<String, dynamic>> searchNearestStations(lat, long) async {
    Map<String, dynamic> stations =
        jsonDecode(await rootBundle.loadString('assets/stations.json'));
    var minDistance = 13000000.0;
    var minId = "0";
    final Distance distance = new Distance();
    stations.forEach((key, value) {
      var lat2 = double.parse(value['lat'].toString().replaceAll(',', '.'));
      var long2 = double.parse(value['lon'].toString().replaceAll(',', '.'));

      final double meter =
          distance(new LatLng(lat, long), new LatLng(lat2, long2));
      if (meter < minDistance) {
        minDistance = meter;
        minId = key;
      }
    });
    return await _getStationById(minId);
  }

  Future<DocumentReference> insertEvaluation(
      String vote, String trainCode, String location) async {
    return await db.collection('evaluations').add({
      'vote': vote,
      'traincode': trainCode,
      'location': location,
      'timestamp': DateTime.now(),
    });
  }

  void insertUserEvaluation(uid, evaluationId) async {
    await db.collection('users').document(uid).updateData({
      'evaluations': FieldValue.arrayUnion([evaluationId])
    });
  }

  void insertUserTrain(uid, String trainCode) async {
    await db.collection('users').document(uid).updateData({
      'trainsEvaluated': FieldValue.arrayUnion([trainCode])
    });
  }

  void insertUserLocation(uid, String locationCode) async {
    await db.collection('users').document(uid).updateData({
      'locationsEvaluated':
          FieldValue.arrayUnion([locationCode]) //level function
    });
  }

  Future<List<dynamic>> getUserLocations(uid) async {
    dynamic result = await db.collection('users').document(uid).get();
    return result.data["locationsEvaluated"];
  }

  Future<DocumentSnapshot> getEvaluationDetails(eid) async {
    return await db.collection('evaluations').document(eid).get();
  }

  Future<List<dynamic>> getUserEvaluations(uid) async {
    dynamic result = await db.collection('users').document(uid).get();
    return result.data["evaluations"];
  }

  Future<List<dynamic>> getUserTrains(uid) async {
    dynamic result = await db.collection('users').document(uid).get();
    return result.data["trainsEvaluated"];
  }

  ///calcola la valutazione di un treno
  Future<int> getTrainEvaluation(String trainCode) async {
    QuerySnapshot querySnapshot =
        await db.collection("evaluations").getDocuments();
    List<int> counters = new List<int>.filled(4, 0);
    //List<String> results = ["Vuoto","Quasi vuoto","Quasi pieno","Pieno"];//to return String
    for (DocumentSnapshot doc in querySnapshot.documents) {
      if (doc.data['traincode'] == trainCode) {
        switch (doc.data['vote']) {
          case "Vuoto":
            {
              counters[0]++;
            }
            break;
          case "Quasi vuoto":
            {
              counters[1]++;
            }
            break;
          case "Quasi pieno":
            {
              counters[2]++;
            }
            break;
          case "Pieno":
            {
              counters[3]++;
            }
            break;
        }
      }
    }
    //return results[counters.indexOf(counters.reduce(max))];//to return String
    return counters.indexOf(counters.reduce(max));
  }

  ///calcola la valutazione di un treno
  Future<List<Map<String, dynamic>>> getLevelRankingList() async {
    QuerySnapshot querySnapshot = await db
        .collection("users")
        .orderBy("level", descending: true)
        .getDocuments();
    List<Map<String, dynamic>> rankingData = [];
    int c = 1;
    for (DocumentSnapshot doc in querySnapshot.documents) {
      //print("data: ${doc.documentID} ${doc.data['displayName']}");
      rankingData.add({
        "position": c,
        "uid": doc.documentID,
        "level": doc.data['level'],
        "displayName": doc.data['displayName']
      });
      c++;
    }
    return rankingData;
  }

  void updateUserFromLocal(uid) async {
    Points points = new Points();
    for (Train train in await _localDbService.getTrains()) {
      insertUserTrain(uid, train.code);
    }
    for (Location location in await _localDbService.getLocations()) {
      insertUserLocation(uid, location.code);
    }
    for (Evaluation evaluation in await _localDbService.getEvaluations()) {
      insertUserEvaluation(uid, evaluation.id);
    }

    await db.collection('users').document(uid).updateData({
      'evaluationsPoints': await points.getEvaluationsPoints(),
      'locationsPoints': await points.getLocationsPoints(),
      'trainsPoints': await points.getTrainsPoints(),
      'level': await points.getLevel()
    });
  }

  Future<File> getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load('assets/$path');

    final file = File('${(await getTemporaryDirectory()).path}/$path');
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return file;
  }

  //inserisce un utente nel db se questo non è ancora presente
  //"S02570/11121","S02581/5820"
  Future insertUser(user) async {
    DocumentReference docRef = db.collection("users").document(user.uid);
    DocumentSnapshot doc = await docRef.get();
    if (!doc.exists) {
      //every user has his own profile image
      File file = await getImageFileFromAssets("default.png");
      FirebaseStorage.instance
          .ref()
          .child('profileImages/${user.uid}')
          .putFile(file);
      return await db.collection('users').document(user.uid).setData({
        'displayName': user.displayName,
        'email': user.email,
        'evaluationsPoints': 0,
        'locationsPoints': 0,
        'trainsPoints': 0,
        'level': 0,
        'trainsEvaluated': [],
        'locationsEvaluated': [],
        'evaluations': []
      });
    } //se esiste ma certi campi non esistono
    /*else{
        db.collection('users').document(user.uid).get()
    }*/
  }

  ///Ottiene i dati di un utente tramite l'id
  ///
  Future<Map<String, dynamic>> getUserById(uid) async {
    DocumentReference docRef = db.collection("users").document(uid);
    DocumentSnapshot doc = await docRef.get();
    doc.data['id'] = uid;
    return doc.data;
  }

  ///returns the profile Image of a User
  Future<dynamic> checkUserImageById(String uid) async {
    print("data: $uid");
    try {
      final String url = await FirebaseStorage.instance
          .ref()
          .child('profileImages/$uid')
          .getDownloadURL();
      return Image.network(
        url,
        fit: BoxFit.cover,
      );
    } catch (e) {
      return Image(
        image: AssetImage("assets/default.png"),
        fit: BoxFit.cover,
      );
    }
  }
}
