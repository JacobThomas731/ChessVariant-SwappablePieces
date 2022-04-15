import 'dart:ui';

import 'package:chess_variant_swappable_pieces/UI/board/chess_board_ui.dart';
import 'package:chess_variant_swappable_pieces/board/square.dart';
import 'package:flutter/src/painting/image_resolution.dart';

class BoardController {
  final String color;
  int swapsAvailable = 3;
  bool suggestionShowing = false;
  late ChessBoardUi chessBoardUi;
  String mode;
  Map<String, Square> pieceSquareMap = {};

  BoardController(this.color, this.mode) {
    pieceSquareMap = mapPieceSquare();

    chessBoardUi = ChessBoardUi(color, pieceSquareMap, this);

    // initialization stuff.
    // 1) Set up the pieceSquareMap Map
    // 2) Update the chess_board_ui with the new board setup
  }

  ChessBoardUi initialize() {
    return chessBoardUi;
  }

  void onPressed(Square square) {
    print('pressed');
    chessBoardUi.createState();
    if (suggestionShowing) {
      // if second click is on valid suggestion then play the move
    } else {
      // if click is on player's piece then show suggestions
    }
  }

  Map<String, Square> mapPieceSquare() {
    Map<String, Square> pieceSquareMap = {};
    String color;
    for (int i = 2; i < 6; i++) {
      for (int j = 0; j < 8; j++) {
        color = (i + j) % 2 == 0 ? 'black' : 'white';
        String ij = i.toString() + j.toString();
        pieceSquareMap[ij] = Square(color, ij, 'empty', false,
            const AssetImage('assets/images/empty.png'), this);
      }
    }
    pieceSquareMap['00'] = Square(
        'Black', '00', 'bR', true, const AssetImage('assets/pro/bR.png'), this);
    pieceSquareMap['01'] = Square(
        'White', '01', 'bN', true, const AssetImage('assets/pro/bN.png'), this);
    pieceSquareMap['02'] = Square(
        'Black', '02', 'bB', true, const AssetImage('assets/pro/bB.png'), this);
    pieceSquareMap['03'] = Square(
        'White', '03', 'bQ', true, const AssetImage('assets/pro/bQ.png'), this);
    pieceSquareMap['04'] = Square(
        'Black', '04', 'bK', true, const AssetImage('assets/pro/bK.png'), this);
    pieceSquareMap['05'] = Square(
        'White', '05', 'bB', true, const AssetImage('assets/pro/bB.png'), this);
    pieceSquareMap['06'] = Square(
        'Black', '06', 'bN', true, const AssetImage('assets/pro/bN.png'), this);
    pieceSquareMap['07'] = Square(
        'White', '07', 'bR', true, const AssetImage('assets/pro/bR.png'), this);
    pieceSquareMap['10'] = Square(
        'Black', '10', 'bP', true, const AssetImage('assets/pro/bP.png'), this);
    pieceSquareMap['11'] = Square(
        'White', '11', 'bP', true, const AssetImage('assets/pro/bP.png'), this);
    pieceSquareMap['12'] = Square(
        'Black', '12', 'bP', true, const AssetImage('assets/pro/bP.png'), this);
    pieceSquareMap['13'] = Square(
        'White', '13', 'bP', true, const AssetImage('assets/pro/bP.png'), this);
    pieceSquareMap['14'] = Square(
        'Black', '14', 'bP', true, const AssetImage('assets/pro/bP.png'), this);
    pieceSquareMap['15'] = Square(
        'White', '15', 'bP', true, const AssetImage('assets/pro/bP.png'), this);
    pieceSquareMap['16'] = Square(
        'Black', '16', 'bP', true, const AssetImage('assets/pro/bP.png'), this);
    pieceSquareMap['17'] = Square(
        'White', '17', 'bP', true, const AssetImage('assets/pro/bP.png'), this);
    pieceSquareMap['60'] = Square(
        'Black', '60', 'wP', true, const AssetImage('assets/pro/wP.png'), this);
    pieceSquareMap['61'] = Square(
        'White', '61', 'wP', true, const AssetImage('assets/pro/wP.png'), this);
    pieceSquareMap['62'] = Square(
        'Black', '62', 'wP', true, const AssetImage('assets/pro/wP.png'), this);
    pieceSquareMap['63'] = Square(
        'White', '63', 'wP', true, const AssetImage('assets/pro/wP.png'), this);
    pieceSquareMap['64'] = Square(
        'Black', '64', 'wP', true, const AssetImage('assets/pro/wP.png'), this);
    pieceSquareMap['65'] = Square(
        'White', '65', 'wP', true, const AssetImage('assets/pro/wP.png'), this);
    pieceSquareMap['66'] = Square(
        'Black', '66', 'wP', true, const AssetImage('assets/pro/wP.png'), this);
    pieceSquareMap['67'] = Square(
        'White', '67', 'wP', true, const AssetImage('assets/pro/wP.png'), this);
    pieceSquareMap['70'] = Square(
        'Black', '70', 'wR', true, const AssetImage('assets/pro/wR.png'), this);
    pieceSquareMap['71'] = Square(
        'White', '71', 'wN', true, const AssetImage('assets/pro/wN.png'), this);
    pieceSquareMap['72'] = Square(
        'Black', '72', 'wB', true, const AssetImage('assets/pro/wB.png'), this);
    pieceSquareMap['73'] = Square(
        'Black', '73', 'wQ', true, const AssetImage('assets/pro/wQ.png'), this);
    pieceSquareMap['74'] = Square(
        'White', '74', 'wK', true, const AssetImage('assets/pro/wK.png'), this);
    pieceSquareMap['75'] = Square(
        'Black', '75', 'wB', true, const AssetImage('assets/pro/wB.png'), this);
    pieceSquareMap['76'] = Square(
        'White', '76', 'wN', true, const AssetImage('assets/pro/wN.png'), this);
    pieceSquareMap['77'] = Square(
        'Black', '77', 'wR', true, const AssetImage('assets/pro/wR.png'), this);

    return pieceSquareMap;
  }
}
