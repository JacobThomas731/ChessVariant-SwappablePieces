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
