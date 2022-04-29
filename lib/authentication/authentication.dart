import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Authentication {
  late FirebaseAuth _auth;

  static final Authentication _instance = Authentication._createInstance();

  Authentication._createInstance() {
    _auth = FirebaseAuth.instance;
  }

  factory Authentication() {
    return _instance;
  }

  registerUser(String username, String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      var myJSONObj = {
        "email": email,
        "friendList": [],
        "gamesPlayed": "0",
        "onlineStatus": "online",
        "rating": "1500",
        "username": username
      };
      var emailRef = FirebaseAuth.instance.currentUser?.email;
      var ref = FirebaseFirestore.instance.collection('users').doc(emailRef);
      print(ref.set(myJSONObj));
    } catch (e) {
      print(e);
    }
  }

  signInEmailPass(String username, String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      print(e);
    }
  }

  signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print(e);
    }
  }
}
