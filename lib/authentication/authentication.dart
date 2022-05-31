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
        "friendList": {},
        "gamesPlayed": "0",
        "onlineStatus": "online",
        "rating": "1500",
        "username": username,
        "challenges": "",
        "challengeAccepted": "" //empty or declined
      };
      var emailRef = FirebaseAuth.instance.currentUser?.email;
      var ref = FirebaseFirestore.instance.collection('users').doc(emailRef);
      await ref.set(myJSONObj);
    } catch (e) {
      print(e);
    }
  }

  signInEmailPass(String username, String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      var db = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser?.email)
          .get();
      Map<String, dynamic> m = db.data() as Map<String, dynamic>;
      m['online'] = 'online';
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser?.email)
          .update(m);
    } catch (e) {}
  }

  signOut() async {
    try {
      var db = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser?.email)
          .get();
      Map<String, dynamic> m =
          (db.data()?["onlineStatus"] = "offline") as Map<String, dynamic>;
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser?.email)
          .update(m);
      await _auth.signOut();
    } catch (e) {}
  }
}
