import 'package:flutter/material.dart';

class GameRules extends StatelessWidget {
  final AssetImage background =
      const AssetImage('assets/homepage/homeScreen_background.png');
  final Color lightBrown = const Color(0xff8e6d58);
  final Color darkBrown = const Color(0x6634211e);

  const GameRules({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
          color: Colors.transparent,
          child: Stack(alignment: Alignment.center, children: [
            Image(
              image: background,
              fit: BoxFit.cover,
              alignment: Alignment.center,
              height: double.infinity,
              width: double.infinity,
            ),
            Container(
              height: screenHeight * 0.9,
              width: screenWidth * 0.55,
              alignment: Alignment.center,
              color: lightBrown,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(screenHeight * 0.04),
                    child: Container(
                      color: darkBrown,
                      height: screenHeight * 0.12,
                      width: double.infinity,
                      alignment: Alignment.center,
                      child: Text(
                        'Game Rules',
                        style: TextStyle(
                            color: lightBrown,
                            fontFamily: 'ol',
                            fontSize: screenHeight * 0.05),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(screenHeight * 0.04, 0,
                        screenHeight * 0.04, screenHeight * 0.04),
                    child: Container(
                      color: darkBrown,
                      width: double.infinity,
                    ),
                  )
                ],
              ),
            )
          ])),
    );
  }
}
