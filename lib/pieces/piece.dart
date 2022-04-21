import 'package:flutter/material.dart';

abstract class Piece {
  String pieceName;
  String pieceColor;
  AssetImage image;

  Piece(this.pieceName, this.pieceColor, this.image) {}

  List<String> getMoves(); // returns a list of possible valid moves

}
