import 'package:chess_variant_swappable_pieces/board/board_controller.dart';
import 'package:chess_variant_swappable_pieces/board/chess_board.dart';
import 'package:flutter/cupertino.dart';

class Square {
  final String color;
  final String position;
  String piece; //piece name or empty
  bool occupied;
  AssetImage image;
  final BoardController boardController;
  String suggestionMode = 'null'; // movable, swappable, capturable
  String pieceSide = 'empty'; // black player or white player or empty

  Square(this.color, this.position, this.piece, this.occupied, this.image,
      this.pieceSide, this.boardController);

  void setPiece(String piece) {
    this.piece = piece;
    if (piece == 'bR') {
      image = const AssetImage('assets/pro/bR.png');
      pieceSide = 'black';
    }
    if (piece == 'bN') {
      image = const AssetImage('assets/pro/bN.png');
      pieceSide = 'black';
    }
    if (piece == 'bB') {
      image = const AssetImage('assets/pro/bB.png');
      pieceSide = 'black';
    }
    if (piece == 'bQ') {
      image = const AssetImage('assets/pro/bQ.png');
      pieceSide = 'black';
    }
    if (piece == 'bK') {
      image = const AssetImage('assets/pro/bK.png');
      pieceSide = 'black';
    }
    if (piece == 'bP') {
      image = const AssetImage('assets/pro/bP.png');
      pieceSide = 'black';
    }
    if (piece == 'bK') {
      image = const AssetImage('assets/pro/bK.png');
      pieceSide = 'black';
    }

    if (piece == 'wR') {
      image = const AssetImage('assets/pro/wR.png');
      pieceSide = 'white';
    }
    if (piece == 'wN') {
      image = const AssetImage('assets/pro/wN.png');
      pieceSide = 'white';
    }
    if (piece == 'wB') {
      image = const AssetImage('assets/pro/wB.png');
      pieceSide = 'white';
    }
    if (piece == 'wQ') {
      image = const AssetImage('assets/pro/wQ.png');
      pieceSide = 'white';
    }
    if (piece == 'wK') {
      image = const AssetImage('assets/pro/wK.png');
      pieceSide = 'white';
    }
    if (piece == 'wP') {
      image = const AssetImage('assets/pro/wP.png');
      pieceSide = 'white';
    }
    if (piece == 'empty') {
      image = const AssetImage('assets/images/empty.png');
      pieceSide = 'empty';
    }
  }
}
