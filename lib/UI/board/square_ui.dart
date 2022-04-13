import 'package:chess_variant_swappable_pieces/board/board_controller.dart';
import 'package:chess_variant_swappable_pieces/board/square.dart';
import 'package:flutter/material.dart';

class SquareUI extends StatefulWidget {
  final Color color;
  final String position;
  final BoardController boardController;

  SquareUI(this.color, this.position, this.boardController);

  @override
  State<SquareUI> createState() => _SquareState();
}

class _SquareState extends State<SquareUI> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        widget.boardController.onPressed(widget.position);
      },
      child: Container(
        height: (height * 0.75) / 8,
        width: (height * 0.75) / 8,
        color: widget.color,
      ),
    );
  }
}
