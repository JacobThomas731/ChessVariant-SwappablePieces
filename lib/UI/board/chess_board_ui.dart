// chess board ui does here. Integrates with with chess_board.dart
import '../../board/square.dart';
import 'package:flutter/material.dart';
import 'package:chess_variant_swappable_pieces/UI/board/square_holder.dart';
import 'package:chess_variant_swappable_pieces/board/board_controller.dart';


class ChessBoardUi extends StatefulWidget {
  final String color;
  Map<String, Square> pieceSquareMap;
  BoardController boardController;
  late var refresh;

  static _ChessBoardUiState? of(BuildContext context) =>
      context.findAncestorStateOfType<_ChessBoardUiState>();

  ChessBoardUi(this.color, this.pieceSquareMap, this.boardController,
      {Key? key})
      : super(key: key);

  @override
  State<ChessBoardUi> createState() {
    var obj = _ChessBoardUiState();
    refresh = obj.refresh;
    return obj;
  }
}

class _ChessBoardUiState extends State<ChessBoardUi> {
  late SquareHolder squareHolder;

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
          child: Container(
            //color: Colors.purple,
            height: height * 0.9,
            width: width * 0.175,
            child: Column(
              children: [
                Container(
                  // 1
                  color: boardBackground,
                  height: height * 0.075,
                ),
                Container(
                  // 2
                  height: height * 0.02,
                ),
                Container(
                  // 3
                  height: height * 0.075,
                  color: boardBackground,
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
                  // 7
                  height: height * 0.05,
                  color: boardBackground,
                  alignment: Alignment.center,
                  child: Text(
                    'rating: 1600',
                    style: TextStyle(
                      color: const Color(0xff8e6d58),
                      fontFamily: 'ol',
                      fontSize: height * 0.02,
                    ),
                  ),
                ),
                Container(
                  // 8
                  height: height * 0.02,
                ),
                Container(
                    // 9
                    height: height * 0.085,
                    width: width * 0.175,
                    //color: boardBackground,
                    alignment: Alignment.center,
                    child: Text(
                      'Ashutosh Kumar',
                      style: TextStyle(
                        color: const Color(0xff8e6d58),
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
                  color: boardBackground,
                ),
                Container(
                  // 10
                  height: height * (0.215 - 0.205),
                  //color: boardBackground,
                ),
                Container(
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
                  // 8
                  height: height * 0.02,
                ),
                Container(
                  // 7
                  height: height * 0.05,
                  color: boardBackground,
                  alignment: Alignment.center,
                  child: Text(
                    'rating: 1830',
                    style: TextStyle(
                      color: const Color(0xff8e6d58),
                      fontFamily: 'ol',
                      fontSize: height * 0.020,
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
                ),
                Container(
                  // 2
                  height: height * 0.02,
                ),
                Container(
                  // 1
                  color: boardBackground,
                  height: height * 0.075,
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
            child: Container(
              color: Colors.purple,
              height: height * 0.9,
              width: width * 0.23,
            ))
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
