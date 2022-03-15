//start screen shows up here

import 'package:flutter/material.dart';
import 'package:chess_variant_swappable_pieces/chess_board.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var isHover0 = false;
  var isHover1 = false;
  var isHover2 = false;
  var isHover3 = false;
  var isHover4 = false;
  var isHover5 = false;

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
    var animationTime = 100;

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
            MouseRegion(
              onEnter: (f) {
                setState(() {
                  isHover0 = true;
                });
              },
              onExit: (f) {
                setState(() {
                  isHover0 = false;
                });
              },
              child: AnimatedContainer(
                duration: Duration(microseconds: animationTime),
                color: menuBarBgColor,
                height: (isHover0 ||
                        isHover1 ||
                        isHover2 ||
                        isHover3 ||
                        isHover4 ||
                        isHover5)
                    ? menuHeight + 10
                    : menuHeight,
                width: menuWidth,
              ),
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
                    child: MouseRegion(
                      onEnter: (f) {
                        setState(() {
                          isHover1 = true;
                        });
                      },
                      onExit: (f) {
                        setState(() {
                          isHover1 = false;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(microseconds: 100),
                        color: menuBgColor,
                        height: isHover1 ? menuBarHeight + 10 : menuBarHeight,
                        width: menuBarWidth,
                        child: Center(
                          child: Text(
                            menuText1,
                            style: TextStyle(
                                color: menuTextColor,
                                fontSize: menuTextFontSize),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: menuPadding,
                  ),
                  MouseRegion(
                    onEnter: (f) {
                      setState(() {
                        isHover2 = true;
                      });
                    },
                    onExit: (f) {
                      setState(() {
                        isHover2 = false;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(microseconds: 200),
                      color: menuBgColor,
                      height: isHover2 ? menuBarHeight + 10 : menuBarHeight,
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
                  ),
                  Container(
                    height: menuPadding,
                  ),
                  MouseRegion(
                    onEnter: (f) {
                      setState(() {
                        isHover3 = true;
                      });
                    },
                    onExit: (f) {
                      setState(() {
                        isHover3 = false;
                      });
                    },
                    child: AnimatedContainer(
                      duration: Duration(microseconds: animationTime),
                      color: menuBgColor,
                      height: isHover3 ? menuBarHeight + 10 : menuBarHeight,
                      width: menuBarWidth,
                      child: Center(
                          child: Text(menuText3,
                              style: TextStyle(
                                  color: menuTextColor,
                                  fontSize: menuTextFontSize))),
                    ),
                  ),
                  Container(
                    height: menuPadding,
                  ),
                  MouseRegion(
                    onEnter: (f) {
                      setState(() {
                        isHover4 = true;
                      });
                    },
                    onExit: (f) {
                      setState(() {
                        isHover4 = false;
                      });
                    },
                    child: AnimatedContainer(
                      duration: Duration(microseconds: animationTime),
                      color: menuBgColor,
                      height: isHover4 ? menuBarHeight + 10 : menuBarHeight,
                      width: menuBarWidth,
                      child: Center(
                          child: Text(menuText4,
                              style: TextStyle(
                                  color: menuTextColor,
                                  fontSize: menuTextFontSize))),
                    ),
                  ),
                  Container(
                    height: menuPadding,
                  ),
                  MouseRegion(
                    onEnter: (f) {
                      setState(() {
                        isHover5 = true;
                      });
                    },
                    onExit: (f) {
                      setState(() {
                        isHover5 = false;
                      });
                    },
                    child: AnimatedContainer(
                      duration: Duration(microseconds: animationTime),
                      color: menuBgColor,
                      height: isHover5 ? menuBarHeight + 10 : menuBarHeight,
                      width: menuBarWidth,
                      child: Center(
                          child: Text(menuText5,
                              style: TextStyle(
                                  color: menuTextColor,
                                  fontSize: menuTextFontSize))),
                    ),
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
