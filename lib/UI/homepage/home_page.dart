//start screen shows up here

import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chess_variant_swappable_pieces/board/chess_board.dart';
import 'auth_button.dart';
import 'menu_button.dart';

class HomePage extends StatefulWidget {
  late var db;

  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool challenges = false;
  bool firstRun = false;
  AssetImage background =
      const AssetImage('assets/homepage/homeScreen_background.png');
  Color menuButContainer = const Color(0x6634211e);
  Color lightBrown = const Color(0xff8e6d58);
  Color darkBrown = const Color(0x6634211e);
  String username = "abc";

  String challengeListener() {
    String? email = FirebaseAuth.instance.currentUser?.email;
    print(email);
    String challenger = '';
    var snaps =
        FirebaseFirestore.instance.collection('users').doc(email).snapshots();
    Map<String, dynamic>? data;
    snaps.listen((event) {
      data = event.data();
      if (data!['challenges'] != "") {
        challenger = data!['challenges'] as String;
      }
    });
    return challenger;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (firstRun == false) {
      //challengeListener();
      firstRun = true;
    }
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
              Positioned(
                  top: screenHeight * 0.05,
                  left: screenWidth * 0.65,
                  child: FutureBuilder(
                      future: (FirebaseFirestore.instance
                          .collection('users')
                          .doc(FirebaseAuth.instance.currentUser?.email)
                          .get() as dynamic),
                      builder: (context, snapshots) {
                        if (snapshots.hasData) {
                          dynamic data = snapshots.data;

                          if (data.data() != null) {
                            Map<String, dynamic> m =
                                (snapshots.data! as dynamic).data()
                                    as Map<String, dynamic>;
                            String challengesAccepted = m['challengeAccepted'];
                            if (challengesAccepted != '' &&
                                challengesAccepted != 'declined') {
                              FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(FirebaseAuth.instance.currentUser?.email)
                                  .update({'challengesAccepted': ''});
                              String gameId = challengesAccepted.split('-')[0];
                              String gameColor =
                                  challengesAccepted.split('-')[1];
                              String gameMode =
                                  challengesAccepted.split('-')[2];
                              String gameTime =
                                  challengesAccepted.split('-')[3];
                              String oppEmailId =
                                  challengesAccepted.split('-')[4];
                              gameColor =
                                  gameColor == 'black' ? 'white' : 'black';
                              Navigator.of(context)
                                  .pushNamed('boardControllerArgs', arguments: [
                                gameColor,
                                gameMode,
                                gameTime,
                                gameId,
                                oppEmailId
                              ]);
                            }
                            String challenges = m['challenges'];
                            print(challenges);
                            if (challenges.isNotEmpty) {
                              String challengerName = challenges.split('-')[0];
                              String gameMode = challenges.split('-')[1];
                              String gameColor = challenges.split('-')[2];
                              String gameTime = challenges.split('-')[3];
                              String gameId = challenges.split('-')[4];
                              String opponentEmailId = challenges.split('-')[5];

                              return Row(children: [
                                Container(
                                  height: screenHeight * 0.1,
                                  width: screenWidth * 0.140,
                                  color: darkBrown,
                                  padding: EdgeInsets.fromLTRB(
                                      screenWidth * 0.004, 0, 0, 0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      challengerName,
                                      style: TextStyle(
                                          color: lightBrown,
                                          fontFamily: 'ol',
                                          fontSize: screenHeight * 0.03),
                                    ),
                                    Text(
                                      '$gameMode | $gameColor | $gameTime min',
                                      style: TextStyle(
                                          color: lightBrown,
                                          fontFamily: 'ol',
                                          fontSize: screenHeight * 0.02),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(
                                    screenWidth * 0.004, 0, 0, 0),
                                child: Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        String? currentEmail = FirebaseAuth
                                              .instance.currentUser?.email;
                                          FirebaseFirestore.instance
                                              .collection('users')
                                              .doc(opponentEmailId)
                                              .update({
                                            'challengeAccepted':
                                                '$gameId-$gameColor-$gameMode-$gameTime-$currentEmail'
                                            //'$currentEmail-$gameColor-$gameMode-$gameTime-$gameTime'
                                            ,
                                            'challenges': ''
                                          });

                                          Navigator.of(context).pushNamed(
                                              'boardControllerArgs',
                                              arguments: [
                                                gameColor,
                                                gameMode,
                                                gameTime,
                                                gameId,
                                                opponentEmailId
                                              ]);
                                        },
                                      child: Container(
                                        height: screenHeight * 0.045,
                                        width: screenWidth * 0.075,
                                        color: darkBrown,
                                        child: Center(
                                          child: Text(
                                            'Accept',
                                            style: TextStyle(
                                                fontSize: screenHeight * 0.02,
                                                fontFamily: 'ol',
                                                color: lightBrown),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: screenHeight * 0.01,
                                      width: screenWidth * 0.075,
                                    ),
                                    Container(
                                      height: screenHeight * 0.045,
                                      width: screenWidth * 0.075,
                                      color: darkBrown,
                                      child: Center(
                                        child: Text(
                                          'Decline',
                                            style: TextStyle(
                                                fontSize: screenHeight * 0.02,
                                                fontFamily: 'ol',
                                                color: lightBrown),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ]);
                            } else {
                              return Container();
                            }
                          } else {
                            return Container();
                          }
                        } else {
                          return Container();
                        }
                      })),
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
                            MenuButton(
                                text: "Settings", pageRoute: '/playFriend'),
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
                                FutureBuilder(
                                    future: (FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(FirebaseAuth
                                            .instance.currentUser?.email)
                                        .get() as dynamic),
                                    builder: (context, snapshots) {
                                      if (snapshots.hasData) {
                                        dynamic data = snapshots.data;

                                        if (data.data() != null) {
                                          print('here');
                                          Map<String, dynamic> m =
                                              (snapshots.data! as dynamic)
                                                      .data()
                                                  as Map<String, dynamic>;
                                          username = m['username'];
                                        } else {
                                          username = "";
                                        }

                                        return Text('Hi, ' + username,
                                            style: TextStyle(
                                              color: const Color(0xff8e6d58),
                                              fontFamily: 'o',
                                              fontSize: screenWidth * 0.024,
                                            ));
                                      } else {
                                        return Text('Hi, ',
                                            style: TextStyle(
                                              color: const Color(0xff8e6d58),
                                              fontFamily: 'o',
                                              fontSize: screenWidth * 0.024,
                                            ));
                                      }
                                    }),
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
