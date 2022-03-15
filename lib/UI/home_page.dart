//start screen shows up here

import 'package:flutter/material.dart';
import 'package:chess_variant_swappable_pieces/chess_board.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    var topSpace = screenHeight * .2;
    var gapSpace = screenWidth * .1;
    var menuPadding = screenHeight * screenWidth * 0.00002;
    var menuWidth = screenWidth * .2;
    var menuHeight = menuWidth * 1.5;
    var totalMenuBar = 5;
    var menuBarHeight = (menuHeight - 6 * menuPadding) / totalMenuBar;
    var menuBarWidth = menuWidth;
    var menuTextColor = const Color(0xF21D150F);
    var menuBgColor = const Color(0x8B4B2B21);
    var menuBarBgColor = const Color(0x513D1B17);
    var menuText1 = 'Play';
    var menuText2 = 'Lobby';
    var menuText3 = 'Friends';
    var menuText4 = 'Rules';
    var menuText5 = 'Setting';
    var menuTextFontSize = screenHeight * screenWidth * .00003;
    var titleWidth = screenWidth * .5;
    var titleHeight = titleWidth * .3;
    var registrationBgHeight = titleHeight * .3;
    var registrationBgWidth = titleWidth;
    var textColor2 = const Color(0xdac2a273);
    var title1Size = screenHeight * screenWidth * .00003;
    var title2Size = screenHeight * screenWidth * .00005;
    var registrationTextSize = screenHeight * screenWidth * .00002;
    return Material(
      type: MaterialType.transparency,
      child: Stack(children: [
        const Image(
          image: AssetImage('assets/homepage/homeScreen_background.png'),
          fit: BoxFit.cover,
          height: double.infinity,
          width: double.infinity,
          alignment: Alignment.center,
        ),
        Positioned(
          top: topSpace,
          left: gapSpace,
          right: screenWidth - menuWidth - gapSpace,
          child: Stack(children: [
            Container(
              color: menuBarBgColor,
              height: menuHeight,
              width: menuWidth,
            ),
            Padding(
              padding: EdgeInsets.all(menuPadding),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Board()),
                      );
                    },
                    child: Container(
                      color: menuBgColor,
                      height: menuBarHeight,
                      width: menuBarWidth,
                      child: Center(
                        child: Text(
                          menuText1,
                          style: TextStyle(
                              color: menuTextColor, fontSize: menuTextFontSize),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: menuPadding,
                  ),
                  Container(
                    color: menuBgColor,
                    height: menuBarHeight,
                    width: menuBarWidth,
                    child: Center(
                      child: Text(
                        menuText2,
                        style: TextStyle(
                          color: menuTextColor,
                          fontSize: menuTextFontSize,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: menuPadding,
                  ),
                  Container(
                    color: menuBgColor,
                    height: menuBarHeight,
                    width: menuBarWidth,
                    child: Center(
                        child: Text(menuText3,
                            style: TextStyle(
                                color: menuTextColor,
                                fontSize: menuTextFontSize))),
                  ),
                  Container(
                    height: menuPadding,
                  ),
                  Container(
                    color: menuBgColor,
                    height: menuBarHeight,
                    width: menuBarWidth,
                    child: Center(
                        child: Text(menuText4,
                            style: TextStyle(
                                color: menuTextColor,
                                fontSize: menuTextFontSize))),
                  ),
                  Container(
                    height: menuPadding,
                  ),
                  Container(
                    color: menuBgColor,
                    height: menuBarHeight,
                    width: menuBarWidth,
                    child: Center(
                        child: Text(menuText5,
                            style: TextStyle(
                                color: menuTextColor,
                                fontSize: menuTextFontSize))),
                  ),
                ],
              ),
            ),
          ]),
        ),
        Positioned(
          top: screenHeight * .2,
          left: screenWidth * .4,
          child: Stack(
            children: [
              Column(
                children: [
                  Container(
                    height: titleHeight,
                    width: titleWidth,
                    color: menuBarBgColor,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: menuPadding),
                          child: Text(
                            'multiplayer chess variant:',
                            style: TextStyle(
                              fontSize: title1Size,
                              color: textColor2,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: menuPadding),
                          child: Text(
                            'swappable pieces',
                            style: TextStyle(
                              fontSize: title2Size,
                              color: textColor2,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: menuPadding,
                  ),
                  Container(
                    height: registrationBgHeight,
                    width: registrationBgWidth,
                    color: menuBgColor,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          'Register',
                          style: TextStyle(
                            fontSize: registrationTextSize,
                            color: textColor2,
                          ),
                        ),
                        Text(
                          '|',
                          style: TextStyle(
                            fontSize: registrationTextSize,
                            color: textColor2,
                          ),
                        ),
                        Text(
                          'Sign-in',
                          style: TextStyle(
                            fontSize: registrationTextSize,
                            color: textColor2,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
