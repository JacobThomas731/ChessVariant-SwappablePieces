import 'package:chess_variant_swappable_pieces/board/board_controller.dart';
import 'package:chess_variant_swappable_pieces/board/chess_board.dart';
import 'package:flutter/cupertino.dart';

class Square {
  final String color;
  final String position;
  String piece; //piece coods or null
  bool occupied;
  AssetImage image;
  BoardController boardController;

  Square(this.color, this.position, this.piece, this.occupied, this.image,
      this.boardController);

  void setImage(String s) {
    image = AssetImage(s);
  }
}
