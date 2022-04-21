import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:chess_variant_swappable_pieces/board/board_controller.dart';
import 'package:chess_variant_swappable_pieces/board/square.dart';
import 'package:flutter/material.dart';

class SquareUI extends StatefulWidget {
  final Color color;
  final String position;
  Square square;
  final BoardController boardController;
  var refresh;

  SquareUI(this.color, this.position, this.square, this.boardController,
      this.refresh);

  @override
  State<SquareUI> createState() => _SquareState();
}

class _SquareState extends State<SquareUI> {
  //AssetImage image = AssetImage('assets/pro/wR.png');

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    // double width = MediaQuery.of(context).size.width;

    Widget movable = Container(
      height: (height * 0.75) / 32,
      width: (height * 0.75) / 32,
      decoration:
          const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
    );

    Widget capturable = Container(
      height: (height * 0.75) / 8,
      width: (height * 0.75) / 8,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.red[800]!, width: height * 0.006)),
    );
    // if(widget.boardController.pieceSquareMap['00']?.piece == 'bQ'){
    //   widget.refresh();
    // }
    Widget suggestionMode = Container();
    if (widget.square.suggestionMode == 'movable') {
      suggestionMode = movable;
    } else if (widget.square.suggestionMode == 'capturable') {
      suggestionMode = capturable;
    }
    return GestureDetector(
      onTap: () {
        bool changed = widget.boardController.onPressed(widget.square);
        widget.refresh();
        if (changed) {
          //setState(() {});

        }
      },
      child: Container(
        height: (height * 0.75) / 8,
        width: (height * 0.75) / 8,
        color: widget.color,
        child: Stack(children: [
          Center(
            child: Padding(
                padding: EdgeInsets.all(height * 0.008),
                child: Image(image: widget.square.image)),
          ),
          Center(child: suggestionMode)
        ]),
      ),
    );
  }
}
