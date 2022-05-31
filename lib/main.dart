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
    await Firebase.initializeApp();
  } else {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyA2iqm-qa5oR46U2Po9JvirazRGe9QG8pE",
            appId: "1:583070078948:web:a33a2d8f0e1ec986e759f1",
            messagingSenderId: "583070078948",
            projectId: "multiplayer-chess-variant"));
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Startup();
  }
}
