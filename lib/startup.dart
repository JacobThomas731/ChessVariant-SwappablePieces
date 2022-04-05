//do all the startup/initializing stuff

import 'package:chess_variant_swappable_pieces/routes/route_generator.dart';
import 'package:flutter/rendering.dart';

import 'UI/homepage/home_page.dart';
import 'package:flutter/material.dart';

class Startup extends StatelessWidget {
  const Startup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: RouteGenerator.generateRoute,
      initialRoute: '/',
      color: Colors.transparent,
      theme: ThemeData(
        primarySwatch: Colors.brown,
      ),
    );
  }
}
