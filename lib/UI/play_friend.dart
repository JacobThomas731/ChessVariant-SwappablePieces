import 'dart:io';

import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PlayFriend extends StatefulWidget {
  PlayFriend({Key? key}) : super(key: key);

  @override
  State<PlayFriend> createState() => _PlayFriendState();
}

class _PlayFriendState extends State<PlayFriend> {
  //Map<String, dynamic> map = {};

  Future getDetails() async {
    var currentUserDetail = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.email)
        .get();
    //print(currentUserDetail.data());
    //map = currentUserDetail.data()!;
    return currentUserDetail.data();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery
        .of(context)
        .size
        .height;
    double width = MediaQuery
        .of(context)
        .size
        .width;
    Color boardBackground = const Color(0xff3f2c2d);
    Color boardColor = const Color(0xcc8e6d58);
    AssetImage background =
    const AssetImage('assets/homepage/homeScreen_background.png');


    return FutureBuilder(
        future: getDetails(),
        builder: (context, snapshots) {
          if (snapshots.hasData) {
            //print(snapshots.data);
            List friendList = [];
            Map<String, dynamic> m = snapshots.data as Map<String, dynamic>;
            print(m);
            m['friendList'].forEach((k, v) => friendList.add([k, v]));
            print(friendList);

            return Scaffold(
              body: Stack(alignment: Alignment.center, children: [
                Image(
                  image: background,
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                  height: double.infinity,
                  width: double.infinity,
                ),
                Center(
                  child: Container(
                    height: height * 0.8,
                    width: width * 0.275,
                    color: boardBackground,
                    child: Column(children: [
                      Container(
                        height: height * 0.1,
                        child: Center(
                          child: Text(
                            'Friend List',
                            style: TextStyle(
                                fontFamily: 'ol',
                                fontSize: height * 0.03,
                                color: boardColor),
                          ),
                        ),
                      ),
                      Container(
                        height: height * 0.7,
                        child: SingleChildScrollView(
                          child: Column(children: [
                            for (int i = 0; i < friendList.length; i++)
                              GestureDetector(
                                onTap: () async {
                                  String? currentEmail =
                                      FirebaseAuth.instance.currentUser?.email;
                                  String gameMode = 'swappable';
                                  String gameColor = 'black';
                                  String time = '500';
                                  String friendEmail = friendList[i][0];
                                  String gameId =
                                      currentEmail! + '_' + friendEmail;
                                  await FirebaseFirestore.instance
                                      .collection('games')
                                      .doc(gameId)
                                      .set({});
                                  await FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(friendEmail)
                                      .update({
                                    'challenges': m['username'] +
                                        '-$gameMode' +
                                        '-$gameColor' +
                                        '-$time' +
                                        '-$gameId' +
                                        '-$currentEmail'
                                  });
                                },
                                onPanStart: (e) {
                                  setState(() {
                                    color:
                                    Colors.red;
                                  });
                                },
                                onPanEnd: (e) {
                                  setState(() {
                                    color:
                                    boardColor;
                                  });
                                },
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(
                                      width * 0.01,
                                      height * 0.01,
                                      width * 0.01,
                                      height * 0.01),
                                  child: Container(
                                    height: height * 0.09,
                                    width: width * 0.275,
                                    decoration: BoxDecoration(
                                      //borderRadius: BorderRadius.circular(height * 0.005),
                                      color: boardColor,
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          height: height * 0.07,
                                          width: height * 0.07,
                                          margin: EdgeInsets.fromLTRB(
                                              height * 0.01,
                                              0,
                                              height * 0.05,
                                              0),
                                          color: Colors.brown,
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                friendList[i][0],
                                                style: TextStyle(
                                                  fontSize: height * 0.030,
                                                  fontFamily: 'ol',
                                                  color: boardBackground,
                                                ),
                                              ),
                                              Text(
                                                friendList[i][1] + ' | online',
                                                style: TextStyle(
                                                  fontSize: height * 0.02,
                                                  fontFamily: 'ol',
                                                  color: boardBackground,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              )
                          ]),
                        ),
                      ),
                    ]),
                  ),
                ),
              ]),
            );
          }
          else {
            print('nope');
            return Container();
          }
        });
  }
}
