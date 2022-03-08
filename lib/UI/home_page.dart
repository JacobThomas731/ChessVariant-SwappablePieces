//start screen shows up here

import 'package:chess_variant_swappable_pieces/chess_board.dart';
import 'package:flutter/cupertino.dart';
// import 'package:flutter/rendering.dart';
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
        top: screenHeight * .2,
        bottom: screenHeight * .2,
        left: screenWidth * .1,
        right: screenWidth * .70,
        child: Stack(children: [
          const Image(
            image: AssetImage('assets/homepage/menu_background.png'),
          ),
          Column(
            children:  [
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                child: GestureDetector(
                  onTap: (){


                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Board(screenHeight)),
                    );
                  },
                  child: const Image(
                    image: AssetImage('assets/homepage/findGame_button.png'),
                    // height: 65,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 10, left: 20, right: 20),
                child: Image(
                  image: AssetImage('assets/homepage/joinLobby_button.png'),
                  // height: 40,
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 10, left: 20, right: 20),
                child: Image(
                  image:
                      AssetImage('assets/homepage/playwithfriend_button.png'),
                  // height: 40,
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 10, left: 20, right: 20),
                child: Image(
                  image: AssetImage('assets/homepage/rules_button.png'),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 10, left: 20, right: 20),
                child: Image(
                  image: AssetImage('assets/homepage/settings_button.png'),
                ),
              ),
            ],
          ),
        ]),
      ),
      Positioned(
        top: screenHeight * .2,
        bottom: screenHeight * .2,
        left: screenWidth * .45,
        right: screenWidth * .1,
        child: Stack(
          children: [
            Column(
              children: const [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Image(
                    image: AssetImage('assets/homepage/title.png'),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Image(
                    image: AssetImage('assets/homepage/register_sign_in_bg.png'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ]);
  }
}
