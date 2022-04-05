import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'auth_pop.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  AssetImage background =
      const AssetImage('assets/homepage/homeScreen_background.png');
  Color bg = const Color(0xb25f433f);
  Color text = const Color(0xff8e6d58);
  Color abg = const Color(0xb25f433f);
  Color tC = const Color(0xff8e6d58);

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: Colors.transparent,
            child: Stack(alignment: Alignment.center, children: [
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
                    flex: 6,
                    child: GestureDetector(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Positioned.fill(
                                child: BackdropFilter(
                                  filter: ui.ImageFilter.blur(
                                    sigmaX: 2.0,
                                    sigmaY: 2.0,
                                  ),
                                  child: const AuthPop(),
                                ),
                              );
                            });
                      },
                      child: AnimatedContainer(
                        margin: EdgeInsets.fromLTRB(
                            screenHeight * 0.08,
                            screenHeight * 0.03,
                            screenHeight * 0.04,
                            screenHeight * 0.03),
                        height: screenHeight * 0.4,
                        color: abg,
                        duration: const Duration(milliseconds: 500),
                        child: MouseRegion(
                          onEnter: (f) {
                            setState(() {
                              abg = text;
                              tC = bg;
                            });
                          },
                          onExit: (f) {
                            setState(() {
                              abg = bg;
                              tC = text;
                            });
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                'Register',
                                style: TextStyle(
                                  color: tC,
                                  fontFamily: 'ol',
                                  fontSize: screenHeight * 0.04,
                                  letterSpacing: -1.5,
                                ),
                              ),
                              Text(
                                '/',
                                style: TextStyle(
                                  color: tC,
                                  fontFamily: 'ol',
                                  fontSize: screenHeight * 0.057,
                                  letterSpacing: -1.5,
                                ),
                              ),
                              Text(
                                'Sign-In',
                                style: TextStyle(
                                  color: tC,
                                  fontFamily: 'ol',
                                  fontSize: screenHeight * 0.04,
                                  letterSpacing: -1.5,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 20,
                    child: Container(
                      margin: EdgeInsets.fromLTRB(
                          screenHeight * 0.04, 0, screenHeight * 0.08, 0),
                      height: screenHeight * 0.4,
                      color: const Color(0xb25f433f),
                      alignment: Alignment.topLeft,
                      padding: EdgeInsets.fromLTRB(
                          screenHeight * 0.09, screenHeight * 0.03, 0, 0),
                      child: ColumnSuper(
                          alignment: Alignment.topLeft,
                          innerDistance: -screenHeight * 0.04,
                          outerDistance: -screenHeight * 0.0,
                          children: [
                            Text(
                              'multiplayer chess variant:',
                              style: TextStyle(
                                color: const Color(0xff8e6d58),
                                fontFamily: 'ob',
                                fontSize: screenHeight * 0.08,
                                letterSpacing: -1.5,
                              ),
                            ),
                            Text(
                              'swappable pieces',
                              style: TextStyle(
                                  color: const Color(0xff8e6d58),
                                  fontFamily: 'oel',
                                  fontSize: screenHeight * 0.17,
                                  letterSpacing: screenWidth * 0.004),
                            )
                          ]),
                    ),
                  )
                ],
              )
            ]),
          ),
        ],
      ),
    );
  }
}
