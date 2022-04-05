import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';

import 'startup.dart';
import 'package:flutter/material.dart';
import 'package:universal_io/io.dart' show Platform;

// import 'UI/home_page.dart';
// import 'package:firebase_auth/firebase_auth.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isAndroid || Platform.isIOS) {
    await SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft]);
  }
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyDXrMQtCgS-8hG1rfMIAm1cHFEindllBVM",
          appId: "1:307380759063:web:ef32b9acae47108506ca52",
          messagingSenderId: "307380759063",
          projectId: "chess-swappable-pieces"));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Startup();
  }
}
