import 'package:chess_variant_swappable_pieces/board/board_controller.dart';
import 'package:chess_variant_swappable_pieces/pieces/piece.dart';
import 'package:flutter/cupertino.dart';

class Pawn extends Piece {
  bool pieceMoved = false;

  Pawn(String pieceName, String pieceColor, String currentSquare,
      AssetImage image)
      : super(pieceName, pieceColor, currentSquare, image);

  @override
  List<String> getMoves() {
    List<String> l;
    if (pieceMoved) {
      if (pieceColor == 'White') {
        if (currentSquare.endsWith('7')) {
          //promotion to new piece
        } else {
          //increase
          int increased = int.parse(currentSquare.substring(1)) + 1;
          String nextSquare =
              currentSquare.substring(0, 1) + increased.toString();
          if (BoardController.getSquareOccupation(nextSquare)) {
            l.add(nextSquare);
          }
        }
      } else {}
    }
    return l;
  }

  @override
  bool isPinned() {
    // TODO: implement isPinned
    throw UnimplementedError();
  }

  @override
  void setMove(String move) {
    // TODO: implement setMove
  }
}
