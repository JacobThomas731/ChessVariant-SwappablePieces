// chess board ui does here. Integrates with with chess_board.dart
import 'package:chess_variant_swappable_pieces/UI/board/square_holder.dart';
import 'package:chess_variant_swappable_pieces/board/board_controller.dart';
import 'package:flutter/material.dart';

class ChessBoardUi extends StatefulWidget {
  final String color;
  late BoardController boardController = BoardController(color);

  ChessBoardUi(this.color, {Key? key}) : super(key: key);

  @override
  State<ChessBoardUi> createState() => _ChessBoardUiState();
}

class _ChessBoardUiState extends State<ChessBoardUi> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    Color boardBackground = const Color(0xff34211e);
    Color boardColor = const Color(0xcc8e6d58);
    AssetImage background =
        const AssetImage('assets/homepage/homeScreen_background.png');
    return Stack(alignment: Alignment.center, children: [
      Image(
        image: background,
        fit: BoxFit.cover,
        alignment: Alignment.center,
        height: double.infinity,
        width: double.infinity,
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
          child: SquareHolder(widget.boardController),
        ),
      ),
    ]);
  }
}
