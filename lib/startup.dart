//do all the startup/initializing stuff

import 'package:chess_variant_swappable_pieces/route_generator.dart';

import 'UI/home_page.dart';
import 'package:flutter/material.dart';

class Startup extends StatelessWidget {
  const Startup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WidgetsApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: RouteGenerator.generateRoute,
      initialRoute: '/',
      color: Colors.transparent,
    );
  }
}
