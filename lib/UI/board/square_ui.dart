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
    return GestureDetector(
      onTap: () {
        bool changed = widget.boardController.onPressed(widget.square);
        if (changed) {
          //setState(() {});
          widget.refresh();
        }
      },
      child: Container(
        height: (height * 0.75) / 8,
        width: (height * 0.75) / 8,
        color: widget.color,
        child: Image(image: widget.square.image),
      ),
    );
  }
}
