import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trains/models/evaluation.dart';
import 'package:trains/models/location.dart';
import 'package:trains/models/train.dart';
import 'package:trains/models/user.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:trains/services/database.dart';
import 'package:trains/services/local_database.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final DatabaseService _dbService = DatabaseService();
  final LocalDatabaseService local = LocalDatabaseService();
  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? User(uid: user.uid) : null;
  }

  Stream<User> get user {
    return _auth.onAuthStateChanged.map(_userFromFirebaseUser);
  }

  Future signInAnon() async {
    try {
      AuthResult result = await _auth.signInAnonymously();
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      return null;
    }
  }

  Future signInWithGoogle() async {
    try {
      GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
      if (googleSignInAccount != null) {
        GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        AuthCredential credential = GoogleAuthProvider.getCredential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        AuthResult result = await _auth.signInWithCredential(credential);
        FirebaseUser user = result.user;
        assert(!user.isAnonymous);
        assert(await user.getIdToken() != null);

        final FirebaseUser currentUser = await _auth.currentUser();
        assert(user.uid == currentUser.uid);
        await _dbService.insertUser(currentUser);

        return _userFromFirebaseUser(currentUser);
      }
      return null;
    } catch (err) {
      return null;
    }
  }

  void signOut() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String uid = prefs.getString("uid") ?? "";
      List<String> localEvaluations = ((await local.getEvaluations())
          .map((evaluation) => evaluation.id)
          .toList());
      List<dynamic> remoteEvaluations =
          await _dbService.getUserEvaluations(uid);
      remoteEvaluations.forEach((evaluationId) async {
        if (!localEvaluations.contains(evaluationId)) {
          DocumentSnapshot evaluation =
              await _dbService.getEvaluationDetails(evaluationId);
          local.insertEvaluation(new Evaluation(
              evaluation.documentID,
              evaluation.data['location'],
              evaluation.data['timestamp'].toString(),
              evaluation.data['traincode'],
              evaluation.data['vote']));
          local.insertLocation(new Location(evaluation.data['location']));
          local.insertTrain(new Train(evaluation.data['traincode']));
        }
      });
      prefs.remove("uid");
      await _auth.signOut();
      await _googleSignIn.signOut();
    } catch (e) {
      return null;
    }
  }

  Future getCurrentUser() async {
    FirebaseUser _user = await FirebaseAuth.instance.currentUser();
    return _user;
  }
}
