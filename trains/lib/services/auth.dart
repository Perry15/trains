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
  //_ before meanbs private
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final DatabaseService _dbService = DatabaseService();
  final LocalDatabaseService local = LocalDatabaseService();
  //ritorna lo user se loggato null se sloggato
  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? User(uid: user.uid) : null;
  }

  //auth change user stream, flusso da firebase che ci dice quando un utente si logga o slogga
  //contiene oggetti User, mappati da FirebaseUser in User,
  //se c'è null utente sloggato se c'è lo user allora è loggato
  Stream<User> get user {
    return _auth.onAuthStateChanged
        //.map((FirebaseUser user)=> _userFromFirebaseUser(user));
        .map(_userFromFirebaseUser); // is the same
  }

  //sign in anon
  Future signInAnon() async {
    try {
      AuthResult result = await _auth.signInAnonymously();
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user); //success
    } catch (e) {
      print(e.toString());
      return null; //failure
    }
  }

  //sign in with google
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
        print("FirebaseUser $user");
        assert(!user.isAnonymous);
        assert(await user.getIdToken() != null);

        final FirebaseUser currentUser = await _auth.currentUser();
        assert(user.uid == currentUser.uid);
        await _dbService.insertUser(
            currentUser); // insert the user in the db if it is not already in

        return _userFromFirebaseUser(currentUser); //ritorna User obj
      }
      return null;
    } catch (err) {
      print("$err");
      return null;
    }
  }
  //register with email & password

  //sign out anon
  void signOut() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String uid = prefs.getString("uid") ?? "";
      List<String> localEvaluations = ((await local.getEvaluations())
          .map((evaluation) => evaluation.id)
          .toList());
      List<dynamic> remoteEvaluations =
          await _dbService.getUserEvaluations(uid);
      remoteEvaluations.forEach((evaluationId) => {
            if (!localEvaluations.contains(evaluationId))
              {_insertEvaluation(evaluationId)}
          });
      prefs.remove("uid");
      await _auth.signOut();
      await _googleSignIn.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  void _insertEvaluation(String evaluationId) async {
    DocumentSnapshot evaluation =
        await _dbService.getEvaluationDetails(evaluationId);
    print('ciao');
    print(evaluation.data['timestamp']);
    local.insertEvaluation(new Evaluation(
        evaluation.documentID,
        evaluation.data['location'],
        DateTime.fromMillisecondsSinceEpoch(evaluation.data['timestamp'].getSeconds()*1000),
        evaluation.data['traincode'],
        evaluation.data['vote']));
    local.insertLocation(new Location(evaluation.data['location']));
    local.insertTrain(new Train(evaluation.data['traincode']));
  }

  Future getCurrentUser() async {
    FirebaseUser _user = await FirebaseAuth.instance.currentUser();
    return _user;
  }
  //forse non serve
  /*void signOutGoogle() async{
    try{
      print("sign out google caxo");
      await _googleSignIn.signOut();
    } catch(e){
      print(e.toString());
      return null;
    }
  }*/
}
