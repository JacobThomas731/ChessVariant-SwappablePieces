//do all the startup/initializing stuff

import 'UI/home_page.dart';
import 'package:flutter/material.dart';

class Startup extends StatelessWidget {
  const Startup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Multiplayer Chess Variant: Swappable Pieces',
        theme: ThemeData(
            brightness: Brightness.light,
            scaffoldBackgroundColor: Colors.white,
            // accentColor: Colors.white,
            splashColor: Colors.white),
        darkTheme: ThemeData(
            brightness: Brightness.dark,
            scaffoldBackgroundColor: Colors.black,
            // accentColor: Colors.black,
            splashColor: Colors.black12),
        home: const HomePage());
  }
}
