// chess board ui does here. Integrates with with chess_board.dart
import 'package:chess_variant_swappable_pieces/timer/game_timer.dart';

import '../../board/square.dart';
import 'package:flutter/material.dart';
import 'package:chess_variant_swappable_pieces/UI/board/square_holder.dart';
import 'package:chess_variant_swappable_pieces/board/board_controller.dart';
import 'dart:async';

class ChessBoardUi extends StatefulWidget {
  final String color;
  Map<String, Square> pieceSquareMap;
  BoardController boardController;
  late Map<String, String> playerDetails;
  late var refresh;
  late var whiteTimer;
  late var blackTimer;
  late int time;

  ChessBoardUi(this.color, this.pieceSquareMap, this.boardController, this.time,
      {Key? key})
      : super(key: key);

  @override
  State<ChessBoardUi> createState() {
    var obj = _ChessBoardUiState();
    refresh = obj.refresh;
    obj.whiteTimer = GameTimer(time);
    obj.blackTimer = GameTimer(time);
    whiteTimer = obj.whiteTimer;
    blackTimer = obj.blackTimer;
    return obj;
  }
}

class _ChessBoardUiState extends State<ChessBoardUi> {
  late int time;
  late SquareHolder squareHolder;
  var whiteTimer;
  var blackTimer;
  var count = 3;

  @override
  Widget build(BuildContext context) {
    Map<String, Square> pieceSquareMap = widget.pieceSquareMap;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    Color boardBackground = const Color(0xff3f2c2d);
    Color boardColor = const Color(0xcc8e6d58);
    squareHolder = SquareHolder(widget.pieceSquareMap, widget.boardController);
    AssetImage background =
        const AssetImage('assets/homepage/homeScreen_background.png');
    return Scaffold(
      body: Stack(alignment: Alignment.center, children: [
        Image(
          image: background,
          fit: BoxFit.cover,
          alignment: Alignment.center,
          height: double.infinity,
          width: double.infinity,
        ),
        Positioned(
          // left panel
          top: height * 0.05,
          left: width * 0.075,
          child: SizedBox(
            //color: Colors.purple,
            height: height * 0.9,
            width: width * 0.175,
            child: Column(
              children: [
                Container(
                  color: boardBackground,
                  height: height * 0.075,
                  child: Row(
                    children: [
                      Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(
                                width * 0.01, height * 0.004, 0, 0),
                            child: Text(
                              'Time',
                              style: TextStyle(
                                fontSize: height * 0.023,
                                color: boardColor,
                                fontFamily: 'ol',
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(
                                width * 0.01, height * 0.004, 0, 0),
                            child: Text(
                              '(min:sec)',
                              style: TextStyle(
                                  fontFamily: 'ol',
                                  color: boardColor,
                                  fontSize: height * 0.02),
                            ),
                          )
                        ],
                      ),
                      Expanded(
                        child: Center(
                          child:
                              widget.color == 'white' ? blackTimer : whiteTimer,
                        ),
                      )
                    ],
                  ),

                  // child: widget.color == 'white' ? blackTimer : whiteTimer,
                ),
                Container(
                  // swapped performed

                  height: height * 0.02,
                ),
                Container(
                  // 3

                  height: height * 0.075,
                  color: boardBackground,
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(width * 0.01, 0, 0, 0),
                        child: Text(
                          'Swaps Performed:',
                          style: TextStyle(
                            fontSize: height * 0.027,
                            fontFamily: 'ol',
                            color: boardColor,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            '$count',
                            style: TextStyle(
                              fontSize: height * 0.042,
                              fontFamily: 'ol',
                              color: boardColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  // 4
                    height: height * 0.02),
                Container(
                  // 5
                  height: height * 0.02,
                  color: boardBackground,
                ),
                Container(
                  // 6
                  height: height * 0.07,
                ),
                Container(
                  //rating
                  // 7
                  height: height * 0.07,
                  //color: boardBackground,
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    'rating: 1600',
                    style: TextStyle(
                      color: boardBackground,
                      fontFamily: 'o',
                      fontSize: height * 0.028,
                    ),
                  ),
                ),
                Container(
                    // player name
                    // 9
                    height: height * 0.085,
                    width: width * 0.175,
                    //color: boardBackground,
                    alignment: Alignment.center,
                    child: Text(
                      'Ashutosh Kumar',
                      style: TextStyle(
                        color: boardColor,
                        fontFamily: 'ol',
                        fontSize: height * 0.045,
                      ),
                    )),
                Container(
                  // 10
                  height: height * (0.215 - 0.205),
                  //color: boardBackground,
                ),
                Container(
                  height: height * 0.01,
                  alignment: Alignment.center,
                  child: Container(
                    height: height * 0.005,
                    color: boardBackground,
                  ),
                ),
                Container(
                  // 10
                  height: height * (0.215 - 0.205),
                  //color: boardBackground,
                ),
                Container(
                    // player name
                    // 9
                    height: height * 0.085,
                    //color: boardBackground,
                    alignment: Alignment.center,
                    child: Text(
                      'Jacob Thomas',
                      style: TextStyle(
                        color: const Color(0xff8e6d58),
                        fontFamily: 'ol',
                        fontSize: height * 0.045,
                      ),
                    )),
                Container(
                  // rating
                  // 7
                  height: height * 0.07,
                  //color: boardBackground,
                  alignment: Alignment.topCenter,
                  child: Text(
                    'rating: 1830',
                    style: TextStyle(
                      color: boardBackground,
                      fontFamily: 'o',
                      fontSize: height * 0.027,
                    ),
                  ),
                ),
                Container(
                  // 6
                  height: height * 0.07,
                ),
                Container(
                  // 5
                  height: height * 0.02,
                  color: boardBackground,
                ),
                Container(
                  // 4
                    height: height * 0.02),
                Container(
                  // 3
                  height: height * 0.075,
                  color: boardBackground,
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(width * 0.01, 0, 0, 0),
                        child: Text(
                          'Swaps Performed:',
                          style: TextStyle(
                            fontSize: height * 0.027,
                            fontFamily: 'ol',
                            color: boardColor,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            '$count',
                            style: TextStyle(
                              fontSize: height * 0.042,
                              fontFamily: 'ol',
                              color: boardColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  // Swaps
                  // 2
                  height: height * 0.02,
                ),
                Container(
                  // Timer
                  // 1
                  color: boardBackground,
                  height: height * 0.075,
                  child: Row(
                    children: [
                      Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(
                                width * 0.01, height * 0.004, 0, 0),
                            child: Text(
                              'Time',
                              style: TextStyle(
                                fontSize: height * 0.023,
                                color: boardColor,
                                fontFamily: 'ol',
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(
                                width * 0.01, height * 0.004, 0, 0),
                            child: Text(
                              '(min:sec)',
                              style: TextStyle(
                                  fontFamily: 'ol',
                                  color: boardColor,
                                  fontSize: height * 0.02),
                            ),
                          )
                        ],
                      ),
                      Expanded(
                        child: Center(
                          child:
                              widget.color == 'white' ? whiteTimer : blackTimer,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          height: height * 0.9,
          width: height * 0.9,
          color: boardBackground,
          alignment: Alignment.center,
          child: Container(
              height: height * 0.75,
              width: height * 0.75,
              color: boardColor,
              child: squareHolder),
        ),
        Positioned(
            // right panel
            top: height * 0.05,
            left: width * 0.75,
            child: Column(children: [
              Container(
                color: boardBackground,
                height: height * 0.1,
                width: width * 0.23,
              ),
              Container(
                height: height * 0.05,
                width: width * 0.23,
              ),
              Container(
                  // chat
                  color: boardBackground,
                  height: height * 0.6,
                  width: width * 0.23,
                  child: Column(
                    children: [
                      Container(
                          height: height * 0.05,
                          child: Center(
                              child: Text(
                            'chat',
                            style: TextStyle(
                                fontSize: height * 0.028,
                                fontFamily: 'ol',
                                color: boardColor),
                          ))),
                      Container(
                        height: height * 0.45,
                        width: width * 0.18,
                        decoration: BoxDecoration(
                          color: boardColor,
                          //borderRadius: BorderRadius.circular(height * 0.005),
                        ),
                      ),
                      Container(
                        height: height * 0.025,
                      ),
                      Container(
                        height: height * 0.0524,
                        width: width * 0.18,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                                height: height * 0.05,
                                width: width * 0.15,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: boardColor, width: height * 0.001),
                                  borderRadius: BorderRadius.circular(20),
                                )),
                            Container(
                              height: height * 0.05,
                              width: height * 0.05,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle, color: boardColor),
                            )
                          ],
                        ),
                      )
                    ],
                  )),
              Container(
                height: height * 0.05,
                width: width * 0.23,
              ),
              Container(
                //color: Colors.purple,
                height: height * 0.1,
                width: width * 0.23,
                child: Row(children: [
                  Container(
                    height: height * 0.1,
                    width: width * 0.23 / 4,
                    color: boardBackground,
                    child: Center(
                      child: Text(
                        'Offer Draw',
                        style: TextStyle(
                            color: boardColor,
                            fontFamily: 'ol',
                            fontSize: height * 0.025),
                      ),
                    ),
                  ),
                  Container(
                    width: width * 0.2 / 8,
                  ),
                  Container(
                    height: height * 0.1,
                    width: width * 0.23 / 4,
                    color: boardBackground,
                    child: Center(
                      child: Text(
                        'Resign',
                        style: TextStyle(
                            color: boardColor,
                            fontFamily: 'ol',
                            fontSize: height * 0.025),
                      ),
                    ),
                  ),
                  Container(
                    width: width * 0.2 / 8,
                  ),
                  Container(
                    height: height * 0.1,
                    width: width * 0.23 / 4,
                    color: boardBackground,
                    child: Center(
                      child: Text(
                        'Take Back',
                        style: TextStyle(
                            color: boardColor,
                            fontFamily: 'ol',
                            fontSize: height * 0.025),
                      ),
                    ),
                  ),
                ]),
              ),
            ]))
      ]),
    );
  }

  void refresh() {
    squareHolder = SquareHolder(widget.pieceSquareMap, widget.boardController);
    setState(() {
      squareHolder;
    });
  }

  void refreshSquareUI() {
    setState(() {});
  }

  void refreshTimers() {}
}
