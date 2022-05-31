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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
      ),
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
                      //height: double.infinity,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(
                            screenHeight * 0.02,
                            screenHeight * 0.01,
                            screenHeight * 0.01,
                            screenHeight * 0.01),
                        child: Text(
                          '1. The game has 2 modes as of now, the normal mode and the swappable mode.',
                          style: TextStyle(
                              fontSize: screenHeight * 0.04,
                              color: lightBrown,
                              fontFamily: 'ol'),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(screenHeight * 0.04, 0,
                        screenHeight * 0.04, screenHeight * 0.04),
                    child: Container(
                      color: darkBrown,
                      width: double.infinity,
                      //height: double.infinity,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(
                            screenHeight * 0.03,
                            screenHeight * 0.01,
                            screenHeight * 0.01,
                            screenHeight * 0.01),
                        child: Text(
                          '2. In swappable mode, you can swap your minor pieces, ie, rook, bishop and knight with each other.',
                          style: TextStyle(
                              fontSize: screenHeight * 0.04,
                              color: lightBrown,
                              fontFamily: 'ol'),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(screenHeight * 0.04, 0,
                        screenHeight * 0.04, screenHeight * 0.04),
                    child: Container(
                      color: darkBrown,
                      width: double.infinity,
                      //height: double.infinity,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(
                            screenHeight * 0.03,
                            screenHeight * 0.01,
                            screenHeight * 0.01,
                            screenHeight * 0.01),
                        child: Text(
                          '3. This operation can be done upto 3 times by each player.',
                          style: TextStyle(
                              fontSize: screenHeight * 0.04,
                              color: lightBrown,
                              fontFamily: 'ol'),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ])),
    );
  }
}
