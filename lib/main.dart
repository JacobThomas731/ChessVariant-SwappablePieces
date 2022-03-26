import 'package:flutter/services.dart';

import 'startup.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;

// import 'UI/home_page.dart';
// import 'package:firebase_auth/firebase_auth.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isAndroid || Platform.isIOS) {
    await SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft]);
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
