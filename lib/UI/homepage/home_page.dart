//start screen shows up here

import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:flutter/material.dart';
import 'package:chess_variant_swappable_pieces/board/chess_board.dart';

import 'auth_button.dart';
import 'menu_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AssetImage background =
      const AssetImage('assets/homepage/homeScreen_background.png');
  Color menuButContainer = const Color(0x6634211e);

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    //double menuSizeWidth = screenWidth * 0.3;
    double menuPadding = screenWidth * 0.05;
    double menuSizeHeight = screenHeight * 0.6;
    //double titleBackgroundWidth = screenWidth * 0.4;
    double titleBackgroundHeight = screenHeight * 0.6;
    return Scaffold(
      body: Container(
          color: Colors.transparent,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Image(
                image: background,
                fit: BoxFit.cover,
                alignment: Alignment.center,
                height: double.infinity,
                width: double.infinity,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Container(
                      height: menuSizeHeight,
                      margin:
                          EdgeInsets.fromLTRB(menuPadding, 0, menuPadding, 0),
                      padding: EdgeInsets.fromLTRB(
                          menuPadding * 0.3,
                          menuPadding * 0.3,
                          menuPadding * 0.3,
                          menuPadding * 0.3),
                      color: menuButContainer,
                      alignment: Alignment.center,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: const [
                            MenuButton(
                                text: "Challenge Anyone", pageRoute: '/board'),
                            MenuButton(
                                text: "Challenge Friend",
                                pageRoute: '/boardController'),
                            MenuButton(text: "Check Lobby", pageRoute: '/auth'),
                            MenuButton(text: "Settings", pageRoute: '/board'),
                            MenuButton(text: "Quit Game", pageRoute: '/board')
                          ]),
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Container(
                      //color: Colors.yellow[300],
                      height: titleBackgroundHeight,
                      padding:
                          EdgeInsets.fromLTRB(0, 0, menuPadding, menuPadding),
                      child: Column(children: [
                        Expanded(
                          flex: 6,
                          child: Container(
                            color: menuButContainer,
                            alignment: Alignment.topLeft,
                            padding: EdgeInsets.fromLTRB(
                                screenWidth * 0.02, screenWidth * 0.015, 0, 0),
                            child: ColumnSuper(
                                alignment: Alignment.topLeft,
                                innerDistance: -screenWidth * 0.024,
                                outerDistance: -screenWidth * 0.0085,
                                children: [
                                  Text(
                                    'multiplayer chess variant:',
                                    style: TextStyle(
                                      color: const Color(0xff8e6d58),
                                      fontFamily: 'ol',
                                      fontSize: screenWidth * 0.037,
                                      letterSpacing: -1.5,
                                    ),
                                  ),
                                  Text(
                                    'swappable pieces',
                                    style: TextStyle(
                                        color: const Color(0xff8e6d58),
                                        fontFamily: 'o',
                                        fontSize: screenWidth * 0.07,
                                        letterSpacing: screenWidth * 0.004),
                                  )
                                ]),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Expanded(
                          flex: 4,
                          child: Container(
                            color: menuButContainer,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                AuthButton(text: 'Sign-in'),
                                AuthButton(text: '|'),
                                AuthButton(text: 'Sign-Out'),
                              ],
                            ),
                          ),
                        )
                      ]),
                    ),
                  )
                ],
              )
            ],
          )),
    );
  }
}
