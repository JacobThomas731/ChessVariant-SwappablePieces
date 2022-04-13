import 'package:flutter/material.dart';

abstract class Piece {
  late String pieceName;
  late String pieceColor;
  late AssetImage image;

  Piece(this.pieceName, this.pieceColor, this.image);

  List<String> getMoves(); // returns a list of possible valid moves

}
