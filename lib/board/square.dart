import 'package:chess_variant_swappable_pieces/board/board_controller.dart';
import 'package:chess_variant_swappable_pieces/board/chess_board.dart';
import 'package:flutter/cupertino.dart';

class Square {
  final String color;
  final String position;
  String piece; //piece name or null
  bool occupied;
  AssetImage image;
  final BoardController boardController;
  String suggestionMode = 'null'; // movable, swappable, capturable

  Square(this.color, this.position, this.piece, this.occupied, this.image,
      this.boardController);

  void setPiece(String piece) {
    this.piece = piece;
    if (piece == 'bR') {
      image = const AssetImage('assets/pro/bR.png');
    }
    if (piece == 'bN') {
      image = const AssetImage('assets/pro/bN.png');
    }
    if (piece == 'bB') {
      image = const AssetImage('assets/pro/bB.png');
    }
    if (piece == 'bQ') {
      image = const AssetImage('assets/pro/bQ.png');
    }
    if (piece == 'bK') {
      image = const AssetImage('assets/pro/bK.png');
    }
    if (piece == 'bP') {
      image = const AssetImage('assets/pro/bP.png');
    }
    if (piece == 'bK') {
      image = const AssetImage('assets/pro/bK.png');
    }

    if (piece == 'wR') {
      image = const AssetImage('assets/pro/wR.png');
    }
    if (piece == 'wN') {
      image = const AssetImage('assets/pro/wN.png');
    }
    if (piece == 'wB') {
      image = const AssetImage('assets/pro/wB.png');
    }
    if (piece == 'wQ') {
      image = const AssetImage('assets/pro/wQ.png');
    }
    if (piece == 'wK') {
      image = const AssetImage('assets/pro/wK.png');
    }
    if (piece == 'wP') {
      image = const AssetImage('assets/pro/wP.png');
    }
    if (piece == 'empty') {
      image = const AssetImage('assets/images/empty.png');
    }
  }
}
