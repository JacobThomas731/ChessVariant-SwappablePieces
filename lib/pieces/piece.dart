import 'package:flutter/material.dart';

abstract class Piece {
  late String pieceName;
  late String pieceColor;
  late String currentSquare;
  late AssetImage image;

  Piece(this.pieceName, this.pieceColor, this.currentSquare, this.image);

  bool isPinned(); // check if piece is pinned
  List<String> getMoves(); // returns a list of possible valid moves
  void setMove(String move); // makes the move

}
