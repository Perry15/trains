import 'dart:math';
import 'package:trains/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import "package:latlong/latlong.dart";
class DatabaseService{

  //collection reference
  final db = Firestore.instance;

  Future load() async {
    String jsonString = await _loadA();
    final jsonResponse = json.decode(jsonString);
    var n = 1;
    String id="S00001";
    while(n<=12973){
      if(n>=1)
        id="S0000$n";
      if(n>=10)
        id="S000$n";
      if(n>=100)
        id="S00$n";
      if(n>=1000)
        id="S0$n";
      if(n>=10000)
        id="S$n";
      if(jsonResponse[id]!=null){
        db.collection("stations").document(id).setData(jsonResponse[id]);
      }
      n++;
    }
    //db.collection("stations").document("nHhas6DsePZTEebJWW5T").delete();
    //db.collection("stations").document("S00001").setData(jsonResponse["S00001"]);
    return jsonResponse;
  }
  Future<String> _loadA() async {
    return await rootBundle.loadString('assets/stations.json');
  }
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
  Future<Map<String,dynamic>> searchNearestStations(lat,long) async {
    print("Arrivati lat: $lat long: $long ");
    QuerySnapshot querySnapshot  = await db.collection("stations").getDocuments();
    var minDistance=13000000.0;
    var minId = "0";
    final Distance distance = new Distance();
    for (DocumentSnapshot doc in querySnapshot.documents) {
      //print("id: ${doc.documentID} data: ${doc.data}");
      var data = doc.data;
      //print("double ${double.parse(data["lat"].toString().replaceAll(',', '.'))}");
      var lat2 = double.parse((data["lat"]).toString().replaceAll(',', '.'));
      var long2 = double.parse((data["lon"]).toString().replaceAll(',', '.'));

      final double meter = distance(new LatLng(lat,long), new LatLng(lat2,long2));
      //update minimum distance
      //print("${doc.documentID} distance: $meter");
      if(meter < minDistance){
        minDistance = meter;
        minId=doc.documentID;
      }
    }
    return await _getStationById(minId);
  }

  Future updateUserPoints(uid, valutationsPoints, locationsPoints, trainsPoints) async{
    var x = valutationsPoints+locationsPoints+trainsPoints;
    return await db.collection('users').document(uid).updateData({
      'valutationsPoints': valutationsPoints,
      'locationsPoints': locationsPoints,
      'trainsPoints': trainsPoints,
      'level': 2+sqrt(((x-40)/5))//level function
    });
  }

  Future insertUser(user) async{
    //TODO if it is not already
    DocumentReference docRef = db.collection("users").document(user.uid);
    DocumentSnapshot doc = await docRef.get();
    if(!doc.exists){
      return await db.collection('users').document(user.uid).setData({
        'displayName': user.displayName,
        'email': user.email,
        'valutationsPoints': 0,
        'locationsPoints' : 0,
        'trainsPoints' : 0,
        'level': 0
      });
    }
  }

  Future getUserById(uid) async{
    DocumentReference docRef = db.collection("users").document(uid);
    DocumentSnapshot doc = await docRef.get();
    doc.data.putIfAbsent('id', () => uid);
    return doc.data;
  }






}