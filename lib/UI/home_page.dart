//start screen shows up here

import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final title;

  HomePage(this.title);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var screenHeight;
  var screenWidth;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Stack(children: [
      const Image(
        image: AssetImage('assets/homepage/homeScreen_background.png'),
        fit: BoxFit.cover,
        height: double.infinity,
        width: double.infinity,
        alignment: Alignment.center,
      ),
      Positioned(
        top: screenHeight * .25,
        bottom: screenHeight * .25,
        left: screenWidth * .2,
        right: screenWidth * .6,
        child: Stack(children: [
          const Image(
            image: AssetImage('assets/homepage/menu_background.png'),
          ),
          Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,

            children: const [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Image(
                  image: AssetImage('assets/homepage/findGame_button.png'),
                  // height: 40,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Image(
                  image: AssetImage('assets/homepage/joinLobby_button.png'),
                  // height: 40,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Image(
                  image: AssetImage('assets/homepage/playwithfriend_button.png'),
                  // height: 40,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Image(
                  image: AssetImage('assets/homepage/rules_button.png'),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Image(
                  image: AssetImage('assets/homepage/settings_button.png'),
                ),
              ),
            ],
          ),
        ]),
      ),
      Positioned(
        top: screenHeight * .25,
        bottom: screenHeight * .25,
        left: screenWidth * .6,
        right: screenWidth * .2,
        child: const Image(
          image: AssetImage('assets/homepage/menu_background.png'),
        ),
      ),
    ]);
  }
}
