import 'dart:ffi';

import 'package:chess_variant_swappable_pieces/board/board_controller.dart';
import 'package:chess_variant_swappable_pieces/pieces/piece.dart';
import 'package:flutter/cupertino.dart';

class Pawn extends Piece {
  bool pieceMoved = false;

  Pawn(String pieceName, String pieceColor, AssetImage image)
      : super(pieceName, pieceColor, image);

  @override
  List<String> getMoves() {
    List<String> l = [];
    return l;
  }
}
