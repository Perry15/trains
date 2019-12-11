import 'package:firebase_auth/firebase_auth.dart';
import 'package:trains/models/user.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService{
  //_ before meanbs private
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  //ritorna lo user se loggato null se sloggato
  User _userFromFirebaseUser(FirebaseUser user){
    return user != null ? User(uid:user.uid) : null;
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
  Future signInAnon() async{
    try{
      AuthResult result = await _auth.signInAnonymously();
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);//success
    } catch(e){
      print(e.toString());
      return null;//failure
    }
  }
  //sign in with google
  Future signInWithGoogle() async {
    try {
      print("ciao");
      final GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;
      print("ocio");
      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final AuthResult result = await _auth.signInWithCredential(credential);
      final FirebaseUser user = result.user;
      print("FirebaseUser $user");
      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      final FirebaseUser currentUser = await _auth.currentUser();
      assert(user.uid == currentUser.uid);

      return _userFromFirebaseUser(currentUser); //ritorna User obj
    }
    catch(e){
      print(e.toString());
      return null;//failure
    }

  }
  //register with email & password

  //sign out anon
  Future signOut() async {
    try{
      return await _auth.signOut();
    } catch(e){
      print(e.toString());
      return null;
    }
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